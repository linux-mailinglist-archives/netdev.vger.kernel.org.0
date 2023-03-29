Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D216CDC81
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjC2O0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjC2OZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:25:24 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930445BA1;
        Wed, 29 Mar 2023 07:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680099489; x=1711635489;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6zk9r8HouzStNrv6SSuyApL/qRnKzba5llrqO6UTjtQ=;
  b=ZDvt0xft1vXUQVyynsDBlnhEa99o1A2fiDRMiXd/uYAcOpdAWglLVCW8
   /f2y/Ja08YcGQeVZObH2ed14WcZAPpR2JAdJjyhNQ3wDVTaW8uOJc4pbC
   ImwpznJ7G++6VAZZI2g4YRIO723sSn0sU6mtx+KUoaSYHNdNKeQyS6ayn
   Dt7/HTuoGC2HOA6kKnBmpESD1EMUCQAGB/s6V8TnjxtB/+QPL9hvzqrBj
   iXXeEbAp+jrz4CZ4Kwxmi9UWqIRgERSHfePh7QRBQM1xAx15lcaektQpr
   5xTEVHZrrL1V33fDB79HZFSyT1FPJJ5EAzAohIRMwSHHp0IUlhrAT1V2r
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="427161229"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="427161229"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 07:16:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="858520392"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="858520392"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 29 Mar 2023 07:16:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 07:16:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 07:16:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 07:16:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HF/cgoyPRx6YQQ1XKTDQ9cYAyy4e44uAfdMXNnrxCNGU4+h8nzZgHWtBHyvqq1Dw5McgqSTg4zpEY6ww545RA5Qr/u7z1Q0HDpRWqxygZwjsYpbuvxnhqGHVf4bkk31rMiQnONu2VotkQMGqleaW/gr11I6nZ1NeQfFO/OWsX2NrpvBXIn/ivmHxfvF6HII4BCRFBzmElBWn1TlEx90fJiZeZZCTSTP4DNCTXjO8ZV5lYp9tj5plCnAv7sTd6xkoS/5ZZ+jyR5MjFPsa9d4kS5rcKHm4RGAzaGe+n7Uu7caWUHhvQnv5E4ErQdOLh2E2aqbIMf2TKLmGeC0aS1I2Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6AYeUVSk15v2zkP5g7qdD2uSYN8X+78TpbiRoRyWGU=;
 b=LeOs6qb/utZu3egdLVVNKsf5THxyBS2wqgrExv8R5unoS1GTXvsrnJoQeDxrguMKGbHflK9+O2wbAr0V73SJkcTxjz25rGRL6vP55eYsC+q0A8oIrTyzERPJs6ytmcFVPICNm0yLpua6XPC28vestWDv4HVPgHv7UALCupp/370u9ZsE2yEsv+pXyJVj1x0euej7Q09XX3yG/tynErL8q+P/f7tg1BU02+dG/53hLOiZbF9sdvP32us9rQkyy2PNS17rBZufvWyYALkzn700sznk2FxOphrmW0Fkz49p725kgdeBodTBl95WYLVavLke5VB9X3TdfibOIpgkHAmCHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by CH0PR11MB5473.namprd11.prod.outlook.com (2603:10b6:610:d4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 14:16:37 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::e704:474f:7205:a467]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::e704:474f:7205:a467%2]) with mapi id 15.20.6222.031; Wed, 29 Mar 2023
 14:16:37 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Andrea Righi <andrea.righi@canonical.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: selftests: net: l2tp.sh regression starting with 6.1-rc1
