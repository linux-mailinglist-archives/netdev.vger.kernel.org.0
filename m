Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DD950DD96
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238828AbiDYKHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238788AbiDYKHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:07:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56B05340DF
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 03:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650881077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xUVE3QjxnEcUyt3l1Kn+VCQgGOmuad6fFvBiDeALGSg=;
        b=Ko76T9CmMQ5S+spchbh8Z4/kj2y6/SFFaMCQNh+83PN+9oKwXrEmLcQHMq1pyxgLilnM29
        pPA5J03yvkaxHqWOpdtqMmck/yr/tFVJcM1rJFYAPIcY76+eqjK2zw5mhY2xRZC3RfdfeK
        AjyxDQZpWivshBNti/XdDoAELjiHzf8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-rCcb1jsqN0SI-eTVkNtQGQ-1; Mon, 25 Apr 2022 06:04:36 -0400
X-MC-Unique: rCcb1jsqN0SI-eTVkNtQGQ-1
Received: by mail-wr1-f69.google.com with SMTP id l7-20020adfbd87000000b0020ac0a4d23dso2491525wrh.17
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 03:04:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xUVE3QjxnEcUyt3l1Kn+VCQgGOmuad6fFvBiDeALGSg=;
        b=ytsWz6wmHS6e1LSXZyIMB5IH5mBr6UjMRtHaglBrqzm0wmueHqS7bNW4v5fuIHJu2B
         Ysl5S8LpNOlZ6kKoC4uboauI5TTai6KiUPgo8A8N/qfbpTquSgOvNtKQusuU8rpEFsYr
         scpHiQKD5U7Y6l1DlelwuZbbv1Owoa2lcKBBfcPiDCi3dbUBlGgr6k6CcUldRW69Ywyt
         uT1ckbe3d2p3ds9BR51MjJit1YEW2D/nNJ6X9l/FRwAC4+kwupJKDhR69Zf0U92YhPRW
         PwG8iL3ClfaTDZ4u75XRhtACZTpXWx3kst3o1ybakZaBSWI65qKyZ4HBREY+4tSlsu2m
         H3qQ==
X-Gm-Message-State: AOAM530B3UHefoz4zlKAvEE3NiDtN73eHLcpaFhr4qlSxu1ksVXY0Qd5
        /pGIGBcCIuGr9Tbp83zNkjP/1zvVJIEE8R3q6LUz8/cBnBoKy5CaZVtpVRjiDJlqniLESL9VqW1
        b+mC4sD6NLxveavV4
X-Received: by 2002:a1c:f705:0:b0:37d:f2e5:d8ec with SMTP id v5-20020a1cf705000000b0037df2e5d8ecmr25566317wmh.21.1650881074502;
        Mon, 25 Apr 2022 03:04:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfG5/QsPJkaUqXVophqD6dyxQQBTLxwx3cEznHKMkmXORQL+OmZl48WKeg/osln6RdOEeNag==
X-Received: by 2002:a1c:f705:0:b0:37d:f2e5:d8ec with SMTP id v5-20020a1cf705000000b0037df2e5d8ecmr25566309wmh.21.1650881074326;
        Mon, 25 Apr 2022 03:04:34 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id e1-20020a05600c4e4100b00392910b276esm8308791wmq.9.2022.04.25.03.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 03:04:33 -0700 (PDT)
Date:   Mon, 25 Apr 2022 12:04:32 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dccp@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] ipv4: Don't reset ->flowi4_scope in
 ip_rt_fix_tos().
Message-ID: <20220425100432.GA3478@pc-4.home>
References: <cover.1650470610.git.gnault@redhat.com>
 <c3fdfe3353158c9b9da14602619fb82db5e77f27.1650470610.git.gnault@redhat.com>
 <0d4e27ee-385c-fd5d-bd31-51e9e2382667@kernel.org>
 <20220422105345.GA15621@debian.home>
 <96b6dc1f-cf7b-73fe-d069-7ae16b3dcda2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96b6dc1f-cf7b-73fe-d069-7ae16b3dcda2@kernel.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 08:40:01AM -0600, David Ahern wrote:
> On 4/22/22 4:53 AM, Guillaume Nault wrote:
> > On Thu, Apr 21, 2022 at 08:30:52PM -0600, David Ahern wrote:
> >> On 4/20/22 5:21 PM, Guillaume Nault wrote:
> >>> All callers already initialise ->flowi4_scope with RT_SCOPE_UNIVERSE,
> >>> either by manual field assignment, memset(0) of the whole structure or
> >>> implicit structure initialisation of on-stack variables
> >>> (RT_SCOPE_UNIVERSE actually equals 0).
> >>>
> >>> Therefore, we don't need to always initialise ->flowi4_scope in
> >>> ip_rt_fix_tos(). We only need to reduce the scope to RT_SCOPE_LINK when
> >>> the special RTO_ONLINK flag is present in the tos.
> >>>
> >>> This will allow some code simplification, like removing
> >>> ip_rt_fix_tos(). Also, the long term idea is to remove RTO_ONLINK
> >>> entirely by properly initialising ->flowi4_scope, instead of
> >>> overloading ->flowi4_tos with a special flag. Eventually, this will
> >>> allow to convert ->flowi4_tos to dscp_t.
> >>>
> >>> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> >>> ---
> >>> It's important for the correctness of this patch that all callers
> >>> initialise ->flowi4_scope to 0 (in one way or another). Auditing all of
> >>> them is long, although each case is pretty trivial.
> >>>
> >>> If it helps, I can send a patch series that converts implicit
> >>> initialisation of ->flowi4_scope with an explicit assignment to
> >>> RT_SCOPE_UNIVERSE. This would also have the advantage of making it
> >>> clear to future readers that ->flowi4_scope _has_ to be initialised. I
> >>> haven't sent such patch series to not overwhelm reviewers with trivial
> >>> and not technically-required changes (there are 40+ places to modify,
> >>> scattered over 30+ different files). But if anyone prefers explicit
> >>> initialisation everywhere, then just let me know and I'll send such
> >>> patches.
> >>
> >> There are a handful of places that open code the initialization of the
> >> flow struct. I *think* I found all of them in 40867d74c374.
> > 
> > By open code, do you mean "doesn't use flowi4_init_output() nor
> > ip_tunnel_init_flow()"? If so, I think there are many more.
> > 
> 
> no, you made a comment about flow struct being initialized to 0 which
> implicitly initializes scope. My comment is that there are only a few
> places that do not use either `memset(flow, 0, sizeof())` or `struct
> flowi4 fl4 = {}` to fully initialize the struct.

Yes, that's right. But I've only audited the call paths that lead to
ip_route_output_key_hash() (plus the ICMP error handlers), as these are
the ones that were relevant for this patch series. So I haven't looked
at flow initialisation in the ip_route_input*() or IPv6 call paths.

