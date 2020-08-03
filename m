Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2217723A2CD
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 12:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgHCKk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 06:40:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:8651 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgHCKk2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 06:40:28 -0400
IronPort-SDR: WxuIUvKrh0GTBnCCt7xTyHLszIxla5GfThClr/vWo4LuQh/Y68s7kJ96ZlluVYZdVHBYFbcE9p
 oSBXdjc8cI+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9701"; a="149874310"
X-IronPort-AV: E=Sophos;i="5.75,429,1589266800"; 
   d="scan'208";a="149874310"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 03:40:27 -0700
IronPort-SDR: 2w4K7eJLcR7AERDsHt2+qY9C2TRYiIv4ZQl4uV1UUMQ4dZKLPs/j3e3ftXK6H7haSTBl4l7Lv4
 PeiedDI8BUSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,429,1589266800"; 
   d="scan'208";a="329954854"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Aug 2020 03:40:27 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 3 Aug 2020 03:40:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 3 Aug 2020 03:40:04 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 3 Aug 2020 03:40:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 3 Aug 2020 03:39:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kguIU8jWN87aU4szmAtuC/jCAr1nSwEzKG1Ep1WHX+3C7EKrvPnbjiczi+vlTJHdoz2YFowkXxNA17zPfpcu/sUF0V3Kq0kaxks1evsl0OmsivpmNu6SQa0BEqsHgA9Ju0D2pJQ/+YmCfCn8pGENfGpT6lfgP9xeFqBuJuOpmHUphJJBlnpj+8kdu7eOl+pCy657ncFVPqLbkGp6ssUu94P53nrYS9zJPyZPdspDRvMEvwfYNahsAXtFT6rZdsPFfnSZhKIpjnyqmsY9CBmupmViIykYbmnH8vobvM00vVhZlWfb46r77jZGu3obv65AIAH+1hwvKVryunWldGCVFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKgCB/At/GRvVLwDOfcJuRgquc6nns6FJ69fS3tr9iw=;
 b=ERA/Elt0o6WuevcxV9FW5b495fgpVZN85qJ5geBYbGZ1cHFynFtCvUhERhm9jtFhbt+QiGBi3TTJKO4A/EeP/bEMA+bkl6AAFNZIrzAOBbg/T4TtxDEK5epI2fWUxL3FleYWLtztUj42bLSmrn2/Q6wxAcurKeuzXqcwjdcH46Eql6kqRT2kqLAyo2v1/nl7XJQJBCn3ahphaKs+iqiS/vhod/nVMEkJzDUKhKHUX3+Jvj3r4hXxOrH/zcpOs9YYSvuNxv7dEj7n1kWo+aQT/q4Jzn1h6H0vHM1lCh7zyXQxoAGsKQJAxIf1RIpEmU9aMSAoUsZcn21Fzl8JJwzzJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKgCB/At/GRvVLwDOfcJuRgquc6nns6FJ69fS3tr9iw=;
 b=sZY5OUCirTJQdLfRlK6glkzdrkoIbJC3kukfDM/hK1rQ3Nb2JUPT4+MaUib4/uhy2JluDQVoz+r5thCAVu4GHb7t9ntlsG93iycMTxa8FTZazIxi1b/l4FGBvSCMV11jdrzGrpSLxZlYKuJe79MPLDUHciEg5Oy2LI4keYhGuJ4=
Received: from BN8PR11MB3795.namprd11.prod.outlook.com (2603:10b6:408:82::31)
 by BN6PR11MB1441.namprd11.prod.outlook.com (2603:10b6:405:b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Mon, 3 Aug
 2020 10:39:53 +0000
Received: from BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::dd0f:7f49:bc5f:2fde]) by BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::dd0f:7f49:bc5f:2fde%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 10:39:53 +0000
From:   "Wang, Haiyue" <haiyue.wang@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Tom Herbert <tom@herbertland.com>
CC:     "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>,
        "Liang, Cunming" <cunming.liang@intel.com>
Subject: RE: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Topic: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Index: AQHWWT0ppkWffu3OB0+1aq0Sup42gakGHQqAgAAk/NCAASN8gIAAbxpwgAEdaICAC25lgIAACEWAgAQpEoCAA5A6AIAKLx7g
Date:   Mon, 3 Aug 2020 10:39:52 +0000
Message-ID: <BN8PR11MB3795FA12407090A2D95F97C6F74D0@BN8PR11MB3795.namprd11.prod.outlook.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
        <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8026dce002758d509b310afa330823be0c8191ec.camel@intel.com>
        <20200722180705.23196cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALx6S36K0kES3b7dWmyigpSLgBmU2jf7FfCSYXBFOeBJkbQ+rw@mail.gmail.com>
 <20200727160406.4d2bc1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200727160406.4d2bc1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca24f169-1871-4871-14fa-08d837998e74
