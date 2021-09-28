Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FE941A66C
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 06:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhI1EXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 00:23:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:15365 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhI1EXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 00:23:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="211700729"
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="211700729"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 21:21:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="476152443"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 27 Sep 2021 21:21:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 27 Sep 2021 21:21:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 27 Sep 2021 21:21:20 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 27 Sep 2021 21:21:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k97Knyu3YLzD6PpeOtQVT16izXv+tl7JPCRw4NaDOVo28r8Nx17RJrCcxV82xohaL1d5OCzAtYOnocfi3YwnNazF+7X3XkywZwwu+F8DmfZdUc/GclpS/fAPwApEuC9tj+XCAmRAW5iYQvB2FmbIBjhGmEywmn8spTbgg1jnAWNJKr4ubWrmEjzEP3qw7sixweCX6Q39zejz9ZRIjoicJUO7n6lb2LpgSATONDgaTpbSMc4vBYtCw64u4c49HotCDQmj+fMMs0Vx3fGPgzcnJkW1imGlwVGtP0roKjdcZnQWr06vbK5dtuD5Y0y+dOPtM3ypw1dFyrZ3qNF1JcbvyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3rAMGLQFr2ZRJxAbAYwZLfg0vqTXblWBx27I2XF6Dqo=;
 b=jmHZn4z3/0qLQGijk6824xF62hf4IMYa29PxjditPoQj+lLF6+atiAXKuc6DPRysJKha7kC/tByswAv8yDc+6ckhpGnnkIBiNjkMOsreNZXQ+b6QDobD2RVc2+tLC7c5LTNaHDQRF6v6jyTgvu79nbjemo7ZZ6eeeeTjxd0Tl+lVSLG6FJkX7an0mi4Mneo2lffexkT/lRlKBvdvcBdzXFJwaosydQc1lO4TDl1qKSGPD+rMAW8QcLsg3LmldlTPHIhbpiGB8xiDDvrLrehSimDBDjwZD69rRMEe/zErgL3Kzw4TbQZAzgRE4+ygS6NxdcpTmXILW44DSSL8q79G4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rAMGLQFr2ZRJxAbAYwZLfg0vqTXblWBx27I2XF6Dqo=;
 b=snKbAeR8zBldY7b1O7EOb3uuy5nkfEWeCuSPlh0pj6sSw6dtEM6Da6bH3m0a/PhSAEH+e6SrqhrfZda4wO2uyyqmSWhUJjB6whDonP2cjigNm8fi3pTlKo2laJQSA0K/Y99Zo/xrpzI1KKj/Mx8a/7cBB170l/SdHoRbXt4wQDU=
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 04:21:13 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::a8a8:6311:c417:ebdf]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::a8a8:6311:c417:ebdf%7]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 04:21:13 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     Feng zhou <zhoufeng.zf@bytedance.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
        "chenying.kernel@bytedance.com" <chenying.kernel@bytedance.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "wangdongdong.6@bytedance.com" <wangdongdong.6@bytedance.com>,
        "zhouchengming@bytedance.com" <zhouchengming@bytedance.com>
Subject: RE: [Intel-wired-lan] [PATCH v3] ixgbe: Fix NULL pointer dereference
 in ixgbe_xdp_setup
Thread-Topic: [Intel-wired-lan] [PATCH v3] ixgbe: Fix NULL pointer dereference
 in ixgbe_xdp_setup
