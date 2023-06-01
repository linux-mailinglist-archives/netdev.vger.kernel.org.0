Return-Path: <netdev+bounces-7070-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 508E5719A15
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:48:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10C732816C0
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9652340D;
	Thu,  1 Jun 2023 10:48:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDB823402
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:47:59 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2087.outbound.protection.outlook.com [40.107.101.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4009D;
	Thu,  1 Jun 2023 03:47:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NglruFj2ssg9cCbZRgk0M+LZk8DQ7eTmLuHmugqRJErpMkrCH/kXM3b7QGxM8ch3xt7tStK5CPU8Yi2o1AM4xMDz/ioWvAaTeyvy9RK4vXqGmMVWWsC8B5YAesokEL05okA2eGabG+t/N3rnGohmAXVA01AW5070WleEs3zi9bYgPoVRuSH1Exn0Ei/keNZOx5DhGxV69TZiG/tq15SUgZL858nmeFx6N3b5/8kFO+eRn1V1quukR561k0tMrJTSobdX2OvUC4446MabGZDVIU643z0tF/zz3OKf1LafudytK71L77mAX8gQ+UeyqEqEysv6mrH1PMbStS/SA8c/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLHoFqyI+5s+qfw0weU1P4q67H+0mg2UVKKfO82pq7Y=;
 b=eP/XGQlh/klkrn6rP6GsTULOIceyyhid2BBc8FB9BEBnx3JnlN5yr2NJ0g1jNEAbBmyru1Hg/a7oipYnu0OGt/ckQRQGTxDfDGdYJ6P0dUMRsis/w9o9ObUKhktKSpELHd5Z9fjx6XldkuzHQav82jTj+SA5+GRz2krueDu7/+YWavPWsh8Vh2kq+iv8JiAYJgUGngnhVzUNVuTn1MhzACWjglSDSyZ5hP1Aulyh9dAtfmqBUMGqQ5rkVMCjFXtsoFZ5kIwNZd96jT7wos6tUkIrMPZYNizPnFPV9G/wYfF958rbMHBEcdPH3c+j2IQqr2vUm9AEsmXwX4hRFqatZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLHoFqyI+5s+qfw0weU1P4q67H+0mg2UVKKfO82pq7Y=;
 b=FcW4kjkedd3d8ZG459GKYkCKlEMjooFpBpa51xdLZjPRHkFoCrz6wx4goz/vc/1YnbxQA6ofAi1goxd+mMie/rCyKUa/aHJ1qDApyt4HXOKfpBXyrvWkub9qcuG02O6TpIsakamfpgce3Zgbcukuh9FfHAj7PpdOMHIcJ+nVqZo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) by
 CY5PR11MB6413.namprd11.prod.outlook.com (2603:10b6:930:37::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.23; Thu, 1 Jun 2023 10:47:55 +0000
Received: from DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::c84c:5f6d:4ea6:b6c6]) by DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::c84c:5f6d:4ea6:b6c6%4]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 10:47:54 +0000
From: =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To: Kalle Valo <kvalo@kernel.org>,
 Ganapathi Kondraju <ganapathi.kondraju@silabs.com>,
 Marek Vasut <marex@denx.de>
Cc: linux-wireless@vger.kernel.org, Amitkumar Karwar <amitkarwar@gmail.com>,
 Amol Hanwate <amol.hanwate@silabs.com>, Angus Ainslie <angus@akkea.ca>,
 Jakub Kicinski <kuba@kernel.org>, Johannes Berg <johannes@sipsolutions.net>,
 Martin Fuzzey <martin.fuzzey@flowbird.group>,
 Martin Kepplinger <martink@posteo.de>,
 Narasimha Anumolu <narasimha.anumolu@silabs.com>,
 Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
 Shivanadam Gude <shivanadam.gude@silabs.com>,
 Siva Rebbagondla <siva8118@gmail.com>,
 Srinivas Chappidi <srinivas.chappidi@silabs.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3] MAINTAINERS: Add new maintainers to Redpine driver
