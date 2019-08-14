Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 059C18C59D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 03:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfHNBou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 21:44:50 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39102 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfHNBot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 21:44:49 -0400
Received: by mail-pl1-f193.google.com with SMTP id z3so3209399pln.6;
        Tue, 13 Aug 2019 18:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vUNwl5nx1kBf+zxIr2kgBV9jHfRhHo+6UnxNpoEu764=;
        b=AVBe50IFJz86bR0eOTvWOyPW5fz1PmgbTerz+kF/Nh0qS7pqsv0hkI26iL6zP56rrG
         reQ1Ax16tgmoqu20fqjGQZ024lTYCQpKUcohQcmcsWuA8/va2lK160FbL+kQdAfzUzKK
         vzY2aIm27fizlsxK9SPWz4fgWBgs8Ys3TRGSPnWFG0yrH8En6pkx1t+DCB45L08LzvWb
         Y45t4+jN3riAZymu5JCH+ASCbl75w1i8O8irQ3u8nHf8CrDWcxmAXMTb+hgt21xBvolj
         E4ZywMkP2F9yg/bJSa/Xxo0CM1N3IwBOZUAGrd7RVr5cY8kOnyzsgdJgR0FYP/qW6QzE
         diKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vUNwl5nx1kBf+zxIr2kgBV9jHfRhHo+6UnxNpoEu764=;
        b=db1xcidcPSCjgflQGfCTyvFeH6spSHS7RnZUCzEhhf0hLV6U0HlsuwTb3hxbV0X7LL
         TYtV9VOth1Fd2XWK3dfqWsaAsSDRXwHNQdvmv0SMATGNEBv3vXCtOerncfvddLyoPnmH
         D6q6wmrfhoHRpgwqR6DTXU/LNmnGQj/hXuxjYooJXKsmo0QqlJL5+cm8xCDQJ8i4SWRK
         Y6g+5Av2A/tQKEylKErFnX1RxyENUBne6D/HjUmQgnZtr576hczKP+f+pB7sYoFOX/AZ
         gC5xjv2wmNqi5j7MBhH3H33zf9WH1H6sJk2OdzIaYoE467Tv+smrp0o+4H/VYWb9uI1U
         7ASQ==
X-Gm-Message-State: APjAAAWhldC//yLujaLs/yy7cCeVHamdvEGAJ7U2Ypp1g+FJBJPb+RFE
        Csxx1ZEP6dYZEbcNeIzT5VI=
X-Google-Smtp-Source: APXvYqxP54S0k5F4xY9PPfUNJPXk2Tf+eUtv7hY7EZRTsRWPfiNKA2vpZI3cLL4pQBWulbor0xffRw==
X-Received: by 2002:a17:902:1122:: with SMTP id d31mr35217050pla.254.1565747089009;
        Tue, 13 Aug 2019 18:44:49 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:8a34])
        by smtp.gmail.com with ESMTPSA id 4sm1762511pfn.118.2019.08.13.18.44.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 18:44:48 -0700 (PDT)
Date:   Tue, 13 Aug 2019 18:44:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
Message-ID: <20190814014445.3dnduyrass5jycr5@ast-mbp>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 09:05:44PM +0900, Toshiaki Makita wrote:
> This is a rough PoC for an idea to offload TC flower to XDP.
...
>  xdp_flow  TC        ovs kmod
>  --------  --------  --------
>  4.0 Mpps  1.1 Mpps  1.1 Mpps

Is xdp_flow limited to 4 Mpps due to veth or something else?

> 
> So xdp_flow drop rate is roughly 4x faster than software TC or ovs kmod.
> 
> OTOH the time to add a flow increases with xdp_flow.
> 
> ping latency of first packet when veth1 does XDP_PASS instead of DROP:
> 
>  xdp_flow  TC        ovs kmod
>  --------  --------  --------
>  25ms      12ms      0.6ms
> 
> xdp_flow does a lot of work to emulate TC behavior including UMH
> transaction and multiple bpf map update from UMH which I think increases
> the latency.

make sense, but why vanilla TC is so slow ?

> * Implementation
> 
> xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
> bpfilter. The difference is that xdp_flow does not generate the eBPF
> program dynamically but a prebuilt program is embedded in UMH. This is
> mainly because flow insertion is considerably frequent. If we generate
> and load an eBPF program on each insertion of a flow, the latency of the
> first packet of ping in above test will incease, which I want to avoid.

I think UMH approach is a good fit for this.
Clearly the same algorithm can be done as kernel code or kernel module, but
bpfilter-like UMH is a safer approach.

> - patch 9
>  Add tc-offload-xdp netdev feature and hooks to call xdp_flow kmod in
>  TC flower offload code.

The hook into UMH from TC looks simple. Do you expect the same interface to be
reused from OVS ?

> * About alternative userland (ovs-vswitchd etc.) implementation
> 
> Maybe a similar logic can be implemented in ovs-vswitchd offload
> mechanism, instead of adding code to kernel. I just thought offloading
> TC is more generic and allows wider usage with direct TC command.
> 
> For example, considering that OVS inserts a flow to kernel only when
> flow miss happens in kernel, we can in advance add offloaded flows via
> tc filter to avoid flow insertion latency for certain sensitive flows.
> TC flower usage without using OVS is also possible.
> 
> Also as written above nftables can be offloaded to XDP with this
> mechanism as well.

Makes sense to me.

>   bpf, hashtab: Compare keys in long

3Mpps vs 4Mpps just from this patch ?
or combined with i40 prefech patch ?

>  drivers/net/ethernet/intel/i40e/i40e_txrx.c  |    1 +

Could you share "perf report" for just hash tab optimization
and for i40 ?
I haven't seen memcmp to be bottle neck in hash tab.
What is the the of the key?