Thread-Index: AQHXqgARPe10IxtL/0exW61B+339qau47EmQ
Date:   Tue, 28 Sep 2021 04:21:13 +0000
Message-ID: <MW3PR11MB45543254E1F9F87512A25A6F9CA89@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20210915070440.6540-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20210915070440.6540-1-zhoufeng.zf@bytedance.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d851acdb-e5b8-49e1-0be2-08d982376860
x-ms-traffictypediagnostic: CO1PR11MB4914:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4914ADAC4FCD2EE7709ECC029CA89@CO1PR11MB4914.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ymd3o/U5Vq8v3VsTShrh5ECr3Im9dhWbeIMFUIplP3J6FSE9BvvBuOW2jzc0UylaJPHEnunGc5l2qujUcPqhLVGZpDpCD1z4ZQHifWXJF+9Q4FulFSvc/MInBFFzExyFED09IlQPsglBgecucp4QbIfX+KUUgqYKmu0QsVN5rmC7C4ksHDfE0Dj6UdUquNtb0P3Ohe8zL1LXUXahqjQMq7ZNT+GhyLqTixL/fjAgmrZmnReHlPtcpwPgua9NbWk7JK6mptOm3LhBCHSSCecrQGTUDhCVWOgprALFN02wx/kcuLLUqgvE8cYoDQ9P6GTMCHNuuLBqhHGpBRQRpXscUQLRyN7Oe+Gj69REXZbGSqSBDHUl4kPkMRbX6m2AyHiZYS8K/Z6HUIvtdjuKZ4aplL2EUOuRGnvJyQgINWwkOEUhmy/tet6I1ePXYytzbie64HkHROC/0NVwfrodyrHmuc7PTJEj+whBFcc4+PqIzodBGL0M4ML1CIjJ0ftiHb0vgxcAg0Nvbjw0AuPluG3GYF7TI6WQJIEoLYUfawAYEoZs3X/yePrw4RFLZftCog8qPQM0R4c9gf4szmA5pXloCIT13bqf6jDoV9vJbtAOUE4MWd1tOXDEpkYNLfr2kXCr1wH5L/Ol4lXZ+ErIMorTirs2ryj3c1/+iQQoHNrPWVVnmIc8/F7BjTQpFkWAoxSU3uMXr0S8ojR6xCz9Rd2ENeTT6XP3r8IRH8GrdKHONc8XFXLFobD++yC1hX101BBMhJRtOn/FnahVEokWr8fT7iuxM8mFfNfsreRbDpiVXZUrINiW6sl/GOHR9G051QhuigyhoEn61oynPtX9UPWx/x7FOUoyksEzPFKYBmIr/wQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(83380400001)(54906003)(86362001)(26005)(9686003)(8676002)(8936002)(122000001)(7696005)(110136005)(508600001)(55016002)(52536014)(71200400001)(66446008)(66556008)(66476007)(2906002)(64756008)(66946007)(6506007)(186003)(4326008)(38070700005)(921005)(33656002)(6636002)(316002)(38100700002)(76116006)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gL0UoDRKyf7YmHgWl8ALomvooPf09bgB8Tj+aHFb+JbsV8ZzwPI8Gz6cY0TQ?=
 =?us-ascii?Q?HiIUXwCTZ8t0woxbfTzBLzgFrfEwsTBh7q9Hiz+yAZvFqhDwOC07JNjQy5O4?=
 =?us-ascii?Q?JuMFjsOIFj/qALZEc8ub5Zb2I5F5nBHY2+KlLw86Zcwdbkt+5l3fGUuWkYqr?=
 =?us-ascii?Q?Gnlzun5sIef3PssiXWL5bZ6G60PbfSr/wqUrGBbzZXM7ZVEXqRnpT5pT4O2p?=
 =?us-ascii?Q?dXBBFR0xRXim6ci9AFATp+qo7lhD2h+LUEyMY3CbOuYOw8VtDhWOC1YlDG2X?=
 =?us-ascii?Q?g0iZTeSDeCWBK57MSgBQScCjPA3rtrHMTcC+01ubVitzGpuOnv9D87h2qflA?=
 =?us-ascii?Q?/67jDnMRhQ5t5sd8a3iGxY0KCIyNHJsugaPX1zQCfwJXXY7/xTyHo8kPQUX/?=
 =?us-ascii?Q?C4Q8e1V5NtlhKgVkKCmMmDCotoihDks0+ifyDL1RT7iBQ4yc4Y+tSDzrWJr/?=
 =?us-ascii?Q?8BC83fPAEkjRW2+Py2n6NVgQQS9rBPPT6F//axxCtm1Dc9ED3SSQb2GxuTX1?=
 =?us-ascii?Q?DuGwsCreHCP2hygLth2Dr/xHMeyWtAnk9Bw9yQpnn/5bCToTW0htOpg6LFwX?=
 =?us-ascii?Q?jqgs/Ev+dZb1Y6LKVEzBNpyyjg4fHv/8YhjS3wrxj+cH/TT95F5ltg6UYSfr?=
 =?us-ascii?Q?AabnSrY02qIkJyiZCFdfI/6dNazvb3TwW77jiYze4OALtULmJg1evGfVD7vU?=
 =?us-ascii?Q?ld9MI/fgpzbfarbg3bKyFG71kS7uuj4aTbKrRXUiTjOKK2UfNi+aP9M19lP1?=
 =?us-ascii?Q?RKGneKBSf42qpUrvWYnvUAb8k9HfBtSO/D5EPpQ401d7YpCqvwo8L36JlMKu?=
 =?us-ascii?Q?h1iwHcnS7NYnXd6l/JN4z4NM3IjTtX+2zH7IeBmdtSPOPdcaukR+pVw6fNf1?=
 =?us-ascii?Q?M3upv/m2r7xnN5PeKhuBFLuPdeCxgyl6IlKLdT9UYY8La+tHOK6bntWWmtLH?=
 =?us-ascii?Q?e6sAYgfTxQw9/sR0XXHoduas+gf2j5vEoGDLSTMiL3ymBpDc4FBFwBfscwTc?=
 =?us-ascii?Q?zx2iyKrY7CYhPbeToOlRfXfSjUiA+xxvsGc28iNqq4mUfF3ebYvIb1Kc/jrQ?=
 =?us-ascii?Q?ELuGfgxafEhv4GucMGjuUq1kVZPnDmeSNygkefMMCyRi+o/u3b8tZekV3hYl?=
 =?us-ascii?Q?HRHITox1skk3ZySC0snCYpwrytADuzZpDmQM6b82juP1wZTc+aW2/R8NmaEX?=
 =?us-ascii?Q?4MWkQ4LiM4W14izBejMS+QrSgnA9dnj2Uv+VCYcqaqNpYs2LAzhGuRr8JVXT?=
 =?us-ascii?Q?Swrs2x/t5dSgm6sriN0Q1WUVo66uCZz63n8LQWfS5P/ur/Et5EF3VOK4s1Ob?=
 =?us-ascii?Q?xBX6sQmQ1QrGwTuRwFWv5UdC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d851acdb-e5b8-49e1-0be2-08d982376860
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 04:21:13.4198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +A+zvKiqlDOXH+aXgrrW1QcNVa58ernEz3a4u7fPzyveQJ4NfsOSRjXwJnSuOMLUXAXPGuJ1uyaemleFcrslWi5d+/qLHnQv7u2wjwz38dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4914
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Feng zhou
>Sent: Wednesday, September 15, 2021 12:35 PM
>To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
>ast@kernel.org; daniel@iogearbox.net; hawk@kernel.org;
>john.fastabend@gmail.com; jeffrey.t.kirsher@intel.com; Karlsson, Magnus
><magnus.karlsson@intel.com>; Fijalkowski, Maciej
><maciej.fijalkowski@intel.com>
>Cc: duanxiongchun@bytedance.com; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org; zhengqi.arch@bytedance.com;
>chenying.kernel@bytedance.com; intel-wired-lan@lists.osuosl.org;
>songmuchun@bytedance.com; zhoufeng.zf@bytedance.com;
>bpf@vger.kernel.org; wangdongdong.6@bytedance.com;
>zhouchengming@bytedance.com
>Subject: [Intel-wired-lan] [PATCH v3] ixgbe: Fix NULL pointer dereference =
in
>ixgbe_xdp_setup
>
>From: Feng Zhou <zhoufeng.zf@bytedance.com>
>
>The ixgbe driver currently generates a NULL pointer dereference with some
>machine (online cpus < 63). This is due to the fact that the maximum value=
 of
