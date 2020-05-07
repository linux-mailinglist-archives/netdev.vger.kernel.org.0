Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1591C9C98
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgEGUmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:42:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:46367 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgEGUmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 16:42:51 -0400
IronPort-SDR: 6lsKsE/Gn3xiIxZrhNmOeW8GOzCKM0+zGYBk3IeXa4k9DGmRLM6p0hIPDOFA2qflKGaLAVvDK2
 q2+rPiUom2QQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 13:42:47 -0700
IronPort-SDR: 0CS4jvyBfp4KSGaDcYDmM+8T65/4tyJ8GiNJM/zUl7XBMIgakV9ntFIQ+jOp87809deDFTtflE
 mM4X3vAx7qcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,365,1583222400"; 
   d="scan'208";a="295848467"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by fmsmga002.fm.intel.com with ESMTP; 07 May 2020 13:42:46 -0700
Received: from orsmsx116.amr.corp.intel.com (10.22.240.14) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 7 May 2020 13:42:46 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX116.amr.corp.intel.com (10.22.240.14) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 7 May 2020 13:42:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 7 May 2020 13:42:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBqZDinxz+lAwQHGJhJZPzkCKL5QshxQZjD7CS/3zKQapzB/ZbLRN3KbmvXzw9fR9Ny97Z44YCMbgvjdqGql9ghdkyLtVD0gT531R+FbmdlXLJElLAV3b2IPNsH1CpG2d3aP5LLxAdlzKOd/PxhZGao/mvLns6u7cxDemBldmPfwB0BK8m+dFyQjxmm6OHABMJiP56y/kOY6WwgpR7k3n3odPgVHXeRJSX6iC7SOfB70p5NeuxW+K3VTbeV/6yg+qZgT6VB5zY6Qli+fYlw2AQ+jNaB0nBKacaO4HJz5HGnjS5PxG3M+AC0uriWrwXe9aE8kZQwbW+Ix7/0GFqcqww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trt/SqIaEplCDwC7iGDmXiPdfbPnJf8WZqNgJVduCJ0=;
 b=Hg4X/RoAHOI3VCEdNd6PY+54jOaHnmqsBDta1yL7G24Gk8i29F0XR5ZQ3+ExxkwyMTU264TGRagS1Yj/9+zbbT05db02iMr960fWj/JZH+Gz5WCbx0ZrVnjx4AtPV98MKBFWZcXNrY/Z+KbeOefuaDHsHUZnlcAN7HDFh2FgmCwFy0ghPAeT2YgJAIJmGVvZMq6H+e6vrYXc0wy1ajgcQVGI2/dtE0puPjRelTJzTq0xtCodqnyvB1CbFChk7ddRdABNByr07nY5uUQuBoB67DJMwyT6CwV7AVbdfjjAvnhtqOcuR3vX3Pizxv61ldINyKmnYLWLTXVqrdTfSCe3GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trt/SqIaEplCDwC7iGDmXiPdfbPnJf8WZqNgJVduCJ0=;
 b=aU24/RubRYJfaxVrnG3hpw5+tKHrcpv6T2t68w1B6//7neFGY/dJUAIVKVy6u6pbkIrvzvfiMQF0eZED6V0asVK9hluPTj8InyWPbg5eS5txnGgqQdrz9FNsOR+E9++JkhvPyn472eFcNHc7z2GHlhbFn3DqbgVoi+zkKwbzQ44=
Received: from DM5PR11MB1659.namprd11.prod.outlook.com (2603:10b6:4:6::20) by
 DM5PR11MB1594.namprd11.prod.outlook.com (2603:10b6:4:5::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.30; Thu, 7 May 2020 20:42:45 +0000
Received: from DM5PR11MB1659.namprd11.prod.outlook.com
 ([fe80::34e5:3ad6:73cd:4783]) by DM5PR11MB1659.namprd11.prod.outlook.com
 ([fe80::34e5:3ad6:73cd:4783%12]) with mapi id 15.20.2979.028; Thu, 7 May 2020
 20:42:45 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next] ixgbe: Use true, false for
 bool variable in __ixgbe_enable_sriov()
Thread-Topic: [Intel-wired-lan] [PATCH net-next] ixgbe: Use true, false for
 bool variable in __ixgbe_enable_sriov()
