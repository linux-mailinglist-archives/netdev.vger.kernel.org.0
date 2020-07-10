Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6EA21B3D6
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 13:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGJLPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 07:15:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:18870 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgGJLPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 07:15:05 -0400
IronPort-SDR: n1K3rXhD03g8VUYgGvbPR/tJcVGrDYOshZnPAIsj3TcSAMpW4WAvrlqBXAFwNx8UsMFHac/6vQ
 3TWE3h8bzFpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="166273494"
X-IronPort-AV: E=Sophos;i="5.75,335,1589266800"; 
   d="scan'208";a="166273494"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 04:15:04 -0700
IronPort-SDR: HNJhi6YVL5oBmbLHbmlgSpSynUluVTzhjfybjng2suFzsWdlqoI7m1Rq9Ej6sps67/rD9EQCV7
 uhnQG2W5PJ1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,335,1589266800"; 
   d="scan'208";a="280617519"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga003.jf.intel.com with ESMTP; 10 Jul 2020 04:15:03 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 10 Jul 2020 04:15:03 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 10 Jul 2020 04:15:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VkJcioQrcjahR9d1qyNYNp1zItZ87AjgarwwhkH8czz1CHvuY48MUMcOFqJgzPkFeSCA/BVasCWTUlo1MdsoO0mursglT3eCbbZElj8Xok18t8NtirXU4jEMSmwDhFrlSzPGDDYXY7Mbtm57yhXeEFCy9KyRULhiZPwkPb2LdTwCeAn2msgfcPZQz6We4q9ltDtw2A2DbG7Xb24vwTA9ddZhB9sdYDVoPIWaYhfu6TmtAz8X4rYVuUXp++fziKpvDrAaP4cp49rfmq63Jm3qLy4IhL6jkaEi5Uv/vX5A3QCPBS69ujGSmQIwv3P6pA4l04cK2riJqx/hDkcTYnMZjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7kivWx3E169TRA+ijenNtx71+Vhmo55dBvVvS6rxd4=;
 b=lgA3xySr5vgaFnzFeazDEvN7TjFCR4H5peq+TBpRtPN88rYZ8ZmZ7p6wumDsMv1os2OvgaDycEPHCaYEWsCgEQQKT7rF9mDM2iYSmttUU5IpxGT71XOBDOYHA1uz0wCzR4EeSm5q/U7vAplalth8JQCG6woimVuDv17BrZh7yEUC3vsr/BAcBQshcEPDaqXiSgVjE4K2qjh7WCzuB7g4/OTboto/jnH5gljkbpRlE7AysVdgbMY2B761fE+xaQ2Haf8j1c/J+5HW/1bVtlflg5M2aB65uHRJROKvcaxljRAgQiHP8DMQbf+S+gFhVAos8KOqNW8TjQvtkf1WlCu27Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7kivWx3E169TRA+ijenNtx71+Vhmo55dBvVvS6rxd4=;
 b=eUNqj3neYp8GH37cQTjTAXfC1+5gXWG1MI/8OUZXe2PHeVpbL9JBG7DlEVb3KdFJ59q684Q+4laSEevAqxyYNVCkLhUuRR8/CRa4vw1crlbk0qOdtqX+fBkAwXiQL2dY9a9sJo52cFsgD3TrxHN3sLNyoBok5eXISZD9uqQVSOw=
