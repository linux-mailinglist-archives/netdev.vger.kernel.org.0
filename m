Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3493A6183EA
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiKCQQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiKCQQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:16:14 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B84F18399;
        Thu,  3 Nov 2022 09:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667492173; x=1699028173;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u3Cj0ca6tI8+Dt3fveuL/6+eMxaoKauEiMucTZUz/FM=;
  b=fNbsIFIwVzXLZ+1kVXD2EsadprotBzjGN67elqaIIys0OJ9fDTcKHZPF
   RFx5t4lKowG9X34t6v313xcn0bzJ3OWJLh+7/ygJfQb6sqls42texEI71
   ll02Xmke09sD+rT+eRz/qQrsIMfbev8SGgLiLosofjkd5Aw4FxUtZuZSu
   n+H7BTCEG74cWMTSTETxFJs8I9Z70Z1a6PVlZ2qLIrNBFwMURCITHEfpW
   muwrwqV4ekeKJjTkEgyyPXjiszrFyv2q+aOJmQiFX4iP1qA3CnxTzskrg
   DacI0OBZekJNDGLMNHFw9sodo8CJCpPXGoAN6DgtSBNnnAcoQV1IJFE6I
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="307347309"
X-IronPort-AV: E=Sophos;i="5.96,134,1665471600"; 
   d="scan'208";a="307347309"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 09:16:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="668025201"
X-IronPort-AV: E=Sophos;i="5.96,134,1665471600"; 
   d="scan'208";a="668025201"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 03 Nov 2022 09:16:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 09:16:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 09:16:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 3 Nov 2022 09:16:11 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 3 Nov 2022 09:16:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aekj9LZ3Gq92CkYbrJCzvnh0QJFYc+ZYULPqsMNUB0p0XMTY9La8/VOdy8+Q2RvubKm9L1+RhV08sSp3MKcFP3vlR2nSjGCfvzT0lvRYiSiAK8P6JO1c5DEr6KdH0cx+b2d4/bqH2wkcp+SbFfNUy5ida65ROxNGpx+s1FcW9x3eUhj/zKFR7xRhyWu9kzKz366+WTYCbO5/E5RCWJC4M1Sv5zrep1JqrjETdsKcn9pKNnibJjJ6R/paMpPxijqTza76IUinjONGedG3QNTTb86/scBWTCpoR3NLaNNH+aY2JKq5QRoAOQyMMW/ANQj2GhkrYOS/ZU8k15oWYC+OAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/V+5UdW9GXF7udx3EU6RaiISdoAvrWY1n0+UhTF5NU=;
 b=S7Z9wz5AZOPsQLLJGmobs+JXxGPXHTlpSOZyMP0Pox3rs2fJLwARfKjfr39kTk/9e25PZiygKeeVF5U2a8uMwlnsTGjo4eHHeMEW5M3bKTVubMqOHY2Yr1FXg6w6HN7wjYInlzjiCJbBS3U3wHpD2/6F75fsGRD50JRBivVYl3dpkaZZoz2CEHZmFtDoLO30QjhBWIYfPqx+0ZM77f32cx1xi3836A53/HowK5kRXm0/ReLWuurmijw1b4DLojxUeEw4fzhk433Txao2pVZ7F0Yt4ZiSRls69VMKlc1EmE9kc8P9CoIL4vX+NNVFSsZeNUxtHwt0dwbAOTXBAaUmWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 16:16:08 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::888:2df7:7c31:e1e5]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::888:2df7:7c31:e1e5%7]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 16:16:08 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
