Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2654B1AAB41
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 17:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394185AbgDOPBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 11:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2394183AbgDOPBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 11:01:52 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CEEC061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 08:01:51 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w65so57383pfc.12
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 08:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zLUIrV4qIHVwDBWFqTHkEAK7lsWcGGutOTlj6QjZqSY=;
        b=XuTB/7EgvGzFc4UH3EXebo1DO9MaGi32clooHLxoKvWlia76dEUS7k224OWsNaPJnu
         DaeonUjTd1FluF/TymFZo0KVBXUkaZdKkAAK7zyKBqXNCoLdgH57faaCpbvBSqadKuTN
         WNkfSNOLv24dRQ2kZxpuoIHntyj8sxESz8KuHGEYNGu1smC9eMSBERTEAbHOApanMnAm
         vx1Kg4nw5o+cyUUzgsZFBWNoO9E3VyfmvTFBA4WVv4KldWRIxCgpn6h61mVN11T+Hqi1
         2z84OqPCfz/vrix6Z+brfoga8rkiOap2y8/Ziej+Bdt+scoJJaKZtfYUWImiPO2MyoZx
         846g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zLUIrV4qIHVwDBWFqTHkEAK7lsWcGGutOTlj6QjZqSY=;
        b=ZFPOPlvZfgivD79hqSlKtMhKqEuvGGXzQ5+8u8NdqDnYJxqRbUKmNf6J20Io2obEn5
         Fn5HZ7ey/kp5IeCT0xL2v2trtcMoKbc7SLi1OOUBkaeCmCUzHvvJ9DCnTcHoQ14hNRwm
         tKJCMXJJ6NhLpJDlRN5K1OI7q3Vi72lvVHthIbFpkE40S2fFJ1BuFlHpdj5bn0LJ8VL0
         DAwClA1lYKJNgMCtXskRBANpZqQ8xEOm0ju8jDLBDK/Mbtx/oyf+kVjYrCIcqMyKJf2c
         39b+Be93W2kyQMdwFx2qNu0zHJu7ub1U5B0i5XmtythcrC2qAUad60FxvYl8pzGxJMdn
         Jfzw==
X-Gm-Message-State: AGi0PuYCYDIlLdTmI9O2CgVXexq2aqr3Ybqsz5ydsKGdIDakiEZ8Yib3
        ep07Km2EEL+dYJCxj5QfchU=
X-Google-Smtp-Source: APiQypI+Zq+z8ZgtHnjmslPNVEbxMggDksNNfm9N7EjYShLcVHgk3VXsH1qHbigTvPl5/b5ZaYxCqQ==
X-Received: by 2002:aa7:931a:: with SMTP id 26mr27280456pfj.11.1586962911229;
        Wed, 15 Apr 2020 08:01:51 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:40b6])
        by smtp.gmail.com with ESMTPSA id j16sm11863181pgi.40.2020.04.15.08.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 08:01:50 -0700 (PDT)
Date:   Wed, 15 Apr 2020 08:01:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC-v5 bpf-next 12/12] samples/bpf: add XDP egress
 support to xdp1
Message-ID: <20200415150147.emllpnh5dnp72lea@ast-mbp>
References: <20200413171801.54406-1-dsahern@kernel.org>
 <20200413171801.54406-13-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413171801.54406-13-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 11:18:01AM -0600, David Ahern wrote:
> From: David Ahern <dahern@digitalocean.com>
> 
> xdp1 and xdp2 now accept -E flag to set XDP program in the egress
> path.
> 
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  samples/bpf/xdp1_user.c | 38 +++++++++++++++++++++++++++++++-------
>  1 file changed, 31 insertions(+), 7 deletions(-)

samples are great to see, but not enough. selftests/bpf is _mandatory_
for any new feature.
