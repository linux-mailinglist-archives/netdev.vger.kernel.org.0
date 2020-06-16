Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747601FB5EE
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgFPPTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729177AbgFPPS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:18:59 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638A5C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:18:59 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q19so21928844eja.7
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mCkOJwzBNQ/VPMuFm+rDhNT8WeNpDSPTUtIsQg/BHiI=;
        b=u5uL0qfz6FtKzKlMGOoJgIbLc/ZPbxodziUhBy46UmHYtjcCFCN/Q0ORlHdQ0UsnEc
         y56u/papPNrl9lbqGlnzb9g6Z4oQ6rvI8TNZor2VKQTfTX4RvLer1yNq6PgTOEY2tgvh
         3xG5Z06nbnzPsAlFo1yQWIlHsynQSae3BPsGJi3ZAqx7OlSonFzNvSNFIvrZRI9MFirq
         FmXMKvkSabtNN0dZstklPtOPjKNZ07kKAk/idu3UhIJRvz33tqNC/M0OBOyDsnxrEl1Y
         js6WT2qetmnyBPFaJLH0hZQJzp0b2UnxXkPXK3jvm1xgHTHXQaMEPBjbWC1wWxmfMff9
         yGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mCkOJwzBNQ/VPMuFm+rDhNT8WeNpDSPTUtIsQg/BHiI=;
        b=hmCQw4kdXEVlkfeuj8kwbUcPniADojKP0FJ0OLC4C0iURbV0xx/yHPGwnN2XPRXxNZ
         Wu5/p35K9aVRJNkDqDl4Hh+00WTnOhZ0n5Ky1Bpy1guluPRAsxYIASrapyEbuoPe3tIi
         F02lSVPHk4/VI9b9HTNULNZRzjev6vQrY6Gy7n8x+TtlbSr7/qmnoV+xxA2xj/Z6wtNr
         pLhrWaOyHfg4fw4bj1GeJ9Y/ISW/3pEnTGdr8DcqRdsyPmDQUuAZYhmG0gwuXI5OPlc/
         0R34WDcRnqNKufReEiezI25YbiccSxYcIBenfd7C/KU7olXLwKUVotJpKxtvQQV+rnTk
         4vMQ==
X-Gm-Message-State: AOAM5327QTKJ/3KfCAC86EVSW0cXxZYBzOE0BYYBL9jT34wXBSBX3EoN
        Sqm5CFQQQ2oN4lczS/ud/oafPw==
X-Google-Smtp-Source: ABdhPJw67sa5PWc8KBuHlwTeUyw9rWGN7u+Mqkl1KZ1SbZ0c0JI05j9hg37mtlspROJB3qDazYt/pQ==
X-Received: by 2002:a17:906:5410:: with SMTP id q16mr3381448ejo.103.1592320737997;
        Tue, 16 Jun 2020 08:18:57 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id p6sm11330395ejb.71.2020.06.16.08.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 08:18:57 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] add MP_PRIO, MP_FAIL and MP_FASTCLOSE
 suboptions handling
To:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
References: <cover.1592289629.git.geliangtang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <04ae76d9-231a-de8e-ad33-1e4e80bb314c@tessares.net>
Date:   Tue, 16 Jun 2020 17:18:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <cover.1592289629.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang

On 16/06/2020 08:47, Geliang Tang wrote:
> Add handling for sending and receiving the MP_PRIO, MP_FAIL, and
> MP_FASTCLOSE suboptions.

Thank you for the patches!

Unfortunately, I don't think it would be wise to accept them now: for 
the moment, these suboptions are ignored at the reception. If we accept 
them and change some variables like you did, we would need to make sure 
the kernel is still acting correctly. In other words, we would need tests:
* For MP_PRIO, there are still quite some works to do regarding the 
scheduling of the packets between the different MPTCP subflows to do 
before supporting this.
* For MP_FAIL, we should forward the info to the path manager.
* For MP_FASTCLOSE, we should close connections and ACK this.

Also, net-next is closed for the moment: 
http://vger.kernel.org/~davem/net-next.html

I would suggest you to discuss about that on MPTCP mailing list. We also 
have meetings every Thursday. New devs are always welcome to contribute 
to new features and bug-fixes!

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
