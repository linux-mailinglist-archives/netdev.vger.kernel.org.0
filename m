Return-Path: <netdev+bounces-5707-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B03CF712814
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63E021C2109F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED5C023D59;
	Fri, 26 May 2023 14:11:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA22B171A7;
	Fri, 26 May 2023 14:11:47 +0000 (UTC)
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492A1DF;
	Fri, 26 May 2023 07:11:46 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-3f4eb166122so3013001cf.3;
        Fri, 26 May 2023 07:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685110305; x=1687702305;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OhUjCk3Hqq2xEyvW93scwqw3dxIwOYejK8Ot6yaK520=;
        b=jWKuPmEl+xceHRiTsjMb1ueK7WhI0eGaA0bbzv+vidk4DdyQcxfteXwEHYcgrwiUvJ
         SXdoQNxFkFlC5IVXInnpUASdHtnG4FjBeXXTvfK8w5b3fYLm1BUdxeNImimAlgQDWf1S
         RXWO6icH7HoyGLATnKpq46s26gmbFAxtbiGsWWTk3/r1+BQQW87LHF4ITg052dR0Y5bN
         dNP6U8DzFeq6ITWy8V6/vNHOxP0XmX0vfT0yv6sUVtPSC92v+jNmx/oQcC6VrRjVCjvc
         hEJusuo7EJgdzqkrvVKnkX4eAzq8S/BvLOcecWxgDL9T44wkeDQMjXRODKm8C+2yo2Ls
         kbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685110305; x=1687702305;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OhUjCk3Hqq2xEyvW93scwqw3dxIwOYejK8Ot6yaK520=;
        b=AQl+INpZabXnJop4cZ+p78nj+AANQZtQF2NCqZlaSQP7H4UJEdek498LKJlFziOdU7
         DwQp48a8uf4u0ksJjUPwvRp/ORyBmk950pDQRblKEBmkH6gbkFeoUUmwfPEVIA4OMehV
         ulS/SFG6YoVjXNYV6QFHY7oHcKHPd1o1NIW8cqLHG4OydO2f4Yj13JjxMrHUkLXC1wSp
         4H+MZcyMtyMN9/y9bDQfZ/iIQ7tY2hNIA09pHBAYVIUyja27c0ukr1A9EEctwZD2dgAh
         DoxdICVQfRKxQGDRhTAHar2z5L/Ri5wFI6cn1i35KeUHvahvuB2fk9REV4uEF0uFiZ+E
         fadg==
X-Gm-Message-State: AC+VfDyiXS6Acvi3swjTT0v/KrxLvMtkJvVXe6stYDuot8s+Ih6U/y9n
	xEx4drN+7APypcWgEjrcIVA=
X-Google-Smtp-Source: ACHHUZ4r03gEO++bq51Ot6Yf5jHXiIl7SM4Zqj5kGEkbCOI5dYaH/H1Ex9e4QbMXs5n/2Vp94X8msQ==
X-Received: by 2002:a05:622a:1b86:b0:3f1:381d:1067 with SMTP id bp6-20020a05622a1b8600b003f1381d1067mr1857546qtb.42.1685110305297;
        Fri, 26 May 2023 07:11:45 -0700 (PDT)
Received: from localhost (ool-944b8b4f.dyn.optonline.net. [148.75.139.79])
        by smtp.gmail.com with ESMTPSA id f2-20020ac87f02000000b003f6b0f4126fsm1284234qtk.8.2023.05.26.07.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 07:11:44 -0700 (PDT)
Date: Fri, 26 May 2023 10:11:43 -0400
From: Louis DeLosSantos <louis.delos.devel@gmail.com>
To: Yonghong Song <yhs@meta.com>, bpf@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
	Stanislav Fomichev <sdf@google.com>, razor@blackwall.org
Subject: Re: [PATCH 1/2] bpf: add table ID to bpf_fib_lookup BPF helper
Message-ID: <ZHC+H7ZBzCN4kPc/@fedora>
References: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
 <20230505-bpf-add-tbid-fib-lookup-v1-1-fd99f7162e76@gmail.com>
 <cc91d53d-0a73-cf30-bd7f-b22db8228842@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc91d53d-0a73-cf30-bd7f-b22db8228842@meta.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:01:34PM -0700, Yonghong Song wrote:
