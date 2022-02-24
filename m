Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F34A4C22FA
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 05:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiBXET5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 23:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBXET4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 23:19:56 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA687246341
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:19:24 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x18so798363pfh.5
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Id4tOxrDjuC1uJrI9Qp+04QHVf8riOijHXfmuhtgLwM=;
        b=APh+P3szYThioap/zSAcFek51NqDwZUaLPQwSSL1etjzYfTPMtxBLb+/X/Sz9P7cb0
         TIIAPdyArn2tZxLO22R/N9A7F5FI6fBgPuGPukLRQSjDglnJK2G5rdjLB3YvGI8Rpghs
         7X/P24UVqOr42rzzLrErjmpGd7X85JV74LxqlpcaOSyGVFjr7yVMzKr2AV/raGK0xjGq
         Zo2sLI3WKiiCyMN1spMnKAF6CKGj6evADGkFebFsKCF6NMX24dE3A7uxPRY6UzIglOfO
         in9hXlrxh5BDV3ceHUh4rKbeMc/L0u5/YNH4u/9BY+mpd1T1q+9346Do4CjWMJpwXmcC
         A7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Id4tOxrDjuC1uJrI9Qp+04QHVf8riOijHXfmuhtgLwM=;
        b=uyiyWbiqFKiaU3ScBaMDKei/v5SxevSiJVsUjwMZQJgGRzl0C6suSGHTSzrUmFzJz6
         /K4qr01FTjwxCLijJu6mm7xkvwFnlCg+jbdmIihrcbpo8GSmf0kXe9xNtzQ4BvFnOLgR
         63s4aZWgO3q9jnpESIntndn2boy/NrwbQ/6frjdLtc4C2TW/9VClSzXl860mlEqZKcct
         pYwp1pxcdq0EnjuscU7/HflvxPADwsZgZCIoldGOaq+p/wb7B416Cl5wgDTExp3s/zFg
         SaPT1HXQnY5+TzQOFyHg/79PLolNYzWsWuBG+AvPzo+/UKejys9WKcJYthFW7xI817Ph
         yimQ==
X-Gm-Message-State: AOAM532HiVEHMUXbU5B2DjU2vyn/QN7EiuOAWIL7Y5HJAWvmEsOLXtf1
        L6Ci7Abuq812+184+qN0flDM8gaAVvZBcuE/Yo0=
X-Google-Smtp-Source: ABdhPJy1hVJJ6IogUkMIB0MTql3ox0iJBInJqfj8aKs8I/GNlkdjdocKD8jn/obMSLi/8ApzXeFK7tF02Kh41q5TOQo=
X-Received: by 2002:a05:6a00:1704:b0:4cc:c8d7:e54a with SMTP id
 h4-20020a056a00170400b004ccc8d7e54amr1011151pfc.16.1645676364223; Wed, 23 Feb
 2022 20:19:24 -0800 (PST)
MIME-Version: 1.0
References: <CAHJXk3b9WhMb7CDHbO3ixGg23G1u7Y+guoLQLWkARgX6Ssrpow@mail.gmail.com>
 <CAHJXk3bpBosy01XojpCd=LFC1Dwbms9GA7FOEudOa_mRgPz7qA@mail.gmail.com> <CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com>
In-Reply-To: <CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com>
From:   Harold Huang <baymaxhuang@gmail.com>
Date:   Thu, 24 Feb 2022 12:19:12 +0800
Message-ID: <CAHJXk3bvyfNMDQCzSB2tfzW4PMAx=PRHL9CFBKt1jXgNUH2DkA@mail.gmail.com>
Subject: Re: Question about the sndbuf of the tap interface with vhost-net
To:     Jason Wang <jasowang@redhat.com>
Cc:     users@dpdk.org, Maxime Coquelin <maxime.coquelin@redhat.com>,
        Chenbo Xia <chenbo.xia@intel.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for Jason's comments.

