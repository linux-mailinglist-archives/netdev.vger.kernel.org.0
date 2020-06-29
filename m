Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5F320D748
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732719AbgF2T2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:28:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:4746 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732783AbgF2T22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:28:28 -0400
IronPort-SDR: 1l3JIOP3C0FY2SN87VfzhHQ4KHV7ySqSSPB5nKwymg9qPOGj+FgPuzMUw6JUKziHBHuZ5DFVPd
 lV3pAJjrSq2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="145094364"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="145094364"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 11:49:01 -0700
IronPort-SDR: 7xv4QkJymBbjbaVYbwrKrhlFH54+C+42UG0Pm5btdnw3KkOYwEy0i3CqFLfdpN9w0aDz+J6fWw
 D34y1s/ky98g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="355540004"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga001.jf.intel.com with ESMTP; 29 Jun 2020 11:49:00 -0700
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 11:49:00 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX155.amr.corp.intel.com (10.18.116.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 11:48:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 29 Jun 2020 11:49:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mnafi3v1wHq+ACxCDGcHV6XBz9D+7WEvZYO3zpMvbMCXpg/v5flqddKZ/NAQKg5uCCpfe9rOjVY4DgMD8AGaQ9Lv8LfKa0g+PndvBts0+632Jx3UaYWopPMwaPuk7zsG8WyYseJtA4rXbPB7U3G3ITeG/Tp5a6FyqBukLNJ7awdJqVAYXOzAUR2nkEU5s5uBxtH2lEu66h9BsPRa5VXZQhV/sxVJ3+KPcZMjZDi128tf/WrHe1DDMDd/TBletTJfvaH1P7xqzYfxkKrrxhYwsHe4srgdu85xV6CIjXNq0NmTMpkU4Edav901VhLhlkJzMHYflLWg5ScpHwHgVZpSUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/UBa+jpa4XGwNN2z6h6lw/I9rz5Ma7aN+G0UqSGYVI=;
 b=VmFJ0De3XZozHoH/DSpfrGwOFBEoALyXP7donzqJD2k29R3vkZtLp/+fw1zRUogfjWwrycEaRfCdSST35E6pj8enD52t85MedQZ4q/7z1jVOdipWb60Kc5YbQUlAZp/fGvTMiZSqkDPDVgQJQzKeRDdK4kc7h1P47aSe6eYPGai3SAF5wkxQh4ASFT89sR2zenb6VbsgcEJShhDSpr5bzgAbbM1gdlgul92rmNYA1iTaSgy9UrLmzLo+t+M6ddmEns06iun5dg+ThJBc4rX7s+v4m1QZt61KlPCyd39QBIMVY+56PBfDmcmPZhmp/asdHXuKV9cduUt0pFJ75+yZDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/UBa+jpa4XGwNN2z6h6lw/I9rz5Ma7aN+G0UqSGYVI=;
 b=rsKcp0NTaErkUCiuTKKVRB/+dfDZgvUxiQKDKD1qfgLa0bFj41+Q639XiSfkLHIethDOGlwkFJ1eixZSu0Ttt2heirJEsh6s/CfyryORemJvmE9CTggfAXKlnQBCv23pIlD/zh0H3QUjiUxE85U0pUr7ZStB04YRqBd7ckjCaxs=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1808.namprd11.prod.outlook.com (2603:10b6:300:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 18:48:58 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 18:48:58 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v3 09/15] iecm: Init and allocate vport
Thread-Topic: [net-next v3 09/15] iecm: Init and allocate vport
Thread-Index: AQHWS16b0xXV1+xqSEymkztmxwCf/ajrQUcAgASzyUA=
Date:   Mon, 29 Jun 2020 18:48:58 +0000
Message-ID: <MW3PR11MB452279359B118A9C2A48AABA8F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-10-jeffrey.t.kirsher@intel.com>
 <20200626120008.43fe087f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626120008.43fe087f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 796688c0-3568-4a85-529a-08d81c5d1516
x-ms-traffictypediagnostic: MWHPR11MB1808:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1808210C89ED2EE07C5C64CC8F6E0@MWHPR11MB1808.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:303;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QjPv94q0KRelfMPdtXsmzPV1TTZeGMGPJ5rlvLZXVRlmkechzB5ZkPO38OWuZ3In/N+B/i1he4bcrpJDhL15uSZ+Mg1KfjQuIWfZbVGNUCBKCMvriHB3FBeLRo7ykdgk1h994R7Aueqx+3jWqgcd5O+0UD01eGNnKhoisc4VLlALM+MdVSkO1g4BCYv6FrnWnH8aS4W4HEpSBLAhAbio4Im2k1I99629YMxWRdKtWKP56sOigSbwIOZi6vZiFQEnfFsAhP+RQ/4eC23u0nmtoglfsPOv+xoktdNfBM8WdOqZQ5lmR8vjKkrQcv6omm0a9AwgWahNZc4x9lQLBpr9Ng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(6506007)(53546011)(33656002)(186003)(26005)(7696005)(9686003)(52536014)(86362001)(66946007)(6636002)(66556008)(66476007)(66446008)(64756008)(76116006)(55016002)(71200400001)(110136005)(54906003)(2906002)(8676002)(4326008)(4744005)(83380400001)(107886003)(5660300002)(478600001)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zFIzxFSvfWlZ/361tpT5ZeF79I2hOb6LZyLu7yxhKizt/cL1W8+vC627bH1PJxjfX49CDNgjkQg0jfjnBZJLWCd6/cdt9eeb6tqkb0ksHyCKZ9tlW5SQZ2f8+it18J2Q4L8stpAhXhJBezWXJaE1mZkVQ+YwpuyrHBLWjFufMG4U9j2eYWzb5pBFCuD57cbPgKXa1cJr5O7q3AU2SUtLf4yfkwb9LennVfKxA57g6UtTQatm5He0fHLZ+K3+wnBi7SgznsvXimCXOylce20ChuXZihPIJl2z+uFAgTptInbROqHD/ZfblTRfAVWz+2YkLEPTMy6Dy5BomCrlV+UPwfFH7v/uZ0UuulwfuohbF2RtcxTUU56sz+kfZRahtCw8QPeS2G3JoXB9ufjFbMZUVigmWAHcoFbo/1ytCoOcffF8psc2EBy0CVt5up0Vkr83ShC0QeNMGTYYcetJ1ZuIKN54alISawR2dNTywFt5gftq67IE9s9urB9dVBVjXbzE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 796688c0-3568-4a85-529a-08d81c5d1516
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 18:48:58.2812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2TzmdLfYBr/t3Fvqc/ZZqHKiccXrZC08dk7kuCVrlkfbkQurZmXaM7Eqyb2ineHguN+Kx+r8UuUUoGSFUd93SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1808
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, June 26, 2020 12:00 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Michael, Alice <alice.michael@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Brady, Alan <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.c=
om>;
> Hay, Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v3 09/15] iecm: Init and allocate vport
>=20
> On Thu, 25 Jun 2020 19:07:31 -0700 Jeff Kirsher wrote:
> > @@ -532,7 +540,12 @@ static void iecm_service_task(struct work_struct
> *work)
> >   */
> >  static void iecm_up_complete(struct iecm_vport *vport)  {
> > -	/* stub */
> > +	netif_set_real_num_rx_queues(vport->netdev, vport->num_txq);
> > +	netif_set_real_num_tx_queues(vport->netdev, vport->num_rxq);
>=20
> These can fail.
>=20
> > +	netif_carrier_on(vport->netdev);
> > +	netif_tx_start_all_queues(vport->netdev);
> > +
> > +	vport->adapter->state =3D __IECM_UP;
> >  }

Will fix, thanks

-Alan
