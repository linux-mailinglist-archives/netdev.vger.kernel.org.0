Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF014D6EB4
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 13:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiCLMqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 07:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiCLMqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 07:46:10 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799C7FFF8D;
        Sat, 12 Mar 2022 04:45:03 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id u3so15648363ljd.0;
        Sat, 12 Mar 2022 04:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=V1xSnHLG9zgiX49+Lkqc7PP+pvPRmauK3yOINCXZiT0=;
        b=gzQkANbeOKCpGahQesW5kij+w4r/Q/pZb/B/WI3TKRp0jsE5WLMZ37i7eS6nJBnVOc
         qQ2VL/KeyAP+3fg17f573lu9D7JhDw1T81eqLT5PYiZGClKBJQds1Z4C4mCZR1yF1IgA
         BQebjEfvbhWF/xEEetr3nPRaxTNuUZp2QEPCfBlMzQkyW+krUbDc5EcjkMkYrY7IPKNX
         KmH/3DWxdRIc8A9CLqOMBOiRQcENdG1e5aOblNo6Lnj3lXqy8fDY7EHV4c6wtFXRO9VW
         yh+aiE0uza6RtFl1zZJ0MuhXXj2FLWI9kBE5uL5qhHfgl4V9W2zauoCwa2BPI0xrhY8W
         A2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V1xSnHLG9zgiX49+Lkqc7PP+pvPRmauK3yOINCXZiT0=;
        b=Dw0ORDnl9zRAJEIqRYX9rSXo2R8cLcIrhdbEXr816GxIZuHYU9mE3wFf3v2riDzUWO
         wsE2Sii1Cd3zoBvTdsbSU6XX+MT5rmcBN7HWgbCNYXEx4iHT7ALNXAC7PkYk1dSXv/9J
         nJGXbxpB7KfxUM7BhhvS4Aod/aJ+E5HAfxFdyRgtn7JWPkICjpjGl8htQMvGFdCalVm7
         FcznMkA2pPDG4Bw0jQhdVefKpIdCNFw4gglu63Wu52yfl/BYbF5v65HyIYP0wgPmvU3d
         WAtJ1rkoLWOv+K2/TKve5jv/rYW9YAfYnfS9hOR7JPlUblBj1W+rDZesy5poHukzr3N7
         lPcQ==
X-Gm-Message-State: AOAM530TcmqAXgg25UK2C//ltfUG5unUbOq8hYjYKaoUOTnTDLwJY5KT
        PvQgWY79DNxs2K8nazLIejo=
X-Google-Smtp-Source: ABdhPJxYGvMqOxiWujG324fhtfAJMMUCOJSBJK8x3WXl/sumDJN4Mp0F8lwFJqlZXYKPSE3e6A9CKg==
X-Received: by 2002:a05:651c:506:b0:22d:b44b:113e with SMTP id o6-20020a05651c050600b0022db44b113emr8782690ljp.32.1647089101094;
        Sat, 12 Mar 2022 04:45:01 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id j7-20020a2e3c07000000b00247fd2f7f46sm2417945lja.47.2022.03.12.04.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Mar 2022 04:45:00 -0800 (PST)
Message-ID: <9f4287ae-21f6-5c2a-fed7-6cc7606c7e8c@gmail.com>
Date:   Sat, 12 Mar 2022 15:44:58 +0300
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
 <20220312115854.1399-1-hdanton@sina.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220312115854.1399-1-hdanton@sina.com>
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

On 3/12/22 14:58, Hillf Danton wrote:
> On Sat, 12 Mar 2022 13:36:15 +0300 Pavel Skripkin  wrote:
>> On 3/12/22 03:56, Hillf Danton wrote:
>> >> upstream branch already has my patch: see commit 
>> >> f80cfe2f26581f188429c12bd937eb905ad3ac7b.
>> >> 
>> > Thanks for your fix.
>> > 
>> >> let's test previous commit to see if my really fixes this issue
>> >> 
>> >> #syz test: 
>> >> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 
>> >> 3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b
>> > 
>> > Given the Reported-and-tested-by tag in syzbot's echo [1], can you try and
>> > bisect the curing commit in your spare cycles?
>> > 
>> > Hillf
>> > 
>> > [1] https://lore.kernel.org/lkml/00000000000002e20d05d9f663c6@google.com/
>> > 
>> 
>> Hm, that's odd. Last hit was 4d09h ago and I don't see related patches 
> 
> Wonder if you mean it was reproduced four days ago by "Last hit was 4d09h ago".

Yes, exactly.

> If it was then can you share the splat? Anything different from the
> syzbot report [2] on Tue, 22 Jun 2021?
> 

IIRC syzbot tests on top of newest updates. I.e. last time syzbot 
reproduced this issue on top of v5.17-rc7 at least. So fix commit should 
somewhere between v5.17-rc7..HEAD




With regards,
Pavel Skripkin
