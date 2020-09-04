Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABA925E44A
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 01:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIDXpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 19:45:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:34626 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbgIDXpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 19:45:18 -0400
IronPort-SDR: vaugxngTrti7dDjjocLGBeX5jwMHS9ESWQMSTb5oUDNBVLTQ5VjNZPjwBPsAokTIa8Ncxl81E9
 GGCtcqsutkNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="145530852"
X-IronPort-AV: E=Sophos;i="5.76,391,1592895600"; 
   d="scan'208";a="145530852"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 16:45:17 -0700
IronPort-SDR: 4uIyxnHVgZkUJIO4I/fGxZMrfNnetG0BjSEtPGes4OB3n8euvijfLUO2htqOHgdqR+sXePQvbp
 j/x8Tbb3v8mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,391,1592895600"; 
   d="scan'208";a="335092737"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 04 Sep 2020 16:45:17 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Sep 2020 16:45:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 4 Sep 2020 16:45:17 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 4 Sep 2020 16:45:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7wob4R5O+EfAAiLKsgBHrE64kDscyu3MDXV23sVudNahBXRGzbbw9A+CN31cOFDz+HqqrTH+6wZresEZqB/WZ2wX2iAqCLQRTWKyPp/5B7uaJzg206VuXkD9qzeWP2aZC7ev4gZ4tDbD2khMG9c+OShluZ3uwzZUCoghprIukVFeGnbYoAKRSBpjJ9/aeY3aKaAh/O1IuO/yWVNdhLNn8IcZlMK8M9q0skWVFscDckqnPMKEBT/HHNGjQ+7ytL65dui/OJ0OMH2cnavPr9s6ibBBbF5hN0A4zGcSmgDe6ImNs9EXKFCu3HWHyTqsNqKEHSE4sd4r14eZKRCNjxLhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/W9oRfxa6vcCxFQs8Sywp10qw0JLGrUKZN/swlMW+c=;
 b=F489slT8J2u1OFcFngXg8M1ia3P/+wB78WOkboncJaogtcm0mR9esKPeadeKPkWD4n+BbtL9ra7u/qxYy8kopKrVOGbKMFRdrgvTnr3KYCpd3wdP7gkI8DKRDoIQgayerUsIiLsIApnKY/mxQPvttEGeKaJFdb8A8eDkiVc7LPSuR2CM/EcIImpWs3q6bePKWYeMqi43CFag25gEuxEsq1naWjG49oF8h60wEHwk2kQw9Xju6L2yYBqzrANzc8NyHw+9t1gvNy2ByKxflG7dICriQabXcVB22YO59wYltNEvX9bJ6P429R0bUgJW8DWeJ89aaQxnVSIMWZFp8B5ckQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/W9oRfxa6vcCxFQs8Sywp10qw0JLGrUKZN/swlMW+c=;
 b=tmkJtt9bBg6Iv1jeGyMsbcjYcy8yaG9TX9g/SvOKK1QMCCOy/FoS4oDNapCHU548+pH/fiAcpYG65oF1jpQYFrtTllJwyHBsbV/MvP/jGvTPlg/j22YjtSX9hGGMOJ/olkgBxhWVUXDB4kFKg3PdVq54NwpzrAteijiBCtZn0zM=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM5PR1101MB2076.namprd11.prod.outlook.com (2603:10b6:4:54::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Fri, 4 Sep 2020 23:45:10 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f%7]) with mapi id 15.20.3326.025; Fri, 4 Sep 2020
 23:45:10 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Li RongQing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH][v3] i40e: optimise prefetch page refcount
