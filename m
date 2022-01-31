Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531DF4A4EC6
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357629AbiAaSqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:46:36 -0500
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:23874
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1357767AbiAaSqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:46:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyyLc4LQy9KHhX6kVyU0HlSeYULBzrN7FN6Hv4y45Lf8srRY4KVuPbjtuHjxojhD/1TlGeqDnQ+Y/VvBLHBDLgX8lnpLZHn3DsKlOlksTJnUa7WZR3gXuaVQyn1SmQC23kSOsKtMtNPGVGTYIFaOZ87MLk9m7/c/UHuocFRAvk4hS1+wLT89Uu+68YgE4SI4AUVXCPfHOYtZMCx8stbzMcPbQRPuS9DI2FmKKLk10/qxNRCdDHJc72vanI1T/R76Squi6fGHjKvHQCS7b8/xQb3ypV/vldbjQK0u+e6illkOs4C79jjFkqPw+ls4xQ3TCXgbsGSeU0UZhO64bnZwEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbY3OxzKGGi1iPWTWO+GR4wXv/uJCDVpt8bDZQKQb0M=;
 b=lSB6rCQl4C2HYA/OQSkPE4vYwXoNrx64pTL+Z5pZOVU1Ne/JmY/IFAK0HLkaJ6qEcm57uoI/BR5Rj+8xdksV6DqKhld0b0wGfZCmaOk5J9TswEd/fw6GzI3sqeF0I7/ljB+Tlb1QCGxiFT6CtOoquUYLsZg17jYXLuRujwRdJRpPE8SRUrXclCS54CaUOIt481nqlBILDneAa5FmaAoWxyG4InHtDzqEcDKZhYlMuJE7SOe6eNawKQbXWohA5DjtkUWIPDr3WJ5KPv/RKhT038riTStrAKS3En83kDZvJPTBe3dwxHjcPRbntQ8Ujbf923mbqhu4cbW3jqmNZIIU7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.72) smtp.rcpttodomain=kernel.org smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbY3OxzKGGi1iPWTWO+GR4wXv/uJCDVpt8bDZQKQb0M=;
 b=qkoVJ9FKpAHFh8Hrv6q4QX+EfkksFBImcRSu3U3VpvC+ZjdUMLJPSuGXZVYpzhclRaWvZAjAXJCNRZisaHi5G1btU9FwvN27wBeMq0ujGnB6YInv0NG+jS+KUj0CcfG3MjKThfGFeotuRloMgM/JLULcw2GBr3+mS5KwlQDqtZ85Td9gsMvS3cggE+63T5Nqg/2MoZtY0zImjb02iDnbC+YqRRzXvtEoQy4kIF0nfVVGa4QqkwJLIjGqjhBrOkzRRMGizZwZ6/itQZnCxLRJX9QdWiTNKHDxaQ2DXXahzoJOp4su73URXvPMv3S0K5aHY4fRNuWpfkNjD/k+qWLaCg==
Received: from AM6P193CA0111.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::16)
 by DB8PR10MB2841.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:b0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 18:46:18 +0000
