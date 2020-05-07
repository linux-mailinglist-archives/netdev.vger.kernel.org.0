Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B81A1C9CAF
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgEGUwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:52:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:61622 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgEGUwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 16:52:38 -0400
IronPort-SDR: 7YdQRa9xBPZ3JuIu4d2NJ1u4Af+IwkIIS/sXCVKjrP9dAmvix7GbHz486ev1Ka8jwAv2/GZlV9
 qTEVrzmzPz4g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 13:52:17 -0700
IronPort-SDR: ZjuuZOjJNGl+L0V3/fbOdWgo/ZLgar2hiVgKYZ1b7imNiFs1yMHXyvSXEX2o5JuNCQUyVYmkY1
 7xYSO9/YfidA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,365,1583222400"; 
   d="scan'208";a="370234722"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga001.fm.intel.com with ESMTP; 07 May 2020 13:52:12 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 7 May 2020 13:51:57 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 May 2020 13:51:57 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 May 2020 13:51:57 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 7 May 2020 13:51:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1fbop7WEdTUeFBF0NtjD0URof5jfiUyy8F1w2U07Bcu6fu5BSNYQ0E5dkBEBui9nmXux5mJsp6ayN4D5RPmeq+hJ+HjQq6AxtkxKgMmrUGit6ae2vLfYNUZlsDTFUai3xBAh+TE8jPij/QoLOx2idZOGto3yvC9sP/uztWWOkFDmAyN2y5xSk4zaagl9vLN1lwWwxcsftu4MK6P5dz1Jq8e0SYYtQd8HVO5zB3abADHKclIvH1f2IOqqrqoS5IWI+G8RQBwSh2Tg2Th5wIL8E0gRAhaiKkU0x5ZUuU6w0TmaqvN2As5zfnYxoHzl50P07ggcxgeMc/+Yno+mYcEnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8R3vS84mPSeDBBk1oHXxP0wjCWuyOeKyGunWHILBss=;
 b=jE90KE/ngTrPEteX8TaruhetxQHHnPye1CTSH4LBYyTVxIoKbrL+HtiwwZZclqJ1eegVHViu3iIPK+5rUNPDGxH+L0ZlqpHYPbdPMupeNlCcTw1CfiWnl2AtDW87fsUzHfP/xRyAaDOatop2xRFJ3E+cZvh1ByzUqDiGjI/HxJtBzjcaceb8FyP4lTYp1lrpIMOIGnlRu5Ey9W+Qwy3QpNgxqdnfIeFkQtp75RDWePntSHVL2+aJbmOJlyL4dzWgiubbAsK6+5uaQn51+q0PktJTWJ8uWNLYaunqLhxy+YGIC933gUMl+CnQeF+MvWpqrE6nFlR7NYGMiK60CM/ImQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8R3vS84mPSeDBBk1oHXxP0wjCWuyOeKyGunWHILBss=;
 b=Jnb+jYFVxoPYqN5F05OCLGgETf+tIprsRCdHiqLeLXTDDLOggCuVO7rhMjxCJUsJOjrAKuo0RLNjDtMY7gnWXL4nNqO2dyo/M61PX0p9D4fRtyv3F77++YmHPgh8L80ENY+OH1m4VR4aY1Gu/YDeijpX2dcLBrmEgfYOeXcM5hE=
Received: from DM5PR11MB1659.namprd11.prod.outlook.com (2603:10b6:4:6::20) by
 DM5PR11MB1497.namprd11.prod.outlook.com (2603:10b6:4:c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.30; Thu, 7 May 2020 20:51:53 +0000
Received: from DM5PR11MB1659.namprd11.prod.outlook.com
 ([fe80::34e5:3ad6:73cd:4783]) by DM5PR11MB1659.namprd11.prod.outlook.com
 ([fe80::34e5:3ad6:73cd:4783%12]) with mapi id 15.20.2979.028; Thu, 7 May 2020
 20:51:53 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next] i40e: Make
 i40e_shutdown_adminq() return void
Thread-Topic: [Intel-wired-lan] [PATCH net-next] i40e: Make
 i40e_shutdown_adminq() return void
