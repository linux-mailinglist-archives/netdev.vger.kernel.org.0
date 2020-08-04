Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB5223C116
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgHDU6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:58:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:2706 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728394AbgHDU6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 16:58:46 -0400
IronPort-SDR: kpnJlzr9i3tua7dAJ/2rfWXHysFohvxzijt61DUEGI8QB9nFNqGsOOIg5g7zPuaErbmCOIEekj
 +hB+MsuSetCg==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="140321086"
X-IronPort-AV: E=Sophos;i="5.75,435,1589266800"; 
   d="scan'208";a="140321086"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 13:58:45 -0700
IronPort-SDR: rri2YYa+P9CbfvwjOR/xwMf6PhNlBVYqE6fhG4Yv06JjRX9YD1XPz9WujT6yPXFvPaTOVNpV1h
 mgCcCv+J23Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,435,1589266800"; 
   d="scan'208";a="467219737"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 04 Aug 2020 13:58:45 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 4 Aug 2020 13:58:44 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 4 Aug 2020 13:58:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 4 Aug 2020 13:58:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDHIuDgMLQQYsVa24ObdW77WmCb+Y5TQJ4jypsPcOjrqVmY6cfOmzLGThzgPwWTe2U7+sdSRQ4GgjqqBuYdpE9R5xCY/l3r/robojk8dDJPQrHlz8JqaCMWUqqvXahzplKHJMrOhJivipONyGeXvCqdhTK/z5qeYnCxRENSpn6to7EPnMpdMom6pPDYQ8S8vGpsAxz5Bc5PUqm84F3JZ+CaT5R7gc37pEdZXBoXFWbVAyA/jvFL+q2BTEgNrJjhsiMjXOIX1CbZRLSd6fRkypOpOszau3ZMqwitax8Bl9ilnWlU4tTe1SF1YEoAuFxoyBgnVZjKAAtKVWFpPY9PPjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EK1hLSvQNbx3Fuh1ZwLnTyWVFvT7ZppujTh404NhyuA=;
 b=Xsd03fGHC97t95lMAAjJldAMUBDU5aoWgLsFXLsYoUaS5vGiw7JcUeDF6n7u0mNKZ/z+GwlK56RYd4XP7kUCE7uJ+JO8cZ67XWex1tgqigtldAuHLpTGs/3CqGq/WSqWG/oUgi2iKrmvxB7sfWov7FkpzuLf5uu5BPzmixrfAfPcTAQj3g/2O8YF1KziW1XwgqMbA+yyceJHh8wUTcVUtGNQZWyCnYUsQpZBz59ybElHYABMfjtGRkVnV07kGcsRC568jI9pZRNL3Yza38XJmssn6dGIIkpALIA/seMd+waLALOV+0qbMN/rJI/I6u3p8ysjjwEHU5/Gf1aaUneUmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EK1hLSvQNbx3Fuh1ZwLnTyWVFvT7ZppujTh404NhyuA=;
 b=Rbc75IYiSlWoLSvn9rY4mbz/qiraxa10NjxWPpaTL21cVOPRbjfXlMgchDGJ6BpDy4m3vxltr0QV4dZJfc6xMIHtEZ0kXd252yWzQ3iliYQd9vhf7R3pfZmO40Q+TJyYVtEqiY7s/lYOgumoVaPNbV1knG87tY4HUT1Y2GDpUxE=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN6PR11MB1537.namprd11.prod.outlook.com
 (2603:10b6:405:c::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 4 Aug
 2020 20:58:43 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::3c1b:6500:3edf:eaf0]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::3c1b:6500:3edf:eaf0%12]) with mapi id 15.20.3261.015; Tue, 4 Aug 2020
 20:58:42 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH][v2] i40e: optimise prefetch page refcount
