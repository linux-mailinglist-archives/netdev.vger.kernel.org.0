Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423ED4C247B
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 08:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiBXHb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 02:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiBXHbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 02:31:55 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD9523401C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 23:31:25 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id s1so944544plg.12
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 23:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YDpmdW8MKhJDPEZgEvoNosgAEEHATGjHHcgXjQaHl8U=;
        b=quUUW/jF5lq/rn5p6erJSt7vsUubzk4dKl2V7wbPxK8WnI3nXez5ul3ZH2ocaaw5Ep
         sLrBRTHYgl97mZW/v4jTcPehEXUx2KA0OKN2TxvejYakp3ALxg0Im46c+5UgOXB8e0P1
         P4+NNPD2MBcI+sA250RVus5IaU7p9RoJHOb4LWPOybnxy2Ck845WHHx8Re7JrvKYqfu6
         cOFU8QI8vTzynuAy3JovV+bWPqC7gFluS97Z2CW6INZdpHxHPMuOIh3lZeVPUZB/gb5o
         4WRh4bulD3vfM7dSJy6jedeO9/b0YgihJ1FX0jEQ9rrFmlUGzCOosOJSURAEFA+4kSw5
         JG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YDpmdW8MKhJDPEZgEvoNosgAEEHATGjHHcgXjQaHl8U=;
        b=fGac4sHpbiMzblSyOKmFSFOfdRQ4tz8SR78/UQMwKorq7fHD6bhep23r0UhMNKqx03
         Ek6LPyMIupazrCpOwlNdS2TRZEmmnylkOfmwEwDK+1tW/YFKO9r9i0Cxr5bKLGr5tLb/
         NG1YygEpej53LV3ZaBVvz2AkclzZU08zBmpkq/I/Ouynb19znZhcuuoZhSXlLMU6N/Na
         EROR4yL6nO7787MMVfzxvxyig52iBHbVq/tR1ixXJDSw3IxFdXyUrL4Fe+pCP26dE0o4
         KwzmFu4zwapwD9+DxyoIcD/POqGfkrGOeKLX7H6IE/GOrsp55r1Mqgcd3UM1Q88UXQHZ
         9a7g==
X-Gm-Message-State: AOAM5328AJTD1Y++JO6PNpTOW79156KBmkRBndRtpQfWUZaR2bIpxH1s
        0VhXyDF7ffaSPYS6dXDAOJHrjvBKqk0gp2H7Jrw=
X-Google-Smtp-Source: ABdhPJw03W/kFhQOtZ1BrXrjraP7yU4DoVDWdk+W9nvyUK84Kd6amIZgHZm9ZoCF0oD2FvjbE139LtwXuQ7LRZmgNn4=
X-Received: by 2002:a17:90a:d511:b0:1bc:50c9:8d8a with SMTP id
 t17-20020a17090ad51100b001bc50c98d8amr13110192pju.112.1645687885260; Wed, 23
 Feb 2022 23:31:25 -0800 (PST)
MIME-Version: 1.0
References: <CAHJXk3b9WhMb7CDHbO3ixGg23G1u7Y+guoLQLWkARgX6Ssrpow@mail.gmail.com>
 <CAHJXk3bpBosy01XojpCd=LFC1Dwbms9GA7FOEudOa_mRgPz7qA@mail.gmail.com>
 <CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com>
 <CAHJXk3bvyfNMDQCzSB2tfzW4PMAx=PRHL9CFBKt1jXgNUH2DkA@mail.gmail.com> <CACGkMEsjkYdkZjQcrqkSfFX5WazCB+hHvfS2z+A4McZ2_2CBFQ@mail.gmail.com>
In-Reply-To: <CACGkMEsjkYdkZjQcrqkSfFX5WazCB+hHvfS2z+A4McZ2_2CBFQ@mail.gmail.com>
From:   Harold Huang <baymaxhuang@gmail.com>
Date:   Thu, 24 Feb 2022 15:31:14 +0800
Message-ID: <CAHJXk3Y9_Fh04sakMMbcAkef7kOTEc-kf84Ne3DtWD7EAp13cg@mail.gmail.com>
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

Hi, Jason,

Jason Wang <jasowang@redhat.com> =E4=BA=8E2022=E5=B9=B42=E6=9C=8824=E6=97=
=A5=E5=91=A8=E5=9B=9B 12:40=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Feb 24, 2022 at 12:19 PM Harold Huang <baymaxhuang@gmail.com> wro=
te:
> >
> > Thanks for Jason's comments.
> >
> > Jason Wang <jasowang@redhat.com> =E4=BA=8E2022=E5=B9=B42=E6=9C=8824=E6=
=97=A5=E5=91=A8=E5=9B=9B 11:23=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Adding netdev.
> > >
> > > On Wed, Feb 23, 2022 at 9:46 PM Harold Huang <baymaxhuang@gmail.com> =
wrote:
> > > >
> > > >  Sorry. The performance tested by iperf is degraded from 4.5 Gbps t=
o
> > > > 750Mbps per flow.
> > > >
> > > > Harold Huang <baymaxhuang@gmail.com> =E4=BA=8E2022=E5=B9=B42=E6=9C=
=8823=E6=97=A5=E5=91=A8=E4=B8=89 21:13=E5=86=99=E9=81=93=EF=BC=9A
> > > > >
> > > > > I see in dpdk virtio-user driver, the TUNSETSNDBUF is initialized=
 with
