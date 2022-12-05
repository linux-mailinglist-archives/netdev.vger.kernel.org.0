Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86301643225
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 20:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbiLETYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 14:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiLETYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 14:24:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5FF26135
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 11:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670267978; x=1701803978;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JfeYVyi0J7kuld6IrzE7ctehTdtLIhB2gQK5GBpHbUY=;
  b=rb9jlOYreOLsOE7I6FkRey/YApR5rMhshSZU6k2g2CKWdFeYlxpzmeX9
   UEBYRs427gqT3UV4R+PnTCv1g8JgKhVVcPFmPDldEtFAmBRUb/Z6daqet
   Ax5wYTyQaPM9DJUWj8Ms7TqXNUvJB8rmQK3VC2zdlhZU2j0aJ4upzNLZd
   iehAZ22oQI+9dVFi/gyKBUOFMnAwFzA2bodWbur/4uWZOpiiQqlKk9mHu
   RfKEdUdwK+dsV8xWjJE+8Yh/UDsBvWonM3HjQa+jYw3jxbWXCUnJqxdu4
   vqiuoOTzn+c6Y1hXnhTA5K3ZBVHpI9GmLCoAQZYgA7SKrFuMM/4VdBizA
   g==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="191796788"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2022 12:19:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 5 Dec 2022 12:19:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 5 Dec 2022 12:19:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBrJNl83Pv44oiV980UtTDffd0ss9U17abVqUgrzih84QZhBkRaUFyY5mLwtcawW6f8U4Cac2mY2gGxOtjHq3GfeQc6bysmUrhpB8JVWRCthdK/2UmO69UrIFAwz2tlJxJHj1LCANd6o5sa06wndo6Ma8EtrSA4WvTlGXQgLOjf/9XwstfdAxD1GVGyeKDBQeu6qGAroISyV93HmqmOKMAJ4LCPjXqTimem9W1xdYSQVU1PQg1daVsmr+r7NvLP0ESmqpQxy3YPMuINII/F9VX9xPk3shrVPugpnHkuZ58oz/6qkHIgMOlwtUe2e9AlSs08pB/2pOiFTe/nWInVaJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RN11mdGS3M2Xcfy91ATnOQSSgRXYxdIzXyV+Z6NA0Fg=;
 b=gA1a7yup/gKoKvVbUczRGVXYQ67EOpfpwx8R4CXpHSvInv+EluCW6B9YCQ6ESu+zqwSQyk8ajLb86y031wQvX120fjEvyuGETypQT/5hyOu74XF3OvDSc/BYmrKWt1JZSeGm8R9rjIOOYZ8DZF7zPeTkvje+0jJS9IjizI4YPuN4OSxIYu3hXlaEsR1g742Sb1bJnGo391ILtZ2zr+2QYTArEvZM8k4K7ZB2v49M70eBzpqqXAoJc/xRM15jcNsCkFD0alvypAUZldtHtZbY6dUT120Zw5jbCc9eMoWAadGLE7UEu7IR3Nqyu2l3yv6J2Hn3bP61nekVOTaGX7yOHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RN11mdGS3M2Xcfy91ATnOQSSgRXYxdIzXyV+Z6NA0Fg=;
 b=LnhHw5tBFvvtdDmnDkclp/otkqXV1yTNkOeXabSL0fGnqVJH2qk6RHb1n4AGy+O+gTbrTyWJsC/GaDlIbvVizj870slsUK1UXc7VoE0ZUUFlN9anNfEC4SlSu4Ej5gXwo6GV5XU35a2xz3LRxHefxUTf6LCbYoGqWEFUq8GqTYM=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by CH0PR11MB5396.namprd11.prod.outlook.com (2603:10b6:610:bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 19:19:35 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 19:19:35 +0000
From:   <Daniel.Machon@microchip.com>
To:     <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, <dsahern@kernel.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v3 1/2] dcb: add new pcp-prio parameter to
 dcb app
Thread-Topic: [PATCH iproute2-next v3 1/2] dcb: add new pcp-prio parameter to
 dcb app
Thread-Index: AQHZBi4aQTbgRosZIUWfrfvxERABnq5cZT0AgAHw1wCAADYngIAAf+KAgABzO4CAADSNAA==
Date:   Mon, 5 Dec 2022 19:19:35 +0000
Message-ID: <Y45G/t9V3luxRDGF@DEN-LT-70577>
References: <20221202092235.224022-1-daniel.machon@microchip.com>
 <20221202092235.224022-2-daniel.machon@microchip.com>
 <20221203090052.65ff3bf1@hermes.local> <Y40hjAoN4VcUCatp@DEN-LT-70577>
 <20221204175257.75e09ff1@hermes.local> <Y426Pzdw5341RbCP@DEN-LT-70577>
 <20221205082305.51964674@hermes.local>
