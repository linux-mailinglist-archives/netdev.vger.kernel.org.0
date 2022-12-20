Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566136522B7
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbiLTOfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbiLTOfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:35:22 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD0E1C417
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 06:35:16 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z92so17783049ede.1
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 06:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LyYnvqM3MCUEyWL5tDHinEGqkBlJP1ckRH8Hs0eCLf8=;
        b=dll//Cfi1b3Mmvggi0qQna7B5+sPKByB/hpfKH62n9J4GJn5GVdVDLQH8T70eJQS34
         CrSfRUtNhSaY2mzLJviTqz1wFfF8YHTcw/Gdxw8bwL0cS8Ewjpq89XsgNf3BHn5Rve0u
         aoJVqSQvF5kk7uMl0Re1s1D4Es2gLk/aNvvrZpovzJt+iSs/Ns/NrQstPBvlhx0pasYy
         a7PKsfp4KdkeTrxtrBFmz+opmEiVlfZH4T+NNlmPByWqHUtivMOxywC2jG2j5s9HxzbR
         rms/h2i72DHhhApE6qDsLQMBrxzfqjZkEnFQwhd2X4K7KiRuREsp+4xSHyymRVL1OM+R
         yIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LyYnvqM3MCUEyWL5tDHinEGqkBlJP1ckRH8Hs0eCLf8=;
        b=KE/nan1LR5lHnl6B8WUY7gtaWap3T0ctwD8HM5Vt2HtqxR1ba3asOpopZsG1fFdizq
         8EKSChzZkOsnSwYVe5Mj5es2Ve4X4NNM/u7dt5vnziCgc0MSMKE4hY4mvJtPAY9JcWBT
         wge992opxJSFKqR0eGphBPc8aT0ysPMBJeCRRYVvrzwTUvQq9o1NgDQ2cWG6KO0BFfTD
         8/dPV/ZzOYXM5dEa2DXo6OmwMcNFLTgIPsEXx7UJHkoDuxKFOPc5pnYbbTv+bOI6FR86
         ZllZOlv1F2IKgud+6p/y8E8VXM+Oi7B0snUtsFQvhb+6XIuy/ABseKmYEAJxj5jAXs+Y
         0F+g==
X-Gm-Message-State: ANoB5plIMYha4oLEJey+YDSebVTUTIXNth0IkH6UVyAmSNCJVG53CS4Y
        TEYeWzt+PND7p6jkcF6s2Pp3271nEBBMN0bAwNs=
X-Google-Smtp-Source: AA0mqf4LWHKm3+bc++AE0iTFaHmGwp6siU/J9epYBb4SpOfuQTmkf3MNYfIpEsGPeXAP2r4EWwbOKxjfJnD9RNM/gpQ=
X-Received: by 2002:aa7:ca4c:0:b0:46c:24fc:ba0f with SMTP id
 j12-20020aa7ca4c000000b0046c24fcba0fmr26924387edt.140.1671546914882; Tue, 20
 Dec 2022 06:35:14 -0800 (PST)
MIME-Version: 1.0
References: <20221205093359.49350-1-dnlplm@gmail.com> <20221205093359.49350-3-dnlplm@gmail.com>
 <ad410abb19bdbcdac617878d14a4e37228f1157b.camel@redhat.com> <CAGRyCJFL5VmeserfoTMY4bR+EWKSEWrdhSTSY8UQsAZphg8PWw@mail.gmail.com>
In-Reply-To: <CAGRyCJFL5VmeserfoTMY4bR+EWKSEWrdhSTSY8UQsAZphg8PWw@mail.gmail.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Tue, 20 Dec 2022 15:28:16 +0100
Message-ID: <CAGRyCJEzg2gFCf3svgKGSv5+W4QRsVhbYQ+KZoEfvw_=2Rb+Zg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: qualcomm: rmnet: add tx packets aggregation
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Paolo,