> > > > > INT_MAX, see: https://github.com/DPDK/dpdk/blob/main/drivers/net/=
virtio/virtio_user/vhost_kernel_tap.c#L169
> > >
> > > Note that Linux use INT_MAX as default sndbuf for tuntap.
> > >
> > > > > It is ok because tap driver uses it to support tx baching, see th=
is
> > > > > patch: https://github.com/torvalds/linux/commit/0a0be13b8fe2cac11=
da2063fb03f0f39359b3069
> > > > >
> > > > > But in tun_xdp_one, napi is not supported and I want to user napi=
 in
> > > > > tun_get_user to enable gro.
> > >
> > > NAPI is not enabled in this path, want to send a patch to do that?
> >
> > Yes, I have a patch in this path to enable NAPI and it greatly
> > improves TCP stream performance, from 4.5Gbsp to 9.2 Gbps per flow. I
> > will send it later for comments.
>
> Good to know that.
>
> Have you compared it with non-NAPI mode?

Do you mean using netif_rx? If so, I have tested and the performance
is about 5Gbps. The netif_rx calls process_backlog to process packet
but it does not support GRO either.

>
> >
> > >
> > > Btw, NAPI mode is used for kernel networking stack hardening at start=
,
> > > but it would be interesting to see if it helps for the performance.
> > >
> > > > > As I result, I change the sndbuf to a
> > > > > value such as 212992 in /proc/sys/net/core/wmem_default.
> > >
> > > Can you describe your setup in detail? Where did you run the iperf
> > > server and client and where did you change the wmem_default?
> >
> > I use dpdk-testpmd to test the vhost-net performance, such as:
> > dpdk-testpmd -l 0-9  -n 4
> > --vdev=3Dvirtio_user0,path=3D/dev/vhost-net,queue_size=3D1024,mac=3D00:=
00:0a:00:00:02
> > -a 0000:06:00.1 -- -i  --txd=3D1024 --rxd=3D1024
> >
> > And I have changed the sndbuf in
> > https://github.com/DPDK/dpdk/blob/main/drivers/net/virtio/virtio_user/v=
host_kernel_tap.c#L169
> > to 212992, which is not INT_MAX anymore. I also enable NAPI in the tun
> > module.  The iperf server ran in the tap interface on the kernel side,
> > which would receive TCP stream from dpdk-testpmd.
>
> You're do TCP stream testing among two TAP and using tesmpd to forward tr=
affic?

The test topology is as follow:
                           ________________________
                           |                                              |
iperf-server-----tap<------->testpmd<------> ixgbe<----------->igxbe
(iperf client)
                           |_______________________|

The testpmd is used to forward traffic from another machine.

>
> > But the performance
> > is greatly degraded,  from 4.5 Gbps to 750Mbps. I am confused about
> > the perf result of the cpu core where iperf server ran, which has a
> > serious bottleneck: 59.86% cpu on the report_bug and  20.66% on the
> > module_find_bug.
>
> This looks odd, you may want to check your perf, I don't think
> module_find_bug() will run at datapath.
>
> >I use centos 8.2 with a native 4.18.0-193.el8.x86_64
> > kernel to test.
>
> The kernel is kind of too old, I suggest to test recent kernel version.

I will use a recent kernel to test it later.

>
> Thanks
>
> >
> > >
> > > > > But the
> > > > > performance tested by iperf is greatly degraded, from 4.5 Gbps to
> > > > > 750Gbps per flow. I see the the iperf server consume 100% cpu cor=
e,
> > > > > which should be the bottleneck of the this test. The perf top res=
ult
> > > > > of iperf server cpu core is as follows:
> > > > >
> > > > > '''
> > > > > Samples: 72  of event 'cycles', 4000 Hz, Event count (approx.):
> > > > > 22685278 lost: 0/0 drop: 0/0
> > > > > Overhead  Shared O  Symbol
> > > > >   59.86%  [kernel]  [k] report_bug
> > > > >   20.66%  [kernel]  [k] module_find_bug
> > > > >    6.51%  [kernel]  [k] common_interrupt
> > > > >    2.82%  [kernel]  [k] __slab_free
> > > > >    1.48%  [kernel]  [k] copy_user_enhanced_fast_string
> > > > >    1.44%  [kernel]  [k] __skb_datagram_iter
> > > > >    1.42%  [kernel]  [k] notifier_call_chain
> > > > >    1.41%  [kernel]  [k] irq_work_run_list
> > > > >    1.41%  [kernel]  [k] update_irq_load_avg
> > > > >    1.41%  [kernel]  [k] task_tick_fair
> > > > >    1.41%  [kernel]  [k] cmp_ex_search
> > > > >    0.16%  [kernel]  [k] __ghes_peek_estatus.isra.12
> > > > >    0.02%  [kernel]  [k] acpi_os_read_memory
> > > > >    0.00%  [kernel]  [k] native_apic_mem_write
> > > > > '''
> > > > > I am not clear about the test result. Can we change the sndbuf si=
ze in
> > > > > dpdk? Is any way to enable vhost_net to use napi without changing=
 the
> > > > > tun kernel driver?
> > >
> > > You can do this by not using INT_MAX as sndbuf.
> >
> > Just mentioned above, I change the sndbuf value and I met a serious
> > performance degradation.
> >
> > >
> > > Thanks
> > >
> > > >
> > >
> >
>
