Return-Path: <netdev+bounces-5705-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAFD8712803
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E7D528185B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B1524129;
	Fri, 26 May 2023 14:07:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F921EA9D;
	Fri, 26 May 2023 14:07:07 +0000 (UTC)
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26285DF;
	Fri, 26 May 2023 07:07:06 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-3f6a3a76665so11076591cf.1;
        Fri, 26 May 2023 07:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685110025; x=1687702025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mpK9X8nhccAYYTxDVOlUGiQW5MD1MybeGcuhmmUxbrw=;
        b=C235mJrz9ECdSMETjNOFNPzkF3k7s8BYqCBixlj5iGCV7/17qaGsv+PJqQpu1oDPe8
         klmtmqFtCVMomSFScw6IxfsPrGru8iHa1qN/MTadbGZFM9JZ2JLDeRyrv8As/dcM+EsO
         oXb33TEWrHeCu4YWOqVZyhIGJdFgpQCOoSnS+rGpnpeIJcUBfU6cW7mPucAy9/+KZKmz
         Cxym2426r5iPTFPhAHz3NzIjpUsklBFoNtCx7ontpHX27egHe9PQhxAruMvmzXnXk6yW
         pOIQnZpd4a4jbY6B+h5pX+97/5WPUnJgz5dbeGgVGzPkqo+186DgNAAG86gjOFfCXZ/6
         y6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685110025; x=1687702025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpK9X8nhccAYYTxDVOlUGiQW5MD1MybeGcuhmmUxbrw=;
        b=N63SfW1m2JibuAdVOYzJEqvQPljoxBonN7diq2ZG9NG51bt//Hw2hlercG5VbwHX/p
         R8Vzr3guSqQTlwu8Nh6C9WuqLV1x71MDsQD20CwGVjf/mBI8h3MzMjblRhnlsS30s4o1
         fNPSmbWHYBUD5ONHp/9agmTnxMyaeiT0wN08qiWKIlKa2vnrNwoMxR5f4Q4MTAf2rIUj
         R9MvcM0EKpi8UR2kPjrDTw3Yqs7ItiAZabSB4L/OWJnEv998OzLpwH2Hzg8KSuH5BFrp
         85/KyZ4qEKRosl3ZNLQ7P0+DGAej+9/EI+0duCVrlJ4y4uPfwzXhU/2NuG51yq3pClxV
         9ByA==
X-Gm-Message-State: AC+VfDxEJum1ASfEYqPlTANHG8U6+pDySjcyBJDLuwVm7Qgv5yD9sbBI
	CdMjpTrNFFm4cwXtS4/EljY=
X-Google-Smtp-Source: ACHHUZ7/8WyLCJiuWZU7NE7r4499LIvt6vjxd/kfiAK3HYySQ4ZF8SmMEdkp4FNjp90TnM36LaXRmw==
X-Received: by 2002:a05:622a:1649:b0:3f5:1861:abe1 with SMTP id y9-20020a05622a164900b003f51861abe1mr1770282qtj.14.1685110025084;
        Fri, 26 May 2023 07:07:05 -0700 (PDT)
Received: from localhost (ool-944b8b4f.dyn.optonline.net. [148.75.139.79])
        by smtp.gmail.com with ESMTPSA id f25-20020ac84659000000b003ee4b5a2dd3sm1269047qto.21.2023.05.26.07.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 07:07:04 -0700 (PDT)
Date: Fri, 26 May 2023 10:07:03 -0400
From: Louis DeLosSantos <louis.delos.devel@gmail.com>
To: John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
	Stanislav Fomichev <sdf@google.com>, razor@blackwall.org
Subject: Re: [PATCH 1/2] bpf: add table ID to bpf_fib_lookup BPF helper
Message-ID: <ZHC9BzCv6KiAUpbj@fedora>
References: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
 <20230505-bpf-add-tbid-fib-lookup-v1-1-fd99f7162e76@gmail.com>
 <6470562cac756_2023020893@john.notmuch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6470562cac756_2023020893@john.notmuch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:48:12PM -0700, John Fastabend wrote:
> Louis DeLosSantos wrote:
> > Add ability to specify routing table ID to the `bpf_fib_lookup` BPF
> > helper.
> > 
> > A new field `tbid` is added to `struct bpf_fib_lookup` used as
> > parameters to the `bpf_fib_lookup` BPF helper.
> > 
> > When the helper is called with the `BPF_FIB_LOOKUP_DIRECT` flag and the
> > `tbid` field in `struct bpf_fib_lookup` is greater then 0, the `tbid`
> > field will be used as the table ID for the fib lookup.
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
> >  include/uapi/linux/bpf.h       | 17 ++++++++++++++---
> >  net/core/filter.c              | 12 ++++++++++++
> >  tools/include/uapi/linux/bpf.h | 17 ++++++++++++++---
> >  3 files changed, 40 insertions(+), 6 deletions(-)
> > 
> 
> Looks good one question. Should we hide tbid behind a flag we have
> lots of room. Is there any concern a user could feed a bpf_fib_lookup
> into the helper without clearing the vlan fields? Perhaps by
> pulling the struct from a map or something where it had been
> previously used.
> 
> Thanks,
> John

This is a fair point. 

I could imagine a scenario where an individual is caching bpf_fib_lookup structs,
pulls in a kernel with this change, and is now accidentally feeding the stale vlan
fields as table ID's, since their code is using `BPF_FIB_LOOKUP_DIRECT` with
the old semantics. 

Guarding with a new flag like this (just a quick example, not a full diff)...

```
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2096fbb328a9b..22095ccaaa64d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6823,6 +6823,7 @@ enum {
        BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
        BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
        BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
+       BPF_FIB_LOOKUP_TBID    = (1U << 3),
 };
 
 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index 6f710aa0a54b3..9b78460e39af2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5803,7 +5803,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
                u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
                struct fib_table *tb;
 
-               if (params->tbid) {
+               if (flags & BPF_FIB_LOOKUP_TBID) {
                        tbid = params->tbid;
                        /* zero out for vlan output */
                        params->tbid = 0;
```

Maybe a bit safer, you're right. 

In this case the semantics around `BPF_FIB_LOOKUP_DIRECT` remain exactly the same,
and if we do `flags = BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_TBID`, only then will
the `tbid` field in the incoming params wil be considered. 

If I squint at this, it technically also allows us to consider `tbid=0` as a 
valid table id, since the caller now explicitly opts into it, where previously
table id 0 was not selectable, tho I don't know if there's a *real* use case 
for selecting the `all` table. 

I'm happy to make this change, what are your thoughts? 

