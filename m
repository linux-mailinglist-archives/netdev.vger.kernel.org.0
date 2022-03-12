Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A424D6E34
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 11:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiCLKh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 05:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiCLKhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 05:37:25 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52F9265B7E;
        Sat, 12 Mar 2022 02:36:19 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id bu29so19276084lfb.0;
        Sat, 12 Mar 2022 02:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cVMykGM44N1x59rRBnWq4F2y+SQvEKrBG4xksC7zjJo=;
        b=R4iG36zRM1avPy+Cd8IFirUlQqyvhoLwlZoCr/vaEHb8QpKSrx8XubJ+Zs3YxZLUXN
         obK5Izo2M6O4p/mWnc+Kn7RRna9fDiA+4MNbERLQfQTp1rJz27L07t1qOE7s6/o6QbPd
         0J3T9NFjOXCUhN13q2ox9sXNFo2rProCMZqd/2rftpD91iQISfMqL1W8HLGeiddTUOa1
         NSK/AuZifoc3BYb/8wFlTG01xBze1yLCK1ZNL2Vhf0E72my1QWgZdU9UX9v9vl/svYn7
         +B0NS42TfgvHj4dx/hLbVeomns5MDo580L73ReS+WEUilVb8BGcUXWwfWn2evqC01dRN
         hTDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cVMykGM44N1x59rRBnWq4F2y+SQvEKrBG4xksC7zjJo=;
        b=yI49zcoyNmnp2QIpNKnLbwLG+2d+uCWCU1qr1rG4Wlwd6b3dfkHLpY5/TQVOdWZcsI
         +SRFHbEcgenbmwnYBs/dk9R6eGhVNZ3IXAr8Ba0l4ePpjTQeFRMYlehaLV+5TmUcHQ01
         utGCVDLdLZuGXNBNxQDZ6MG2Fy+Z5PqxnSsbz5KxkZBtCn5JI5SSvpUnYWwk3sRt7jqj
         c3JfTzt30g6dYoJQDzfyKynz9RzLyG0q2oDwnLXWgAhaHRPDbCK/pdshKzQas6HLnHXf
         +zmz6uVz+3mh+vK/aRgXUYsFay+E7BSbSqFf4xnS0bPV6YsfBIn/nyehAbpqWfvkFlGe
         zXPA==
X-Gm-Message-State: AOAM531RwI50K49nM4sfb7xh5M1KdadtgZ9306A03nnG4mxjFYALX/uC
        t05KjoCWZOwKNyxFCY4THH0=
X-Google-Smtp-Source: ABdhPJwjgRadCVDsz2iiQqoREhkfedSRAVn4c3qnX9gSi8nz4QTRvG2LSStr6XLQkDPN+57SRpHoUA==
X-Received: by 2002:a05:6512:3d12:b0:448:5f9f:92ab with SMTP id d18-20020a0565123d1200b004485f9f92abmr7910228lfv.667.1647081378030;
        Sat, 12 Mar 2022 02:36:18 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id u2-20020a2e9f02000000b00244c5e20ee9sm2351933ljk.23.2022.03.12.02.36.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Mar 2022 02:36:17 -0800 (PST)
Message-ID: <afbc1c26-8aea-e0b7-47e0-bee0d195a21b@gmail.com>
Date:   Sat, 12 Mar 2022 13:36:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [syzbot] INFO: task hung in port100_probe
Content-Language: en-US
To:     Hillf Danton <hdanton@sina.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <20220310084247.1148-1-hdanton@sina.com>
 <20220311053751.1226-1-hdanton@sina.com>
 <20220312005624.1310-1-hdanton@sina.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220312005624.1310-1-hdanton@sina.com>
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

On 3/12/22 03:56, Hillf Danton wrote:
>> upstream branch already has my patch: see commit 
>> f80cfe2f26581f188429c12bd937eb905ad3ac7b.
>> 
> Thanks for your fix.
> 
>> let's test previous commit to see if my really fixes this issue
>> 
>> #syz test: 
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 
>> 3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b
> 
> Given the Reported-and-tested-by tag in syzbot's echo [1], can you try and
> bisect the curing commit in your spare cycles?
> 
> Hillf
> 
> [1] https://lore.kernel.org/lkml/00000000000002e20d05d9f663c6@google.com/
> 

Hm, that's odd. Last hit was 4d09h ago and I don't see related patches 
went it expect for mine.

Will try to bisect...

Also there is a chance, that reproducer is just unstable.



With regards,
Pavel Skripkin
