Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07A7583CB9
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 12:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbiG1K64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 06:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236783AbiG1K6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 06:58:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50C0C63925
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659005922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LtdLR9SFwxaX+Ndoi2CgL0PTjlgHFBIkj39QECeR/t0=;
        b=WgpHyVTt0tFSa6UyFcYSkDCs7HkETTKrj4Di5/+J2UbA3jUfPkvVN5Dop24HiaFOx/McWO
        xJwwsU8xMIZH4vidEpABQmi2THKtXkpyUYwNNJ70MeXrYTpd8j3f59wjro7sF8lPntyGhb
        XTvoX5O0RWBBvueLXa8Lw8ZQOI2wyOU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-hBCRqlsIPd2Ydy_KVn5SKQ-1; Thu, 28 Jul 2022 06:58:41 -0400
X-MC-Unique: hBCRqlsIPd2Ydy_KVn5SKQ-1
Received: by mail-lj1-f197.google.com with SMTP id g3-20020a2e9cc3000000b00253cc2b5ab5so294312ljj.19
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:58:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LtdLR9SFwxaX+Ndoi2CgL0PTjlgHFBIkj39QECeR/t0=;
        b=EciVi4JgjaI6HOuqSiiDPoNp+fTP5GbTWeOJk3UwUqotOT1xfC/7RcFglAUC7/bAeT
         52WHTXPxPI/y3SI2rNMPIe4U8w3Q/7hE/J2RvieMvMBYj57na42GTq6N17GiONcZmb8W
         o8bqpwCaDPevs5jNBXR8STG/CJ39cGP4m1B10N1EkPRPqOAD7rBHyMo/BnMIt9XOd8nD
         BB7p766eYlQVE+DjT6OmI6JovKoD5uS+pMGgzRSaq3xG/trVKdNnAm846WoAkCyQu71f
         QCCoNQxI9t6Oa1zk02Gi8ndXRDVGPGQ+1d8e78Ei1A6eW424uAJFfjYPvWpAjVcO88Sk
         5jug==
X-Gm-Message-State: AJIora/FQqigZgsUDiIN5pr8bPcZ2edavNE2rb6zUObD5VzOWO0Er0VW
        28fAJlQijwE5neBsUN3NJZzCPR5269TA1OE/+4qdHzIWOydLTrEfnEHK63Oiavh5Rh2Tv7YW73o
        D6YA4/1Tj0yG3APOpuLk7CZhLumwwpw2m
X-Received: by 2002:a2e:b8d5:0:b0:25e:18ef:bb57 with SMTP id s21-20020a2eb8d5000000b0025e18efbb57mr3869330ljp.37.1659005918543;
        Thu, 28 Jul 2022 03:58:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v1ZH0wygCcvZqPsGiVOmXl0/ZqcfYUUBL4Dv3rqr0vbYdPnhl8V7kcjwG6NEg07Ve7r3UcfU4CBOvMWyxdBRQ=
X-Received: by 2002:a2e:b8d5:0:b0:25e:18ef:bb57 with SMTP id
 s21-20020a2eb8d5000000b0025e18efbb57mr3869313ljp.37.1659005918182; Thu, 28
 Jul 2022 03:58:38 -0700 (PDT)
MIME-Version: 1.0
References: <CA+QYu4qw6LecuxwAESLBvzEpj9Uv4LobX0rofDgVk_3YHjY7Fw@mail.gmail.com>
 <0051a5c0-aa9f-423e-bba3-6d5732402692@huaweicloud.com>
