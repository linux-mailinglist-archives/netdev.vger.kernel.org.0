Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13717694B93
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjBMPr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjBMPrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:47:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F37E193E9
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 07:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676303161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JU5gR2JfhT2YMusgdO9Wq8a6MnhhEnF0yv/p8fHaQm8=;
        b=gdHdoX9fvCIILzLRjvtJWb3Dd+26fnPY/J3sgWHx3cQqB2SKLk+Eil6YpbxSo+oZctsdgW
        11oQC1tsjKd8kK40j0oku7a58iqq45use0Mjx0vazUCV6STWF2zzr8UQHWUxpyPfXZaKGe
        NA9kZcYioORzYYiUydHPQt0cijJxq1g=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-484-4Xyan_g1Mhy_yclqDcc0ZA-1; Mon, 13 Feb 2023 10:46:00 -0500
X-MC-Unique: 4Xyan_g1Mhy_yclqDcc0ZA-1
Received: by mail-qt1-f198.google.com with SMTP id c14-20020ac87d8e000000b003ba2d72f98aso7613981qtd.10
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 07:46:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JU5gR2JfhT2YMusgdO9Wq8a6MnhhEnF0yv/p8fHaQm8=;
        b=KJZ/FaW6XU3aTosK8hD+d0jdM/Jp5Li/33jui9g1cKQjJVv9txnejVSPLZPXLe63f0
         RrAzH3k0O2sCjv9yhqy56c1DLkWYyFRAOBIyjB45mwPmWCISyNN6eUYBOsxZMusWQePa
         3yGiHl43kaANH1STbTQkVNA4iBSgJjJgojJ7j+W8njCuTlMW5zkXaSdC98MvrOFaAZRY
         ZCHUPWlxtViFt1ANvFUP+F0L7MVS4CqdzkLpRzvA5l4SPRTpIZOx2uL4KCSKaqx97h/C
         uCzCjeebhlIqStL21BY9wXe1mxMvGDexOmvQMn/v1l0BFTP+Kiyoq99eP3T4nrpf/n7H
         CUMg==
X-Gm-Message-State: AO0yUKW0G/J8HMWOBzyrga0ggzYihPXW7ddxPPXh1I8dTgfPATWCvYXS
        JppQ5UTWvfdRab4j926CTZzCuuFo8aF/AZpeawBMhVvyOUtwYpp1XYi9GMzvz0dgH1Dr8MaeTrW
        Ye0ExJsFiaLmOrfIkvNEUbw==
X-Received: by 2002:a05:6214:e8f:b0:56e:b7a1:c7e with SMTP id hf15-20020a0562140e8f00b0056eb7a10c7emr4054956qvb.23.1676303159365;
        Mon, 13 Feb 2023 07:45:59 -0800 (PST)
X-Google-Smtp-Source: AK7set8aW7aqzIzN2tmLsHI7C7rMX+FyClrDf7lnBwRHBSw/mjp1kiMRqZ2B/NK5+xijWm2Bz+o0tQ==
X-Received: by 2002:a05:6214:e8f:b0:56e:b7a1:c7e with SMTP id hf15-20020a0562140e8f00b0056eb7a10c7emr4054919qvb.23.1676303159085;
        Mon, 13 Feb 2023 07:45:59 -0800 (PST)
Received: from debian (2a01cb058918ce0052a1c4711233f5f0.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:52a1:c471:1233:f5f0])
        by smtp.gmail.com with ESMTPSA id l68-20020a37bb47000000b00733fe2fa3a3sm9965753qkf.36.2023.02.13.07.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 07:45:58 -0800 (PST)
Date:   Mon, 13 Feb 2023 16:45:54 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Shigeru Yoshida <syoshida@redhat.com>, jchapman@katalix.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] l2tp: Avoid possible recursive deadlock in
 l2tp_tunnel_register()
Message-ID: <Y+pbMgEq0epVbB4P@debian>
References: <20230212162623.2301597-1-syoshida@redhat.com>
 <cd8907dc-0319-6c04-271c-489ca4550579@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd8907dc-0319-6c04-271c-489ca4550579@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 04:05:59PM +0100, Alexander Lobakin wrote:
> From: Shigeru Yoshida <syoshida@redhat.com>
> Date: Mon, 13 Feb 2023 01:26:23 +0900
> 
> > When a file descriptor of pppol2tp socket is passed as file descriptor
> > of UDP socket, a recursive deadlock occurs in l2tp_tunnel_register().
> > This situation is reproduced by the following program:
> 
> [...]
> 
> > +static struct l2tp_tunnel *pppol2tp_tunnel_get(struct net *net,
> > +					       struct l2tp_connect_info *info,
> > +					       bool *new_tunnel)
> > +{
> > +	struct l2tp_tunnel *tunnel;
> > +	int error;
> > +
> > +	*new_tunnel = false;
> > +
> > +	tunnel = l2tp_tunnel_get(net, info->tunnel_id);
> > +
> > +	/* Special case: create tunnel context if session_id and
> > +	 * peer_session_id is 0. Otherwise look up tunnel using supplied
> > +	 * tunnel id.
> > +	 */
> > +	if (!info->session_id && !info->peer_session_id) {
> > +		if (!tunnel) {
> 
> This `if` is the sole thing the outer `if` contains, could we combine them?

The logic of this code is a bit convoluted, sure, but if we want to
rework it, let's simplify it for real:

	tunnel = l2tp_tunnel_get(...)
	if (tunnel)
		return tunnel; /* the original !tunnel->sock test is useless I believe */

	/* Tunnel not found. Try to create one if both session_id and
	 * peer_session_id are 0. Fail otherwise.
	 */
	if (info->session_id || info->peer_session_id)
		return ERR_PTR(-ENOENT);

	[...] /* Tunnel creation code */


However, I'd prefer to keep such refactoring for later. Keeping the
same structure in pppol2tp_tunnel_get() as in the original code helps
reviewing the patch.

> > +			struct l2tp_tunnel_cfg tcfg = {
> > +				.encap = L2TP_ENCAPTYPE_UDP,
> > +			};
> > +
> > +			/* Prevent l2tp_tunnel_register() from trying to set up
> > +			 * a kernel socket.
> > +			 */
> > +			if (info->fd < 0)
> > +				return ERR_PTR(-EBADF);
> > +
> > +			error = l2tp_tunnel_create(info->fd,
> > +						   info->version,
> 
> This fits into the prev line.
> 
> > +						   info->tunnel_id,
> > +						   info->peer_tunnel_id, &tcfg,
> > +						   &tunnel);
> > +			if (error < 0)
> > +				return ERR_PTR(error);
> > +
> > +			l2tp_tunnel_inc_refcount(tunnel);
> > +			error = l2tp_tunnel_register(tunnel, net, &tcfg);
> > +			if (error < 0) {
> > +				kfree(tunnel);
> > +				return ERR_PTR(error);
> > +			}
> > +
> > +			*new_tunnel = true;
> > +		}
> > +	} else {
> > +		/* Error if we can't find the tunnel */
> > +		if (!tunnel)
> > +			return ERR_PTR(-ENOENT);
> 
> [...]
> 
> Thanks,
> Olek
> 

