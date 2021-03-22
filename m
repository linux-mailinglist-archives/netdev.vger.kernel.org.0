Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6D8343620
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 02:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCVBHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 21:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCVBHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 21:07:37 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78B9C061574;
        Sun, 21 Mar 2021 18:07:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so9535954pjq.5;
        Sun, 21 Mar 2021 18:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zLg3jQuxJTAirwbCGsamIpmUx/Vcu8RiU7hZ/RJZnVk=;
        b=tw018bGtPS10fpxPs8hjt1us4jCIaG7zFJGW4H8hZFGsvTcBYfOMYDUKfy4+lJqVqR
         foZrxXy30mF0UyD7PEErJ01j1HH3cQvBluGT7bztMV7VTTQcdQkEhRj+SGzWLA2DHWuT
         BG+Xf46DDFqgheOwHR5Ls9W7eQHv8zO+rsbXTs/DRRLMafc2uoewNFCNBE0F5NDfYjq+
         XK1d1GTmed0sG91/q/SqimMId5VOgz/XBzNZvEjKL3HhYDtc8Sg62Vw9ADAbi/GUV83u
         SMnp3v6rU4t4pT3cNVdlaERqVwkMvgdaZ6mpjMrI10swfsYv27RTl7ONHmfsc9bSI45e
         HybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zLg3jQuxJTAirwbCGsamIpmUx/Vcu8RiU7hZ/RJZnVk=;
        b=qLOUgP3PAba5nF+2WTcUv8BzzhNMof0LGm3AW19i9hnV85Q0z2WtmQqs5Ug5kuUjux
         nuGgfCrBCxY90mv2nHVcSQSuDJQO0GHW5avIIdZ+uCovBj2KRd8L4+B/sSqTZJJs7eBR
         oKl9cngIfbcVtNakGv3N6Do3VJSzHKIo7qn1nqQaa0uHi76gjNPBeu6RCk0DNGBiAHgU
         tNh6fGfSuH+XlPTFvc1qns807POkUY9iSGcK5W3d1rHo033mMSazXGZNDaPd2l1YFu5/
         WTPJD/CpHIe4+LlUA9tkrasoQmgubJCAeUYjx/16VexpOYugxf3qbxs9pyNfHveMVOrd
         WCnA==
X-Gm-Message-State: AOAM53216O4OJBy/qNbEjyMTABfkIzJipOIAr74S12NWjUzj0lJ9AMf3
        zQzGfDgzG/ELcaV0eyR3fA8=
X-Google-Smtp-Source: ABdhPJyXZQMVSdHxj/wL96Br+8qDc9UO+TYqGVLihDysV1/LBI8XztQBU5C6YSh8s4N0rcTsk+ElBQ==
X-Received: by 2002:a17:902:343:b029:e6:bc94:48c7 with SMTP id 61-20020a1709020343b02900e6bc9448c7mr24744836pld.72.1616375257034;
        Sun, 21 Mar 2021 18:07:37 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:8b22])
        by smtp.gmail.com with ESMTPSA id h6sm11104267pfb.157.2021.03.21.18.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 18:07:36 -0700 (PDT)
Date:   Sun, 21 Mar 2021 18:07:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: allow compiling BPF objects
 without BTF
Message-ID: <20210322010734.tw2rigbr3dyk3iot@ast-mbp>
References: <20210319205909.1748642-1-andrii@kernel.org>
 <20210319205909.1748642-4-andrii@kernel.org>
 <20210320022156.eqtmldxpzxkh45a7@ast-mbp>
 <CAEf4Bzarx33ENLBRyqxDz7k9t0YmTRNs5wf_xCqL2jNXvs+0Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzarx33ENLBRyqxDz7k9t0YmTRNs5wf_xCqL2jNXvs+0Sg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 20, 2021 at 10:00:57AM -0700, Andrii Nakryiko wrote:
> On Fri, Mar 19, 2021 at 7:22 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Mar 19, 2021 at 01:59:09PM -0700, Andrii Nakryiko wrote:
> > > Add ability to skip BTF generation for some BPF object files. This is done
> > > through using a convention of .nobtf.c file name suffix.
> > >
> > > Also add third statically linked file to static_linked selftest. This file has
> > > no BTF, causing resulting object file to have only some of DATASEC BTF types.
> > > It also is using (from BPF code) global variables. This tests both libbpf's
> > > static linking logic and bpftool's skeleton generation logic.
> >
> > I don't like the long term direction of patch 1 and 3.
> > BTF is mandatory for the most bpf kernel features added in the last couple years.
> > Making user space do quirks for object files without BTF is not something
> > we should support or maintain. If there is no BTF the linker and skeleton
> > generation shouldn't crash, of course, but they should reject such object.
> 
> I don't think tools need to enforce any policies like that. They are
> tools and should be unassuming about the way they are going to be used
> to the extent possible.

Right and bpftool/skeleton was used with BTF since day one.
Without BTF the skeleton core ideas are lost. The skeleton api
gives no benefit. So what's the point of adding support for skeleton without BTF?
Is there a user that would benefit? If so, what will they gain from
such BTF-less skeleton?
