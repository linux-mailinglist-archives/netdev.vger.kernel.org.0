Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F1046A4EB
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347542AbhLFSxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:53:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:9279 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhLFSxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 13:53:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="261438455"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="261438455"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 10:49:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="679095088"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 06 Dec 2021 10:49:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 10:49:42 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 6 Dec 2021 10:49:42 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 6 Dec 2021 10:49:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfPisXqYEKNGFnqKRGP17s/Jch7l5LIuYBW7Ec/qoVtqh3zd6iM8Lhsll1KIIwcYcfqOmibEaMYzpGTTuFbmC0c/QxDQ3TlSUx8FFOaZb7Bx7URpXpO1N9SW2ErT4/XsFyx56F7A2JGOJsbHSgfUydxiaSBNuLWzF3SP1JkHj5RHEwapvG1GVcrRY5QTG15Gyeb3H7QDwezSrK9lfez92GB/lhqxv+67czFp87GN2ddRjOquvgh/gs7okoVLEJDy2xZ2LLIgS9ImPZGSxrsbOjOj3/2BEpejfLxq7HFvhDGJM1Z+Ay4lzwQwWdep7HCUY6BW7pB1SSPuWeDDdd9byw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sol6QE8kHPyxXGK1ZLMbuowPpkDZVyNuHOhPmcdO3yA=;
 b=fw7Cp4By6s3ozgNxD+Z2d41W3z+R2TGPby3MltbSxYsyZiMn7Kd5STX7ofNz6VH4+JT9cOJcS4cKdx+7JD6VM+h13HQoEHkP6Oy65Qoy48Na7WO6bZp59uNQQKrJR5MoKbDGryuO90tSPoRfOUKhMnUKMlWL90vCoBNom0Hrf/VMOtJi2vPzn8Ot27FlNT4KXCcjaqcK8McmfJS+eflHcR4+bSJbwj+z4/WwI+Wb7zNKKrTyz8/TDvqY0pJYGR8QXWRBA2jjbqZCAo4T8TJsPGPI9BhfGrxLoBJAe0EY0kEPuddnhtCiZWDHDCQ/CzkZ5KMm/DAbdv/YXxXSCY0QAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sol6QE8kHPyxXGK1ZLMbuowPpkDZVyNuHOhPmcdO3yA=;
 b=XeVxnuVwHqKVo3o0m/aUjZq46h+6wTEwka9yOB0cAjZ1pL8UPrz/objhayWZpkcWlTVPlXY1qZMJeKf+5GmdBYt0+NUVNr0aTbGlz3QPS9dmtzpnN8mskiVPouH1EPFHRXDLfb/OAtqcSNgO5IdgpjEhzCgHWi5gKhiU0xT4waA=