CC:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Eric Dumazet <edumazet@google.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Yan Vugenfirer" <yan@daynix.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v2] e1000e: Fix TX dispatch condition
Thread-Topic: [Intel-wired-lan] [PATCH v2] e1000e: Fix TX dispatch condition
Thread-Index: AQHY6s1+459MsLlVRka/vtnfDMJ6pq4taWjA
Date:   Thu, 3 Nov 2022 16:16:08 +0000
Message-ID: <BYAPR11MB3367F11AA3FC83C70BBBA8D5FC389@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20221028130000.7318-1-akihiko.odaki@daynix.com>
In-Reply-To: <20221028130000.7318-1-akihiko.odaki@daynix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|PH0PR11MB5657:EE_
x-ms-office365-filtering-correlation-id: d374e79f-ec40-43a2-c342-08dabdb6b777
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hq5ecXnE2ZPRGvMJ3fSGJVQrdh2CWEFVxdC5pi4Ddgqy4VZ3k4PBDqy2mqcRHiLRM8ou5KBwoRubJ6jAB3SPq9yYW3S+Mcjl2ckZkfovQ6XoTpLE7oAqhs0gJjW4zFwCq8HaCE1ahAyQL0JjaF8TXbb7mhoDke+KRABeG2QqvReoTP9+O36InDyiDxHKOwtNmIigfkQwetzc+PKt60iv6nF5rI8vufZnZer9YTqqiQQ2/pK6wi49/FTOPLRttD4rxrxvu6B7TkQUhwLdV60KOWJo/9Ktm3zKkIP5PeImJLlK0RgqKu/tkRLaval1gtGAuk7dyBhobcmP6iMGpZKMgI3uTTCAsy7UKccTJJ/NWGXwQPI5BRa9if8CdlVnWOquo5OWFVJilBdTdHXcaf5pWI5DQcLWFUrpzM70DY0T3i6I6NZKki8g2vJPN/mxEx0CzHp0hCzxIDES+Raed2vzpzqA2C1JP5vlExiPvkdEsuUkkZe4aobIwAxZ0N0YoXwWBqIm6AN90DdKrXeihk24VPJjaC1qs+uYmrNSUjX6Dy+C6xNdG19gy8xJYgpsvaZ9tHEo2DRLikvUTF6huIfKEEotsDYVKxfLPTolSZFa0WTndMVv+307whAXpcgE9y4TYoGSU8/naGII78V0FxDopdDsu0t59vhxdm68iIbVJ8uqhpEbQ3aBH3x3Hm9hYiVpCnZVipBHdZhn7EBX1wJuu0a5pK6ehJqIXBuyRSbMnYOeYyBO0nhei+S9llXqX7ttCA75r/0NsWcYKCpAco9VBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199015)(478600001)(9686003)(7416002)(5660300002)(26005)(41300700001)(8936002)(52536014)(122000001)(186003)(86362001)(66476007)(83380400001)(2906002)(71200400001)(64756008)(66446008)(66556008)(76116006)(8676002)(66946007)(4326008)(82960400001)(38070700005)(6506007)(38100700002)(54906003)(7696005)(6916009)(316002)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PuZWOKh/1TWoETkFrFH69LyCzDrPRZU/+SMJh6nE1Da+8uCZ9GZQi1kdXhRq?=
 =?us-ascii?Q?5MDqhsEeVQKEmjxxjI7ISobXXcFwW7WKPcDgF1cQUgzW7evjwPY7sOI7y+QZ?=
 =?us-ascii?Q?Kh+4mx05IQ1NR1XZ5CIFbAeDntUK8QGTY264ajIipS2oIBf3JqEvtSuPlDhC?=
 =?us-ascii?Q?Ntpz/jbtLIQHBBGuLQgxnF/GGRORrK5sp97+e2v7fLKOQQq7lD6v777lAFF9?=
 =?us-ascii?Q?ZzN3yQQ3OtRjnjt8pJpr/SaxMtoLMzAd+X2oYoj5pRh2AdWSAfN0byrFNRyP?=
 =?us-ascii?Q?aho/PV7ndTuGwW6tTYHnZSlSQR91Wo0+pD0BugAKn6La1n52ciSDZUaw5nLi?=
 =?us-ascii?Q?XpqIHrgPfK1g3mIZ1DTaMtu9RLZkAOFiR5ISvuEKQW8aR3fYwFessnOF6OGH?=
 =?us-ascii?Q?lT/qAR+lf6eUMGQEfJK2epcY/CuhYX77+temPUqF7xQAMuTWq9uaD8nbkF3A?=
 =?us-ascii?Q?KmG+f7uIZXDT/of3e2aklwjac382viS6akHsV4nQ3g6VtDKCstD27yg+BK1W?=
 =?us-ascii?Q?AyD0PXvDJBEOvmD37o5BzRJZ4ZHA2yjS/3ZuLFQSf0LBo7X9+SSiTZc5MC+o?=
 =?us-ascii?Q?eQ2LrlN0Pr43GdsmTM0qO83cjtfPk5OVyFU4yNwB/YR0Yk6MAVl2ajt0JZyU?=
 =?us-ascii?Q?vAZLAlQ9RHGx8jyPBGHv+OLCO5nTtP+2f50J6NSDkX6dF43fDOdagIi2GqI4?=
 =?us-ascii?Q?aQCYASl6LDK80YHVEctmY4pobKN6HXBS2uZUgfRdaAmD+Bxjq1dAm9/aR6Ii?=
 =?us-ascii?Q?x9Ancmmqx+6Gq+zNTd8GJnyyFTAwaySrMT33fbUIbfn3pp0TyNA0Gaqw+26O?=
 =?us-ascii?Q?ikW0el0EGmiL71pAy3Y/ybNe4X+uq8z7KL0KnP20wap9hET50/t+f+c91EwL?=
 =?us-ascii?Q?x5VbQZN0BIrFMmuOzIKCY48D2P6akbCmMdBa5nCwULjV1IbWdUPpcBIFyBTF?=
 =?us-ascii?Q?9K7EXLXxFO7O7JEGR5t5GOXkeczreRmwJUYDXeogbsrjZ0J1PSU6olUrHwb7?=
 =?us-ascii?Q?kVEqpa1HfH58NvriD5s5Tw9zavoN+tEe0MDBk1WAkCHY5qzljADPdu101yzK?=
 =?us-ascii?Q?UmaKCNOYPJXT5G8vEN1mOKn4sZmSlpXHpvJZ+LBKOG+rx9X+yVYkbvtX10iq?=
 =?us-ascii?Q?p7Ospq+iSURDqlnghqGknOFX06RjrBI7hq+oEU8jw1ThZ6pqdanv0QS26Pwz?=
 =?us-ascii?Q?1YQOwCesOJ23L9fqhyilyaAwsBhF/H3LJHRBh6iCy5ZiGmBMKj5lr15DKYCa?=
 =?us-ascii?Q?0KlPavueqlNyWul8A3jWzQ2edhaskiJ8Ef9zFlPYIRCV2tx+OUZpkg/OVv+h?=
 =?us-ascii?Q?2d9BfckxHBaOul+sYNpJST36KCXiIjeRQFtSHuXJ01tBnJ/h4WBG4dYN1Cr4?=
 =?us-ascii?Q?qjweEoO4l41X2T700Kn0DihHnMyQ/gyVdtAlKJIUu4UiMxRbA5jX58wWU3qS?=
 =?us-ascii?Q?IlVD/NvrRlvBtzTksqgjFaOx4mFWBR0NBOpcMeiSuAGXZUAwOc72mhEarSEE?=
 =?us-ascii?Q?rCdN0odMCXWvXeq8GbSynOdurLLkcFfVQ6RiHAUrw63WLld1YnQdrPFOUHIr?=
 =?us-ascii?Q?VFGbP0kUpWCqibzaqc06BTdN7nYWHfU+V2WJlWCK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d374e79f-ec40-43a2-c342-08dabdb6b777
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 16:16:08.5967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r8wqaGWoXnJysf0KTI9R6oZEqRiuTxLIV5GNGpGt2FXiq5t+7UJYsbKL4ybXjDdQcCCEg4e6sHGSMn/um12d3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5657
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Akihiko Odaki
> Sent: Friday, October 28, 2022 6:30 PM
> Cc: Paul Menzel <pmenzel@molgen.mpg.de>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Yuri Benditovich
> <yuri.benditovich@daynix.com>; Eric Dumazet <edumazet@google.com>;
> intel-wired-lan@lists.osuosl.org; Yan Vugenfirer <yan@daynix.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S .
> Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH v2] e1000e: Fix TX dispatch condition
>=20
> e1000_xmit_frame is expected to stop the queue and dispatch frames to
> hardware if there is not sufficient space for the next frame in the buffe=
r, but
> sometimes it failed to do so because the estimated maxmium size of frame
> was wrong. As the consequence, the later invocation of e1000_xmit_frame
> failed with NETDEV_TX_BUSY, and the frame in the buffer remained forever,
> resulting in a watchdog failure.
>=20
> This change fixes the estimated size by making it match with the conditio=
n for
> NETDEV_TX_BUSY. Apparently, the old estimation failed to account for the
> following lines which determines the space requirement for not causing
> NETDEV_TX_BUSY:
>     ```
>     	/* reserve a descriptor for the offload context */
>     	if ((mss) || (skb->ip_summed =3D=3D CHECKSUM_PARTIAL))
>     		count++;
>     	count++;
>=20
>     	count +=3D DIV_ROUND_UP(len, adapter->tx_fifo_limit);
>     ```
>=20
> This issue was found when running http-stress02 test included in Linux Te=
st
> Project 20220930 on QEMU with the following commandline:
> ```
> qemu-system-x86_64 -M q35,accel=3Dkvm -m 8G -smp 8
> 	-drive if=3Dvirtio,format=3Draw,file=3Droot.img,file.locking=3Don
> 	-device e1000e,netdev=3Dnetdev
> 	-netdev tap,script=3Difup,downscript=3Dno,id=3Dnetdev
> ```
>=20
> Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently f=
or
> ICH9 devices only)")
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
