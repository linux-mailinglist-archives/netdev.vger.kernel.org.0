Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DED4D6904
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 20:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbiCKTSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 14:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236885AbiCKTSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 14:18:25 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE181AD968;
        Fri, 11 Mar 2022 11:17:20 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id w27so16731522lfa.5;
        Fri, 11 Mar 2022 11:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZsHIBpGXnwIhrG4iMGUoWdVIjbIGNaY5etm7AT6pDJo=;
        b=JI0zoRS6FXKnShZyhOhGVFcJdy21NP5xQQ/CvdTLkZA310iwvsy6ee3UvoCKSrYLYJ
         nfYq7HPVfhxGtutuZMeWid9zyzLJOj4rheuLfsJoTCH31Wdqa1FtnMusRMaKQWJ/9hek
         HtEFfr7h6qdC0u+Ld3fR0DSfPW/CmToq4RZGSdAywyP1PF9STOQS4tfPi4+sba2X5oYB
         kqHdsnUJgPqnb+rG7q59AntjYVZlaYcK+XRElE4HYk/Jx8EAvc6en+pxyji9UGBoOfJF
         3ssCbE+SZfSGtu5E88kEcXCNup2NxXhFnr5sPBi5c7R0p0/vtX5ZomuaM9E8ahKf4rbg
         DQeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZsHIBpGXnwIhrG4iMGUoWdVIjbIGNaY5etm7AT6pDJo=;
        b=CXlPsXLRF/f2HO4EpnT1KLV7Nf2eYgmaN60o1NIjniSEKOS42oLWwA+AW43alrUqfR
         vKiIIzNrr4Nrdbk/0KTGK8hOfGkbXIS75jcuTSxlmm365UCRyuNhLoL5kMVFf2jiNWkJ
         NK0Ylz0qCr4dgegPUn7m+ek/cyeEjMVo4QgVveMrW7VDwTYKdYwgsYRVLSkfvUeBNB20
         gYebws6GTtoaYvW4zWfc8CItnggzNmNKH+5cXjeOMwcPE4/HVPIbRf9CniP+sH716f2w
         LRztRZU5fj5fpQAquHapJEJA4omkt+wx4ks70B1ezrti/V9bh0KPWEKpG2FSGy9zFN2t
         yYEg==
X-Gm-Message-State: AOAM531CRtnhkyvK3dCTwjdq0qoMbkRYTv56uw97gyPT78uM8CX6c2hC
        8+Ivxxq3p0XZxOmcEkAqwLk=
X-Google-Smtp-Source: ABdhPJyyLsiPSmD0HDq7LOiUdayb6rR4N+WeRVHYqxcrmuHlfUT0Dp33NeCBtwTz9FEWw4C8m1sS2w==
X-Received: by 2002:ac2:41d6:0:b0:448:cd3:4b6e with SMTP id d22-20020ac241d6000000b004480cd34b6emr6716100lfi.134.1647026238168;
        Fri, 11 Mar 2022 11:17:18 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id cf35-20020a056512282300b004487e5bc10esm162791lfb.219.2022.03.11.11.17.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 11:17:17 -0800 (PST)
Message-ID: <9df69909-9859-f76c-e31a-75df47738710@gmail.com>
Date:   Fri, 11 Mar 2022 22:17:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [syzbot] INFO: task hung in port100_probe
Content-Language: en-US
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <20220310084247.1148-1-hdanton@sina.com>
 <20220311053751.1226-1-hdanton@sina.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220311053751.1226-1-hdanton@sina.com>
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

Hi Hillf,

On 3/11/22 08:37, Hillf Danton wrote:
> On Thu, 10 Mar 2022 06:22:10 -0800
>> Hello,
>> 
>> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>> 
>> Reported-and-tested-by: syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com
>> 
>> Tested on:
>> 
>> commit:         1db333d9 Merge tag 'spi-fix-v5.17-rc7' of git://git.ke..
>> git tree:       upstream
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=16438642a37fea1
>> dashboard link: https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
>> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
>> 
>> Note: no patches were applied.
>> Note: testing is done by a robot and is best-effort only.
> 
> Given the failure of reproducing it upstream, wait for syzbot to bisect the
> fix commit in spare cycles.
> 

upstream branch already has my patch: see commit 
f80cfe2f26581f188429c12bd937eb905ad3ac7b.

let's test previous commit to see if my really fixes this issue

#syz test: 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 
3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b




With regards,
Pavel Skripkin
