Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A71D182C82
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 10:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgCLJdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 05:33:43 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:30855
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbgCLJdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 05:33:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWoovKJnRfDHRK5aMpSs1LVRcbdkNNPIuYIIlal5BPJLPBw4YB+EzCI/aNsKHU26Fary/U8NknDZcqyhcAmmRQM4Fs55OB1jluzyG+gwxiBjKjmqQsd/fUd3KYxNMowclhNW2zS+m2/SmENUDPu5PRuvWYqXHEzdY1/tsAWO7BdxEQk//Z6dE8q2ZQKF1rrwtrGsDLGP2aqasGStga3nYu0f89F+F/RoxHGTCT+aoBtzSnHxw5F8WWf4stxY/4aG9kWxoEYWHrTY6JOJttBOk4fPxtNpJ/Wb2jCqop5/bUT4PDhrcFDLfuO8uZPcJMpd7lLi46R7FIb5Y57UEV9qrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTM7RzCI4WsFOwsaC528mLhiMAiHD741XHAqZeSKprQ=;
 b=lEUjg5WMK7geziYIAVVN8PrJzIBccYzIVJGujNKKBxqeZJVsA36TEcRami70Xu1Vc+PWx2fik/fXTu5NbH+DCRdSxdlMnXPQL37Pd6lSIXzmK1WqbtJfIP0e7NZ69SY7+UGJwu9E4r6SpfD2eNM5O8bFCN5wv3DbCRrZ5/l7Owi5ZFnHP7AwafZhVFgCpZKX1gvGSYymJrjyNv/7N2cj2lWHFCw6wX7uJX8X5V0ZMtoNTHfFtbX6wnuOpI0PD4tBz/4VUXpu9+Z6nSsipKxx9hN/4fJ2nvgkpi33fsCvZttx6h5OEJ5acTq2sIAHMDVF2vZrLPtGVUPe11H3jmnA5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTM7RzCI4WsFOwsaC528mLhiMAiHD741XHAqZeSKprQ=;
 b=qhwecg6eSF+/bi/RFa+3LSwIjXsIAVxlB0Ys3yNw2xNQe+1bB/+lD154IZ4N7gqFp2pMgrexW3/6vdJ7h+u9xpxvewe7+YXLTlhypr8i7kTK8A80k1rguO7r/HFGIDk6U1gUNzjVeFjYceiWFQXB0edTZN2FYolSR99t3/jqXB4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6423.eurprd05.prod.outlook.com (20.179.4.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13; Thu, 12 Mar 2020 09:33:38 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2%7]) with mapi id 15.20.2814.007; Thu, 12 Mar 2020
 09:33:38 +0000
Subject: Re: [PATCH net-next ct-offload v3 00/15] Introduce connection
 tracking offload
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
 <20200311191353.GL2546@localhost.localdomain>
 <511542c9-2028-a5a8-4e4a-367b916a7f1c@mellanox.com>
 <20200311224415.GL3614@localhost.localdomain>
 <20200312000126.GF2547@localhost.localdomain>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <37bec421-dddc-decf-8aef-5990c6136418@mellanox.com>
