Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EFA475542
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241205AbhLOJfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:35:32 -0500
Received: from mga12.intel.com ([192.55.52.136]:42840 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241191AbhLOJf3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 04:35:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639560929; x=1671096929;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9+28yWy+U3CfpAFKhwL5jeZgmxsrrPtqmcm6DyFjsY0=;
  b=CwTTJX16FQ3ax5u9/OXx381I+yRC5wRFszltf6ZEgNqgt74c/tSINulT
   4dqwwF39y39Tn+r1L7ti1yR91UB9E2LVyzwZSaoJp5USrmc66HJSc+cKS
   KZnIqo8q51PrOokzEElrjDywv+KvRNsoYXROBl+ihhC5qPY+pJ0m3SkNg
   vBBnC2+eGMYSQXt98Qy/efEmDFQO0hFC9lG2+SFBXRZOLFA0o7P4ee2OO
   HMjE+uvkslcKsEyQz16/kryyYh359RahH5LzV/tDyaJhTgFJttBeH/f3V
   S90BXrjw+KR1NVutUwWfPvCw7ejjjPBsCsgIGRJ83wiPDSMGbezVwJTrJ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="219204499"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="219204499"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 01:35:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="604869229"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Dec 2021 01:35:27 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 01:35:27 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 01:35:27 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 15 Dec 2021 01:35:27 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 15 Dec 2021 01:35:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nU3QYp9A72+z/UlrTCkcphV9rVJYOheMH4WphwlLOWGhyFpoN0bTOgX9euX0QJ82oqAB11Khm36XUBjMfUzRMYNgJoceMF8RntaqxKC3dARr7BEWqiU+koWq3jE5kry78IdfrlYPuX0104a58bYZ9MuLI5ysg8vyzEqa+e65w51yxnAXef5UcDZK6eQAkrdjWDWMKzbZLO0kkeZB/xU23Y8RKcujcb0IItd8xGyc2GGxC2syZUcwoFsF2vHrTY/1WL1jbsv8ZamrXuZRMtGzEQMicztdTU9EMpcdiMPUVFLCQR3S//NOkQqYi2iesb12dRMlk8hRFXmwUv+QsAUw5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0s43FS5KDUn1hE7qhq1yQ0noBwbzSZJr/qNVRugEof4=;
 b=Acl4XszjG46xSbuQTwffitGvqJSB2bIPnsiu/Mwa0/pE9iPqBpytvbSXGGkUr1itaSD3ggdOuvYLVjXCPMXgaYsoWbN+fzo/YZuNkGhCFPmuKbHDZJgnrxhBT1JRJPcIxvhGqFHwqlqRFFBaD+TMibbb4NeurcNfu184nEwXeHiKVBT5KvPXDjyl4rliIx5jUPwh8AlKk4Fbn3hNjbaArjBqW4G+GZGMqPrqLTIYHpW0D3HL+gz3zT37h4qUh+3D8hWj/Yk+cB7Z9WjJUsrtNZp16XANqNUs95m8kez6hQe2LR9OTdf627Kge9r7XwPLgdnmlupI6JCVwrfssJXBDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MWHPR11MB1904.namprd11.prod.outlook.com (2603:10b6:300:111::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 09:35:20 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b%8]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 09:35:20 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: RE: [BUG] net: phy: genphy_loopback: add link speed configuration
Thread-Topic: [BUG] net: phy: genphy_loopback: add link speed configuration
Thread-Index: AdfwtmkvCyrAW5M4S3mERBKDxICdHAAGBHqAADANSQAAAa06AAAAYHXg
Date:   Wed, 15 Dec 2021 09:35:20 +0000
Message-ID: <CO1PR11MB47715A9B7ADB8AF36066DCE6D5769@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <CO1PR11MB4771251E6D2E59B1B413211FD5759@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YbhmTcFITSD1dOts@lunn.ch>
 <CO1PR11MB477111F4B2AF4EFA61D9B7F4D5769@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Ybm0Bgclc0FP/Q3f@lunn.ch>
In-Reply-To: <Ybm0Bgclc0FP/Q3f@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d25e84aa-545c-43c7-fc98-08d9bfae3653
x-ms-traffictypediagnostic: MWHPR11MB1904:EE_
x-microsoft-antispam-prvs: <MWHPR11MB1904D521DF119655EF7D449CD5769@MWHPR11MB1904.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9SI4R5WysPRb0wUbEIuTezqQJyeXEU4fC5nl8jBN0/rcYGeq5AYnyqud+r5GxPeI+wfG6Et69UvnbT0xNkS9Btjmu7e48zz6kNBeBVEHJDqbYI2hZOWPgat1tu1EpCBNvNRorrEmDUI54NtXC8XD19RzZhgUImU7qs3ICbUnRTGz/26tWGcTyk1aoGjcwY3c2AgMH3UCk8UkdsGdgaFqBWOZrV4EFiYSVTzwy1zkMgJNDU3OOLd/RHt/Fe3wVLSiMISlVTVTuYvWphIz5osE5+OJj3233zUZdDOHte+ROXsS6iBCDSeSHNiqlv+MYJ8u1DTUV7tHG2zziSU1+fG6Jtb+bj++a0NEiIZxBYjGwY8NwFh4M2ESMT8PpoF3yb9ub/XTAFIl03iXYTWT3vP5/k/ilMsVq52jvO+TLlsso5tMLkZsNe76p05pLxqUBUY0OgY6jVjvHX76p6MJKEve1W5LBfralbzbQuHN2HEBMvPvIvvvDVRjORGozazjQT2t83YA9DTJATSLTJ121Y6hRWuysbmr31usGUWa4eJxVhWn+wGgL3B/fWwcOYiLUKB2Wv52fTkyXrpF/d0gXBF41694Cua45CQMy4GyyfM7GQFcs55MKn7aQD3ENI+L4V0dnd1U9TH2gHqhWIC+n2Y8QtKLDfGmJzRYA6D2LzJlsnXO0CNMBjxdXhCJbSjMg1ELeo5ehNSCNPO87ofDUWD06Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(54906003)(5660300002)(8676002)(64756008)(76116006)(55016003)(86362001)(6916009)(66446008)(122000001)(6506007)(4326008)(66476007)(66556008)(4744005)(66946007)(316002)(7696005)(38100700002)(33656002)(53546011)(9686003)(2906002)(38070700005)(82960400001)(26005)(71200400001)(52536014)(186003)(83380400001)(107886003)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GN/xRawQzJ2OjPImkYQthpkdry1D62GBDaJUFRrAXl1ulObwO8TXmNN6Q1cH?=
 =?us-ascii?Q?iHvQ93TFo2TZUTQfEyiOHvplOGDabPw+QVVJDbn4Tb/pO/GjENqlHCwA4bq6?=
 =?us-ascii?Q?nab+lnw4md7lsb4PT3E28jkn9MZjb5clNRiaK4vgk1QWyYWq8Ljt/rh+DX+q?=
 =?us-ascii?Q?KZidvSxaRdRnGkVaDK6tWhOjZxrXX0hHiew4euBGTsToYepcg6iO/0gDjE9C?=
 =?us-ascii?Q?0YXNzd9Lp57vs0woS99e8sQu9mD0DXJw8ZiMcvRojgY3qL5oNzFqThow5FGr?=
 =?us-ascii?Q?alNv4DJ/X5J7Jen9euVIBU8eh8FOdUWNzMk94ZoAEb0Z91jn4OTMkUVLLhP3?=
 =?us-ascii?Q?//nMnRRALG4JjmUXcVOwLzPyD64ThX2V887/ECHs29ZAL2SNv+H2cuJ+3iEg?=
 =?us-ascii?Q?CYIIGk9nGxabqzBmonqPnmC7VJr+S7uFWfAxnzvNr3q/6y4lwuXN1xxlusQs?=
 =?us-ascii?Q?b5JvL7XDe+nwVmRR5/RUYzhVhddNE0NenEQ2nTSPo0G+mhjHUtZfK3ynnKyo?=
 =?us-ascii?Q?Ojdvr2CUfjBDeBzub4UeEteKGTktr9Wa+flcjhEFxC6tVKx+5ymtdA8chhTY?=
 =?us-ascii?Q?PEEPE3k2m7ljdD+50Grngk+Tn2hrLLZYaT/OxlDEFoHeS0PFYl5wUyWwAa0n?=
 =?us-ascii?Q?iLYeQyNfis8/qU0LEt2kDahx2ame9Y3/+h/jwWPNTR6CYeDCUx35HUGybUaf?=
 =?us-ascii?Q?8N/zkiEt7OPWAxj1oJFdFwW5g9sA5YtrILxev7IUq0LXQSApDWn3oi2+YON3?=
 =?us-ascii?Q?pfySKGH69UVMJgATTeB1rzhTl/MTezzEbM1GUP/mAeaI8vi9K71RPIlG61wb?=
 =?us-ascii?Q?cs1OHrHT9LCQAt0Lf+ClkyviNnNt6TyJJ2QxDhFpsr/tI2aHCreVYXvmpn7D?=
 =?us-ascii?Q?qBxhd86Yk5Z1qASLULLdFNuXMAm/g7Bwx8rrYe/WY32Q5uGHhVZ98ziwsp1f?=
 =?us-ascii?Q?Pjdj+dWxrj+KQrDJ3J6bdJ9bOM2tRCwDIswrTVO0gvLSLWXvMzu2h/mV3zKX?=
 =?us-ascii?Q?QT71zSk393G+ggG645GyR6lnv4Q6bMHz7ELw9EWWwXJbbBeh7VNa6e1Z/Pc0?=
 =?us-ascii?Q?HBSO+5K8N3LyOBzGMYSbzt70sBpUzebyCXWVQXv/mSnfWr9qVVS3RBkJ8cRS?=
 =?us-ascii?Q?D8tg3KDTP32lo94jAqd9KwUnIr61PcSU+B6KrhDygrXlZOyQ2M4QkzRt4lQz?=
 =?us-ascii?Q?DnsJhfAKnk0ZNTfWUq5HhmE7EjYdqTWvsAAOkXTk4ZSE19mZpHTqb5AKsvRD?=
 =?us-ascii?Q?fEengT1LqRI4MlhSLaL9HrEGky3qJGupDs9P1Y4o6NVEGH90ZwXkVJVnhH/2?=
 =?us-ascii?Q?wQNdvciHTtY08f5LUHQSbWCupu1W8lvQYsNvjBBdQunjd2eQOap0aJkcaYiw?=
 =?us-ascii?Q?gX16JmJSVm3/8j34KC+pjxIqLkptFFPHWyvweK3lQWpncSmohtccnX+yxiYe?=
 =?us-ascii?Q?u/VLR7q1+tnX0YFL1Xj+pHIyK8kZm1RNlpZxbgHBJ0+aR9MBVIN8Uvtbi6io?=
 =?us-ascii?Q?7jfnZhZwl5TfVFg1wyVQ7W0iR3jBBfuXIguNCmcBPIHIQHJmFJEdae8ml9JR?=
 =?us-ascii?Q?YrqsLyjonSh/Fm6sO0hnqFx0KFlonJN+AxVVs3FtL/fFhqWqpn9kUmMQHlLQ?=
 =?us-ascii?Q?WT6a5lp/l3NifkQZ6DH29XgTKPUaY7n6/HJ1TslpLYYRH3KzGvEf3mrENLsy?=
 =?us-ascii?Q?CGjCeEKCcbZIj6FhwEw3knuktFaRwUFvdtb3V7FR9x+RWQrE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d25e84aa-545c-43c7-fc98-08d9bfae3653
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 09:35:20.5468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cnPmkyCFPLR4zQmd92FQaU28uspjpX6r2MrDqRWHbVoRr2+a4SGW4qiTlav3oWWeGSp5xv6XALjltVTLWA4us856HqFo0sJY0mjI/ilbw4csqxF2osQMhrHSwMDVHih8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1904
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, December 15, 2021 5:23 PM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Voon, Weifeng <weifeng.voon@intel.com>;
> Wong, Vee Khee <vee.khee.wong@intel.com>
> Subject: Re: [BUG] net: phy: genphy_loopback: add link speed configuratio=
n
>=20
> > Thanks for the suggestion. The proposed solution also doesn't work. Sti=
ll
> get -110 error.
>=20
> Please can you trace where this -110 comes from. Am i looking at the wron=
g
> poll call?

I did read the ret value from genphy_soft_reset() and phy_read_poll_timeout=
().
The -110 came from phy_read_poll_timeout().

-Athari-

>=20
> Thanks
> 	Andrew
