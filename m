Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05584EDF7D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 19:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiCaRTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 13:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiCaRTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 13:19:10 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DC01B79A
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 10:17:21 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n63-20020a1c2742000000b0038d0c31db6eso53605wmn.1
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 10:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=yp3Z/fJ/2D5TuY1CDcatqt8zApVU5YKqP274msIzkuw=;
        b=4HAACwRS5mbHPk0BA6Vi1dhwe5CycNQ3JS7CQM9fQD9xjWktuX8DQiMVtS1+lOwEco
         2ZTp0k3wG9+8KpG9PNEB7XK82TLMPi27xxHrSTg7lEUsF6JG9bzbECF8lAUQDDnIgF1D
         i25YTqsXbIjf+g65DUDhROPz5AfCnp7AcK8Jw2jk9atph2Vnl/VHCp3yWZfnw272r1X2
         ng9564YN9wIGU4a2Zuq+1NUY2utC8RKNnkKKhDuPLJPs1CNXdLfcHyLVrM1PzOk40IeB
         NCFdMlUHSByBwXC+SyjcwAxL8Oni+E88FXA8oClQnmIw0iM9BJJBo4CXofxVlmrso9nN
         DJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=yp3Z/fJ/2D5TuY1CDcatqt8zApVU5YKqP274msIzkuw=;
        b=YsrX+wJmn0g6c1raydmHTHUzWxCSLhJdQmtkAY1l1iCeskAA6+sa6vjyxx0FOWnn5T
         WYjcKMKplq4XaIz0V2OyFaTBrQgliWkkhA2XStWfyhUE3+GnXZs46HSZfMHfUqcPVyUI
         pj395DGKhCLPplzkgrCQMkFi0VWrnFvB2tX9phk/IOtEOqvrHPOGDYRI4y9xiM39i5Xj
         KSdb/wU4kpdpajUU4P/n2wKoe8d5xYYFqk6r5GbNLfZqpyNetxIYKbpDUGospVIItiZC
         GuvzWfj/zDI1PM0HnWiNB5sGHmCZoUbLybYA7MMRyfCmOg6RFpKrSlsEAycHjruFAmqH
         Icow==
X-Gm-Message-State: AOAM531aaU1fmHnmPjS8FQu9F2tRDA47RV60Y6++ZLUcZatHhd6iPqiR
        2V1VXhESdHGKi94u9GpTKPCU3w==
X-Google-Smtp-Source: ABdhPJwtE8aTwpv3IuRTMUqVGfmJBlCHS+6/0R5NGpcDoVjyNN/xOjItgu8Hj2o5Rz9pBzpNoMlPYA==
X-Received: by 2002:a05:600c:1d0e:b0:38c:e1d3:9317 with SMTP id l14-20020a05600c1d0e00b0038ce1d39317mr5523135wms.200.1648747040069;
        Thu, 31 Mar 2022 10:17:20 -0700 (PDT)
Received: from [127.0.0.1] ([93.123.70.11])
        by smtp.gmail.com with ESMTPSA id l20-20020a05600c1d1400b0038cba2f88c0sm10930234wms.26.2022.03.31.10.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 10:17:19 -0700 (PDT)
Date:   Thu, 31 Mar 2022 20:17:14 +0300
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
CC:     donaldsharp72@gmail.com, philippe.guibert@outlook.com,
        kuba@kernel.org, davem@davemloft.net, idosch@idosch.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net_1/2=5D_net=3A_ipv4=3A_fix_ro?= =?US-ASCII?Q?ute_with_nexthop_object_delete_warning?=
