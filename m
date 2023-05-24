Return-Path: <netdev+bounces-5171-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8592570FFA8
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 23:08:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AEBD1C20D41
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 21:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C8582262B;
	Wed, 24 May 2023 21:08:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7050A2260D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 21:08:11 +0000 (UTC)
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A224C1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:08:08 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso725889a12.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684962487; x=1687554487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpxp2B3gmYJM0RowfLmenBqRcoLJfpwPfI/6YQul1nw=;
        b=B2H2Thm6MNBuEiJop95PQdwxEsSYZO7KDsY5edpt3fjN7TX5HrFl3Q9QCpbUXS6qkA
         BBLmv/eeRymPh0E4jotO/J2WcCvjKlTARPifK6HCZEpRwlbI1BaBYXNcSogct8Boxo6p
         MzgHKKBCP3WeOU6Z4C/doNQDehNIPCEA/F9tt182beNvkFqbXQyG7Rmh4caRowZQ9nYM
         j+LdZ5+Kt0R7NDJT7lel1dK12eCKI5vw85Wh8NoCHuc2qms+EUVfRDUXQsQ8W4l27h2J
         AwjWfOEFKHUmFJLNefBxX53MbRVfAqGqwKBfdBzbth+Lg8Qkd+sk3i9Q8IR72S/YOovj
         P4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684962487; x=1687554487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zpxp2B3gmYJM0RowfLmenBqRcoLJfpwPfI/6YQul1nw=;
        b=Pbl/7UOoe9TfwmNnCWGEPHMw2224Az6TX3WhX0x68u5Xed1Y4FpJpfRFGkVm6nphn2
         428WrmzkiwG1Wm9tcQug1P1xjgMGy8F0tHdiKWc1kEW/+BYEbSxIOu6nm5R2HzsUqe5Q
         yfBupF0q2n3fnRX/EaGVWeMO1zvTNewLUR000mEeGoTJy2iM/qX+gLnbyZEIOmYVtZJw
         drhGeKdb/vqR8D2pgY+7wcPTPHJgjDlCo2xQw7PV64HzUfDkMnoPUiQ5bGZAUF7A4nLm
         pkDNGOxBEvDEZWOhLAGDJxBWfuFc0byjSazbcozsovOAvsSe3avCX/YVIMVNnau4oan9
         +VOw==
X-Gm-Message-State: AC+VfDzIlGuYqKVMoCQnaFjv3niLlivOr2PJ9YuO+8lsrYJhkZ1+TcQ3
	aqCci2MhzMO9vVTLOt8KpBBvMR8pHtRL/cOldwIc1A==
X-Google-Smtp-Source: ACHHUZ5XBjYbuXcV63qi9gkXklrQDSVcu6ZwCvUFQKe6UKK3RHQyK3lySHqiO4nFx+TKxAjgaMGrbQ==
X-Received: by 2002:a17:902:db03:b0:1ae:6135:a050 with SMTP id m3-20020a170902db0300b001ae6135a050mr24086391plx.19.1684962487590;
        Wed, 24 May 2023 14:08:07 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id p12-20020a170902eacc00b00199203a4fa3sm9154671pld.203.2023.05.24.14.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 14:08:07 -0700 (PDT)
Date: Wed, 24 May 2023 14:08:05 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: netdev@vger.kernel.org
Subject: Re: [RFC 2/2] vxlan: make option printing more consistent
Message-ID: <20230524140805.1740748e@hermes.local>
In-Reply-To: <20230524114451.2d014b03@hermes.local>
References: <20230523165932.8376-1-stephen@networkplumber.org>
	<20230523165932.8376-2-stephen@networkplumber.org>
	<ZG5SF/8CLymhAQsT@renaissance-vector>
	<20230524114451.2d014b03@hermes.local>
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

On Wed, 24 May 2023 11:44:51 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Wed, 24 May 2023 20:06:15 +0200
> Andrea Claudi <aclaudi@redhat.com> wrote:
> 
> > Thanks Stephen for pointing this series out to me, I overlooked it due
> > to the missing "iproute" in the subject.
> > 
> > I'm fine with the JSON result, having all params printed out is much
> > better than the current output.
> > 
> > My main objection to this is the non-JSON output result. Let's compare
> > the current output with the one resulting from this RFC:
> > 
> > $ ip link add type vxlan id 12
> > $ ip -d link show vxlan0
> > 79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> >     link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
> >     vxlan id 12 srcport 0 0 dstport 8472 ttl auto ageing 300 udpcsum noudp6zerocsumtx noudp6zerocsumrx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 65536 tso_max_segs 65535 gro_max_size 65536
> > 
> > $ ip.new -d link show vxlan0
> > 79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> >     link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535
> >     vxlan noexternal id 12 srcport 0 0 dstport 8472 learning noproxy norsc nol2miss nol3miss ttl auto ageing 300 udp_csum noudp_zero_csum6_tx noudp_zero_csum6_rx noremcsum_tx noremcsum_rx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 65536 tso_max_segs 65535 gro_max_size 65536
> > 
> > In my opinion, the new output is much longer and less human-readable.
> > The main problem (besides intermixed boolean and numerical params) is
> > that we have a lot of useless info. If the ARP proxy is turned off,
> > what's the use of "noproxy" over there? Let's not print anything at all,
> > I don't expect to find anything about proxy in the output if I'm not
> > asking to have it. It seems to me the same can be said for all the
> > "no"-params over there.
> > 
> > What I'm proposing is something along this line:
> > 
> > +int print_color_bool_opt(enum output_type type,
> > +			 enum color_attr color,
> > +			 const char *key,
> > +			 bool value)
> > +{
> > +	int ret = 0;
> > +
> > +	if (_IS_JSON_CONTEXT(type))
> > +		jsonw_bool_field(_jw, key, value);
> > +	else if (_IS_FP_CONTEXT(type) && value)
> > +		ret = color_fprintf(stdout, color, "%s ", key);
> > +	return ret;
> > +}
> > 
> > This should lead to no change in the JSON output w.r.t. this patch, and
> > to this non-JSON output
> > 
> > 79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> >     link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
> >     vxlan id 12 srcport 0 0 dstport 8472 learning ttl auto ageing 300 udp_csum addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 65536 tso_max_segs 65535 gro_max_size 65536
> > 
> > that seems to me much more clear and concise.
> >   
> 
> The problem is that one of the options is now by default enabled.
> The current practice in iproute2 is that the output of the show command must match the equivalent
> command line used to create the device.  There were even some VPN's using that.
> The proposed localbypass would have similar semantics.
> 
> The learning option defaults to true, so either it has to be a special case or it needs to be
> printed only if false.
> 
> Seems to me that if you ask for details in the output, that showing everything is less surprising,
> even if it is overly verbose. But the user asked for the details, so show them.

I notice that the number of options in vxlan driver has gotten out of control.
There are too many. But the preponderance of nerd knobs to deal with non standard usage
is an industry wide problem

