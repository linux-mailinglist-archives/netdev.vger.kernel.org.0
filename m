Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBC650A135
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387752AbiDUNyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387697AbiDUNx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:53:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8306713F97
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650549067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9X5WXrysF88Ouj/slnEAN9ILrlD7gwjjZO9fEL4BbEQ=;
        b=fKrAsnAMq3aigMbo5EEBDb+HSwA6BXjNc7utSGR64zvlhkI4aLabOR+IatJzIwaRkEdKRl
        I66f6z9WaOhEeiplJ7k4xFN/6PC4UZ1Bj42KQwbtB+EuAYaUvFZ+y/+R9xErtlVLhzGard
        sc0wj+7f1UiVTF36bePoSBIPfQ3Vx6k=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-TwIljPudP3iJScaIYhFSjQ-1; Thu, 21 Apr 2022 09:51:03 -0400
X-MC-Unique: TwIljPudP3iJScaIYhFSjQ-1
Received: by mail-ej1-f70.google.com with SMTP id qw33-20020a1709066a2100b006f001832229so2535283ejc.4
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9X5WXrysF88Ouj/slnEAN9ILrlD7gwjjZO9fEL4BbEQ=;
        b=dFug1Pn8rY+DWRzDa199al7iyEFQE3pNzqfMSC1pt/lHKaKpqsRR57DKtExhzWg5jR
         Czum5trxP6CyN7/339b3iRErvaT9PhDGoZttrX3QnZGL1PB9tBNk4oLowaZRM9IVtvUy
         PEhOJ0resudMz7UnnLn2JoegRp98fBXyTUndrUqIyzWfzRvKnOIx10zvTloLbymJF+8D
         wdYmbGLMHLk6YtgYW94yS+BgiHZycGjxzOV5g3/JJCW3fcxKYJyDGRie3KlNPUKvvLRs
         U0gPAA/aei7Rb3jVJjGCO26U+hpZb4ZbJnUJzgZt4/wWBMqMVwGng0c4uWyVda1CIxYm
         u42g==
X-Gm-Message-State: AOAM532IbgjzgtIAA9A6xq5by20Pealr9Kc5/9TmNQ+nhrhtBa6blkGl
        KijXPDtAjqQpcdTYhdAWWKkDGfOsleMZ8P/kCx3Xx5450uklzj5wgTPfq/Anqg6XLMpi5hD1nj+
        wCiQ4YyFF+wAeEKSs
X-Received: by 2002:a05:6402:26cd:b0:423:b43d:8b09 with SMTP id x13-20020a05640226cd00b00423b43d8b09mr28005752edd.400.1650549062691;
        Thu, 21 Apr 2022 06:51:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTS+Y4ILLrJT3QP2BpwpnOM5BPXge8ufksj1+vy8uCme6m2CyXJ309d3wnCuvShf6eaPoQKg==
X-Received: by 2002:a05:6402:26cd:b0:423:b43d:8b09 with SMTP id x13-20020a05640226cd00b00423b43d8b09mr28005722edd.400.1650549062455;
        Thu, 21 Apr 2022 06:51:02 -0700 (PDT)
Received: from sgarzare-redhat ([217.171.75.76])
        by smtp.gmail.com with ESMTPSA id d7-20020a170906174700b006e80a7e3111sm8096281eje.17.2022.04.21.06.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:51:01 -0700 (PDT)
Date:   Thu, 21 Apr 2022 15:50:57 +0200
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
Subject: Re: [PATCH 1/5] hv_sock: Check hv_pkt_iter_first_raw()'s return value
Message-ID: <20220421135057.57whrntjdv25jqpl@sgarzare-redhat>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
 <20220420200720.434717-2-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220420200720.434717-2-parri.andrea@gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 10:07:16PM +0200, Andrea Parri (Microsoft) wrote:
>The function returns NULL if the ring buffer doesn't contain enough
>readable bytes to constitute a packet descriptor.  The ring buffer's
>write_index is in memory which is shared with the Hyper-V host, an
>erroneous or malicious host could thus change its value and overturn
>the result of hvs_stream_has_data().
>
>Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
>---
> net/vmw_vsock/hyperv_transport.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>index e111e13b66604..943352530936e 100644
>--- a/net/vmw_vsock/hyperv_transport.c
>+++ b/net/vmw_vsock/hyperv_transport.c
>@@ -603,6 +603,8 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
>
> 	if (need_refill) {
> 		hvs->recv_desc = hv_pkt_iter_first_raw(hvs->chan);
>+		if (!hvs->recv_desc)
>+			return -ENOBUFS;
> 		ret = hvs_update_recv_data(hvs);
> 		if (ret)
> 			return ret;
>-- 
>2.25.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

