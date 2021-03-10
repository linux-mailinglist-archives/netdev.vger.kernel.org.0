Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551A13336AE
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 08:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhCJHvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 02:51:51 -0500
Received: from mail-co1nam11on2119.outbound.protection.outlook.com ([40.107.220.119]:30657
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231208AbhCJHve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 02:51:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXZLOOcAtCq+7C0S9Kv762JoAxmSOmjHY0fIr5r6icEK8hG/pAZN5ZazqK+aZ7cZNL90MYjVu2ueQ1GvST/CnvYn94RYGZ0upEX3WACdikQRJuPe/3HRvBpfK72Ly3zU/IkKCUoDC7i0BVRxalsAX7ddxBVw9q/ZMS81PiZ/TudZhxEAXQ+XUHNPH/0T+LJ9d248RPcmu39DXW3Y3XoVn/P65O2bYAEf2vQF9FwCwSbO/uFyAjtIjSNq9kdHJiISSNsy157fTKsKwQeB3+Yz0pJyfTCTakZ9t3bMGcjDxtvE3HhNCLM2A4Yc2ZAGz5jEF4u2AG3fUEMAR/y84kkr5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaEx86dQb8bgwhlqI8gwu43O+OAl+6VbyOII6Mdh5tU=;
 b=RBF63PUBRG7LHX0ZmMsnlmR+J8Aof5X9VD5B0O4EY/ZjC9+raCKvUQw4TbaFBFCNTnJTwfX0M6zhZ3TnRqUR6WH3n0IfvRatfHilyX7e/RyJwcC8/JKY6qEs1VHwSuULvnlAOiWB4BVX80lGao9ZkNOPD7HYrxs3Rh5AdBoD6nVGoP6vVCqGY9N1b6rWdnzZOtDPI+P1Zom+QRSbKsBngKCFGqHXROlDQeTVC8nGVeoxe8WI3WcqIBWLBZOkkPkk2N5nz4odbSZqx7LelPXXu4Sy/v0bPFqQNW/46lMMa33KTpWopVmq/L9BFJ5u+HbNOHK98/zVuegFcXBFMQhKHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaEx86dQb8bgwhlqI8gwu43O+OAl+6VbyOII6Mdh5tU=;
 b=ZU8WGdoaDAKpi2jCOoiSilEWoWiImaYnWqIG/MCcV25hS06wcB2e51UUGZmx9gVsXroWCJPsPMiT1uGUlVYsT9j9ts/t6VuXfsPB64UsnXKmbVFlOJkD5g/aQN9xroUsOfJci2DpsHBoUJZiLWvcSCdbhI5+4v2Gn5kAxya+55U=
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM6PR13MB4250.namprd13.prod.outlook.com (2603:10b6:5:30::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.11; Wed, 10 Mar 2021 07:51:33 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80a1:dc0f:1853:9fc9]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80a1:dc0f:1853:9fc9%4]) with mapi id 15.20.3933.030; Wed, 10 Mar 2021
 07:51:32 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     "ovs-dev@openvswitch.org" <ovs-dev@openvswitch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: [ovs-dev] tc-conntrack: inconsistent behaviour with icmpv6
Thread-Topic: [ovs-dev] tc-conntrack: inconsistent behaviour with icmpv6
Thread-Index: AQHXFXuY8j6rUxPkcE6KCWUHTw3qng==
Date:   Wed, 10 Mar 2021 07:51:32 +0000
Message-ID: <DM6PR13MB424939CD604B0FD638A0D56C88919@DM6PR13MB4249.namprd13.prod.outlook.com>
Accept-Language: en-ZA, en-GB, en-US
Content-Language: en-ZA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: openvswitch.org; dkim=none (message not signed)
 header.d=none;openvswitch.org; dmarc=none action=none
 header.from=corigine.com;
