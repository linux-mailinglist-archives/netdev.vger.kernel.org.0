Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7AD4F9903
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbiDHPJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiDHPJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:09:09 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663E83010AC;
        Fri,  8 Apr 2022 08:07:03 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id w134so15568298ybe.10;
        Fri, 08 Apr 2022 08:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Vy2kBZ4xA6F4IJq6Z6C2L6kcZur0GoeuReWcMvctJ4U=;
        b=BqxVSJ313KYwtJCSOcTSCg6iLeLiwDHndoKCZvKIWb8onJMKGD9Ee11kIC/JbICtd1
         4qd9Bc+fnE/y6/1BMCqQsO2oCYDKu0fzoTXUsxk6sj3BdF0MbKhy58ANttEHkhNkUcgb
         HJTNIP/xJ3/1W2Xzz01pwfNY6lkUqms97EYNpMa4d5VEUmhsAv6tUcbbxwfkmlqdV41m
         sXF6tOT1BTZ5RdTigUKl6l77RHPnLBMc7oL6TotL2X26qp3vbyPPCmm8Cjsih3V0sB2G
         XcMeHIZoLEtpadktXxZMsLKvxydX558S8At0/5fAsFBWOMqxPWfJwm8z/XYesSYXKOY8
         byFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Vy2kBZ4xA6F4IJq6Z6C2L6kcZur0GoeuReWcMvctJ4U=;
        b=ZJa6q8CEuuUiNK3FdZdY3zcIkm+jlOJaxdhqsga68Ds9EXE+u4BJEi0KGDT6XOzkbz
         8UL2JEL9OgnZ9U43D2kPSjX0YjA7yU8hd8Zw6VdY0vpm3m4SbREm8Rk7eGQAkpu8Hs13
         15ujSbsmJFvToQt+hDqDbyPEQQ02AeqU6ZVatlmhAjYsbC0Oo8gRaSwFZGCGaC7tn89/
         IAcx+T/BGyIs15km0GqJozrOPgbpn/KQ4ZbuB57yjXE32IOrojvQhUP4hi1xp6ZXATiF
         xbZ8LpuSE117HIjAlUBwLY2kG9ezfAcwhQ2uAx6Tlu3PykWwzofqd1V/aIN0SSoA0A4D
         2QaQ==
X-Gm-Message-State: AOAM533TXTHMFPkLj+wHEz5XjFIjbFJVg583tuAQjyPZAn4W4nmgFxUs
        WIJrtJhlbJm0VXVJUNjTarNjYg80oH20zrbuKwk=
X-Google-Smtp-Source: ABdhPJzb6XpEZ9QBXHrhQnNJPD+klzSY4dXhr3o2LZiFqrECtxC6QdRQsmHO82HP2ZT2GdkvE4IMUNVOCJzw0QFsDjk=
X-Received: by 2002:a25:5092:0:b0:63d:b258:8047 with SMTP id
 e140-20020a255092000000b0063db2588047mr14641886ybb.285.1649430422482; Fri, 08
 Apr 2022 08:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220401073343.277047-1-razor@blackwall.org> <20220401073343.277047-2-razor@blackwall.org>
 <c87b0c4a-ec11-22a4-af19-9bf814a2214f@6wind.com>
In-Reply-To: <c87b0c4a-ec11-22a4-af19-9bf814a2214f@6wind.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Fri, 8 Apr 2022 17:06:51 +0200
Message-ID: <CA+res+Ss4v8Y_xHyqz3HsqMNnuG71PygjxxX=RaMx8d_PquF8A@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] net: ipv4: fix route with nexthop object
 delete warning
To:     nicolas.dichtel@6wind.com
Cc:     stable <stable@vger.kernel.org>, dsahern@kernel.org,
        donaldsharp72@gmail.com, kuba@kernel.org, davem@davemloft.net,
        idosch@idosch.org, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Philippe Guibert <philippe.guibert@6wind.com>
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