Thread-Topic: selftests: net: l2tp.sh regression starting with 6.1-rc1
Thread-Index: AQHZYjl1GRPOFSRp8EO/z00nY9tXgq8Rxqfw
Date:   Wed, 29 Mar 2023 14:16:37 +0000
Message-ID: <MW4PR11MB57763144FE1BE9756FD3176BFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390>
In-Reply-To: <ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|CH0PR11MB5473:EE_
x-ms-office365-filtering-correlation-id: bc256c2a-09ff-4894-3493-08db3060355d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QJtgkQysWfkidxmIaGwbJopZffmZ2sfAiycxlrEVJ0b1v9ecipQ7MLqWO2XE7G2h/IzOGzEOp7QKTsm8OtKiLCQKY+UOfdU4oCV6c+QuLntikDCkU2QwSxX5CvFwt0VrhdGxRpUKO1q79qj1CAYLRSTxVJ3+kT2iMQiZ/HdrSx1Gyg2Qohmjw/Jerf6Yk+uoG0qoXGYb/j+aHQKDCAGU6g7RBCJeYa6Rr1t8JRV/6X7rcwbfx+Mg99pmxU3jjx72rJRhoIRH4mXo7GHwgPLgTXwKoKMrvpukJ0SBBpFx/lFqe0RqgruM0O7XY8/T02iv8hunQm9zVfmDrh648fRAWkTyJ2xBnlYeOZT824750W1RPcbjYsMb7FY+zVyGQo1YR2aduQRmG4xfc+CW0HeI+j1VDd82G4qnwF+phOZemVE793ItSysn+cmAntVvt+wQd3HtUOsdQIoT6J717QCqs0+FLoaDU9FBSi04PbxKiC31Lvd8TwD4z6eP++UIjMaN3oDYOP47+PEQQ+wRlvDSNTD2emaOdlc8zjUkBxFPmrnvq8HHMdno7scQJMZCZMSssY5flExydwCn2MsiFQ1H+lLv4xw8rMoYd/ymys7RPC/COju9ow7LZ92bp2c2nBqirSpo8Z+Q75EUa75ZS1whiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199021)(38070700005)(66946007)(122000001)(33656002)(38100700002)(55016003)(86362001)(8676002)(76116006)(66476007)(66556008)(6916009)(66446008)(64756008)(4326008)(5660300002)(186003)(83380400001)(8936002)(41300700001)(52536014)(6506007)(478600001)(7696005)(71200400001)(966005)(9686003)(53546011)(54906003)(26005)(316002)(82960400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?nEzAF295Pq+PmdyS9Pj8hwteLV+/b9iwySRSkZTVtnh2LQ66sGmePWRMUU?=
 =?iso-8859-2?Q?KhZABY0iLyNZXEDWfvZMllIh12B/l69pXx8/oF5nbT3OIzmaD5UXsylnEc?=
 =?iso-8859-2?Q?LqxkiYuJTMdkz8y0FE+uU9vjtQu/M/RjcdOkh9ZLqEExKBjDLl+VXDHmQI?=
 =?iso-8859-2?Q?vDQnbAuPkKlDorfNw+Vcs8oG+UrAtm4NZwth6vs91xWlV7hvqJ/S7PYksq?=
 =?iso-8859-2?Q?rNPuncKKs0foowuRGYKywGB+zXEQJvoGoLBvom+DoiPWJrpFf7S5LmGcIa?=
 =?iso-8859-2?Q?I9I9f8Sonb2OML8vZOq+1RAJRFdkti71CI+hXDz9ynFiACvK7pZz0epD6+?=
 =?iso-8859-2?Q?xhuuEt2qECV0AtJrAQKMPRIefe6MaGy+yjIVU/tEPEQRC04KPqgW/rLhF8?=
 =?iso-8859-2?Q?0XDwALsDW7hkB9ji9OCgOxURfpjhmHCaDqzGlqj39zGZrqkrQd1B0PevEW?=
 =?iso-8859-2?Q?+ITahe61mOBtsXgaZy9WtkkAk+IwwziAPoo6O37UQFgldDgn2bE8JS1jyH?=
 =?iso-8859-2?Q?wz1u4IOVi/Cizmcx9aj0r2wTEmi8B9oNzDP5zJv6Eh0ESGEyY0ev+YLIOW?=
 =?iso-8859-2?Q?ZLnrqSnxm1zPrIO/qsqNwMJ5RSS/40uo9ZdkDSFfqYnmi0xOOpNmQ73RQb?=
 =?iso-8859-2?Q?zLzV0eEF56rH03/oHbpZFFaTE7J6EahOIsaCP/9MrXtD2EdhXTrfsHuNN5?=
 =?iso-8859-2?Q?UvPPu0lrdKzGVpV0EDAJwUD5vPgvUva4QaHYcuBA04oaZf7Rz1wn6NCoFL?=
 =?iso-8859-2?Q?ujaRJuOOrk55CWo96+FD/pQDQs3jqyADebXbw2HOTS4WNgCFBgBi04vUWS?=
 =?iso-8859-2?Q?2eSlYAvrDgoCBRItlhMZjHsW//l8/0wTzQ8piDYbpmy11XE6A3ZjOCVBM7?=
 =?iso-8859-2?Q?zUCxEwZS67vF0gkfb4UYwUZJVVRF8IMiKoKBllTNQXBdrb2ohf0srqw5Wz?=
 =?iso-8859-2?Q?bzdcM0Ezp0nENlWV66yNoZuB7KTYwFXhZ0EsxIW1KeZeyrfuTc+iTd/vfd?=
 =?iso-8859-2?Q?q8puykEJynUNT2IJdt/n7b03issdUbqstLz6JHOn88/riyOerPBwfyt5ba?=
 =?iso-8859-2?Q?g8seha3Od1vKlRP+wzqgwwWBziAvwVFXK/VQ1q1AvZT8Gr8toEkjLTyaxL?=
 =?iso-8859-2?Q?BEUJzllr+qvWOhUMgAvDhKch2+2aAb4X5cTbUCRcP7mAl0sCFItOGltCpd?=
 =?iso-8859-2?Q?kybtL2XnkuNgxaEl/pWyD/+6WS3S43XH+pPivZ1EMdsR3UXKqHcqt6Gatq?=
 =?iso-8859-2?Q?1OYeET5k3q0U9o0ImkuzL+qTYHRwHgW084/GkpOtrHWwnI1q1i/kGTKwMQ?=
 =?iso-8859-2?Q?deAfG9Q3Ttl3ywPhv7lflamD0poiFuwiV6cYyYRxlD/HEptgPmMa2kAe45?=
 =?iso-8859-2?Q?zyB6by1nze2xzo0SxE4nXE3EtOcS1ZjcycS1C8qSyn2Ety4jQA74Gtulxe?=
 =?iso-8859-2?Q?fYSx35UGPq6ATrdRKUE+Jm4Lx0tIAJhHmSK0vxSKpVtFvbYDhd0EXYpErR?=
 =?iso-8859-2?Q?5c3KWctaaolJkJ69gkzom8yumtjZRuPg6Ei54ep+ZWBw75dj52A3Q78UOx?=
 =?iso-8859-2?Q?nWT/OPzLT34TknwR/bG7YDBOIiUkZPy2qg2tqrNkodsmY0SIjsJHX9bn4K?=
 =?iso-8859-2?Q?jZFVEiYgEUTgip+n58d0FRXICU0kkal6Vf?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc256c2a-09ff-4894-3493-08db3060355d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 14:16:37.2943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QR2FvFyZcHJ6z107m1DSlazzshplsoP7k4uspwY6VvmlGrdpkfBo0zqMBl2frzaG5Fi25mF/K9/uaWiGgE1sa5jVGjzfHRLn9VMjcVtEBcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5473
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Modifying UAPI was not a good idea although the patch should not break user=
space (related discussion [1]).
We could revert this patch with one additional change (include l2tp.h in ne=
t/sched/cls_flower.c) but then again,
modifying UAPI. This patch was mostly cosmetic anyway.
Second option is to try to fix the automatic load. I'm not an expert but I =
think
MODULE_ALIAS_NET_PF_PROTO macro is somehow responsible for that. I noticed =
some comments saying that
"__stringify doesn't like enums" (this macro is using _stringify) and my pa=
tch defined IPPROTO_L2TP in enum.
We can just replace IPPROTO_L2TP with 115 (where this macro is used) in ord=
er to fix this.
I'm going to give it a try and will let you know.

Regards,
Wojtek

[1] https://lore.kernel.org/netdev/Ywis3PYhKiATnzXB@nanopsycho/

> -----Original Message-----
> From: Andrea Righi <andrea.righi@canonical.com>
> Sent: =B6roda, 29 marca 2023 14:24
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.=
com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Shuah Khan <shuah@kernel.org>; netdev@vger.kernel.or=
g; linux-kselftest@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: selftests: net: l2tp.sh regression starting with 6.1-rc1
>=20
> I noticed that l2tp.sh net selftest is failing in recent kernels with
> the following error:
>=20
>  RTNETLINK answers: Protocol not supported
>=20
> See also: https://bugs.launchpad.net/bugs/2013014
>=20
> Apprently the module lt2p_ipv6 is not automatically loaded when the test
> is trying to create an l2tp ipv6 tunnel.
>=20
> I did a bisect and found that the offending commit is this one:
>=20
>  65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h")
>=20
> I've temporarily reverted this commit for now, any suggestion on how to
> fix this properly?
>=20
> Thanks,
> -Andrea