Thread-Topic: [PATCH][v3] i40e: optimise prefetch page refcount
Thread-Index: AQHWdS5kEcebK211o0iczgV9rrIhGqlZQDMA
Date:   Fri, 4 Sep 2020 23:45:09 +0000
Message-ID: <DM6PR11MB289076BE0502BC161EDF82F9BC2D0@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <1597734477-27859-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1597734477-27859-1-git-send-email-lirongqing@baidu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.215.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30b1376f-355f-4716-9282-08d8512c8f84
x-ms-traffictypediagnostic: DM5PR1101MB2076:
x-microsoft-antispam-prvs: <DM5PR1101MB207640F720AD8E73F2724C68BC2D0@DM5PR1101MB2076.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:619;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IpLGZgl+qF/s4FL0Y87I2YFjy3injN/dhH6ZMWQJOAlQnxqneBVpPczgqCYydxJWaJmVzOJvywFbHHJUy4Qoh6kYNLaJfpFXpf4RH02iyCRjbOI1z/Lkdv+pqRT8rE3/azaMCZhToiOUDZFhN7KQPUuHv9jz7mMVMG9Xvbax6d9dWYnpF5Mrq2u/7OoxTstXFn+HYSQ9gbR+VV3GA22VrFCRn+Ude2wkLVvKSrX40uCkPHhm4nGyoviRqg3sPNd3htJjZEsClpCHpFH8xALcA+QvhyCsTRfdPBs8fdx0anU785G+1waoJCpSvMT08bAL4WpwImRVs08GJ2/aHV7pAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(9686003)(33656002)(110136005)(53546011)(6506007)(71200400001)(66446008)(64756008)(66476007)(66556008)(66946007)(55016002)(7696005)(52536014)(76116006)(8936002)(86362001)(83380400001)(5660300002)(2906002)(478600001)(26005)(8676002)(186003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 106d/x+tYGasjP+JGprQY6qeh9xMIebkMJbcfqwJy1MQXcwFYE8T269+BBpsUN8sMRUywmjnF65RMd35ExWHT4Rw3U3tJG8XicdCjYgCDOuiSYlHIsdTcfdk50XE0NYoMgoUty6u9VudZY9+xfeimNejLhwxIeAb7xLmTm3LH3O07hbHrSMqTHXrMZmAvwlJW29URMdM3+jiCYHhN8T0pfAPUCLZuCZ+LcqMDgCMXBQPJgSm6vYACNI6azqNPtbtZMy9XBT7WnReBZ2Zr34uJjt2sl7ICeZlW3VNXjwEnqPblwThfgAiukmD0MYMvVkZ6X5k8oc04WYJnjRJmSr7bt1UJkq83I/+8cNXffsEiqJ1dNYelQD2hDLqojQkL2MIFVQ1obztiQ85o2dNw+4YX0762cEBeYtWMKUbmYAAd3uyyfACl5/2TBgrzlqyk258zXQVL1zDA2GY1vRsgqm17pQjCllrjr5C9n4se/vGVCca3y6M/Jvis0RCJI+CFGgVh0fHwxN1Sg25i8YpZc6LQZOldeS1wAL3Z+2qtHghG1P9jVQAryLcEWNfGOKJX/UcV6tbyXs5Z/0vXh/4DgwNVGFsC8t7tknPgta/mJMDwG6ieezfd7xgl8zjq5Y5/6nch5jF3ySjMRoYZPNbW6CmcA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30b1376f-355f-4716-9282-08d8512c8f84
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 23:45:09.9876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zvS/0/T4Sjhdlrw2T6oavKslYC+rlYnEFMr6Bq/jKRP4tcmBr7h/VBMoUSN20lLx/TJ8eX4pGDjpR0bgPcUyFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2076
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of Li RongQing
> Sent: Tuesday, August 18, 2020 12:08 AM
> To: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> Subject: [PATCH][v3] i40e: optimise prefetch page refcount
>=20
> refcount of rx_buffer page will be added here originally, so prefetchw
> is needed, but after commit 1793668c3b8c ("i40e/i40evf: Update code to
>  better handle incrementing page count"), and refcount is not added
> everytime, so change prefetchw as prefetch,
>=20
> now it mainly services page_address(), but which accesses struct page
> only when WANT_PAGE_VIRTUAL or HASHED_PAGE_VIRTUAL is defined
> otherwise
> it returns address based on offset, so we prefetch it conditionally
>=20
> Jakub suggested to define prefetch_page_address in a common header
>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff with v2: fix a build warning -Wvisibility
> diff with v1: create a common function prefetch_page_address
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 +-
>  include/linux/prefetch.h                    | 8 ++++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
>=20
Ignore my prior mail on the v2 for this patch.  I really was using v3.
Tested-by: Aaron Brown <aaron.f.brown@intel.com>

