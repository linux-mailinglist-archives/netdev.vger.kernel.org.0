Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B3E5894F1
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 01:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiHCXlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 19:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238530AbiHCXlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 19:41:47 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA2850734
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 16:41:22 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pm17so12352184pjb.3
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 16:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1sPbeiZpRruAa6REs//xsGmRNVOyOPNtxbd2Sfog704=;
        b=1US45KLl5AbHH3duMeY7x64PyCB5fJKkwYEm656wVG0uqOOcr6O36D0Gk3uvV8nVWo
         EtfcVWEN4FRRGsKq6s8rragY645M6ubika72Z3SC7WfEmoMARcPZyrWD40ed435YqfMh
         rbGwfkgouP0sYM+q0pguzTvcwyr9h8w4UWzjnPnvGDbayxeHte7djgxWVxEC3N9tS3bQ
         u5RMpNL/v7BOrubRlxhat/W1mkp/O7h0mRWt3EXepjIvKYHzG6N07PfnmcpIFxozM5Gw
         eLVykql9/o+qVwxyC/HNKSLMYCuRZ/UFQQ6amCTW2gxHOauCTxcSD/XRZ/RiRJ2gne5Q
         jYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1sPbeiZpRruAa6REs//xsGmRNVOyOPNtxbd2Sfog704=;
        b=KcatSHnFolXB0/3nEyLNxo++66b2dgZ0EhNJzURehXXdKmhQwoLBR4VTte+i3CSvv3
         VVcdutRxlUOfwcV5eEbaSTWaQ2EXssEcrxPkVk8KdQLxiTjEs+2do2Ps0yo+8cp5PL0h
         6DGrV3UTX+kjpv6fDo4p7wWW8GMs8PI6n+5gRgeWd6L5Y92/Je2IcbDxU03EXFiKJxvh
         mo/N10KW6xpco5ZWstEfAChQojBVxwvbR/rIDSsxHkiZc2jB+RQi+EluAqdyWnbkJUQK
         3+jTU6v/S+79dS9XiIpHLlsUnJDG4x35qLQbC9xB0hvYPb/gm+CpsWKbwjTg9G+rC+1d
         TklA==
X-Gm-Message-State: ACgBeo1prcLH8i1csAFf1KQKSk/QxTcwaWKJq06ZOWK7WcIQI8mVdRXL
        pg42lPrHmq/UiOFGb2sJ9L9EJg==
X-Google-Smtp-Source: AA6agR5c4SHTahuBWgqei8kKggTl9cLa8c8jckoIYfd4i6X7Bb0kGgOdlVW6WpQxcoSbiuLenak0TQ==
X-Received: by 2002:a17:90a:1a5c:b0:1f5:15a6:aae9 with SMTP id 28-20020a17090a1a5c00b001f515a6aae9mr7458087pjl.117.1659570081771;
        Wed, 03 Aug 2022 16:41:21 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id z16-20020aa79590000000b0052db82ad8b2sm5961555pfj.123.2022.08.03.16.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 16:41:21 -0700 (PDT)
Date:   Wed, 3 Aug 2022 16:41:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, zmlcc@linux.alibaba.com,
        hans@linux.alibaba.com, zhiyuan2048@linux.alibaba.com,
        herongguang@linux.alibaba.com