x-originating-ip: [105.22.41.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 690f8652-fd6f-402d-b31d-08d8e39952a4
x-ms-traffictypediagnostic: DM6PR13MB4250:
x-ld-processed: fe128f2c-073b-4c20-818e-7246a585940c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR13MB42501AF70AE305B8DF068A0288919@DM6PR13MB4250.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FdUwOfpMAlkv3WyKp3XQ5LsA/4/q1uAfBAR3HMbJ4WQXuQ3JvU/e80x8vvRNdyikVADCetbzesplYB+ieos5H5f4Hf9w3GdjPCbFRtAhQHXtYrirlug8B8fkrik51YgtNsqUSReum/5gVyMdFF4ZqUdXxdFX6A6fFuhbgPl19SDx1TADluVO5lCaYQ38u1sDQnk1tUhwBqo4dDLqmH+Rv3sz649THkrJRockK4i3UFRq/nYRtwrLYzGjZef2yzyPj9pXw40YN7GE8jAZhXBaOgy9s8yoThyaWZTxAsjbltBIRw3PWf+xd/DnTuP0LEQx2fBKeUlUv9O7bqacqBMg4K69MwehQICDK8Qgynnr2uVAj+Sm5PEcRka12E1uRqHnHCz5kVoslGC6N2VmPjtDyjTOJNsZxw7AH/6hjsowzb2/zQKpto9pbYyqmROEChirE9AxVf7z1hYvp8tgbTDXFjr8TCr1OX7T1KWUcp+xK/JBKo9T5F1Ti8MLhsggnq4U3eoUtXfIqDzTW5rkdbI1NQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(39830400003)(136003)(83380400001)(44832011)(8936002)(86362001)(107886003)(64756008)(33656002)(54906003)(7696005)(2906002)(5660300002)(26005)(478600001)(186003)(316002)(4326008)(55016002)(8676002)(66446008)(66476007)(52536014)(6506007)(66556008)(9686003)(6916009)(91956017)(66946007)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?anVAIk+NA+NNqOC7CXhGIrY2OJdAljmHak3ptVLe4y6Q/S5HxnljVTj6mH?=
 =?iso-8859-1?Q?BVpi6cOG4Ko93FFHq/ShEFSkcJ/aZk/y6qCGN/DjeMRj0rfjQJFhqbct+v?=
 =?iso-8859-1?Q?z/LViyZM/BSiakR+IkRp5stEkl4lNoW1oBQVXdRjMk5aPhSRsb9AhPrnBX?=
 =?iso-8859-1?Q?vbfJB02Elv+8ewOoTZy5qfcBzzVl189iqk8m+/ELJCNTItqlKy6vqJJbvB?=
 =?iso-8859-1?Q?+PH2FVhjzRYsbvyixV+cLQK0hoXjelIVy85PpsdJvmRhnn1TALL+oYeRXa?=
 =?iso-8859-1?Q?m6K6WLtlNTfoCoOy3Wx82kBgh/48OMj761FiPovQgm8MYPvQ7hbTFDWFcL?=
 =?iso-8859-1?Q?Dc1IZdxmAJ+nAVLZQmGJCnPgbzq7/djYEe62wZi38Xu/Iyxv5zwH55OTSa?=
 =?iso-8859-1?Q?FPRFlLPsHeIUyeTg291b2nTAr9fCtqMElIP3UWhTV3BrfkLb37vnnf0kPo?=
 =?iso-8859-1?Q?j/4LkYd2NCDk23rOzNeu6qTQDnstpJqj/9xhfIfIHeVmFN92MnqA/a8SOU?=
 =?iso-8859-1?Q?SjGRcDbyHGZGRn9Hm+fwBCbd89v8K1UaESoILPWc1ud/6qvpNXMu9wjtlV?=
 =?iso-8859-1?Q?ODkv1TXiRjp5Qjvg2dfDBzIwaRArmIyAIpMxanL2LV07fMq+RvrvPcQeUY?=
 =?iso-8859-1?Q?yD0rLWDLiIG+nbFnbXVP6x2SSoPwEh5SZ8sgyn7H9PA5tFpE4rp+GAWB3+?=
 =?iso-8859-1?Q?Nw9LfJ05FhFU0JYD5HLaWdBwjpdGNGFK3klD5NvRm4F4Rd5lIGHrCPdGO5?=
 =?iso-8859-1?Q?6QOWFeHa74AZUR173Wj+aSXwkajP7pyvC8Sa2zHhXDrbKWih/V2PWKBnYY?=
 =?iso-8859-1?Q?9KYo/iZ6y0KRaEOimKULcCJ2gyfkXUIFcZQ5mfxmr8mfStKc3YxYmmWyc7?=
 =?iso-8859-1?Q?r/GrC2TP1QGdpxj7Jn1rqa9aLgKTk5/gdH3sPrzE++uiW06sppKuDvHe7p?=
 =?iso-8859-1?Q?aETVTsOtigJJ7p7s4leIYZwIMelICxdwS1rcc2Aq4ExbwU39OAgavws3ho?=
 =?iso-8859-1?Q?9F6a6pvt4OwSIE6wtBW97W5yDLQeSROHuX7mpe+XybW+tvtfGk41UOy0Cs?=
 =?iso-8859-1?Q?VDtTsMm9DzLmrKG/z2JgwKS/Q2iHtdmeLk6huo2b+FIXbvbR6hx7yzCncK?=
 =?iso-8859-1?Q?cQAxgNGpr00WXRgfePTxLpsjRGyRcowEf3AmN7nwOXlUga4QDc45oVnGIc?=
 =?iso-8859-1?Q?doS4yHsx3V9seqMKEFuB5d/iTPnf5BzYoppf94mvLMsljUrW5Xl9b6pref?=
 =?iso-8859-1?Q?+f6j4nvBbNTuIGrtZbifW27lTnwbk7w82XnNcLhGO7J2zPKtfgFwedwLyY?=
 =?iso-8859-1?Q?sVTOU3K7bqj/ZcdA2eokf7LamDwxAALCLEKKG+X2M9+5PR0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 690f8652-fd6f-402d-b31d-08d8e39952a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 07:51:32.7372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FhkqSEkpzxwdKBVJk05Ys9OfBFkaZPRpUqxHpMTg3+Ews6Nk5PlLH+/B1AwD9KuxGkLcJvVeHZWjLBewl+KMRp9HW4E36fFJ+ae+gwp1h2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4250
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all=0A=
=0A=
We've recently encountered an interesting situation with OVS conntrack=0A=
when offloading to the TC datapath, and would like some feedback. Sorry=0A=
about the longish wall of text, but I'm trying to explain the problem=0A=
as clearly as possible. The very short summary is that there is a mismatch=
=0A=
in behaviour between the OVS datapath and OVS+TC datapath, and we're=0A=
not sure how to resolve this. Here goes:=0A=
=0A=
We have a set of rules looking like this:=0A=
ovs-ofctl add-flow br0 "table=3D0,in_port=3Dp1,ct_state=3D-trk,ipv6,actions=
=3Dct(table=3D1)"=0A=
ovs-ofctl add-flow br0 "table=3D0,in_port=3Dp2,ct_state=3D-trk,ipv6,actions=
=3Dct(table=3D1)"=0A=
#post_ct flows"=0A=
ovs-ofctl add-flow br0 "table=3D1,in_port=3Dp1,ct_state=3D+trk+new,ipv6,act=
ions=3Dct(commit),output:p2"=0A=
ovs-ofctl add-flow br0 "table=3D1,in_port=3Dp2,ct_state=3D+trk+new,ipv6,act=
ions=3Dct(commit),output:p1"=0A=
ovs-ofctl add-flow br0 "table=3D1,in_port=3Dp1,ct_state=3D+trk+est,ipv6,act=
ions=3Doutput:p2"=0A=
ovs-ofctl add-flow br0 "table=3D1,in_port=3Dp2,ct_state=3D+trk+est,ipv6,act=
ions=3Doutput:p1"=0A=
=0A=
p1/p2 are the endpoints of two different veth pairs, just to keep this simp=
le.=0A=
The rules above work well enough with UDP/TCP traffic, however ICMPv6 packe=
ts=0A=
(08:56:39.984375 IP6 2001:db8:0:f101::1 > ff02::1:ff00:2: ICMP6, neighbor s=
olicitation, who has 2001:db8:0:f101::2, length 32)=0A=
breaks this somewhat. With TC offload disabled:=0A=
=0A=
ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=3Dfalse=0A=
=0A=
we get the following datapath rules:=0A=
=0A=
ovs-appctl dpctl/dump-flows --names=0A=
recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ip=
v6(frag=3Dno), packets:2, bytes:172, used:1.329s, actions:drop=0A=
recirc_id(0),in_port(p1),ct_state(-trk),eth(),eth_type(0x86dd),ipv6(frag=3D=
no), packets:2, bytes:172, used:1.329s, actions:ct,recirc(0x1)=0A=
=0A=
This part is still fine, we do not have a rule for just matching +trk, so t=
he=0A=
the drop rule is to be expected. The problem however is when we enable TC=
=0A=
offload:=0A=
=0A=
ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=3Dtrue=0A=
=0A=
This is the result in the datapath:=0A=
=0A=
ovs-appctl dpctl/dump-flows --names=0A=
ct_state(-trk),recirc_id(0),in_port(p1),eth_type(0x86dd),ipv6(frag=3Dno), p=
ackets:2, bytes:144, used:0.920s, actions:ct,recirc(0x1)=0A=
recirc_id(0x1),in_port(p1),ct_state(-new-est-trk),eth(),eth_type(0x86dd),ip=
v6(frag=3Dno), packets:1, bytes:86, used:0.928s, actions:drop=0A=
recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ip=
v6(frag=3Dno), packets:0, bytes:0, used:never, actions:drop=0A=
=0A=
Notice the installation of the two recirc rules, one with -trk and one with=
 +trk,=0A=
with the -trk one being the rule that handles all the next packets. Further=
=0A=
investigation reveals that something like the following is happening:=0A=
=0A=
1) The first packet arrives and is handled by the OVS datapath,=0A=
   triggering the installation of the two rules like in the non-offloaded=
