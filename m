Return-Path: <netdev+bounces-5159-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4067970FD7A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 20:06:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC2361C20BA2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D431D2E3;
	Wed, 24 May 2023 18:06:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEB6C13A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 18:06:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EC512F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684951584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ju/p2u+a4gVhg2Ic2qOwycvH0K+jz2K0TMOZpQPXaPM=;
	b=X1wQrRghg6Lt9ybRjD3CB9FJLlT4igEWWjDs1Yqlx+Txv8YC5iKaAQgS3UdWcDy0Ovi0dh
	Cxdx771fvml4ybHFGcECdqBrAL/iUNoAKV3gbeyE3TSUUJtk7Kn8lIWEskVq9krH7e08Wa
	bY7VWhdWhBYEb5Gv0BLlt2jeFD48J2c=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-EiF4mIC3MMidlDN3tNT1Gw-1; Wed, 24 May 2023 14:06:22 -0400
X-MC-Unique: EiF4mIC3MMidlDN3tNT1Gw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-75b1bc4a19aso4659285a.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684951582; x=1687543582;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ju/p2u+a4gVhg2Ic2qOwycvH0K+jz2K0TMOZpQPXaPM=;
        b=ctE3m9UCMtsWr6gYulbPV0bSNrpqsF793eM92N1r+jrTbrsdhKsIQrS3jIQEtOz8s8
         FFiwlkf1sMoJP7Vc99OUSpCYsbf5ux3jx1M4l1vBCyimauOzDJCoBpbJXRklQLTh/la+
         fv6tCGCFLeTd53och5mobzo8R/uq454EYp112aNlCWDz/bU3S1gQ8YwMYqrxTQZAaw6J
         041HTf1LHKZtnCqhNKRoIeCJ/CW5Z+S8SD3PY5q+/Nays9pvOKzEnbZRFueZ5L0kzCcw
         RT4ueNuisa6BNQg+k5BuNJw6TjfgzpEjee7rIwVzAj7Q+ngqtMJ4vgmRWQzgsDkZE24G
         58Cw==
X-Gm-Message-State: AC+VfDyQGLDGtm1mjV5jA66nQ/gT13zcYJqV35hSn9ESHUQ3aU0j+t3U
	V2xoSvGnpAWe6DgBkSej5gROxzoL8o8dfmZiCWL8DlgSajeCWZLwvmcx43o9Huj21XheJPji1IB
	rxG37MbpuJ+D8j49AyxeJmHwPZwo=
X-Received: by 2002:a05:620a:b0c:b0:75b:23a1:d85a with SMTP id t12-20020a05620a0b0c00b0075b23a1d85amr219618qkg.28.1684951581756;
        Wed, 24 May 2023 11:06:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5lDHSufB1IGi/PEy8BcsoQ5Nh95+6p0yXBDlQZzT47UiOvqSPaKjnWdU/grhaX25NmYqlLoQ==
X-Received: by 2002:a05:620a:b0c:b0:75b:23a1:d85a with SMTP id t12-20020a05620a0b0c00b0075b23a1d85amr219594qkg.28.1684951581391;
        Wed, 24 May 2023 11:06:21 -0700 (PDT)
Received: from localhost ([37.162.144.87])
        by smtp.gmail.com with ESMTPSA id f3-20020a0cbec3000000b005dd8b934579sm21632qvj.17.2023.05.24.11.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 11:06:20 -0700 (PDT)
Date: Wed, 24 May 2023 20:06:15 +0200
From: Andrea Claudi <aclaudi@redhat.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org
Subject: Re: [RFC 2/2] vxlan: make option printing more consistent
Message-ID: <ZG5SF/8CLymhAQsT@renaissance-vector>
References: <20230523165932.8376-1-stephen@networkplumber.org>
 <20230523165932.8376-2-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523165932.8376-2-stephen@networkplumber.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 09:59:32AM -0700, Stephen Hemminger wrote:
