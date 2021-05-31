Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A973953A9
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 03:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhEaBZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 21:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbhEaBZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 21:25:50 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19004C061574
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 18:24:10 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 69-20020a9d0a4b0000b02902ed42f141e1so9656676otg.2
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 18:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FUMtbhS9Vm9ltvUN4m/UF7B3F2/o1UvNXJ5gC7QflMI=;
        b=ZKNIcZ9WDRe681ZYTh4P8k8P2CcMb0DejTq5a1zRewVkqz2fCcsCLO20Wwh1VBM6bx
         sf80JgNrSoT4mQy4EevSmQktpvnAwFMdpt7p6S5THuFREdlFERBUfThyhE508UeghyN1
         tqgwSkr3XRk4XUoO3q9RDCCV00U/Fzwra+PVzkJfTLoIivxBRwVp6mYFp9x69wswP+Qh
         RiqhbRTVUxDRdx9zWIeaBG9BCx5spI82UtQjLFSEDxwiqhbXCMNw/Tcf+6NqVXz3+B62
         34LK6Ie/axN754d6xXO7SrpkinArKn3jVTdnCbcd53fJvdMqypZHMRuc/Bz8qqDZ0hwe
         tD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FUMtbhS9Vm9ltvUN4m/UF7B3F2/o1UvNXJ5gC7QflMI=;
        b=hSFk2qQczrfF9LLmsD/3hu5KBGNaEL06BL9Bdlj+Y30CCmfoFkvgdQEfOLG4ggrUJV
         hH6fcVHmsYII95PwQ5iWB//Cqbgsn2p81jvuw5U4Sc76pdaU5X6PKTwKgzc6ALU9qfXw
         uuUcnD6/vjHsrxrYDsEOMWPHhLalUjR/CIipiAgvYbeCVkPPcAf5jBEqxcBkW3JvZ6Hw
         NgA+a2kfuGUh/ykD6K5wMjbxf4cMF5v0TCPCerOYjslUFoFm9br2dKv6SOcjG3hQsEHM
         Byc6OqnoewJpCbfu0+AwdBo6VtGZm5Oi2oHhecayiXqgljm+AcAIjgF0WdE110Kguyt1
         YtmA==
X-Gm-Message-State: AOAM530BZp/B1M7UNkxTxDdu05QJXz/VHUMXi6bWRiii2FQawGjIVqgn
        lArPv0Ym+PVFQIUzhvL96OQ=
X-Google-Smtp-Source: ABdhPJz8Wo1y5E+/EIR2e068UKeEOf1hIeY9Gl2NqDdF9fq7K7jsUSIpWCiGctTH1VP2dPVKYy3O3Q==
X-Received: by 2002:a05:6830:1184:: with SMTP id u4mr15586100otq.324.1622424249483;
        Sun, 30 May 2021 18:24:09 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id a71sm2534476oib.20.2021.05.30.18.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 May 2021 18:24:08 -0700 (PDT)
Subject: Re: [PATCH net-next v4 0/5] Support for the IOAM Pre-allocated Trace
 with IPv6
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tom@herbertland.com
References: <20210527151652.16074-1-justin.iurman@uliege.be>
 <85a22702-da46-30c2-46c9-66d293d510ff@gmail.com>
 <1049853171.33683948.1622305441066.JavaMail.zimbra@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cc16923b-74bc-7681-92c7-19e84a44c0e1@gmail.com>
Date:   Sun, 30 May 2021 19:24:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1049853171.33683948.1622305441066.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/21 10:24 AM, Justin Iurman wrote:
> Actually, February 2021 is the last update. The main draft (draft-ietf-ippm-ioam-data) has already come a long way (version 12) and has already been Submitted to IESG for Publication. I don't think it would hurt

when the expected decision on publication?

 that much to have it in the kernel as we're talking about a stable
draft (the other one is just a wrapper to define the encapsulation of
IOAM with IPv6) and something useful. And, if you think about Segment
Routing for IPv6, it was merged in the kernel when it was still a draft.

The harm is if there are any changes to the uapi.