=0A=
   case. So the recirc_id(0) rule gets installed into tc, and recirc_id(0x1=
)=0A=
   gets installed into the ovs datapath. This bit of code in the OVS module=
=0A=
   makes sure that +trk is set.=0A=
=0A=
    /* Update 'key' based on skb->_nfct.  If 'post_ct' is true, then OVS ha=
s=0A=
     * previously sent the packet to conntrack via the ct action.....=0A=
     * /=0A=
   static void ovs_ct_update_key(const struct sk_buff *skb,=0A=
                              const struct ovs_conntrack_info *info,=0A=
                              struct sw_flow_key *key, bool post_ct,=0A=
                              bool keep_nat_flags)=0A=
    {=0A=
            ...=0A=
            ct =3D nf_ct_get(skb, &ctinfo);=0A=
            if (ct) {//tracked=0A=
                    ...=0A=
            } else if (post_ct) {=0A=
                    state =3D OVS_CS_F_TRACKED | OVS_CS_F_INVALID;=0A=
                    if (info)=0A=
                            zone =3D &info->zone;=0A=
            }=0A=
            __ovs_ct_update_key(key, state, zone, ct);=0A=
=0A=
    }=0A=
    Obviously this is not the case when the packet was sent to conntrack=0A=
    via tc.=0A=
=0A=
2) The second packet arrives, and now hits the rule installed in=0A=
   TC. However, TC does not handle ICMPv6 (Neighbor Solicitation), and expl=
icitely=0A=
   clears the tracked bit (net/netfilter/nf_conntrack_proto_icmpv6.c):=0A=
=0A=
    int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,=0A=
                                  struct sk_buff *skb,=0A=
                                  unsigned int dataoff,=0A=
                                  const struct nf_hook_state *state)=0A=
=0A=
    {=0A=
    ...=0A=
            type =3D icmp6h->icmp6_type - 130;=0A=
            if (type >=3D 0 && type < sizeof(noct_valid_new) &&=0A=
                noct_valid_new[type]) {=0A=
                    nf_ct_set(skb, NULL, IP_CT_UNTRACKED);=0A=
                    return NF_ACCEPT;=0A=
            }=0A=
    ...=0A=
    }=0A=
    (The above code gets triggered a few function calls down from act_ct.c)=
=0A=
=0A=
3) So now the packet does not hit the +trk rule after the recirc, and leads=
=0A=
   to the installation of the "recirc_id(0x1),..-trk" rule, since +trk wasn=
't=0A=
   set by TC.=0A=
=0A=
This is now the point where we're a bit stuck and is hoping for some ideas=
=0A=
on how to best resolve this. A workaround is of course just to modify the=
=0A=
userspace rules to not send the icmp packets to conntrack and that should=
=0A=
work, but it is a workaround. I think this inconsistency between TC=0A=
offload and non-TC is quite undesirable, and could lead to some interesting=
=0A=
results, for instance this was first detected by the observation of packets=
=0A=
getting stuck in a loop in the datapath:=0A=
=0A=
recirc_id(0xe),...ct_state(0/0x20),....,in_port(eth9),eth_type(0x86dd),... =
,dp:tc, actions:ct,recirc(0xe)=0A=
=0A=
Where the userspace rule was doing ct to the same table instead of moving t=
o the next table:=0A=
=0A=
ovs-ofctl add-flow br0 "table=3D0,in_port=3Deth9,ct_state=3D-trk,ipv6,actio=
ns=3Dct(table=3D0)"=0A=
=0A=
So far we've not managed to think of a good way to resolve this in the code=
.=0A=
I don't think changing the kernel behaviour would be desirable, at least=0A=
not in that specific function as that is common conntrack code. I suspect=
=0A=
that ideally this is something we can try and address from the OVS side,=0A=
but at this moment I have no idea how this will be achieved, hence this=0A=
email.=0A=
=0A=
Looking forward to get some suggestions on this=0A=
=0A=
Regards=0A=
Louis Peens=0A=
=0A=
PS: Tested on:=0A=
net-next kernel:=0A=
    d310ec03a34e Merge tag 'perf-core-2021-02-17' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/tip/tip=0A=
OVS:=0A=
    "cdaa7e0fd dpif-netdev: Fix crash when add dp flow without in_port fiel=
d."=0A=
        +=0A=
    "[ovs-dev] [PATCH v3 0/3] Add offload support for ct_state rpl and inv =
flags"=0A=
    (The behaviour before and after the patch series in terms of the proble=
m=0A=
     above is the same. Whether the recirc rules end up in the ovs datapath=
 or tc=0A=
     datapath doesn't really matter)=
