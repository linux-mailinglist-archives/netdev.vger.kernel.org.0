Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196801C9C88
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgEGUim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:38:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:54093 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726093AbgEGUil (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 16:38:41 -0400
IronPort-SDR: UHxqcZesHWEURBt3HfK2/O54UdM9QnFJWTpIxLZs5SQVeOO91s0xyiABdH5g5/BTv6cCwn2UPx
 gVoAdtRa/7Yg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 13:38:37 -0700
IronPort-SDR: cIjyc3uN7sJkN4EAl9fjgtuhJV4KzYGjdKEc472g1ka3rUbYGVns8h1h/Gr/oeqUgrHFmQ0p+i
 PF/mCkyC3uqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,365,1583222400"; 
   d="scan'208";a="305226490"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 07 May 2020 13:38:35 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 7 May 2020 13:38:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 7 May 2020 13:38:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGwsR0Ha7ZO7CAHJ+gMSceigoYn99Z3WEINw2b9/TejgLOavHaSCklJh2zTYR8+pCUf2mo92SLO+4jggSpA3Ku+X6S9g+hRoEHGC+fq59XjzDxFSTNtqmtJZRweKYP/es1fEJm+LBGOrBc8DiMJN7t5yiOKVZagNPJ992ifUjr47LZGBArDAgja6HtQmriTRNVxQ/NtgxMrNlBJKkMmfrmms6DWBBDw/iB6pW+ER24wPsOuqnb/zEWgKjENCw7fTRahXMs6Jkw8JcqaouSvF6wctw8uFHbB/5Oumw9S1lbJRlU4N01rrX1U86rvtz4wtNrCOzPNAb0t4cjkoANC/nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyKLHnF4PPEXAmWD4Rc5yO6nXpO1UHSqDqq3sRnt6SA=;
 b=LNGdQApj3Rrw9hiFubQTUxmiJZl0uUIQgp8+aST8Li0axMq/jpe30sSdyGxB+mnScQDDeM0q97QZshdhaa9q4REkGuHeDkifExjxhEqAsvoF15uQVyi5r9bFQoR4qqg/zUfVaOyLYmb1mnUSFPuVWSvRNKVvixkG/CkwYd7JvphSLg0VF5vgq5QS2Vi4r0vOuh/8OtSAAf11Jtr62D0SfEML4q/5/w8WeArMWQzlp+/PwL1b0cJjG1sWbEEJ5OX+jw7QsWWNY+uqzgJrpregq6plpfbCnsLecNoVl24K+DGv8ZiC4EXkPuLl+ep/ZmGHXNsV7k4DA1Xu2P9MK6stjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyKLHnF4PPEXAmWD4Rc5yO6nXpO1UHSqDqq3sRnt6SA=;
 b=ARemjsu+qKB1iM9aF/XVoBmKBHqtTBShAOBEUwE0CBJaz/pNGB41UYKCdkLpXtCCkudsIHW7a3lZLILplKOo80hoC/GJDtYdLUUfC/DmxL6bEC7TLPCbtDRE1fgUvR2a+UIdHQe/MLxOpDVx1pPPVhIm75+jIu1fvB1+PaFSQEE=
Received: from DM5PR11MB1659.namprd11.prod.outlook.com (2603:10b6:4:6::20) by
 DM5PR11MB1916.namprd11.prod.outlook.com (2603:10b6:3:10a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.26; Thu, 7 May 2020 20:38:28 +0000
Received: from DM5PR11MB1659.namprd11.prod.outlook.com
 ([fe80::34e5:3ad6:73cd:4783]) by DM5PR11MB1659.namprd11.prod.outlook.com
 ([fe80::34e5:3ad6:73cd:4783%12]) with mapi id 15.20.2979.028; Thu, 7 May 2020
 20:38:28 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next] ixgbe: Remove unused inline
 function ixgbe_irq_disable_queues
Thread-Topic: [Intel-wired-lan] [PATCH net-next] ixgbe: Remove unused inline
 function ixgbe_irq_disable_queues
Thread-Index: AQHWIrhjV+hk88Bt0UaP/JtHzNMsZ6idGV1w
Date:   Thu, 7 May 2020 20:38:28 +0000
Message-ID: <DM5PR11MB16593A317D17A0C8553ACE2D8CA50@DM5PR11MB1659.namprd11.prod.outlook.com>
References: <20200505083554.25808-1-yuehaibing@huawei.com>
In-Reply-To: <20200505083554.25808-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33ea9d29-78d2-493e-1a00-08d7f2c69980
x-ms-traffictypediagnostic: DM5PR11MB1916:
x-microsoft-antispam-prvs: <DM5PR11MB191649B6F5E781A49630B2828CA50@DM5PR11MB1916.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:39;
x-forefront-prvs: 03965EFC76
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HE2N1aWbbCVOJjhvwTIhVVSfdfH1roT8/nOhvnutD3RzqUVa2nzVlVLYpWUWvAOVSQcvpXE82dcDiBYvxtAHC3Pkxu7lqnPZpgdJpPJK0GHueXtDZs/YLdu18UV/Za+qNmw3UEXX90f8rYOm+bs6KY3FwRlHKRH+kcAUYuKRHvALqG9p7zl64Fh2JGA/SkJKEcC3sJw4ZWWkUsN5dzrcG1bJKb9+IyTospQC96Pzk3kLcGaQvuD1zo1YxhXVV3M/CpclbbJtvLuwZWEQggU+YO2+LBHeC5sRhJk0tmU3Dk65FD2IObwcUh41DrjN2hb7Wvy17uqCcMqdXywZTUAtBdUhqrgO2meIchU2AgNxyDhVj82QVCofE3Mk2W258+1StD4eR7YG2Muagvyanu9J/h/FjZkts9HsODaK9VJx8dsWgqEE4UxfCIT8R+LGlxKCwMz4wRinrBYOQF9DUpomqnWKKFWHVZPFvw387gATSEaIrp/gC8RBPDldosflW0GgrlIAVRIeS0wccufROnzq7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1659.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(136003)(39860400002)(346002)(396003)(33430700001)(76116006)(7696005)(66446008)(8936002)(186003)(9686003)(71200400001)(66556008)(66476007)(52536014)(55016002)(66946007)(110136005)(83300400001)(8676002)(26005)(86362001)(83280400001)(33656002)(83320400001)(83290400001)(83310400001)(4744005)(53546011)(5660300002)(6506007)(2906002)(478600001)(64756008)(33440700001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NMUN+AkuWAD8hP2dLAOfr4YHySe4kLLS4j5X31vq3jiat/GamrsONQCJvhuEZ5MMO/apXBrgE7Le51ec8Rzr5FhO2+OHGg5tBOCEmnOnkeVSsWqeLRegl3IjaP065/CvvunGABJpO8mFxHUU5dFOu75Rw3D1xGT3nO9clwdnmyCX5R4S7HdEDe4D4eTxsnwkYwVNI+15v2sOMi5Gv8jXen7rxWL7+5CjrWZK/D+NJufuTG9t5+N61ZngOkl6mDcC7U9rLuDJhlJ0Ma0Hztq85QStfL9/okx4IpYNxWhwpzB+tG1TQtiED0XNcH8KDZaocIBrDGfoAG68/k7Z64vQO5DfpaHoOqd4RZdrPOcNbKdpHdlrpFi9qzXkaYzULr5SVD8OAMykZoUAuy4OBEV4bmJsGGWW7cjAWFzJMB82kXzUEkg0ef7VZ3ZZ6SrkvCoi+YEZK+9JXxvlxxf/E3g0yDmElxVNi7MXCxgDiN31K9Owj6SKnsoVBGgO2PR4l5Es7EB1IqLgtyf7vrVwdyFwCfN5aKBetHxnzjMxKWRPPk9u6ZPaZj7yPMn46zyj+mJakQcuOIMluB8R+uGvd59pO++bCrJysP1vRKGaJ7FwE04EiG7lqzfhoiWLPZyTR7wrjlMiOr/ca1IUyaLebH3QFXzV2sqjf7Ct+6VoQCkLH50EkBXoEMtNDgEvW+7WWDrrcFHjq+C91xUTQYqrQ0kJtChCwkea0yqno9FbVFXguGnxOx9UdLgUjcQmnVusW3UkYJC5IkjY9OSG/xTWCC9asElktARudI168sprxCbZRwg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ea9d29-78d2-493e-1a00-08d7f2c69980
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2020 20:38:28.7740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ke4jjEMx+mmQ+GGGIfkPcoP+Pojc22FMwGnr+c+/o5s131BYasssInmV371iZSZ+XptILvA01W1ba1zQxYdEMixi6lcUY3LQeRwZuwRmm8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1916
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Yue=
Haibing
Sent: Tuesday, May 5, 2020 1:36 AM
To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
Cc: netdev@vger.kernel.org; YueHaibing <yuehaibing@huawei.com>; intel-wired=
-lan@lists.osuosl.org; linux-kernel@vger.kernel.org
Subject: [Intel-wired-lan] [PATCH net-next] ixgbe: Remove unused inline fun=
ction ixgbe_irq_disable_queues

commit b5f69ccf6765 ("ixgbe: avoid bringing rings up/down as macvlans are a=
dded/removed") left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 29 -------------------
 1 file changed, 29 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


