Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4217127F3FD
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbgI3VMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3VMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:12:44 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B345C061755;
        Wed, 30 Sep 2020 14:12:44 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id y14so1926238pgf.12;
        Wed, 30 Sep 2020 14:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vcUyxFUOgHUmdj8xy6sPye9byV+TKZ+uv4Peg/cadZU=;
        b=HC+rGaApog9DM4ubka9ac2AzfQwogkGihEvLYVeujqMvkB9gxPvg0a9Zswz9QJjfwx
         KDC4z9KZSD6E3MctcZtT8aaC4SmSBReQIPQJKcLAxyOV4JklArHXqq/Ij6ciKXo1pDBP
         ywyeXN54adJDoy3iPqi1kFSgAZZgajYkCawOquBHnfFPIFTbA0SQ7VEYPFu3LJLMNiSJ
         CjjHhhJwACYxFZv39jSKFkHdULqj7DdrV5dPSxUfKnZg8+uZauWiwmCKzJLvzd/hs0ZJ
         1C2qsno/RBzD1OkD1D/eZVN7MJhoFeNoEyjRa6Yz2fPbF1tJJkD8Na3c5D9m2D8iDTkU
         4t7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vcUyxFUOgHUmdj8xy6sPye9byV+TKZ+uv4Peg/cadZU=;
        b=WNXHSDkaBoD4L5ZRqx/6cprKHBpt5Hh08LtSuCsOThacZM6kPl1oTIXGptTdXFsCCF
         CANo3YufgCu4LJD2QOpQWGjJmWRblBSK4qcd6DbxIHKdLm30L+GR8uBsvKpulseWaMD1
         DKC2Q5pCVn4HBeTCAg+dxekRAuyXa6p1ThJ/j1cXtPS1pKkqPMRtRr4HexBugSF/oY2v
         WDZE2VpicXwHgpZ4yJSkIgfYR02z/nX3K+O7DFutsoSEbPYhhnvftHfMFym+deR20KTf
         2MhkZWJoOi2EOh2O8Vxy0MwOd9jWC7om10rD4deIF9O1dgJVAkFNxDOIVsAjKsLJcxWb
         Hi5A==
X-Gm-Message-State: AOAM531OgYDFL9BU/JOAyBU7pdoMKrDLPvc6B8CvI7Uj6EOPCV+grPg9
        fXNIFJlhEtVoNuHnwgIKCAU=
X-Google-Smtp-Source: ABdhPJx4C70rSCQkSio/HHfnoTZ2WhGquAo8s/1D5Aog4T3xD/4HPUz1yD5oApEE592dVcCIIfbyqA==
X-Received: by 2002:aa7:8583:0:b029:13f:7096:5eb with SMTP id w3-20020aa785830000b029013f709605ebmr4434330pfn.0.1601500363650;
        Wed, 30 Sep 2020 14:12:43 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:af79])
        by smtp.gmail.com with ESMTPSA id w192sm3618236pfd.156.2020.09.30.14.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 14:12:42 -0700 (PDT)
Date:   Wed, 30 Sep 2020 14:12:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 6/6] bpf, selftests: add redirect_neigh
 selftest
Message-ID: <20200930211240.sn7hukivc3nrec6w@ast-mbp.dhcp.thefacebook.com>
References: <cover.1601477936.git.daniel@iogearbox.net>
 <0fc7d9c5f9a6cc1c65b0d3be83b44b1ec9889f43.1601477936.git.daniel@iogearbox.net>
 <20200930192004.acumndm6xfxwplzl@ast-mbp.dhcp.thefacebook.com>
 <7a454afe-9f5b-6e6f-5683-33fdc61dabaa@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a454afe-9f5b-6e6f-5683-33fdc61dabaa@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 11:01:45PM +0200, Daniel Borkmann wrote:
> On 9/30/20 9:20 PM, Alexei Starovoitov wrote:
> > On Wed, Sep 30, 2020 at 05:18:20PM +0200, Daniel Borkmann wrote:
> > > +
> > > +#ifndef barrier_data
> > > +# define barrier_data(ptr)	asm volatile("": :"r"(ptr) :"memory")
> > > +#endif
> > > +
> > > +#ifndef ctx_ptr
> > > +# define ctx_ptr(field)		(void *)(long)(field)
> > > +#endif
> > 
> > > +static __always_inline bool is_remote_ep_v4(struct __sk_buff *skb,
> > > +					    __be32 addr)
> > > +{
> > > +	void *data_end = ctx_ptr(skb->data_end);
> > > +	void *data = ctx_ptr(skb->data);
> > 
> > please consider adding:
> >          __bpf_md_ptr(void *, data);
> >          __bpf_md_ptr(void *, data_end);
> > to struct __sk_buff in a followup to avoid this casting headache.
> 
> You mean also for the other ctx types? I can take a look, yeah.

I mean we can add two new fields to __sk_buff with proper 'void *' type
and rename the old ones:

struct __sk_buff {
...
-  u32 data;
+  u32 data_deprecated;
-  u32 data_end;
+  u32 data_end_deprecated;
...
+  __bpf_md_ptr(void *, data);
+  __bpf_md_ptr(void *, data_end);
};

All existing progs will compile fine because they do type cast anyway,
but new progs wouldn't need to do the cast anymore.

It will solve some llvm headaches due to 32-bit load too.

Or we can introduce two new fields with new names.

> Yeah, so the barrier_data() was to avoid compiler to optimize, and the bpf_ntohl()
> to load target ifindex which was stored in big endian. Thanks for applying the set,
> I'll look into reworking this to have a loader application w/ the global data and
> then to pin it and have iproute2 pick this up from the pinned location, for example
> (or directly interact with netlink wrt attaching ... I'll see which is better).

Thanks! Appreciate it.
