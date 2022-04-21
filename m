Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3171509B05
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 10:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386882AbiDUIuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 04:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386852AbiDUIuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 04:50:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0B9313E86
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 01:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650530839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cmuFO35zQUp1s4VhyCud3srWXPlk5AJzSrlDvha5upI=;
        b=ZI1d3mTwo3AKBjUbqtJhR3SD2AIzw6ppBes3+gnMnPoAlHrztCfAhf3x4PjuPPY8brrtnC
        Im/AYttT/5ufwIHQU/UAa9Qmm/To+gSOmxMOLsCJKdNmvjRxle1cS4tzVFFqzlDF+mJNxM
        woBuLxcy9//LVtBO7thaSn2HV3gigL4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-UbLBWSK3P6Wy2Vk78u20_A-1; Thu, 21 Apr 2022 04:47:18 -0400
X-MC-Unique: UbLBWSK3P6Wy2Vk78u20_A-1
Received: by mail-qt1-f199.google.com with SMTP id r16-20020ac87950000000b002f34f162c75so290427qtt.9
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 01:47:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cmuFO35zQUp1s4VhyCud3srWXPlk5AJzSrlDvha5upI=;
        b=VtG+yDVSwZ8LZxHrcRAHtFZJ+u3OEfYPsN2hyARTyjv6hMkXaI8MnDAG6Nbw+K3vjs
         ut9L00bS2NNX4yxNePEn+gRVHIqlhdCiraHtVJ78Exe5GdKn/MYK5E1oYckg/iYsaRwt
         78Grpkf+/u+0I3zcakWkHI6cJWAojAXAMZOBmsqgRemyPDtm9cfZVE4mmpwCzLT5aQxF
         PRK5yreOedTJJo+WWyOe4j3eiSWyk2S+yZgH9mwImXFsheQKZvNBSHca8DR2m/3qyXbm
         Y0xXKkTtAU/b+umS7q3Ji1guOB4DaFIqBQ/SxmcLwucsVAg4sOQ/l9/8MqeU/LtrPikz
         IQPg==
X-Gm-Message-State: AOAM532Vi8nPdL2FUNutEJLxGOvi4ImDwwQp3xHF/F2KWqCmcJMQev5d
        upnC2brujXmtnwLQpJ9RoVGjY/QyH/E7NGhovk8uBkbMcCd7MUGPTkC2nm1B8ugSICq7MlgZgGN
        sh4+Q3gXppSxdCSqb
X-Received: by 2002:a05:6214:2a8d:b0:446:5a52:47f5 with SMTP id jr13-20020a0562142a8d00b004465a5247f5mr14666506qvb.131.1650530838157;
        Thu, 21 Apr 2022 01:47:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2GJ8m4EUIE8m8G2Vb5sGhuPqmE97xodK09lR4BsEnMPjsLVXYZ96WzI2QTuXoVzXWb0tD1w==
X-Received: by 2002:a05:6214:2a8d:b0:446:5a52:47f5 with SMTP id jr13-20020a0562142a8d00b004465a5247f5mr14666492qvb.131.1650530837957;
        Thu, 21 Apr 2022 01:47:17 -0700 (PDT)
Received: from gerbillo.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e13-20020a05620a12cd00b0069e908ab48dsm2559403qkl.106.2022.04.21.01.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 01:47:17 -0700 (PDT)
Message-ID: <84310b72be223d736c8ac9fc58eb4936a98aa839.camel@redhat.com>
Subject: Re: [PATCH] openvswitch: meter: Remove unnecessary int
From:   Paolo Abeni <pabeni@redhat.com>
To:     Solomon Tan <solomonbstoner@protonmail.ch>, pshelar@ovn.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Date:   Thu, 21 Apr 2022 10:47:14 +0200
In-Reply-To: <Yly1t/mE6QAGPS0e@ArchDesktop>
References: <Yly1t/mE6QAGPS0e@ArchDesktop>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-04-18 at 00:50 +0000, Solomon Tan wrote:
> This patch addresses the checkpatch.pl warning that long long is
> preferred over long long int.

Please don't do that. This kind of changes cause e.g. backporting issue
for any later relevant bugfix touching the same area, for no real
benefit. 

Documentation/process/2.Process.rst

explicltly states to avoid this kind of patches.
> 
> Signed-off-by: Solomon Tan <solomonbstoner@protonmail.ch>
> ---
>  net/openvswitch/meter.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 04a060ac7fdf..a790920c11d6 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -592,8 +592,8 @@ static int ovs_meter_cmd_del(struct sk_buff *skb, struct genl_info *info)
>  bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
>  		       struct sw_flow_key *key, u32 meter_id)
>  {
> -	long long int now_ms = div_u64(ktime_get_ns(), 1000 * 1000);
> -	long long int long_delta_ms;
> +	long long now_ms = div_u64(ktime_get_ns(), 1000 * 1000);
> +	long long long_delta_ms;
>  	struct dp_meter_band *band;
>  	struct dp_meter *meter;
>  	int i, band_exceeded_max = -1;

Additionally the patch is mangled by non plain-text encoding.

For any later submissions (regarding some other different topic) please
ensure that your client/mailer send purely plain-text messages,

Thanks,

Paolo