Jason Wang <jasowang@redhat.com> =E4=BA=8E2022=E5=B9=B42=E6=9C=8824=E6=97=
=A5=E5=91=A8=E5=9B=9B 11:23=E5=86=99=E9=81=93=EF=BC=9A
>
> Adding netdev.
>
> On Wed, Feb 23, 2022 at 9:46 PM Harold Huang <baymaxhuang@gmail.com> wrot=
e:
> >
> >  Sorry. The performance tested by iperf is degraded from 4.5 Gbps to
> > 750Mbps per flow.
> >
> > Harold Huang <baymaxhuang@gmail.com> =E4=BA=8E2022=E5=B9=B42=E6=9C=8823=
=E6=97=A5=E5=91=A8=E4=B8=89 21:13=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > I see in dpdk virtio-user driver, the TUNSETSNDBUF is initialized wit=
h
> > > INT_MAX, see: https://github.com/DPDK/dpdk/blob/main/drivers/net/virt=
io/virtio_user/vhost_kernel_tap.c#L169
>
> Note that Linux use INT_MAX as default sndbuf for tuntap.
>
> > > It is ok because tap driver uses it to support tx baching, see this
> > > patch: https://github.com/torvalds/linux/commit/0a0be13b8fe2cac11da20=
63fb03f0f39359b3069
> > >
> > > But in tun_xdp_one, napi is not supported and I want to user napi in
> > > tun_get_user to enable gro.
>
> NAPI is not enabled in this path, want to send a patch to do that?

Yes, I have a patch in this path to enable NAPI and it greatly
improves TCP stream performance, from 4.5Gbsp to 9.2 Gbps per flow. I
will send it later for comments.

>
> Btw, NAPI mode is used for kernel networking stack hardening at start,
> but it would be interesting to see if it helps for the performance.
>
> > > As I result, I change the sndbuf to a
> > > value such as 212992 in /proc/sys/net/core/wmem_default.
>
> Can you describe your setup in detail? Where did you run the iperf
> server and client and where did you change the wmem_default?

I use dpdk-testpmd to test the vhost-net performance, such as:
dpdk-testpmd -l 0-9  -n 4
--vdev=3Dvirtio_user0,path=3D/dev/vhost-net,queue_size=3D1024,mac=3D00:00:0=
a:00:00:02
-a 0000:06:00.1 -- -i  --txd=3D1024 --rxd=3D1024

And I have changed the sndbuf in
https://github.com/DPDK/dpdk/blob/main/drivers/net/virtio/virtio_user/vhost=
_kernel_tap.c#L169
to 212992, which is not INT_MAX anymore. I also enable NAPI in the tun
module.  The iperf server ran in the tap interface on the kernel side,
which would receive TCP stream from dpdk-testpmd. But the performance
is greatly degraded,  from 4.5 Gbps to 750Mbps. I am confused about
the perf result of the cpu core where iperf server ran, which has a
serious bottleneck: 59.86% cpu on the report_bug and  20.66% on the
module_find_bug. I use centos 8.2 with a native 4.18.0-193.el8.x86_64
kernel to test.

>
> > > But the
> > > performance tested by iperf is greatly degraded, from 4.5 Gbps to
> > > 750Gbps per flow. I see the the iperf server consume 100% cpu core,
> > > which should be the bottleneck of the this test. The perf top result
> > > of iperf server cpu core is as follows:
> > >
> > > '''
> > > Samples: 72  of event 'cycles', 4000 Hz, Event count (approx.):
> > > 22685278 lost: 0/0 drop: 0/0
> > > Overhead  Shared O  Symbol
> > >   59.86%  [kernel]  [k] report_bug
> > >   20.66%  [kernel]  [k] module_find_bug
> > >    6.51%  [kernel]  [k] common_interrupt
> > >    2.82%  [kernel]  [k] __slab_free
> > >    1.48%  [kernel]  [k] copy_user_enhanced_fast_string
> > >    1.44%  [kernel]  [k] __skb_datagram_iter
> > >    1.42%  [kernel]  [k] notifier_call_chain
> > >    1.41%  [kernel]  [k] irq_work_run_list
> > >    1.41%  [kernel]  [k] update_irq_load_avg
> > >    1.41%  [kernel]  [k] task_tick_fair
> > >    1.41%  [kernel]  [k] cmp_ex_search
> > >    0.16%  [kernel]  [k] __ghes_peek_estatus.isra.12
> > >    0.02%  [kernel]  [k] acpi_os_read_memory
> > >    0.00%  [kernel]  [k] native_apic_mem_write
> > > '''
> > > I am not clear about the test result. Can we change the sndbuf size i=
n
> > > dpdk? Is any way to enable vhost_net to use napi without changing the
> > > tun kernel driver?
>
> You can do this by not using INT_MAX as sndbuf.

Just mentioned above, I change the sndbuf value and I met a serious
performance degradation.

>
> Thanks
>
> >
>
