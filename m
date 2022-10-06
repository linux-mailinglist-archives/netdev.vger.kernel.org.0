Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8825F605F
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 07:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJFFBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 01:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJFFA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 01:00:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5316A6555B;
        Wed,  5 Oct 2022 22:00:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id p3-20020a17090a284300b0020a85fa3ffcso3316182pjf.2;
        Wed, 05 Oct 2022 22:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=m+vauEjniZkyBVTIFPHjqy8YYa004OnW0Mq7lTCgICc=;
        b=ZStaP4gpO4xho2Ip0ERmsqUevypMHJkmb3wxE9NFAEV4AQTcEy+fiq3U6LyFLSVDVm
         k7ci2fylzkGBBhD4iYAIC+uWbZ/FGqQf4FF5KDRe6/OCnX7pHou+Gu4eTQrymMxGWATI
         sKyNQ07reAb+TrrZoc1yWJTLiNjdoOFas4HIvN04VnNsIQ0XO5Bu8Q6TSHiuI2xYn+yO
         cxgf5uiWPiIFJlkL9h+qvqPja+FmfR+LpOlbIUjMsgGiDrHu3plnON5sAd7PwVr+PARl
         r7azeennzAomNJC8yHNDO5LIILv/c1mcDvJ9jesDMQKHNJyXkkNXiLzA0vLiDtyhw13h
         sLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=m+vauEjniZkyBVTIFPHjqy8YYa004OnW0Mq7lTCgICc=;
        b=Hhn7gk3axZFGxNEGp5+tTzd4/pgccf+LWPKOHOyxTvbG/8zrG6p91FteMPhpZDhxkI
         xuBa451qy4RCre9DGn0uUHcd+ZsnRoAlzl7tYRqf1jII38JtK/OxEl6WhaFpsRk8x/JD
         P3BNqsVouUBwgV7SopAxnZ0QNelkyYQE84IHCr0I/xRuJOGS9DbrciSB99FDL9fO32Ol
         nRMfqk5Jf29Ar5cqtXI6Z/Qs+1LlHySwY5NQU5xlmGUkqn5xp1DSHZ6P0feHigtiHq5z
         GxaxuxpAXbC/U3MJagFOPlQKQTXDbcjYJJ+7ZsSfC71kgVCw7XANz7JvzhWhR9SBgBAd
         PCRA==
X-Gm-Message-State: ACrzQf1xWTw1NP06zNiqX+NMeHZ174krETiYWdM6B0MIwZUEs2CbAoB2
        buBheVjA7wksTW7tveiEskg=
X-Google-Smtp-Source: AMsMyM5S3OLT1c8rB7Hmhfz5232wjIk9PwIxh46ZOChT/rCTdF1qPXtOX71v1Wq9UOwsPPdTidY6Iw==
X-Received: by 2002:a17:902:8643:b0:17a:3e74:d2a6 with SMTP id y3-20020a170902864300b0017a3e74d2a6mr2911168plt.120.1665032457567;
        Wed, 05 Oct 2022 22:00:57 -0700 (PDT)
Received: from macbook-pro-4.dhcp.thefacebook.com ([2620:10d:c090:400::5:d9ff])
        by smtp.gmail.com with ESMTPSA id p18-20020a631e52000000b004405c6eb962sm717529pgm.4.2022.10.05.22.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 22:00:56 -0700 (PDT)
Date:   Wed, 5 Oct 2022 22:00:53 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach
 tc BPF programs
