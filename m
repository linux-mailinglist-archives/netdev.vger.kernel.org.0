Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294CF192FF1
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgCYRzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:55:37 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39509 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgCYRzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 13:55:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id b22so1504992pgb.6;
        Wed, 25 Mar 2020 10:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZV1CqF++eOLoAGcfvlmYWXRZOSEy7vu8gNuIXPymwVY=;
        b=nL5rfKtj1wm/41AcVuQsjNn19ps5/C45NEjlUJAR6h1TUtnpMIqCHtMEi/7tRG0pRD
         0SR760Hl7TPyU+jwZ8TQt81oowAtynnLB7uJZeJ5lJEDevuI3eGAJSNJ8ewwBRyGHf3/
         SYyyn5/A0o/2YcT7DsV+AiH8If1tmIhrS4H4uAwufZCs9kn93jmq1Wi0vgG2fdRLun6x
         K55ajw1aLnwmyFMuOzwG59JYC3YHV3HNN6vzhOqlvlHmM2cW8nWz/AJmi3Jh2xAtahSJ
         yh2hlud8Arhi1CUdG4W0q7FmNO2Ks8Mue0dWs3c75feSHnifmNCVp4PEuCvFJzsoseaw
         FjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZV1CqF++eOLoAGcfvlmYWXRZOSEy7vu8gNuIXPymwVY=;
        b=KpIa9XN62/t0BaxjcO3M3+ZGZjWqg+uaGfA9hFB7pFma9SodEsMvbH2k+Lq+S6if8x
         Fr9j/ntq15G0JtGuNyu+LtjOomq9k8H9zxUQzgwoR8fgQCLEGLFIMOCT3G2fpbpDoZFJ
         zju/YGGxVRLfcK+n2PCmSp934GlOhQ25b2zv5uTccUNiIUbADxsxKX4A44Gt0y6Du8Cf
         /naBGrBsvwp2IcL+7AZTxpW0yPEMX/hizj+Ch0P3sx3vyGGMWa717AAWsA0LQ1+229bE
         eaODOcuTu0DReXJXo8SLyzGHYNr0XIGHl91mPDXLPqnsBQnwuu715WiyE4dfoRCJnh3/
         3MOA==
X-Gm-Message-State: ANhLgQ32WBuga5q/135GnZ/PvijzoWQ0YaLFygI67D9qsWaJwRySDPrN
        39qNKkPgahVbZuOudcxcOSg=
X-Google-Smtp-Source: ADFU+vuaLB1Z4N2UHL/BUAckqo+GcqWgVsjB1l2zt73fOH8TRiLz64eMYf72yJickCc5HZPcBxDeOQ==
X-Received: by 2002:a63:7b5e:: with SMTP id k30mr4169626pgn.209.1585158935341;
        Wed, 25 Mar 2020 10:55:35 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:b339])
        by smtp.gmail.com with ESMTPSA id c128sm18574855pfa.11.2020.03.25.10.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 10:55:34 -0700 (PDT)
Date:   Wed, 25 Mar 2020 10:55:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200325175531.iqut7m5cxafdasiz@ast-mbp>
References: <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87369wrcyv.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 10:38:32AM +0100, Toke Høiland-Jørgensen wrote:
> >
> > As for having netlink interface for creating link only for XDP. Why
> > duplicating and maintaining 2 interfaces?
> 
> Totally agree; why do we need two interfaces? Let's keep the one we
> already have - the netlink interface! :)

it's not about netlink vs something else.
I already explained that the ownership concept is missing.

> > All the other subsystems will go through bpf syscall, only XDP wants
> > to (also) have this through netlink. This means duplication of UAPI
> > for no added benefit. It's a LINK_CREATE operations, as well as
> > LINK_UPDATE operations. Do we need to duplicate LINK_QUERY (once its
> > implemented)? What if we'd like to support some other generic bpf_link
> > functionality, would it be ok to add it only to bpf syscall, or we
> > need to duplicate this in netlink as well?
> 
> You're saying that like we didn't already have the netlink API. We
> essentially already have (the equivalent of) LINK_CREATE and LINK_QUERY,
> this is just adding LINK_UPDATE. It's a straight-forward fix of an
> existing API; essentially you're saying we should keep the old API in a
> crippled state in order to promote your (proposed) new API.

It's not a fix. It papers over a giant issue with all existing attaching
apis regardless of the form (netlink, syscall, etc)
The commit 7dd68b3279f1 ("bpf: Support replacing cgroup-bpf program in MULTI mode")
is the same paper-over. It's not a fix for broken api. I regret applying it.