In-Reply-To: <0051a5c0-aa9f-423e-bba3-6d5732402692@huaweicloud.com>
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Thu, 28 Jul 2022 12:58:26 +0200
Message-ID: <CA+QYu4rTZELV40+GxPnH=Uu9dSvCEQn3jP8DAf+gYeYDQp3s5A@mail.gmail.com>
Subject: Re: [aarch64] pc : ftrace_set_filter_ip+0x24/0xa0 - lr : bpf_trampoline_update.constprop.0+0x428/0x4a0
To:     Xu Kuohai <xukuohai@huaweicloud.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 at 05:34, Xu Kuohai <xukuohai@huaweicloud.com> wrote:
>
> On 7/27/2022 6:40 PM, Bruno Goncalves wrote:
> > Hello,
> >
> > Recently we started to hit the following panic when testing the
> > net-next tree on aarch64. The first commit that we hit this is
> > "b3fce974d423".
> >
> > [   44.517109] audit: type=1334 audit(1658859870.268:59): prog-id=19 op=LOAD
> > [   44.622031] Unable to handle kernel NULL pointer dereference at
> > virtual address 0000000000000010
> > [   44.624321] Mem abort info:
> > [   44.625049]   ESR = 0x0000000096000004
> > [   44.625935]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [   44.627182]   SET = 0, FnV = 0
> > [   44.627930]   EA = 0, S1PTW = 0
> > [   44.628684]   FSC = 0x04: level 0 translation fault
> > [   44.629788] Data abort info:
> > [   44.630474]   ISV = 0, ISS = 0x00000004
> > [   44.631362]   CM = 0, WnR = 0
> > [   44.632041] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000100ab5000
> > [   44.633494] [0000000000000010] pgd=0000000000000000, p4d=0000000000000000
> > [   44.635202] Internal error: Oops: 96000004 [#1] SMP
> > [   44.636452] Modules linked in: xfs crct10dif_ce ghash_ce virtio_blk
> > virtio_console virtio_mmio qemu_fw_cfg
> > [   44.638713] CPU: 2 PID: 1 Comm: systemd Not tainted 5.19.0-rc7 #1
> > [   44.640164] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
> > [   44.641799] pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > [   44.643404] pc : ftrace_set_filter_ip+0x24/0xa0
> > [   44.644659] lr : bpf_trampoline_update.constprop.0+0x428/0x4a0
> > [   44.646118] sp : ffff80000803b9f0
> > [   44.646950] x29: ffff80000803b9f0 x28: ffff0b5d80364400 x27: ffff80000803bb48
> > [   44.648721] x26: ffff8000085ad000 x25: ffff0b5d809d2400 x24: 0000000000000000
> > [   44.650493] x23: 00000000ffffffed x22: ffff0b5dd7ea0900 x21: 0000000000000000
> > [   44.652279] x20: 0000000000000000 x19: 0000000000000000 x18: ffffffffffffffff
> > [   44.654067] x17: 0000000000000000 x16: 0000000000000000 x15: ffffffffffffffff
> > [   44.655787] x14: ffff0b5d809d2498 x13: ffff0b5d809d2432 x12: 0000000005f5e100
> > [   44.657535] x11: abcc77118461cefd x10: 000000000000005f x9 : ffffa7219cb5b190
> > [   44.659254] x8 : ffffa7219c8e0000 x7 : 0000000000000000 x6 : ffffa7219db075e0
> > [   44.661066] x5 : ffffa7219d3130e0 x4 : ffffa7219cab9da0 x3 : 0000000000000000
> > [   44.662837] x2 : 0000000000000000 x1 : ffffa7219cb7a5c0 x0 : 0000000000000000
> > [   44.664675] Call trace:
> > [   44.665274]  ftrace_set_filter_ip+0x24/0xa0
> > [   44.666327]  bpf_trampoline_update.constprop.0+0x428/0x4a0
> > [   44.667696]  __bpf_trampoline_link_prog+0xcc/0x1c0
> > [   44.668834]  bpf_trampoline_link_prog+0x40/0x64
> > [   44.669919]  bpf_tracing_prog_attach+0x120/0x490
> > [   44.671011]  link_create+0xe0/0x2b0
> > [   44.671869]  __sys_bpf+0x484/0xd30
> > [   44.672706]  __arm64_sys_bpf+0x30/0x40
> > [   44.673678]  invoke_syscall+0x78/0x100
> > [   44.674623]  el0_svc_common.constprop.0+0x4c/0xf4
> > [   44.675783]  do_el0_svc+0x38/0x4c
> > [   44.676624]  el0_svc+0x34/0x100
> > [   44.677429]  el0t_64_sync_handler+0x11c/0x150
> > [   44.678532]  el0t_64_sync+0x190/0x194
> > [   44.679439] Code: 2a0203f4 f90013f5 2a0303f5 f9001fe1 (f9400800)
> > [   44.680959] ---[ end trace 0000000000000000 ]---
> > [   44.682111] Kernel panic - not syncing: Oops: Fatal exception
> > [   44.683488] SMP: stopping secondary CPUs
> > [   44.684551] Kernel Offset: 0x2721948e0000 from 0xffff800008000000
> > [   44.686095] PHYS_OFFSET: 0xfffff4a380000000
> > [   44.687144] CPU features: 0x010,00022811,19001080
> > [   44.688308] Memory Limit: none
> > [   44.689082] ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---
> >
> > more logs:
> > https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/07/26/redhat:597047279/build_aarch64_redhat:597047279_aarch64/tests/1/results_0001/console.log/console.log
> >
> > https://datawarehouse.cki-project.org/kcidb/tests/4529120
> >
> > CKI issue tracker: https://datawarehouse.cki-project.org/issue/1434
> >
>
> Hello,
>
> It's caused by a NULL tr->fops passed to ftrace_set_filter_ip:
>
> if (tr->func.ftrace_managed) {
>          ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
>          ret = register_ftrace_direct_multi(tr->fops, (long)new_addr);
> }
>
> Could you test it with the following patch?

Thank you, the patch works well.

Bruno

>
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -255,8 +255,15 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
>                  return -ENOENT;
>
>          if (tr->func.ftrace_managed) {
> -               ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
> -               ret = register_ftrace_direct_multi(tr->fops,(long)new_addr);
> +               if (tr->fops)
> +                       ret = ftrace_set_filter_ip(tr->fops, (unsigned long)ip,
> +                                                  0, 0);
> +               else
> +                       ret = -ENOTSUPP;
> +
> +               if (!ret)
> +                       ret = register_ftrace_direct_multi(tr->fops,
> +                                                          (long)new_addr);
>          } else {
>                  ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
>          }
>
> Thanks.
>
> > Thanks,
> > Bruno Goncalves
> >
> > .
>

