Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12AE6C99AD
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 04:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbjC0Cq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 22:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjC0Cq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 22:46:27 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376F244B5;
        Sun, 26 Mar 2023 19:46:26 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id ek18so29960114edb.6;
        Sun, 26 Mar 2023 19:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679885184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WQh8DFlIUFAoe6CD871YIQT7zlRrIbVfDsOcaDVxO8=;
        b=cRPQntf31DinXZlVfGGDpBKfUmyiIOuBVPDWAdjL7XRw4ROKwFwpblTZuEbQn1Qqj9
         mPBwO2tySYTwo74LMixlktTXT2Av59yCzMfMmNRE0vew+g+6rwHpejYPrtl3yiOdi1NS
         Ts1CnL2Em0n8wizTS7U/FJjw+r8fZD59acCN6MAceUElYFsWXs6/Po48PcamJ4hhwZhx
         HSm7ID3AXzmF4oRq7lSDYOeKzVjie3ccUS5gzKAP7/loltCwkyxBQeMlBbxqXFItU++z
         KiNZ9ToxGTUk02hLTzaIBiVdRoXtmW5IM865K6HwCvaGe+tk2nd8LZjeQwaBFl9HU+Uj
         1xjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679885184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6WQh8DFlIUFAoe6CD871YIQT7zlRrIbVfDsOcaDVxO8=;
        b=6pNyfWJmO8b1PZf5J+YWiU0cGNX5JTkSzSvFO23X+gD9Chi02+dyEeqK6q9ykPaN+b
         5dXo0rtve8WPDE8gR5EIrbpiq/B+hz3weoD4oUuxxMAUbYaWbOmcWJpFVUfsAJR7ryAu
         lZGL7qOzAYWMZFMJyOR1Ib35Znq5P3lG/NEESOjHZL6QVo1JOvtNd3qW1QVDi+1rlslg
         FhoQRDBgWXJyy7QQhDKWT4pcQ0chiZxc2eWaU96EawsRIeW2sfz0wPzTltn/42dg0Ugr
         hmTb1+dQzaaEKzdiCZfo8shPYCe1liFZCkNdRAN3VR+srhqdjG2iHMSILpa3CdyPjznp
         IZLg==
X-Gm-Message-State: AAQBX9fUtnb2vXj0yS/I6c1bXcy558lpC07K3F6JnBlSZhEWuFbjsAUs
        OuuPhV7rjvcKgtlcaBatLAEUOaPeEp1Z+smr9qw=
X-Google-Smtp-Source: AKy350b2aU3b0D3A20UYbEPIMA+aY6RWYTOZcSWqIEmCMA0rD4Sn9M+wTMKUJlEzAA0yKXqkDVSzJrq7qqPnhai9qIs=
X-Received: by 2002:a50:ab5a:0:b0:4bb:e549:a2ad with SMTP id
 t26-20020a50ab5a000000b004bbe549a2admr5032610edc.4.1679885184546; Sun, 26 Mar
 2023 19:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230308220756.587317-1-jjh@daedalian.us> <ddbae662-96d6-8779-eb8a-5a375e97ec22@molgen.mpg.de>
 <f586237d-66be-8968-d980-f911b83d11ca@molgen.mpg.de>
In-Reply-To: <f586237d-66be-8968-d980-f911b83d11ca@molgen.mpg.de>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 27 Mar 2023 10:45:48 +0800
Message-ID: <CAL+tcoAtEnK6VFf9CD0x4h_VoeHwGhs87_MgZqdmebCcvtZvGA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net v3] ixgbe: Panic during XDP_TX with
 > 64 CPUs
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     John Hickey <jjh@daedalian.us>, Shujin Li <lishujin@kuaishou.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Jason Xing <xingwanli@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 11:50=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de=
> wrote:
>
> [Cc: Remove undeliverable <xingwanli@kuaishou.com>]

Ah, It's my previous company email. Sorry to notice this email so late.

