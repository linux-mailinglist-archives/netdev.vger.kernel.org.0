Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC44D6882FE
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbjBBPrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbjBBPrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:47:04 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1422778AD4
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 07:46:44 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id m2so7117653ejb.8
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 07:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8Gc65aUVwApOeHyeBrWY9LnhCMXXP4ZkreA7OeG+4U=;
        b=67VAyORvNbOtmnWVjQlursOQbEnRpUIb8PQ29AvrnI1ROHyz3Be78spBGFafB30mz6
         wKlDF18QRYFQa5RUBVcuLuF7jvYPaACSnz65hTDC9su12QhMbeMgwsmkkpFLaq8hVuzT
         7ngvN5B8r5K9/2C6qtC+rjJqxpxPPJC1RYheRSddhGmeBCsvd0cF5A2qydhTiJV7cGvq
         v9CbrDoLpItIonop4Vn7OYpk9qjRADcHiMQNgbWTiaqmQU6kHx50EgiolP3kToc0rGyU
         G4VhAQKISk5qG7hnEkVbahol2M4AFU3yyaLilHmzVc+0i2n4SqMTU/cARtECLPEIElkV
         8AmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8Gc65aUVwApOeHyeBrWY9LnhCMXXP4ZkreA7OeG+4U=;
        b=Um5fmOtMhclMiH3WkRgmaCQRmR+FT884uG0IcxKxW9fuFjvf9xMLt5sJob5VMjzUS7
         nDuXayaowLB0zZG75lFgBNumbAnmRoTc+9hTCtnhek9iSQ4gfK+yfpYNA/nV4HpItT7L
         jw9wQ7ctPR7jVSZqxocZi/5exRJKocXrL5bJLEFZSgSE0fcczmg7jQVVNNVczsdQb3pr
         75lZef96rXoYnrvj8dUzvreB5intihmTqf+uBTTlkRh36HoEmwH8Af+e1hTYfkIZlsee
         5mA8I4o5yUj+FSeqmqrOetTNxZ/2owpjBTJWLyNFKTZimxYBTWsqJMBKGWDhGZcUBoNn
         ergQ==
X-Gm-Message-State: AO0yUKWfpE17B+ERDZEQ2cLb2zHabXbCPIS8/JWzzqieUkC9ARAPeeoW
        oTXiZNr+uW5Hc3CG/wfWbmJEYHK39BIh6Y5BmWS0Eg==
X-Google-Smtp-Source: AK7set/vvtOpJuh/J1KX2g79Jkm9KHWdxwyC+o/qD9/dF5IauAW+GhEbTVX1t0WBvGA2i55u+YWKLA==
X-Received: by 2002:a17:907:9c07:b0:88d:ba89:183b with SMTP id ld7-20020a1709079c0700b0088dba89183bmr2463211ejc.12.1675352801454;
        Thu, 02 Feb 2023 07:46:41 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709063e4c00b0088a9e083318sm5477031eji.168.2023.02.02.07.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 07:46:40 -0800 (PST)
Date:   Thu, 2 Feb 2023 16:46:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH 2/2] virtio-net: Maintain reverse cleanup order
Message-ID: <Y9va33VLJ/eRPUbW@nanopsycho>
References: <20230202050038.3187-1-parav@nvidia.com>
 <20230202050038.3187-3-parav@nvidia.com>
 <Y9ur9B6CDIwThMN6@nanopsycho>
 <PH0PR12MB5481C0C7E46B5DFF85178792DCD69@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481C0C7E46B5DFF85178792DCD69@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 02, 2023 at 04:10:56PM CET, parav@nvidia.com wrote:
>
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Thursday, February 2, 2023 7:26 AM
>> 
>> Thu, Feb 02, 2023 at 06:00:38AM CET, parav@nvidia.com wrote:
>> >To easily audit the code, better to keep the device stop() sequence to
>> >be mirror of the device open() sequence.
>> >
>> >Signed-off-by: Parav Pandit <parav@nvidia.com>
>> 
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>> 
>> If this is not fixing bug (which I believe is the case), you should target it to net-
>> next ([patch net-next] ..).
>> 
>Yes. Right. First one was fix for net-rc, second was for net-next. And 2nd depends on the first to avoid merge conflicts.
>So, I was unsure how to handle it.
>Can you please suggest?

1) Send the fix to -net
2) Wait until -net is merged into -net-next
3) Send the second patch to -net-next

>
>
>> 
>> >---
>> > drivers/net/virtio_net.c | 2 +-
>> > 1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> >diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c index
>> >b7d0b54c3bb0..1f8168e0f64d 100644
>> >--- a/drivers/net/virtio_net.c
>> >+++ b/drivers/net/virtio_net.c
>> >@@ -2279,9 +2279,9 @@ static int virtnet_close(struct net_device *dev)
>> > 	cancel_delayed_work_sync(&vi->refill);
>> >
>> > 	for (i = 0; i < vi->max_queue_pairs; i++) {
>> >+		virtnet_napi_tx_disable(&vi->sq[i].napi);
>> > 		napi_disable(&vi->rq[i].napi);
>> > 		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>> >-		virtnet_napi_tx_disable(&vi->sq[i].napi);
>> > 	}
>> >
>> > 	return 0;
>> >--
>> >2.26.2
>> >
