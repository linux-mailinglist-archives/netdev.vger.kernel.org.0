Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9746C299B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 06:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCUFKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 01:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjCUFJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 01:09:59 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE7835EFC
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 22:09:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id k2so14879319pll.8
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 22:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google; t=1679375289;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YVBCNyKMZVVmLFFHqt5fOyRwqj6sJa+u3FQimK/ukqI=;
        b=bK2r86ZjYFuTDuW61ASfjj4DpQop0n0MruTSJ5cU7ryAccFk2wgk7jAQSpc4oPmZfE
         tEAp5ZKVgOj5N3E7yLUH97tSbELmCTkLfUdtmwXBP8SObAFAN/t+3r9bafmPxlPiRw0Q
         qX8uB/DG5yNeKTaKAu8AEqs8sUIx1XfXfhLus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679375289;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YVBCNyKMZVVmLFFHqt5fOyRwqj6sJa+u3FQimK/ukqI=;
        b=VAEh9YUQFS8LMpaWDiTEoB3JkHq+5eg4b23cBzXH38H4i3MJ0gn2kzaZI7MSIEtCoV
         xyWcReCiOkVa6QiVLeTlSKrh+2ene/L5unRfPa3AutQ3bq7CVQTy7aF5hH/VVUFIQTXN
         NkPmx6yXlGE6RHpKV+3sQ8g3LYUY8Tox2GBAIZabw95NpjnxQpNISYXyyVYlEpszjvR/
         3Z6Jmts6gaPlrP4yThl3WjHtUUrx7BIJ5b6aFR47q8P2ySib9H//+DggB2lwdbiryY2S
         6nTOUiWKAf8T9+qk8o1VjmC/fGYvT9T7XWkBJciEj8WzcHXwjbWsVLPjh/Hm/LWR9H8w
         qJcg==
X-Gm-Message-State: AO0yUKXO8mxkx9+h+98biJ8NY7SKpalPwmraJQKsHcgod0WN2ZTlPgm0
        o2iav3vZu/LM6El/Jc2TPAJHSg==
X-Google-Smtp-Source: AK7set8LiZwCGpkRWb/bR1Eeq1iWL3LdZvh2zT+U2b0GoYIPWiHh1JG8o/NL6oJWj5OlsRNFQaYMsg==
X-Received: by 2002:a17:902:db08:b0:19e:82aa:dc8a with SMTP id m8-20020a170902db0800b0019e82aadc8amr1281140plx.22.1679375288699;
        Mon, 20 Mar 2023 22:08:08 -0700 (PDT)
Received: from ubuntu ([121.133.63.188])
        by smtp.gmail.com with ESMTPSA id p9-20020a170902bd0900b001a075503ab8sm3295247pls.132.2023.03.20.22.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 22:08:08 -0700 (PDT)
Date:   Mon, 20 Mar 2023 22:08:03 -0700
From:   Hyunwoo Kim <v4bel@theori.io>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dmitry Kozlov <xeb@mail.ru>,
        David Ahern <dsahern@kernel.org>, tudordana@google.com,
        netdev@vger.kernel.org, imv4bel@gmail.com, v4bel@theori.io
Subject: Re: [PATCH] net: Fix invalid ip_route_output_ports() call
Message-ID: <20230321050803.GA22060@ubuntu>
References: <20230321024946.GA21870@ubuntu>
 <CANn89i+=-BTZyhg9f=Vyz0rws1Z-1O-F5TkESBjkZnKmHeKz1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+=-BTZyhg9f=Vyz0rws1Z-1O-F5TkESBjkZnKmHeKz1g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 08:17:15PM -0700, Eric Dumazet wrote:
> On Mon, Mar 20, 2023 at 7:49 PM Hyunwoo Kim <v4bel@theori.io> wrote:
> >
> > If you pass the address of the struct flowi4 you declared as a
> > local variable as the fl4 argument to ip_route_output_ports(),
> > the subsequent call to xfrm_state_find() will read the local
> > variable by AF_INET6 rather than AF_INET as per policy,
> > which could cause it to go out of scope on the kernel stack.
> >
> > Reported-by: syzbot+ada7c035554bcee65580@syzkaller.appspotmail.com
> 
> I could not find this syzbot issue, can you provide a link, and a stack trace ?

This is the syzbot dashboard:
https://syzkaller.appspot.com/bug?extid=0f526bf9663842ac2dc7


