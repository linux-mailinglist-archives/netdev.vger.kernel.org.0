Return-Path: <netdev+bounces-11435-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89213733181
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:44:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6B51281736
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8BB107A0;
	Fri, 16 Jun 2023 12:44:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6143653;
	Fri, 16 Jun 2023 12:44:30 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2089C3C0D;
	Fri, 16 Jun 2023 05:44:00 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6667e221f75so621591b3a.1;
        Fri, 16 Jun 2023 05:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686919418; x=1689511418;
        h=content-transfer-encoding:subject:to:from:cc:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q91LMqsIB4qZ7S0jCEYhCeWPk3aMqz/NCsS9bfdEeVA=;
        b=SnL5sxTgN52fC+Ff4/GlLsnlySBEOtb0JKvoAk5NliQsPea9A+kP/OzVx8/NCezJXE
         Zu0X7eorrXaUPEimaveVmvGz4rqfDYR1wGqgX6GC5fir2K0BjbccGjO4VlUEqEqy25C6
         yteuDf0Tfvkbkds+T/wV0DhG25d38/bFmsXe1ZCF+aIiT7FAS/hlxjuL9yjPBLjBYet/
         GWMQrF5mCPpGT0HocTrzXhvPMfT+fR8ia6N51MuUZ0dD0UvSiU8B7MCd6tgxLCGIylhI
         qhyofm8o7hrRbVeKE1R/ch7YV+3e2Tt51sLj4QHyu/siZxliA3j2PJaMK7lkkUdx5OW2
         wz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686919418; x=1689511418;
        h=content-transfer-encoding:subject:to:from:cc:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q91LMqsIB4qZ7S0jCEYhCeWPk3aMqz/NCsS9bfdEeVA=;
        b=QC79I2zRSPK+g5TE8rUB7KespmviXRg/hHoxfAF59A3y3P66E1tF9RztuzZLKlnxJu
         G26taPNxDIvlQy8EkEBCYM3U1bEmJmstCQMJ57svga8fPopEspl7j2x2O6cQWTuj5bby
         pkiiD5/Hi1gfgYlkSMV7XQNJG6/Njn5VrHw1fmvUszEp1LFBHoBdkKWcRQ0khIdn2PbC
         uIIX4ybqx3UG88qVWT4Da5Dn5kfIjeRGzB+lNX0mck2WUKSwhLztl9Aewvv5UVL2mBGQ
         Uezaa7Ld9BwA8/SKAVOUobCDOnFWW4c/5ljZnLRFq6+fEOYgyMf6FNEF2IW32WarEPDY
         lmuQ==
X-Gm-Message-State: AC+VfDwxN95wjqkWLt3N6bi3xvDluR90QEBvihCIcX88UUpFcpdlI64z
	cGYRM6GYDFICHY0OYVCz1NZwRRSvG/M=
X-Google-Smtp-Source: ACHHUZ57UHsO8YY+elbXrosr7QOXUSA8JFKnQxpae1jI/U0kXI5msWQwNR926vSwgmW+bselvP6Caw==
X-Received: by 2002:a17:90b:1803:b0:258:842e:e23b with SMTP id lw3-20020a17090b180300b00258842ee23bmr1402157pjb.34.1686919418426;
        Fri, 16 Jun 2023 05:43:38 -0700 (PDT)
Received: from [192.168.0.103] ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090a2ac900b002591f7ff90csm1378200pjg.43.2023.06.16.05.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 05:43:38 -0700 (PDT)
Message-ID: <8bfaee54-3117-65d3-d723-6408edf93961@gmail.com>
Date: Fri, 16 Jun 2023 19:43:19 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
Cc: Linux Networking <netdev@vger.kernel.org>, Linux BPF
 <bpf@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Regressions <regressions@lists.linux.dev>
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, David Ahern
 <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Fwd: inet6_sock_destruct->inet_sock_destruct trigger Call Trace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I notice a regression report on Bugzilla [1]. Quoting from it:

> When the IPv6 address or NIC configuration changes, the following kerne=
l warnings may be triggered:
>=20
> Thu Jun 15 09:02:31 2023 daemon.info : 09[KNL] interface utun deleted
> Thu Jun 15 09:02:31 2023 daemon.info : 13[KNL] interface utun deleted
> Thu Jun 15 09:02:32 2023 daemon.notice procd: /etc/rc.d/S99zerotier: di=
sabled in config
> Thu Jun 15 09:02:33 2023 daemon.info procd: - init complete -
> Thu Jun 15 09:02:45 2023 daemon.info : 09[KNL] interface utun deleted
> Thu Jun 15 09:02:45 2023 daemon.info : 15[KNL] interface utun deleted
> Thu Jun 15 09:02:48 2023 user.notice firewall: Reloading firewall due t=
o ifup of lan6 (br-switch)
> Thu Jun 15 09:02:51 2023 daemon.err uhttpd[2929]: cat: can't open '/tmp=
/cpu.usage': No such file or directory
> Thu Jun 15 09:03:03 2023 user.notice firewall: Reloading firewall due t=
o ifup of wg (wg)
> Thu Jun 15 09:03:03 2023 daemon.info : 13[KNL] interface tunh activated=

> Thu Jun 15 09:03:03 2023 daemon.info : 16[KNL] fe80::5efe:c0a8:7df9 app=
eared on tunh
> Thu Jun 15 09:03:03 2023 daemon.info : 08[KNL] 10.10.13.1 appeared on t=
unh
> Thu Jun 15 09:03:03 2023 daemon.info : 13[KNL] interface utun deleted
> Thu Jun 15 09:03:03 2023 daemon.info : 05[KNL] interface utun deleted
> Thu Jun 15 09:03:04 2023 auth.err passwd: password for root changed by =
root
> Thu Jun 15 09:03:17 2023 daemon.err uhttpd[2929]: sh: /etc/init.d/tasks=
: line 7: extra_command: not found
> Thu Jun 15 09:03:17 2023 daemon.err uhttpd[2929]: sh: /etc/init.d/tasks=
: line 8: extra_command: not found
> Thu Jun 15 09:03:17 2023 daemon.err uhttpd[2929]: sh: /etc/init.d/tasks=
: line 9: extra_command: not found
> Thu Jun 15 09:03:17 2023 daemon.err uhttpd[2929]: sh: /etc/init.d/tasks=
: line 10: extra_command: not found
> Thu Jun 15 09:03:17 2023 daemon.err uhttpd[2929]: sh: /etc/init.d/tasks=
: line 11: extra_command: not found
> Thu Jun 15 09:03:23 2023 daemon.err uhttpd[2929]: sh: /etc/init.d/tasks=
: line 7: extra_command: not found
> Thu Jun 15 09:03:23 2023 daemon.err uhttpd[2929]: sh: /etc/init.d/tasks=
: line 8: extra_command: not found
> Thu Jun 15 09:03:23 2023 daemon.err uhttpd[2929]: sh: /etc/init.d/tasks=
: line 9: extra_command: not found
> Thu Jun 15 09:03:23 2023 daemon.err uhttpd[2929]: sh: /etc/init.d/tasks=
: line 10: extra_command: not found
> Thu Jun 15 09:03:23 2023 daemon.err uhttpd[2929]: sh: /etc/init.d/tasks=
: line 11: extra_command: not found
> Thu Jun 15 09:03:35 2023 daemon.err uhttpd[2929]: Error: The backup GPT=
 table is corrupt, but the primary appears OK, so that will be used.
> Thu Jun 15 09:03:35 2023 daemon.err uhttpd[2929]: Warning: Not all of t=
he space available to /dev/sda appears to be used, you can fix the GPT to=
 use all of the space (an extra 6111 blocks) or continue with the current=
 setting?
> Thu Jun 15 09:03:59 2023 daemon.info acpid: starting up with netlink an=
d the input layer
> Thu Jun 15 09:03:59 2023 daemon.info acpid: 1 rule loaded
> Thu Jun 15 09:03:59 2023 daemon.info acpid: waiting for events: event l=
ogging is off
> Thu Jun 15 09:11:16 2023 daemon.err uhttpd[2929]: getopt: unrecognized =
option: no-validate
> Thu Jun 15 10:06:07 2023 daemon.err uhttpd[2929]: getopt: unrecognized =
option: no-validate
> Thu Jun 15 10:09:27 2023 daemon.info : 09[KNL] interface utun deleted
> Thu Jun 15 10:09:27 2023 daemon.info : 13[KNL] interface utun deleted
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.437330] ------------[=
 cut here ]------------
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.439948] WARNING: CPU:=
 1 PID: 19 at inet_sock_destruct+0x190/0x1c0
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.440967] Modules linke=
d in: pppoe ppp_async l2tp_ppp i915 wireguard video sch_fq_pie pppox ppp_=
mppe ppp_generic mt7921u mt7921s mt7921e mt7921_common mt7915e mt76x2u mt=
76x2e mt76x2_common mt76x02_usb mt76x02_lib mt76_usb mt76_sdio mt76_conna=
c_lib mt76 mac80211 libchacha20poly1305 ipt_REJECT curve25519_x86_64 chac=
ha_x86_64 cfg80211 ax88179_178a zstd xt_time xt_tcpudp xt_tcpmss xt_strin=
g xt_statistic xt_state xt_socket xt_recent xt_quota xt_policy xt_pkttype=
 xt_owner xt_nat xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprang=