User-Agent: K-9 Mail for Android
In-Reply-To: <46d8d642-4c25-20e9-0805-4e4727a232b1@kernel.org>
References: <20220331154615.108214-1-razor@blackwall.org> <20220331154615.108214-2-razor@blackwall.org> <46d8d642-4c25-20e9-0805-4e4727a232b1@kernel.org>
Message-ID: <CF021BA4-036B-40FC-ADBB-F7C66D57348A@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31 March 2022 20:05:43 EEST, David Ahern <dsahern@kernel=2Eorg> wrote:
>On 3/31/22 9:46 AM, Nikolay Aleksandrov wrote:
>> FRR folks have hit a kernel warning[1] while deleting routes[2] which i=
s
>> caused by trying to delete a route pointing to a nexthop id without
>> specifying nhid but matching on an interface=2E That is, a route is fou=
nd
>> but we hit a warning while matching it=2E The warning is from
>> fib_info_nh() in include/net/nexthop=2Eh because we run it on a fib_inf=
o
>> with nexthop object=2E The call chain is:
>>  inet_rtm_delroute -> fib_table_delete -> fib_nh_match (called with a
>> nexthop fib_info and also with fc_oif set thus calling fib_info_nh on
>> the fib_info and triggering the warning)=2E The fix is to not do any
>> matching in that branch if the fi has a nexthop object because those ar=
e
>> managed separately=2E
>>=20
>> [1]
>>  [  523=2E462226] ------------[ cut here ]------------
>>  [  523=2E462230] WARNING: CPU: 14 PID: 22893 at include/net/nexthop=2E=
h:468 fib_nh_match+0x210/0x460
>>  [  523=2E462236] Modules linked in: dummy rpcsec_gss_krb5 xt_socket nf=
_socket_ipv4 nf_socket_ipv6 ip6table_raw iptable_raw bpf_preload xt_statist=
ic ip_set ip_vs_sh ip_vs_wrr ip_vs_rr ip_vs xt_mark nf_tables xt_nat veth n=
f_conntrack_netlink nfnetlink xt_addrtype br_netfilter overlay dm_crypt nfs=
v3 nfs fscache netfs vhost_net vhost vhost_iotlb tap tun xt_CHECKSUM xt_MAS=
QUERADE xt_conntrack 8021q garp mrp ipt_REJECT nf_reject_ipv4 ip6table_mang=
le ip6table_nat iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ip=
v6 nf_defrag_ipv4 iptable_filter bridge stp llc rfcomm snd_seq_dummy snd_hr=
timer rpcrdma rdma_cm iw_cm ib_cm ib_core ip6table_filter xt_comment ip6_ta=
bles vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) qrtr bnep binfmt_misc xfs vf=
at fat squashfs loop nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nv=
idia(POE) intel_rapl_msr intel_rapl_common snd_hda_codec_realtek snd_hda_co=
dec_generic ledtrig_audio snd_hda_codec_hdmi btusb btrtl iwlmvm uvcvideo bt=
bcm snd_hda_intel edac_mce_amd
>>  [  523=2E462274]  videobuf2_vmalloc videobuf2_memops btintel snd_intel=
_dspcfg videobuf2_v4l2 snd_intel_sdw_acpi bluetooth snd_usb_audio snd_hda_c=
odec mac80211 snd_usbmidi_lib joydev snd_hda_core videobuf2_common kvm_amd =
snd_rawmidi snd_hwdep snd_seq videodev ccp snd_seq_device libarc4 ecdh_gene=
ric mc snd_pcm kvm iwlwifi snd_timer drm_kms_helper snd cfg80211 cec soundc=
ore irqbypass rapl wmi_bmof i2c_piix4 rfkill k10temp pcspkr acpi_cpufreq nf=
sd auth_rpcgss nfs_acl lockd grace sunrpc drm zram ip_tables crct10dif_pclm=
ul crc32_pclmul crc32c_intel ghash_clmulni_intel nvme sp5100_tco r8169 nvme=
_core wmi ipmi_devintf ipmi_msghandler fuse
>>  [  523=2E462300] CPU: 14 PID: 22893 Comm: ip Tainted: P           OE  =
   5=2E16=2E18-200=2Efc35=2Ex86_64 #1
>>  [  523=2E462302] Hardware name: Micro-Star International Co=2E, Ltd=2E=
 MS-7C37/MPG X570 GAMING EDGE WIFI (MS-7C37), BIOS 1=2EC0 10/29/2020
>>  [  523=2E462303] RIP: 0010:fib_nh_match+0x210/0x460
>>  [  523=2E462304] Code: 7c 24 20 48 8b b5 90 00 00 00 e8 bb ee f4 ff 48=
 8b 7c 24 20 41 89 c4 e8 ee eb f4 ff 45 85 e4 0f 85 2e fe ff ff e9 4c ff ff=
 ff <0f> 0b e9 17 ff ff ff 3c 0a 0f 85 61 fe ff ff 48 8b b5 98 00 00 00
>>  [  523=2E462306] RSP: 0018:ffffaa53d4d87928 EFLAGS: 00010286
>>  [  523=2E462307] RAX: 0000000000000000 RBX: ffffaa53d4d87a90 RCX: ffff=
aa53d4d87bb0
>>  [  523=2E462308] RDX: ffff9e3d2ee6be80 RSI: ffffaa53d4d87a90 RDI: ffff=
ffff920ed380
>>  [  523=2E462309] RBP: ffff9e3d2ee6be80 R08: 0000000000000064 R09: 0000=
000000000000
>>  [  523=2E462310] R10: 0000000000000000 R11: 0000000000000000 R12: 0000=
000000000031
>>  [  523=2E462310] R13: 0000000000000020 R14: 0000000000000000 R15: ffff=
9e3d331054e0
>>  [  523=2E462311] FS:  00007f245517c1c0(0000) GS:ffff9e492ed80000(0000)=
 knlGS:0000000000000000
