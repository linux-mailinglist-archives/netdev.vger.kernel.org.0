Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C985578221
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiGRMWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiGRMWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:22:05 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157AA24F3F
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 05:22:03 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so7211282wmb.5
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 05:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nS8BrUJlcx3O0As5RCswdI/Y0VaO9P6aCOLOUYcd/Lk=;
        b=QpN8Q09BBY5ivZKeE7bdhbJ0fOmepyuOm6jmBC6iOthuOqa2Ki+1yPY9qDPv7sapsZ
         VELrkXzvprg2yAPGOIToN5pkZ+iL57cYILuFCi9Au0U1mzw0nbH6XqJVNLwvUcgbuqng
         /aQqV0QmmWeiA0Q4qtpECrpvLkTnE1cLd88UTY0Zn2Q620JsUgv4LXwhzpG1xmCajUoT
         IIc24R1I+Nsv8LyJ2tVnFpFOciDaN7SkgWMuev44l+PSV0/qjHxd2zkLnkWIdjVCPS/O
         ckgGJK/H4TgdOSpeAnFFG2GsxzKBDJebaj6HMq4Ri44rpcpgIcWR3HX833wp3LBy9dIS
         gaiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nS8BrUJlcx3O0As5RCswdI/Y0VaO9P6aCOLOUYcd/Lk=;
        b=50WcLW1CMMdUHLcn2P96Re4i5tjg2ci4Py/Ia1pAe0josEDM7jh2Q3EzNIeTIVDCkO
         Xg2dbJTEjmjNZdf3bvtazyhCb4uy9urTJxN7RpMqYSFPaAK/0K+FWPbOQoDHuksLvGe/
         LfJIwdaup6XI0+s6FEhkbRtAuocu7dvRJjFZyZvwDcBBgVWuQYzYThuHO8wDgY972RqF
         WSXTe6xfNf0dEOnbDQhUIjEZ/TAcYcQ9RwZ5upbDr19oYhuyIrCdMblyPOvdSRhNzjY9
         7RljSpW7QtKMQVdfWunU0kH/97PYC2gZh50xtkJgGSKtkH0zIC40n261z5NVcT5DgEqg
         AXJw==
X-Gm-Message-State: AJIora+D1v68SvRK7l12AMqDibZvdQ9P6vgiddE1pBZycTWz6liYBEKy
        fVSVyxJg4JkOxAiPts6Tep98
X-Google-Smtp-Source: AGRyM1sDn3Z6YN+O+7XYWRrScGZPCdNJdJ/7p4OtJHde5Kyq2TqBMDNAq2WMsssLlctuFwKHgazjuA==
X-Received: by 2002:a05:600c:1e83:b0:3a2:f96b:6c48 with SMTP id be3-20020a05600c1e8300b003a2f96b6c48mr25993563wmb.198.1658146921600;
        Mon, 18 Jul 2022 05:22:01 -0700 (PDT)
Received: from Mem (2a01cb088160fc006422ad4f4c265774.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:6422:ad4f:4c26:5774])
        by smtp.gmail.com with ESMTPSA id q17-20020a5d6591000000b0021b829d111csm10541025wru.112.2022.07.18.05.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 05:22:01 -0700 (PDT)
Date:   Mon, 18 Jul 2022 14:21:59 +0200
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
Message-ID: <20220718122159.GA23451@Mem>
References: <cover.1657895526.git.paul@isovalent.com>
 <627e34e78283b84c79db8945b05930b70eeaa925.1657895526.git.paul@isovalent.com>
 <fe77bef0-bbfa-261d-6419-548160c986e5@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe77bef0-bbfa-261d-6419-548160c986e5@fb.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

That's a good point; I didn't know about bpf_lwt_xmit_reroute. I set the
flag for IPv6 as the same check seemed to exist, but didn't test it.
I'll check if it's actually needed.

> 
> >   	if (flags & BPF_F_TUNINFO_IPV6) {
> >   		info->mode |= IP_TUNNEL_INFO_IPV6;
