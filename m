Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045C950A168
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383239AbiDUOBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 10:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbiDUOBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 10:01:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A49EF37AAE
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650549527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FCDdTtfh+cTEbBhGHl6TDA/w0vVS1GSM5e8sY5ZehTw=;
        b=dFsW2VqZ8e8caxzOPPndF7Ftv1Zo+Zm63zFtoCYvGUyM6AvJnZaTDiRdh8mCFFWyG2NlOQ
        YiQvZVLLR+hk6DlNcjD+Su2+G0Fbtu6oi2JTIOr3MSucdHsDIc0du0bQcnuh5q0gIpQQyZ
        lsN7KVukZyTCusivYnpzTK3hc4ZIFiw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-rFUlS-i7P8SW3p685uCmLQ-1; Thu, 21 Apr 2022 09:58:46 -0400
X-MC-Unique: rFUlS-i7P8SW3p685uCmLQ-1
Received: by mail-ej1-f69.google.com with SMTP id sa27-20020a1709076d1b00b006e8b357a2e7so2533771ejc.14
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:58:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FCDdTtfh+cTEbBhGHl6TDA/w0vVS1GSM5e8sY5ZehTw=;
        b=ifxL+tOe4RA4eF+/ncnve+EL2VDCvbeCFndNtjr3xu9hIDqTdjOKDMf58TfZ3+RzBJ
         EuE2EVr7S7UOvwn5AARcb9pTsHZ1jw2BzOBvDjcfkmqRzrGiCKUrCGTjvnuRvMr4skCr
         0ngAcxFpSiTcK6+DRI7KRCTC2u5LU5RYEN/j4C6omPaZB6tGt3RWicdGiGY9tlJ0Z7gv
         b5pbd8Ns8qfD+6VNvpcUElo8INN1QgDBVl5ASgZGDtDV7q0PdOARr0+OxnodOEeNeV6Y
         ihGiKpR0tTDQzqoZomuJ4kmynfS3lTLvMr9Gz8BY6fObkyDrA4htwacS7nOKYI4etQ47
         8XEw==
X-Gm-Message-State: AOAM530Pm7SgiVgXOfFxFOnHpU+Jb5CWGJPoiJTOdKfYAz5qBDSXFPXO
        l5jknDqK2sgyMquEWZabJbv+Kglh1J66uUE6BnVbdl+P3J3qVWnJv0Y9wvaVejfzgD0rfGK4RLz
        1n0ZtenBWMzoGWCMX
X-Received: by 2002:a05:6402:50d1:b0:423:f4a2:95c7 with SMTP id h17-20020a05640250d100b00423f4a295c7mr18677811edb.91.1650549525250;
        Thu, 21 Apr 2022 06:58:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4JGn8p7OAUTHSbJC7sBsOiSljB3wcQ48NL5S76jPutkqPECOtv4rN6ZvZhqHRw9AZzzPQ5Q==
X-Received: by 2002:a05:6402:50d1:b0:423:f4a2:95c7 with SMTP id h17-20020a05640250d100b00423f4a295c7mr18677794edb.91.1650549525081;
        Thu, 21 Apr 2022 06:58:45 -0700 (PDT)
Received: from sgarzare-redhat ([217.171.75.76])
        by smtp.gmail.com with ESMTPSA id s1-20020a056402036100b004240a3fc6b4sm3043298edw.82.2022.04.21.06.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:58:44 -0700 (PDT)
Date:   Thu, 21 Apr 2022 15:58:39 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] hv_sock: Copy packets sent by Hyper-V out of the
 ring buffer
Message-ID: <20220421135839.2fj6fk6bvlrau73o@sgarzare-redhat>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
 <20220420200720.434717-3-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220420200720.434717-3-parri.andrea@gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 10:07:17PM +0200, Andrea Parri (Microsoft) wrote:
>Pointers to VMbus packets sent by Hyper-V are used by the hv_sock driver
>within the guest VM.  Hyper-V can send packets with erroneous values or
>modify packet fields after they are processed by the guest.  To defend
>against these scenarios, copy the incoming packet after validating its
>length and offset fields using hv_pkt_iter_{first,next}().  In this way,
>the packet can no longer be modified by the host.
>
>Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
>---
> net/vmw_vsock/hyperv_transport.c | 9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>index 943352530936e..8c37d07017fc4 100644
>--- a/net/vmw_vsock/hyperv_transport.c
>+++ b/net/vmw_vsock/hyperv_transport.c
>@@ -78,6 +78,9 @@ struct hvs_send_buf {
> 					 ALIGN((payload_len), 8) + \
> 					 VMBUS_PKT_TRAILER_SIZE)
>
>+/* Upper bound on the size of a VMbus packet for hv_sock */
>+#define HVS_MAX_PKT_SIZE	HVS_PKT_LEN(HVS_MTU_SIZE)
>+
> union hvs_service_id {
> 	guid_t	srv_id;
>
>@@ -378,6 +381,8 @@ static void hvs_open_connection(struct vmbus_channel *chan)
> 		rcvbuf = ALIGN(rcvbuf, HV_HYP_PAGE_SIZE);
> 	}
>
>+	chan->max_pkt_size = HVS_MAX_PKT_SIZE;
>+

premise, I don't know HyperV channels :-(

Is this change necessary to use hv_pkt_iter_first() instead of 
hv_pkt_iter_first_raw()?

If yes, then please mention that you set this value in the commit 
message, otherwise maybe better to have a separate patch.

Thanks,
Stefano

> 	ret = vmbus_open(chan, sndbuf, rcvbuf, NULL, 0, hvs_channel_cb,
> 			 conn_from_host ? new : sk);
> 	if (ret != 0) {
>@@ -602,7 +607,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
> 		return -EOPNOTSUPP;
>
> 	if (need_refill) {
>-		hvs->recv_desc = hv_pkt_iter_first_raw(hvs->chan);
>+		hvs->recv_desc = hv_pkt_iter_first(hvs->chan);
> 		if (!hvs->recv_desc)
> 			return -ENOBUFS;
> 		ret = hvs_update_recv_data(hvs);
>@@ -618,7 +623,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
>
> 	hvs->recv_data_len -= to_read;
> 	if (hvs->recv_data_len == 0) {
>-		hvs->recv_desc = hv_pkt_iter_next_raw(hvs->chan, hvs->recv_desc);
>+		hvs->recv_desc = hv_pkt_iter_next(hvs->chan, hvs->recv_desc);
> 		if (hvs->recv_desc) {
> 			ret = hvs_update_recv_data(hvs);
> 			if (ret)
>-- 
>2.25.1
>

