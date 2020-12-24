Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9D32E2366
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 02:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgLXBYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 20:24:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:48587 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbgLXBYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 20:24:10 -0500
IronPort-SDR: lF7WGLv/vMEMCnV4Dz1EK4HGqzYfdzQJ08wSDZ2U1nKgZUatCQigXqIbQraww7/L3qC32HGIox
 Et3SsV9eaqxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9844"; a="163153870"
X-IronPort-AV: E=Sophos;i="5.78,443,1599548400"; 
   d="scan'208";a="163153870"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2020 17:23:27 -0800
IronPort-SDR: y2O0PuH/Oh0ISwmFECmcNyj7yAYvgCjpmiGCZs0EkHEPF6ttdhAdqhTpzbvOJ9FQckdmNu4u0r
 wbK8BvBGg+LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,443,1599548400"; 
   d="scan'208";a="383381630"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Dec 2020 17:23:27 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 23 Dec 2020 17:23:26 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 23 Dec 2020 17:23:26 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 23 Dec 2020 17:23:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=og/AeORXulp35dFy2XRXVGy6DNrowKzXLzEnLpZlULdYocXSH2ZhKzpouE8ISKZ3W66E6uDxu2PbMbVF85Hi0TXcPEekt5oOurtPxA6pUWq7X3W+7jqcU+LdkVsLQeJiWSLz4tzayLaNWyhjIuWsxuNAQ43DHp7ulqWXUxSPnu9e4m1F5/Vbop4Aa/QRXlw7+TtqJ6Z1YhvN+Z4oR9g7/Ea1mXSXllwT4SkZQXc+nuS4quc1ZEafbF9O1KbUKpNEbcOA+E6YV40bX8U8ppNtQp8KA7kkeYYevn+IMtNT/0WAkkony+kOgbCjhkUG66nnbnMLq3tuAK2UqlT+INjIww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSnuEAwsuS1UQO4jWxy9ud4I8r+v3njyN9XA0fjCvnw=;
 b=aRsnTcR0yp3rOKwvTP7YulKfQqLsxnbcPSnSqus2ubH7c0fM1YNkC+itnrRTVn8NHoytxkdE76fOQ5dtCzaBWMPiUexr4xZLE6xIwMJA4tDdDxDyk8KH8v7Mn0Ah02ZtCAzAgoaP6DVKnRD/KZ469PzSqAbLZL+t7ex4oL9OGF7mANVvcVbEGjFx1NjRnRSikOrK/hPd9N6SMdjl10yLjiZRuVgODwIJCH3J/L/YdDJs5WpdZ0mOOFRlGs+vSEX5puu59ZXS4mwUsCxvUJ6634s6VRF8Wh0fV8uAdBK4l+6N35//mCvg2nLMKwMeVN9/XhXfO8Cr2/X2NvmvGgUyfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSnuEAwsuS1UQO4jWxy9ud4I8r+v3njyN9XA0fjCvnw=;
 b=djbbLyFb7MDz9Yx/O3+7alpTceViol959redUHOuYmfFQM7EWgrkfcbl2Kffz2Iw00H/YKk55YqvnNzPAMndboUwmwBSkqMUdu0fVvWWOXWl5CCSjx1M+PEdf4lr0Ja4aWVTH2c5AJhPju20b8tsKJyW0+NaEK5V2/UvRR3KleM=
Received: from BYAPR11MB2870.namprd11.prod.outlook.com (2603:10b6:a02:cb::12)
 by BYAPR11MB2872.namprd11.prod.outlook.com (2603:10b6:a02:c9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Thu, 24 Dec
 2020 01:23:25 +0000
Received: from BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::c100:4aea:3b83:e662]) by BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::c100:4aea:3b83:e662%3]) with mapi id 15.20.3700.026; Thu, 24 Dec 2020
 01:23:25 +0000
From:   "Wong, Vee Khee" <vee.khee.wong@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ahmad Tarmizi, Noor Azura" <noor.azura.ahmad.tarmizi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>
Subject: RE: [PATCH net-next v1] stmmac: intel: Add PCI IDs for TGL-H platform
Thread-Topic: [PATCH net-next v1] stmmac: intel: Add PCI IDs for TGL-H
 platform