Message-ID: <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004231143.19190-2-daniel@iogearbox.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 01:11:34AM +0200, Daniel Borkmann wrote:
> +
> +static int __xtc_prog_attach(struct net_device *dev, bool ingress, u32 limit,
> +			     struct bpf_prog *nprog, u32 prio, u32 flags)
> +{
> +	struct bpf_prog_array_item *item, *tmp;
> +	struct xtc_entry *entry, *peer;
> +	struct bpf_prog *oprog;
> +	bool created;
> +	int i, j;
> +
> +	ASSERT_RTNL();
> +
> +	entry = dev_xtc_entry_fetch(dev, ingress, &created);
> +	if (!entry)
> +		return -ENOMEM;
> +	for (i = 0; i < limit; i++) {
> +		item = &entry->items[i];
> +		oprog = item->prog;
> +		if (!oprog)
> +			break;
> +		if (item->bpf_priority == prio) {
> +			if (flags & BPF_F_REPLACE) {
> +				/* Pairs with READ_ONCE() in xtc_run_progs(). */
> +				WRITE_ONCE(item->prog, nprog);
> +				bpf_prog_put(oprog);
> +				dev_xtc_entry_prio_set(entry, prio, nprog);
> +				return prio;
> +			}
> +			return -EBUSY;
> +		}
> +	}
> +	if (dev_xtc_entry_total(entry) >= limit)
> +		return -ENOSPC;
> +	prio = dev_xtc_entry_prio_new(entry, prio, nprog);
> +	if (prio < 0) {
> +		if (created)
> +			dev_xtc_entry_free(entry);
> +		return -ENOMEM;
> +	}
> +	peer = dev_xtc_entry_peer(entry);
> +	dev_xtc_entry_clear(peer);
> +	for (i = 0, j = 0; i < limit; i++, j++) {
> +		item = &entry->items[i];
> +		tmp = &peer->items[j];
> +		oprog = item->prog;
> +		if (!oprog) {
> +			if (i == j) {
> +				tmp->prog = nprog;
> +				tmp->bpf_priority = prio;
> +			}
> +			break;
> +		} else if (item->bpf_priority < prio) {
> +			tmp->prog = oprog;
> +			tmp->bpf_priority = item->bpf_priority;
> +		} else if (item->bpf_priority > prio) {
> +			if (i == j) {
> +				tmp->prog = nprog;
> +				tmp->bpf_priority = prio;
> +				tmp = &peer->items[++j];
> +			}
> +			tmp->prog = oprog;
> +			tmp->bpf_priority = item->bpf_priority;
> +		}
> +	}
> +	dev_xtc_entry_update(dev, peer, ingress);
> +	if (ingress)
> +		net_inc_ingress_queue();
> +	else
> +		net_inc_egress_queue();
> +	xtc_inc();
> +	return prio;
> +}

...

> +static __always_inline enum tc_action_base
> +xtc_run(const struct xtc_entry *entry, struct sk_buff *skb,
> +	const bool needs_mac)
> +{
> +	const struct bpf_prog_array_item *item;
> +	const struct bpf_prog *prog;
> +	int ret = TC_NEXT;
> +
> +	if (needs_mac)
> +		__skb_push(skb, skb->mac_len);
> +	item = &entry->items[0];
> +	while ((prog = READ_ONCE(item->prog))) {
> +		bpf_compute_data_pointers(skb);
> +		ret = bpf_prog_run(prog, skb);
> +		if (ret != TC_NEXT)
> +			break;
> +		item++;
> +	}
> +	if (needs_mac)
> +		__skb_pull(skb, skb->mac_len);
> +	return xtc_action_code(skb, ret);
> +}

I cannot help but feel that prio logic copy-paste from old tc, netfilter and friends
is done because "that's how things were done in the past".
imo it was a well intentioned mistake and all networking things (tc, netfilter, etc)
copy-pasted that cumbersome and hard to use concept.
Let's throw away that baggage?
In good set of cases the bpf prog inserter cares whether the prog is first or not.
Since the first prog returning anything but TC_NEXT will be final.
I think prog insertion flags: 'I want to run first' vs 'I don't care about order'
is good enough in practice. Any complex scheme should probably be programmable
as any policy should. For example in Meta we have 'xdp chainer' logic that is similar
to libxdp chaining, but we added a feature that allows a prog to jump over another
prog and continue the chain. Priority concept cannot express that.
Since we'd have to add some "policy program" anyway for use cases like this
let's keep things as simple as possible?
Then maybe we can adopt this "as-simple-as-possible" to XDP hooks ?
And allow bpf progs chaining in the kernel with "run_me_first" vs "run_me_anywhere"
in both tcx and xdp ?
Naturally "run_me_first" prog will be the only one. No need for F_REPLACE flags, etc.
The owner of "run_me_first" will update its prog through bpf_link_update.
"run_me_anywhere" will add to the end of the chain.
In XDP for compatibility reasons "run_me_first" will be the default.
Since only one prog can be enqueued with such flag it will match existing single prog behavior.
Well behaving progs will use (like xdp-tcpdump or monitoring progs) will use "run_me_anywhere".
I know it's far from covering plenty of cases that we've discussed for long time,
but prio concept isn't really covering them either.
We've struggled enough with single xdp prog, so certainly not advocating for that.
Another alternative is to do: "queue_at_head" vs "queue_at_tail". Just as simple.
Both simple versions have their pros and cons and don't cover everything,
but imo both are better than prio.