and KASAN log:
```
[  239.016529] ==================================================================
[  239.016540] BUG: KASAN: stack-out-of-bounds in xfrm_state_find+0x2b8/0x2ae0
[  239.016556] Read of size 4 at addr ffffc90000860ba0 by task swapper/14/0

[  239.016571] CPU: 14 PID: 0 Comm: swapper/14 Tainted: G      D     E      6.2.0+ #14
[  239.016583] Hardware name: Gigabyte Technology Co., Ltd. B460MDS3H/B460M DS3H, BIOS F3 05/27/2020
[  239.016593] Call Trace:
[  239.016599]  <IRQ>
[  239.016605]  dump_stack_lvl+0x4c/0x70
[  239.016617]  print_report+0xcf/0x620
[  239.016629]  ? kasan_addr_to_slab+0x11/0xb0
[  239.016639]  ? xfrm_state_find+0x2b8/0x2ae0
[  239.016650]  kasan_report+0xbf/0x100
[  239.016657]  ? xfrm_state_find+0x2b8/0x2ae0
[  239.016664]  __asan_load4+0x84/0xa0
[  239.016670]  xfrm_state_find+0x2b8/0x2ae0
[  239.016677]  ? __pfx_xfrm_state_find+0x10/0x10
[  239.016684]  ? __pfx_xfrm4_get_saddr+0x10/0x10
[  239.016690]  ? unwind_next_frame+0x27/0x40
[  239.016697]  xfrm_tmpl_resolve+0x1f9/0x780
[  239.016704]  ? __pfx_xfrm_tmpl_resolve+0x10/0x10
[  239.016711]  ? kasan_save_stack+0x3e/0x50
[  239.016716]  ? kasan_save_stack+0x2a/0x50
[  239.016721]  ? kasan_set_track+0x29/0x40
[  239.016726]  ? kasan_save_alloc_info+0x22/0x30
[  239.016731]  ? __kasan_slab_alloc+0x91/0xa0
[  239.016736]  ? kmem_cache_alloc+0x17e/0x370
[  239.016741]  ? dst_alloc+0x5c/0x230
[  239.016747]  ? xfrm_pol_bin_cmp+0xc8/0xe0
[  239.016753]  xfrm_resolve_and_create_bundle+0xf1/0x10d0
[  239.016758]  ? __pfx_xfrm_policy_inexact_lookup_rcu+0x10/0x10
[  239.016764]  ? xfrm_policy_lookup_inexact_addr+0xa1/0xc0
[  239.016771]  ? xfrm_policy_match+0xd6/0x110
[  239.016776]  ? __rcu_read_unlock+0x3b/0x80
[  239.016782]  ? xfrm_policy_lookup_bytype.constprop.0+0x52e/0xb80
[  239.016788]  ? __pfx_xfrm_resolve_and_create_bundle+0x10/0x10
[  239.016795]  ? __pfx_xfrm_policy_lookup_bytype.constprop.0+0x10/0x10
[  239.016802]  ? __kasan_check_write+0x18/0x20
[  239.016807]  ? _raw_spin_lock_bh+0x8c/0xe0
[  239.016813]  ? __pfx__raw_spin_lock_bh+0x10/0x10
[  239.016819]  xfrm_lookup_with_ifid+0x2f2/0xe50
[  239.016824]  ? __local_bh_enable_ip+0x3f/0x90
[  239.016830]  ? rcu_gp_cleanup+0x2f2/0x6c0
[  239.016836]  ? __pfx_xfrm_lookup_with_ifid+0x10/0x10
[  239.016842]  ? ip_route_output_key_hash_rcu+0x3da/0x1000
[  239.016848]  xfrm_lookup_route+0x2a/0x100
[  239.016854]  ip_route_output_flow+0x1a7/0x1c0
[  239.016859]  ? __pfx_ip_route_output_flow+0x10/0x10
[  239.016866]  igmpv3_newpack+0x1c1/0x5d0
[  239.016872]  ? __pfx_igmpv3_newpack+0x10/0x10
[  239.016878]  ? check_preempt_curr+0xd7/0x120
[  239.016885]  add_grhead+0x111/0x130
[  239.016891]  ? __pfx_igmp_ifc_timer_expire+0x10/0x10
[  239.016897]  add_grec+0x756/0x7f0
[  239.016903]  ? __pfx_add_grec+0x10/0x10
[  239.016909]  ? __pfx__raw_spin_lock_bh+0x10/0x10
[  239.016914]  ? wake_up_process+0x19/0x20
[  239.016919]  ? insert_work+0x130/0x160
[  239.016926]  ? __pfx_igmp_ifc_timer_expire+0x10/0x10
[  239.016932]  igmp_ifc_timer_expire+0x2b5/0x650
[  239.016938]  ? __kasan_check_write+0x18/0x20
[  239.016943]  ? _raw_spin_lock+0x8c/0xe0
[  239.016948]  ? __pfx_igmp_ifc_timer_expire+0x10/0x10
[  239.016954]  ? __pfx_igmp_ifc_timer_expire+0x10/0x10
[  239.016960]  call_timer_fn+0x2d/0x1b0
[  239.016966]  ? __pfx_igmp_ifc_timer_expire+0x10/0x10
[  239.016973]  __run_timers.part.0+0x447/0x530
[  239.016979]  ? __pfx___run_timers.part.0+0x10/0x10
[  239.016986]  ? ktime_get+0x58/0xd0
[  239.016992]  ? lapic_next_deadline+0x30/0x40
[  239.016997]  ? clockevents_program_event+0x118/0x1a0
[  239.017004]  run_timer_softirq+0x69/0xf0
[  239.017010]  __do_softirq+0x128/0x444
[  239.017016]  __irq_exit_rcu+0xdd/0x130
[  239.017022]  irq_exit_rcu+0x12/0x20
[  239.017027]  sysvec_apic_timer_interrupt+0xa5/0xc0
[  239.017033]  </IRQ>
[  239.017036]  <TASK>
[  239.017039]  asm_sysvec_apic_timer_interrupt+0x1f/0x30
[  239.017045] RIP: 0010:cpuidle_enter_state+0x1d2/0x510
[  239.017051] Code: 30 00 0f 84 61 01 00 00 41 83 ed 01 73 dd 48 83 c4 28 44 89 f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc fb 0f 1f 44 00 00 <45> 85 f6 0f 89 18 ff ff ff 48 c7 43 18 00 00 00 00 49 83 fd 09 0f
[  239.017061] RSP: 0018:ffffc9000028fd40 EFLAGS: 00000246
[  239.017067] RAX: 0000000000000000 RBX: ffffe8ffffd00c40 RCX: ffffffff811eae9c
[  239.017072] RDX: dffffc0000000000 RSI: ffffffff82e7cc00 RDI: ffff88840eb44188
[  239.017077] RBP: ffffc9000028fd90 R08: 00000037a67e1a91 R09: ffff88840eb3f0a3
[  239.017082] R10: ffffed1081d67e14 R11: 0000000000000001 R12: ffffffff846c43a0
[  239.017087] R13: 0000000000000002 R14: 0000000000000002 R15: ffffffff846c4488
[  239.017093]  ? sched_idle_set_state+0x4c/0x70
[  239.017101]  cpuidle_enter+0x45/0x70
[  239.017108]  call_cpuidle+0x44/0x80
[  239.017113]  do_idle+0x2b4/0x340
[  239.017118]  ? __pfx_do_idle+0x10/0x10
[  239.017125]  cpu_startup_entry+0x24/0x30
[  239.017130]  start_secondary+0x1d6/0x210
[  239.017136]  ? __pfx_start_secondary+0x10/0x10
[  239.017142]  ? set_bringup_idt_handler.constprop.0+0x93/0xc0
[  239.017150]  ? start_cpu0+0xc/0xc
[  239.017156]  secondary_startup_64_no_verify+0xe5/0xeb
[  239.017163]  </TASK>

[  239.017169] The buggy address belongs to the virtual mapping at
                [ffffc90000859000, ffffc90000862000) created by:
                irq_init_percpu_irqstack+0x1c8/0x270

[  239.017182] The buggy address belongs to the physical page:
[  239.017186] page:00000000d2ae7732 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x40eb09
[  239.017193] flags: 0x17ffffc0001000(reserved|node=0|zone=2|lastcpupid=0x1fffff)
[  239.017202] raw: 0017ffffc0001000 ffffea00103ac248 ffffea00103ac248 0000000000000000
[  239.017208] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
[  239.017213] page dumped because: kasan: bad access detected

[  239.017219] Memory state around the buggy address:
[  239.017222]  ffffc90000860a80: 00 00 00 00 f3 f3 f3 f3 00 00 00 00 00 00 00 00
[  239.017228]  ffffc90000860b00: 00 00 00 00 00 00 00 00 f1 f1 f1 f1 00 00 00 00
[  239.017233] >ffffc90000860b80: 00 00 00 00 f3 f3 f3 f3 00 00 00 00 00 00 00 00
[  239.017238]                                ^
[  239.017241]  ffffc90000860c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  239.017247]  ffffc90000860c80: 00 00 00 00 00 00 00 f1 f1 f1 f1 00 f3 f3 f3 00
[  239.017251] ==================================================================
```

