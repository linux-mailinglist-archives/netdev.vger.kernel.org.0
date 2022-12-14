Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66ED264CEC5
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 18:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiLNRRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 12:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239193AbiLNRQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 12:16:47 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87435F1C
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 09:16:39 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h10so447601wrx.3
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 09:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cer/PS+So0alvCS30HT2Oh5V3K7NvUmDhiX3byrygKk=;
        b=7IFMj9BPAx1VL3ASQhkU0pm5fS4vHUcccZICHcTeDM4cu8R1uARADgaA83h/A2UQps
         Vb/5MQ6aDgzwbqmdrpgL8fyZ3btZYjOaxm7LcKh4y0t0089b5mxO2UNAeYuyJIIkAnWU
         Mp67RbN3lnQ/Ccg/IaA1sHq0IGKJbiYu8wtPJRs9R278kWNdprILZFIZO/mZkmG35K8x
         lXHqmixziGKJjrSIPR+TjJCWWjATa/OHqkdfni2+weBtQBSqbSWPkZYrZhhPmafJCCvt
         1V0V2PiXvF6ye4pvJ/MHymezQrkIM6hw/MBkXY7ZU5UAaiqqLahWDXMyVoJEN2mk3IrS
         pUag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cer/PS+So0alvCS30HT2Oh5V3K7NvUmDhiX3byrygKk=;
        b=t/99bw8DOYNixQKhxKVTdSsV600UE/hJPFnwvAVGGRSRnuL7tfNUigCO0D3jqdVhhv
         XKCNcQVB53gz8cQzyNajOtMxHfPmiBL2P8KW4S4XMZfket6/axgcw6bvZvsweMWumS1Q
         b4kXPKncETcmpU8WEg6WvpDrn0J1qe/NjBAD6t2dWtOizZg4wEfVTJHqVmbcyXYQ+mSZ
         o3qx2tknKwkfuVBNCOyLMziwcNNX/QgfcVXo330jXyIlAGJ1nDwf3MO6a72N+wWpSH/S
         LrIgYX083NxnC5jhN5r7/pOFDv98SyL7PlHJ/vn3PpN2ivAi2ev/1voTjn8wSebCpNN8
         zw2Q==
X-Gm-Message-State: ANoB5plhFPwQfCjuEwLkVgAYUmp5B4CGUY4c0t5HvelHEglGKsCaff+a
        n5FVDOLX37LeRNL/hi8Z8vgBX+FB+BUGU71P
X-Google-Smtp-Source: AA0mqf5VNtUVA4VWhGCW880Be/rf4YhL7Sr6MQUNSh7+yImfpkG4KogHNMjZ9pO+xWAaDS+rjdjzrg==
X-Received: by 2002:a5d:678b:0:b0:242:5d76:f571 with SMTP id v11-20020a5d678b000000b002425d76f571mr16229034wru.2.1671038198023;
        Wed, 14 Dec 2022 09:16:38 -0800 (PST)
Received: from ?IPV6:2a02:578:8593:1200:22af:65bc:a1dd:1562? ([2a02:578:8593:1200:22af:65bc:a1dd:1562])
        by smtp.gmail.com with ESMTPSA id l18-20020a5d4bd2000000b00236488f62d6sm3447643wrt.79.2022.12.14.09.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 09:16:37 -0800 (PST)
Message-ID: <0e6d6a35-88bf-d577-67d0-7c3f70268c10@tessares.net>
Date:   Wed, 14 Dec 2022 18:16:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [ANNOUNCE] iproute2 6.1 release
Content-Language: en-GB
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20221214082705.5d2c2e7f@hermes.local>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20221214082705.5d2c2e7f@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On 14/12/2022 17:27, Stephen Hemminger wrote:
> This is the release of iproute2 corresponding to the 6.1 kernel.
> Nothing major; lots of usual set of small fixes.

Thank you for this new release and for maintaining this project!

I noticed that the version that is now displayed with 'ip -V' is a bit
different. Before we had something like:

  ip utility, iproute2-5.19.0

Now we have an extra 'v' before the version:

  ip utility, iproute2-v6.1.0

I don't know if it is there[1] on purpose and if it is the reason why
the link was broken. It is just a detail, it was easy to fix my script
parsing the version on my side.

[1]
https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=83de2e800531dd30c2f2dd6e5196ed26c16c0407

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
