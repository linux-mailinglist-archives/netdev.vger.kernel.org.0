Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8992E6523AA
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 16:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiLTP3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 10:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiLTP3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 10:29:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED71B7
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 07:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671550132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/74ZcnfRnP6hfriDq7Kyi6quMr/Tq9CepA6GPX++5Bg=;
        b=dasBB1AvcAeG2Z+Dk+Gdh4UQ5TQtRHbcOzlgoPSrUT/mwh6gwbh0mSLtjZaQl8p15XaRIo
        /PKAH+BciLmEx9/y6utFAsVjElcMh4bu2QL6X2xdugEaPDTrFZP9XgCUZvcO/wao4bMP2h
        7FPumGUri7tIHp45VQ7T5lu17rxd55g=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-358-_tZSIv2DN52JaqtaIy0APg-1; Tue, 20 Dec 2022 10:28:51 -0500
X-MC-Unique: _tZSIv2DN52JaqtaIy0APg-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-45c1b233dd7so9109547b3.20
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 07:28:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/74ZcnfRnP6hfriDq7Kyi6quMr/Tq9CepA6GPX++5Bg=;
        b=s3uIYLW7lP7Sua4IMkewcrtAVbup7q4JH9ArymkccXFHc4qKerCojnbpLHxSyA2l4d
         O0/Ae3Z79Ee4MReFIoRVCpF28m8Vv7IcgUja3B4+NQarwk7aqoPEycmrf3BfT4nv+2yg
         4rII2GHEgayj7tbRGYY8uyp2Xmfqvb8Mn2/rTHY1w0xuHniBYcMjof37P5lkk1ULE7b+
         s6tx12+XuMVCbMKa1t65BSL/eRBOFQ3EsO/ngxTamxY/rVnE4i+wrnKiFnqmLB+4Xn06
         aho4d0XwftrQwWjjY0fRouZzczi4ukBc2RPBu5XEN4LV5TIpMZ9HziKCdpiVJ9LJqxiM
         EhEA==
X-Gm-Message-State: AFqh2kp74xXy8bbTavhJwQ6JizD1PKsIfvav9e3il1n7O1tveKex3sau
        TH3/X8JVRRJOV/sO8oVyIoZ2Ic1SwtzC9o7vXeOdvg1AKrpysqPNJWwup59zgOQs5R7+N0Qa9we
        tkUdEn+iRKkcZXbA6
X-Received: by 2002:a25:4e87:0:b0:6c3:8ce3:a926 with SMTP id c129-20020a254e87000000b006c38ce3a926mr11780258ybb.65.1671550128121;
        Tue, 20 Dec 2022 07:28:48 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu7AUxg3jp6I6OtVwJ9usm41tyPsr1iORF36dVVjXNmqRAQ5biNVYDPOuSccDbfrxhhsas7qw==
X-Received: by 2002:a25:4e87:0:b0:6c3:8ce3:a926 with SMTP id c129-20020a254e87000000b006c38ce3a926mr11780226ybb.65.1671550127800;
        Tue, 20 Dec 2022 07:28:47 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id s191-20020a37a9c8000000b006feb0007217sm8952073qke.65.2022.12.20.07.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 07:28:47 -0800 (PST)
Message-ID: <3bf0ab2e58acbb203fa36fbdb0cc41de4d9ad6dc.camel@redhat.com>
Subject: Re: [PATCH net-next v3 2/3] net: qualcomm: rmnet: add tx packets
 aggregation
From:   Paolo Abeni <pabeni@redhat.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
Date:   Tue, 20 Dec 2022 16:28:43 +0100
In-Reply-To: <CAGRyCJEzg2gFCf3svgKGSv5+W4QRsVhbYQ+KZoEfvw_=2Rb+Zg@mail.gmail.com>
References: <20221205093359.49350-1-dnlplm@gmail.com>
         <20221205093359.49350-3-dnlplm@gmail.com>
         <ad410abb19bdbcdac617878d14a4e37228f1157b.camel@redhat.com>
         <CAGRyCJFL5VmeserfoTMY4bR+EWKSEWrdhSTSY8UQsAZphg8PWw@mail.gmail.com>
         <CAGRyCJEzg2gFCf3svgKGSv5+W4QRsVhbYQ+KZoEfvw_=2Rb+Zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-20 at 15:28 +0100, Daniele Palmas wrote:
