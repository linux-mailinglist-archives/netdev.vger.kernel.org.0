Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E30E4372A3
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 09:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhJVHY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 03:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhJVHY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 03:24:26 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3C3C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 00:22:09 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r4so3243667edi.5
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 00:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RbxGn8rvlnJonem+I51mG2O5Nb4QJa213IRNxjEHDzc=;
        b=idoDBpxK3g/Y8jwFbbjLfCUbrdl3cfF4/Xt4dK/+g6y/v8Pm7vzJ1gjVy4+sGAGD3W
         RbMqC4MPYDKCXbTnyrEn1wR9qgqxcVHXVphUXHK2XhECVKm85EcVVSVIWrzH+q29ZpkL
         fubwFEEpamJCjVIDBqXmZfdp/1TB9e5+ZqIx9UzW4CP1Ce6U6+4IfUldbLP6kxxvMcH5
         HMM/pDb2wn02KOWQK/ryIPnM2E/DPc0qfJr0fT74HWwJH1zn53Mvi8dGbzVeV40ko7Zd
         VoYuDuzW0cOzCeV5QTkWYCcvT5i9pB89UkAPkBs1aG1zNfB79fok/K9mrllQIzIqeddA
         8HoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RbxGn8rvlnJonem+I51mG2O5Nb4QJa213IRNxjEHDzc=;
        b=GaJKdLCJQNYrP4avxa5cWSrWBrGXXYBplEitDQsZ5gW9XBGVwbikWsbWdgJhOWg0gJ
         PeU49R8QESee6OLIaw2CSCf4AJJ6EHUgwsP2bply/U2BWb9oa/ld9d9/NYTMtKJPHhoN
         GgOp4kn8O/ESaF+9EJIheVlFELejWCMXhq18YrARyIUn2z27F2hZyRWEB5Wny1Jg1Hn4
         vFHZNkZde7v2mbonrdrGoH32tpVaC6NY436uVnnZfyhFHB9I94lnnkzv6MsfBGNLb7NV
         Tnr+i2zkvQgVegwJm481C/FRgrxbhfxJdEARv85Zwjn6J0lZ+jLQB7VsJ5eKpR1a9hqo
         NsVg==
X-Gm-Message-State: AOAM530EE2mL9biMvjeaZFTWbrg5xPM8zkjDLZZ6fOoXBovQDL+yogbE
        izEjqI7SbZXUbAfjx6NtNlqa1mt/2Ik=
X-Google-Smtp-Source: ABdhPJwyL+UItn/YEDXHshQ+g0TJKkj60vQsd6GMIX84mKyStSO7wVN78j7AE77Ap/h6l+ACVM7I5A==
X-Received: by 2002:a05:6402:4308:: with SMTP id m8mr14709732edc.188.1634887327088;
        Fri, 22 Oct 2021 00:22:07 -0700 (PDT)
Received: from [192.168.178.46] ([213.211.156.121])
        by smtp.gmail.com with ESMTPSA id j21sm3824944edr.64.2021.10.22.00.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 00:22:06 -0700 (PDT)
Message-ID: <7323f833-08e7-5b90-6175-c88696b73e63@tessares.net>
Date:   Fri, 22 Oct 2021 09:22:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH net-next v1] net: mptcp, Fast Open Mechanism
Content-Language: en-GB
To:     Dmytro Shytyi <dmytro@shytyi.net>,
        mathewjmartineau <mathew.j.martineau@linux.intel.com>
Cc:     Davem <davem@davemloft.net>, Kuba <kuba@kernel.org>,
        mptcp <mptcp@lists.linux.dev>, netdev <netdev@vger.kernel.org>
References: <17ca66cd439.10a0a3ce11621928.1543611905599720914@shytyi.net>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <17ca66cd439.10a0a3ce11621928.1543611905599720914@shytyi.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmytro,

On 22/10/2021 07:15, Dmytro Shytyi wrote:
> This set of patches will bring "Fast Open" Option support to MPTCP.
> The aim of Fast Open Mechanism is to eliminate one round trip 
> time from a TCP conversation by allowing data to be included as 
> part of the SYN segment that initiates the connection. 
> 
> IETF RFC 8684: Appendix B.  TCP Fast Open and MPTCP.
> 
> [PATCH v1] includes "client" partial support for :
> 1. send request for cookie;
> 2. send syn+data+cookie.

Thank you for working on that and sharing this patch with us!

It looks like some modifications are going to be needed, e.g. after a
very quick look, it seems all tabs have been converted to spaces causing
the patch not being applicable on git[1]: did you not use git
format-patch to generate it? Also, some issues will be reported by
checkpatch.pl, the "reversed XMas tree" order is not respected for
variables declaration, etc.

Do you mind if we continue the discussion on MPTCP mailing list only? In
other words, without Netdev mailing list and Net maintainers, not to
bother everybody for MPTCP specific stuff?

Our usual way of working for MPTCP patches is to have the code review on
MPTCP ML only, then apply accepted patches in our tree first and once a
validation has been done, send patches later to Netdev ML for inclusion
in the -net or net-next tree.

Cheers,
Matt

[1]
https://patchew.org/logs/17ca66cd439.10a0a3ce11621928.1543611905599720914@shytyi.net/git/
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
