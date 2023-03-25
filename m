Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28A66C9007
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 19:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCYS3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 14:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYS3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 14:29:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74FCC170;
        Sat, 25 Mar 2023 11:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679768951; x=1711304951;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RqTvlCZxs33lRXJx2qnAk7mPpEBQgnBZ9gfd6ASiioA=;
  b=VIgymKlAlhZBLId1Rt7whkHMO4a3DR8X3DV59WVJrVMEHJMdXrjkFXMA
   tFaJDcTqbVsXtgS6++7UxonetyUutOnD6Lzk3MEsZ8PNX7NWgpbnGCM17
   unkpNzzWia/RwK6AQRwolYWcXKVFKv1HKLhqBs8EncWG8fmaLbZV9x70W
   Xvy1Rh4bVSVOb4uGhWEpSxyYxWNgugs156iu3adYOqyTtkOXAHPWw7Opw
   lQ008ajKLe41HndUo9tKtuxEq+18JfmOYISPen5kcnUQZKwzd9qdk538y
   r7DCYvB/hlyupBM5eB+8bvH994DzwWuCcTLROjkkcCBAIPpqAP0zTDuaJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10660"; a="402599453"
X-IronPort-AV: E=Sophos;i="5.98,290,1673942400"; 
   d="scan'208";a="402599453"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2023 11:29:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10660"; a="807028078"
X-IronPort-AV: E=Sophos;i="5.98,290,1673942400"; 
   d="scan'208";a="807028078"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 25 Mar 2023 11:29:10 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 25 Mar 2023 11:29:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sat, 25 Mar 2023 11:29:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sat, 25 Mar 2023 11:29:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B65XLceVOJ3E0D5h2gaykyvACFeYDILhLUmPx85PK172/h19zaXjWf3Qy4fWeU+X1GpmNzw0vNaWWEH9jAJnNsu6qHbtaMyt/k0RNB4o9D35//7sM5W82zefOCN2gqtqBSqOeiFO+63DwRAmsCfDUeSmoKAMaWwuHGHktTtTaQvneRL3wOZ5PqNZDTN7aGbilMLUgV9+LXDRd+Qmpsz5jwfDApUJmjkxnYihK707yucu2b79XhMfvjPCv1CyQTcnxg0AUtCEXYvXhYxH2SH+1J5Sm44q7b2NE3Gnl92xfj2PbAEGFRoCsDAGlJ1BdM/0oCX0SeZ4Jju7VZc9zdhj4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zc25Fd8I2SzHQ2ais9i8r9YCAIcmMvMV6HDC7yOJkg=;
 b=Ex8kVJZOgc93FMVVe23RFBHfHf1hxdIDyoA6GiwTG54JsjpVpMrpeLGJ1EQNTg4k7hC/wdAsJIu14YEURcvcjlbtYSrRfoZYbfmknKtTTD3s+SLcrsZbItzwMiwUDQAmWv/ia2vIZD5t5ZWZoO5aEgLVg2q4/N1WVC78vERyEHvuKWtycujyB2sPSfV2v1aAgTE5ctgsfddLbL1/WoK8O+tE51qR4feIcKS2/xCL0mD6JC7lm6zRD9z3/bKf2R9AN6P1ut5P3Ty53ldv/AioMMaxo8jpkKiUUZE5MMWKNBRW1Ura59Kop6I4UP0PpkeXsKXyQxNeM+KxKpolP5vjjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by CY8PR11MB7340.namprd11.prod.outlook.com (2603:10b6:930:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sat, 25 Mar
 2023 18:29:06 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6515:e7bf:629c:e141]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6515:e7bf:629c:e141%3]) with mapi id 15.20.6178.038; Sat, 25 Mar 2023
 18:29:06 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     John Hickey <jjh@daedalian.us>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Shujin Li" <lishujin@kuaishou.com>,
        "Xing, Wanli" <xingwanli@kuaishou.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>