> Add new helper function print_bool_opt() which prints
> with no prefix and use it for vxlan options.
> 
> Based on discussion around how to handle new localbypass option.
> Initial version of this was from Ido Schimmel.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  include/json_print.h |  9 +++++
>  ip/iplink_vxlan.c    | 80 ++++++++++++++++----------------------------
>  lib/json_print.c     | 18 ++++++++++
>  3 files changed, 55 insertions(+), 52 deletions(-)
> 
> diff --git a/include/json_print.h b/include/json_print.h
> index 91b34571ceb0..4d165a91c23a 100644
> --- a/include/json_print.h
> +++ b/include/json_print.h
> @@ -101,6 +101,15 @@ static inline int print_rate(bool use_iec, enum output_type t,
>  	return print_color_rate(use_iec, t, COLOR_NONE, key, fmt, rate);
>  }
>  
> +int print_color_bool_opt(enum output_type type, enum color_attr color,
> +			 const char *key, bool value);
> +
> +static inline int print_bool_opt(enum output_type type,
> +				 const char *key, bool value)
> +{
> +	return print_color_bool_opt(type, COLOR_NONE, key, value);
> +}
> +
>  /* A backdoor to the size formatter. Please use print_size() instead. */
>  char *sprint_size(__u32 sz, char *buf);
>  
> diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
> index cb6745c74507..292e19cdb940 100644
> --- a/ip/iplink_vxlan.c
> +++ b/ip/iplink_vxlan.c
> @@ -427,15 +427,13 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>  	if (!tb)
>  		return;
>  
> -	if (tb[IFLA_VXLAN_COLLECT_METADATA] &&
> -	    rta_getattr_u8(tb[IFLA_VXLAN_COLLECT_METADATA])) {
> -		print_bool(PRINT_ANY, "external", "external ", true);
> -	}
> +	if (tb[IFLA_VXLAN_COLLECT_METADATA])
> +		print_bool_opt(PRINT_ANY, "external",
> +			       rta_getattr_u8(tb[IFLA_VXLAN_COLLECT_METADATA]));
>  
> -	if (tb[IFLA_VXLAN_VNIFILTER] &&
> -	    rta_getattr_u8(tb[IFLA_VXLAN_VNIFILTER])) {
> -		print_bool(PRINT_ANY, "vnifilter", "vnifilter", true);
> -	}
> +	if (tb[IFLA_VXLAN_VNIFILTER])
> +		print_bool_opt(PRINT_ANY, "vnifilter",
> +			       rta_getattr_u8(tb[IFLA_VXLAN_VNIFILTER]));
>  
>  	if (tb[IFLA_VXLAN_ID] &&
>  	    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) >= sizeof(__u32)) {
> @@ -532,22 +530,24 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>  	if (tb[IFLA_VXLAN_LEARNING]) {
>  		__u8 learning = rta_getattr_u8(tb[IFLA_VXLAN_LEARNING]);
>  
> -		print_bool(PRINT_JSON, "learning", NULL, learning);
> -		if (!learning)
> -			print_bool(PRINT_FP, NULL, "nolearning ", true);
> +		print_bool_opt(PRINT_ANY, "learning", learning);
>  	}
>  
> -	if (tb[IFLA_VXLAN_PROXY] && rta_getattr_u8(tb[IFLA_VXLAN_PROXY]))
> -		print_bool(PRINT_ANY, "proxy", "proxy ", true);
> +	if (tb[IFLA_VXLAN_PROXY])
> +		print_bool_opt(PRINT_ANY, "proxy",
> +			       rta_getattr_u8(tb[IFLA_VXLAN_PROXY]));
>  
> -	if (tb[IFLA_VXLAN_RSC] && rta_getattr_u8(tb[IFLA_VXLAN_RSC]))
> -		print_bool(PRINT_ANY, "rsc", "rsc ", true);
> +	if (tb[IFLA_VXLAN_RSC])
> +		print_bool_opt(PRINT_ANY, "rsc",
> +			       rta_getattr_u8(tb[IFLA_VXLAN_RSC]));
>  
> -	if (tb[IFLA_VXLAN_L2MISS] && rta_getattr_u8(tb[IFLA_VXLAN_L2MISS]))
> -		print_bool(PRINT_ANY, "l2miss", "l2miss ", true);
> +	if (tb[IFLA_VXLAN_L2MISS])
> +		print_bool_opt(PRINT_ANY, "l2miss",
> +			       rta_getattr_u8(tb[IFLA_VXLAN_L2MISS]));
>  
> -	if (tb[IFLA_VXLAN_L3MISS] && rta_getattr_u8(tb[IFLA_VXLAN_L3MISS]))
> -		print_bool(PRINT_ANY, "l3miss", "l3miss ", true);
> +	if (tb[IFLA_VXLAN_L3MISS])
> +		print_bool_opt(PRINT_ANY, "l3miss",
> +			       rta_getattr_u8(tb[IFLA_VXLAN_L3MISS]));
>  
>  	if (tb[IFLA_VXLAN_TOS])
>  		tos = rta_getattr_u8(tb[IFLA_VXLAN_TOS]);
> @@ -604,51 +604,27 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>  	if (tb[IFLA_VXLAN_UDP_CSUM]) {
>  		__u8 udp_csum = rta_getattr_u8(tb[IFLA_VXLAN_UDP_CSUM]);
>  
> -		if (is_json_context()) {
> -			print_bool(PRINT_ANY, "udp_csum", NULL, udp_csum);
> -		} else {
> -			if (!udp_csum)
> -				fputs("no", f);
> -			fputs("udpcsum ", f);
> -		}
> +		print_bool_opt(PRINT_ANY, "udp_csum", udp_csum);
>  	}
>  
>  	if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
>  		__u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]);
>  
> -		if (is_json_context()) {
> -			print_bool(PRINT_ANY,
> -				   "udp_zero_csum6_tx", NULL, csum6);
> -		} else {
> -			if (!csum6)
> -				fputs("no", f);
> -			fputs("udp6zerocsumtx ", f);
> -		}
> +		print_bool_opt(PRINT_ANY, "udp_zero_csum6_tx",  csum6);
>  	}
>  
>  	if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_RX]) {
>  		__u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_RX]);
>  
> -		if (is_json_context()) {
> -			print_bool(PRINT_ANY,
> -				   "udp_zero_csum6_rx",
> -				   NULL,
> -				   csum6);
> -		} else {
> -			if (!csum6)
> -				fputs("no", f);
> -			fputs("udp6zerocsumrx ", f);
> -		}
> +		print_bool_opt(PRINT_ANY, "udp_zero_csum6_rx",  csum6);
>  	}
>  
> -	if (tb[IFLA_VXLAN_REMCSUM_TX] &&
> -	    rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_TX]))
> -		print_bool(PRINT_ANY, "remcsum_tx", "remcsumtx ", true);
> -
> -	if (tb[IFLA_VXLAN_REMCSUM_RX] &&
> -	    rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_RX]))
> -		print_bool(PRINT_ANY, "remcsum_rx", "remcsumrx ", true);
> -
> +	if (tb[IFLA_VXLAN_REMCSUM_TX])
> +		print_bool_opt(PRINT_ANY, "remcsum_tx",
> +			       rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_TX]));
> +	if (tb[IFLA_VXLAN_REMCSUM_RX])
> +		print_bool_opt(PRINT_ANY, "remcsum_rx",
> +			       rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_RX]));
>  	if (tb[IFLA_VXLAN_GBP])
>  		print_null(PRINT_ANY, "gbp", "gbp ", NULL);
>  	if (tb[IFLA_VXLAN_GPE])
> diff --git a/lib/json_print.c b/lib/json_print.c
> index d7ee76b10de8..29959e7335c3 100644
> --- a/lib/json_print.c
> +++ b/lib/json_print.c
> @@ -215,6 +215,24 @@ int print_color_bool(enum output_type type,
>  				  value ? "true" : "false");
>  }
>  
> +/* In JSON mode, acts like print_color_bool
> + * otherwise, prints key with no prefix if false
> + */
> +int print_color_bool_opt(enum output_type type,
> +			 enum color_attr color,
> +			 const char *key,
> +			 bool value)
> +{
> +	int ret = 0;
> +
> +	if (_IS_JSON_CONTEXT(type))
> +		jsonw_bool_field(_jw, key, value);
> +	else if (_IS_FP_CONTEXT(type))
> +		ret = color_fprintf(stdout, color, "%s%s ",
> +				    value ? "" : "no", key);
> +	return ret;
> +}
> +
>  int print_color_on_off(enum output_type type,
>  		       enum color_attr color,
>  		       const char *key,
> -- 
> 2.39.2
> 
>

Thanks Stephen for pointing this series out to me, I overlooked it due
to the missing "iproute" in the subject.

I'm fine with the JSON result, having all params printed out is much
better than the current output.

My main objection to this is the non-JSON output result. Let's compare
the current output with the one resulting from this RFC:

$ ip link add type vxlan id 12
$ ip -d link show vxlan0
79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    vxlan id 12 srcport 0 0 dstport 8472 ttl auto ageing 300 udpcsum noudp6zerocsumtx noudp6zerocsumrx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 65536 tso_max_segs 65535 gro_max_size 65536

$ ip.new -d link show vxlan0
79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535
    vxlan noexternal id 12 srcport 0 0 dstport 8472 learning noproxy norsc nol2miss nol3miss ttl auto ageing 300 udp_csum noudp_zero_csum6_tx noudp_zero_csum6_rx noremcsum_tx noremcsum_rx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 65536 tso_max_segs 65535 gro_max_size 65536

In my opinion, the new output is much longer and less human-readable.
The main problem (besides intermixed boolean and numerical params) is
that we have a lot of useless info. If the ARP proxy is turned off,
what's the use of "noproxy" over there? Let's not print anything at all,
I don't expect to find anything about proxy in the output if I'm not
asking to have it. It seems to me the same can be said for all the
"no"-params over there.

What I'm proposing is something along this line:

+int print_color_bool_opt(enum output_type type,
+			 enum color_attr color,
+			 const char *key,
+			 bool value)
+{
+	int ret = 0;
+
+	if (_IS_JSON_CONTEXT(type))
+		jsonw_bool_field(_jw, key, value);
+	else if (_IS_FP_CONTEXT(type) && value)
+		ret = color_fprintf(stdout, color, "%s ", key);
+	return ret;
+}

This should lead to no change in the JSON output w.r.t. this patch, and
to this non-JSON output

79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    vxlan id 12 srcport 0 0 dstport 8472 learning ttl auto ageing 300 udp_csum addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 65536 tso_max_segs 65535 gro_max_size 65536

that seems to me much more clear and concise.

What do you think?
Andrea