Thread-Index: AQHW2HwzpoyqRFU1H0CErNWCaDB2XKoFHzmAgABWT0A=
Date:   Thu, 24 Dec 2020 01:23:25 +0000
Message-ID: <BYAPR11MB28703D0C520657C8D3078DFAABDD0@BYAPR11MB2870.namprd11.prod.outlook.com>
References: <20201222160337.30870-1-muhammad.husaini.zulkifli@intel.com>
 <20201223121337.58b0c276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223121337.58b0c276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [210.195.26.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02b77c91-6031-4cbd-83d5-08d8a7aa82bc
x-ms-traffictypediagnostic: BYAPR11MB2872:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB287235945742C3F23C8F2CA5ABDD0@BYAPR11MB2872.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: opHskg3zlN596DNlX6Ix3LitibnLFjhTIMvHCNfCuhdS3f1pJRUFWvkEDvkEb7nbhRsGdBC1UDvdbkE14PwwKfoF1iOKUOH8HU1RJOvpfgvBriB+2gjLTezBZITdeSkbsnU1l1ilboV51PHZS6hfsWxU2zf0DK6cf9F5+fjbB2SK++AUiyRXHwT1qE71Mzov8e7+IFxfKUw3xWPkRsYzQ3c/1eJVLd6NngSR11sWAvNAhW/yvQbKgRxbSZwOMVgxeGUMmiDH5gQAESMNN5G8St04GouEWLZyfxkdIe1Ax514X9SCCa0X8WTYgrZ/i5/MUCz2B+pPbq16HnecRTYq7d0nQce985aX1GsyC1lV5QCQLD1+2k0EnINC3CHJCHp3bwmVrlBCFHyrwVB68/aX2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(66446008)(478600001)(52536014)(64756008)(33656002)(9686003)(76116006)(66556008)(110136005)(316002)(54906003)(71200400001)(4744005)(66476007)(66946007)(186003)(107886003)(7696005)(86362001)(55236004)(4326008)(83380400001)(6506007)(5660300002)(53546011)(26005)(6636002)(55016002)(2906002)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vyZr8sAjQ6ce68+by6fM4ralV1DhYxlADpVAcM26EECNGEc2tI+iKHOkZPN+qZIeqWAIB/cpVSYWe8Fzh5qhrpPNoYpNX2RxAPu7g+dpSOcLNQNVI6YP5oH4/1fBIM5A+g1V/SMaV19xdDyR8TruSL0ukalwto6OpbeCgpLNwOODnjxP65ShffmW+v0y3qmceBdIIw8RGzmOEAmmalNbqYdbgh5hPTKldtGDdhKvttSw2UTcnYWnrGEDQTb/ShAaSmJ0M7CJQdd5Ii47dBD92gnnSiCYGedUP2HuTbKMMlW1swouFaKdj3hCeLV4dyXrFzIwL0c3BODtqfHRS6ABFAy29kU4GJzCFByHVDSopRU0kY3Y5vU5XgpatRMxrfyJhqy3kLH2IEgLjZHqznJMdO7czpMtwUUqEnlq6jxQy3BjLwxj3bmYOKE4iWjHXLx76No1EzdCplPXENLKXuDlfD2zo+n/uCuTiOuOvCOhmH+iPLMkXbWph/d2LfD/Q2gcYSMS6j+Nomg8AXWh/88yoU+U+zTnVtByzF6mQwR5WP6+OfLiprEKnnhKFMk4KrAqxHNS2d3WhGaw+9aDaKa1EFWQ79msYIHrBDXUqiivo6RSAVNd6R79jAQX6I5CalJmfPIooMoGB5GHZ7Uc4vbPbNnj5M5KbfbSCz9zYqh88HRLhyy01dodbhSbXRaCgq6li2fJkSIsbnyxly4TCaTKNxJl8GVKS2ffTm6t53FPMsw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b77c91-6031-4cbd-83d5-08d8a7aa82bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2020 01:23:25.1247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pCpcpFh7nWMRfufhe009iEZzuPI0/CruXEulAF7ZYJezHFoBeXEiBUiMkp0aw3/8NenVIz6cj6XOzH1lTyLukA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2872
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, December 24, 2020 4:14 AM
> To: Zulkifli, Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>
> Cc: davem@davemloft.net; peppe.cavallaro@st.com;
> alexandre.torgue@st.com; joabreu@synopsys.com;
> netdev@vger.kernel.org; Ahmad Tarmizi, Noor Azura
> <noor.azura.ahmad.tarmizi@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>
> Subject: Re: [PATCH net-next v1] stmmac: intel: Add PCI IDs for TGL-H
> platform
>=20
> On Wed, 23 Dec 2020 00:03:37 +0800 Muhammad Husaini Zulkifli wrote:
> > From: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
> >
> > Add TGL-H PCI info and PCI IDs for the new TSN Controller to the list
> > of supported devices.
> >
> > Signed-off-by: Noor Azura Ahmad Tarmizi
> <noor.azura.ahmad.tarmizi@intel.com>
> > Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> > Signed-off-by: Muhammad Husaini Zulkifli
> <muhammad.husaini.zulkifli@intel.com>
>=20
> Applied, thanks. Are these needed in the 5.10 LTS branch?

Yes, these are needed in the 5.10 LTS branch.