Subject: Re: [RFC net-next 1/1] net/smc: SMC for inter-VM communication
Message-ID: <20220803164119.5955b442@hermes.local>
In-Reply-To: <0ccf9cc6-4916-7815-9ce2-990dc7884849@linux.ibm.com>
References: <20220720170048.20806-1-tonylu@linux.alibaba.com>
        <0ccf9cc6-4916-7815-9ce2-990dc7884849@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,WEIRD_QUOTING
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Aug 2022 16:27:54 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 7/20/22 1:00 PM, Tony Lu wrote:
> > Hi all,
> >=20
> > # Background
> >=20
> > We (Alibaba Cloud) have already used SMC in cloud environment to
> > transparently accelerate TCP applications with ERDMA [1]. Nowadays,
> > there is a common scenario that deploy containers (which runtime is
> > based on lightweight virtual machine) on ECS (Elastic Compute Service),
> > and the containers may want to be scheduled on the same host in order to
> > get higher performance of network, such as AI, big data or other
> > scenarios that are sensitive with bandwidth and latency. Currently, the
> > performance of inter-VM is poor and CPU resource is wasted (see
> > #Benchmark virtio). This scenario has been discussed many times, but a
> > solution for a common scenario for applications is missing [2] [3] [4].
> >=20
> > # Design
> >=20
> > In inter-VM scenario, we use ivshmem (Inter-VM shared memory device)
> > which is modeled by QEMU [5]. With it, multiple VMs can access one
> > shared memory. This shared memory device is statically created by host
> > and shared to desired guests. The device exposes as a PCI BAR, and can
> > interrupt its peers (ivshmem-doorbell).
> >=20
> > In order to use ivshmem in SMC, we write a draft device driver as a
> > bridge between SMC and ivshmem PCI device. To make it easier, this
> > driver acts like a SMC-D device in order to fit in SMC without modifying
> > the code, which is named ivpci (see patch #1).
> >=20
> >    =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=90
> >    =E2=94=82  =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=90 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=90  =E2=94=82
> >    =E2=94=82  =E2=94=82      VM1      =E2=94=82 =E2=94=82      VM2     =
 =E2=94=82  =E2=94=82
> >    =E2=94=82  =E2=94=82=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=90=E2=94=82 =E2=94=82=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=90=E2=94=82  =E2=94=82
> >    =E2=94=82  =E2=94=82=E2=94=82 Application =E2=94=82=E2=94=82 =E2=94=
=82=E2=94=82 Application =E2=94=82=E2=94=82  =E2=94=82
> >    =E2=94=82  =E2=94=82=E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=A4=E2=94=82 =E2=94=82=E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=A4=E2=94=82  =E2=94=82
> >    =E2=94=82  =E2=94=82=E2=94=82     SMC     =E2=94=82=E2=94=82 =E2=94=
=82=E2=94=82     SMC     =E2=94=82=E2=94=82  =E2=94=82
> >    =E2=94=82  =E2=94=82=E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=A4=E2=94=82 =E2=94=82=E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=A4=E2=94=82  =E2=94=82
> >    =E2=94=82  =E2=94=82=E2=94=82    ivpci    =E2=94=82=E2=94=82 =E2=94=
=82=E2=94=82    ivpci    =E2=94=82=E2=94=82  =E2=94=82
> >    =E2=94=82  =E2=94=94=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=98=E2=94=98 =E2=94=94=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=98=E2=94=98  =E2=94=82
> >    =E2=94=82        x  *               x  *        =E2=94=82
> >    =E2=94=82        x  ****************x* *        =E2=94=82
> >    =E2=94=82        x  xxxxxxxxxxxxxxxxx* *        =E2=94=82
> >    =E2=94=82        x  x                * *        =E2=94=82
> >    =E2=94=82  =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=90 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=90  =E2=94=82
> >    =E2=94=82  =E2=94=82shared memories=E2=94=82 =E2=94=82ivshmem-server=
 =E2=94=82  =E2=94=82
> >    =E2=94=82  =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=98 =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98  =E2=94=82
> >    =E2=94=82                HOST A                 =E2=94=82
> >    =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98
> >     *********** Control flow (interrupt)
> >     xxxxxxxxxxx Data flow (memory access)
> >=20
> > Inside ivpci driver, it implements almost all the operations of SMC-D
> > device. It can be divided into two parts:
> >=20
> > - control flow, most of it is same with SMC-D, use ivshmem trigger
> >    interruptions in ivpci and process CDC flow.
> >=20
> > - data flow, the shared memory of each connection is one large region
> >    and divided into two part for local and remote RMB. Every writer
> >    syscall copies data to sndbuf and calls ISM's move_data() to move da=
ta
> >    to remote RMB in ivshmem and interrupt remote. And reader then
> >    receives interruption and check CDC message, consume data if cursor =
is
> >    updated.
> >=20
> > # Benchmark
> >=20
> > Current POC of ivpci is unstable and only works for single SMC
> > connection. Here is the brief data:
> >=20
> > Items         Latency (pingpong)    Throughput (64KB)
> > TCP (virtio)   19.3 us                3794.185 MBps
> > TCP (SR-IOV)   13.2 us                3948.792 MBps
> > SMC (ivshmem)   6.3 us               11900.269 MBps
> >=20
> > Test environments:
> >=20
> > - CPU Intel Xeon Platinum 8 core, mem 32 GiB
> > - NIC Mellanox CX4 with 2 VFs in two different guests
> > - using virsh to setup virtio-net + vhost
> > - using sockperf and single connection
> > - SMC + ivshmem throughput uses one-copy (userspace -> kernel copy)
> >    with intrusive modification of SMC (see patch #1), latency (pingpong)
> >    use two-copy (user -> kernel and move_data() copy, patch version).
> >=20
> > With the comparison, SMC with ivshmem gets 3-4x bandwidth and a half
> > latency.
> >=20
> > TCP + virtio is the most usage solution for guest, it gains lower
> > performance. Moreover, it consumes extra thread with full CPU core
> > occupied in host to transfer data, wastes more CPU resource. If the host
> > is very busy, the performance will be worse.
> >  =20
>=20
> Hi Tony,
>=20
> Quite interesting!  FWIW for s390x we are also looking at passthrough of=
=20
> host ISM devices to enable SMC-D in QEMU guests:
> https://lore.kernel.org/kvm/20220606203325.110625-1-mjrosato@linux.ibm.co=
m/
> https://lore.kernel.org/kvm/20220606203614.110928-1-mjrosato@linux.ibm.co=
m/
>=20
> But seems to me an 'emulated ISM' of sorts could still be interesting=20
> even on s390x e.g. for scenarios where host device passthrough is not=20
> possible/desired.
>=20
> Out of curiosity I tried this ivpci module on s390x but the device won't=
=20
> probe -- This is possibly an issue with the s390x PCI emulation layer in=
=20
> QEMU, I'll have to look into that.
>=20
> > # Discussion
> >=20
> > This RFC and solution is still in early stage, so we want to come it up
> > as soon as possible and fully discuss with IBM and community. We have
> > some topics putting on the table:
> >=20
> > 1. SMC officially supports this scenario.
> >=20
> > SMC + ivshmem shows huge improvement when communicating inter VMs. SMC-D
> > and mocking ISM device might not be the official solution, maybe another
> > extension for SMC besides SMC-R and SMC-D. So we are wondering if SMC
> > would accept this idea to fix this scenario? Are there any other
> > possibilities? =20
>=20
> I am curious about ivshmem and its current state though -- e.g. looking=20
> around I see mention of v2 which you also referenced but don't see any=20
> activity on it for a few years?  And as far as v1 ivshmem -- server "not=
=20
> for production use", etc.
>=20
> Thanks,
> Matt
>=20
> >=20
> > 2. Implementation of SMC for inter-VM.
> >=20
> > SMC is used in container and cloud environment, maybe we can propose a
> > new device and new protocol if possible in these new scenarios to solve
> > this problem.
> >=20
> > 3. Standardize this new protocol and device.
> >=20
> > SMC-R has an open RFC 7609, so can this new device or protocol like
> > SMC-D can be standardized. There is a possible option that proposing a
> > new device model in QEMU + virtio ecosystem and SMC supports this
> > standard virtio device, like [6].
> >=20
> > If there are any problems, please point them out.
> >=20
> > Hope to hear from you, thank you.
> >=20
> > [1] https://lwn.net/Articles/879373/
> > [2] https://projectacrn.github.io/latest/tutorials/enable_ivshmem.html
> > [3] https://dl.acm.org/doi/10.1145/2847562
> > [4] https://hal.archives-ouvertes.fr/hal-00368622/document
> > [5] https://github.com/qemu/qemu/blob/master/docs/specs/ivshmem-spec.txt
> > [6] https://github.com/siemens/jailhouse/blob/master/Documentation/ivsh=
mem-v2-specification.md
> >=20
> > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com> =20


Also looks a lot like existing VSOCK which has transports for Virtio, Hyper=
V and VMWare already.