In-Reply-To: <20221205082305.51964674@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|CH0PR11MB5396:EE_
x-ms-office365-filtering-correlation-id: b5f559a0-5dd1-43d1-51f1-08dad6f5a513
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VHgVriuvImQevfyGO4HArSK9DmDUTaJ02qviwTiIBth3JZOA3dsVpRjdLrXuNK6YoHpx66FSND7+fG82y0939EpjupG5Y3hwnkJSoEF5nf3QCZfjGTPVsnAmXev+DvoLxZU5HggDnEo2EQtk+MzwgO8FH5grAcJej2wSblqMPF1ovXzitAWtsNhqEd8nBWVLwCbfp59k96BEGkwA95bbTiJIxl2gAlO8lBmvQFWUXuqUaqjGjZKTvA0o39V5w8Gb5ZHwF89T13nQHC6kQGqH51w3aAKp+o6hAWAbGV/6Hp5rvJ3PP323I4UDxuXW/ekK4V1oWG6NnQEE1rAX+Q/vca9sQZ7bIltM3tmbIGpFi/KZtVFIc88xmo72belnKs2fTOFDea+JRgQ9vGB34Xuwa5KW79EhTfKjBO+mkefRtNpnQWtx6BitWf4reFgAlOmBGSFGjPjgGkuWR8fsBmZA7dw7mB5RBBPCDll2v+UdClBoXzXVTd1QYF+3S21k+azAX+XyjmgSRjn5GFnKS3lcGMWCH/WDAkMpYpPPG2sNFFzjMTLiL+NDZrUOcwIZ3p9aefC51ZwtRndq4eYl760vBLedjJJDm8NwymeXWLTr/gEuO41lpUKSX2+1MhOQciZhfydR3uo20azfpIuicJw2JpPnvZPSGU7KI17zXOpWHs9IguuJ2BDicSObC7+F13nssIQeFRUDM2lbzrjH7blRPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(38100700002)(41300700001)(38070700005)(33716001)(186003)(2906002)(83380400001)(122000001)(5660300002)(8936002)(478600001)(6486002)(107886003)(71200400001)(76116006)(91956017)(86362001)(8676002)(66946007)(66476007)(66446008)(66556008)(64756008)(4326008)(6506007)(26005)(9686003)(6512007)(316002)(6916009)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3QZS5oAIBZPlH7483XmGNgGxPSAxEQTbou8DJSdsrChhoBchwjHUoLcIFD5J?=
 =?us-ascii?Q?pyGYNbUuzXgjDzg4h/MIsaCVc1tb3Um9HrFLfotSR2j0zNbFAWAPlqGjHKzt?=
 =?us-ascii?Q?K912aAspNpiGVQHdVlJzdDgIiYoVGAW066TEigo+X0bmtl/wWrdLRnXJ6Slc?=
 =?us-ascii?Q?RGk5Z4wxr4Poak62dJo2QsUoU2HwmfCLnFEAEGd+mVCX/GjJIOnja49zJYW3?=
 =?us-ascii?Q?nd9nidG+rn1YB8xfDB3Jt9bsTfsZ4Fb2B2LQYh/xaB3nNNvRjK6tbXWf9gAA?=
 =?us-ascii?Q?N04C1SAZyE69vPYeifY+YyO/nVEYR+RlIT9zUraPCmjBvLCoudN2JP6Yu5Qj?=
 =?us-ascii?Q?glE5Mxa24KlBcDBVt+eJW3BDVac06byHwgNeUsJNRSR0PEzFLWYeMSIAah0T?=
 =?us-ascii?Q?YDrtGoHb50F6AstnX8evZNOLF6oqV2fFPBy0ShDM4IqMMBWRKc5iLZOVmUOD?=
 =?us-ascii?Q?+IG7dVKfuTM9fAgvZojUpnxIans0SVhlAaeMrc0iWkKhNMZsJ2S9epli2VvD?=
 =?us-ascii?Q?1/P/MmIxHlmcY/yShnAQiX3ngqDngdBb5nzOs4+CefuWzvl/VaXP0Kqfg9bp?=
 =?us-ascii?Q?d9T2oLNzyuGoaXZpn3eFjQkFG2VRR5f5nmGc9mQ2jFzdGc9+ybryu5St1mv4?=
 =?us-ascii?Q?hHRJq0RD9bRj2mwhLSOsLZ6SHrIBlP7/svlNdZEKtH5Qlhm9LLOzMGEOTqd5?=
 =?us-ascii?Q?UYk05VANV5HCLTqH5TuENi9SBN7Nqd9nTCUtd0anv9e9M74Cm8+1TgHvBETp?=
 =?us-ascii?Q?ooCnME3W1j5HfdvAHW6BWYAnLxgrs7A4M7bsgsikUagZJnartjkxs6cXPpxy?=
 =?us-ascii?Q?umSUJ2kwzWzw2x3eFR4QxcBOnIkQjWoyB4P7mHpaNUjOpdCNCaN+3P4yN8th?=
 =?us-ascii?Q?cxXgAklrJVsqkHfCzJt9zhFy8WCuaxm/hFry4a7hqRCEZ2Bm0nRBRqQPgwBP?=
 =?us-ascii?Q?kW6x+4XGSXBx6xGf/gom/Aqn8RksIO3HXlD4kNMiUDg3gym32sMrnNCNEdOX?=
 =?us-ascii?Q?2pmzdZA9esZBCpddIFEf4Zd/KfBGq3PCZLS2zsxumUUnQ5ZckUiqALRRhFRV?=
 =?us-ascii?Q?UbewT5PGUmc2oL3rT56yLZwBCYxQGfZLAEwNIAWYIpeq2hF0JM+e1wBuKApm?=
 =?us-ascii?Q?sBEX41cUbcMjdfl9fZJ8+oapCfvl0/JQce/LqPqXv7eF8VIbomLZGsdk+uvW?=
 =?us-ascii?Q?8XxrQEoOzqEWur5KGr8+R4oy8CWhM+wnARXNLa1Jw9XEAu1+N6ZjwGKCkjx8?=
 =?us-ascii?Q?CJEIAeI8bFZynFKF7l5dNtUrvJTkl3lXHo9QjAR7uJkVNHpeJSdg7c3+viUY?=
 =?us-ascii?Q?O7pA9PyPwy7SkZlxCqyGNebW5wIagv15z9PnN50ydE6zmVw/bMmPYNPRTaeM?=
 =?us-ascii?Q?8IdbU80ppW+EalQOzgHiJ2/H/CPYX7A2IsNFqVnEwYw82Go09VUzUU/eE8VS?=
 =?us-ascii?Q?jYlMUgjMzjE7DtoImCtPSzr44z1CLNmXMvsc4df9AUsgVrOO9H0NbPKX5Qqq?=
 =?us-ascii?Q?gSAN+OhdU+qIubar3yf1VYchkZ8qCzZju0jEuOcYmX93dxWZxyTvfJ5rMk3Q?=
 =?us-ascii?Q?ayOsqf4dsa7rI0ivOuvpKp03lNIDO9Al5BN769SOnl77YZziFtziQCwQl4SJ?=
 =?us-ascii?Q?nlmy0pKn04Rf7iOEmVP20i4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E3CF807ADD45584A8C15B3E32F4C4ABE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f559a0-5dd1-43d1-51f1-08dad6f5a513
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 19:19:35.0403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m9/HbbzPj7Hv4vSScbVOM6/6jR3YShwTJ8ujUdV83hv6yu9CsB2foxzwgoigLCowNc19I3KidQxkAanSqh7GlytoYvFXcchDPw5BCJH45MI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5396
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, 5 Dec 2022 09:19:06 +0000
> <Daniel.Machon@microchip.com> wrote:
>=20
> > > > Trying to understand your comment.
> > > >
> > > > Are you talking about not producing any JSON output with the symbol=
ic
> > > > PCP values? eg. ["1de", 1] -> [8, 1]. So basically print with PRINT=
_FP
> > > > in case of printing in JSON context?
> > > >
> > > > /Daniel
> > >
> > > What does output look like in json and non-json versions?
> >
> > non-JSON: pcp-prio 1de:1
> > JSON    : {"pcp_prio":[["1de",1]]}
>=20
> Would the JSON be better as:
>         { "pcp_prio" :[ { "1de":1 } ] }
>=20
> It looks like the PCP values are both unique and used in a name/value man=
ner.

In this case I think it would be best to stay consistent with the rest
of the dcb app code. All priority mappings are printed using the
dcb_app_print_filtered() (now also the pcp-prio), which creates an
array, for whatever reason.=20

If you are OK with this, I will go ahead and create v4, with the print
warning removed.

/Daniel

>=20
> >
> > > My concern that the json version would be awkward and have colons in =
it, but looks
> > > like it won't.
> >
> > Yeah, the "%s:" format is only used in non-JSON context, so we are good
> > here.
> >
> > >
> > > For the unknown key type is printing error necessary? Maybe just show=
 it in numeric form.
> >
> > No not necessary, I'll get rid of it.
> =
