Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3CA4C2318
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 05:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiBXEkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 23:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiBXEkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 23:40:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2443220A965
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645677599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Am46PTmy5kMN2mfTXjYSgc6DjUyFNTOSNwyB1OrzwSE=;
        b=EiV6xSGVF0P55INAZRa2SBS+GJjrgGBZu01R7odrE1MurmG36QSMN1BruycEjf2h/3rslG
        YykawEPOrJ5yQAQHoNuPW8OiclUbvtqe9CsIPC3GpAOx+4ArflrjLsCLSWFW6SD/Ofcvkn
        4aznlQovH2pm0kMAREhX7lfv7tXw994=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-Qmxm5WAPPaaOtJFRQ6_6MQ-1; Wed, 23 Feb 2022 23:39:58 -0500
X-MC-Unique: Qmxm5WAPPaaOtJFRQ6_6MQ-1
Received: by mail-lj1-f197.google.com with SMTP id n9-20020a2e82c9000000b002435af2e8b9so443790ljh.20
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:39:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Am46PTmy5kMN2mfTXjYSgc6DjUyFNTOSNwyB1OrzwSE=;
        b=C7fJdul3aehCdqqvqELilEYRRqUFgu8AqQZBeoI7n/vhGI0h0ZotpkRnFGuzCY5725
         V/BeRH744YXa0ee6Hw02HxnB59753thBkQsT9LfvXgzYPfHEKpc/xWqUcgLmasUQrwx7
         29na+R595ng3ImpYgib6tu8CCALDtuz3ozq1+r+WaXKRFr9GLWLLxlpO/4zy3tzRnh+C
         g1L95J4BXmhEsvGutl+C72wof4ch95epyU9sRxGwp0tBkHtNpaiaTL4wxIXzq6dvjIPS
         ZUIHc1jc0Y3nux2CTHPuCTAHimXRdWl81RAS+E7liYaMIwKL3rIa+EfXATPyU41m7Zw5
         jLDw==
X-Gm-Message-State: AOAM531S88fj1awv347Smgi+Qu5hLl14rMETanVTqj9V+eTBLprnWhwT
        tQFD0RXWidwEOWM1X/QdQkDFj+GQ0462jAWupaCA9hmxELtZ8/vhXzuVuIdgJxq47h/5BzFLAga
        qFD7N6qpyQZl1x/rXXYQarGfhTNTdaELt
X-Received: by 2002:a05:6512:3d08:b0:43f:8f45:d670 with SMTP id d8-20020a0565123d0800b0043f8f45d670mr695855lfv.587.1645677596300;
        Wed, 23 Feb 2022 20:39:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwO3Gfx4nBQ0YNhzLMSiTyrx/rVkAKNhMF9Czk833KtuEnohiO8qOAxsHFguLu++WRIgmo8EFwvzD+xKACdP4U=
X-Received: by 2002:a05:6512:3d08:b0:43f:8f45:d670 with SMTP id
 d8-20020a0565123d0800b0043f8f45d670mr695848lfv.587.1645677596053; Wed, 23 Feb
 2022 20:39:56 -0800 (PST)
MIME-Version: 1.0
References: <CAHJXk3b9WhMb7CDHbO3ixGg23G1u7Y+guoLQLWkARgX6Ssrpow@mail.gmail.com>
 <CAHJXk3bpBosy01XojpCd=LFC1Dwbms9GA7FOEudOa_mRgPz7qA@mail.gmail.com>
 <CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com> <CAHJXk3bvyfNMDQCzSB2tfzW4PMAx=PRHL9CFBKt1jXgNUH2DkA@mail.gmail.com>
In-Reply-To: <CAHJXk3bvyfNMDQCzSB2tfzW4PMAx=PRHL9CFBKt1jXgNUH2DkA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 24 Feb 2022 12:39:44 +0800
Message-ID: <CACGkMEsjkYdkZjQcrqkSfFX5WazCB+hHvfS2z+A4McZ2_2CBFQ@mail.gmail.com>
Subject: Re: Question about the sndbuf of the tap interface with vhost-net
To:     Harold Huang <baymaxhuang@gmail.com>
Cc:     users@dpdk.org, Maxime Coquelin <maxime.coquelin@redhat.com>,
        Chenbo Xia <chenbo.xia@intel.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 12:19 PM Harold Huang <baymaxhuang@gmail.com> wrote=
:
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

Good to know that.

Have you compared it with non-NAPI mode?

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
> which would receive TCP stream from dpdk-testpmd.

You're do TCP stream testing among two TAP and using tesmpd to forward traf=
fic?

> But the performance
> is greatly degraded,  from 4.5 Gbps to 750Mbps. I am confused about
> the perf result of the cpu core where iperf server ran, which has a
> serious bottleneck: 59.86% cpu on the report_bug and  20.66% on the
> module_find_bug.

This looks odd, you may want to check your perf, I don't think
module_find_bug() will run at datapath.

>I use centos 8.2 with a native 4.18.0-193.el8.x86_64
> kernel to test.

The kernel is kind of too old, I suggest to test recent kernel version.

Thanks

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
>