>num_xdp_queues is nr_cpu_ids. Code is in "ixgbe_set_rss_queues"".
>
>Here's how the problem repeats itself:
>Some machine (online cpus < 63), And user set num_queues to 63 through
>ethtool. Code is in the "ixgbe_set_channels",
>	adapter->ring_feature[RING_F_FDIR].limit =3D count;
>
>It becomes 63.
>
>When user use xdp, "ixgbe_set_rss_queues" will set queues num.
>	adapter->num_rx_queues =3D rss_i;
>	adapter->num_tx_queues =3D rss_i;
>	adapter->num_xdp_queues =3D ixgbe_xdp_queues(adapter);
>
>And rss_i's value is from
>	f =3D &adapter->ring_feature[RING_F_FDIR];
>	rss_i =3D f->indices =3D f->limit;
>
>So "num_rx_queues" > "num_xdp_queues", when run to "ixgbe_xdp_setup",
>	for (i =3D 0; i < adapter->num_rx_queues; i++)
>		if (adapter->xdp_ring[i]->xsk_umem)
>
>It leads to panic.
>
>Call trace:
>[exception RIP: ixgbe_xdp+368]
>RIP: ffffffffc02a76a0  RSP: ffff9fe16202f8d0  RFLAGS: 00010297
>RAX: 0000000000000000  RBX: 0000000000000020  RCX: 0000000000000000
>RDX: 0000000000000000  RSI: 000000000000001c  RDI: ffffffffa94ead90
>RBP: ffff92f8f24c0c18   R8: 0000000000000000   R9: 0000000000000000
>R10: ffff9fe16202f830  R11: 0000000000000000  R12: ffff92f8f24c0000
>R13: ffff9fe16202fc01  R14: 000000000000000a  R15: ffffffffc02a7530
>ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> 7 [ffff9fe16202f8f0] dev_xdp_install at ffffffffa89fbbcc
> 8 [ffff9fe16202f920] dev_change_xdp_fd at ffffffffa8a08808
> 9 [ffff9fe16202f960] do_setlink at ffffffffa8a20235
>10 [ffff9fe16202fa88] rtnl_setlink at ffffffffa8a20384
>11 [ffff9fe16202fc78] rtnetlink_rcv_msg at ffffffffa8a1a8dd
>12 [ffff9fe16202fcf0] netlink_rcv_skb at ffffffffa8a717eb
>13 [ffff9fe16202fd40] netlink_unicast at ffffffffa8a70f88
>14 [ffff9fe16202fd80] netlink_sendmsg at ffffffffa8a71319
>15 [ffff9fe16202fdf0] sock_sendmsg at ffffffffa89df290
>16 [ffff9fe16202fe08] __sys_sendto at ffffffffa89e19c8
>17 [ffff9fe16202ff30] __x64_sys_sendto at ffffffffa89e1a64
>18 [ffff9fe16202ff38] do_syscall_64 at ffffffffa84042b9
>19 [ffff9fe16202ff50] entry_SYSCALL_64_after_hwframe at ffffffffa8c0008c
>
>So I fix ixgbe_max_channels so that it will not allow a setting of queues =
to be
>higher than the num_online_cpus(). And when run to ixgbe_xdp_setup, take
>the smaller value of num_rx_queues and num_xdp_queues.
>
>Fixes: 4a9b32f30f80 ("ixgbe: fix potential RX buffer starvation for
>AF_XDP")
>Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>---
>v1:
>- Fix "ixgbe_max_channels" callback so that it will not allow a setting of
>queues to be higher than the num_online_cpus().
>v2:
>- Modify commit message
>more details can be seen from here:
>https://patchwork.ozlabs.org/project/intel-wired-
>lan/patch/20210817075407.11961-1-zhoufeng.zf@bytedance.com/
>https://lore.kernel.org/netdev/20210903064013.9842-1-
>zhoufeng.zf@bytedance.com/
>Thanks to Maciej Fijalkowski and Paul Menzel for yours advice.
>
> drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 2 +-
> drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    | 8 ++++++--
> 2 files changed, 7 insertions(+), 3 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
