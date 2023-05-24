Return-Path: <netdev+bounces-5163-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 556CC70FDF5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 20:44:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C3F7281111
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC02318C23;
	Wed, 24 May 2023 18:44:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF76F60862
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 18:44:55 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFA410B
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:44:53 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-64d18d772bdso1418232b3a.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684953893; x=1687545893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3z9gVzvP+6FBEHWrnozdoHhW6MSUsg5+Grnw0Cfk85M=;
        b=YQ41LCQ9nVxOxB03et/dUrxGYnN56neokWma7G4pkTsGeElrzv7vr7uc1tWyAfXdgI
         Cx7yovjGMe92hoBu0Cko6TOOyWTITcAE77UI43TYoOyga0Wj3z7TA7xW9MsOmF4fY/j7
         TPDcKmVX6DsNYEV5yfFztrNd2QjTzMmMK3YAR48yuJknTT6j9UvhXceWarLNkjiwBBU4
         pLKe2PLpE3XAmKUYLdfI8JrzHZOYUZBxE+0C3y/udN0cGnXS5jPvKOwlj2JUVJuLaELO
         to5G0TEFp0XS0D3GpvTipAeipXtT2BzQFDkIaduxZdBB6C/RHx9pDl3PPugC8MDiPEcP
         B+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684953893; x=1687545893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3z9gVzvP+6FBEHWrnozdoHhW6MSUsg5+Grnw0Cfk85M=;
        b=OJjUSCzRhFDqc9TDbeRHmBSQ01dIyB45HUqZCPCgz1wCnhJUc1LVHSzm+zbHVRUpJy
         mdf8t5sF8CvEfUIXSJMbbITNX9oOmBeHASn1vxe9UAd7wndg0ykrBylWLwuz07eS96h1
         S9dwkvwDkJtqk0U7G36f0Iry5I0jUl9uZsZMIJtfly0IDkv4Fp5BJ8PQWxkij6OyG25J
         BQzzZeX0gAbsDepZhcqYpaRLM5mafr+g7hE9BZpyEzWJAnEqIPbKbBQ/0flS1ZB7In19
         /LL95HrK4pCjbzAhqyD8xBlfxbggfUSr4YJWnGKHRJbEuAP90n4fhQJzLdnKwYnKRlp1
         eztA==
X-Gm-Message-State: AC+VfDzzw8o49DzIDiL2QZE4WjtlP19rOQLIB4EI/LEuLegyLE6VyHhb
	CVJAGRlZb2R2cgDFOoF3cOB4bw==
X-Google-Smtp-Source: ACHHUZ7OwPf2L4eaK00fKaPMHzC67Jqk3xa7TTNBwVDMHEoW6Lqn0uQW/IIYbvy5177xrJZYEQ2TDw==
X-Received: by 2002:a05:6a00:1513:b0:623:8592:75c4 with SMTP id q19-20020a056a00151300b00623859275c4mr5192420pfu.29.1684953893292;
        Wed, 24 May 2023 11:44:53 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id g20-20020a62e314000000b0064d48d98260sm7460092pfh.156.2023.05.24.11.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 11:44:53 -0700 (PDT)
Date: Wed, 24 May 2023 11:44:51 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: netdev@vger.kernel.org
Subject: Re: [RFC 2/2] vxlan: make option printing more consistent
Message-ID: <20230524114451.2d014b03@hermes.local>
In-Reply-To: <ZG5SF/8CLymhAQsT@renaissance-vector>
References: <20230523165932.8376-1-stephen@networkplumber.org>
	<20230523165932.8376-2-stephen@networkplumber.org>
	<ZG5SF/8CLymhAQsT@renaissance-vector>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 24 May 2023 20:06:15 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> Thanks Stephen for pointing this series out to me, I overlooked it due
> to the missing "iproute" in the subject.
> 
> I'm fine with the JSON result, having all params printed out is much
> better than the current output.
> 
> My main objection to this is the non-JSON output result. Let's compare
> the current output with the one resulting from this RFC:
> 
> $ ip link add type vxlan id 12
> $ ip -d link show vxlan0
> 79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
>     vxlan id 12 srcport 0 0 dstport 8472 ttl auto ageing 300 udpcsum noudp6zerocsumtx noudp6zerocsumrx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 65536 tso_max_segs 65535 gro_max_size 65536
> 
> $ ip.new -d link show vxlan0
> 79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535
>     vxlan noexternal id 12 srcport 0 0 dstport 8472 learning noproxy norsc nol2miss nol3miss ttl auto ageing 300 udp_csum noudp_zero_csum6_tx noudp_zero_csum6_rx noremcsum_tx noremcsum_rx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 65536 tso_max_segs 65535 gro_max_size 65536
> 
> In my opinion, the new output is much longer and less human-readable.
> The main problem (besides intermixed boolean and numerical params) is
> that we have a lot of useless info. If the ARP proxy is turned off,
> what's the use of "noproxy" over there? Let's not print anything at all,
> I don't expect to find anything about proxy in the output if I'm not
> asking to have it. It seems to me the same can be said for all the
> "no"-params over there.
> 
> What I'm proposing is something along this line:
> 
> +int print_color_bool_opt(enum output_type type,
> +			 enum color_attr color,
> +			 const char *key,
> +			 bool value)
> +{
> +	int ret = 0;
> +
> +	if (_IS_JSON_CONTEXT(type))
> +		jsonw_bool_field(_jw, key, value);
> +	else if (_IS_FP_CONTEXT(type) && value)
> +		ret = color_fprintf(stdout, color, "%s ", key);
> +	return ret;
> +}
> 
> This should lead to no change in the JSON output w.r.t. this patch, and
> to this non-JSON output
> 
> 79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
>     vxlan id 12 srcport 0 0 dstport 8472 learning ttl auto ageing 300 udp_csum addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 65536 tso_max_segs 65535 gro_max_size 65536
> 
> that seems to me much more clear and concise.
> 

The problem is that one of the options is now by default enabled.
The current practice in iproute2 is that the output of the show command must match the equivalent
command line used to create the device.  There were even some VPN's using that.
The proposed localbypass would have similar semantics.

The learning option defaults to true, so either it has to be a special case or it needs to be
printed only if false.

Seems to me that if you ask for details in the output, that showing everything is less surprising,
even if it is overly verbose. But the user asked for the details, so show them.