Received: from SN6PR11MB2575.namprd11.prod.outlook.com (2603:10b6:805:57::20)
 by SA0PR11MB4527.namprd11.prod.outlook.com (2603:10b6:806:72::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 10 Jul
 2020 11:15:01 +0000
Received: from SN6PR11MB2575.namprd11.prod.outlook.com
 ([fe80::cd49:6ea7:530c:95e0]) by SN6PR11MB2575.namprd11.prod.outlook.com
 ([fe80::cd49:6ea7:530c:95e0%4]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 11:15:01 +0000
From:   "G Jaya Kumaran, Vineetha" <vineetha.g.jaya.kumaran@intel.com>
To:     Rob Herring <robh@kernel.org>
CC:     "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: RE: [PATCH 1/2] dt-bindings: net: Add bindings for Intel Keem Bay
Thread-Topic: [PATCH 1/2] dt-bindings: net: Add bindings for Intel Keem Bay
Thread-Index: AQHWVBoHg2J3hFBg90GdtvIrstZWeKj/eGoAgAE0jPA=
Date:   Fri, 10 Jul 2020 11:15:01 +0000
Message-ID: <SN6PR11MB2575830AC1DAFDB8D9C00504F6650@SN6PR11MB2575.namprd11.prod.outlook.com>
References: <1594097238-8827-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
 <1594097238-8827-2-git-send-email-vineetha.g.jaya.kumaran@intel.com>
 <20200709164510.GA496369@bogus>
In-Reply-To: <20200709164510.GA496369@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6224986d-ada4-4c94-c328-08d824c27d5b
x-ms-traffictypediagnostic: SA0PR11MB4527:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB45274BC320540357F5C4C75EF6650@SA0PR11MB4527.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pQqkfJ6MpYwlU0dc+o+fVcQD2IgWkxp8WnDfmntBnQSlL6FsR+9eF8atrUtAC0Lxh0g/URmZA3h/WKnRoBIIxvev32UtftfDucLnJR/wQmfzcspZzjhmklD3EtKHSEHVmQk75IkJsv8DAPC+/Y0OB1MIcKP8QKjtWMCPw+5QKfKx22B/EAO202dp1ilFUIlkYaWJP66BqdL8qKOjBluqkt2f7KJm9Naq2gEnwM4GlsrfP8GXXQ/Id/WlJG2l5Q/WiJ378SonIwbx+Yxpb6vxnFu8aJcuRaKaimH0z+ZpaTZHkBFyl1fmdO+ZfmdozNtyOorZ52jfKRH6vt62hnoywbnOB6V6qSE50N7Binru8uaGs0xzPXAqwP0u5xMPhrmQ1+Q91CiLS4WWafe5iVi58g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2575.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(53546011)(6506007)(6916009)(86362001)(71200400001)(4326008)(55016002)(26005)(52536014)(66446008)(76116006)(64756008)(66476007)(66556008)(186003)(66946007)(2906002)(8676002)(5660300002)(7696005)(54906003)(316002)(83380400001)(478600001)(33656002)(8936002)(9686003)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zNpaSbONcPTZ9EobcMnbKJiwBViuCtSmwKNlu0U+oFkIxDu80rxtMcjs1+fY+9WBW48bqnKKyDrhzhLEcZXqOP4qS8kwRfN8jUX9oy4V+W6QTusqSIyew90yr4OYgKeLqxDaor/bj0dVZOWUDkJr3/5eXkjL52/Noz69xeEPkJEzcI151AAkz7Oa/Zr4UOPFUHxanF7+AXe6btkoeqH8RONQdsOrIJX4GZfQampKI0IfWO9t1w7HROn+dd9PWwMV6rdVUaIRx7Q6YkNxoprL0Bpqvsmzy4FdxmYglI1Pi5P5jIB9Bus9eQNDLzddItyY6oQ9J2WlJI8EMyweGgoS6cb27il963Hs3n9MulIJYSJQWOeYh2C+1mJhs4Q8babSJ2wsEHIE3kBsTGdKhLkLQ4S2Ws1Y6FMDC4varDlnK2w8F6TJNS52CfP7h4KYn67HqvKP33gNC+Is0IRiqAOraNOau6ne4G/TB3jV7ZYxduvT9ynaav6Q7a/6607BzZCK
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2575.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6224986d-ada4-4c94-c328-08d824c27d5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 11:15:01.6287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 42Qx0qM5N653objYVKytiKc6TO1vmFN83574max71WeLE8jRarZtcFFPhneL7os9VMydfG0z2r2yrEQ/h+zYS+yoRoemAx2PadGcAJaoScySLPRQA97pyfPop3Zan5f7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4527
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: Friday, July 10, 2020 12:45 AM
> To: G Jaya Kumaran, Vineetha <vineetha.g.jaya.kumaran@intel.com>
> Cc: Ong, Boon Leong <boon.leong.ong@intel.com>; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; mcoquelin.stm32@gmail.com;
> davem@davemloft.net; Voon, Weifeng <weifeng.voon@intel.com>; Kweh,
> Hock Leong <hock.leong.kweh@intel.com>; kuba@kernel.org;
> robh+dt@kernel.org
> Subject: Re: [PATCH 1/2] dt-bindings: net: Add bindings for Intel Keem Ba=
y
>=20
> On Tue, 07 Jul 2020 12:47:17 +0800, vineetha.g.jaya.kumaran@intel.com wro=
te:
> > From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
> >
> > Add Device Tree bindings documentation for the ethernet controller on
> > Intel Keem Bay.
> >
> > Signed-off-by: Vineetha G. Jaya Kumaran
> > <vineetha.g.jaya.kumaran@intel.com>
> > ---
> >  .../devicetree/bindings/net/intel,dwmac-plat.yaml  | 123
> > +++++++++++++++++++++
> >  1 file changed, 123 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
> >
>=20
>=20
> My bot found errors running 'make dt_binding_check' on your patch:
>=20
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml:
> properties:clocks:maxItems: False schema does not allow 3
> Documentation/devicetree/bindings/Makefile:20: recipe for target
> 'Documentation/devicetree/bindings/net/intel,dwmac-plat.example.dts' fail=
ed
> make[1]: *** [Documentation/devicetree/bindings/net/intel,dwmac-
> plat.example.dts] Error 1
> make[1]: *** Waiting for unfinished jobs....
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml:
> ignoring, error in schema: properties: clocks: maxItems
> warning: no schema found in file:
> ./Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
> /builds/robherring/linux-dt-
> review/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml:
> ignoring, error in schema: properties: clocks: maxItems
> warning: no schema found in file:
> ./Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
> Makefile:1347: recipe for target 'dt_binding_check' failed
> make: *** [dt_binding_check] Error 2
>=20
>=20
> See https://patchwork.ozlabs.org/patch/1324088
>=20
> If you already ran 'make dt_binding_check' and didn't see the above error=
(s),
> then make sure dt-schema is up to date:
>=20
> pip3 install git+https://github.com/devicetree-org/dt-schema.git@master -=
-
> upgrade
>=20
> Please check and re-submit.

Thanks Rob,  I did run make dt_binding_check on my side but did not encount=
er any errors.=20
Will update and check before resubmitting.