Nicolas Dichtel <nicolas.dichtel@6wind.com> =E4=BA=8E2022=E5=B9=B44=E6=9C=
=888=E6=97=A5=E5=91=A8=E4=BA=94 16:47=E5=86=99=E9=81=93=EF=BC=9A
>
>
> Le 01/04/2022 =C3=A0 09:33, Nikolay Aleksandrov a =C3=A9crit :
> > FRR folks have hit a kernel warning[1] while deleting routes[2] which i=
s
> > caused by trying to delete a route pointing to a nexthop id without
> > specifying nhid but matching on an interface. That is, a route is found
> > but we hit a warning while matching it. The warning is from
> > fib_info_nh() in include/net/nexthop.h because we run it on a fib_info
> > with nexthop object. The call chain is:
> >  inet_rtm_delroute -> fib_table_delete -> fib_nh_match (called with a
> > nexthop fib_info and also with fc_oif set thus calling fib_info_nh on
> > the fib_info and triggering the warning). The fix is to not do any
> > matching in that branch if the fi has a nexthop object because those ar=
e
> > managed separately. I.e. we should match when deleting without nh spec =
and
> > should fail when deleting a nexthop route with old-style nh spec becaus=
e
> > nexthop objects are managed separately, e.g.:
> >  $ ip r show 1.2.3.4/32
> >  1.2.3.4 nhid 12 via 192.168.11.2 dev dummy0
> >
> >  $ ip r del 1.2.3.4/32
> >  $ ip r del 1.2.3.4/32 nhid 12
> >  <both should work>
> >
> >  $ ip r del 1.2.3.4/32 dev dummy0
> >  <should fail with ESRCH>
> >
> > [1]
> >  [  523.462226] ------------[ cut here ]------------
> >  [  523.462230] WARNING: CPU: 14 PID: 22893 at include/net/nexthop.h:46=
8 fib_nh_match+0x210/0x460
> >  [  523.462236] Modules linked in: dummy rpcsec_gss_krb5 xt_socket nf_s=
ocket_ipv4 nf_socket_ipv6 ip6table_raw iptable_raw bpf_preload xt_statistic=
 ip_set ip_vs_sh ip_vs_wrr ip_vs_rr ip_vs xt_mark nf_tables xt_nat veth nf_=
conntrack_netlink nfnetlink xt_addrtype br_netfilter overlay dm_crypt nfsv3=
 nfs fscache netfs vhost_net vhost vhost_iotlb tap tun xt_CHECKSUM xt_MASQU=
ERADE xt_conntrack 8021q garp mrp ipt_REJECT nf_reject_ipv4 ip6table_mangle=
 ip6table_nat iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv6=
 nf_defrag_ipv4 iptable_filter bridge stp llc rfcomm snd_seq_dummy snd_hrti=
mer rpcrdma rdma_cm iw_cm ib_cm ib_core ip6table_filter xt_comment ip6_tabl=
es vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) qrtr bnep binfmt_misc xfs vfat=
 fat squashfs loop nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvid=
ia(POE) intel_rapl_msr intel_rapl_common snd_hda_codec_realtek snd_hda_code=
c_generic ledtrig_audio snd_hda_codec_hdmi btusb btrtl iwlmvm uvcvideo btbc=
m snd_hda_intel edac_mce_amd
> >  [  523.462274]  videobuf2_vmalloc videobuf2_memops btintel snd_intel_d=
spcfg videobuf2_v4l2 snd_intel_sdw_acpi bluetooth snd_usb_audio snd_hda_cod=
ec mac80211 snd_usbmidi_lib joydev snd_hda_core videobuf2_common kvm_amd sn=
d_rawmidi snd_hwdep snd_seq videodev ccp snd_seq_device libarc4 ecdh_generi=
c mc snd_pcm kvm iwlwifi snd_timer drm_kms_helper snd cfg80211 cec soundcor=
e irqbypass rapl wmi_bmof i2c_piix4 rfkill k10temp pcspkr acpi_cpufreq nfsd=
 auth_rpcgss nfs_acl lockd grace sunrpc drm zram ip_tables crct10dif_pclmul=
 crc32_pclmul crc32c_intel ghash_clmulni_intel nvme sp5100_tco r8169 nvme_c=
ore wmi ipmi_devintf ipmi_msghandler fuse
> >  [  523.462300] CPU: 14 PID: 22893 Comm: ip Tainted: P           OE    =
 5.16.18-200.fc35.x86_64 #1