Received: from SJ0PR11MB5816.namprd11.prod.outlook.com (2603:10b6:a03:427::18)
 by SJ0PR11MB4784.namprd11.prod.outlook.com (2603:10b6:a03:2da::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 18:49:40 +0000
Received: from SJ0PR11MB5816.namprd11.prod.outlook.com
 ([fe80::50af:ee0a:320c:a26f]) by SJ0PR11MB5816.namprd11.prod.outlook.com
 ([fe80::50af:ee0a:320c:a26f%7]) with mapi id 15.20.4649.019; Mon, 6 Dec 2021
 18:49:40 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Thread-Topic: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Thread-Index: AQHX5t+zHNhA4eAQzEyd+4hcIqumb6wfJraAgAAesICAACIlAIAACV/ggAFk6oCAAARAAIAAHSAAgAADU9CAACN2gIAAA8qwgARu94CAAAHcgIAAFGoAgAAX26A=
Date:   Mon, 6 Dec 2021 18:49:40 +0000
Message-ID: <SJ0PR11MB581605D60396476AC54BB6ECEA6D9@SJ0PR11MB5816.namprd11.prod.outlook.com>
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
 <20211201180208.640179-3-maciej.machnikowski@intel.com>
 <Yai/e5jz3NZAg0pm@shredder>
 <MW5PR11MB5812455176BC656BABCFF1B0EA699@MW5PR11MB5812.namprd11.prod.outlook.com>
 <Yaj13pwDKrG78W5Y@shredder>
 <PH0PR11MB583105F8678665253A362797EA699@PH0PR11MB5831.namprd11.prod.outlook.com>
 <87pmqdojby.fsf@nvidia.com>
 <MW5PR11MB581202E2A601D34E30F1E5AEEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87lf11odsv.fsf@nvidia.com>
 <MW5PR11MB5812A86416E3100444894879EA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87fsr9o7di.fsf@nvidia.com>
 <MW5PR11MB5812AA2C625AC00616F94A2AEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87czm9okyc.fsf@nvidia.com>
 <MW5PR11MB58121BF596AB9C501F900887EA6D9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <877dchoh9h.fsf@nvidia.com>
In-Reply-To: <877dchoh9h.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5069e69-38be-4f16-55e6-08d9b8e92938
x-ms-traffictypediagnostic: SJ0PR11MB4784:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB47843473084389E0F1301B8CEA6D9@SJ0PR11MB4784.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w7ypmYtjS/UPQvGjLEDPPhmqdTef/kEbL5HXNa/qY7y1D/UGgGChYMDO4SmmHwVKBchE11KZeCKiqDarGhD1G9fEMq2xU8TXTZ4pdkmNMaoaIuR4wYNguf+G1JDVqydIboU+iD/LACDeOTdt2+fjO/vOcwprXwqmL9iOjLQhtY4ITrNDBvO6Inp4/OWHclP4O1Fns8eVzFLSzPWLRB2URKTLSNaWu+PgU/8SzbYoaiadzsvju1+bOO+fvxB46gj/5n7lOtqJA7tR9XrLTmFsoM6Lb6q4VNksdTiT3kljFsMyOtcS0/tUuPeNmJGcn+VRCOqiISy4RamVcv83B0WJtGbdUl0Ocbbt04+ttIacEdtJOXIhlx0DONypSA9EdNJPaiDPvZeYIVGqp4vRsnvhDMMRbF0p3hcwN1DLkxcct7CWCaGikyfqVbYXMNSxFpe6ZuRuhvTSJfSH9M6egiXnoobZ90f7cJCG+64lhBh8IRQtKXrLSG2LJWZfh9Xhd/mM4cXGc69Pp6DWVmATeK8sY7tO5Vj9zNpIVVsYLF6cFO66OKLXPk9q6ud0WH2x3ckcM9yKUe8u87+IjC0EkS8OiocitKUyYLayGERhrSqF+j1KIbITGWXga1mGWfcfMkFWrbLk3Xuj6kZvYng/q7Nj660HlI63e2PU0by3UtZSvAFnXDqXcPINd3Tpi/WRLL8yLEgT/VumHlreFbkpE9OGbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5816.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(7696005)(52536014)(26005)(2906002)(316002)(8676002)(66946007)(66556008)(38100700002)(122000001)(66446008)(66476007)(4326008)(5660300002)(64756008)(71200400001)(76116006)(55016003)(86362001)(8936002)(6916009)(82960400001)(33656002)(186003)(38070700005)(83380400001)(7416002)(54906003)(53546011)(508600001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zVmAZmWu3/J4wlPpCmBnsaWWkASpd1uulm9AoKWuq7XJpXD/HcteLI82YyVg?=
 =?us-ascii?Q?jEE+YNZWCQgTADUS/shyPEAsItX3L7vyjtx7MYHTDxDuMlAMJ/zFPJatweUR?=
 =?us-ascii?Q?TSZNBhSOrrMOuLUwpCtRwAjw6yVCXzxJelyqh/veZCdszInopV1aJhIVShlB?=
 =?us-ascii?Q?RKJ0Tpsk0EuBaTLPdZZuozcSLymRSEnftQ3krBu6Qk5A6nAgbx63Om5/5PPT?=
 =?us-ascii?Q?sKfLZDiU0DBsEdbowsZi85MtCHYC+KRJnIoJQWIpKjUp14xwmTVywCvF8OUM?=
 =?us-ascii?Q?qQPca56q58aWoYk2utOyzoTLmymfnfbmDHmjWks+H9L7cbB+vzsMEfqchNXt?=
 =?us-ascii?Q?mhfKSAIjWUUCoQnT3ZdEtJ5jtLJYXdXqTGT0bY68IWsW7juRrB8euxfHf82I?=
 =?us-ascii?Q?fLVc+rwenE0YiDNuNJFq5YxI4hKXe9vufxfcz/WKUNoQFig1vLKPOfxInHZ0?=
 =?us-ascii?Q?+Fe4Fj8Ry6QWg8OmjppWBuH/bXzZSYZfE6oR3ZVm6HRwM8pOD1/7aVczI+kH?=
 =?us-ascii?Q?2JhZwpg0gDu2kINq1gMlCvCxNMlQ8EYLQPTdhIFH+DxIMm0eh25KVC6G959Q?=
 =?us-ascii?Q?XEyzXcSpMElH6Z1napL59b4KADyychPwosS4+zNCLT1ooQCjTWL2ii1JeQoD?=
 =?us-ascii?Q?ahUnjOz33rJ+QRwmkhWhyQT28gbecczX6I7W3X65DmUXWhB+YqPCuALUKWUr?=
 =?us-ascii?Q?WcKsMgaVpwFDHWsC5dRnHngYAjvbDtZQmXz7VTcp20419yDBGn7bIpMCV9Uo?=
 =?us-ascii?Q?QSDV0PfmYYWZpphaqCQw/3U2XOcaDiOFUWcJAeaMA12m+kp7F5MrNZAkfJPj?=
 =?us-ascii?Q?oLkvdXuYHtXE4PTYz4+BPmgKrNRxTQwCSEPPpfrAP9N1WytbZKepSkTKTi4r?=
 =?us-ascii?Q?26Z4mRPpRhh7nw1zGNn9hRosab1+oeokqf1lyVyJEJsMuhHDYIv/6KwpfaiB?=
 =?us-ascii?Q?ughCLfvzQzYpWudb+A3+QLJyMBktQZqu9SapH7Y/RXkhy2BzCDG99JtjXTm1?=
 =?us-ascii?Q?f61mFmliXfDSLM+LiKPaubdUgd+9sHX7l+oaQMxu6LWgggP7ssSakHuZbk7/?=
 =?us-ascii?Q?IIwnOH2B6P49QsieWnpMs9sdP5HzVOBthw7F3ufbxkCsnq1o8b17+8/9zhKg?=
 =?us-ascii?Q?iQpulOau/knFqAEIe3XPXysVYSjYOvv6ZUA5kokY+qv/yEpCfnLtxHzUuNvl?=
 =?us-ascii?Q?kJOUkAwf9Jq3NIW7jmvS+FuiqwHEHQISMMtH/RxVMk17cYRp/+HHDWnNWPjm?=
 =?us-ascii?Q?U/pL+XkGiVoqQ4wBwX+txxUSOWAaxJyIImQhJEnA9aDhXHMO27MDixZvtzjW?=
 =?us-ascii?Q?/ryhQ5+a9HHI6c+SN/mSZklzM/9hjwRSA+40mizn+dtpaN8Tj8gaamLAxYWK?=
 =?us-ascii?Q?scNF6RxBf81+hIkd4tuorVbES3xGcGVbcAYGypfoBdrUhhBwjwm9hP0niN+8?=
 =?us-ascii?Q?rF3JDu0y2UzsIKVcFMdA2HydhWy4rMd4bZIHz/1t6T8DyfhUNAzyAZrNbd5T?=
 =?us-ascii?Q?9+R/txq+d2IpORvKqvMuZxqgy4mSI1cevn2inPzNSA6gRmxjbCyJihkAxvwU?=
 =?us-ascii?Q?EdVMt8qeV7rNSHdVYC0hSMlHwBXpnTYLh/ydt2yK80diCj7FxeD0MTM/4ISl?=
 =?us-ascii?Q?cLYoPW1/SViPt9dx3mNgTM9E84nZ36zqa6Q1dtnTV57rU3BO0vzg0UJgn5a8?=
 =?us-ascii?Q?kcol6w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5816.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5069e69-38be-4f16-55e6-08d9b8e92938
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2021 18:49:40.6571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nGJ3vZVbp9yAePb3bb+ZsibDiELbsFtTgM01KkL4sfGRg4ccNNJMdPOs0qFdquHCWLsK0pe0d+z7aw7A0BU4wYOhbBvqZ0PnLYvc49TcosI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4784
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Petr Machata <petrm@nvidia.com>
> Sent: Monday, December 6, 2021 5:00 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
> recovered clock for SyncE feature
>=20
>=20
> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
>=20
> >> -----Original Message-----
> >> From: Petr Machata <petrm@nvidia.com>
> >> Sent: Monday, December 6, 2021 3:41 PM
> >> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> >> Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
> >> recovered clock for SyncE feature
> >>
> >>
> >> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
> >>
> >> >> -----Original Message-----
> >> >> From: Petr Machata <petrm@nvidia.com>
> >> >>
> >> >> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
> >> >>
> >> >> > Additionally, the EEC device may be instantiated by a totally
> >> >> > different driver, in which case the relation between its pins
> >> >> > and netdevs may not even be known.
> >> >>
> >> >> Like an EEC, some PHYs, but the MAC driver does not know about
> >> >> both pieces? Who sets up the connection between the two? The box
> >> >> admin through some cabling? SoC designer?
> >> >>
> >> >> Also, what does the external EEC actually do with the signal from
> >> >> the PHY? Tune to it and forward to the other PHYs in the complex?
> >> >
> >> > Yes - it can also apply HW filters to it.
> >>
> >> Sounds like this device should have an EEC instance of its own then.
> >>
> >> Maybe we need to call it something else than "EEC". PLL? Something
> >> that does not have the standardization connotations, because several
> >> instances would be present in a system with several NICs.
> >
> > There will be no EEC/EEC subsystem, but the DPLL. Every driver would
> > be able to create a DPLL object so that we can easily use it from
> > non-netdev devices as well. See the other mail for more details.
>=20
> Yes, this makes sense to me.
>=20
> >> > The EEC model will not work when you have the following system:
> >> > SoC with some ethernet ports with driver A
> >> > Switch chip with N ports with driver B
> >> > EEC/DPLL with driver C
> >> > Both SoC and Switch ASIC can recover clock and use the cleaned
> >> > clock from the DPLL.
> >> >
> >> > In that case you can't create any relation between EEC and recover
> >> > clock pins that would enable the EEC subsystem to control
> >> > recovered clocks, because you have 3 independent drivers.
> >>
> >> I think that in that case you have several EEC instances. Those are
> >> connected by some wiring that is external to the devices themselves. I
> >> am not sure who should be in charge of describing the wiring. Device
> >> tree? Config file?
> >
> > In some complex systems you'll need to create a relation between
> > netdevs and DPLLs in a config file, so it is the only way to describe
> > all possible scenarios. We can't assume any connections between them,
> > as that's design specific, just like PTP pins are. They have labels,
> > but it's up to the system integrator to define how they are used. We
> > can consider creating some of them if they are known to the driver and
> > belong to the same driver.
>=20
> Agreed.
>=20
> >> > The model you proposed assumes that the MAC/Switch is in
> >> > charge of the DPLL, but that's not always true.
> >>
> >> The EEC-centric model does not in fact assume that. It lets anyone to
> >> set up an EEC object.
> >>
> >> The netdev-centric UAPI assumes that the driver behind the netdev
> >> knows about how many RCLK out pins there are. So it can certainly
> >> instantiate a DPLL object instead, with those pins as external pins,
> >> and leave the connection of the external pins to the EEC proper
> >> implicit.
> >
> > Netdev will know how many RCLK outputs are there, as that's the
> > function of a given MAC/PHY/Retimer.
>=20
> So... spawn a DPLL with that number of virtual pins?

Recovered clock has different properties than a DPLL output.
Think of it as of a specific GPIO pin that sends the clock signal.


> >> That gives userspace exactly the same information as the
> >> netdev-centric UAPI, but now userspace doesn't need to know about
> >> netdevs, and synchronously-spinning drives, and GPS receivers, each
> >> of which is handled through a dedicated set of netlink messages /
> >> sysctls / what have you. The userspace needs to know about EEC
> >> subsystem, and that's it.
> >
> > I believe the direction is to make the connection between a netdev and
> > its related DPLL that's serving as EEC in a similar way the link to a
> > PTP device is created. Userspace app will need to go to DPLL subsystem
> > to understand what's the current frequency source for a given netdev.
>=20
> But the way PTP and netdevs are linked is that PTP clock is instantiated
> independently, and then this clock is referenced by the netdevice. I do
> not object to that at all, in fact I believe I mentioned this a couple
> times already.
>=20
> I'm objecting to accessing the PTP clock _through_ the netdev UAPI.
> Because, how will non-NIC-bound DPLLs be represented? Well, through
> some
> other UAPI, obviously. So userspace will need to know about all classes
> of devices that can carry frequency signal.

That's why we'll link to an instantiated DPLL like we do to PTP.
Those patches are only enabling recovered clock outputs - not DPLL.

> Alternatively, both NIC drivers and other drivers can instantiate some
> common type of DPLL-related object. Then any userspace tool that knows
> how to work with objects of that type automatically knows how to handle
> NICs, and GPSs, and whatever craziness someone dreams up.

I see no benefit in adding a new object like that - other subsystems
already have their own implementations of such GPIOs and they are
always implementation-specific.

> > That's still independent uAPI from the one defined by those patches.
> >
> >> > The model where recovered clock outputs are controlled independently
> >> > can support both models and is more flexible. It can also address th=
e
> >>
> >> - Anyone can instantiate EEC objects
> >> - Only things with ports instantiate netdevs
> >>
> >> How is the latter one more flexible?
> >
> > - Everything can instantiate DPLL object,
> > - Only a netdev can instantiate recovered clock outputs, which can be
> >   connected to any other part of the system - not only a DPLL.
>=20
> If the frequency source devices are truly so different from the general
> DPLL circuits that thay cannot possibly be expressed as the same type of
> object, then by all means, represent them as something else. DPLL
> frequency source, whatever.
>=20
> But don't hide the API behind netdevs just because some NICs carry
> DPLLs. Non-NIC frequency sources do exist, and the subsystem should
> support them _in the same way_ as the NIC ones.

That's not the goal. This API gives control over a simple logic that's insi=
de the
netdev that allows outputting the clock signal to a given physical output.
Internally it controls muxes and dividers.

NIC frequency source is actually different to other sources. It's tightly
coupled to a given netdev port, depends on link speed and the link itself.=
=20
That's why it needs a separate API coupled with the netdev subsystem.

Also other subsystems have similar controls embedded in them - like PTP
has its pins subsystem. I don't see a reason to make yet another subsystem,
as all of them are custom.