Date:   Thu, 12 Mar 2020 11:33:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <20200312000126.GF2547@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR01CA0102.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::43) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM0PR01CA0102.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Thu, 12 Mar 2020 09:33:37 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 84f51545-20a8-4916-3af7-08d7c668715f
X-MS-TrafficTypeDiagnostic: AM6PR05MB6423:|AM6PR05MB6423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB64237B30099C1A9536DD7451CFFD0@AM6PR05MB6423.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(199004)(5660300002)(316002)(8936002)(54906003)(6486002)(66556008)(107886003)(53546011)(66476007)(66946007)(6666004)(36756003)(16576012)(4326008)(52116002)(2616005)(478600001)(956004)(31686004)(86362001)(2906002)(8676002)(26005)(186003)(16526019)(81166006)(6916009)(81156014)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6423;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HpGwK0W/BypI1z6II0wAR3JxJyDhTax+eJOlKJ+GGRGKNb7cX5YoT0n8rhrm35wLBvtWAWbeYv5/zjgpo2l2hV9nKdgQUMBBnhjaC9cXfzEnx1fSobPDVbe4cWZ+jS9dgjHsskRoiyGXpyi0mHaar2baN1eLqIri7w/FpL8cvosmPyVUvsvhAoPXDxjncUZVpk0VDzJ+tt/UcVQkY4royqMTrA19E0Ev/T0fc53bOf/QoZHOvRPsaqJknKBxc7YpfW/1Xrt9MUW9WLHUDPe+Uxlzkl7qnO4gekWj8bshcVyrHRKREG+u9y0VEYlpZ0sWiAD3/QpRov89pJDEw0MtqTIoVvOq7kxRva84ddNdqlY4Ov4hENJUuAHtWSRImasIwhgqBZIPLB3pzxHrXqINJyE6M82eEMATL5bt1WrxXgMSzj9vKlRUnkWttpNsd2mu
X-MS-Exchange-AntiSpam-MessageData: Mw4HX5qCtDBSwRpT0g1uW7ZzJfXajDKln6xcUd+U/oN5F7Gxdh/L+QDGWMVTXr2vcOz7OsGwKM5o80y1j4P4/w17XzqrRtfvI/LrUdAM+VYpLVoSkLIPiMf7Tp9X1C71t0Rw7vPZHDcKM8I/oc5Q3g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84f51545-20a8-4916-3af7-08d7c668715f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 09:33:37.9579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8AW0AGuRQ30Gg9Ig7+HRVnVAvm6+dzTO/5UjtdtsqyOaAygxm+nWTZ66cb+G+n4eZ1c8eu+YslIBXb0Q5OE2Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6423
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/12/2020 2:01 AM, Marcelo Ricardo Leitner wrote:
> On Wed, Mar 11, 2020 at 07:44:15PM -0300, Marcelo Ricardo Leitner wrote:
>> On Thu, Mar 12, 2020 at 12:27:37AM +0200, Paul Blakey wrote:
> ...
>>> if not try skipping flow_action_hw_stats_types_check() calls in mlx5 driver.
>> Ok. This one was my main suspect now after some extra printks. I could
>> confirm it parse_tc_fdb_actions is returning the error, but not sure
>> why yet.
> Copied the extack in flow_action_mixed_hw_stats_types_check() onto a
> printk and logged the if parameters:
>
> @@ -284,6 +284,8 @@ flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
>
>         flow_action_for_each(i, action_entry, action) {
>                 if (i && action_entry->hw_stats_type != last_hw_stats_type) {
> +                       printk("Mixing HW stats types for actions is not supported, %d %d %d\n",
> +                              i, action_entry->hw_stats_type, last_hw_stats_type);
>                         NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
>
> [  188.554636] Mixing HW stats types for actions is not supported, 2 0 3
>
> with iproute-next from today loaded with
> 'iproute2/net-next v2] tc: m_action: introduce support for hw stats
> type', I get a dump like:
>
> # ./tc -s filter show dev vxlan_sys_4789 ingress
> filter protocol ip pref 2 flower chain 0
> filter protocol ip pref 2 flower chain 0 handle 0x1
>   dst_mac 6a:66:2d:48:92:c2
>   src_mac 00:00:00:00:0e:b7
>   eth_type ipv4
>   ip_proto udp
>   ip_ttl 64
>   src_port 100
>   enc_dst_ip 1.1.1.1
>   enc_src_ip 1.1.1.2
>   enc_key_id 0
>   enc_dst_port 4789
>   enc_tos 0
>   ip_flags nofrag
>   not_in_hw
>         action order 1: tunnel_key  unset pipe
>          index 4 ref 1 bind 1 installed 2432 sec used 0 sec
>         Action statistics:
>         Sent 223744 bytes 4864 pkt (dropped 0, overlimits 0 requeues 0)
>         backlog 0b 0p requeues 0
>         no_percpu
>
>         action order 2:  pedit action pipe keys 2
>          index 4 ref 1 bind 1 installed 2432 sec used 0 sec
>          key #0  at ipv4+8: val 3f000000 mask 00ffffff
>          key #1  at udp+0: val 13890000 mask 0000ffff
>         Action statistics:
>         Sent 223744 bytes 4864 pkt (dropped 0, overlimits 0 requeues 0)
>         backlog 0b 0p requeues 0
>
>         action order 3: csum (iph, udp) action pipe
>         index 4 ref 1 bind 1 installed 2432 sec used 0 sec
>         Action statistics:
>         Sent 223744 bytes 4864 pkt (dropped 0, overlimits 0 requeues 0)
>         backlog 0b 0p requeues 0
>         no_percpu
>
>         action order 4: mirred (Egress Redirect to device eth0) stolen
>         index 1 ref 1 bind 1 installed 2432 sec used 0 sec
>         Action statistics:
>         Sent 223744 bytes 4864 pkt (dropped 0, overlimits 0 requeues 0)
>         backlog 0b 0p requeues 0
>         cookie 9c7d6b3aa84a32498181d98da0af80d2
>         no_percpu
>
> Which is quite interesting as it is not listing any hwstats fields at all.
> Considering that due to tcf_action_hw_stats_type_get() and
> hw_stats_type initialization in tcf_action_init_1(), the default is
> for it to be 3 if not specified (which is then not dumped over netlink
> by the kernel).
>
> I'm wondering how it was 0 for i==0,1 and is 3 for i==2.
There is a current bug with pedit, as it is split to muliple mangle action entries, and the action entry hw_stats field is not
init for all of them. Then we fail on checking all hw_stats are the same ...