e xt_hl xt_helper xt_hashlimit xt_esp xt_ecn xt_dscp xt_conntrack xt_conn=
mark xt_connlimit xt_connbytes xt_comment xt_cgroup xt_bpf xt_addrtype xt=
_TPROXY xt_TCPMSS xt_REDIRECT xt_MASQUERADE xt_LOG xt_IPMARK xt_HL xt_FLO=
WOFFLOAD xt_DSCP xt_CT xt_CLASSIFY wmi via_velocity usbnet ums_usbat ums_=
sddr55 ums_sddr09 ums_karma ums_jumpshot ums_isd200 ums_freecom ums_dataf=
ab ums_cypress ums_alauda tulip ts_fsm ts_bm tcp_bbr slhc sch_pie sch_cak=
e rtl8150 r8168 r8152 r8125
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.441064]  poly1305_x86=
_64 pcnet32 nf_tproxy_ipv6 nf_tproxy_ipv4 nf_socket_ipv6 nf_socket_ipv4 n=
f_reject_ipv4 nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat=
_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda nf_log_syslog nf_flow_table nf_=
conntrack_tftp nf_conntrack_snmp nf_conntrack_sip nf_conntrack_pptp nf_co=
nntrack_netlink nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp nf_co=
nntrack_broadcast ts_kmp nf_conntrack_amanda nf_conncount mlx5_core mlx4_=
en mlx4_core mdev macvlan lzo_rle lzo libcurve25519_generic libchacha kvm=
_intel kvm ipvlan iptable_raw iptable_nat iptable_mangle iptable_filter i=
pt_ah ipt_ECN ip_tables iommu_v2 igc iavf i40e forcedeth e1000e drm_displ=
ay_helper drm_buddy crc_ccitt compat_xtables compat cls_flower br_netfilt=
er bnx2x bnx2 alx act_vlan 8139too 8139cp ntfs3 cls_bpf act_bpf sch_tbf s=
ch_ingress sch_htb sch_hfsc em_u32 cls_u32 cls_route cls_matchall cls_fw =
cls_flow cls_basic act_skbedit act_mirred act_gact configs sg evdev i2c_d=
ev cryptodev xt_set
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.453861]  ip_set_list_=
set ip_set_hash_netportnet ip_set_hash_netport ip_set_hash_netnet ip_set_=
hash_netiface ip_set_hash_net ip_set_hash_mac ip_set_hash_ipportnet ip_se=
t_hash_ipportip ip_set_hash_ipport ip_set_hash_ipmark ip_set_hash_ipmac i=
p_set_hash_ip ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip ip_=
set st ip6table_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6=
t_NPT ip6table_mangle ip6table_filter ip6_tables ip6t_REJECT x_tables nf_=
reject_ipv6 nfsv4 nfsd nfs bonding ip_gre gre ixgbe igbvf e1000 amd_xgbe =
mdio_devres dummy sit mdio l2tp_netlink l2tp_core udp_tunnel ip6_udp_tunn=
el ipcomp6 xfrm6_tunnel esp6 ah6 xfrm4_tunnel ipcomp esp4 ah4 ipip tunnel=
6 tunnel4 ip_tunnel udp_diag tcp_diag raw_diag inet_diag rpcsec_gss_krb5 =
auth_rpcgss veth tun nbd xfrm_user xfrm_ipcomp af_key xfrm_algo virtiofs =
fuse lockd sunrpc grace hfs cifs oid_registry cifs_md4 cifs_arc4 asn1_dec=
oder dns_resolver md_mod nls_utf8 nls_cp950 nls_cp936 ena shortcut_fe_ipv=
6 shortcut_fe crypto_user
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.462923]  algif_skciph=
er algif_rng algif_hash algif_aead af_alg sha512_ssse3 sha512_generic sha=
1_ssse3 sha1_generic seqiv jitterentropy_rng drbg md5 hmac echainiv des_g=
eneric libdes deflate cts cmac authencesn authenc arc4 crypto_acompress n=
ls_iso8859_1 nls_cp437 uas sdhci_pltfm xhci_plat_hcd fsl_mph_dr_of ehci_p=
latform ehci_fsl igb vfat fat exfat btrfs zstd_decompress zstd_compress z=
std_common xxhash xor raid6_pq lzo_decompress lzo_compress dm_mirror dm_r=
egion_hash dm_log dm_crypt dm_mod dax button_hotplug mii libphy tpm cbc s=
ha256_ssse3 sha256_generic libsha256 encrypted_keys trusted
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.472554] CPU: 1 PID: 1=
9 Comm: ksoftirqd/1 Not tainted 6.1.34 #0
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.473025] Hardware name=
: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.1-0-g3208b098f51a-pr=
ebuilt.qemu.org 04/01/2014
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.473731] RIP: 0010:ine=
t_sock_destruct+0x190/0x1c0
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.474204] Code: bc 24 4=
0 01 00 00 e8 af 0d f0 ff 49 8b bc 24 88 00 00 00 e8 a2 0d f0 ff 5b 41 5c=
 5d c3 4c 89 e7 e8 e5 7e ed ff e9 70 ff ff ff <0f> 0b eb c3 0f 0b 41 8b 8=
