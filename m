Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDA5502DA0
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355771AbiDOQSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355761AbiDOQSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:18:35 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C53097BA2;
        Fri, 15 Apr 2022 09:16:07 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s25so9944877edi.13;
        Fri, 15 Apr 2022 09:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mj8Kd2iaxdzZLtP+lkn5ZFqD1Z3Svx/w2u5MGhXQFl4=;
        b=bI5nLF7gOH5fv+8CP/CcpZvHtE/YkpEJ7pdSo6kPPHCCY1r5/XqoNcnQ1uaxXY+dZP
         yj0nBoF5wG4uOR3ic7tkxW+2Q7fON1wnFMlREAfAE3XIgGj6J/mluz9sK6iRhH/LR/34
         ly3rUt0CTm5jYczR93kve/CY9CHWsfbVUwigeBqIUyIpSRVnlyhw0f02QvA1eqpDDn6Y
         x1vyb4yjGlGvEMlnsWy7rUglQ1c8IYQ2YWWCdt/CPrAu55z70tFfAKeFNMe0XMmMV9Rz
         /x+87a1EmR21GeZmbhXd5QMkf3FomJ+tmVuex1tGqZKJX13mvnbxBl/JPADUWhwqwtNM
         sAdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mj8Kd2iaxdzZLtP+lkn5ZFqD1Z3Svx/w2u5MGhXQFl4=;
        b=Bc+g8kMDyLS1Y9VOjy/IzKpw9y1dhJhUCGNzB5hDWFdvC6eeaHXxHJEkmQxsBTSJGM
         KxNbUGEzxLlVCO8Z4wxIJFDS7I8MP8YnTi4RFI68x0u0knYooXJ83J6OymOb5gcKkzmZ
         i3iSGvW0OfoIrTyma9eAb6F1NdpaKf5fwzMhuI8JQhJ6aSfvT5B35KSPZsAzNuy6gVUo
         SZ8US+LsUTm8bvyESZhTLe1WAW8UTXJhGfssAGKMfPJKYW2fgMvSspSciXDDgnqamxYs
         wFlbUlQOJ+AvyUkc3MvkILrHUkZwZtruTVyNl50Bugto+suVd2VmwuXlJ2CWt0KjvL/3
         t2Wg==
X-Gm-Message-State: AOAM531AppofaXAeF9VdhMe8xTu/r794vMlqepmO/QuCPeM2RvOad0Ad
        ElOCXt3fjdliT30BEolv8KgMk3Abu+b11cpU
X-Google-Smtp-Source: ABdhPJyHwgUdfR3xOYg50OKEZyOpA7BGxyjG+xURtu5uCfd+kRod+JU/CISItj+ytt0oHpzfnDHFJA==
X-Received: by 2002:a50:fc89:0:b0:41d:83d1:9df3 with SMTP id f9-20020a50fc89000000b0041d83d19df3mr8753484edq.19.1650039365812;
        Fri, 15 Apr 2022 09:16:05 -0700 (PDT)
Received: from anparri (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id b7-20020a170906708700b006da8440d642sm1847640ejk.113.2022.04.15.09.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 09:16:05 -0700 (PDT)
Date:   Fri, 15 Apr 2022 18:16:02 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 4/6] hv_sock: Initialize send_buf in
 hvs_stream_enqueue()
Message-ID: <20220415161602.GB47428@anparri>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-5-parri.andrea@gmail.com>
 <PH0PR21MB3025F58A2536209ED3785F24D7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
 <20220415065041.GC2961@anparri>
 <PH0PR21MB302526F1483A6FC932AC55CFD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR21MB302526F1483A6FC932AC55CFD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > All fields are explicitly initialized, and in the data
> > > array, only the populated bytes are copied to the ring buffer.  There should not
> > > be any uninitialized values sent to the host.   Zeroing the memory ahead of
> > > time certainly provides an extra protection (particularly against padding bytes,
> > > but there can't be any since the layout of the data is part of the protocol with
> > > Hyper-V).
> > 
> > Rather than keeping checking that...
> 
> The extra protection might be obtained by just zero'ing the header (i.e., the
> bytes up to the 16 Kbyte data array).   I don't have a strong preference either
> way, so up to you.

A main reason behind this RFC is that I don't have either.  IIUC, you're
suggesting something like (the compiled only):


diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 092cadc2c866d..200f12c432863 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -234,7 +234,8 @@ static int __hvs_send_data(struct vmbus_channel *chan,
 {
 	hdr->pkt_type = 1;
 	hdr->data_size = to_write;
-	return vmbus_sendpacket(chan, hdr, sizeof(*hdr) + to_write,
+	return vmbus_sendpacket(chan, hdr,
+				offsetof(struct hvs_send_buf, data) + to_write,
 				0, VM_PKT_DATA_INBAND, 0);
 }
 
@@ -658,6 +659,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
 	send_buf = kmalloc(sizeof(*send_buf), GFP_KERNEL);
 	if (!send_buf)
 		return -ENOMEM;
+	memset(send_buf, 0, offsetof(struct hvs_send_buf, data));
 
 	/* Reader(s) could be draining data from the channel as we write.
 	 * Maximize bandwidth, by iterating until the channel is found to be
-- 

Let me queue this for further testing/review...

Thanks,
  Andrea