Thread-Topic: [PATCH][v2] i40e: optimise prefetch page refcount
Thread-Index: AQHWZybApSeEI6IAT0W07Fq+PwlK26kodalg
Date:   Tue, 4 Aug 2020 20:58:42 +0000
Message-ID: <BN6PR1101MB2145FBEC323CA803DD7F1DF78C4A0@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <1596191874-27757-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1596191874-27757-1-git-send-email-lirongqing@baidu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.59.183.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c05de87-973c-43eb-4476-08d838b92bc5
x-ms-traffictypediagnostic: BN6PR11MB1537:
x-microsoft-antispam-prvs: <BN6PR11MB1537B05CCB197430B4D3013F8C4A0@BN6PR11MB1537.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:317;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uPckcbHpp1coEG5tTdQ4cUhn8BXi8V+TqzxMHUE5kSbC7U1Y895XP77Ierkv2Rc03o8sTHizUZDGETGeBX2yaPRbrih1owoK+f3eRKy/zc7GTU8jRD9s98dZ3oV845Rg5yfOsn8Mf1rLDH97Oax8HNQ4qjHJJ9gDHL9cG5xuMoSfbgBHFAdwT4zlYaHszLEPKw620iqSKR8RA9ngDjoNPfbVrepfrpy0pEjtQ5qeafsk3/nBIfF0moq7dl+92+Z0M9fnLWE9b8mFcktAsLuMWTzTEoNOu+LPs5KycOW+X1nY2zM3+VCb3NhBIU8xkNnS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(33656002)(83380400001)(64756008)(66556008)(66476007)(71200400001)(66446008)(8676002)(8936002)(76116006)(2906002)(66946007)(9686003)(478600001)(55016002)(52536014)(186003)(5660300002)(26005)(316002)(110136005)(53546011)(7696005)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: buR8XmtbZZVod4TXsPF47twBNroH3Y5PE5St+PrHJdcDi+YmVTnPBkrqeHq7pkxwdE1HUbEI2EnmOfYzGjlKr5DCHmN7ZBGfOrQJV/XSw/y5mp/rhzrYsVWjE+ax01km8LHjsIBhmF+DNbnA1CQIZtK9/Yt/tOZ5El0GbYNnjHTewH8TnVzSyn+U0T0hdhDC2vsiRfEmLEX7ArVxY1x/fmRF8ZZPGXanVGoloWS6OMuXKiSsbD3o0lJY/Wdigx0YaMQFu0dkxt0sT1LwoTMe6r9+dd/AyVl1QVafhGQUEOrUCiNmbyoHHZr6q4fa5nmIveMKtH8hU60nFHnpu/SflCQ+jhWMkuW9VVH/nTbwYY4DZGEniMJkKxMqsxuOanXkEpu/dgl1XwEGoOvvKAALrCnQZIWkj+cjmElcK11REqDjy/+pCTnTmpu3wf2b2kaFB2MtPztBVW7g8pMM4LhX4sEO5aFFIkXwx+vaOUzKt+AtlslzDj++U5XU6yPLLECIZf9UCYQ5ydH+G4S0fGytBf/mveW9nb9BDed4JT0Qhrv8wEbeCYw1hBjWfunBL8d0qzswMiSMiQa1KPw7us96ce7VlgRZ6aJNASP6pwI0vl02WTkwxHXsIKrDVjwM4LI5IpXpxtaDL9JON2T7Pcuwbg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c05de87-973c-43eb-4476-08d838b92bc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 20:58:42.4789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wkj+1Z2xoa2cLu7YsPZNWoMPGuAIN9gwghvkAhBcO58OjO9b4/XIcm0YDnrgEbiL+eeBunitb/alZx3WUZXjpuLPJ64VwicJIOP/cW95Ppk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1537
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Li RongQing <lirongqing@baidu.com>
> Sent: Friday, July 31, 2020 3:38 AM
> To: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> kuba@kernel.org; Bowers, AndrewX <andrewx.bowers@intel.com>;
> Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Subject: [PATCH][v2] i40e: optimise prefetch page refcount
>=20
> refcount of rx_buffer page will be added here originally, so prefetchw is
> needed, but after commit 1793668c3b8c ("i40e/i40evf: Update code to
> better handle incrementing page count"), and refcount is not added
> everytime, so change prefetchw as prefetch,
>=20
> now it mainly services page_address(), but which accesses struct page onl=
y
> when WANT_PAGE_VIRTUAL or HASHED_PAGE_VIRTUAL is defined
> otherwise it returns address based on offset, so we prefetch it condition=
ally
>=20
> Jakub suggested to define prefetch_page_address in a common header
>=20
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff with v1: create a common function prefetch_page_address
>=20
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 +-
>  include/linux/prefetch.h                    | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


