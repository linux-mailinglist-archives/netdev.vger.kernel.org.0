Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B274962F74E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242284AbiKRO30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbiKRO3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:29:24 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F62E5DBA9;
        Fri, 18 Nov 2022 06:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668781763; x=1700317763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e6PJ+XMP73JRtXkEyhPqJLlYY+Y9cGJ4/6pojagtX7A=;
  b=jU3xV8MW/NnKjtFm0waEI4XN+HoJNfvxxyNzCIEfxNhIJnYHQUlNrfXL
   hrO+be5TPF1rt+cCVDiSdWifXvubNJklK2/2Yy7j9yD99myJyHcO5b2yR
   b59mcGx7bpGI/yib2ElQk783Imhcu3MauM6fNJ/oipaZs0M/TPaMm83JP
   WLRlaFk1s9UA+8V+qNMr4Y+wTAxokZ7u7XEWFdWjSIxMx2w0GQVf1vaRb
   iQN7zaWpZpSGmD1nmbedy5bJjeWPXoZE6PcDnywcn4jKE/UFc1GVSTOM1
   dQo70/YZwkatQxvyjGGL/tqJQI+JC/ZhyIoXUdKPTJ9aWVIQ/QYxHswb+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="377411190"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="377411190"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 06:29:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="634442736"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="634442736"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 18 Nov 2022 06:29:22 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 06:29:22 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 06:29:21 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 06:29:21 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 06:29:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3GUyKwiRCeEAmcXTAJEMkUCJ3g9lnbzP+yd9h03caf2lSD8MhhYRT0Op8AlqVXg8iz0+3SMJ6wj2+SNZPUz/eDfHRJeVALS48loUL1EVxGJWqJ8nddrgoAFElCCYZuvDwdtmVRncRrznb0yp4Sq17YYhaYbpT+HbcbtP545zsAZTuVwzoRI9SgO6UiIu23zwELk067rX4NQNHwng2iWKa5qdGFrxKBDwIUns3FcHMC/zHdYd8rA0KVVdqwnTBIcIOpfBE3ss89mVaMWmYdoD6MfTW545VqcgLLzqVPZShw58MImrq6VydySm4z8Rqm7xeQTwKP6StI5G5MIrHD6Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UlLIDKRoSkZNZxY/v84XydpU5Km8Q+ycHPTXmNyvg4=;
 b=ifnXQKhZHGww59UNXBUgh3RvgQQ+Z6ArkHciuEnfOz15H+vyXVM6IcmED+aZ5XoGTpbWnrCgrbXe7IDQQr2vPUlpT+B7tBxfcholooFxGEy3vP0xG3AREP4wukyCvaAiYyPgJYukHoMmR5w9pNnCYd4iJP796g/AX0ZIlGOMgD5aou1IIP5aloMN6AWvdXIIj+O661fC649uYRkOGUO9jslrqB93S/9DQ1TMPvXe3bx/awiSJXwlNpik8R/h5l4kioFOMBOwwAuV76HZaj4cYj1oJOzq9sTE3IBCriQu2Fhem5K3/u9XfGEzie8DwSAJKFCB11M/ZrytLhDbSkE50g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 DS0PR11MB7288.namprd11.prod.outlook.com (2603:10b6:8:13b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.19; Fri, 18 Nov 2022 14:29:09 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::9f29:9c7a:f6fb:912a]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::9f29:9c7a:f6fb:912a%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 14:29:09 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     SlawomirX Laba <slawomirx.laba@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [Intel-wired-lan] [PATCH net] iavf: Fix a crash during reset task
Thread-Topic: [Intel-wired-lan] [PATCH net] iavf: Fix a crash during reset
 task