Thread-Index: AQHWI25niFJOSSrBe0a8vH6oZkfZ26idG7Zw
Date:   Thu, 7 May 2020 20:51:53 +0000
Message-ID: <DM5PR11MB16594FEB630E54642174701B8CA50@DM5PR11MB1659.namprd11.prod.outlook.com>
References: <20200506061835.19662-1-yanaijie@huawei.com>
In-Reply-To: <20200506061835.19662-1-yanaijie@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cb60bc2-97a0-4135-9e7c-08d7f2c87956
x-ms-traffictypediagnostic: DM5PR11MB1497:
x-microsoft-antispam-prvs: <DM5PR11MB14975FA42F7299807BBA42F38CA50@DM5PR11MB1497.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 03965EFC76
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6G/gEgJj3viGWvIT0DxZdyTyCQ5Avj65QVINT9Q8rCfV7c5272yFJ++KMQ6SXHY4QPS3A2pFRsLDjfUzgQyZn5IBy0W+etbBKwAH2NFFhL2PhFDc2oJ5WDlEW3wMiyHBnfbozlc7rdnkyWHWaLcadgv5tlkizvH62WAO4aLbuhrUF7WaAiVQIqYlxwdZzGuDrHoW2MMVIqvIaLNG4EZZOqa956lAoxVinaNCf5+dP6QsaY6djwK1dG6r9nJPgenh9vzEdeHPEBvZeC9CFf9DPZUD+Emgm/aEPS2er+1qxiivCxgeSuq34lDQKwm/ztNRnOXC1QXJB95ljrYZ6AOOoLGL/xIlLrwmIyYtKFrvJAoLKOnnl4EBG/QvfEnXWC1CA1KZRGU9ioi25y7592aa1gvMSvzTRMF74lZ9gFgTUP1TwmyK1dghPbOeMKqLSf9gNla6ctNes0bFIEGMnz11udiJzA+miW+0lvN/m+FUN+AFOLOdlFEFJj+W09m+gICUFuBODowOtbKZ7JQjpQPJUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1659.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(396003)(346002)(366004)(39860400002)(136003)(33430700001)(64756008)(66446008)(33440700001)(110136005)(76116006)(66556008)(478600001)(9686003)(71200400001)(66476007)(8676002)(55016002)(8936002)(66946007)(316002)(5660300002)(53546011)(26005)(7696005)(86362001)(6506007)(52536014)(4744005)(83280400001)(83320400001)(83290400001)(83310400001)(186003)(83300400001)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: raBnNYIRY/c3i8UPX2VX7OTAdJkKei35hA1W/qc5/2MHdpEJ3v9NU+nySgJk+LRP7UxSc49yoGsHVUdIvncqfUH5SwzPxRNs/LtVD4Lg5KvOXTZmXyRQbN+wHdmhLiEis3IuvzEX7F/iQ+47Qq3oq2v7poHvoVAQHuHRedwhvzlrOTsvyW/IRbSK8lAMOmU5gMYKdCHVG6sD33J3gYB24+2yWLH8C6aExGroNysiD1CD1DdyEp1SqJ/+rfyN7K5Y5CkZQtBzr9unL6OVTfEa4848hbBPMn08HltFpBDug3nRGUxqp3Y89cS1KZIl4SbAIp+OBYZP031ogdwtfePoGxIJhUXa+uQa01Cfh6ozbQrEyku0pPkg9EBrYar8uCs6pHCfcs7Em3Sz9ndJtWrxEk9ViOQYIEu/SIL7z8If5tDF03/2CbYontCsSKNmvsCB1g3K/40hmi6MYORX53Nrs3fI3sBia8OnBXHQXbALGsz8lr5dxhYjCk//O3o1ggcN72jsIYqWg26Ov3pSUmKd51ECzK8OowyHalqgwqnvhQJPinYPWq5VOlUL7jk4vQJ292T1oAbdjVy9uIOaotsWpcQAygyoeNFrwqA8g4BRZtWoubLUPXBG7DjkfOKz4IG4cTLFc2YILPGqE3YMQss9vsUAZBD1E2xtHQt653xRjvJKTPIuMSK8joCBs5PfXIktm7tiB/BEUrykJBthTgNcMZhqf49BmuRd7M0XDEiLvKf/xjQVp4xqNcbdxRobbNX8+nI/ZGx0krd3APDCXmFCQs1939NZZG67UlfbyIdxHkY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb60bc2-97a0-4135-9e7c-08d7f2c87956
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2020 20:51:53.7226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0nA9an4Y2Dz9gGaAGakfS2szU3SXapJuu2rXmsWQAXzpv2xnRa3X+164zBTGuOGAisPrYg2m9xSR6hFiKomCxMDmzaZ8ZBLJzQotscAJObE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1497
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Jas=
on Yan
Sent: Tuesday, May 5, 2020 11:19 PM
To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net; =
Azarewicz, Piotr <piotr.azarewicz@intel.com>; intel-wired-lan@lists.osuosl.=
org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Jason Yan <yanaijie@huawei.com>
Subject: [Intel-wired-lan] [PATCH net-next] i40e: Make i40e_shutdown_adminq=
() return void

Fix the following coccicheck warning:

drivers/net/ethernet/intel/i40e/i40e_adminq.c:699:13-21: Unneeded
variable: "ret_code". Return "0" on line 710

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c    | 6 +-----
 drivers/net/ethernet/intel/i40e/i40e_prototype.h | 2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)


Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


