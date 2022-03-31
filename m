Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D122D4EE040
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 20:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbiCaSTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 14:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbiCaSTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 14:19:09 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023D21E5A50
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 11:17:20 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22VFisIV001494
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 11:17:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=proofpoint20171006;
 bh=yYCAmDkVMiHx2Uy6IO3pPJP1zsafI/U5CMisi8XcLiU=;
 b=FohEiKSEzRaHXDgJHIKrLq4Xcm5M7us/ZeJY+gJIBtAYfwlSCVRt49gdQqgz/Q6u3Jbs
 f3/doWP1SSCCRStjqe47gh9ylkwj2XLJqDsVPQ0TScav56Q7T/qn2+3Mq6FhTYWJmO0e
 PSrPj9sQZW9Kj+Ltrge0yYpjdp0eJe/GAxRv1tujySq2lrDJF2KQQ6bIsVJd8hTAoGHY
 a40pqajcvtbRAKuIYHLQo/E4Y8nJB1eoxC0ofVlR1HDkcbVGwLWZeqrsbVGLcU2WcYLy
 tcHFXANFsvzF92KuNVy4uRc/85DIzj3/W7JtGrH2yGvbcou2bX6w6dQxaJsmxrZe6EIZ mQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3f1xr8kwr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 11:17:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Il1MUVub2FKGJ3RKoWyxUQ4hhmu9kpFLp2S6yW8GtIat2u2ACKQPYF7lmpejZ3zKwxmDjMy0FvhvYhmOH/BtX2d7fyYLCe3T2IUqzUw7gd2tPA3/35rn8srYO6sS5RD4O6SUu5dLbKYZD17OLRJNZywM45/grxvf4ePtNomEnpWSxTQp52QIgQ6mmCWcb4i+9C8Lfjhyole5nNK4mm1wq6FNYhJH6ciRNhEoWJdZr3iZLddIrd5Mzykru0FC+fkqkB/t2ADRUf6vqym8yBDpa2WCUpteW1ca3kEQRIzf26exYxdUSK4L2eYfYVkoJBk7pmpUREbXgaszeG9rKpRLTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYCAmDkVMiHx2Uy6IO3pPJP1zsafI/U5CMisi8XcLiU=;
 b=I1yfKHcGMHpR0WOWp1TuX3uoKlW/5Gs6JrDjlvCdH+nwzKL7HauXhL+DutSrHMbzGO+YvokVRc9g6QShT9r17ijko9m0jzvSQLikSSJzRWCMM+Q4LNYCzfaZ7kI4ED8DxxArqAoLFHV+2kCshoQeTGTzubrm7aXY6i+VncCIm06dBe3GH9IDWiHQKkATkrQ+o1albt+QIOidRJALaiG5DJnpu8xyOXvvaYv/c+uU+9H8IBJm7n1vAXbxh2OZ7pM+HXc45VH3dxbjpKTo8deFUX7C0Xvw7iUXnpjBZR+lwwGzelFHVWocA1YggeayDStSRlMnwbowJt6N4jyat8FFFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from SJ0PR02MB8862.namprd02.prod.outlook.com (2603:10b6:a03:3fd::8)
 by BY5PR02MB6066.namprd02.prod.outlook.com (2603:10b6:a03:1f9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.21; Thu, 31 Mar
 2022 18:17:14 +0000
Received: from SJ0PR02MB8862.namprd02.prod.outlook.com
 ([fe80::3580:8973:41bc:fe63]) by SJ0PR02MB8862.namprd02.prod.outlook.com
 ([fe80::3580:8973:41bc:fe63%6]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 18:17:14 +0000
From:   "Kallol Biswas [C]" <kallol.biswas@nutanix.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: bug in i40e-2.14.13 driver ??
Thread-Topic: bug in i40e-2.14.13 driver ??
Thread-Index: AdhFK4uEFseXr7dmQZ6a8liD4G0ezw==
Date:   Thu, 31 Mar 2022 18:17:14 +0000
Message-ID: <SJ0PR02MB8862A7F336A45D8E8B0090C4FEE19@SJ0PR02MB8862.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99609f68-c48d-43f5-612f-08da1342aebb
x-ms-traffictypediagnostic: BY5PR02MB6066:EE_
x-microsoft-antispam-prvs: <BY5PR02MB60662D8DD3FA8C09A3CB1EDFFEE19@BY5PR02MB6066.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pu7kI2VR1O3U/nAPrYxprj/OyqURh7xFdFT3MsrgQ5ve+frYSO3duySHB7JbIPzOjMsgSBn4heFCRECkZCUu89tu8jU7FWpCno1h2BR0s+gopL9Zb+CqGuKTup576uY1BjzQ8/iiSstffkxQWOw5/TcUvXy/TKw77AKYlVtvyxqDFPotnWV6Gr1N2CyskqsSFEuQSYiCXQQILO5uQ4EMY/UNHP752910B8yumjkJqRtbp/h6KC6546VJCJISur26WOLYVQ4KvdudAvRBTmQwJXC7cXvo/Q1akDinStzA0HRO2doXB8e0fD1u2b1/c2e58LS/sMJ0hFGbDjHnv/V3/e5zVM4Bo11jvEWuHlk0YMGwQKBWhlbX7QwZIUrAiStCxJ7C2ag4gZaz6zxmxC8CgnHFgpJ/6mziuc6++F6Le1hxcRXBuxfi+bm6tcQ+vyyO/IOehUSqKKFBrAB4dx9BIQjM+oPcE53EndIRJaup/A2npMi/vLFy1OeR88aqiRdOO5OKDpW4sS89fDia7/HimlphMgNclq7cxbPcs0ZOZaixLZoFSjkfAVLG9AbdUcxfry7YqpVooN8cfSBluDJcjBeL5qjhKuvFnHBxWnKkSROn5PJuxgn2+tl67eP/2umNzAAdb5pRPjCKGAY25cn+L10YE9l/cLI74auWeFEuqvYRBjevrURaYkT5Elx3RWLs5PGs3k69F4XsO8L83O52pg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR02MB8862.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52536014)(7696005)(66556008)(8936002)(2906002)(33656002)(83380400001)(64756008)(186003)(76116006)(66946007)(40140700001)(66446008)(8676002)(9686003)(26005)(5660300002)(71200400001)(55016003)(508600001)(38070700005)(38100700002)(122000001)(66476007)(316002)(86362001)(6916009)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+Il8aPZy1a3VLzFTQfXo+uc1DlkRtSfShJDJPiHsq4Fb6o0ZIJf4nGlTyZHW?=
 =?us-ascii?Q?uHAddL+8siWXqvVRkYboOpHyX7MlmyCIIP0DdjTUT2j7gGns5J1uC6WhHebt?=
 =?us-ascii?Q?UYzJiCbGxRfmv+xHxJOBVz4kt7YtEGJ8p6ok8TTfA8qLNTGlh8CnAId4u8PH?=
 =?us-ascii?Q?A6FFOmWtwLZD2/2wUd/GN6z8ge2M/GNNEBgKqUFNhf3BCEpAHEcRD/f2Th9A?=
 =?us-ascii?Q?rTT0+uxTse2T9Yb8NGkauA2FOtnpG5rHLPaM3bZUH9IkYocApSJSlTdv493p?=
 =?us-ascii?Q?Mu4VKASLoMTy9THf3fwHap8g6bSyL/B6QJykybhk1wk7owJIAXPg6GOA+x8A?=
 =?us-ascii?Q?vMiYvPWVmUw7R69x9um0jVIe5INzTtTAcg/kTjQyFVbDRDE9x0X6WNIpaRKs?=
 =?us-ascii?Q?CPT+JGPF8QT6lCnOwtqOH9AhSNGgLy7HODTHoaErCac+Fn5+We7i+LySmWi1?=
 =?us-ascii?Q?AZx7VhtKfV9Spxl6kh11cfk6kctvijpsZHxZn99355SwKYzLl2nfzj/cmkRD?=
 =?us-ascii?Q?h67YPiTYPZFcsBgz4AQGcglKmNcLZvJA+SlDIPvdL9C/fbWtXJqE7KX6FEY4?=
 =?us-ascii?Q?1xF70Kunm6lXMXo+zXBc/wHECBrDhifHoGIEhnjyX8Ch9uvBn+ZlSuxESUvq?=
 =?us-ascii?Q?YVaXewIt6CnYSfQ9mSaBcea7IfFcgAfmnO3Ur6LQ5gYSSLvUmeqIaaetKfvi?=
 =?us-ascii?Q?V4j8gthibOB7CAF7bU8KRCGoci6ja7fBJB3UoxCDDO3E8dmtf4eHrVDe8o4a?=
 =?us-ascii?Q?ikI747lZ4mFDr1n5k4jQDZAp8P2OASJz/0+0tvDApiYIl5Fnhr6aJCgyn4yz?=
 =?us-ascii?Q?SMh2rZFX8iBMyDM/ZWRxxA+91wubzDbmDFrtn+REf40NA2HwWbQ7gDlfoXSw?=
 =?us-ascii?Q?OVB/x14OohNZW/HR102vrvgBLwCzr64dbBPp01GMXSpcMyswdjVv0G7pzbbc?=
 =?us-ascii?Q?6C9JOTBVmQrRUj8zrpvcPNOgwx9R5air2siwruLP/Zd4TIU/5S1b5Up7hZV4?=
 =?us-ascii?Q?ryG7Q7SZ3oodtB+fQhf/xi0bRVq5KLii4IQvSdefuqesfAVyWAIRkJcRMjSt?=
 =?us-ascii?Q?Fw27l1pRm4g6XJvAWsvJ+8L8Eo8eebw9kLbxnZBNKf2l9k407zLD094kFgW9?=
 =?us-ascii?Q?MGQ5ukUffhYOKl2QrbZvLt7utXIHZD/g93gKRpGgUQQ37AUaMACebrlyqdG2?=
 =?us-ascii?Q?NrKiVYFaGYkf+a5ABpvM6aq9tng0Y/NFAjhZ2cEyXQTtGnrs9xoKaWzY8qnX?=
 =?us-ascii?Q?4wWsI0x7+AYsln3tQNvjO9wG/LFpPZgY9npipIsF6ZwpdWyxL9QLP5drqG9t?=
 =?us-ascii?Q?VsQyoc/CWv17WtuD8iAqQHLaEuPRIVGYdejjsKtH/e+ss8CpV9Anjq7sqGrY?=
 =?us-ascii?Q?9uWwiAWPddfyah69Q7O2GeyfHRWdV7kSpZtK8gYdt0QXTuac7P72riwIrWgr?=
 =?us-ascii?Q?UUPkJNWtWDyFQp3ED4hVfBVWpZMlzPsAhs7PB1MVYizyXyRrcAws+zIyR93X?=
 =?us-ascii?Q?CV02XClCgS2hFTd8MuIovebf/Gn3LXMBVDgYsCAHmJpB3cp+Mm90SEEimz84?=
 =?us-ascii?Q?Zbdf2GZFBLa+O0/brh/keXLYNLTJgldmh6MEIKKeXK5kjKidueHhMYs01hNA?=
 =?us-ascii?Q?nn2+y4wzeBIgWsQFcldrm9ans2Tz6tDu70HiVM0GGuVYfz/4zoH5hSfoKFI9?=
 =?us-ascii?Q?6nuL4prohevwMFdY2FEGT71h2pnMk7RCTWa5KK9zFwpnoW37cIjDg/6bS2IH?=
 =?us-ascii?Q?unwNB1PBJO5ffCd+sQFBU0fsZYaf9OU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR02MB8862.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99609f68-c48d-43f5-612f-08da1342aebb
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 18:17:14.5225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v2jONoYAW37RyUkabikZepl8OFHSqqGMVBesXmpJ85t3nOF3g+yB/+RKcz2VaX285JD1GZBZMAvnO99VqgY0CFQ383JW6BKOzk5T1BspJxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6066
X-Proofpoint-GUID: tq9DVKVwN4BdIXX7CfN-IG-4AfcmwtBz
X-Proofpoint-ORIG-GUID: tq9DVKVwN4BdIXX7CfN-IG-4AfcmwtBz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_06,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
     We have been getting a NULL pointer dereference in intel i40e driver.

[  105.551413] BUG: kernel NULL pointer dereference, address: 0000000000000=
00a

PID: 369    TASK: ffff980d62d70000  CPU: 16  COMMAND: "kworker/16:1"
#0 [ffffb0354e26fb00] machine_kexec at ffffffffae059db5
    /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244=
.x86_64/arch/x86/kernel/machine_kexec_64.c: 441
#1 [ffffb0354e26fb50] __crash_kexec at ffffffffae12584d
    /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244=
.x86_64/kernel/kexec_core.c: 957
#2 [ffffb0354e26fc18] crash_kexec at ffffffffae126ab9
    /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244=
.x86_64/include/linux/compiler.h: 292
#3 [ffffb0354e26fc30] oops_end at ffffffffae02a3da
    /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244=
.x86_64/arch/x86/kernel/dumpstack.c: 334
#4 [ffffb0354e26fc50] no_context at ffffffffae065ff8
    /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244=
.x86_64/arch/x86/mm/fault.c: 848
#5 [ffffb0354e26fcc0] do_page_fault at ffffffffae066ad1
    /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244=
.x86_64/arch/x86/mm/fault.c: 1552
#6 [ffffb0354e26fcf0] page_fault at ffffffffae801119
    /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244=
.x86_64/arch/x86/entry/entry_64.S: 1203
    [exception RIP: i40e_detect_recover_hung+116]
    RIP: ffffffffc07ae0d4  RSP: ffffb0354e26fda0  RFLAGS: 00010202
    RAX: ffff980d64e6a000  RBX: ffff980d5b788c00  RCX: ffff980d6f426e08
    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffff980d5b788800
    RBP: 000000000000003c   R8: 0000000065303469   R9: 8080808080808080
    R10: 0000000000000000  R11: 0000000000000000  R12: ffff980d62d86000
    R13: 00000000ffffffff  R14: 0000000000000000  R15: ffff980d64e6a848
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
    /home/mockbuild/rpmbuild/BUILD/i40e-2.14.13/src/i40e_virtchnl_pf.c: 725=
3
#7 [ffffb0354e26fdc8] i40e_service_task at ffffffffc078ff9b [i40e]
    /home/mockbuild/rpmbuild/BUILD/i40e-2.14.13/src/i40e_ethtool.c: 5000
#8 [ffffb0354e26fe78] process_one_work at ffffffffae09818b
    /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244=
.x86_64/kernel/workqueue.c: 2271
#9 [ffffb0354e26feb8] worker_thread at ffffffffae098ca9
    /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244=
.x86_64/include/linux/compiler.h: 266
#10 [ffffb0354e26ff10] kthread at ffffffffae09e378
    /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244=
.x86_64/kernel/kthread.c: 268
#11 [ffffb0354e26ff50] ret_from_fork at ffffffffae8001ff
    /usr/src/debug/kernel-5.4.109/linux-5.4.109-2.el7.nutanix.20201105.2244=
.x86_64/arch/x86/entry/entry_64.S: 352

-------------------------------------------

movzwl 0xa(%rdx),%edx fails as RDX: 0000000000000000  (offset 0xa from 0) c=
auses NULL pointer dereference
4:27
mov    0xe8(%rbx),%rdx program rdx, and %rbx is ffff980d5b788c00
x/x 0xffff980d5b788ce8
0xffff980d5b788ce8:     0x00000000, so %rdx gets programmed with 0.

crash> i40e_vsi.state ffff980d62d86000
  state =3D {0}
crash> i40e_vsi.netdev ffff980d62d86000
  netdev =3D 0xffff980d62d87000
crash> num_queue_pairs
crash: command not found: num_queue_pairs
crash> i40e_vsi.num_queue_pairs ffff980d62d86000
  num_queue_pairs =3D 64
All Tx rings
crash> x/64g 0xffff980d61f11800
0xffff980d61f11800:     0xffff980d61f11c00      0xffff980d61f12000
0xffff980d61f11810:     0xffff980d61f12400      0xffff980d61f12800
0xffff980d61f11820:     0xffff980d61f12c00      0xffff980d61f13000
0xffff980d61f11830:     0xffff980d61f13400      0xffff980d61f13800
0xffff980d61f11840:     0xffff980d61f13c00      0xffff980d61f14000
0xffff980d61f11850:     0xffff980d61f14400      0xffff980d61f14800
0xffff980d61f11860:     0xffff980d61f14c00      0xffff980d61f15000
0xffff980d61f11870:     0xffff980d61f15400      0xffff980d61f15800
0xffff980d61f11880:     0xffff980d61f15c00      0xffff980d61f16000
0xffff980d61f11890:     0xffff980d61f16400      0xffff980d61f16800
0xffff980d61f118a0:     0xffff980d61f16c00      0xffff980d61f17000
0xffff980d61f118b0:     0xffff980d61f17400      0xffff980d61f17800
0xffff980d61f118c0:     0xffff980d61f17c00      0xffff980d5b790000
0xffff980d61f118d0:     0xffff980d5b790400      0xffff980d5b790800
0xffff980d61f118e0:     0xffff980d5b790c00      0xffff980d5b791000
0xffff980d61f118f0:     0xffff980d5b791400      0xffff980d5b791800
0xffff980d61f11900:     0xffff980d5b791c00      0xffff980d5b792000
0xffff980d61f11910:     0xffff980d5b792400      0xffff980d5b792800
0xffff980d61f11920:     0xffff980d5b792c00      0xffff980d5b793000
0xffff980d61f11930:     0xffff980d5b793400      0xffff980d5b793800
0xffff980d61f11940:     0xffff980d5b793c00      0xffff980d5b794000
0xffff980d61f11950:     0xffff980d5b794400      0xffff980d5b794800
0xffff980d61f11960:     0xffff980d5b794c00      0xffff980d5b795000
0xffff980d61f11970:     0xffff980d5b795400      0xffff980d5b795800
0xffff980d61f11980:     0xffff980d5b795c00      0xffff980d5b796000
0xffff980d61f11990:     0xffff980d5b796400      0xffff980d5b796800
0xffff980d61f119a0:     0xffff980d5b796c00      0xffff980d5b797000
0xffff980d61f119b0:     0xffff980d5b797400      0xffff980d5b797800
0xffff980d61f119c0:     0xffff980d5b797c00      0xffff980d5b788000
0xffff980d61f119d0:     0xffff980d5b788400      0xffff980d5b788800
0xffff980d61f119e0:     0xffff980d5b788c00      0xffff980d5b789000
0xffff980d61f119f0:     0xffff980d5b789400      0xffff980d5b789800crash> st=
ruct i40e_ring.q_vector 0xffff980d5b788400  q_vector =3D 0xffff980d61c92800
crash> struct i40e_ring.q_vector 0xffff980d5b788400 =20
q_vector =3D 0xffff980d61c92800

crash> struct i40e_ring.q_vector 0xffff980d5b788c00
  q_vector =3D 0x0

So q_vector is not set after around 60 queues, yet in the driver we do a de=
ference
i40e_force_wb():
(q_vector->reg_idx) and die.

Gdb macro:
define print_i40e_q_vector
    set $vsi =3D (struct i40e_vsi *)$arg0

    set $q_vectors =3D $vsi->num_q_vectors

    printf "vsi %p q_vectors %d", $vsi, $q_vectors
    set $index =3D 0

    while $index < $q_vectors

        set $q_vector =3D (struct i40e_q_vector *)$vsi->q_vectors[$index]

        printf "num_ringpairs %d\n", $q_vector->num_ringpairs

        set $index +=3D 1
    end


end

Ouput:

crash> print_i40e_q_vector 0xffff980d62d86000
vsi 0xffff980d62d86000 q_vectors 64num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 1
num_ringpairs 0
num_ringpairs 0
num_ringpairs 0
num_ringpairs 0


Source code:

static void i40e_vsi_map_rings_to_vectors(struct i40e_vsi *vsi)
{
  int qp_remaining =3D vsi->num_queue_pairs;
  int q_vectors =3D vsi->num_q_vectors;
  int num_ringpairs;
  int v_start =3D 0;
  int qp_idx =3D 0;

  /* If we don't have enough vectors for a 1-to-1 mapping, we'll have to
   * group them so there are multiple queues per vector.
   * It is also important to go through all the vectors available to be
   * sure that if we don't use all the vectors, that the remaining vectors
   * are cleared. This is especially important when decreasing the
   * number of queues in use.
   */
  for (; v_start < q_vectors; v_start++) {
    struct i40e_q_vector *q_vector =3D vsi->q_vectors[v_start];

    num_ringpairs =3D DIV_ROUND_UP(qp_remaining, q_vectors - v_start);

    q_vector->num_ringpairs =3D num_ringpairs;
    q_vector->reg_idx =3D q_vector->v_idx + vsi->base_vector - 1;

    q_vector->rx.count =3D 0;
    q_vector->tx.count =3D 0;
    q_vector->rx.ring =3D NULL;
    q_vector->tx.ring =3D NULL;

    while (num_ringpairs--) {
      i40e_map_vector_to_qp(vsi, v_start, qp_idx);
      qp_idx++;
      qp_remaining--;
    }
  }
}

How in the above for loop=20
    num_ringpairs =3D DIV_ROUND_UP(qp_remaining, q_vectors - v_start);
evaluates to 0, is not clear.

Have we seen this problem before? If so, is there are fix?

Nucleodyne@Nutanix
408-718-8164

Nucleodyne@Nutanix
408-718-8164