Received: from VE1EUR01FT006.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:209:85:cafe::d) by AM6P193CA0111.outlook.office365.com
 (2603:10a6:209:85::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Mon, 31 Jan 2022 18:46:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.72)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.72 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.72; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.72) by
 VE1EUR01FT006.mail.protection.outlook.com (10.152.2.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 18:46:18 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SMA.ad011.siemens.net (194.138.21.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Mon, 31 Jan 2022 19:46:17 +0100
Received: from [167.87.32.84] (167.87.32.84) by DEMCHDC8A0A.ad011.siemens.net
 (139.25.226.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 31 Jan
 2022 19:46:16 +0100
Message-ID: <406b7ca2-e6c3-f38b-90b7-d586894b86d1@siemens.com>
Date:   Mon, 31 Jan 2022 19:46:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Georgi Valkov <gvalkov@abv.bg>,
        Greg KH <gregkh@linuxfoundation.org>, <davem@davemloft.net>,
        <mhabets@solarflare.com>, <luc.vanoostenryck@gmail.com>,
        <snelson@pensando.io>, <mst@redhat.com>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <corsac@corsac.net>,
        <matti.vuorela@bitfactor.fi>, <stable@vger.kernel.org>
References: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
 <20210720122215.54abaf53@cakuba>
 <5D0CFF83-439B-4A10-A276-D2D17B037704@abv.bg> <YPa4ZelG2k8Z826E@kroah.com>
 <C6AA954F-8382-461D-835F-E5CA03363D84@abv.bg> <YPbHoScEo8ZJyox6@kroah.com>
 <AEC79E3B-FA7F-4A36-95CE-B6D0F3063DF8@abv.bg>
 <80a13e9b-e026-1238-39ed-32deb5ff17b0@siemens.com>
 <20220131092726.3864b19f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6108f260-36bf-0059-ccb9-8189f4a2d0c1@siemens.com>
 <20220131094704.0e255169@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <20220131094704.0e255169@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.87.32.84]
X-ClientProxiedBy: DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa785072-5052-4ceb-ed81-08d9e4e9f79e
X-MS-TrafficTypeDiagnostic: DB8PR10MB2841:EE_
X-Microsoft-Antispam-PRVS: <DB8PR10MB2841D6F7E09FBC5C8E3104EF95259@DB8PR10MB2841.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56HAzuFZgI1kUIKb5h+zxH9jBgg+GJLs2G2XoP3Vw3obPixuP4M9UPB5QPtlMKk+9yopZnuk1n+l9rA1I1qfc5p9+vB79RTHxTAbUhD60wiJT6+chxIqjx/HCs4KrRuJiT8igJdo0OnhZHosnF3H6lNEN6PZU+BIQ5wcTDauMbbojAI59J92bQZ01f1mrq13F452opfDdq66Idcsp71t3wp8q5Kx1VJ+Fta/SLObEZDB5Em8VmtpdBFzZ1KqHkngKGd80rpn4upd5hEM3+rd8Xe5NcZGChod+rUXY+VydP+MN/paJwvJfsC0ZbCxNSrnwZ3rsiWuBGfRdvEXvInrezarW/Chc4n8H1g4IlmByRHqxQ4So58900Auk85AYv6UelNDpjb8i/i2z5Z0wfDk/1fhyiXbAnXKJoe/iMB5QOBEljIXfpXTQOFTmpt+dndvHxJ9KWLYfiZC0XzLFOL1qv9ld1lrXSta61kPRnBQlt09IXO0yzarc8Fzt2CJLduAYSWocdKF+2OJdcWVWQQqRml9ieNRQa8lhUuNUiiivkW4R9VxlZ8XMlrv1IazT6wzGJk4JJVCiM3oY2eLGImY3w8VHQu54/cJlDYBTZAH+TZ3vRGbE05WRFkCPLwcXZlWtxgv1p/TxNBe7cV2Zof5Popp+mW+ZzrVUBKDazNiiDzmux5jTfDrOwQ+wZlj15e0iV4qpi+Xr8nkvS/rzwsbmPSKyolCjVZaryTQ5Ox+XLQYLiQtn2R+wqkXriSVx5dbAcKkni1x+WwNnpJ/+AlfjQ==
X-Forefront-Antispam-Report: CIP:194.138.21.72;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(5660300002)(53546011)(8936002)(47076005)(7416002)(81166007)(70206006)(70586007)(82310400004)(8676002)(40460700003)(336012)(31696002)(86362001)(2906002)(356005)(2616005)(26005)(44832011)(186003)(956004)(16526019)(83380400001)(82960400001)(498600001)(36860700001)(36756003)(16576012)(6916009)(31686004)(45080400002)(54906003)(6706004)(3940600001)(36900700001)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 18:46:18.2067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa785072-5052-4ceb-ed81-08d9e4e9f79e
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.72];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT006.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB2841
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.01.22 18:47, Jakub Kicinski wrote:
> On Mon, 31 Jan 2022 18:35:44 +0100 Jan Kiszka wrote:
>> On 31.01.22 18:27, Jakub Kicinski wrote:
>>> On Mon, 31 Jan 2022 10:45:23 +0100 Jan Kiszka wrote:
>>>> What happened here afterwards?
>>>>
>>>> I just found out the hard way that this patch is still not in mainline
>>>> but really needed.
>>>
>>> I have not seen the repost :(
>>
>> Would it help if I do that on behalf of Georgi? Meanwhile, I can add a
>> tested-by to it, after almost a full working day with it applied.
> 
> That's probably the most expedient way to close the issue, yup.
> Real Fixes: tag would be useful as well.

Need to check if I can find a causing commit, but I suspect that was
always broken.

Meanwhile, just to make fun of my "tested-by":

[29837.952695] ------------[ cut here ]------------
[29837.957350] WARNING: CPU: 0 PID: 0 at drivers/usb/core/urb.c:364 usb_submit_urb+0x68/0x4c4
[29837.965661] URB dc43e380 submitted while active
[29837.970209] Modules linked in: qcserial pppoe ppp_async option cdc_mbim uvcvideo usb_wwan sierra_net sierra rndis_host qmi_wwan pptp pppox ppp_mppe ppp_generic nf_nat_pptp nf_conntrack_pptp iptable_nat ipt_REJECT ipt_MASQUERADE huawei_cdc_ncm gspca_zc3xx gspca_ov534 gspca_main ebtable_nat ebtable_filter ebtable_broute cdc_ncm cdc_ether xt_time xt_tcpudp xt_tcpmss xt_string xt_statistic xt_state xt_recent xt_quota xt_pkttype xt_owner xt_nat xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange xt_hl xt_helper xt_ecn xt_dscp xt_conntrack xt_connmark xt_connlimit xt_connlabel xt_connbytes xt_comment xt_bpf xt_addrtype xt_TCPMSS xt_REDIRECT xt_NETMAP xt_LOG xt_HL xt_DSCP xt_CT xt_CLASSIFY wireguard videobuf2_v4l2 usbserial usbnet usblp ums_usbat ums_sddr55 ums_sddr09 ums_karma ums_jumpshot ums_isd200
[29838.041501]  ums_freecom ums_datafab ums_cypress ums_alauda ts_fsm ts_bm slhc nft_set_rbtree nft_set_hash nft_reject_ipv6 nft_reject_ipv4 nft_reject_inet nft_reject nft_redir_ipv4 nft_redir nft_quota nft_numgen nft_nat nft_meta nft_masq_ipv4 nft_masq nft_log nft_limit nft_exthdr nft_ct nft_counter nft_chain_route_ipv6 nft_chain_route_ipv4 nft_chain_nat_ipv4 nf_tables_ipv6 nf_tables_ipv4 nf_tables_inet nf_tables nf_reject_ipv4 nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_redirect nf_nat_proto_gre nf_nat_masquerade_ipv4 nf_nat_irc nf_conntrack_ipv4 nf_nat_ipv4 nf_nat_h323 nf_nat_ftp nf_nat_amanda nf_log_ipv4 nf_defrag_ipv4 nf_conntrack_tftp nf_conntrack_snmp nf_conntrack_sip nf_conntrack_rtcache nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp nf_conntrack_broadcast
[29838.113904]  ts_kmp nf_conntrack_amanda iptable_raw iptable_mangle iptable_filter ipt_ECN ipheth ip6table_raw ip_tables input_core ebtables ebt_vlan ebt_stp ebt_snat ebt_redirect ebt_pkttype ebt_mark_m ebt_mark ebt_limit ebt_ip ebt_dnat ebt_arpreply ebt_arp ebt_among ebt_802_3 crc_ccitt cdc_wdm cdc_acm br_netfilter fuse sch_teql sch_sfq sch_red sch_prio sch_pie sch_multiq sch_gred sch_fq sch_dsmark sch_codel em_text em_nbyte em_meta em_cmp act_simple act_police act_pedit act_ipt act_gact act_csum libcrc32c sch_tbf sch_ingress sch_htb sch_hfsc em_u32 cls_u32 cls_tcindex cls_route cls_matchall cls_fw cls_flow cls_basic act_skbedit act_mirred videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev mwlwifi mac80211 cfg80211 compat xt_set ip_set_list_set ip_set_hash_netportnet ip_set_hash_netport
[29838.185710]  ip_set_hash_netnet ip_set_hash_netiface ip_set_hash_net ip_set_hash_mac ip_set_hash_ipportnet ip_set_hash_ipportip ip_set_hash_ipport ip_set_hash_ipmark ip_set_hash_ip ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set nfnetlink xt_weburl xt_webmon xt_timerange xt_bandwidth ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6t_NPT ip6t_MASQUERADE nf_nat_masquerade_ipv6 nf_nat nf_conntrack ip6t_rt ip6t_mh ip6t_ipv6header ip6t_hbh ip6t_frag ip6t_eui64 ip6t_ah nf_log_ipv6 nf_log_common ip6table_mangle ip6table_filter ip6_tables ip6t_REJECT x_tables nf_reject_ipv6 nfsv4 nfsd nfs msdos ip_gre gre ip6_udp_tunnel udp_tunnel ip_tunnel rpcsec_gss_krb5 auth_rpcgss oid_registry tun vfat fat lockd sunrpc grace hfsplus dns_resolver dm_mirror dm_region_hash dm_log dm_crypt dm_mod
[29838.256898]  dax nls_utf8 nls_koi8_r nls_iso8859_2 nls_iso8859_15 nls_iso8859_13 nls_iso8859_1 nls_cp866 nls_cp852 nls_cp850 nls_cp775 nls_cp437 nls_cp1251 nls_cp1250 dma_shared_buffer md5 hmac ecb cts cbc uas ohci_platform ohci_hcd gpio_button_hotplug mii
[29838.279709] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.261 #0
[29838.285828] Hardware name: Marvell Armada 380/385 (Device Tree)
[29838.291781] [<c010ecf8>] (unwind_backtrace) from [<c010a9b8>] (show_stack+0x10/0x14)
[29838.299560] [<c010a9b8>] (show_stack) from [<c062f1f4>] (dump_stack+0x94/0xa8)
[29838.306816] [<c062f1f4>] (dump_stack) from [<c01287d4>] (__warn+0xe4/0x100)
[29838.313810] [<c01287d4>] (__warn) from [<c0128828>] (warn_slowpath_fmt+0x38/0x48)
[29838.321327] [<c0128828>] (warn_slowpath_fmt) from [<c04a9e1c>] (usb_submit_urb+0x68/0x4c4)
[29838.329650] [<c04a9e1c>] (usb_submit_urb) from [<bf7cb320>] (ipheth_tx+0x104/0x18c [ipheth])
[29838.338186] [<bf7cb320>] (ipheth_tx [ipheth]) from [<c0537a94>] (dev_hard_start_xmit+0xa0/0x114)
[29838.347014] [<c0537a94>] (dev_hard_start_xmit) from [<c055fbcc>] (sch_direct_xmit+0xb0/0x1b0)
[29838.355577] [<c055fbcc>] (sch_direct_xmit) from [<c055fd60>] (__qdisc_run+0x94/0xb4)
[29838.363355] [<c055fd60>] (__qdisc_run) from [<c0536d74>] (net_tx_action+0xf4/0x120)
[29838.371046] [<c0536d74>] (net_tx_action) from [<c0101628>] (__do_softirq+0xe0/0x240)
[29838.378827] [<c0101628>] (__do_softirq) from [<c012d46c>] (irq_exit+0xd4/0xe4)
[29838.386082] [<c012d46c>] (irq_exit) from [<c016662c>] (__handle_domain_irq+0x9c/0xac)
[29838.393947] [<c016662c>] (__handle_domain_irq) from [<c0101464>] (gic_handle_irq+0x5c/0x90)
[29838.402334] [<c0101464>] (gic_handle_irq) from [<c010b64c>] (__irq_svc+0x6c/0x90)
[29838.409849] Exception stack(0xc0a01f50 to 0xc0a01f98)
[29838.414922] 1f40:                                     00000001 00000000 00000000 c01145a0
[29838.423135] 1f60: ffffe000 c0a03cb8 c0a03c6c 00000000 00000000 414fc091 00000000 00000000
[29838.431349] 1f80: c0a01f98 c0a01fa0 c0107f68 c0107f6c 60000013 ffffffff
[29838.437995] [<c010b64c>] (__irq_svc) from [<c0107f6c>] (arch_cpu_idle+0x34/0x38)
[29838.445426] [<c0107f6c>] (arch_cpu_idle) from [<c015d318>] (do_idle+0xdc/0x19c)
[29838.452767] [<c015d318>] (do_idle) from [<c015d634>] (cpu_startup_entry+0x18/0x1c)
[29838.460371] [<c015d634>] (cpu_startup_entry) from [<c0900d3c>] (start_kernel+0x470/0x484)
[29838.468595] ---[ end trace 3b48202f08f7521f ]---

Old kernel, but the code diff of ipheth to master is minimal and
unrelated. Let's see if that reoccurs again. So far, I don't see how
that single tx urb could be resubmitted while in use.

Jan

-- 
Siemens AG, Technology
Competence Center Embedded Linux