Thread-Index: AQHY81Wo7vJxCL1y7EygrMfUJmu5d65EzX6A
Date:   Fri, 18 Nov 2022 14:29:09 +0000
Message-ID: <DM8PR11MB5621099FB651DCCD091E3E2BAB099@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20221108093534.1957820-1-ivecera@redhat.com>
In-Reply-To: <20221108093534.1957820-1-ivecera@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5621:EE_|DS0PR11MB7288:EE_
x-ms-office365-filtering-correlation-id: 126dce35-082e-479c-c62d-08dac971419b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hS6VWeDvF2zFN/calKHgkp8UFFeB5iJpSPtp8s8+IVKiDkZrFriv5pK/NXJ68hPzOooLjgjGTqFiVFcfHhLasDTG3kIibX5xRkShggVZ/6PI0HsOeMzixdyzLnSCwvwqk8hbV2BeS2aM6IPOpA25SFeWyZaaPoj2tCS1jbwNTeAAjEy/aCTNIT0s17ZkITmeElziirEHIq7np8fXvWVdF5zNq2wXuc4nf6BPqapBOhI1VSuSQt8rnLBS+4gtj5wO5zrMnROsT8DP2R5l+xSwOc48LzrKsgkvBAD1RJj6b05I8xn7LbL4SDuEPNT5GD9sJjG40c1ETJdMiffjJ3cxiiuQKM/MpfZTpWN0bz1h0EL7iC3bBG+UxaR1nsUzHcILrwGD4XNKEfB2Qt70j6+/InIev2wQEvIw7GrDU94+Jvy0OYhp8sD9KUgl+GL8CMMnhP66kmYLMfrQrdWmzCl2bz/QaHQbId2oxMzGZPMm+DpcT1LPVc2fn+bh++f7C1/2k4E/sfUrRRM4sVfRbg4ENPWM6SNJRlojXZPWY+Ff4SjiRT+YpmZeQHOUr/H1Jp2KH3D6EGy1VP+ILh+3Ky67fw9YX3Sbd9zSGQ64AOSOBnA00khfwU8r6sqsEu7++bm4ZpfX8n90gvb5JFMZ53eJqu1cZIEWxIDuk0tYKkumah2kewo+/ShyAb2YwEFVaST/GsQbnAJTEbHZb1udaKGwkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199015)(478600001)(71200400001)(4326008)(26005)(110136005)(9686003)(186003)(66946007)(316002)(7696005)(64756008)(66556008)(66476007)(8936002)(66446008)(6506007)(5660300002)(52536014)(41300700001)(33656002)(76116006)(53546011)(8676002)(2906002)(38100700002)(82960400001)(86362001)(83380400001)(55016003)(122000001)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cWk6DgCqUhxiaGkkgtVPy5NRFPtUF/9mv1/1kZwGJvNIpGu8r35DXey77a7j?=
 =?us-ascii?Q?iaF6jCo6z/4Gvknc+UtuflO/On6Zf31Vb6b1ged5EpIslS5RoXqumq1DRgM5?=
 =?us-ascii?Q?Rn6WqvzPXi/6Y9iAguGBWDHUvrBeP4as8HAscuOGiwZFqTiY5uNtoBPP8/Ux?=
 =?us-ascii?Q?k1GSNureKLMeJK+20ZQL1JOsiIbc3MFRrMfPdtvKa7T3V4yioQBRP2ArnFh6?=
 =?us-ascii?Q?I59qiHuKt2vratNXCrwHEyRUFdNNFtdv3ToKOZGdGawwAjaSk8Aa19RgIhzC?=
 =?us-ascii?Q?1hmjPijh5dCmzqMWZE+iZ2TVd+JVbdIp1u0fvmFPjyTAEAOdu+yMsd7PTAPt?=
 =?us-ascii?Q?hDO3kvStAbv67e4jl7MNOIlXrKyvkF1j2wT0/n41y/9s7WDyn3KtF0QdyVYX?=
 =?us-ascii?Q?87lyP/fOrhAGYKmDtrEGRMgb4RqZkKGT5+Ljt+Y9OLvI4kgYe35uTWOnH7Ar?=
 =?us-ascii?Q?DS0vjkXp7fgmUdRIcCY0R+tQAeqQPM+wNXdVGtUTMgDbiMSTRXq8i+EjyaVj?=
 =?us-ascii?Q?Lh1L/buuL3+72RiTAYcsUsCMCxX2/8iVcNeZeraoCnzyzBn9O7HjKXOhS0os?=
 =?us-ascii?Q?vpPaNNbQN4/OklC+rSXJPkIP1VZy8JkyorT8rQrGSQaSKmeEHH0babgyUI+d?=
 =?us-ascii?Q?2b2M4OvcaXhgrvIe2TSffFihxsSeF1xxeEsEQ8CFDA64hHlNHviulKITjXa4?=
 =?us-ascii?Q?m1zcyT6t3vSx/gCXDkEf1fLfZzrVwzTTgJ0yNayyz3Jj+Zzy+1ZeIPHFgp2z?=
 =?us-ascii?Q?cmPRojgsq59PaccI3aFY/mNtRz7gq7t17QVnHCNvX6btWYl5dCz/awkeeaSr?=
 =?us-ascii?Q?Sk5LSGeU0pu6blsSAlWqwVTNy+GgeQA0S+l4bpdwF173rJzE56c4YhoKQja2?=
 =?us-ascii?Q?FngQq1WuYAQhabb5AdyIsLtMUj+clDdSybEd33XbpT/WNUzVo+rma14jPn7g?=
 =?us-ascii?Q?JneVcAasefHjgDOza6R4aD2Ld7wwfa3jHwt1Lcy3GV5CMzHgMxsk/ORldE/h?=
 =?us-ascii?Q?ZiQFY4NQQBeg/QE2ZaeLNt/guGNg968ppY01rhKxtHhkTnXYEHsCGtvvJnZm?=
 =?us-ascii?Q?JqsdxboQWiyew7lZA7E3jJsuqFuRfv86yjV4tbLmcFIJh2Y/Ix9h+gp1k1Jk?=
 =?us-ascii?Q?/lLiIBhFxo7GabUhh73rcXpiZrbb+/7HWJ/iL4suZM3GQMBDgD7TeWZAsbpL?=
 =?us-ascii?Q?H8kjzbQW542uFx1SF49KsDwbZ1dQWPzHrBBZTh3kJhaGys1WbhUph+zdplZG?=
 =?us-ascii?Q?5p4eDpMHmNC+avEtSvpJtzXYEYVGuO0Ng2OpP1AhEpRrhugQ19KPb9qLe5cx?=
 =?us-ascii?Q?FU708eOm9RL6X7DCARgrqWbCwZ1VVKn18wmhkb+cClrvHsq4plR1M6+hyyYZ?=
 =?us-ascii?Q?ogpgc52L85JPkume/arKnQPMpb60Gl8s84P1aHQTb+2JGfpoK0o6udGUGm+B?=
 =?us-ascii?Q?Reyv3YiVx7irdBqT5DYTw7LCB4fgSzkGIHXDTbGCSHD7ApxeBejnvIp983Jf?=
 =?us-ascii?Q?YOyJuBdmWzCkxX8p9JBLeBqRU+aPpLnCZ34ORpWeZ3ZrJkET4YuaIrjKSsJu?=
 =?us-ascii?Q?C4ybjU83onLY+VetJ8bS4KiF7PU0dBOZ9FZKL2idQvcI4Bs0Z2mIZKxHiMzz?=
 =?us-ascii?Q?5A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 126dce35-082e-479c-c62d-08dac971419b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 14:29:09.5093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0huD8rI8iLWxXPEvMImVdtqNwEXtJOITX+vA0sbZ9lStZXZOMKappVuxTdIOXN/rTTWMBg8vv6AAPAghqaVpf8NQHOAvLB1D7z6pwGotx7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7288
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of I=
van
> Vecera
> Sent: Tuesday, November 8, 2022 10:36 AM
> To: netdev@vger.kernel.org
> Cc: SlawomirX Laba <slawomirx.laba@intel.com>; Eric Dumazet
> <edumazet@google.com>; moderated list:INTEL ETHERNET DRIVERS <intel-
> wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>;
> Piotrowski, Patryk <patryk.piotrowski@intel.com>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Miller
> <davem@davemloft.net>; sassmann@redhat.com
> Subject: [Intel-wired-lan] [PATCH net] iavf: Fix a crash during reset tas=
k
>=20
> Recent commit aa626da947e9 ("iavf: Detach device during reset task") remo=
ved
> netif_tx_stop_all_queues() with an assumption that Tx queues are already
> stopped by netif_device_detach() in the beginning of reset task. This ass=
umption
> is incorrect because during reset task a potential link event can start T=
x queues
> again.
> Revert this change to fix this issue.
>=20
> Reproducer:
> 1. Run some Tx traffic (e.g. iperf3) over iavf interface 2. Switch MTU of=
 this
