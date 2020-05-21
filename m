Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0B61DC799
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 09:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgEUH2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 03:28:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:34945 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728265AbgEUH2M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 03:28:12 -0400
IronPort-SDR: TODDjnfUr+ai3JQVGvqeeHuYSZcvT62g6WMAxrXyQGbWC0M9Gb2JH9Z6X2A2o4lcY+9ar+5Tf7
 t0XFYLJD3c3A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 00:28:11 -0700
IronPort-SDR: ig+6r7OpeNQpkCmWjFNztGKt55XqSZxBrptfP8QoT5cxxfOA2aTtifAdLEKweUmESazqsfPq6f
 XIXPfTXtscMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,417,1583222400"; 
   d="scan'208";a="343758758"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga001.jf.intel.com with ESMTP; 21 May 2020 00:28:10 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 21 May 2020 00:28:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 May 2020 00:28:03 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 21 May 2020 00:28:03 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 21 May 2020 00:28:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5nN79oSvHuEqmD3sdQeTk7/1SJ7cgEA7TLUC2p4wJa68Nwe6kp4MYGDhRGFoqpfJeHXXwh8HEBwqiUo4pJ0FO5EFW3giNv0T+tIOxnY3xXodFh8uIT2amW8qhLj+b4cMP/0Kjgd6LKQC6XIQZIwflki3UMRkyzdb0E4HLR8oW31CoXCVR6Lqpq8Ldqk6N8+t4qZgRX0S7M9+pxdbgb1gOfvvVVGQnIAhs6WAbPQmOMwRzIf7tEebaahIN7xTPVjqcMP7IGAJvCJZ4rh+2WO6tQiwfrOtFg9yFcfkrVGbqUKwjwtNkMHUP76ouO+1O+ZwvjQ8VzsGvPiFgx83r0LjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6rKwDmkVV2jlKIha/hxNJeCu5trBEe+dFatsSGxw5+U=;
 b=HMU1mU9KsqZTEk63oXQGE/0dCkC2Ukj6/eJGRwkRAmjpFaI6N3h5CPCv1DRGFMDHXvcYJgA6vGd19ep1O/r8OKqbfHO5rF6gxAOBDhvRoMqnezMFqpnIZOarmTK35mssfWnH2V+seltSiLpwxLdOi/RAPLSz8nfTeYZJ+owt07QvJdnsXn32j/XnviIqjbWEHEpx9oSzalqGKgM9NYeQDsthqdznDZK+x70k1LpHNTBVwW8Mbqk3FS5/fNIW/p4LIHaEJoqVL7mRWOfir8WrBqbbNP+RbbJpuEAusuSjH6GWD8LXvIU2LA8ifS5rTi6vxbBgd+VUcLlnEPnKR2qUlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6rKwDmkVV2jlKIha/hxNJeCu5trBEe+dFatsSGxw5+U=;
 b=wdpwJKPNCz6Hpj/TTsMOllCZruiy+dBiomVZrwrkQhxptk+XnALCb2i2xuDo4FTUPHxUivVzebmvgoS2Wwlcj+T21GaK7lonQulPSbNVUzdJ2ieBpaHvr06VFE8vA4pjgBW1hPj7kM7katlZfC0aZ99ZxV7+ap4eUSIaJPjY4vE=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB3001.namprd11.prod.outlook.com (2603:10b6:5:6e::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.26; Thu, 21 May 2020 07:28:00 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875%7]) with mapi id 15.20.3000.022; Thu, 21 May 2020
 07:28:00 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Jason Yan <yanaijie@huawei.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] igb: make igb_set_fc_watermarks() return void
