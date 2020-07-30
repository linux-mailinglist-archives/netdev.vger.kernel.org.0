Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBFE23382C
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 20:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgG3SLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 14:11:07 -0400
Received: from mga04.intel.com ([192.55.52.120]:60966 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgG3SLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 14:11:06 -0400
IronPort-SDR: akvOvEgVkj6YmAF/UCLc37MlhCFtPeqGvmk7xLhFRr7hE4hn9KmmudMvkdWdHFQsxVEfW/pv4k
 tPG2dZ2Z9UXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149127527"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="149127527"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 11:11:05 -0700
IronPort-SDR: XGhOtikLRFj4bUzHis/EUAMaJn9hTuP27qCHecWJYfKr5W4UMMGjJ92NJawgnOKwvZpeOtnKRF
 O0DIyhvKpm1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274290275"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 11:11:05 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 30 Jul 2020 11:11:04 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 30 Jul 2020 11:11:04 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.58) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 30 Jul 2020 11:11:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYI+GCQb+Jv+cjQu7jpeYT9GrxUs6pxuZXMgsNrU8EZWIEi6AHDqIEFMAQSOVGHQ9GoWmQIWDurAanylXFHgg8WuH1MTJehhRs5TON8qm2t+zbfiFHt/Vjwp3QA/X3T4JZ1fkSdmFsdTqQjLpfN7CrJoNVKPElNxCugHuvoeg0cH9Gb3CRF6QDzvusi3knVLzyi0tiLGV3oIhd45m48aEat9lWLBM0wBJ8FugvWTV5idAraVBjGLFld3+g52vVB5R6R9g8+cn3JahrRcFh1GLhufVAcbqa/iVO5gTBlqfK3QEdPzNlCUlIMqXrvuPBbOup58a0I0v5M8EACrSC/c3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNokaa+lICIb3HvcRCsaOQZfgtyQtxNXcnLk0VAgR2U=;
 b=kd02wpZDLJvKmEwRmxoE0alV2gb3fbnk2taVBF74GtS6Ax0vJ1K/O61dzugA/3g6zT5nI28TwCbQf0DKr3hfr/unIZ5afbaqW8P2eUf0XJgyje8E70DPnz16nJ7WRm8EjIrO0AbPSmHAl4lPSa06cv+URtTPKv+dygKBwLs7V9+zGu8NYpE5MFMIYwX5ohV0/dsihBti3lkcyEaHFWnh6uVumnH0JLhG0VjjDvmiXwT5lLzyk+0xRSlQH5Y+XyDmwhlNbcwfsdvQvO3AkP/SNgsDIMQXzkgfiVT7JN/9779A5xVSXd1X+7k0Tx6GqhcMIXtdWT7fy64d59vpim8EpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNokaa+lICIb3HvcRCsaOQZfgtyQtxNXcnLk0VAgR2U=;
 b=CcXOy1+tHqvx1ASPKx7ekbCdgonF/iDsmWiqCrqOUOgW0+uMcHs0aiJJZm3TWIe0UovwzEZg618VNbNScczeUAueFup2OA3xctu9G5uEv1WUk2SQc01cQNZE+GwAPgD22iDBgs55WjuSFznHBNtZdetPHU3ctm1cyPE54jALxew=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM5PR11MB1945.namprd11.prod.outlook.com (2603:10b6:3:10b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Thu, 30 Jul 2020 18:10:59 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::65c2:9ac9:2c52:82bd]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::65c2:9ac9:2c52:82bd%6]) with mapi id 15.20.3216.034; Thu, 30 Jul 2020
 18:10:59 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     linmiaohe <linmiaohe@huawei.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] igb: use eth_zero_addr() to clear mac address
Thread-Topic: [PATCH] igb: use eth_zero_addr() to clear mac address
Thread-Index: AQHWXm+I59f8q93ZeEeloBybSFRo46kgfKwA
Date:   Thu, 30 Jul 2020 18:10:58 +0000
Message-ID: <DM6PR11MB28901BD34266235B3CB65D9ABC710@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <1595233754-13765-1-git-send-email-linmiaohe@huawei.com>
In-Reply-To: <1595233754-13765-1-git-send-email-linmiaohe@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.173.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47a72c03-7c26-43fb-2f4b-08d834b3e941
x-ms-traffictypediagnostic: DM5PR11MB1945:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1945E6D6F5E4B35E1B058575BC710@DM5PR11MB1945.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:241;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z85JSWl+d/7f4YA6u1E0HvAe4wX7cybMw7vXhfljoQ4TanTLxs36bpPNIJeprgYgvu7a6S0R2YxpDyD55g7UJm72G7+P3y70Cmuf6PDG1aNm2+TYxD3ojLg7QwXZydbjG9y32L00/X5bGiEEdJDiLCHz8pwAqOUjt50tXL0uJesIhjYELof4Gjku0DpsWuHfjoGXeSfLyGkEbSwjVJUuvRoU3pkGsrhRlMqkZeHj4mA+NCUsQGQziJMXEzpi2O1tTHOrlyrh7lFFciTRK4iEI5i9qxg0yLoV2dM3UU8m2iXWE0SBQXz3utYJqOY3OB0uGTV0nwuw7klKUb+DjAtu0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(9686003)(55016002)(76116006)(64756008)(66476007)(54906003)(33656002)(8676002)(66446008)(66556008)(110136005)(83380400001)(66946007)(4744005)(2906002)(26005)(186003)(86362001)(71200400001)(4326008)(5660300002)(7696005)(53546011)(478600001)(316002)(6506007)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: r8FHiaWSE/m/l/JUJ5qHOa50ok75pcHomQ38g/7jGeKVEaJFKw0TE4WwtvJ/s/TrLL0qXxgZMaM9MOA71Q/9rYjrd8roKpp46UBPoTpTerBJZ9gNBHDuPMESH/uh5CDOsFTdX39aOqnvDeaMZQV8foKHO4GUXPBk0EbosS1588fCbyX/8hRH6K1iXzCj2Zya1aXm/nDVP6K5v9Nbrt9TvDN6Gj6cRZu/uoK2z4gOd89PI3zDtfnPewZ+SPyh8A1AIMkstBD2sI9/IM8mOMkXl5QtKQs3v9LYC9fx8Bm0+8ebrL242pYpu2ACLdX3vD+sYH3GuLHfHLz79mXIk7liM79x9EOUOHOQo3YmSBTWiWnFUQ0a3ODATSGxT2ng9D6DYZlMy6qibZYVc2p4kdqQsug+ZHgvrrt/w3vFFTfcyqtW/wSAtXHG+IE074swCfA8EG9SuwkPTZq6A+llGi65hIVf6a1z9rNtFXXDcsLKIfZ1lZ6mhfTZNVhM5K8SZ78t
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a72c03-7c26-43fb-2f4b-08d834b3e941
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 18:10:58.8659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uP+0zFkolpvNz/ibauMajp2J7JucMoIBghMMbn3igD3h01wF1cWo0AF/b9xLfc1QXHeC3qQ0hfZijjDpa6o3EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1945
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linmiaohe <linmiaohe@huawei.com>
> Sent: Monday, July 20, 2020 1:29 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net=
;
> kuba@kernel.org
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linmiaohe@huawei.com
> Subject: [PATCH] igb: use eth_zero_addr() to clear mac address
>=20
> From: Miaohe Lin <linmiaohe@huawei.com>
>=20
> Use eth_zero_addr() to clear mac address insetad of memset().
>=20
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
