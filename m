Return-Path: <netdev+bounces-2712-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7561D7032C6
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A2361C20BB1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910C9E57F;
	Mon, 15 May 2023 16:21:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3BBC8ED
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:21:07 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49151199
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:21:06 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64cb307d91aso741017b3a.3
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684167666; x=1686759666;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3sjjMKntyz3ar2/ZLbJl2r6S+7L97jsCB6JQxHHScbY=;
        b=hj70LO/uq4dXdwvECVfe+84/KPWcqvut9qdnUGRaYq3FCYXLVJ+aAPfNRSBBClk0Sf
         rAlx8pDRXUkFAdBzuxkLadcA3SgkMO2OpyGq3lBEMcZY6rw6vhwSyFo3h49EENTM3XOd
         9iMYbs6eQMUTFMYHFz+skrRcf6CnYolI7NOKVqotUb+49N0JxwUDtNLENQrwALu5N6rt
         rYecx1cyCu62zYrA+rD5eabWixq71WV/qmEPn+XRGqoI0EAN1+oKvy9Eay1unRw8SfEH
         4FtGGj1paWzl2lSSzOqIB/3DWlFHQZAZO+dEm7Qh/nQKl3dk9TAPK5i5goFxh21mw6/o
         z46Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684167666; x=1686759666;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3sjjMKntyz3ar2/ZLbJl2r6S+7L97jsCB6JQxHHScbY=;
        b=fd54kmMprIWRP3Jsunr5EGZwM0GYZq4BurtiTatQELJWkDxt0dIaumKfxArg80HSCR
         zvI52+jE2jeaK3aVzTuQAVoVD7bmEha6zfPWGja6MnCoIXJ3tQiYkqxmXlBpKZzSO44m
         ltrpyyoGuUYkzTHeIWvSr2M41jK0j/8B0hsXMP+GSvTKysQHqC8hWLmcxz5Kz6fr/ha2
         54Red9rPibqSAyOhU8HKbAW8TyCMTnrlsOomSjIGZ7hiA5UaodnWcQ406P8r5u4mVEUx
         0evvxD8Hc0vMTQbruqLr9W99tjxpffOpbygDS0isr4eMey9/NSAFawFTWkB9aReVxt6W
         iDSA==
X-Gm-Message-State: AC+VfDyguggWi7ZGbyAKOvQ/Mo4I4MQTdjfCgc7ay6732/UL034V2PBI
	hMfGWXPDvMX/VOym0ohlkAo=
X-Google-Smtp-Source: ACHHUZ7L0feZ5Qorm5BLu0RgChv6QK9ywhof3zZNFlMZ9ifQvcwdcE7VebMefRxBz1vlF3N/awvVJw==
X-Received: by 2002:a05:6a21:3a43:b0:f8:1101:c074 with SMTP id zu3-20020a056a213a4300b000f81101c074mr35806887pzb.54.1684167665493;
        Mon, 15 May 2023 09:21:05 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id e16-20020aa78250000000b006348cb791f4sm1348038pfn.192.2023.05.15.09.21.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 09:21:04 -0700 (PDT)
Message-ID: <a43c690e-5768-02ea-5e1f-9f7ae32236cf@gmail.com>
Date: Tue, 16 May 2023 01:21:00 +0900
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net] net: fix stack overflow when LRO is disabled for
 virtual interfaces
To: Simon Horman <simon.horman@corigine.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, jiri@resnulli.us, j.vosburgh@gmail.com,
 andy@greyhouse.net, netdev@vger.kernel.org, jarod@redhat.com,
 wangyufen@huawei.com, syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
References: <20230515053740.3065735-1-ap420073@gmail.com>
 <ZGIvbCJqAgVMIJ57@corigine.com>
Content-Language: en-US
From: Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <ZGIvbCJqAgVMIJ57@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/15/23 22:11, Simon Horman wrote:
Hi Simon,
Thank you so much for the review!

 > On Mon, May 15, 2023 at 05:37:40AM +0000, Taehee Yoo wrote:
 >> When the virtual interface's feature is updated, it synchronizes the
 >> updated feature for its own lower interface.
 >> This propagation logic should be worked as the iteration, not 
recursively.
 >> But it works recursively due to the netdev notification unexpectedly.
 >> This problem occurs when it disables LRO only for the team and bonding
 >> interface type.
 >>
 >>         team0
 >>           |
 >>    +------+------+-----+-----+
 >>    |      |      |     |     |
 >> team1  team2  team3  ...  team200
 >>
 >> If team0's LRO feature is updated, it generates the NETDEV_FEAT_CHANGE
 >> event to its own lower interfaces(team1 ~ team200).
 >> It is worked by netdev_sync_lower_features().
 >> So, the NETDEV_FEAT_CHANGE notification logic of each lower interface
 >> work iteratively.
 >> But generated NETDEV_FEAT_CHANGE event is also sent to the upper
 >> interface too.
 >> upper interface(team0) generates the NETDEV_FEAT_CHANGE event for 
its own
 >> lower interfaces again.
 >> lower and upper interfaces receive this event and generate this
 >> event again and again.
 >> So, the stack overflow occurs.
 >>
 >> But it is not the infinite loop issue.
 >> Because the netdev_sync_lower_features() updates features before
 >> generating the NETDEV_FEAT_CHANGE event.
 >> Already synchronized lower interfaces skip notification logic.
 >> So, it is just the problem that iteration logic is changed to the
 >> recursive unexpectedly due to the notification mechanism.
 >>
 >> Reproducer:
 >>
 >> ip link add team0 type team
 >> ethtool -K team0 lro on
 >> for i in {1..200}
 >> do
 >>          ip link add team$i master team0 type team
 >>          ethtool -K team$i lro on
 >> done
 >>
 >> ethtool -K team0 lro off
 >>
 >> In order to fix it, the priv_notifier_ctx net_device member is 
introduced.
 >> This variable can be used by each interface in its own way in the
 >> notification context. The bonding and team interface is going to use it
 >> to avoid duplicated NETDEV_FEAT_CHANGE event handling.
 >>
 >> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
 >> Fixes: fd867d51f889 ("net/core: generic support for disabling netdev 
features down stack")
 >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >
 > ...
 >
 >> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
 >> index 08fbd4622ccf..ebd49a54f0d5 100644
 >> --- a/include/linux/netdevice.h
 >> +++ b/include/linux/netdevice.h
 >> @@ -2393,6 +2393,7 @@ struct net_device {
 >>   	unsigned		threaded:1;
 >>
 >>   	struct list_head	net_notifier_list;
 >> +	u32			priv_notifier_ctx;
 >
 > Hi Taehee,
 >
 > Please add this new field to the kdoc for struct net_device.
 >

Thanks! I will check this before submitting the v2 patch.

Thank you so much,
Taehee Yoo


 >>
 >>   #if IS_ENABLED(CONFIG_MACSEC)
 >>   	/* MACsec management functions */
 >
 > ...
 >
 > ---
 > pw-bot: cr

