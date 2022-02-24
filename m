Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20544C2312
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 05:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiBXEh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 23:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiBXEhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 23:37:25 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D714510EE
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:36:52 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gl14-20020a17090b120e00b001bc2182c3d5so4751768pjb.1
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aF839RdN5pgbGhmSGvabjB9GBim8qWgWEBwGQ0omKMQ=;
        b=Ilk2LNUdSZktSaFqjAdRtLrOZwHgMoAOEBnNVB6M8rptgoP2CUhg9+ax2QLsRSMWnd
         nb5jLc3HPI3gl+J2xOQadw3IBoT8rW7wXckxVefdbH/fKLP4j/HpBYtTgWP0AMpIxYuh
         VoeoDekb3gQZDgDPW+JgR4jR5Ebchp+uOxHpUzH2Y5Pe+kOi8tATPEJbCO5vsUjpAESO
         EDTWuEq4wLIiPGghKuWJz0EwbTeDSQtiEJDrGmgq0HRy0Pwg5AzEkyZR84FcDUqgsxXs
         ob3P55LwrmbXDcsKbHDUIe9P1V6xdAakSoDcprMFnNAL5wmMb4Awit6sR1MUA/D3sT7d
         GPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aF839RdN5pgbGhmSGvabjB9GBim8qWgWEBwGQ0omKMQ=;
        b=miTZswNINO2qgUBfX58r4wJNAYVYrRtIfSuq8XnkpjjmPt/9l6Nj2gBtH6a9vQPjQm
         2GoyiGN4OAULbmtmidBXYOhM7M3KbU1f7OX3WiDz7pIuVRvtdzFr72EGvyXQUVsuUSDk
         1CJFYsYIbxmDoyC5WmBFR8Ks52UIQrXjDgG2oNnjM0hi6ihwZlURfltklQ1VKumctQ5Q
         GB+sK5lr45/6Hyuo7lVz7YVSycDo3UckovS/RzwXUd2Gtx8lfo/jaD9tpu5KGGiXfKKG
         XGbW6Sdb+EG3znKv4O8BmU59QtK78GdH6gvpFZGlHbd7pZOEbhEpFDWoAmR0qN+pGAUw
         /NyQ==
X-Gm-Message-State: AOAM531cSbYTmhWnq02T7c0lbB1jW/R4BFTwtLTrFEOsrs6/i6+V55Eu
        7MPtPpWTCRQW8I59s9ST0oG4mCebCjHaGNx5P6M=
X-Google-Smtp-Source: ABdhPJwdwMvYZhB0Po+dvefEHeMf+bRvHxKfUX54RdkTyov9StNoc4cba+RXHg1NMZxJGHJTMyX8Zr4bCQIGcehOisU=
X-Received: by 2002:a17:902:6b0a:b0:14d:8ee9:3298 with SMTP id
 o10-20020a1709026b0a00b0014d8ee93298mr822369plk.125.1645677412356; Wed, 23
 Feb 2022 20:36:52 -0800 (PST)
MIME-Version: 1.0
References: <CAHJXk3b9WhMb7CDHbO3ixGg23G1u7Y+guoLQLWkARgX6Ssrpow@mail.gmail.com>
 <CAHJXk3bpBosy01XojpCd=LFC1Dwbms9GA7FOEudOa_mRgPz7qA@mail.gmail.com>
 <CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com> <CAHJXk3bvyfNMDQCzSB2tfzW4PMAx=PRHL9CFBKt1jXgNUH2DkA@mail.gmail.com>
In-Reply-To: <CAHJXk3bvyfNMDQCzSB2tfzW4PMAx=PRHL9CFBKt1jXgNUH2DkA@mail.gmail.com>
From:   Harold Huang <baymaxhuang@gmail.com>
Date:   Thu, 24 Feb 2022 12:36:41 +0800
Message-ID: <CAHJXk3bVBKyP2UnKs4rTypfHLRs2d3=DuDSvM8e_2WMWtgYa8w@mail.gmail.com>
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

