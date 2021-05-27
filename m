Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B00039248C
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbhE0Buz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233044AbhE0Buy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 21:50:54 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DD3C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 18:49:22 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id ee9so1837060qvb.8
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 18:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nZWJ4KtmWre0H886xS86T1Rlq9eoppffftmkC5fCuOk=;
        b=fD2Ru/+tK++imWBvESIvOLEulkb9mAYjr19bTfvl31Qa+J1rQ99MlRQeC/ffEUI4JH
         FmyGDyxmYd9mcVRwVGvCUYNWisXAij/YyGq7X3sua/lJsSHqjVa7EyZmxa40/vGNKNfE
         ybVjxQoHvMowW7+LL024Nl/E5DRrnekbE1pRmBjt1Gl7D3Y6KdoLFI4mw1aaOFy4YvwY
         PoMDlgsqfdBCLpwh7jaclKImSkTvkhiHFQs31aYZsi172dLLLNggnSNGv6IfcvcS7xmA
         oQnrP0x/BAF2oFZne5azlG46Bu1B9E3cVUX4VBXqyGGO7/tGtFLQmpsUZM4TFd/5FH0d
         7zMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nZWJ4KtmWre0H886xS86T1Rlq9eoppffftmkC5fCuOk=;
        b=tpbgZ7bNFilKH/CxY/j/iqxfWn6LR9ttfNEDbyA86hNmmX80Fy0JUEy4OHKQRJD8sg
         NGPC9O/CKz/SzlLaG8ryr2Mws+f0Sp4SG2PajKHRjf79l5X+cYzEAd7pukArJbKJIPlM
         Cx1fjKL22BWdQTUZ7YCpTc/Y8jylI/ZStYsnEs/W912I8HFGr5cPcEqSDe7vXBPHuRW8
         9MID+3bFxAwyfT44LVPp/GdzEoIt8f/Yx81I0dx1T1wM8qAvOwgTVJ60v+sm4dlgJ3vj
         ijD7leyBvPQV7fV+qaX5zp4+8pBZBv7XciqiTMJuiPrQWRgCdqyZq51ABewy8z6BZZ8a
         aq9w==
X-Gm-Message-State: AOAM531HjODOWqarRwR0K4sY7yAieopyncwi5DyrJ0vkYJTnIo5Jhg/0
        w3Dnpii+K94KkGBEG24n+yI=
X-Google-Smtp-Source: ABdhPJz8T8BQrhuLw1VrhA7fTJMiEKJ5JQiTTovO5w30LhO0JljbNQPpRzbQgpdiZpSRtKirKblDtw==
X-Received: by 2002:a0c:99db:: with SMTP id y27mr975853qve.19.1622080161575;
        Wed, 26 May 2021 18:49:21 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f013:c858:4e88:b1d7:83be:b613])
        by smtp.gmail.com with ESMTPSA id g3sm497045qth.19.2021.05.26.18.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 18:49:21 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 0775EC169D; Wed, 26 May 2021 22:49:18 -0300 (-03)
Date:   Wed, 26 May 2021 22:49:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Ariel Levkovich <lariel@nvidia.com>
Cc:     netdev@vger.kernel.org, paulb@nvidia.com, jiri@resnulli.us
Subject: Re: [PATCH net] net/sched: act_ct: Fix ct template allocation for
 zone 0