> 
> > Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
> > ---
> 
> I find this patch quite strange, to be honest.
> 
> It looks like some xfrm bug to me.
> 
> A stack trace would be helpful.

Here are the root caouses I analyzed:

```
igmp_ifc_timer_expire() -> igmpv3_send_cr() -> add_grec() -> add_grhead() -> igmpv3_newpack()[1] -> ip_route_output_ports() -> 
ip_route_output_flow()[3] -> xfrm_lookup_route() -> xfrm_lookup() -> xfrm_lookup_with_ifid() -> xfrm_resolve_and_create_bundle() -> 
xfrm_tmpl_resolve() -> xfrm_tmpl_resolve_one() -> xfrm_state_find()[5]
```

Here, igmpv3_newpack()[1] declares the variable `struct flowi4 fl4`[2]:
```
static struct sk_buff *igmpv3_newpack(struct net_device *dev, unsigned int mtu)
{
	struct sk_buff *skb;
	struct rtable *rt;
	struct iphdr *pip;
	struct igmpv3_report *pig;
	struct net *net = dev_net(dev);
	struct flowi4 fl4;    // <===[2]
	int hlen = LL_RESERVED_SPACE(dev);
	int tlen = dev->needed_tailroom;
	unsigned int size = mtu;

	while (1) {
		skb = alloc_skb(size + hlen + tlen,
				GFP_ATOMIC | __GFP_NOWARN);
		if (skb)
			break;
		size >>= 1;
		if (size < 256)
			return NULL;
	}
	skb->priority = TC_PRIO_CONTROL;

	rt = ip_route_output_ports(net, &fl4, NULL, IGMPV3_ALL_MCR, 0,
				   0, 0,
				   IPPROTO_IGMP, 0, dev->ifindex);
```


