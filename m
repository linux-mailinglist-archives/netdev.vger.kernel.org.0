Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFCA6CF837
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 02:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjC3A1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 20:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC3A1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 20:27:15 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A256C1FED
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 17:27:14 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id cm5so5605671pfb.0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 17:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1680136034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7VcmXdqZtNcPeKWqqyIJTPXJmEo1KcutXG7+M0aesE=;
        b=R1M/CIP/JQFpeVL8E0F5bZ0UWFsJqCCz8R59Fiw3Tk3q9Wrlr2N61iOMQ2JnulyEF4
         0GArupJYHX8F4t5Yd0a1Upgj1llOuYx/0F1qixzjDBvgiIgXctf1+t8AMK+Q8Dr380lR
         jJNnJYB/Mk4Wl/yYtmIfVdlHGdHgNWnyS8daheiEgOgxJedfOaJeOn0IRS2NmW8OjgUn
         67K+50TfZRp1Q0T+xEsxrqxFe29fx/0+X0mOE8q5EbsAWf89Xb/HG+dJzmHzdGqU/bsO
         b44XzdgRmN3fFFisVB65b4/XIiJWDkkE4/tBicItHVydnFQHvRoiqWt7Gb2JG5JCfC8H
         fztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680136034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i7VcmXdqZtNcPeKWqqyIJTPXJmEo1KcutXG7+M0aesE=;
        b=tDPFdJwuMlK21XUrt0H6QMzJT74EX4E0uS7xsTh5sLNATJTOr4aV9dqErRLMxcGWLU
         P6I2U1FBl+zN9SP78WdpmdmbajfGoUMyj3n9uHPd2CRQ1HcmKzLWGogX8sSL2qgQNgJL
         MXxp4Ypo8uR+6kLOgKknIbKjBYSUgwMpaxj4FX8pLDM8hrMtvLP64I8UwybFPVgelH7t
         3MoT6N6lGJNzGTmZ9P1AadDJpSXomv9vqXLbi+xK47G6Mnv6LoTLch/bjy7dcFe52N3h
         CI/UM+jQ3mermN6kKYsCsiRbS8d+mAN/r//xlRi5xVZ1+GjduW6yhb7H+A5oai5l+2pC
         0S4w==
X-Gm-Message-State: AAQBX9eQ5khNJs+u7ulOKUkJfoAer+jMGBYIff7OJ6ed3s3QsbvO76W+
        bFglAxhCDjbtKWZxSazYZCYi2eKGNTgCh4IdDYMOtQ==
X-Google-Smtp-Source: AKy350ZNgBTk/Bl4y/6vvaNgvZiKUvk17nRG9kMC7zx9X0sp3nTZlxV9bWZ4SpbZLulQWGN39+CX3JMU46PBItELf1Q=
X-Received: by 2002:a05:6a00:2385:b0:5aa:310c:e65b with SMTP id
 f5-20020a056a00238500b005aa310ce65bmr10810754pfc.2.1680136033965; Wed, 29 Mar
 2023 17:27:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230329104546.108016-1-andrew@daynix.com> <1680090663.603155-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1680090663.603155-2-xuanzhuo@linux.alibaba.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Thu, 30 Mar 2023 03:09:22 +0300
Message-ID: <CABcq3pFGhGpRmOBQEaCWhW89ANPqvnDJoSQrPn4O0SmGPGnaKQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] eBPF RSS through QMP support.
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     yan@daynix.com, yuri.benditovich@daynix.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mst@redhat.com, jasowang@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oh yeah, I'll fix that. Thank you!

On Wed, Mar 29, 2023 at 2:52=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> Is this a patch-set of QEMU? If yes, why are the email lists all kernel m=
ail
> list without QEMU mail list?
>
> Thanks.
>
> On Wed, 29 Mar 2023 13:45:41 +0300, Andrew Melnychenko <andrew@daynix.com=
> wrote:
> > This series of patches provides the ability to retrieve eBPF program
> > through qmp, so management application may load bpf blob with proper ca=
pabilities.
> > Now, virtio-net devices can accept eBPF programs and maps through prope=
rties
> > as external file descriptors. Access to the eBPF map is direct through =
mmap()
> > call, so it should not require additional capabilities to bpf* calls.
> > eBPF file descriptors can be passed to QEMU from parent process or by u=
nix
> > socket with sendfd() qmp command.
> >
> > Overall, the basic scenario of using the helper looks like this:
> >  * Libvirt checks for ebpf_fds property.
> >  * Libvirt requests eBPF blob through QMP.
> >  * Libvirt loads blob for virtio-net.
> >  * Libvirt launches the QEMU with eBPF fds passed.
> >
> > Andrew Melnychenko (4):
> >   ebpf: Added eBPF initialization by fds and map update.
> >   virtio-net: Added property to load eBPF RSS with fds.
> >   ebpf: Added declaration/initialization routines.
> >   qmp: Added new command to retrieve eBPF blob.
> >
> >  ebpf/ebpf.c                    |  48 +++++++++++++
> >  ebpf/ebpf.h                    |  25 +++++++
> >  ebpf/ebpf_rss-stub.c           |   6 ++
> >  ebpf/ebpf_rss.c                | 124 +++++++++++++++++++++++++++------
> >  ebpf/ebpf_rss.h                |  10 +++
> >  ebpf/meson.build               |   1 +
> >  hw/net/virtio-net.c            |  77 ++++++++++++++++++--
> >  include/hw/virtio/virtio-net.h |   1 +
> >  monitor/qmp-cmds.c             |  17 +++++
> >  qapi/misc.json                 |  25 +++++++
> >  10 files changed, 307 insertions(+), 27 deletions(-)
> >  create mode 100644 ebpf/ebpf.c
> >  create mode 100644 ebpf/ebpf.h
> >
> > --
> > 2.39.1
> >