> >  [  523.462302] Hardware name: Micro-Star International Co., Ltd. MS-7C=
37/MPG X570 GAMING EDGE WIFI (MS-7C37), BIOS 1.C0 10/29/2020
> >  [  523.462303] RIP: 0010:fib_nh_match+0x210/0x460
> >  [  523.462304] Code: 7c 24 20 48 8b b5 90 00 00 00 e8 bb ee f4 ff 48 8=
b 7c 24 20 41 89 c4 e8 ee eb f4 ff 45 85 e4 0f 85 2e fe ff ff e9 4c ff ff f=
f <0f> 0b e9 17 ff ff ff 3c 0a 0f 85 61 fe ff ff 48 8b b5 98 00 00 00
> >  [  523.462306] RSP: 0018:ffffaa53d4d87928 EFLAGS: 00010286
> >  [  523.462307] RAX: 0000000000000000 RBX: ffffaa53d4d87a90 RCX: ffffaa=
53d4d87bb0
> >  [  523.462308] RDX: ffff9e3d2ee6be80 RSI: ffffaa53d4d87a90 RDI: ffffff=
ff920ed380
> >  [  523.462309] RBP: ffff9e3d2ee6be80 R08: 0000000000000064 R09: 000000=
0000000000
> >  [  523.462310] R10: 0000000000000000 R11: 0000000000000000 R12: 000000=
0000000031
> >  [  523.462310] R13: 0000000000000020 R14: 0000000000000000 R15: ffff9e=
3d331054e0
> >  [  523.462311] FS:  00007f245517c1c0(0000) GS:ffff9e492ed80000(0000) k=
nlGS:0000000000000000
> >  [  523.462313] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >  [  523.462313] CR2: 000055e5dfdd8268 CR3: 00000003ef488000 CR4: 000000=
0000350ee0
> >  [  523.462315] Call Trace:
> >  [  523.462316]  <TASK>
> >  [  523.462320]  fib_table_delete+0x1a9/0x310
> >  [  523.462323]  inet_rtm_delroute+0x93/0x110
> >  [  523.462325]  rtnetlink_rcv_msg+0x133/0x370
> >  [  523.462327]  ? _copy_to_iter+0xb5/0x6f0
> >  [  523.462330]  ? rtnl_calcit.isra.0+0x110/0x110
> >  [  523.462331]  netlink_rcv_skb+0x50/0xf0
> >  [  523.462334]  netlink_unicast+0x211/0x330
> >  [  523.462336]  netlink_sendmsg+0x23f/0x480
> >  [  523.462338]  sock_sendmsg+0x5e/0x60
> >  [  523.462340]  ____sys_sendmsg+0x22c/0x270
> >  [  523.462341]  ? import_iovec+0x17/0x20
> >  [  523.462343]  ? sendmsg_copy_msghdr+0x59/0x90
> >  [  523.462344]  ? __mod_lruvec_page_state+0x85/0x110
> >  [  523.462348]  ___sys_sendmsg+0x81/0xc0
> >  [  523.462350]  ? netlink_seq_start+0x70/0x70
> >  [  523.462352]  ? __dentry_kill+0x13a/0x180
> >  [  523.462354]  ? __fput+0xff/0x250
> >  [  523.462356]  __sys_sendmsg+0x49/0x80
> >  [  523.462358]  do_syscall_64+0x3b/0x90
> >  [  523.462361]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >  [  523.462364] RIP: 0033:0x7f24552aa337
> >  [  523.462365] Code: 0e 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0=
f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 0=
5 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
> >  [  523.462366] RSP: 002b:00007fff7f05a838 EFLAGS: 00000246 ORIG_RAX: 0=
00000000000002e
> >  [  523.462368] RAX: ffffffffffffffda RBX: 000000006245bf91 RCX: 00007f=
24552aa337
> >  [  523.462368] RDX: 0000000000000000 RSI: 00007fff7f05a8a0 RDI: 000000=
0000000003
> >  [  523.462369] RBP: 0000000000000000 R08: 0000000000000001 R09: 000000=
0000000000
> >  [  523.462370] R10: 0000000000000008 R11: 0000000000000246 R12: 000000=
0000000001
> >  [  523.462370] R13: 00007fff7f05ce08 R14: 0000000000000000 R15: 000055=
e5dfdd1040
> >  [  523.462373]  </TASK>
> >  [  523.462374] ---[ end trace ba537bc16f6bf4ed ]---
> >
> > [2] https://github.com/FRRouting/frr/issues/6412
> >
> > Fixes: 4c7e8084fd46 ("ipv4: Plumb support for nexthop object in a fib_i=
nfo")
> > Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> > Reviewed-by: David Ahern <dsahern@kernel.org>
> This patch has been applied in Linus' tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D6bf92d70e690
>
> Could it be backported to stable trees?

Normally stable maintainer will auto backport because the Fixes tag.
I tested with stable 5.10.y, it applied clean and the fix works.
>
>
> Regards,
> Nicolas
Regards!
Jinpu Wang @ IONOS Cloud.