Then, starting with ip_route_output_flow()[3], we use flowi4_to_flowi() to convert the `struct flowi4` variable to a `struct flowi` pointer[4]:
```
struct flowi {
	union {
		struct flowi_common	__fl_common;
		struct flowi4		ip4;
		struct flowi6		ip6;
	} u;
#define flowi_oif	u.__fl_common.flowic_oif
#define flowi_iif	u.__fl_common.flowic_iif
#define flowi_l3mdev	u.__fl_common.flowic_l3mdev
#define flowi_mark	u.__fl_common.flowic_mark
#define flowi_tos	u.__fl_common.flowic_tos
#define flowi_scope	u.__fl_common.flowic_scope
#define flowi_proto	u.__fl_common.flowic_proto
#define flowi_flags	u.__fl_common.flowic_flags
#define flowi_secid	u.__fl_common.flowic_secid
#define flowi_tun_key	u.__fl_common.flowic_tun_key
#define flowi_uid	u.__fl_common.flowic_uid
} __attribute__((__aligned__(BITS_PER_LONG/8)));


static inline struct flowi *flowi4_to_flowi(struct flowi4 *fl4)
{
	return container_of(fl4, struct flowi, u.ip4);
}


struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
				    const struct sock *sk)
{
	struct rtable *rt = __ip_route_output_key(net, flp4);

	if (IS_ERR(rt))
		return rt;

	if (flp4->flowi4_proto) {
		flp4->flowi4_oif = rt->dst.dev->ifindex;
		rt = (struct rtable *)xfrm_lookup_route(net, &rt->dst,
							flowi4_to_flowi(flp4),  // <===[4]
							sk, 0);
	}

	return rt;
}
EXPORT_SYMBOL_GPL(ip_route_output_flow);
```
This is the cause of the stack OOB. Because we calculated the struct flowi pointer address based on struct flowi4 declared as a stack variable, 
if we accessed a member of flowi that exceeds the size of flowi4, we would get an OOB.


Finally, xfrm_state_find()[5] uses daddr, which is a pointer to `&fl->u.ip4.saddr`.
Here, the encap_family variable can be entered by the user using the netlink socket. 
If the user chose AF_INET6 instead of AF_INET, the xfrm_dst_hash() function would be called on an AF_INET6 basis[6], 
which could cause an OOB in the `struct flowi4 fl4` variable of igmpv3_newpack()[2].
```
struct xfrm_state *
xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
		const struct flowi *fl, struct xfrm_tmpl *tmpl,
		struct xfrm_policy *pol, int *err,
		unsigned short family, u32 if_id)
{
	static xfrm_address_t saddr_wildcard = { };
	struct net *net = xp_net(pol);
	unsigned int h, h_wildcard;
	struct xfrm_state *x, *x0, *to_put;
	int acquire_in_progress = 0;
	int error = 0;
	struct xfrm_state *best = NULL;
	u32 mark = pol->mark.v & pol->mark.m;
	unsigned short encap_family = tmpl->encap_family;
	unsigned int sequence;
	struct km_event c;

	to_put = NULL;

	sequence = read_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);

	rcu_read_lock();
	h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);  // <===[6]
```

Of course, it's possible that the patch I wrote is not appropriate.


Regards,
Hyunwoo Kim
