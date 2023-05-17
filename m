Return-Path: <netdev+bounces-3266-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB6BD7064C5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA2B81C20EC5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B09156D6;
	Wed, 17 May 2023 09:58:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52FCDDBA
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:58:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209865583
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 02:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684317532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XvoIzOkIR1J1LsLE/nUjRSF5xgEoE1dCdtDep80GMs0=;
	b=gzA3Q0M6RLRUXMlDhJmCb3qxMh/jx8RorD9NpbKvxD+Qgi+7c48DrjUFvBxOiWexbfjMwf
	jGnWuXB87sgIXveYawS+IdfmHHnPUjKfk/ABx2HW+j69JH7L9dCwebkkFyWwXyo8EALoDe
	1PU9L+XJmDTLqXNViyGo/xQHi2EVszY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-nGdXZ3fIMcKo3NXKGv_8pA-1; Wed, 17 May 2023 05:58:50 -0400
X-MC-Unique: nGdXZ3fIMcKo3NXKGv_8pA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-61b7bb55ec2so3041826d6.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 02:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684317530; x=1686909530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XvoIzOkIR1J1LsLE/nUjRSF5xgEoE1dCdtDep80GMs0=;
        b=Rj7A/zrT1aRoEbuBMoV/hVZzdqB4Jz1mswfkssJOrI0jM4sijVoEopN+0pQe9WQT/7
         LyRIuuC+bJ75BWdwPr3TVpct+ln76UqIjGFKHDwa0gVn+DF0DDH86GvDb6HkuLH07Pbn
         02QfyujOeKRVpIGkM+qD8hUbDRgs7BJ7ZSzemrvSFjTYRx5eftaVwndDvqef47RQV4tO
         eRc47rk17AsAy8KzgUWulo6S49duul4xE2VZJhNEiMtGjV6IDG/IS9b8rmqTqHFCGFek
         q/j+TokiYQxCmqptMMiRxz/XLdL75lWyQFNmsFSernmUCSI4tad3smWH6BmgSBPkk5SC
         WE9w==
X-Gm-Message-State: AC+VfDyYbiyySs7Qg4W7Dvz086tD1i3HaSYZ0A8MEmz9DLqgdiMw96HA
	tA2sJnBxvTwLLtGGADnfUsdwUjJqVPm7r5QQtRRp4ndTjD9L9Ko2F9QftA//8iiKmMmum1rdGLj
	CrVDjZqkyp4KWYaI4
X-Received: by 2002:a05:6214:628:b0:5d5:fd1d:6ef5 with SMTP id a8-20020a056214062800b005d5fd1d6ef5mr63688026qvx.12.1684317530456;
        Wed, 17 May 2023 02:58:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5omh38gvqlHPQ3AppzUhAtOUH9IqRQ5N3ueu2cT2/0TKKnnps0GXvSddPWfKvZgFaJom5GGA==
X-Received: by 2002:a05:6214:628:b0:5d5:fd1d:6ef5 with SMTP id a8-20020a056214062800b005d5fd1d6ef5mr63688012qvx.12.1684317530215;
        Wed, 17 May 2023 02:58:50 -0700 (PDT)
Received: from localhost ([37.161.95.186])
        by smtp.gmail.com with ESMTPSA id p18-20020a0ccb92000000b0061acac1e61bsm6266031qvk.39.2023.05.17.02.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 02:58:49 -0700 (PDT)
Date: Wed, 17 May 2023 11:58:43 +0200
From: Andrea Claudi <aclaudi@redhat.com>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v2] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZGSlU4bW+AmIr2MD@renaissance-vector>
References: <20230516140457.22366-1-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516140457.22366-1-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 10:04:57PM +0800, Vladimir Nikishkin wrote:
> Add userspace support for the [no]localbypass vxlan netlink
> attribute. With localbypass on (default), the vxlan driver processes
> the packets destined to the local machine by itself, bypassing the
> nework stack. With nolocalbypass the packets are always forwarded to
> the userspace network stack, so usepspace programs, such as tcpdump
> have a chance to process them.
> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> ---
> v2: this patch matches commit 69474a8a5837be63f13c6f60a7d622b98ed5c539
> in the main tree.
> 
>  ip/iplink_vxlan.c     | 19 +++++++++++++++++++
>  man/man8/ip-link.8.in | 10 ++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
> index c7e0e1c4..98fbc65c 100644
> --- a/ip/iplink_vxlan.c
> +++ b/ip/iplink_vxlan.c
> @@ -45,6 +45,7 @@ static void print_explain(FILE *f)
>  		"		[ [no]remcsumtx ] [ [no]remcsumrx ]\n"
>  		"		[ [no]external ] [ gbp ] [ gpe ]\n"
>  		"		[ [no]vnifilter ]\n"
> +		"		[ [no]localbypass ]\n"
>  		"\n"
>  		"Where:	VNI	:= 0-16777215\n"
>  		"	ADDR	:= { IP_ADDRESS | any }\n"
> @@ -276,6 +277,12 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
>  		} else if (!matches(*argv, "noudpcsum")) {
>  			check_duparg(&attrs, IFLA_VXLAN_UDP_CSUM, *argv, *argv);
>  			addattr8(n, 1024, IFLA_VXLAN_UDP_CSUM, 0);
> +		} else if (0 == strcmp(*argv, "localbypass")) {
> +			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
> +			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 1);
> +		} else if (0 == strcmp(*argv, "nolocalbypass")) {
> +			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
> +			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 0);
>  		} else if (!matches(*argv, "udp6zerocsumtx")) {
>  			check_duparg(&attrs, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
>  				     *argv, *argv);
> @@ -613,6 +620,18 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>  		}
>  	}
>  
> +	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
> +		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
> +
> +		if (is_json_context()) {
> +			print_bool(PRINT_ANY, "localbypass", NULL, localbypass);
> +		} else {
> +			if (!localbypass)
> +				fputs("no", f);
> +			fputs("localbypass ", f);
> +		}

Please use print_* functions for non-json output, too.

Also, you don't need to use is_json_context() here, you can simply use
PRINT_JSON to ensure that info is printed only for json output.

Something like this should work:

+		print_bool(PRINT_JSON, "localbypass", NULL, localbypass);
+		if (localbypass) {
+			print_string(PRINT_FP, NULL, "localbypass ", NULL);
+		} else {
+			print_string(PRINT_FP, NULL, "nolocalbypass ", NULL);
+		}

> +	}
> +
>  	if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
>  		__u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]);
>  
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index bf3605a9..e53efc45 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -630,6 +630,8 @@ the following additional arguments are supported:
>  ] [
>  .RB [ no ] udpcsum
>  ] [
> +.RB [ no ] localbypass
> +] [
>  .RB [ no ] udp6zerocsumtx
>  ] [
>  .RB [ no ] udp6zerocsumrx
> @@ -734,6 +736,14 @@ are entered into the VXLAN device forwarding database.
>  .RB [ no ] udpcsum
>  - specifies if UDP checksum is calculated for transmitted packets over IPv4.
>  
> +.sp
> +.RB [ no ] localbypass
> +- if fdb destination is local, with nolocalbypass set, forward packets
> +to the userspace network stack. If there is a userspace process
> +listening for these packets, it will have a chance to process them.
> +If localbypass is active (default), bypass the network stack and
> +inject the packet into the driver directly.
> +
>  .sp
>  .RB [ no ] udp6zerocsumtx
>  - skip UDP checksum calculation for transmitted packets over IPv6.
> -- 
> 2.35.8
> 
> --
> Fastmail.
> 
> 


