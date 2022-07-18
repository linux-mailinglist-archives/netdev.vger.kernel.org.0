Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49CE5786EA
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbiGRQEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbiGRQEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:04:09 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D918A616A
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:04:07 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h17so17802982wrx.0
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BLQKlhIDTPBwzVBGPq9qp9erdvGfKtRolD9aeKLSQT4=;
        b=zJ2pMQ6vsCE693gONX6Y8n5AbjmpEWbaNyXPo/Pha7ek0LIOCJokVgfSEYU6NbRRTy
         2bSrMWT/Rwt1tUguROqLMnkgM0vv2RBLebcQwIn4qbOHYE21wZguck2SznMUIZ3wveje
         zYKpxhVOHytSjOBOAdA3Q86A4zOnMwrzrkWevwQIIqI5TshJSQlqI721xqjVUEAdoBkl
         c56dOvKEy0eG31gvlwO8N7FXLM0xHeu0c4yJ7CnITgcMipv8PRgR0e65mvjizvFwJ4Cg
         CCLKqwKZitCbjJmO209DJmqR5PBEZ/r8hbcAf90RVlA1KYmEVQzyD0cW6opYFQ3F/d3v
         FdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BLQKlhIDTPBwzVBGPq9qp9erdvGfKtRolD9aeKLSQT4=;
        b=de5ogOAcT+16oxnbn72M15NgPwoaSlKLz2c302qd+amCrEzAdmaoYzNqXL2XyJv2TX
         wky1hOn9TXPuzGuj1rxdahnmokA4WwGmKAzLZ0e3mTj2HktVTkUmvJ0Vpdq/c9oxFznz
         QMiNRO2J6u5mSThX8S6CFM5Tcl/pqQgqjHqiN1WLHFGHxR4cd8cWmIt0/FBnvO4Tixib
         h/OuoY2T8UNkbfTNX0LGZG75BNPch1xXF94lFYzuJRgOXg8xKIVJNy/8yncc2tGkDnGr
         2NZknjmbTsr6ngbzt/1bGsxdvFheIZJTRYSFXu908ag4EDkGbnd+Hy+Zy5hV0a5daYFM
         nO5A==
X-Gm-Message-State: AJIora9XhPhnO1x6BChA14z9RWzR5PSnDbndYpfOwN7rA+yAVAiz5F5Q
        1bljxkuytwp00M6c0USv/WEw
X-Google-Smtp-Source: AGRyM1vvhfztTiOKC7FnuaAhKckAWTI/SKXTyNRzYeieBMZywBMrc8EFFGuxriqfR0xFyJQQu7QcBg==
X-Received: by 2002:adf:f0c1:0:b0:21d:ed10:5811 with SMTP id x1-20020adff0c1000000b0021ded105811mr10296701wro.656.1658160246295;
        Mon, 18 Jul 2022 09:04:06 -0700 (PDT)
Received: from Mem (2a01cb088160fc006422ad4f4c265774.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:6422:ad4f:4c26:5774])
        by smtp.gmail.com with ESMTPSA id h18-20020a05600c351200b003a3199c243bsm7085639wmq.0.2022.07.18.09.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 09:04:05 -0700 (PDT)
Date:   Mon, 18 Jul 2022 18:04:03 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH bpf 4/5] bpf: Set flow flag to allow any source IP in
 bpf_tunnel_key
Message-ID: <20220718160403.GA233852@Mem>
References: <cover.1657895526.git.paul@isovalent.com>
 <627e34e78283b84c79db8945b05930b70eeaa925.1657895526.git.paul@isovalent.com>
 <fe77bef0-bbfa-261d-6419-548160c986e5@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe77bef0-bbfa-261d-6419-548160c986e5@fb.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 11:21:08AM -0700, Yonghong Song wrote:
> On 7/15/22 8:02 AM, Paul Chaignon wrote:
> > Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> > added support for getting and setting the outer source IP of encapsulated
> > packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
> > allows BPF programs to set any IP address as the source, including for
> > example the IP address of a container running on the same host.
> > 
> > In that last case, however, the encapsulated packets are dropped when
> > looking up the route because the source IP address isn't assigned to any
> > interface on the host. To avoid this, we need to set the
> > FLOWI_FLAG_ANYSRC flag.
> > 
> > Fixes: 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> > Signed-off-by: Paul Chaignon <paul@isovalent.com>
> > ---
> >   net/core/filter.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 5d16d66727fc..6d9c800cdab9 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -4641,6 +4641,7 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *, skb,
> >   	info->key.tun_id = cpu_to_be64(from->tunnel_id);
> >   	info->key.tos = from->tunnel_tos;
> >   	info->key.ttl = from->tunnel_ttl;
> > +	info->key.flow_flags = FLOWI_FLAG_ANYSRC;
> 
> Can we set FLOWI_FLAG_ANYSRC in all conditions?
> In lwt_bpf.c, func bpf_lwt_xmit_reroute(), FLOWI_FLAG_ANYSRC
> is set for ipv4 but not for ipv6. I am wondering whether
> FLOWI_FLAG_ANYSRC needs to be set for ipv6 packet or not
> in bpf_skb_set_tunnel_key().

I've confirmed that IPv6-encapsulated packets are not dropped even if
the flag is not set and the outer source IP address is not assigned to
the host. This is also expected given we never check for
FLOWI_FLAG_ANYSRC on the IPv6 path. I must have been confused by the
fact we sometimes still set FLOWI_FLAG_ANYSRC for IPv6.

I've sent a v2 without the changes to IPv6 code paths.

> 
> >   	if (flags & BPF_F_TUNINFO_IPV6) {
> >   		info->mode |= IP_TUNNEL_INFO_IPV6;