Date: Thu, 01 Jun 2023 12:47:48 +0200
Message-ID: <112376890.nniJfEyVGO@pc-42>
Organization: Silicon Labs
In-Reply-To: <8eb3f1fc-0dee-3e5d-b309-e62349820be8@denx.de>
References:
 <1675433281-6132-1-git-send-email-ganapathi.kondraju@silabs.com>
 <87lekj1jx2.fsf@kernel.org> <8eb3f1fc-0dee-3e5d-b309-e62349820be8@denx.de>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SN7PR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:806:f3::22) To DS7PR11MB6038.namprd11.prod.outlook.com
 (2603:10b6:8:75::8)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6038:EE_|CY5PR11MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: d488dfc9-727c-43a0-5872-08db628da7a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uIyRKarLCJJsauyp0QxRUdIJ2ouo6G6SdCJB+YrcoplmSDiz4um+FwiGcEAHbb9EgikRxS0nUiXHELc55fbc4Bo5FdU9BN4BK5SRPPo9FtOY8YoH+6lInmG6PaNz3EWJWl0oKVccVAPDGQolgIKtVXjkHZfVK03tVWkizISqzN4VCleG2RknKgn1/yUrUcLul4cKD138+lRhuQeP8GN1bxmUY3fcyrYkbMurHPaJlm7l5zS7p1vCz+QDMyl8VLF/WaKxh8GWzlMKtOxAiZTZWjpThoHslBaRAZyJNZPcbn/szcs0v2TGW1DsNtP5ru/JFKPYYcebanHLTlLLkQu9ex8DT5shcqhChDymNbGD16uWfxN/e1Z5k578Ou583KOidEcPFjL7TvpvnqLUSNAZesskgJwlLc14Xcu9itWhGeauNnDpx61BOelBD+Fu6qn7U4PVWHqZt+pU2Jqjk/Ns3FhjyMqk33EgRWXZOo0jyjY1EZS+NSXPrEmG2LEhlLX3Ua9QFvbahq3AIdkzPDX62h8oL6dhOFg+G4BsTRqCIKjaqCL5j1Rb0zPuhzkY8IvN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6038.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199021)(86362001)(36916002)(316002)(4326008)(478600001)(110136005)(54906003)(66476007)(66946007)(66556008)(33716001)(6666004)(52116002)(41300700001)(8676002)(5660300002)(8936002)(6486002)(7416002)(2906002)(66574015)(38100700002)(186003)(6506007)(6512007)(53546011)(9686003)(83380400001)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?zGxUpy+7z3ZiLYFEFQ+XBlq1hFZ+Ww7rHRavmyLbYpWfzlGcqnnLOZ/mU2?=
 =?iso-8859-1?Q?Ygre7Ig6B1UldnKRGbbe1nWa7RhE2vH8ruDonrjOzj5DL4dKxbyZo+dagu?=
 =?iso-8859-1?Q?2PP2NmzN92ubQzCnYs5YpIbMZ+D5jyYjvIQrkkMsIkSg227jqilREmHc1q?=
 =?iso-8859-1?Q?YuIgP4jR2zoLyXOCg5yblg8GrxPd7buv1nke4BCebz9BwwpDcO8h4f/IqX?=
 =?iso-8859-1?Q?J3dRAgfBHK3kUc1CbSDvP3vDsvcjI1lBaJ/GbJZFTGhPhyL4l3haDsDmND?=
 =?iso-8859-1?Q?J5G2dhGrbDKLG9JIwJ92sH7Psulxo067YrmUp/FdoYbRcgm0S3PJCtwhRK?=
 =?iso-8859-1?Q?vBeBIKSH365ApiUMTOzFBHFB2+VWc2jenxF9GomwBah8SjLggOFoQEgbvs?=
 =?iso-8859-1?Q?BuXFSz877dRkA9yLy/Wa09+Hr65KLdeIOlZCdHh/Ttq9RHV1Vp/3Y+oQr9?=
 =?iso-8859-1?Q?wYs3YE/ype3uIWKfNPqfoSacAipiFCSFFqEqRvQdRP+Fy0+ZA9FhoBgzvQ?=
 =?iso-8859-1?Q?Qm0rkcf5W7tI1dloIquMMEw2RN7/wsLha2ClO/z55T1Lltg4FwAgSyUqTv?=
 =?iso-8859-1?Q?OfA1dNbRqVZEKGLVQ8ObocT40RxHM4tKKvL1/iuWKWHhDXusiEPOtZsKip?=
 =?iso-8859-1?Q?JVfakxmPPbCEEPSbxA3OFl7FEH7wJWCrn2rQF1JQoo3rkzcC7zucr2KoQJ?=
 =?iso-8859-1?Q?7Tklks6VUinVkFhoQCDM5CsQrnEXjOL5t+3L3OhTOAhHdq9IFpGnP1h7Yc?=
 =?iso-8859-1?Q?gxjHgot1EU+x9cW7nGgBnAc2WYIcq3+S6D1bY8/LMCBqX25fO4VbGRxudJ?=
 =?iso-8859-1?Q?3UTFRsc3mWRi9wAT1GvxpkPzlJi1vHyeAGFBh0HkKcFQAYpjQ60xc+kK6u?=
 =?iso-8859-1?Q?R4PRipKBTCyIa5j1eCmf6QdaxyO94YY2Il6YNJKgFgnYBR0fQVogy8YkYX?=
 =?iso-8859-1?Q?L+CTRo4ngBIUv8ac3/5+YNhH8KQg2bmoLzvyN60aQyt8VqFSuco9YQuJ9Z?=
 =?iso-8859-1?Q?TU3SZZOoxPeOxi231U3htHe72dL9Ci99n7dK5f6pt8yI5sZMYIogaTh7cP?=
 =?iso-8859-1?Q?05EugJHleEzfF4GNTmP5kCPdnPrCCk2Py6iYkdrg+i26cizA6Kdzot1W/s?=
 =?iso-8859-1?Q?dsbuzoRcx2OhcSe1lslIF7Br9c+CaZAsM8wWfr00i9f2l8J6Iz1nIW+BTH?=
 =?iso-8859-1?Q?3yGqElZ1BUxCiNU4cSgdyvU0wCOUdejXtCxvWm1vbrsh3bprW7dLaJCkqN?=
 =?iso-8859-1?Q?J9NCRWRs3831MKdIBZyBUgIec5AIyQ6UMg3vEeZnZOOqWEa/mlYbvqkB4i?=
 =?iso-8859-1?Q?Z5YdaJn7PMfSD4BGoUSjOgDoZ9zZFaLdXgH/fL5XUMpmlo2Ti6Y3VRF7aU?=
 =?iso-8859-1?Q?Zcf8VH8MrJ9UmJxnAYDtZUkKdh7s121UIALD35OvkSPBzEtSKYZyDZ5w75?=
 =?iso-8859-1?Q?O33KmJg7vkj518fwqEkA9TFTXAZoxoKl2fw+l+RbQemHRmy2bOh8Czt6t0?=
 =?iso-8859-1?Q?UMp+rxKmAMrZ6d2+w7Kao+eakffnO/8fX6FoD8xGGeUYks/VP8VDBFEfOd?=
 =?iso-8859-1?Q?VvPy5ZHTnzKVOzEH1T0VbpV226bWH+sHUD5knlKi5YRCcjydZpwKFg+fDM?=
 =?iso-8859-1?Q?kSd5RwT8PS9cLpJmGHYCXA/5lZM31OziMVF+Q7IzjRkroQjMm0mlYGyD7s?=
 =?iso-8859-1?Q?cGEphhXxTmx05mOCi1xF38Ze5VkoLcvopS/VslCn?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d488dfc9-727c-43a0-5872-08db628da7a4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6038.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 10:47:54.6787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5TXaO/IZvJtYUCVfWYAfcGRhZgzNMDv1e5WuxcfiG2mgjsmS7g/S52R0HHUwZA+o2JVZqqIirATHDbbBbXR9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6413
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Saturday 27 May 2023 23:12:16 CEST Marek Vasut wrote:
> On 2/27/23 11:28, Kalle Valo wrote:
> > Ganapathi Kondraju <ganapathi.kondraju@silabs.com> writes:
> >
> >> Silicon Labs acquired Redpine Signals recently. It needs to continue
> >> giving support to the existing REDPINE WIRELESS DRIVER. This patch add=
s
> >> new Maintainers for it.
> >>
> >> Signed-off-by: Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
> >> ---
> >> V2:
> >> - Add proper prefix for patch subject.
> >> - Reorder the maintainers list alphabetically.
> >> - Add a new member to the list.
> >> ---
> >> V3:
> >> - Fix sentence formation in the patch subject and description.
> >> ---
> >>
> >>   MAINTAINERS | 8 +++++++-
> >>   1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index ea941dc..04a08c7 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -17709,8 +17709,14 @@ S:  Maintained
> >>   F: drivers/net/wireless/realtek/rtw89/
> >>
> >>   REDPINE WIRELESS DRIVER
> >> +M:  Amol Hanwate <amol.hanwate@silabs.com>
> >> +M:  Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
> >> +M:  J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >> +M:  Narasimha Anumolu <narasimha.anumolu@silabs.com>
> >> +M:  Shivanadam Gude <shivanadam.gude@silabs.com>
> >> +M:  Srinivas Chappidi <srinivas.chappidi@silabs.com>
> >>   L: linux-wireless@vger.kernel.org
> >> -S:  Orphan
> >> +S:  Maintained
> >>   F: drivers/net/wireless/rsi/
> >
> > For me six maintainers is way too much. Just last November I marked thi=
s
> > driver as orphan, I really do not want to add all these people to
> > MAINTAINERS and never hear from them again.
> >
> > Ideally I would prefer to have one or two maintainers who would be
> > actively working with the drivers. And also I would like to see some
> > proof (read: reviewing patches and providing feedback) that the
> > maintainers are really parciticiping in upstream before changing the
> > status.
>=20
> Has there been any progress on improving this driver maintainership
> since this patch ?

Hello Marek,

The situation is still blurry. There is a willing to maintain this driver
(and several people would like I take care of that). However, the effort
to properly support this driver is still unknown (in fact, I have not yet
started to really look at the situation).

Is this driver blocking some architectural changes? Kalle is talking about
patches to review. Can you point me on them?

Anyway, I would like to come back with a plan by the end of the summer.

--=20
J=E9r=F4me Pouiller



