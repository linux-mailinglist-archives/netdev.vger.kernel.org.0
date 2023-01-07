Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7F7661166
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 20:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbjAGTtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 14:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAGTtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 14:49:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF7F482A6
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 11:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673120937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PlQy9ZGQk+Wo1lYz7pXyaK/XiWsZDpuOVw+o6IN3zo0=;
        b=at2MPcSAwnmZUaJE5nOubBYjS2iN3hGfyv/Ky2wuWhwAyGHABzdK+gx9hxS2bfp+XWxg2Z
        agQt8pih/TQUJmo7A2730ptx8bhM4Cc0w1h20lYj+/ijsFa+MtCWjo9jmO0PGgeZkgpxAq
        Qjay9F2CMjw69FYcCn2oqQtMahgGPZg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-11YllnqoPzWEcwitWZ1oKg-1; Sat, 07 Jan 2023 14:48:55 -0500
X-MC-Unique: 11YllnqoPzWEcwitWZ1oKg-1
Received: by mail-qt1-f200.google.com with SMTP id e18-20020ac845d2000000b003a6a5cbbebcso2531796qto.20
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 11:48:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PlQy9ZGQk+Wo1lYz7pXyaK/XiWsZDpuOVw+o6IN3zo0=;
        b=5mYXefbDgfBH9LxrqrYX00ypk/k0pm84tbyGxMmST1ImLaRkVoBRnk99HWQ+w5Brhp
         BqWa0mfL8hBDibcSFezMTtVFibxyHEZQc2krikgci3uPExx7rT101Ti75/AQcAZMklA/
         qfD56SVvOHdiesWt7WTE+ZdcFtVtF/MuxC2zFq8TrqEv3UugLnUeY1e2H1r7XV7BYGQ2
         XpI8kvdxIRLyeaSrenc8ffGokBQISRNBO9jNgLkheptJ686IKjBy5AaE9JZieFM+XQSF
         afGsgizyDeQkZcAKTzUcfDDaDLlZ6P7DRq4sInQXEVqowiXBu6QbHc3AoH+938cVuVjj
         hcJg==
X-Gm-Message-State: AFqh2kqEu6qbHdlWqoQbdQ+cZVMkClC3aoebU92G8hZwQurUBV2YFqgE
        7RBvNWi4nzjxTfd2lxkL52+1jl0xTz/+OThIatH6x66dmz1ULcwWIpDOTL2x/SDrS5Jku9zllJD
        HcNzOZnuRZ6+PYZUf
X-Received: by 2002:ac8:74d1:0:b0:3a8:e35:257e with SMTP id j17-20020ac874d1000000b003a80e35257emr78499948qtr.20.1673120935511;
        Sat, 07 Jan 2023 11:48:55 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtYRgQblr+bBowAAPHwzxPeAaG69E+EDjs9HjHmnpOcHfZ86h6MBkbMQyk3+X+Fs0yKCeJQ7g==
X-Received: by 2002:ac8:74d1:0:b0:3a8:e35:257e with SMTP id j17-20020ac874d1000000b003a80e35257emr78499935qtr.20.1673120935209;
        Sat, 07 Jan 2023 11:48:55 -0800 (PST)
Received: from debian (2a01cb058918ce0098fed9113971adae.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:98fe:d911:3971:adae])
        by smtp.gmail.com with ESMTPSA id y11-20020a05620a25cb00b006bbf85cad0fsm2637215qko.20.2023.01.07.11.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 11:48:54 -0800 (PST)
Date:   Sat, 7 Jan 2023 20:48:51 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, g.nault@alphalink.fr,
        Cong Wang <cong.wang@bytedance.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net 1/2] l2tp: convert l2tp_tunnel_list to idr
Message-ID: <Y7nMo02WWWwoGmv0@debian>
References: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
 <20230105191339.506839-2-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105191339.506839-2-xiyou.wangcong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 11:13:38AM -0800, Cong Wang wrote:
> +int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id,
> +		       u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg,
> +		       struct l2tp_tunnel **tunnelp)
>  {
>  	struct l2tp_tunnel *tunnel = NULL;
>  	int err;
>  	enum l2tp_encap_type encap = L2TP_ENCAPTYPE_UDP;
> +	struct l2tp_net *pn = l2tp_pernet(net);
>  
>  	if (cfg)
>  		encap = cfg->encap;
>  
> +	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
> +	err = idr_alloc_u32(&pn->l2tp_tunnel_idr, NULL, &tunnel_id, tunnel_id,
> +			    GFP_ATOMIC);
> +	if (err) {
> +		spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
> +		return err;
> +	}
> +	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);

Why reserving the tunnel_id in l2tp_tunnel_create()? This function is
supposed to just allocate a structure and pre-initialise some fields.
The only cleanup required upon error after this call is to kfree() the
new structure. So I can't see any reason to guarantee the id will be
accepted by the future l2tp_tunnel_register() call.

Looks like you could reserve the id at the beginning of
l2tp_tunnel_register() instead. That'd avoid changing the API and thus
the side effects on l2tp_{ppp,netlink}.c. Also we wouldn't need create
l2tp_tunnel_remove().