> 
> 
> On 5/25/23 7:27 AM, Louis DeLosSantos wrote:
> > Add ability to specify routing table ID to the `bpf_fib_lookup` BPF
> > helper.
> > 
> > A new field `tbid` is added to `struct bpf_fib_lookup` used as
> > parameters to the `bpf_fib_lookup` BPF helper.
> > 
> > When the helper is called with the `BPF_FIB_LOOKUP_DIRECT` flag and the
> > `tbid` field in `struct bpf_fib_lookup` is greater then 0, the `tbid`
> > field will be used as the table ID for the fib lookup.
> 
> I think table id 0 is legal in the kernel, right?
> It is probably okay to consider table id 0 not supported to
> simplify the user interface. But it would be great to
> add some explanations in the commit message.
> 
> > 
> > If the `tbid` does not exist the fib lookup will fail with
> > `BPF_FIB_LKUP_RET_NOT_FWDED`.
> > 
> > The `tbid` field becomes a union over the vlan related output fields in
> > `struct bpf_fib_lookup` and will be zeroed immediately after usage.
> > 
> > This functionality is useful in containerized environments.
> > 
> > For instance, if a CNI wants to dictate the next-hop for traffic leaving
> > a container it can create a container-specific routing table and perform
> > a fib lookup against this table in a "host-net-namespace-side" TC program.
> > 
> > This functionality also allows `ip rule` like functionality at the TC
> > layer, allowing an eBPF program to pick a routing table based on some
> > aspect of the sk_buff.
> > 
> > As a concrete use case, this feature will be used in Cilium's SRv6 L3VPN
> > datapath.
> > 
> > When egress traffic leaves a Pod an eBPF program attached by Cilium will
> > determine which VRF the egress traffic should target, and then perform a
> > FIB lookup in a specific table representing this VRF's FIB.
> > 
> > Signed-off-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
> > ---
> >   include/uapi/linux/bpf.h       | 17 ++++++++++++++---
> >   net/core/filter.c              | 12 ++++++++++++
> >   tools/include/uapi/linux/bpf.h | 17 ++++++++++++++---
> >   3 files changed, 40 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 1bb11a6ee6676..2096fbb328a9b 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3167,6 +3167,8 @@ union bpf_attr {
> >    *		**BPF_FIB_LOOKUP_DIRECT**
> >    *			Do a direct table lookup vs full lookup using FIB
> >    *			rules.
> > + *			If *params*->tbid is non-zero, this value designates
> > + *			a routing table ID to perform the lookup against.
> >    *		**BPF_FIB_LOOKUP_OUTPUT**
> >    *			Perform lookup from an egress perspective (default is
> >    *			ingress).
> > @@ -6881,9 +6883,18 @@ struct bpf_fib_lookup {
> >   		__u32		ipv6_dst[4];  /* in6_addr; network order */
> >   	};
> > -	/* output */
> > -	__be16	h_vlan_proto;
> > -	__be16	h_vlan_TCI;
> > +	union {
> > +		struct {
> > +			/* output */
> > +			__be16	h_vlan_proto;
> > +			__be16	h_vlan_TCI;
> > +		};
> > +		/* input: when accompanied with the 'BPF_FIB_LOOKUP_DIRECT` flag, a
> > +		 * specific routing table to use for the fib lookup.
> > +		 */
> > +		__u32	tbid;
> > +	};
> > +
> >   	__u8	smac[6];     /* ETH_ALEN */
> >   	__u8	dmac[6];     /* ETH_ALEN */
> >   };
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 451b0ec7f2421..6f710aa0a54b3 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5803,6 +5803,12 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
> >   		u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
> >   		struct fib_table *tb;
> > +		if (params->tbid) {
> > +			tbid = params->tbid;
> > +			/* zero out for vlan output */
> > +			params->tbid = 0;
> > +		}
> > +
> >   		tb = fib_get_table(net, tbid);
> >   		if (unlikely(!tb))
> >   			return BPF_FIB_LKUP_RET_NOT_FWDED;
> > @@ -5936,6 +5942,12 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
> >   		u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
> >   		struct fib6_table *tb;
> > +		if (params->tbid) {
> > +			tbid = params->tbid;
> > +			/* zero out for vlan output */
> > +			params->tbid = 0;
> > +		}
> > +
> >   		tb = ipv6_stub->fib6_get_table(net, tbid);
> >   		if (unlikely(!tb))
> >   			return BPF_FIB_LKUP_RET_NOT_FWDED;
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index 1bb11a6ee6676..2096fbb328a9b 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -3167,6 +3167,8 @@ union bpf_attr {
> >    *		**BPF_FIB_LOOKUP_DIRECT**
> >    *			Do a direct table lookup vs full lookup using FIB
> >    *			rules.
> > + *			If *params*->tbid is non-zero, this value designates
> > + *			a routing table ID to perform the lookup against.
> >    *		**BPF_FIB_LOOKUP_OUTPUT**
> >    *			Perform lookup from an egress perspective (default is
> >    *			ingress).
> > @@ -6881,9 +6883,18 @@ struct bpf_fib_lookup {
> >   		__u32		ipv6_dst[4];  /* in6_addr; network order */
> >   	};
> > -	/* output */
> > -	__be16	h_vlan_proto;
> > -	__be16	h_vlan_TCI;
> > +	union {
> > +		struct {
> > +			/* output */
> > +			__be16	h_vlan_proto;
> > +			__be16	h_vlan_TCI;
> > +		};
> > +		/* input: when accompanied with the 'BPF_FIB_LOOKUP_DIRECT` flag, a
> > +		 * specific routing table to use for the fib lookup.
> > +		 */
> > +		__u32	tbid;
> > +	};
> > +
> >   	__u8	smac[6];     /* ETH_ALEN */
> >   	__u8	dmac[6];     /* ETH_ALEN */
> >   };
> > 

> I think table id 0 is legal in the kernel, right?
> It is probably okay to consider table id 0 not supported to
> simplify the user interface. But it would be great to
> add some explanations in the commit message.

Agreed. 

My initial feelings were there is no real use case to query against the Kernel's
`all` table. 

The response from John will dictate if this remains the case, as the suggestion
of using a new flag bit will nullify this issue, I think.

If it stays tho, I will def add details in the commit message around this on next
rev.

