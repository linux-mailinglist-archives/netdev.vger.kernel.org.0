Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEAA0456F8E
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 14:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbhKSN32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 08:29:28 -0500
Received: from mga05.intel.com ([192.55.52.43]:41520 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhKSN31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 08:29:27 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="320626464"
X-IronPort-AV: E=Sophos;i="5.87,247,1631602800"; 
   d="scan'208";a="320626464"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 05:26:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,247,1631602800"; 
   d="scan'208";a="455775799"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 19 Nov 2021 05:26:24 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 19 Nov 2021 05:26:23 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 19 Nov 2021 05:26:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 19 Nov 2021 05:26:23 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 19 Nov 2021 05:26:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fth9Zc/VjWzEMpTJBF9HTH9wvDfipHnUv4u8FVt4hpIht0HX7K/VnjRSC2cKVM3S0FnSTiwCEgHqGAxajYt25dBOS1zHcTLTb14QemAVmQU75bEC0eZmo4n2n5/jiOniQnp6gwRdwXpSOx/kLnyI7vDmB5eyf4XavfWTfS/EfTKTeeSOJLtqh5kDiEFfIgTN+lT5UVcfmK/p7Zqk9qobVDp45CGiY3Ji9r4fESiI9vqEIiWHHXO1mALRByGQVt2BMBocBKhH5+XSppNpbTMCY8mhLKqLDJU2YmGbRUK7OZ9NXX5w1ZkxrZZrBtNDjzM0JUekPyT1MP/lTvDcjMSdlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pR4uaMCPzA9KQtzm05vWYj88Hcx6YbqxSAW7c9i/EEY=;
 b=Z2dBVicwX79FhP7RYOVk9qOXUXMDd+zDTlEjknFzpG0jpCjpov25PybDHUwb9QQuJnbYlAsagX+BmFUcA3wcrezSsUnXvERbqxwGRUfbajeDy/daa1lUX7pLKGShrawKss+bnVmdVtz0OlDbwL89P11ngGIU1JBB7XC0P2Ir0sh0X+G9Lqp5z9vZfx5zUQwk5x8YPv+bsgRLn7tsm3b8e7yH3uGPXK6y3QlPJ7TwSV2JAWHvkmUSVtWb2FRNppQm0WfNf7nbcPl4OoTuLE1CX/deIYkkQJo2CJC6Sp9yP5SiCL7AX4QkYA5TKr9JhhfyabhK9eydIWQIc2847soIsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pR4uaMCPzA9KQtzm05vWYj88Hcx6YbqxSAW7c9i/EEY=;
 b=SiHOVt+3SKN4XMy2j4hov0LS90hkYPdaZzijH7/m29wFavAfozwHwu69IDHRshgE3DM9pbqFlfBHH837ADSXT2I8pqzP3+ikr/JrWrd8NjcxbPM3UkS9h/iiVXdECDTNIlbfh2zxrlH8Z7BgjEyU+j74JZNzOE1u0fA07R4lk+0=
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BY5PR11MB3958.namprd11.prod.outlook.com (2603:10b6:a03:18e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.18; Fri, 19 Nov
 2021 13:26:20 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce%7]) with mapi id 15.20.4690.027; Fri, 19 Nov 2021
 13:26:20 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Colin King <colin.king@canonical.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] net: ixgbevf: Remove redundant
 initialization of variable ret_val
Thread-Topic: [Intel-wired-lan] [PATCH] net: ixgbevf: Remove redundant
 initialization of variable ret_val