Il giorno ven 9 dic 2022 alle ore 08:38 Daniele Palmas
<dnlplm@gmail.com> ha scritto:
>
> Il giorno mer 7 dic 2022 alle ore 13:46 Paolo Abeni
> <pabeni@redhat.com> ha scritto:
> > > +static void rmnet_map_flush_tx_packet_work(struct work_struct *work)
> > > +{
> > > +     struct sk_buff *skb = NULL;
> > > +     struct rmnet_port *port;
> > > +
> > > +     port = container_of(work, struct rmnet_port, agg_wq);
> > > +
> > > +     spin_lock_bh(&port->agg_lock);
> > > +     if (likely(port->agg_state == -EINPROGRESS)) {
> > > +             /* Buffer may have already been shipped out */
> > > +             if (likely(port->skbagg_head)) {
> > > +                     skb = port->skbagg_head;
> > > +                     reset_aggr_params(port);
> > > +             }
> > > +             port->agg_state = 0;
> > > +     }
> > > +
> > > +     spin_unlock_bh(&port->agg_lock);
> > > +     if (skb)
> > > +             rmnet_send_skb(port, skb);
> > > +}
> > > +
> > > +static enum hrtimer_restart rmnet_map_flush_tx_packet_queue(struct hrtimer *t)
> > > +{
> > > +     struct rmnet_port *port;
> > > +
> > > +     port = container_of(t, struct rmnet_port, hrtimer);
> > > +
> > > +     schedule_work(&port->agg_wq);
> >
> > Why you need to schedule a work and you can't instead call the core of
> > rmnet_map_flush_tx_packet_work() here? it looks like the latter does
> > not need process context...
> >
>
> Ack.
>

looks like removing the work is not as straightforward as I thought.

Now the timer cb has become:

static enum hrtimer_restart rmnet_map_flush_tx_packet_cb(struct hrtimer *t)
{
    struct sk_buff *skb = NULL;
    struct rmnet_port *port;

    port = container_of(t, struct rmnet_port, hrtimer);

    spin_lock_bh(&port->agg_lock);
    if (likely(port->agg_state == -EINPROGRESS)) {
        /* Buffer may have already been shipped out */
        if (likely(port->skbagg_head)) {
            skb = port->skbagg_head;
            reset_aggr_params(port);
        }
        port->agg_state = 0;
    }
    spin_unlock_bh(&port->agg_lock);

    if (skb)
        rmnet_send_skb(port, skb);

    return HRTIMER_NORESTART;
}

but this is causing the following warning:

[ 3106.701296] WARNING: CPU: 15 PID: 0 at kernel/softirq.c:375
__local_bh_enable_ip+0x54/0x70
...
[ 3106.701537] CPU: 15 PID: 0 Comm: swapper/15 Tainted: G           OE
     6.1.0-rc5-rmnet-v4-warn #1
[ 3106.701543] Hardware name: LENOVO 30DH00H2IX/1048, BIOS S08KT40A 08/23/2021
[ 3106.701546] RIP: 0010:__local_bh_enable_ip+0x54/0x70
[ 3106.701554] Code: a9 00 ff ff 00 74 27 65 ff 0d 08 bb 75 61 65 8b
05 01 bb 75 61 85 c0 74 06 5d c3 cc cc cc cc 0f 1f 44 00 00 5d c3 cc
cc cc cc <0f> 0b eb bf 65 66 8b 05 e0 ca 76 61 66 85 c0 74 cc e8 e6 fd
ff ff
[ 3106.701559] RSP: 0018:ffffb8aa80510ec8 EFLAGS: 00010006
[ 3106.701564] RAX: 0000000080010202 RBX: ffff932d7b687868 RCX: 0000000000000000
[ 3106.701569] RDX: 0000000000000001 RSI: 0000000000000201 RDI: ffffffffc0bd5f7c
[ 3106.701573] RBP: ffffb8aa80510ec8 R08: ffff933bdc3e31a0 R09: 000002d355c2f99d
[ 3106.701576] R10: 0000000000000000 R11: ffffb8aa80510ff8 R12: ffff932d7b687828
[ 3106.701580] R13: ffff932d7b687000 R14: ffff932cc1a76400 R15: ffff933bdc3e3180
[ 3106.701584] FS:  0000000000000000(0000) GS:ffff933bdc3c0000(0000)
knlGS:0000000000000000
[ 3106.701589] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3106.701593] CR2: 00007ffc26dae080 CR3: 0000000209f04003 CR4: 00000000007706e0
[ 3106.701597] PKRU: 55555554
[ 3106.701599] Call Trace:
[ 3106.701602]  <IRQ>
[ 3106.701608]  _raw_spin_unlock_bh+0x1d/0x30
[ 3106.701623]  rmnet_map_flush_tx_packet_cb+0x4c/0x90 [rmnet]
[ 3106.701640]  ? rmnet_send_skb+0x90/0x90 [rmnet]
[ 3106.701655]  __hrtimer_run_queues+0x106/0x260
[ 3106.701664]  hrtimer_interrupt+0x101/0x220
[ 3106.701671]  __sysvec_apic_timer_interrupt+0x61/0x110
[ 3106.701677]  sysvec_apic_timer_interrupt+0x7b/0x90
[ 3106.701685]  </IRQ>
[ 3106.701687]  <TASK>
[ 3106.701689]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
[ 3106.701694] RIP: 0010:cpuidle_enter_state+0xde/0x6e0
[ 3106.701704] Code: eb d6 60 e8 74 01 68 ff 8b 53 04 49 89 c7 0f 1f
44 00 00 31 ff e8 b2 23 67 ff 80 7d d0 00 0f 85 da 00 00 00 fb 0f 1f
44 00 00 <45> 85 f6 0f 88 01 02 00 00 4d 63 ee 49 83 fd 09 0f 87 b6 04
00 00
[ 3106.701709] RSP: 0018:ffffb8aa801dbe38 EFLAGS: 00000246
[ 3106.701713] RAX: ffff933bdc3f1380 RBX: ffffd8aa7fbc0700 RCX: 000000000000001f
[ 3106.701717] RDX: 000000000000000f RSI: 0000000000000002 RDI: 0000000000000000
[ 3106.701720] RBP: ffffb8aa801dbe88 R08: 000002d355d34146 R09: 000000000006e988
[ 3106.701723] R10: 0000000000000004 R11: 071c71c71c71c71c R12: ffffffffa04ba5c0
[ 3106.701727] R13: 0000000000000001 R14: 0000000000000001 R15: 000002d355d34146
[ 3106.701735]  ? cpuidle_enter_state+0xce/0x6e0
[ 3106.701744]  cpuidle_enter+0x2e/0x50
[ 3106.701751]  do_idle+0x204/0x290
[ 3106.701758]  cpu_startup_entry+0x20/0x30
[ 3106.701763]  start_secondary+0x122/0x160
[ 3106.701773]  secondary_startup_64_no_verify+0xe5/0xeb
[ 3106.701784]  </TASK>

The reason is not obvious to me, so I need to dig further...

Regards,
Daniele