> Hello Paolo,
> 
> Il giorno ven 9 dic 2022 alle ore 08:38 Daniele Palmas
> <dnlplm@gmail.com> ha scritto:
> > 
> > Il giorno mer 7 dic 2022 alle ore 13:46 Paolo Abeni
> > <pabeni@redhat.com> ha scritto:
> > > > +static void rmnet_map_flush_tx_packet_work(struct work_struct *work)
> > > > +{
> > > > +     struct sk_buff *skb = NULL;
> > > > +     struct rmnet_port *port;
> > > > +
> > > > +     port = container_of(work, struct rmnet_port, agg_wq);
> > > > +
> > > > +     spin_lock_bh(&port->agg_lock);
> > > > +     if (likely(port->agg_state == -EINPROGRESS)) {
> > > > +             /* Buffer may have already been shipped out */
> > > > +             if (likely(port->skbagg_head)) {
> > > > +                     skb = port->skbagg_head;
> > > > +                     reset_aggr_params(port);
> > > > +             }
> > > > +             port->agg_state = 0;
> > > > +     }
> > > > +
> > > > +     spin_unlock_bh(&port->agg_lock);
> > > > +     if (skb)
> > > > +             rmnet_send_skb(port, skb);
> > > > +}
> > > > +
> > > > +static enum hrtimer_restart rmnet_map_flush_tx_packet_queue(struct hrtimer *t)
> > > > +{
> > > > +     struct rmnet_port *port;
> > > > +
> > > > +     port = container_of(t, struct rmnet_port, hrtimer);
> > > > +
> > > > +     schedule_work(&port->agg_wq);
> > > 
> > > Why you need to schedule a work and you can't instead call the core of
> > > rmnet_map_flush_tx_packet_work() here? it looks like the latter does
> > > not need process context...
> > > 
> > 
> > Ack.
> > 
> 
> looks like removing the work is not as straightforward as I thought.
> 
> Now the timer cb has become:
> 
> static enum hrtimer_restart rmnet_map_flush_tx_packet_cb(struct hrtimer *t)
> {
>     struct sk_buff *skb = NULL;
>     struct rmnet_port *port;
> 
>     port = container_of(t, struct rmnet_port, hrtimer);
> 
>     spin_lock_bh(&port->agg_lock);
>     if (likely(port->agg_state == -EINPROGRESS)) {
>         /* Buffer may have already been shipped out */
>         if (likely(port->skbagg_head)) {
>             skb = port->skbagg_head;
>             reset_aggr_params(port);
>         }
>         port->agg_state = 0;
>     }
>     spin_unlock_bh(&port->agg_lock);
> 
>     if (skb)
>         rmnet_send_skb(port, skb);
> 
>     return HRTIMER_NORESTART;
> }
> 
> but this is causing the following warning:
> 
> [ 3106.701296] WARNING: CPU: 15 PID: 0 at kernel/softirq.c:375
> __local_bh_enable_ip+0x54/0x70
> ...
> [ 3106.701537] CPU: 15 PID: 0 Comm: swapper/15 Tainted: G           OE
>      6.1.0-rc5-rmnet-v4-warn #1
> [ 3106.701543] Hardware name: LENOVO 30DH00H2IX/1048, BIOS S08KT40A 08/23/2021
> [ 3106.701546] RIP: 0010:__local_bh_enable_ip+0x54/0x70
> [ 3106.701554] Code: a9 00 ff ff 00 74 27 65 ff 0d 08 bb 75 61 65 8b
> 05 01 bb 75 61 85 c0 74 06 5d c3 cc cc cc cc 0f 1f 44 00 00 5d c3 cc
> cc cc cc <0f> 0b eb bf 65 66 8b 05 e0 ca 76 61 66 85 c0 74 cc e8 e6 fd
> ff ff
> [ 3106.701559] RSP: 0018:ffffb8aa80510ec8 EFLAGS: 00010006
> [ 3106.701564] RAX: 0000000080010202 RBX: ffff932d7b687868 RCX: 0000000000000000
> [ 3106.701569] RDX: 0000000000000001 RSI: 0000000000000201 RDI: ffffffffc0bd5f7c
> [ 3106.701573] RBP: ffffb8aa80510ec8 R08: ffff933bdc3e31a0 R09: 000002d355c2f99d
> [ 3106.701576] R10: 0000000000000000 R11: ffffb8aa80510ff8 R12: ffff932d7b687828
> [ 3106.701580] R13: ffff932d7b687000 R14: ffff932cc1a76400 R15: ffff933bdc3e3180
> [ 3106.701584] FS:  0000000000000000(0000) GS:ffff933bdc3c0000(0000)
> knlGS:0000000000000000
> [ 3106.701589] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3106.701593] CR2: 00007ffc26dae080 CR3: 0000000209f04003 CR4: 00000000007706e0
> [ 3106.701597] PKRU: 55555554
> [ 3106.701599] Call Trace:
> [ 3106.701602]  <IRQ>
> [ 3106.701608]  _raw_spin_unlock_bh+0x1d/0x30
> [ 3106.701623]  rmnet_map_flush_tx_packet_cb+0x4c/0x90 [rmnet]
> [ 3106.701640]  ? rmnet_send_skb+0x90/0x90 [rmnet]
> [ 3106.701655]  __hrtimer_run_queues+0x106/0x260
> [ 3106.701664]  hrtimer_interrupt+0x101/0x220
> [ 3106.701671]  __sysvec_apic_timer_interrupt+0x61/0x110
> [ 3106.701677]  sysvec_apic_timer_interrupt+0x7b/0x90
> [ 3106.701685]  </IRQ>
> [ 3106.701687]  <TASK>
> [ 3106.701689]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
> [ 3106.701694] RIP: 0010:cpuidle_enter_state+0xde/0x6e0
> [ 3106.701704] Code: eb d6 60 e8 74 01 68 ff 8b 53 04 49 89 c7 0f 1f
> 44 00 00 31 ff e8 b2 23 67 ff 80 7d d0 00 0f 85 da 00 00 00 fb 0f 1f
> 44 00 00 <45> 85 f6 0f 88 01 02 00 00 4d 63 ee 49 83 fd 09 0f 87 b6 04
> 00 00
> [ 3106.701709] RSP: 0018:ffffb8aa801dbe38 EFLAGS: 00000246
> [ 3106.701713] RAX: ffff933bdc3f1380 RBX: ffffd8aa7fbc0700 RCX: 000000000000001f
> [ 3106.701717] RDX: 000000000000000f RSI: 0000000000000002 RDI: 0000000000000000
> [ 3106.701720] RBP: ffffb8aa801dbe88 R08: 000002d355d34146 R09: 000000000006e988
> [ 3106.701723] R10: 0000000000000004 R11: 071c71c71c71c71c R12: ffffffffa04ba5c0
> [ 3106.701727] R13: 0000000000000001 R14: 0000000000000001 R15: 000002d355d34146
> [ 3106.701735]  ? cpuidle_enter_state+0xce/0x6e0
> [ 3106.701744]  cpuidle_enter+0x2e/0x50
> [ 3106.701751]  do_idle+0x204/0x290
> [ 3106.701758]  cpu_startup_entry+0x20/0x30
> [ 3106.701763]  start_secondary+0x122/0x160
> [ 3106.701773]  secondary_startup_64_no_verify+0xe5/0xeb
> [ 3106.701784]  </TASK>
> 
> The reason is not obvious to me, so I need to dig further...

It happens because __hrtimer_run_queues runs in hard-IRQ context.

To address the above you need to replace all the

spin_lock_bh(&port->agg_lock);

instances with the spin_lock_irqsave() variant. With one exception: in
rmnet_map_flush_tx_packet_cb() you can use simply spin_lock() as such
fuction is already in hard-irq context.

Cheers,

Paolo

