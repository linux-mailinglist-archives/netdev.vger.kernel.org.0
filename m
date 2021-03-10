Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E67333333F
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 03:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhCJCpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 21:45:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:29618 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231235AbhCJCpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 21:45:15 -0500
IronPort-SDR: Z+OkqB917b3zdBZ72s1r+QeMysxrIeXWkaw02SArbJnNhaUJFRrpX7xBukzcim47BdfZdiDkKg
 E1dRlw1lMxPw==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="208166205"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="208166205"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 18:45:14 -0800
IronPort-SDR: RAcCMqglw0o6JVd0Zsa6UwUWeOBOOmbfpyxALeICn1Fqf53NPJ+DbnMTFM23MkoLGLrgCmSouc
 0DM23w0h5cEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="588661460"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga005.jf.intel.com with ESMTP; 09 Mar 2021 18:45:14 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 18:45:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 9 Mar 2021 18:45:13 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.56) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 9 Mar 2021 18:45:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEnnKg4ggZ5X/ZnRWV8TdtYaZ9r+963akFNpfQ6rIxEZwBdQeao4F903aMnmS4akCUJ/iWUuRqoaUmgYee86UYJBS2cvExy5iKn13wG27Q9ApXU7XsncZ1OnvEmY+pWs57O6b1GLH4C8N+zF1D6Uzx9I2P/C6oQ449u4DHGtdYdkgfcMNRltbUMz3OmHPWI5LPtQ2PepIFS6sZJeCl6G+Wd5N+cGF17pt/XPhcOqUtYuyRHTAOtESEE7ZzJkQbDTyQQK0qn2MKnFzCdsF7q2mLQgb3EKIkTKDh/V+Nz9rUsbIpsc6m8pcOemNjVCLLZ8eDQWOFnZsbJT91eT865orA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9DIWzwljm/jXGuHrRtGo4z3DtB8dfzuv2LzHm3WDAg=;
 b=dq1hW+XOOFFNhBPR+tLP7EXVBOW0uChA4CZ+8+RocVR9ZiJnF387PdUk2Gffw5SjlMfBjmk6A29gBkxTx6dMwVhthxZzGwHSNelsQ3lV3MmPgCUyg44+ahTtAIoxM4alQVqXMvg1zTZwqzG71M7yi17LJfh7hwEOpaYhYdRRXWInUHv16VO2pCYbePhf8ndVj83+83jotWyP4k0gmM/0XYYSXCFbuxP/OjsJY4a8PDU6z1vs/gSLVN9vK63J8np1e6zDdJ4pAZ7oM7XJBUpcKmqLxQ3fzP5ezK37Zt/M5t6fG2mDzP0Jy9MagJvZsgwp2Ojfg/dgFUYOXTRbCw+pVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9DIWzwljm/jXGuHrRtGo4z3DtB8dfzuv2LzHm3WDAg=;
 b=gYr6nPSDr4kN8fv37LVQ6lQEzJiN/vfr/MLCDBlOROPYAt3rS4LLIiIG+Eej6LsFT4Fg/2Z3FogJd/zmSuETyexFsUfI7w42/RsLCExMPmv37tl1ogdV2iJqf61XVqQ+Ecd6EH4VyIqx5kA0MF3i8EF5cIHHLnBzZBWmbyRlrNI=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by BYAPR11MB2773.namprd11.prod.outlook.com (2603:10b6:a02:c6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Wed, 10 Mar
 2021 02:45:10 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3890.035; Wed, 10 Mar 2021
 02:45:10 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: RE: [PATCH v10 14/20] dlb: add start domain ioctl
Thread-Topic: [PATCH v10 14/20] dlb: add start domain ioctl
Thread-Index: AQHW/9cf51qMHKbbbEiK3J9lquEWHqp7jbCAgAEXzwA=
Date:   Wed, 10 Mar 2021 02:45:10 +0000
Message-ID: <BYAPR11MB3095CCF0E4931A4DB75AB3F7D9919@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-15-mike.ximing.chen@intel.com>
 <YEc/8RxroJzrN3xm@kroah.com>
In-Reply-To: <YEc/8RxroJzrN3xm@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [69.141.163.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5ad3b8e-b7bc-4d87-d583-08d8e36e85be
x-ms-traffictypediagnostic: BYAPR11MB2773:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2773967C4299DCED2F61D8EAD9919@BYAPR11MB2773.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dw42CJamD4Cm3BxXgHPoEZPSPTLz4/eMWDrw/+/xrpThsVj3uXhaUzTMLJk+L8MpNUR4yW7tROOQtKtM4rQUP8Ga0I007aULwbpC6KO8nZZtLTuEufEiYcgwieEn+P+hWlEXzs2yrtgUN+IB5H9HwP1fxueCy7Brw5nrHFex9w2M04n8qtT8+0GoDPKxXCx+2MjsX5GyFEFXX8sxHkZDB+9qsuvYfDQ7aJD3TCXMUIjT+KWhA998fF84KsICkgrxw09G1yMQiudiLyeyai8Bu9X0yXRzpk+L40MwEdRdhugoZs//KwHuvaKKPruMzajrX6zn/2M1nCKVM4/CQTDxWl2LxRy1oORBy6zK1p5GDP10QzB1E4XWsKkVzewJPV347nhKwDcuQWUS47zWGb7rcX0kkf+oR+dnkG5HPTZggy0CG4U/5d+gOt9+hOoBxa7Rf8WhBpTLbwsjchjBxc+nqqbvCSNKNMYuPNyc0bqOpeJKldtPUgCdoKALxm4L+25IMPYSZiWeXIj+IbWhSimexg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(26005)(71200400001)(76116006)(54906003)(5660300002)(498600001)(6506007)(2906002)(64756008)(7696005)(9686003)(186003)(83380400001)(55016002)(6916009)(52536014)(86362001)(8676002)(4326008)(8936002)(66476007)(66446008)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pvfz6QxnkWDicIgVjSPeWLiFilw//w6gojqQjxliAPwdRRKJMwq9udg0uLcT?=
 =?us-ascii?Q?UoNAClCiYHSfY0tVJbAKEJCpcD80f0l0M+b6hWLaQikiiCX09d9ZIvKdq+4n?=
 =?us-ascii?Q?mglGXWfXbkISlqAQRjgPfDFX8FcBITXdKcXcISP+AV09z99AqQ9EXQAaQGWj?=
 =?us-ascii?Q?RENJ1P+61vO5RLucOiHeFZqYIoihF4qdyKNHjDfM5KJhCPpJv3nla2DjngiK?=
 =?us-ascii?Q?2BSNe/HjZYaBGvhcO+YKiomKvE7p35lqfH6fhLPrnjbxxmmwqrmVocx5GpQ+?=
 =?us-ascii?Q?luGBvN+8PATPqK3pNuU1vzZYQnAompE1o7QjNGLVVh8R3kK7HSYHjYlABUy+?=
 =?us-ascii?Q?MlYQCbePC5zdWhws9CJOemoLwKeL6nYMX+h0PFsoUb47d/wfs34nymxLnj6/?=
 =?us-ascii?Q?XGrFIEVO/BJA4v1pyZeBopxOqwM3ZHdCFQMNn+bfvLqgA1XoNpf5k9JoZSBR?=
 =?us-ascii?Q?XyeSlSrrH/woAGgnlGXyzzh7yBSVVIL+EkeTlHm2qR9xi1fAscb+hxQaD4JB?=
 =?us-ascii?Q?iYQ7ypkdwSTz2C2lY5BhHAXMqClyqslN/3aRJoWyHySCJRNoVkOYp35XXsuv?=
 =?us-ascii?Q?v1sUVravDls5HDT6arRGVYDv6ufqEcTEmXK9Di9Q4FRFf4uQDRYG7T6CJzDG?=
 =?us-ascii?Q?hBT0ObLjbkOY/ArmJZwUWcVw8jYSE1qUL6dKu4sMaMLP1votDpyCCoHCqHoG?=
 =?us-ascii?Q?V8ggIlilZNGFmnSYYjCDHQh7q1sLakb4g9WWRp5MVti1+i5YACcPyG5cOXse?=
 =?us-ascii?Q?SXPoRzEgqagfNJZMbCZDRInjvjI2HO3BosYs+ADqH7qIKWmFluIo59y5Yr7w?=
 =?us-ascii?Q?uhh8sEoq7HmkzKAe++0LeED1RnI8kQzjFqtReqAWubYTo9sUL0J5cN1XZxq7?=
 =?us-ascii?Q?Dg4Az70E61gnTGyTkMPvIAkgpIk2cner8/nGUJ6sx2wFxootNXXtmhsc8qxs?=
 =?us-ascii?Q?l1Pk6wx7EPIHaIriExkAM8oHXrtt7h1lWWKXkcTQ9wdFxvOI41a6uxilX5/n?=
 =?us-ascii?Q?7yBDgMRsa3EGtB1B4bCwrmI2bw1MgbVCM6wPnQBLjbzpchJxiU/AkU3GAYW1?=
 =?us-ascii?Q?bTAMVAWM055eqPvMoTnf4cCZsj4WWnswfyt8prPrY1bVspAZ6Xxke4qGW3eg?=
 =?us-ascii?Q?gBUpCAJrdKKZRmj2yXciEMXJbN6ah7M1V1Qd4jbPJaXVgWi93asw5ghY8qJR?=
 =?us-ascii?Q?jjVXky4P7khpbclweIy/gBmlkd1YUwYGVY3iTXUBQmEib8Dr3WuOr7lLVz5v?=
 =?us-ascii?Q?/XNu09yoMJYr9+pV00ShKxQ/BxBCi94Xz3TOkIdfPbsBXUvImwWYLcjWIotq?=
 =?us-ascii?Q?ARoWZtcPd1mRqfNJY9hqz3pf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ad3b8e-b7bc-4d87-d583-08d8e36e85be
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 02:45:10.1539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iR8jVJ5TNEx+byrXMu+aVywMzfVdKWDZU4FlW3Knn7sOOUMvvstGcHZEpVDqMIYN0dPD8pGlxRM9BcE+JmMVM0Me8v5jJiqKKuUiag4Tg+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2773
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> On Wed, Feb 10, 2021 at 11:54:17AM -0600, Mike Ximing Chen wrote:
> >
> > diff --git a/drivers/misc/dlb/dlb_ioctl.c b/drivers/misc/dlb/dlb_ioctl.=
c
> > index 6a311b969643..9b05344f03c8 100644
> > --- a/drivers/misc/dlb/dlb_ioctl.c
> > +++ b/drivers/misc/dlb/dlb_ioctl.c
> > @@ -51,6 +51,7 @@
> DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(create_ldb_queue)
> >  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(create_dir_queue)
> >  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_ldb_queue_depth)
> >  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_dir_queue_depth)
> > +DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(start_domain)
> >
> > --- a/drivers/misc/dlb/dlb_pf_ops.c
> > +++ b/drivers/misc/dlb/dlb_pf_ops.c
> > @@ -160,6 +160,14 @@ dlb_pf_create_dir_port(struct dlb_hw *hw, u32 id,
> >  				       resp, false, 0);
> >  }
> >
> > +static int
> > +dlb_pf_start_domain(struct dlb_hw *hw, u32 id,
> > +		    struct dlb_start_domain_args *args,
> > +		    struct dlb_cmd_response *resp)
> > +{
> > +	return dlb_hw_start_domain(hw, id, args, resp, false, 0);
> > +}
> > +
> >  static int dlb_pf_get_num_resources(struct dlb_hw *hw,
> >  				    struct dlb_get_num_resources_args *args)
> >  {
> > @@ -232,6 +240,7 @@ struct dlb_device_ops dlb_pf_ops =3D {
> >  	.create_dir_queue =3D dlb_pf_create_dir_queue,
> >  	.create_ldb_port =3D dlb_pf_create_ldb_port,
> >  	.create_dir_port =3D dlb_pf_create_dir_port,
> > +	.start_domain =3D dlb_pf_start_domain,
>=20
> Why do you have a "callback" when you only ever call one function?  Why
> is that needed at all?
>=20
In our next submission, we are going to add virtual function (VF) support. =
The
callbacks for VFs are different from those for PF which is what we support =
in this
submission. We can defer the introduction of  the callback structure to whe=
n we=20
add the VF support. But since we have many callback functions, that approac=
h
will generate many changes in then "existing" code. We thought that putting
the callback structure in place now would make the job of adding VF support=
 easier.
Is it OK?

Thanks
Mike