Thread-Index: AQHWIrEZMVV555cHQku27UMWWc4JnKidGoxA
Date:   Thu, 7 May 2020 20:42:45 +0000
Message-ID: <DM5PR11MB16599DCBE62862ADE61E6BBE8CA50@DM5PR11MB1659.namprd11.prod.outlook.com>
References: <20200505074337.21477-1-yanaijie@huawei.com>
In-Reply-To: <20200505074337.21477-1-yanaijie@huawei.com>
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
x-ms-office365-filtering-correlation-id: c4b62bf2-0f4d-4708-25d5-08d7f2c73259
x-ms-traffictypediagnostic: DM5PR11MB1594:
x-microsoft-antispam-prvs: <DM5PR11MB15942F6F94A520269AA710D58CA50@DM5PR11MB1594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 03965EFC76
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HXzy0r7c/0yUH4hPcGBGq0O3t2xEVOMLyYVk9Zz6FV7evr9GJZUx1EU6qnq0tQZtmG5hiRQPqX9/XS2bHWTuD/Risbq2pprt0aXKOxs2OBJWlEe9gmuVi8ni65N4u6Vd/ym+vSPQlsBz01E6As4gcsK6zm5+VObuDFyr6V9EyT6UFFsyzCHMN205OKkVRqjfdjbVDg04Ajm0xAn67BtId8Tvsc+jDYxEun3hrcSbn9StCCuA537pNNCPFhbwdW5dZHMH544kRyhcqgpWzK/V67TqknxtR/plXLPGM4uj0KEoe4s4NER99FwgaWkrqmcBWfC0yUl8xbDCPs/w80YfAVrdQtesRwcJtSzb2AQKfcl9e8/eUa+sNrW2yfeJhGRw2+c13IZZS7qWHX40V5OT6oMzSgFMPdC28J+offbPKrZ3PjV8k/L6hiWRDU2EnrBCc091K24RnpOI2FYGhQmDd543tPbtvjuReyaWOBmxfoUtTJQ9Q81hsBQOayyiAFdODF6JRtczVbg0UrkhlVgw1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1659.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(366004)(39860400002)(136003)(33430700001)(5660300002)(110136005)(33440700001)(66446008)(64756008)(76116006)(66556008)(71200400001)(66476007)(478600001)(8676002)(8936002)(55016002)(316002)(66946007)(9686003)(26005)(53546011)(6506007)(7696005)(86362001)(4744005)(33656002)(83320400001)(83280400001)(83310400001)(83290400001)(52536014)(83300400001)(2906002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: H35PO6IlmFem5dh/0tKohDwYawb+yO4sbA2RX03HOxv3H/PgwGNqlfM3Adv3KfEhdBfTVS+34TjltfDfB5wKR3XXQyvihWolZHR0OBGALAK6as2W/pO6A4OlMlk13edP331pBh4wLlSiMOqGQ4DuiHb+au3B7ojtBoHnNvD0uO7pSwWJd/LjQssQV09s65vDusnNSmo5tLgBqQSbhHCyqQ6Sedkd8bWEWx7qTz3wo7lUJJ8ZvsuxVgM9P4/OPukpJcgSDTPBGrVuSn+KquLiIi5lwH3PwIgZ0Gbs0MnXUSkkMKDxsbJ8B5aUlveIpvGtvyvI93iYHb1lGSrQV8ROfPVsd1u8dul8JRyZ4uAERSNjRM6LSepPcr7M+dDhXWZ6ZpD2xJ0kUfy6AdNSDqzgZlhiblz0tGgcTvSbyUEft6i6We9pEH6brXUBLwg3AoA1SzpI0I9TMoXHn3Ni0w4qYuZYhAdBcKoXkGGcobnY4MlwzLTyPOWg+Xf+LOsQCZpf3VJVtb/P0xA7QImQbHPWkP7ZbwOH7J8KcB9F0A09kbRaUcio3Pg0djo1kdr6xDl9mF4rO7xuMGILC+NvOzHJLESztlSw7QrAIoyzO+7x5FdUeA6x5OerFYSx/r/SPYC/IOhpQGjrOZ+YsrliwsCYgv6+6XFFXnO97RSswiaSD55f1ofUIDdBAd2z8V8u1RBwIfqoRdhKPP2lroaPWIBpR3CppBvK4Zs6iupSqCy9uqqGxS7wLuz7F6nPo5yhsLYe66gmZHkpCGLFCScs0JaUnBfQmwEKbFWFVvFuiFoaBd8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c4b62bf2-0f4d-4708-25d5-08d7f2c73259
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2020 20:42:45.1442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jW0QhiOIWy/lMLc5X0msl5bACw0lJqz9nqY2RMeYUar3EeaVfAtAKT05haVtvG5tyJY3pEZdQQafm4YyBb2Jk4Jifc6upQa0VO0Oh/Ur3N8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1594
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Jas=
on Yan
Sent: Tuesday, May 5, 2020 12:44 AM
To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net; =
ast@kernel.org; daniel@iogearbox.net; kuba@kernel.org; hawk@kernel.org; joh=
n.fastabend@gmail.com; intel-wired-lan@lists.osuosl.org; netdev@vger.kernel=
.org; linux-kernel@vger.kernel.org; bpf@vger.kernel.org
Cc: Jason Yan <yanaijie@huawei.com>
Subject: [Intel-wired-lan] [PATCH net-next] ixgbe: Use true, false for bool=
 variable in __ixgbe_enable_sriov()

Fix the following coccicheck warning:

drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c:105:2-38: WARNING:
Assignment of 0/1 to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