>>  [  523=2E462313] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>  [  523=2E462313] CR2: 000055e5dfdd8268 CR3: 00000003ef488000 CR4: 0000=
000000350ee0
>>  [  523=2E462315] Call Trace:
>>  [  523=2E462316]  <TASK>
>>  [  523=2E462320]  fib_table_delete+0x1a9/0x310
>>  [  523=2E462323]  inet_rtm_delroute+0x93/0x110
>>  [  523=2E462325]  rtnetlink_rcv_msg+0x133/0x370
>>  [  523=2E462327]  ? _copy_to_iter+0xb5/0x6f0
>>  [  523=2E462330]  ? rtnl_calcit=2Eisra=2E0+0x110/0x110
>>  [  523=2E462331]  netlink_rcv_skb+0x50/0xf0
>>  [  523=2E462334]  netlink_unicast+0x211/0x330
>>  [  523=2E462336]  netlink_sendmsg+0x23f/0x480
>>  [  523=2E462338]  sock_sendmsg+0x5e/0x60
>>  [  523=2E462340]  ____sys_sendmsg+0x22c/0x270
>>  [  523=2E462341]  ? import_iovec+0x17/0x20
>>  [  523=2E462343]  ? sendmsg_copy_msghdr+0x59/0x90
>>  [  523=2E462344]  ? __mod_lruvec_page_state+0x85/0x110
>>  [  523=2E462348]  ___sys_sendmsg+0x81/0xc0
>>  [  523=2E462350]  ? netlink_seq_start+0x70/0x70
>>  [  523=2E462352]  ? __dentry_kill+0x13a/0x180
>>  [  523=2E462354]  ? __fput+0xff/0x250
>>  [  523=2E462356]  __sys_sendmsg+0x49/0x80
>>  [  523=2E462358]  do_syscall_64+0x3b/0x90
>>  [  523=2E462361]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>  [  523=2E462364] RIP: 0033:0x7f24552aa337
>>  [  523=2E462365] Code: 0e 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9=
 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f=
 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
>>  [  523=2E462366] RSP: 002b:00007fff7f05a838 EFLAGS: 00000246 ORIG_RAX:=
 000000000000002e
>>  [  523=2E462368] RAX: ffffffffffffffda RBX: 000000006245bf91 RCX: 0000=
7f24552aa337
>>  [  523=2E462368] RDX: 0000000000000000 RSI: 00007fff7f05a8a0 RDI: 0000=
000000000003
>>  [  523=2E462369] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000=
000000000000
>>  [  523=2E462370] R10: 0000000000000008 R11: 0000000000000246 R12: 0000=
000000000001
>>  [  523=2E462370] R13: 00007fff7f05ce08 R14: 0000000000000000 R15: 0000=
55e5dfdd1040
>>  [  523=2E462373]  </TASK>
>>  [  523=2E462374] ---[ end trace ba537bc16f6bf4ed ]---
>>=20
>> [2] https://github=2Ecom/FRRouting/frr/issues/6412
>>=20
>> Fixes: 4c7e8084fd46 ("ipv4: Plumb support for nexthop object in a fib_i=
nfo")
>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall=2Eorg>
>> ---
>>  net/ipv4/fib_semantics=2Ec | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/net/ipv4/fib_semantics=2Ec b/net/ipv4/fib_semantics=2Ec
>> index cc8e84ef2ae4=2E=2Eccb62038f6a4 100644
>> --- a/net/ipv4/fib_semantics=2Ec
>> +++ b/net/ipv4/fib_semantics=2Ec
>> @@ -889,8 +889,13 @@ int fib_nh_match(struct net *net, struct fib_confi=
g *cfg, struct fib_info *fi,
>>  	}
>> =20
>>  	if (cfg->fc_oif || cfg->fc_gw_family) {
>> -		struct fib_nh *nh =3D fib_info_nh(fi, 0);
>> +		struct fib_nh *nh;
>> +
>> +		/* cannot match on nexthop object attributes */
>> +		if (fi->nh)
>> +			return 1;
>> =20
>> +		nh =3D fib_info_nh(fi, 0);
>>  		if (cfg->fc_encap) {
>>  			if (fib_encap_match(net, cfg->fc_encap_type,
>>  					    cfg->fc_encap, nh, cfg, extack))
>
>I think the right fix is something like this:
>diff --git a/net/ipv4/fib_semantics=2Ec b/net/ipv4/fib_semantics=2Ec
>index cc8e84ef2ae4=2E=2Ec70775f5e155 100644
>--- a/net/ipv4/fib_semantics=2Ec
>+++ b/net/ipv4/fib_semantics=2Ec
>@@ -886,6 +886,8 @@ int fib_nh_match(struct net *net, struct fib_config
>*cfg, struct fib_info *fi,
>                if (fi->nh && cfg->fc_nh_id =3D=3D fi->nh->id)
>                        return 0;
>                return 1;
>+       } else if (fi->nh) {
>+               return 1;
>        }
>
>ie=2E, if the cfg has a nexthop id it needs to match fib_info=2E
>if the cfg does not have a nexthop id, but fib_info does then it is not
>a match


Right, that is also correct and I was tempted to cut it all short in that =
case
 but seemed riskier so I went with the more narrow fix for that specific c=
ase=2E
Anyway, I'll respin with that change=2E

Cheers,
 Nik

