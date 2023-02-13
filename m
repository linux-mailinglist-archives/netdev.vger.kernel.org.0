Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9BD694928
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 15:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjBMO4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 09:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjBMO4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 09:56:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500F417145
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 06:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676300130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zl63jsky81erb0FQXv5yXqKKrGCIcE7sOvGJJky9NkM=;
        b=Qw+TPfCKwTpto8vxn2oCXNfSQ/b6pVqoTk5MLXfLifBujeH+tLWsqrh+8JEZYceDZgVf0F
        xbYpYyJ+zjoKkGMtqWbpRSO4PgCnSsgyrZiJVJjrNc2BXmKJFrMfjQSh2MAKW3rzeKcUA9
        ejauTT4ofs6MYvwriOBhVqWNeS4ju9A=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-djH-2buCPCiupL10nUpyhQ-1; Mon, 13 Feb 2023 09:55:29 -0500
X-MC-Unique: djH-2buCPCiupL10nUpyhQ-1
Received: by mail-qk1-f197.google.com with SMTP id 130-20020a370588000000b0072fcbe20069so7665323qkf.22
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 06:55:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zl63jsky81erb0FQXv5yXqKKrGCIcE7sOvGJJky9NkM=;
        b=ebRMNXr57fU85ECTgcM30/kxc4oN6547NIGGfOFTzHx+NQPv6P0/1orjGL8BbN68sC
         eI3SpwQVLdaVxlq7soaDT1EePWt+megGZUtl1K3WokD0vJHssvkOB0vTpJ1wfo3yjmwb
         XRbDZs2JuB47bNoz562RGtSCDi0Er3plAXfAdNEAn/fCSrN0lEauHwwSNq3N02ZWEntj
         bWQDVM6S/9yYENbcHrmHHSb4oWQHazdjdfRoy7Z5vxfwcTMj6JWQyyeG7nwKGrk+7Bma
         03HPJZgXyt+5x2gW+BI8EDNey6KXsCqwoCoHGdfHj38UbKOLzszJCy9PzEnUZvTdzqA5
         u3bg==
X-Gm-Message-State: AO0yUKW02eE+bfuMfgiQNJijgHZ+hZAwBwfJBGCbQccVTL7ecX2WjJ48
        tX8ca0sca5jFJ8JYV5unW05uoiKLeJIDzzM8e6+AA+BVmhJUVbyTizG5qH2Ty6FUoGg93/SKxNJ
        5EL2g81b/xIEIoCCiGo8qkg==
X-Received: by 2002:a05:622a:4084:b0:3b9:bc8c:c20e with SMTP id cg4-20020a05622a408400b003b9bc8cc20emr22774277qtb.25.1676300128409;
        Mon, 13 Feb 2023 06:55:28 -0800 (PST)
X-Google-Smtp-Source: AK7set/voaD06hHqmVn8o1/r1OntQREu64g27uMIQbxbd8hliMG2MSEOcwYxRW8AwbTRvID0EMlAWA==
X-Received: by 2002:a05:622a:4084:b0:3b9:bc8c:c20e with SMTP id cg4-20020a05622a408400b003b9bc8cc20emr22774247qtb.25.1676300128108;
        Mon, 13 Feb 2023 06:55:28 -0800 (PST)
Received: from debian (2a01cb058918ce0052a1c4711233f5f0.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:52a1:c471:1233:f5f0])
        by smtp.gmail.com with ESMTPSA id u123-20020a379281000000b0073b4d9e2e8dsm722213qkd.43.2023.02.13.06.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 06:55:27 -0800 (PST)
Date:   Mon, 13 Feb 2023 15:55:24 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     jchapman@katalix.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] l2tp: Avoid possible recursive deadlock in
 l2tp_tunnel_register()
Message-ID: <Y+pPXOqfrYkXPg1K@debian>
References: <20230212162623.2301597-1-syoshida@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230212162623.2301597-1-syoshida@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 01:26:23AM +0900, Shigeru Yoshida wrote:
> +static struct l2tp_tunnel *pppol2tp_tunnel_get(struct net *net,
> +					       struct l2tp_connect_info *info,

Please make "*info" const.

> +					       bool *new_tunnel)
> +{
> +	struct l2tp_tunnel *tunnel;
> +	int error;
> +
> +	*new_tunnel = false;
> +
> +	tunnel = l2tp_tunnel_get(net, info->tunnel_id);
> +
> +	/* Special case: create tunnel context if session_id and
> +	 * peer_session_id is 0. Otherwise look up tunnel using supplied
> +	 * tunnel id.
> +	 */
> +	if (!info->session_id && !info->peer_session_id) {
> +		if (!tunnel) {
> +			struct l2tp_tunnel_cfg tcfg = {
> +				.encap = L2TP_ENCAPTYPE_UDP,
> +			};
> +
> +			/* Prevent l2tp_tunnel_register() from trying to set up
> +			 * a kernel socket.
> +			 */
> +			if (info->fd < 0)
> +				return ERR_PTR(-EBADF);
> +
> +			error = l2tp_tunnel_create(info->fd,
> +						   info->version,
> +						   info->tunnel_id,
> +						   info->peer_tunnel_id, &tcfg,
> +						   &tunnel);
> +			if (error < 0)
> +				return ERR_PTR(error);
> +
> +			l2tp_tunnel_inc_refcount(tunnel);
> +			error = l2tp_tunnel_register(tunnel, net, &tcfg);
> +			if (error < 0) {
> +				kfree(tunnel);
> +				return ERR_PTR(error);
> +			}
> +
> +			*new_tunnel = true;
> +		}
> +	} else {
> +		/* Error if we can't find the tunnel */
> +		if (!tunnel)
> +			return ERR_PTR(-ENOENT);
> +
> +		/* Error if socket is not prepped */
> +		if (!tunnel->sock) {
> +			l2tp_tunnel_dec_refcount(tunnel);
> +			return ERR_PTR(-ENOENT);
> +		}
> +	}
> +
> +	return tunnel;
> +}
> +
>  /* connect() handler. Attach a PPPoX socket to a tunnel UDP socket
>   */
>  static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
> @@ -663,7 +722,6 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
>  	struct pppol2tp_session *ps;
>  	struct l2tp_session_cfg cfg = { 0, };
>  	bool drop_refcnt = false;
> -	bool drop_tunnel = false;
>  	bool new_session = false;
>  	bool new_tunnel = false;
>  	int error;
> @@ -672,6 +730,10 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
>  	if (error < 0)
>  		return error;
>  
> +	tunnel = pppol2tp_tunnel_get(sock_net(sk), &info, &new_tunnel);
> +	if (IS_ERR(tunnel))
> +		return PTR_ERR(tunnel);
> +
>  	lock_sock(sk);
>  
>  	/* Check for already bound sockets */
> @@ -689,57 +751,6 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
>  	if (!info.tunnel_id)
>  		goto end;

The original code did test info.tunnel_id before trying to get or
create the tunnel (as it doesn't make sense to work on a tunnel whose
ID is 0). So we need move this test before the pppol2tp_tunnel_get()
call.

> -	tunnel = l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
> -	if (tunnel)
> -		drop_tunnel = true;
> -
> -	/* Special case: create tunnel context if session_id and
> -	 * peer_session_id is 0. Otherwise look up tunnel using supplied
> -	 * tunnel id.
> -	 */

Just a note for your future submissions: for networking patches, we
normally indicate which tree the patch is targetted to in the mail
subject (for example "[PATCH net v2]"). Also, you should Cc:
the author of the patch listed in the Fixes tag.