>
> Am 26.03.23 um 17:03 schrieb Paul Menzel:
> > Dear John,
> >
> >
> > Thank you for your patch.
> >
> > I=E2=80=99d recommend, to use a statement in the git commit message/sum=
mary by
> > adding a verb (in imperative mood). Maybe:
> >
> > Fix panic during XDP_TX with > 64 CPUs
> >
> > Am 08.03.23 um 23:07 schrieb John Hickey:
> >> In commit 'ixgbe: let the xdpdrv work with more than 64 cpus'
> >> (4fe815850bdc), support was added to allow XDP programs to run on syst=
ems
> >
> > I think it=E2=80=99s more common to write it like:
> >
> > In commit 4fe815850bdc (ixgbe: let the xdpdrv work with more than 64
> > cpus) =E2=80=A6
> >
> > Even shorter
> >
> > Commit 4fe815850bdc (ixgbe: let the xdpdrv work with more than 64 cpus)
> > adds support to allow XDP programs =E2=80=A6
> >
> >> with more than 64 CPUs by locking the XDP TX rings and indexing them
> >> using cpu % 64 (IXGBE_MAX_XDP_QS).
> >>
> >> Upon trying this out patch via the Intel 5.18.6 out of tree driver
> >
> > Upon trying this patch out via =E2=80=A6
> >
> >> on a system with more than 64 cores, the kernel paniced with an
> >> array-index-out-of-bounds at the return in ixgbe_determine_xdp_ring in
> >> ixgbe.h, which means ixgbe_determine_xdp_q_idx was just returning the
> >> cpu instead of cpu % IXGBE_MAX_XDP_QS.  An example splat:
> >
> > Please add, that you have UBSAN  enabled, or does it happen without?
> >
> >>
> >>
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> >>   UBSAN: array-index-out-of-bounds in
> >>   /var/lib/dkms/ixgbe/5.18.6+focal-1/build/src/ixgbe.h:1147:26
> >>   index 65 is out of range for type 'ixgbe_ring *[64]'
> >>
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> >>   BUG: kernel NULL pointer dereference, address: 0000000000000058
> >>   #PF: supervisor read access in kernel mode
> >>   #PF: error_code(0x0000) - not-present page
> >>   PGD 0 P4D 0
> >>   Oops: 0000 [#1] SMP NOPTI
> >>   CPU: 65 PID: 408 Comm: ksoftirqd/65
> >>   Tainted: G          IOE     5.15.0-48-generic #54~20.04.1-Ubuntu
> >>   Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 2.5.4 01/13/202=
0
> >>   RIP: 0010:ixgbe_xmit_xdp_ring+0x1b/0x1c0 [ixgbe]
> >>   Code: 3b 52 d4 cf e9 42 f2 ff ff 66 0f 1f 44 00 00 0f 1f 44 00 00 55=
 b9
> >>   00 00 00 00 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 <44> 0f =
b7
> >>   47 58 0f b7 47 5a 0f b7 57 54 44 0f b7 76 08 66 41 39 c0
> >
> > If you do not it yet, `scripts/decode_stacktrace.sh` helps decoding
> > these traces.
> >
> >>   RSP: 0018:ffffbc3fcd88fcb0 EFLAGS: 00010282
> >>   RAX: ffff92a253260980 RBX: ffffbc3fe68b00a0 RCX: 0000000000000000
> >>   RDX: ffff928b5f659000 RSI: ffff928b5f659000 RDI: 0000000000000000
> >>   RBP: ffffbc3fcd88fce0 R08: ffff92b9dfc20580 R09: 0000000000000001
> >>   R10: 3d3d3d3d3d3d3d3d R11: 3d3d3d3d3d3d3d3d R12: 0000000000000000
> >>   R13: ffff928b2f0fa8c0 R14: ffff928b9be20050 R15: 000000000000003c
> >>   FS:  0000000000000000(0000) GS:ffff92b9dfc00000(0000)
> >>   knlGS:0000000000000000
> >>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>   CR2: 0000000000000058 CR3: 000000011dd6a002 CR4: 00000000007706e0
> >>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >>   PKRU: 55555554
> >>   Call Trace:
> >>    <TASK>
> >>    ixgbe_poll+0x103e/0x1280 [ixgbe]
> >>    ? sched_clock_cpu+0x12/0xe0
> >>    __napi_poll+0x30/0x160
> >>    net_rx_action+0x11c/0x270
> >>    __do_softirq+0xda/0x2ee
> >>    run_ksoftirqd+0x2f/0x50
> >>    smpboot_thread_fn+0xb7/0x150
> >>    ? sort_range+0x30/0x30
> >>    kthread+0x127/0x150
> >>    ? set_kthread_struct+0x50/0x50
> >>    ret_from_fork+0x1f/0x30
> >>    </TASK>
> >>
> >> I think this is how it happens:
> >>
> >> Upon loading the first XDP program on a system with more than 64 CPUs,
> >> ixgbe_xdp_locking_key is incremented in ixgbe_xdp_setup.  However,
> >> immediately after this, the rings are reconfigured by ixgbe_setup_tc.
> >> ixgbe_setup_tc calls ixgbe_clear_interrupt_scheme which calls
> >> ixgbe_free_q_vectors which calls ixgbe_free_q_vector in a loop.
> >> ixgbe_free_q_vector decrements ixgbe_xdp_locking_key once per call if
> >> it is non-zero.  Commenting out the decrement in ixgbe_free_q_vector
> >> stopped my system from panicing.
> >>
> >> I suspect to make the original patch work, I would need to load an XDP
> >> program and then replace it in order to get ixgbe_xdp_locking_key back
> >> above 0 since ixgbe_setup_tc is only called when transitioning between
> >> XDP and non-XDP ring configurations, while ixgbe_xdp_locking_key is
> >> incremented every time ixgbe_xdp_setup is called.
> >>
> >> Also, ixgbe_setup_tc can be called via ethtool --set-channels, so this
> >> becomes another path to decrement ixgbe_xdp_locking_key to 0 on system=
s
> >> with greater than 64 CPUs.
> >
> > =E2=80=A6 with more than 64 CPUs.
> >
> >> For this patch, I have changed static_branch_inc to static_branch_enab=
le
> >> in ixgbe_setup_xdp.  We weren't counting references.  The
> >> ixgbe_xdp_locking_key only protects code in the XDP_TX path, which is
> >> not run when an XDP program is loaded.  The other condition for settin=
g
> >> it on is the number of CPUs, which I assume is static.
> >>
> >> Fixes: 4fe815850bdc ("ixgbe: let the xdpdrv work with more than 64 cpu=
s")
> >> Signed-off-by: John Hickey <jjh@daedalian.us>
> >> ---
> >> v1 -> v2:
> >>     Added Fixes and net tag.  No code changes.
> >> v2 -> v3:
> >>     Added splat.  Slight clarification as to why ixgbe_xdp_locking_key
> >>     is not turned off.  Based on feedback from Maciej Fijalkowski.
> >> ---
> >>   drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 3 ---
> >>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
> >>   2 files changed, 1 insertion(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> >> b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> >> index f8156fe4b1dc..0ee943db3dc9 100644
> >> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> >> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> >> @@ -1035,9 +1035,6 @@ static void ixgbe_free_q_vector(struct
> >> ixgbe_adapter *adapter, int v_idx)
> >>       adapter->q_vector[v_idx] =3D NULL;
> >>       __netif_napi_del(&q_vector->napi);
> >> -    if (static_key_enabled(&ixgbe_xdp_locking_key))
> >> -        static_branch_dec(&ixgbe_xdp_locking_key);
> >> -
> >>       /*
> >>        * after a call to __netif_napi_del() napi may still be used and
> >>        * ixgbe_get_stats64() might access the rings on this vector,
> >> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> index ab8370c413f3..cd2fb72c67be 100644
> >> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> @@ -10283,7 +10283,7 @@ static int ixgbe_xdp_setup(struct net_device
> >> *dev, struct bpf_prog *prog)
> >>       if (nr_cpu_ids > IXGBE_MAX_XDP_QS * 2)
> >>           return -ENOMEM;
> >>       else if (nr_cpu_ids > IXGBE_MAX_XDP_QS)
> >> -        static_branch_inc(&ixgbe_xdp_locking_key);
> >> +        static_branch_enable(&ixgbe_xdp_locking_key);
> >>       old_prog =3D xchg(&adapter->xdp_prog, prog);
> >>       need_reset =3D (!!prog !=3D !!old_prog);
> >
> >
> > Kind regards,
> >
> > Paul