Thread-Index: AQHXpjovOl/CLm9KvkeHcWpZSVrvs6wLRX6g
Date:   Fri, 19 Nov 2021 13:26:20 +0000
Message-ID: <BYAPR11MB3367B7C420AA4FE8F5E41D10FC9C9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20210910115100.45429-1-colin.king@canonical.com>
In-Reply-To: <20210910115100.45429-1-colin.king@canonical.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17465d01-16c2-428e-f1bf-08d9ab602cc7
x-ms-traffictypediagnostic: BY5PR11MB3958:
x-microsoft-antispam-prvs: <BY5PR11MB3958FB6C20F9B5269624F903FC9C9@BY5PR11MB3958.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:546;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y8GXTbmMIlNWwBiOkHY7Vtp4T8ECJ7xBoRUrjJeLApPKjIeVIaV16T2GFjk+IPfzCpASLHHX919C30B5XM+ZVJU3BwLpBX8R2uKZTKPJGi/r63p4J0pLuLDVyTZ6+JXKQxKlBjJBTXRIYCgqUMk7Dgqa1qAMTY1XIvIbrJLc1RDaVk8ougnsScRVPjVeyxz5JGWhnn8VY6FYpp1GqMDYY91MR7SWxHTDWXb4s5lJVn/3JIYtSlkrqzHYBkkQo2ApzRezlqzpd0hV2AXh8JQQul10Sqhq+C+Rso7m4qDjRllk6+6rlknJGD/oXehiRy4YarfiOZFg1llRgVWAjbtkNDiZaZ4two+pZs+Tap6RCW9jpuHVdxzKRbFeQ9qs9PJaFuuQvnlxRxtHRuQOTvlfQPShXI6oQNoHJ4DwNPNVUV6T9SxF2gPs7/ZyauIKJXcdPGcS3lqsvjeqixvQ1jYLbI6tbjMCL9HAqr5nvU21OuTWMzzPRlITmNUADITd/CrVIIpEFdKW50/RIWmJ3/7e9QRRGbRyx2F0N53EVyPmFLR5w4RrnGILx7UrcvYjWk4eSzXkxJbyNpJlEsbXR90RuaTvuGHh0M6essZA9PncfXRKiN016dU1KQsJPr8ScpMOrTDpAOYAkck6lyBUf/mp/Lhq1GzOuCDTvLlBY70Ie472uGrBPjtMaoJ9rJNtKt5ogY8fqguoZQoEXeimKv4sGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(54906003)(71200400001)(86362001)(4326008)(316002)(52536014)(66476007)(66556008)(83380400001)(8936002)(2906002)(6506007)(66946007)(26005)(5660300002)(186003)(55016002)(122000001)(33656002)(9686003)(508600001)(76116006)(53546011)(38100700002)(82960400001)(64756008)(66446008)(7696005)(8676002)(4744005)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SL/UgMFAgSnaDfNOv960yJT1czGf0Fa4ezRPFG6KgCEGigRecZe4O04k20Iv?=
 =?us-ascii?Q?4F/4Ki5wJIpxuCd6Ajw6d5HpB9QDtdFXLBq5NtoV6pNxccEOL9Rrp2mxzDPc?=
 =?us-ascii?Q?9BpHfHhRAaH99Gkh6caD7WOZH7wVfqUHDmkTOR+nnW1quiDnl2gWZt598jx2?=
 =?us-ascii?Q?KYITWOcS8Qp7sYrkXrKJiQEPMZdxVP3xbD+JDZHcl/PrkG++waQDLninQNPl?=
 =?us-ascii?Q?iRcqJA8n1TL3rHGXAwksD54F3hPVdEcEj7zGmDh1TblEnzxhNtwjSvzHdZWK?=
 =?us-ascii?Q?lbLUv+LIa4oWmnIsa9Scklbo4w0N+pigkBJfPIPQfqzuPJroSNAbAZteF/XP?=
 =?us-ascii?Q?G6nax/EYCaVXBbZaZaWuBZ9e6y7tt5BampIn3r+8pfu9m8W6M1XMtNmDUECG?=
 =?us-ascii?Q?Dvzuc63T+MjScFrNgAIoDuGSVXGjBZ0YR850jpbJH32vMUbdKomaBpWK5maB?=
 =?us-ascii?Q?1bZu6Ip0PVjw6XQCwVNzAfufUKnkZ7UYtfz0tX3MmXqRExndUa6QdJfcVWAU?=
 =?us-ascii?Q?qfsllMAiZymzfCRWtwJY1TJdLuvDptP1aoaaYVBhlrAFq+v1OWiZl7K+k6Yb?=
 =?us-ascii?Q?ZHLomaFN/ub76WCuQhF3sGk3GlgtKAVSigIA1KMSe8WhfSMOArQs8HcvpTei?=
 =?us-ascii?Q?WqgLRvBBQEEVQK91kyZ7phIBglZ5moYh98umQ87UPjJnqnalm8HPOzS0vRUA?=
 =?us-ascii?Q?7IXfUIdJLCeZVMWlrbyFbtf4OgIUAQ10ZAgu/jUWKpMQoCSMm7n8a03PfP1P?=
 =?us-ascii?Q?ZGjD15o5J9IUpTvQljaA+UU8RYtIs84Q7KYNc9Vl4ji6yb6FbNmBZvBExMab?=
 =?us-ascii?Q?wN3WLW3rGfHmWey8bxHIWP2lcoautqcZmznQ6L9J5L0GGUtFRC3rhmxqh2Xn?=
 =?us-ascii?Q?fhOfxJmXm1YnJL2OVROeXbe5oliwFDsy18U2RdlpZ7P2hgRANndY10qXuHXz?=
 =?us-ascii?Q?aOSqrqWNPN12FbMDnLQK4nSPNZmrLx+fSdar808ipMcDPN/XmDT1vYNkYFok?=
 =?us-ascii?Q?WBeTmZh9tO6G0D3Brq6FR5TFm4mmEfLxmqFEyc7yqHRzwJ5nsDNif+IsR3rJ?=
 =?us-ascii?Q?3l1b/1BKgVEOFuLtGnZSjfJo4sTv16jDb/BwkphZlaPBmHR7lROJ0I8EYgbt?=
 =?us-ascii?Q?u892WP2DOQ6ZTGqOGcZE7BUP7SX6lLSHFw4mz7fn2tUs8HjY7zQP8JTxsQdu?=
 =?us-ascii?Q?nd9o04gECCdU2kviQK4XJruERpeDfj3SB1mLgJ/lc7r43ot4pAMU0qd1pL11?=
 =?us-ascii?Q?oiX1sgSAE8ri3lnxRTUa2zDe3NGMbDih19Og6G3t1wzFqU3ZMTqFSXVvbvH3?=
 =?us-ascii?Q?+0N0RTpBj+3KwO5aVZHdIPqbVCfS/xZuZdkG6y2BGCwSBm7SfTAzyC0Tzi3A?=
 =?us-ascii?Q?PIf8W/GEp9qmKkPhMDpfBfkP0Fbr6XAArPq48bUzK46R15q3Gl3as5VGv4Pr?=
 =?us-ascii?Q?F0yW+zGelsMoiRJ6LdV2AQuM8Gwb3B1NeijvMhaVjOu82Le2AYStplJS7D6Y?=
 =?us-ascii?Q?FiGPidXNczVyXr9DjpqK+CggB6+CxP8+82umZHYal8h8WFk0MSV3gsOsoB7C?=
 =?us-ascii?Q?B1uNgXbDnkUpTNvpIpleKaHX/07oBXa20RQ2E2l++w/RlXlHsVSDPBVdxNYg?=
 =?us-ascii?Q?Ew=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17465d01-16c2-428e-f1bf-08d9ab602cc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2021 13:26:20.5327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2j6fQNupH3wDRgBL43ubLTyx5n1MFD6ttR8ST5hIXpBpMoT3nKRLO/+2WxtA4XLbaT8Z4oa8CRQMh7XeSqys8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3958
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of C=
olin
> King
> Sent: Friday, September 10, 2021 5:21 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S . Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] net: ixgbevf: Remove redundant initial=
ization
> of variable ret_val
>=20
> From: Colin Ian King <colin.king@canonical.com>
>=20
> The variable ret_val is being initialized with a value that is never read=
, it is
> being updated later on. The assignment is redundant and can be removed.
>=20
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/intel/ixgbevf/vf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