> interface in a loop
>=20
> [root@host ~]# cat repro.sh
> #!/bin/sh
>=20
> IF=3Denp2s0f0v0
>=20
> iperf3 -c 192.168.0.1 -t 600 --logfile /dev/null & sleep 2
>=20
> while :; do
>         for i in 1280 1500 2000 900 ; do
>                 ip link set $IF mtu $i
>                 sleep 2
>         done
> done
> [root@host ~]# ./repro.sh
>=20
> Result:
> [  306.199917] iavf 0000:02:02.0 enp2s0f0v0: NIC Link is Up Speed is 40 G=
bps Full
> Duplex [  308.205944] iavf 0000:02:02.0 enp2s0f0v0: NIC Link is Up Speed =
is 40
> Gbps Full Duplex [  310.103223] BUG: kernel NULL pointer dereference, add=
ress:
> 0000000000000008 [  310.110179] #PF: supervisor write access in kernel mo=
de [
> 310.115396] #PF: error_code(0x0002) - not-present page [  310.120526] PGD=
 0
> P4D 0 [  310.123057] Oops: 0002 [#1] PREEMPT SMP NOPTI [  310.127408] CPU=
:
> 24 PID: 183 Comm: kworker/u64:9 Kdump: loaded Not tainted 6.1.0-rc3+ #2 [
> 310.135485] Hardware name: Abacus electric, s.r.o. - servis@abacus.cz Sup=
er
> Server/H12SSW-iN, BIOS 2.4 04/13/2022 [  310.145728] Workqueue: iavf
> iavf_reset_task [iavf] [  310.150520] RIP: 0010:iavf_xmit_frame_ring+0xd1=
/0xf70
> [iavf] [  310.156180] Code: d0 0f 86 da 00 00 00 83 e8 01 0f b7 fa 29 f8 =
01 c8 39 c6
> 0f 8f a0 08 00 00 48 8b 45 20 48 8d 14 92 bf 01 00 00 00 4c 8d 3c d0 <49>=
 89 5f 08