Thread-Topic: [PATCH net-next] igb: make igb_set_fc_watermarks() return void
Thread-Index: AQHWJGAuISXMEjQLckCV8vKCyHNEfqiyOb5g
Date:   Thu, 21 May 2020 07:27:59 +0000
Message-ID: <DM6PR11MB2890A3BB1993EF97E4368F06BCB70@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200507110915.38349-1-yanaijie@huawei.com>
In-Reply-To: <20200507110915.38349-1-yanaijie@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c18b27d-59bc-4f04-9e43-08d7fd587d7c
x-ms-traffictypediagnostic: DM6PR11MB3001:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3001BBB86BDB86413B1FBA6FBCB70@DM6PR11MB3001.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-forefront-prvs: 041032FF37
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n51z531juMO7xV4AJlgT91PGdAp/QuI+orG29HrzZKvlhQSL0QfVqkfHSFyE8afIpOLgMfgJqWkd21DfPmrkwu1TH66z5yYphmui2sDHnQ6GStMaQtZhUYTvTECz3pGPaB+ze79lyg6FBaT3jKrAa20zFpbi5Yg12lvN9NtrrZ0iUlHC6DYAUkzembWykogVqnh+ZVAX2JblZL6xwmlXOdKNABMn2Pugj4fJsMj+VprBG42lWEdLiODs4WFjAI54EJP/0cmqxGzXSqqXUGxdbQn+L/Nd3SjEeMwtLX5Z7wDLbcXOAGAq7QstpCBj9seXAM6da7bMhXmU4Uz1M82vizvOCr43OTYgKG+nDzGm7Haq+UBmegp9uYxZVSETvmxqJ/frZA21o9tIAikGGwiB1gHzEJkH4tV8MBEuyc3xGCILgNk7mjilzWA/FKg/T+rm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(396003)(136003)(346002)(366004)(39860400002)(53546011)(8936002)(66446008)(71200400001)(52536014)(8676002)(7696005)(6506007)(33656002)(478600001)(186003)(66476007)(64756008)(66556008)(55016002)(26005)(9686003)(76116006)(4744005)(316002)(5660300002)(66946007)(86362001)(110136005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Wk5XGyVVABLv01CFN/wpIyahwDz/XV9/P7EDdNMHRoFthD2DV89vx8QC4Za3fA3amJUnt0Ml9gcayGcICCiMBbh0t6yKD+mRzyhpB02KeZXyQwG6Vv5PviZz8IN72CFYCfwj0dS0JYWNbgOJVHd9YekQcBzbsr1Ak/nuu+fKj1L76c1tfno5uDCxFlRdYXleJIOdrxd9tX5c/LbfZqz+G8Fiqr/ph8JTGIoWGovPs676G+psawG6I5PVJvclmFX2iOjwVbM+Qo03bJMTVn4K+PI8dKDVMA7HmpVWue/8ib8tvmo+gA5tpkKndbYA0/b9PDBloqgS3UdcF8FtFTVCbhkixoUnt8m2Tu8HsgMboZ+eA5MVuSFbXP9lTTugxGBNvT2nzNKQkzzuyKEZXQ5eM8JQPk6P05tc6atZaHieZP+wqUcCBWajYnLUaBD5imQ+oMrCKZ5En6DvVcV1hTJnZWdQ6d9PLy+PRP6xScJJ5e4HnQaSHlQyIbhhm7OknD9b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c18b27d-59bc-4f04-9e43-08d7fd587d7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2020 07:27:59.9103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rf4Cf14qfPOEbSKxP4JNhjRdFWC6RC5GhHNTwsAO2CA8/oAzyopuuAOplcSPP+Z5OGDxuEgrkh/PVGnHg3XtCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3001
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jason Yan
> Sent: Thursday, May 7, 2020 4:09 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net=
;
> yanaijie@huawei.com; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH net-next] igb: make igb_set_fc_watermarks() return void
>=20
> This function always return 0 now, we can make it return void to
> simplify the code. This fixes the following coccicheck warning:
>=20
> drivers/net/ethernet/intel/igb/e1000_mac.c:728:5-12: Unneeded variable:
> "ret_val". Return "0" on line 751
>=20
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/net/ethernet/intel/igb/e1000_mac.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>