Message-ID: <YK76nZpfTBO904lU@horizon.localdomain>
References: <20210526170110.54864-1-lariel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526170110.54864-1-lariel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 08:01:10PM +0300, Ariel Levkovich wrote:
> Fix current behavior of skipping template allocation in case the
> ct action is in zone 0.
> 
> Skipping the allocation may cause the datapath ct code to ignore the
> entire ct action with all its attributes (commit, nat) in case the ct
> action in zone 0 was preceded by a ct clear action.
> 
> The ct clear action sets the ct_state to untracked and resets the
> skb->_nfct pointer. Under these conditions and without an allocated
> ct template, the skb->_nfct pointer will remain NULL which will
> cause the tc ct action handler to exit without handling commit and nat
> actions, if such exist.
> 
> For example, the following rule in OVS dp:
> recirc_id(0x2),ct_state(+new-est-rel-rpl+trk),ct_label(0/0x1), \
> in_port(eth0),actions:ct_clear,ct(commit,nat(src=10.11.0.12)), \
> recirc(0x37a)
> 
> Will result in act_ct skipping the commit and nat actions in zone 0.
> 
> The change removes the skipping of template allocation for zone 0 and
> treats it the same as any other zone.
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
> ---
>  net/sched/act_ct.c | 3 ---

Hah! I guess I had looked only at netfilter code regarding
NF_CT_DEFAULT_ZONE_ID.

>  1 file changed, 3 deletions(-)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index ec7a1c438df9..dfdfb677e6a9 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -1202,9 +1202,6 @@ static int tcf_ct_fill_params(struct net *net,
>  				   sizeof(p->zone));
>  	}
>  
> -	if (p->zone == NF_CT_DEFAULT_ZONE_ID)
> -		return 0;
> -

This patch makes act_ct behave like ovs kernel datapath, but I'm not
sure ovs kernel is doing the right thing. :-) (jump to last paragraph
for my suggestion, might ease the reading)

As you described:
"The ct clear action sets the ct_state to untracked and resets the
skb->_nfct pointer." I think the problem lies on the first part, on
setting it to untracked.

That was introduced in ovs kernel on commit b8226962b1c4
("openvswitch: add ct_clear action") and AFAICT the idea there was to
"reset it to original state" [A].

Then ovs userspace has commit 0cdfddddb664 ("datapath: add ct_clear
action") as well, a mirror of the one above. There, it is noted:
"   - if IP_CT_UNTRACKED is not available use 0 as other nf_ct_set()
     calls do. Since we're setting ct to NULL this is okay."

Thing is, IP_CT_ESTABLISHED is the first member of enum
ip_conntrack_info and evalutes 0, while IP_CT_UNTRACKED is actually:
include/uapi/linux/netfilter/nf_conntrack_common.h:
        /* only for userspace compatibility */
#ifndef __KERNEL__
        IP_CT_NEW_REPLY = IP_CT_NUMBER,
#else
        IP_CT_UNTRACKED = 7,
#endif

In the commits above, none of them mention that the packet should be
set to Untracked. That's a different thing than "undoing CT"..
That setting untrack here is the equivalent of:
  # iptables -A ... -j CT --notrack

Then, when it finally reaches nf_conntrack_in:
          tmpl = nf_ct_get(skb, &ctinfo);
	      vvvv--- NULL if from act_ct and zone 0, !NULL if from ovs
          if (tmpl || ctinfo == IP_CT_UNTRACKED) {
	                     ^^-- always true after ct_clear
                  /* Previously seen (loopback or untracked)?  Ignore. */
                  if ((tmpl && !nf_ct_is_template(tmpl)) ||
                       ctinfo == IP_CT_UNTRACKED)
		              ^^--- always true..
                          return NF_ACCEPT;
			  ^^ returns her
                  skb->_nfct = 0;
          }

If ct_clear (act_ct and ovs) instead set it 0 (which, well, it's odd
but maps to IP_CT_ESTABLISHED), it wouldn't match on the conditions
above, and would do CT normally.

With all that, what about keeping the check here, as it avoids an
allocation that AFAICT is superfluous when not setting a zone != 0 and
atomics for _get/_put, and changing ct_clear instead (act_ct and ovs),
to NOT set the packet as IP_CT_UNTRACKED?

Thanks,
Marcelo

>  	nf_ct_zone_init(&zone, p->zone, NF_CT_DEFAULT_ZONE_DIR, 0);
>  	tmpl = nf_ct_tmpl_alloc(net, &zone, GFP_KERNEL);
>  	if (!tmpl) {
> -- 
> 2.25.2
> 
