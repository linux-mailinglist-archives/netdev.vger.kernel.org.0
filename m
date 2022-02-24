Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4DC4C2260
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 04:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiBXDY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 22:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiBXDYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 22:24:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BAA71A128C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 19:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645673034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CLYmPytNi8Y5ncMBx5Mf9J1ouptftAJw22Im2XIZ2e8=;
        b=dQwsX+nUkBoh+lBm+N288BpyN7Msk4h7U5pxME9bEyQeS+QmTTL6fGcgBT5zXrel26UbYp
        eNbusDUbQKOF0K6gGOLqI3rUrgNoqPxR9fgy9HcStDgJ/+e1xaZ6paL46PkRhAkqc3X4Mc
        HxxLeTPKo8d9pfu00TbHZdmr8CgwnqE=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-pFknz_mqPGOhsGPzG9Rr9Q-1; Wed, 23 Feb 2022 22:23:53 -0500
X-MC-Unique: pFknz_mqPGOhsGPzG9Rr9Q-1
Received: by mail-lj1-f200.google.com with SMTP id a5-20020a2eb545000000b002462b5eddb3so381695ljn.14
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 19:23:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CLYmPytNi8Y5ncMBx5Mf9J1ouptftAJw22Im2XIZ2e8=;
        b=IsAJsNsBUURAUwFeGx4O+9AsupkqDmWKjaHI4u7EdS/KKYuhFvYxCl0O7hdjNfZg0I
         06HMfq1KgSzdaLBP+nlC8qFC26z4OseE+6EreChTISuURVtrveo3MEfjTyl9YLtSToG0
         UOnWo/ngOtDTvHGkiUkiOCufyoy0BAqqAxnJ6S4UzktEeWZ5QYNAuFZ12nTJ1axrU6iS
         Rb5FSe3EGjVDUbCM986UfniGD+0sPjrzSlqvXZNLaUys1nkuxnYZA9uAsE9Gm4IMpuEW
         rBrTur3ugqWE2ZAtiRRgbxRSXIjsxNHFJQeMhgIGl/UIP6nhS+Uhl8l14IYn4laZ5Of3
         Xm/A==
X-Gm-Message-State: AOAM533yZwZ3/XMV9sqee+0CKt5uwUiRJbr7ynNitlpE7WmBw/UtBgpR
        G6BsZmUQ5IZ6sqrWE7ijlGm9/GuuC8HFrswMiYOCfSp4lhIVvASautu8Q/urqEXMs0uc3UL1YE7
        ka+j8GiyTik/PpiAEunFNk6isZKFB06Go
X-Received: by 2002:a05:6512:3147:b0:443:323d:179d with SMTP id s7-20020a056512314700b00443323d179dmr579175lfi.98.1645673031405;
        Wed, 23 Feb 2022 19:23:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUe5dwgs4Zt8RJjJa9dYBCHoUjub4YEZ6koNq4tb1tfp+jvAlBT28t478zjTiwSykr/+BPx9EVwpRaN2ShvWA=
X-Received: by 2002:a05:6512:3147:b0:443:323d:179d with SMTP id
 s7-20020a056512314700b00443323d179dmr579169lfi.98.1645673031202; Wed, 23 Feb
 2022 19:23:51 -0800 (PST)
MIME-Version: 1.0
References: <CAHJXk3b9WhMb7CDHbO3ixGg23G1u7Y+guoLQLWkARgX6Ssrpow@mail.gmail.com>
 <CAHJXk3bpBosy01XojpCd=LFC1Dwbms9GA7FOEudOa_mRgPz7qA@mail.gmail.com>
In-Reply-To: <CAHJXk3bpBosy01XojpCd=LFC1Dwbms9GA7FOEudOa_mRgPz7qA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 24 Feb 2022 11:23:39 +0800
Message-ID: <CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com>
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

Adding netdev.

On Wed, Feb 23, 2022 at 9:46 PM Harold Huang <baymaxhuang@gmail.com> wrote:
>
>  Sorry. The performance tested by iperf is degraded from 4.5 Gbps to
> 750Mbps per flow.
>
> Harold Huang <baymaxhuang@gmail.com> =E4=BA=8E2022=E5=B9=B42=E6=9C=8823=
=E6=97=A5=E5=91=A8=E4=B8=89 21:13=E5=86=99=E9=81=93=EF=BC=9A
> >
> > I see in dpdk virtio-user driver, the TUNSETSNDBUF is initialized with
> > INT_MAX, see: https://github.com/DPDK/dpdk/blob/main/drivers/net/virtio=
/virtio_user/vhost_kernel_tap.c#L169

Note that Linux use INT_MAX as default sndbuf for tuntap.

> > It is ok because tap driver uses it to support tx baching, see this
> > patch: https://github.com/torvalds/linux/commit/0a0be13b8fe2cac11da2063=
fb03f0f39359b3069
> >
> > But in tun_xdp_one, napi is not supported and I want to user napi in
> > tun_get_user to enable gro.

NAPI is not enabled in this path, want to send a patch to do that?

Btw, NAPI mode is used for kernel networking stack hardening at start,
but it would be interesting to see if it helps for the performance.

> > As I result, I change the sndbuf to a
> > value such as 212992 in /proc/sys/net/core/wmem_default.

Can you describe your setup in detail? Where did you run the iperf
server and client and where did you change the wmem_default?

> > But the
> > performance tested by iperf is greatly degraded, from 4.5 Gbps to
> > 750Gbps per flow. I see the the iperf server consume 100% cpu core,
> > which should be the bottleneck of the this test. The perf top result
> > of iperf server cpu core is as follows:
> >
> > '''
> > Samples: 72  of event 'cycles', 4000 Hz, Event count (approx.):
> > 22685278 lost: 0/0 drop: 0/0
> > Overhead  Shared O  Symbol
> >   59.86%  [kernel]  [k] report_bug
> >   20.66%  [kernel]  [k] module_find_bug
> >    6.51%  [kernel]  [k] common_interrupt
> >    2.82%  [kernel]  [k] __slab_free
> >    1.48%  [kernel]  [k] copy_user_enhanced_fast_string
> >    1.44%  [kernel]  [k] __skb_datagram_iter
> >    1.42%  [kernel]  [k] notifier_call_chain
> >    1.41%  [kernel]  [k] irq_work_run_list
> >    1.41%  [kernel]  [k] update_irq_load_avg
> >    1.41%  [kernel]  [k] task_tick_fair
> >    1.41%  [kernel]  [k] cmp_ex_search
> >    0.16%  [kernel]  [k] __ghes_peek_estatus.isra.12
> >    0.02%  [kernel]  [k] acpi_os_read_memory
> >    0.00%  [kernel]  [k] native_apic_mem_write
> > '''
> > I am not clear about the test result. Can we change the sndbuf size in
> > dpdk? Is any way to enable vhost_net to use napi without changing the
> > tun kernel driver?

You can do this by not using INT_MAX as sndbuf.

Thanks

>

