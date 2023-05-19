Return-Path: <netdev+bounces-3823-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F7E2708FDF
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBB5D28186B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73E265D;
	Fri, 19 May 2023 06:25:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF62C7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:25:20 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618C61A6
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 23:25:18 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1ae452c2777so3736145ad.0
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 23:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684477518; x=1687069518;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2qte+yLzdGBgNQqllGOcsDFJQTEnZZ08ThkY7gM5Pnc=;
        b=ETEGU6g9BZ0eYyNJAns5VR1T898YRSVDBaw0pf55fSNFXXIirkRnLevHElOM4w30Th
         RnuqK/EFc2VOoBQXxvChiFUPEGdzi3ji6uhMDz3rFXYh4hjSTcwky9vOckO6LMHXPP3r
         +BsEumBj+W7mrh058SljxU/MZyTlxTc6IQPz7ufFFe77e2iCIYaBZPf5OT3C5xJ1bzR3
         7dKJW02ooQxdcIMPLk+3tVNwMCtzbLoCKCgFrtb855+J/S4KoBQuR5l9JJn/Orz87mrC
         Ymd+zWsymTtM5MpI9OZXrMKHa3uQObW8RtVs0CdCL1dzbMSu4OkXaFZbXBK6/EI71XQF
         Oltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684477518; x=1687069518;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2qte+yLzdGBgNQqllGOcsDFJQTEnZZ08ThkY7gM5Pnc=;
        b=e4G+vUThDhVUVaTWRRAHsJUURhnZ8d+ql503RKGWjJ5MKp8xxTXgOracsX5ifodie4
         1kzoyBaS26Vo35poNAEFdT4YSeJEjvcFE833CkUfPA4VXu6iBn4SUc0vsVFn7kWEP3BT
         1Nqc7bd9hyjSihdj+T4W7KSmf/Zbg44czz5ics8yUCC3cgOXtyk4k0Dg4urQthx0nFH2
         7YmwsYislq6+HL5EVf8wuVBclCT0SVSqQfzT9x/KyjMWTxsAGeb+k/poo2zibirRiCMv
         8s2sOntOmKu2NPYJH0Np9UA8ZnJo7olbxH1Rl6lvojV5OQBd70gDiCMnCmnT7lW6tB4r
         qa3g==
X-Gm-Message-State: AC+VfDxAGFdjKnSLsbUOT7Qx1+zqjW30mTEBeIGBjcM9jeWgqn3CCQ7d
	t8TazQXDC5eN+Z6qYjnCGqw=
X-Google-Smtp-Source: ACHHUZ7rRxqIJnmt4QKzgEJxraU1RCjfC6dpTRcaLlkZJIRp4NE6OSZOvh7GR43B2GQY2Nj5saObfA==
X-Received: by 2002:a17:903:1d1:b0:1a1:d54b:71df with SMTP id e17-20020a17090301d100b001a1d54b71dfmr1944890plh.0.1684477517643;
        Thu, 18 May 2023 23:25:17 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902680500b001a245b49731sm2577658plk.128.2023.05.18.23.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 23:25:16 -0700 (PDT)
Message-ID: <2ea192a8-b437-86e4-59b3-b4d57117aee1@gmail.com>
Date: Fri, 19 May 2023 15:25:12 +0900
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v2] net: fix stack overflow when LRO is disabled for
 virtual interfaces
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 jiri@resnulli.us, j.vosburgh@gmail.com, andy@greyhouse.net,
 netdev@vger.kernel.org, jarod@redhat.com, razor@blackwall.org,
 simon.horman@corigine.com, wangyufen@huawei.com,
 syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
References: <20230517143010.3596250-1-ap420073@gmail.com>
 <20230517091511.30cc0803@kernel.org>
 <6701e21c-a430-6309-bc13-dcff529d8ab5@gmail.com>
 <20230517114552.08c38d4c@kernel.org>
Content-Language: en-US
From: Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20230517114552.08c38d4c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/18/23 03:45, Jakub Kicinski wrote:
 > On Thu, 18 May 2023 02:28:29 +0900 Taehee Yoo wrote:
 >>   > Why doesn't the (already synchronized) upper not skip the update?
 >>
 >> The skipping logic of this is existing in the 
netdev_sync_lower_features().
 >> The purpose of this is to synchronize the lower interfaces, not the
 >> upper interface.
 >> Actually, there is no upper-only synchronization logic.
 >>
 >> Both bonding and team interfaces rely on notification mechanisms to work
 >> their own logic such as synchronization.
 >> The notification is a broadcasting mechanism.
 >> So, both lower and upper receive this event, and it works its own
 >> notification handling.
 >
 > This is all true.
 >
 >> But the notification mechanism currently doesn't have options such as
 >> filtering and these interfaces receive this event with updated feature
 >> flags.
 >
 > We don't have to filter notifications.
 >
 >> So, the upper interface can't distinguish whether the received event is
 >> the first event or duplicated event.
 >
 > What I was thinking was basically why does __netdev_update_features()
 > not return early if it made no changes? Looking thru the history this
 > behavior has been created by commit e7868a85e1b26bcb2e. Can we revert
 > that and fix the problem of syncing features on new ports differently?

I think this is the best approach so I tried it with existing variables 
such as dev->features, dev->wanted_features, But I couldn't find to fix it.
Because the upper interface' feature flag is updated at the end of it.
So, __netdev_update_features() is called always with the old 
upper-interface' features flag.
__netdev_update_features()
     netdev_sync_lower_features()
        __netdev_update_features()
            netdev_sync_lower_features()
...
            dev->features = features;
        dev->features = features;
     dev->features = features;
dev->features = features;

In order to return __netdev_update_features() early in duplicated call,
__netdev_update_features() should update dev->features ealier than 
netdev_sync_lower_features() call.
So, the current code doesn't update dev->features early so it can't 
check duplicated calls with dev->features.

I tested this approach with a revert of e7868a85e1b26bcb2e and the below 
change.

diff --git a/net/core/dev.c b/net/core/dev.c
index 6b12d8a9d463..f051c293ffaa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9758,6 +9758,9 @@ int __netdev_update_features(struct net_device *dev)
                 return -1;
         }

+       if (netif_is_bond_master(dev) || netif_is_team_master(dev))
+               dev->features = features;
+
         /* some features must be disabled on lower devices when disabled
          * on an upper device (think: bonding master or bridge)
          */

It fixes the stack overflow problem, but I'm not sure whether updating 
it before netdev_sync_lower_features() is safe or not.