Harold Huang <baymaxhuang@gmail.com> =E4=BA=8E2022=E5=B9=B42=E6=9C=8824=E6=
=97=A5=E5=91=A8=E5=9B=9B 12:19=E5=86=99=E9=81=93=EF=BC=9A
>
> Thanks for Jason's comments.
>
> Jason Wang <jasowang@redhat.com> =E4=BA=8E2022=E5=B9=B42=E6=9C=8824=E6=97=
=A5=E5=91=A8=E5=9B=9B 11:23=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Adding netdev.
> >
> > On Wed, Feb 23, 2022 at 9:46 PM Harold Huang <baymaxhuang@gmail.com> wr=
ote:
> > >
> > >  Sorry. The performance tested by iperf is degraded from 4.5 Gbps to
> > > 750Mbps per flow.
> > >
> > > Harold Huang <baymaxhuang@gmail.com> =E4=BA=8E2022=E5=B9=B42=E6=9C=88=
23=E6=97=A5=E5=91=A8=E4=B8=89 21:13=E5=86=99=E9=81=93=EF=BC=9A
> > > >
> > > > I see in dpdk virtio-user driver, the TUNSETSNDBUF is initialized w=
ith
> > > > INT_MAX, see: https://github.com/DPDK/dpdk/blob/main/drivers/net/vi=
rtio/virtio_user/vhost_kernel_tap.c#L169
> >
> > Note that Linux use INT_MAX as default sndbuf for tuntap.
> >
> > > > It is ok because tap driver uses it to support tx baching, see this
> > > > patch: https://github.com/torvalds/linux/commit/0a0be13b8fe2cac11da=
2063fb03f0f39359b3069
> > > >
> > > > But in tun_xdp_one, napi is not supported and I want to user napi i=
n
> > > > tun_get_user to enable gro.
> >
> > NAPI is not enabled in this path, want to send a patch to do that?
>
> Yes, I have a patch in this path to enable NAPI and it greatly
> improves TCP stream performance, from 4.5Gbsp to 9.2 Gbps per flow. I
> will send it later for comments.
>
> >
> > Btw, NAPI mode is used for kernel networking stack hardening at start,
> > but it would be interesting to see if it helps for the performance.
> >
> > > > As I result, I change the sndbuf to a
> > > > value such as 212992 in /proc/sys/net/core/wmem_default.
> >
> > Can you describe your setup in detail? Where did you run the iperf
> > server and client and where did you change the wmem_default?
>
> I use dpdk-testpmd to test the vhost-net performance, such as:
> dpdk-testpmd -l 0-9  -n 4
> --vdev=3Dvirtio_user0,path=3D/dev/vhost-net,queue_size=3D1024,mac=3D00:00=
:0a:00:00:02
> -a 0000:06:00.1 -- -i  --txd=3D1024 --rxd=3D1024
>
> And I have changed the sndbuf in
> https://github.com/DPDK/dpdk/blob/main/drivers/net/virtio/virtio_user/vho=
st_kernel_tap.c#L169
> to 212992, which is not INT_MAX anymore. I also enable NAPI in the tun
> module.  The iperf server ran in the tap interface on the kernel side,
> which would receive TCP stream from dpdk-testpmd. But the performance
> is greatly degraded,  from 4.5 Gbps to 750Mbps. I am confused about
> the perf result of the cpu core where iperf server ran, which has a
> serious bottleneck: 59.86% cpu on the report_bug and  20.66% on the
> module_find_bug. I use centos 8.2 with a native 4.18.0-193.el8.x86_64
> kernel to test.

BTW, if I change sock_can_batch =3D false in
https://github.com/torvalds/linux/blob/master/drivers/vhost/net.c#L782
directly and use the default sk.sk_sndbuf size, ie. INT_MAX, the test
result seems ok.

>
> >
> > > > But the
> > > > performance tested by iperf is greatly degraded, from 4.5 Gbps to
> > > > 750Gbps per flow. I see the the iperf server consume 100% cpu core,
> > > > which should be the bottleneck of the this test. The perf top resul=
t
> > > > of iperf server cpu core is as follows:
> > > >
> > > > '''
> > > > Samples: 72  of event 'cycles', 4000 Hz, Event count (approx.):
> > > > 22685278 lost: 0/0 drop: 0/0
> > > > Overhead  Shared O  Symbol
> > > >   59.86%  [kernel]  [k] report_bug
> > > >   20.66%  [kernel]  [k] module_find_bug
> > > >    6.51%  [kernel]  [k] common_interrupt
> > > >    2.82%  [kernel]  [k] __slab_free
> > > >    1.48%  [kernel]  [k] copy_user_enhanced_fast_string
> > > >    1.44%  [kernel]  [k] __skb_datagram_iter
> > > >    1.42%  [kernel]  [k] notifier_call_chain
> > > >    1.41%  [kernel]  [k] irq_work_run_list
> > > >    1.41%  [kernel]  [k] update_irq_load_avg
> > > >    1.41%  [kernel]  [k] task_tick_fair
> > > >    1.41%  [kernel]  [k] cmp_ex_search
> > > >    0.16%  [kernel]  [k] __ghes_peek_estatus.isra.12
> > > >    0.02%  [kernel]  [k] acpi_os_read_memory
> > > >    0.00%  [kernel]  [k] native_apic_mem_write
> > > > '''
> > > > I am not clear about the test result. Can we change the sndbuf size=
 in
> > > > dpdk? Is any way to enable vhost_net to use napi without changing t=
he
> > > > tun kernel driver?
> >
> > You can do this by not using INT_MAX as sndbuf.
>
> Just mentioned above, I change the sndbuf value and I met a serious
> performance degradation.
>
> >
> > Thanks
> >
> > >
> >