x-ms-traffictypediagnostic: BN6PR11MB1441:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1441AF9ED0D7A9C8F192F7DEF74D0@BN6PR11MB1441.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g0qiv6x8xMpRDPTndEn9ywDSMGWODoznUVQAVCgcWaMABTjato+mB3WrKzLf63b987yFRu+vAf1Exxte0s9WzFlSHKDk2UQGOIIp2aMxoJLgFXJNEawvEZ4o+Or0I7GeQhptU6vKLv7L+2CyPsf0QlX/lT4X0BGW0qsKHw4o86acR0UPo6NTUWg2ZO/JSXVp6QAhz/I41nYDufXFYAYSaYxUZAYYx0UkbRInT6AR6Ro9ye68z9IiLkfO2asL0+tl4SJVPmwFuNVO+4BAVC6BBkyyjdJxHF2NwDcHEnKBPHgbCVdcwGeNQ/sRNh67W8d+JOFHFnPr+LL3zP7zeTdk+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR11MB3795.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(52536014)(9686003)(4744005)(66446008)(186003)(66946007)(26005)(76116006)(33656002)(54906003)(64756008)(5660300002)(7696005)(53546011)(66476007)(66556008)(6506007)(55016002)(316002)(83380400001)(71200400001)(8936002)(4326008)(110136005)(478600001)(8676002)(2906002)(86362001)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OvWIQGXBix5/0DwARrq85Z+/QGl7U5Wwkhi/XrupF8YBXbNLy6+TINps7GHWCORuaxoj6hwNQ0F+mdZtSWybziDnpRYghnd0EdVLG8k9DDWZAtsQsc0EGxMK18ch8aQNRBKEn8vPfSKU6mUWixa4QhQpKBA2dWsa2+py0/wByGsNHGHhJmONRPHZ9q8/zKmBDZKd2NzPGJP2B0sXql2uy3ytj+v1+3rfyWy+rumM/8l970eqF9VoMpS8Y2W5cGKXq80a/dCOuFRBOSlVcKM1Icds2+w497M4d6aB+MlN0O7S17B/mo26xFO0Nzmp0/kHLExYY7gPpDYAiU+8Im4HluAEk7XNWPHE4oE3Ur1KWlAg5vH28IPcCt+Zw4AkTd1C/PzfNolpmGVEz0JAAYv7HhB5WqyxO5QtH+hxE4TQHPcjx3leUHl/Na7kOZytcOxH2YM39hkXls64GcumGQjbMqofPak8x3/zEXfC5AtPpnhMWJTMNwleMsp9dc/tdaJSAlmHGRV4hg6XzJ0cuh6geTRH/xiu/41k0+BumJkOYkccfBQaj+Wv/mRQ4gpAk3Xf8EenAtVxb0ZW0851zd2dE2aW18W8daizvd+QE6yBVD8bMVFsr+Ju3Cp7VpTVMY0GMmhXqHk2LBomUHnVkoP+gQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR11MB3795.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca24f169-1871-4871-14fa-08d837998e74
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 10:39:52.5775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /WAQcQfw+dM+ERoeHhKuOzYf6Wk/4ZEvnQNZXlVbx8VxAHn0Hw9mIUVfl70vnuyTeX4XsUXmiYFonTdTvBHgYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1441
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, July 28, 2020 07:04
> To: Tom Herbert <tom@herbertland.com>
> Cc: Venkataramanan, Anirudh <anirudh.venkataramanan@intel.com>; Wang, Hai=
yue <haiyue.wang@intel.com>;
> davem@davemloft.net; nhorman@redhat.com; sassmann@redhat.com; Bowers, And=
rewX
> <andrewx.bowers@intel.com>; Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.c=
om>; netdev@vger.kernel.org;
> Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Lu, Nannan <nannan.lu@int=
el.com>
> Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ comm=
and
>=20


> In this case, I'm guessing, Intel can reuse RTE flow -> AQ code written
> to run on PFs on the special VF.
>=20
> This community has selected switchdev + flower for programming flows.
> I believe implementing flower offloads would solve your use case, and
> at the same time be most beneficial to the netdev community.

Jakub,

Thanks, I deep into the switchdev, it is kernel software bridge for hardwar=
e
offload, and each port is registered with register_netdev. So this solution
is not suitable for current case: VF can be assigned to VMs.

BR,
Haiyue