4 24 54 01 00 00 85 c0 74 9d 0f 0b 41 8b
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.475522] RSP: 0018:fff=
fc900000afda8 EFLAGS: 00010206
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.475947] RAX: 00000000=
00000e00 RBX: ffff888015c9b040 RCX: 0000000000000007
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.476450] RDX: 00000000=
00000000 RSI: 0000000000000e00 RDI: ffff888015c9b040
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.476966] RBP: ffffc900=
000afdb8 R08: ffff88800aba5900 R09: 000000008020001a
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.477588] R10: 00000000=
40000000 R11: 0000000000000000 R12: ffff888015c9af80
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.478326] R13: ffff8880=
02931540 R14: ffffc900000afe28 R15: ffff88807dd253f8
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.478872] FS:  00000000=
00000000(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.479434] CS:  0010 DS:=
 0000 ES: 0000 CR0: 0000000080050033
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.479886] CR2: 00007f11=
fc4cd0a0 CR3: 0000000021cbe004 CR4: 0000000000370ee0
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.480533] Call Trace:
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.480851]  <TASK>
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.481169]  ? show_regs.=
part.0+0x1e/0x20
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.481631]  ? show_regs.=
cold+0x8/0xd
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.482248]  ? __warn+0x6=
e/0xc0
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.483300]  ? inet_sock_=
destruct+0x190/0x1c0
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.484240]  ? report_bug=
+0xed/0x140
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.484937]  ? handle_bug=
+0x46/0x80
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.485448]  ? exc_invali=
d_op+0x19/0x70
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.485963]  ? asm_exc_in=
valid_op+0x1b/0x20
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.486360]  ? inet_sock_=
destruct+0x190/0x1c0
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.486888]  inet6_sock_d=
estruct+0x16/0x20
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.487289]  __sk_destruc=
t+0x23/0x180
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.487638]  rcu_core+0x2=
8f/0x690
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.487964]  rcu_core_si+=
0x9/0x10
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.488285]  __do_softirq=
+0xbd/0x1e8
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.488973]  run_ksoftirq=
d+0x24/0x40
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.489370]  smpboot_thre=
ad_fn+0xdb/0x1d0
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.489826]  kthread+0xde=
/0x110
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.490572]  ? sort_range=
+0x20/0x20
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.491356]  ? kthread_co=
mplete_and_exit+0x20/0x20
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.491839]  ret_from_for=
k+0x1f/0x30
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.492195]  </TASK>
> Thu Jun 15 10:09:28 2023 kern.warn kernel: [ 4071.492448] ---[ end trac=
e 0000000000000000 ]---

Later, the reporter revealed his setup:

> This is an openwrt gateway device on x86_64 platform. I'm not sure the =
exact version number that came up, it seems like 6.1.27 was not encounter=
ed before. I have encountered it since kernel 6.1.32, but it is also from=
 this version that I have relatively large IPv6 udp traffic, conntrack -L=
|grep -c udp shows that the number is between 600 - 2000.

See Bugzilla for the full thread and attached log.

Anyway, I'm adding it to regzbot:

#regzbot introduced: v6.1.27..v6.1.32 https://bugzilla.kernel.org/show_bu=
g.cgi?id=3D217555
#regzbot title: kernel warning (oops) at inet_sock_destruct

Thanks.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=3D217555
--=20
An old man doll... just what I always wanted! - Clara