> 8b 43 70 66 41 89 7f 14 41 89 47 10 f6 83 82 00 00 00 [  310.174918] RSP:
> 0018:ffffbb5f0082caa0 EFLAGS: 00010293 [  310.180137] RAX:
> 0000000000000000 RBX: ffff92345471a6e8 RCX: 0000000000000200 [
> 310.187259] RDX: 0000000000000000 RSI: 000000000000000d RDI:
> 0000000000000001 [  310.194385] RBP: ffff92341d249000 R08: ffff92434987fc=
ac
> R09: 0000000000000001 [  310.201509] R10: 0000000011f683b9 R11:
> 0000000011f50641 R12: 0000000000000008 [  310.208631] R13:
> ffff923447500000 R14: 0000000000000000 R15: 0000000000000000 [
> 310.215756] FS:  0000000000000000(0000) GS:ffff92434ee00000(0000)
> knlGS:0000000000000000 [  310.223835] CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033 [  310.229572] CR2: 0000000000000008 CR3:
> 0000000fbc210004 CR4: 0000000000770ee0 [  310.236696] PKRU: 55555554 [
> 310.239399] Call Trace:
> [  310.241844]  <IRQ>
> [  310.243855]  ? dst_alloc+0x5b/0xb0
> [  310.247260]  dev_hard_start_xmit+0x9e/0x1f0 [  310.251439]
> sch_direct_xmit+0xa0/0x370 [  310.255276]  __qdisc_run+0x13e/0x580 [
> 310.258848]  __dev_queue_xmit+0x431/0xd00 [  310.262851]  ?
> selinux_ip_postroute+0x147/0x3f0 [  310.267377]
> ip_finish_output2+0x26c/0x540
>=20
> Fixes: aa626da947e9 ("iavf: Detach device during reset task")
> Cc: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Patryk Piotrowski <patryk.piotrowski@intel.com>
> Cc: SlawomirX Laba <slawomirx.laba@intel.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 3fc572341781..5abcd66e7c7a 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -3033,6 +3033,7 @@ static void iavf_reset_task(struct work_struct *wor=
k)


Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