Subject: RE: [PATCH net v3] ixgbe: Panic during XDP_TX with > 64 CPUs
Thread-Topic: [PATCH net v3] ixgbe: Panic during XDP_TX with > 64 CPUs
Thread-Index: AQHZUgq6zOvPojcFKkWWWW4VXRvR9K8L6nbQ
Date:   Sat, 25 Mar 2023 18:29:06 +0000
Message-ID: <MN2PR11MB40453E93415576B08273306CEA859@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20230308220756.587317-1-jjh@daedalian.us>
In-Reply-To: <20230308220756.587317-1-jjh@daedalian.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|CY8PR11MB7340:EE_
x-ms-office365-filtering-correlation-id: 006c1561-e7d9-4933-159e-08db2d5ed11e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DVIZwO1AxR20XuK9fNZakXMQ3haaDK4/SnGyAnw0NFSBQgAzaT4y1iAmgVYkj3w21hw6+g4har0QCnc6MCyyq2hECwDfnCDNT+sUyS30V2AXdoE75PUP7GxDX0GMjEePf4KIig7DXn9rsdXSlvbWkOUVPKyppNI0oKOS78tEZFbjewIFMt3gniNFq+weh939HIaq/HYUuOnz5iC2Ap9ACCuML0SCdKbn9vuCQH1YRk5m5t6pR/nYXOZ/D9C2OuTlFbl9diFZW/h3VzJNBVYHdEFSRhmBHuujZrhdaPAt02xGU5kL+/LFEPyCUggQOtMEtPcxnx72TShe/Bb71lzCay2uJEcVzvWEqPU+o1HF132oBbTUPoqJwYUc3SxON/LZYtB9x7abKoyxKB1cf1Y2taF/CNTb4GMND14quozZj9BJUOLjuqsgLwS4lasGcOxO7du/LMWLjRHKE/mmFvNFgJRn6jUXKc3xVnsqENOMebQpcqoZws3yu4Q5fsPmeEjTGr5ZHJeLWJdgwqldxdenk6ND5RG2GVrDfgBzC0U4VMEaHxtOtkzvoxLHSa1paYmwQ4qZxj0NR8gvVoaPuFsWjVMhuwJ+blCL4gT7g9X4cmbI1NbCEztTUCcgNEztmbt5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199021)(41300700001)(54906003)(8936002)(71200400001)(55016003)(82960400001)(122000001)(107886003)(478600001)(52536014)(38100700002)(55236004)(26005)(5660300002)(6506007)(7416002)(8676002)(83380400001)(2906002)(9686003)(4326008)(66556008)(76116006)(186003)(66476007)(66446008)(66946007)(64756008)(86362001)(110136005)(316002)(38070700005)(33656002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?D7s4EXaoy6OUItaszDhcYrVVmqhuVSRc3axOgN6o33/F4zAuYbJ5S061af7G?=
 =?us-ascii?Q?UTsUgA+GAboZpp615Coj3/ms8K/B2sFmaLZTjRNwQG5z2+82oS/H3iKg1tXX?=
 =?us-ascii?Q?18tcQABX+e8kvX2whaaIzyLbrBBNXq00UzZdTT2zPLJF2XnAWMyWgDq9St0B?=
 =?us-ascii?Q?152+dGPkS0xffxRAVHXzUK54MoKMW/rpmsmAgOmpBghhFYVsQaDS3mWG19gg?=
 =?us-ascii?Q?HMw6rHJC3GYD6puw6hcIn1PeEIgbHA2Qp4BG9gWxqt7x2eFkHmN+UOdgmwQ0?=
 =?us-ascii?Q?WsZyohDdTt6c20CMAMVmT/PqlXrqo/rUdctw0wlndDF8W2IsR17f/i9eP+El?=
 =?us-ascii?Q?Ausq8U4fNANipOyohAjYH5UufGcOW+yVTcl5w6Wjcbc1qPc2Te88PEPk3AYl?=
 =?us-ascii?Q?43VMWyGkiwhDtlveq0hv0vOiSWbDLsHeHDM8NSkEXs9zVQQa8rJnavCs0ptJ?=
 =?us-ascii?Q?c6vb084SOVSrPUPDUU4QZsUrPYLGZIW3jQ2ZkTbMIVugnvVpGduGsnlGDHk5?=
 =?us-ascii?Q?aFeuOQWZljol5LrbXIj7MEsecD8Qek9Yu5mQwNXTCy0K8oW+gcBvaI9RIYb+?=
 =?us-ascii?Q?7XpSIFjoofO4V/XFrgRPLwSB/RSBeGcGQICgk9xbJHSOTrVkABRbmnVE62Hk?=
 =?us-ascii?Q?GYKrUS3JYCf5E45oWlbm/hb9sY0Ox8ooHmd9WJUJchdYH5DNlSihnNvYIXdh?=
 =?us-ascii?Q?uRxQGrYssVE8asGEedUtIYwTgU6HKhuYeaGpZucrJjhtB/SCzVKA4C4X8GUA?=
 =?us-ascii?Q?jSgSnRVAAe6FjvSu6zb4+qmFQKPV1JOPRtYBPIrg7CKLDq4rg8HdwZwEL0fe?=
 =?us-ascii?Q?drVMKJo3wIGasz/0e99xjY2jqBftpxNVZdr2Vg0vm6b3B9Dt6Huf3+HN6aPv?=
 =?us-ascii?Q?Fz8gXMF2r3aVu7mb5yKhAtGKIzHQjWwdIdw6KqQvpVOcTfSo+qPdMD6VjFTm?=
 =?us-ascii?Q?He8Q+//1LX4hSIqM5C0eG0wQx4afXfIW1eG7jEUVaTOAJNw01FaC/Lr+Fp4C?=
 =?us-ascii?Q?3WI+KHSIZL8ONy7ELrBDPWOTluy6uUI/495ZVkpKSrOQAmpOSo7H4oAEgDgl?=
 =?us-ascii?Q?2RpHmNIDK57BEP95J+hhn4nCbj5JR7vytb10bl6s1W+6CbCNnnV99sWRmQDa?=
 =?us-ascii?Q?ftVCIqvwhN9rEd8aJFU8o7UInQngBW338ewOwSgKdB195N4R13Lx5SJbI015?=
 =?us-ascii?Q?UoERQI0CAeNdHfSJ+rOenW7EiFk/FNlb3xj5Dg7qskE9ZOASThFGFwcqoBOR?=
 =?us-ascii?Q?7m9mK8bO5U3SJrYJhC6EiWjbTgfXKTjCP2EaybpS2x/nFZ/cu1noNS+H8y59?=
 =?us-ascii?Q?ejmYFcBCEDvs3Ut23bCutcMNb7YeHkAHYudrFoGEdcLzWiiA4dsfjoWxhxMk?=
 =?us-ascii?Q?9fd8yjfaURjKAF4AD6VL8wOvLd/yrZdyR5EQjzMg60bBWlvc9PFBUCWx3lHO?=
 =?us-ascii?Q?baK8IyUmcO9it7yfbxbf8FG9sfLrlw8aDLi5evxJqcBVDy/aNKF/1mHdhQ43?=
 =?us-ascii?Q?DdxQ+9rKXV4qjBPI8NuVRNtiY92pIX1JHEyIBkwNDKGRWWj4mM1/mLfJGVrv?=
 =?us-ascii?Q?enCpK8yVNpzi4PJC2Oy699DSKk6oanUMc7qVM6TL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 006c1561-e7d9-4933-159e-08db2d5ed11e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2023 18:29:06.1486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6PySIaVncvwbnh9mfCwt428yZRGF0Cpnye6q+66jSRI592Qt3dQNhdEjzHraaIaD5azWfm1SUp1mh0kjQuS52Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7340
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: John Hickey <jjh@daedalian.us>
>Sent: 09 March 2023 03:38
>To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
>Cc: John Hickey <jjh@daedalian.us>; Brandeburg, Jesse
><jesse.brandeburg@intel.com>; David S. Miller <davem@davemloft.net>;
>Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
>Paolo Abeni <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>;
>Daniel Borkmann <daniel@iogearbox.net>; Jesper Dangaard Brouer
><hawk@kernel.org>; John Fastabend <john.fastabend@gmail.com>; Shujin Li
><lishujin@kuaishou.com>; Xing, Wanli <xingwanli@kuaishou.com>; intel-
>wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org; bpf@vger.kernel.org
>Subject: [PATCH net v3] ixgbe: Panic during XDP_TX with > 64 CPUs
>
>In commit 'ixgbe: let the xdpdrv work with more than 64 cpus'
>(4fe815850bdc), support was added to allow XDP programs to run on systems
>with more than 64 CPUs by locking the XDP TX rings and indexing them using
>cpu % 64 (IXGBE_MAX_XDP_QS).
>
>Upon trying this out patch via the Intel 5.18.6 out of tree driver on a sy=
stem
>with more than 64 cores, the kernel paniced with an array-index-out-of-
>bounds at the return in ixgbe_determine_xdp_ring in ixgbe.h, which means
>ixgbe_determine_xdp_q_idx was just returning the cpu instead of cpu %
>IXGBE_MAX_XDP_QS.  An example splat:
>
>
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> UBSAN: array-index-out-of-bounds in
> /var/lib/dkms/ixgbe/5.18.6+focal-1/build/src/ixgbe.h:1147:26
> index 65 is out of range for type 'ixgbe_ring *[64]'
>
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: kernel NULL pointer dereference, address: 0000000000000058
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page  PGD 0 P4D 0
> Oops: 0000 [#1] SMP NOPTI
> CPU: 65 PID: 408 Comm: ksoftirqd/65
> Tainted: G          IOE     5.15.0-48-generic #54~20.04.1-Ubuntu
> Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 2.5.4 01/13/2020
> RIP: 0010:ixgbe_xmit_xdp_ring+0x1b/0x1c0 [ixgbe]
> Code: 3b 52 d4 cf e9 42 f2 ff ff 66 0f 1f 44 00 00 0f 1f 44 00 00 55 b9
> 00 00 00 00 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 <44> 0f b7
> 47 58 0f b7 47 5a 0f b7 57 54 44 0f b7 76 08 66 41 39 c0
> RSP: 0018:ffffbc3fcd88fcb0 EFLAGS: 00010282
> RAX: ffff92a253260980 RBX: ffffbc3fe68b00a0 RCX: 0000000000000000
> RDX: ffff928b5f659000 RSI: ffff928b5f659000 RDI: 0000000000000000
> RBP: ffffbc3fcd88fce0 R08: ffff92b9dfc20580 R09: 0000000000000001
> R10: 3d3d3d3d3d3d3d3d R11: 3d3d3d3d3d3d3d3d R12: 0000000000000000
> R13: ffff928b2f0fa8c0 R14: ffff928b9be20050 R15: 000000000000003c
> FS:  0000000000000000(0000) GS:ffff92b9dfc00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000058 CR3: 000000011dd6a002 CR4: 00000000007706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  ixgbe_poll+0x103e/0x1280 [ixgbe]
>  ? sched_clock_cpu+0x12/0xe0
>  __napi_poll+0x30/0x160
>  net_rx_action+0x11c/0x270
>  __do_softirq+0xda/0x2ee
>  run_ksoftirqd+0x2f/0x50
>  smpboot_thread_fn+0xb7/0x150
>  ? sort_range+0x30/0x30
>  kthread+0x127/0x150
>  ? set_kthread_struct+0x50/0x50
>  ret_from_fork+0x1f/0x30
>  </TASK>
>
>I think this is how it happens:
>
>Upon loading the first XDP program on a system with more than 64 CPUs,
>ixgbe_xdp_locking_key is incremented in ixgbe_xdp_setup.  However,
>immediately after this, the rings are reconfigured by ixgbe_setup_tc.
>ixgbe_setup_tc calls ixgbe_clear_interrupt_scheme which calls
>ixgbe_free_q_vectors which calls ixgbe_free_q_vector in a loop.
>ixgbe_free_q_vector decrements ixgbe_xdp_locking_key once per call if it i=
s
>non-zero.  Commenting out the decrement in ixgbe_free_q_vector stopped
>my system from panicing.
>
>I suspect to make the original patch work, I would need to load an XDP
>program and then replace it in order to get ixgbe_xdp_locking_key back
>above 0 since ixgbe_setup_tc is only called when transitioning between XDP
>and non-XDP ring configurations, while ixgbe_xdp_locking_key is
>incremented every time ixgbe_xdp_setup is called.
>
>Also, ixgbe_setup_tc can be called via ethtool --set-channels, so this bec=
omes
>another path to decrement ixgbe_xdp_locking_key to 0 on systems with
>greater than 64 CPUs.
>
>For this patch, I have changed static_branch_inc to static_branch_enable i=
n
>ixgbe_setup_xdp.  We weren't counting references.  The
>ixgbe_xdp_locking_key only protects code in the XDP_TX path, which is not
>run when an XDP program is loaded.  The other condition for setting it on =
is
>the number of CPUs, which I assume is static.
>
>Fixes: 4fe815850bdc ("ixgbe: let the xdpdrv work with more than 64 cpus")
>Signed-off-by: John Hickey <jjh@daedalian.us>
>---
>v1 -> v2:
>	Added Fixes and net tag.  No code changes.
>v2 -> v3:
>	Added splat.  Slight clarification as to why ixgbe_xdp_locking_key
>	is not turned off.  Based on feedback from Maciej Fijalkowski.
>---
> drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 3 ---
>drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
> 2 files changed, 1 insertion(+), 4 deletions(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)

