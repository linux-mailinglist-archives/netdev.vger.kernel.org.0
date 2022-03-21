Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30294E3261
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 22:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiCUVqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 17:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiCUVqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 17:46:32 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946EE3A145F;
        Mon, 21 Mar 2022 14:41:51 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id s11so16565698pfu.13;
        Mon, 21 Mar 2022 14:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NA1m9UyZ4lhhPpf1XufykiTNpRaeivKuhk1ObAu+BXw=;
        b=LQTsvuzqLGnxWBpHNx87luZRiDd5e6nwkPpxuTQMdejb7r4ez2JV41xIavmg+0JYb1
         3gfB/fykswbIdQhU1jzV9OE8Cz4MKbZu0ZC17EvjdpUdqeSvhnE+IKfeIfCJpwK5jYWe
         11nNL+PBKvExIjtQsZ1B3f0S3/inF7KZ3VPc8xKiSVrcCIUyyKs2SnFPzgMkNLlPoJ1L
         xI0VeJpt2iGJ61j5Zdfw732CbWjSEROH+SMQipF0k6q6ZRObWv8xT0WGlSXp2Dy/P1c5
         XrlfcdNxjWB2ahRfPfwB31rX+InEsIgNv+/flquTjwASIUFfe68e111s3EzX8/fiAgaK
         WYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NA1m9UyZ4lhhPpf1XufykiTNpRaeivKuhk1ObAu+BXw=;
        b=yxQuZgzERScbhX2iXKGCI7WDtws5oWhxokdVycM3WtCHAWhDpfAecOjB1kcDy5rc3r
         7xapkk34jzRi8w3FBUSuOQZum1OGPzuo242qa8ctWAHxA/Ve8mwn4ePhsbQMx5KA0wGj
         c3AoREf54nPHDgh2uP9c6KuEnfk1DmRPM4yDliT9rr2LpAJDIHHp9918POfNmK0ENYA3
         4q0aFgLcokq4DLwCnd/4jXhXeyUf3gXtF3cViooER/ZVoe/4z/lxGCZYIOPTo5Yjl9Q0
         8y8QYEnIjJX7wI83jM/QBNVvMSb48ey1+WVWX/kignndwwwr2WmMoCDkmwPvDJtgsxGI
         kdsA==
X-Gm-Message-State: AOAM531+OaxEGsIVmBPdOjoHQ2F1+OshRSqXOfLi2sqnibC96iphq4a+
        utAugC8BmCADWsGunGxL22PRGj/nRFY=
X-Google-Smtp-Source: ABdhPJwGsBOLEzAnmRQgfxIP4KZUd1qcl+p25o66/UzHbunEyTsNdmj5FAsUQ+gEDQnD43J7G3cuYQ==
X-Received: by 2002:a63:ab47:0:b0:375:5d05:9f79 with SMTP id k7-20020a63ab47000000b003755d059f79mr19971911pgp.192.1647898102558;
        Mon, 21 Mar 2022 14:28:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b1-20020a17090aa58100b001bcb7bad374sm360872pjq.17.2022.03.21.14.28.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 14:28:21 -0700 (PDT)
Message-ID: <2d15b283-8378-89e5-d01c-9e5f5e0e0919@gmail.com>
Date:   Mon, 21 Mar 2022 14:28:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: bcmgenet: Use stronger register read/writes to
 assure ordering
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org,
        opendmb@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>
References: <20220310045358.224350-1-jeremy.linton@arm.com>
 <0465ecd0-0cd7-1376-51bf-38aa385c128a@gmail.com>
 <20220321142645.38b8a087@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220321142645.38b8a087@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/22 14:26, Jakub Kicinski wrote:
> On Fri, 18 Mar 2022 12:04:34 -0700 Florian Fainelli wrote:
>> On 3/9/22 8:53 PM, Jeremy Linton wrote:
>>> GCC12 appears to be much smarter about its dependency tracking and is
>>> aware that the relaxed variants are just normal loads and stores and
>>> this is causing problems like:
> 
>>> Fixes: 69d2ea9c79898 ("net: bcmgenet: Use correct I/O accessors")
>>> Reported-by: Peter Robinson <pbrobinson@gmail.com>
>>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>>
>> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Commit 8d3ea3d402db ("net: bcmgenet: Use stronger register read/writes
> to assure ordering") in net now, thanks!

Thank you Jakub!
-- 
Florian
