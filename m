Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA985F2E44
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiJCJkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJCJjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:39:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7368E2F3AF;
        Mon,  3 Oct 2022 02:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664789692; x=1696325692;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PYeei6SZcVZxGnMlsYmYsEkttjI1rAXmMoWB8ROufiU=;
  b=Wh9JYLAIJj4i3YjeHbLn+xd6B6+H2dH9pe7f9tnyK/azEM8qbDAQ0Rlh
   M3pa4INakcS8HMoSLt3/nHc6jWF0YZbBF9uImSunAZeUAUjMsVd68DSOA
   x1XupJshea6TiFsJ2Ghs5T6/5bVfuWdo6RAw3CFj8xuL2gFWpTSnFFLRL
   NqC/qT0NTaJ+GbgTYpP/7pc9jNh4AjwwtzhWr48lgNI5+r+cpeyqJ89rZ
   w8OGhEKohqZ6n6oCdJSTWaD9C6TQ3f6R5nE8B+y65HCTzTj8OAvXfBEi/
   nnAZJCuFjDqXilko6wsrmCvPDLYJUzjCnrnxFL9FUz16fxQOZaC/gEQmb
   A==;
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="183070105"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Oct 2022 02:33:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 3 Oct 2022 02:33:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Mon, 3 Oct 2022 02:33:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJYI8ZeQgOkZ6SBbEuYlmmbI0sHUoXN/sX61L/ryUktJMh5uwRFxsLKKLOOdBb1Qs3cbR5WByLdXTU6WXxTUxWecTzK4jzV5TyDahFfGpoLmPlAXn2INHtePJaPGHBhQf84B+AuOMkjWbQjAoXa5rnZ/+4EchmzP2zAquVCkFh3/jp8hOopg7KrkI5uwAgRBfG67mA3ZH9D28j7X346AYNqVLhqQi5BgZdlCeG7kWmK7iNAZTn/QraxKHfqzdeEVTAWKSgxX2ixjBbBIrrd5WpzidaEJ6zrsnb9/urxzqT48ih0F+hCEA8cscDUrEJJESr62VFNtI70nEw2U5NjEGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYeei6SZcVZxGnMlsYmYsEkttjI1rAXmMoWB8ROufiU=;
 b=N9uGAIq4VfwWGgsLBT7473D7T+u4bRDI3600m5qwhrxm8qYZkBM1kVDcZbJWnn86AreD8QE1ixdOX5WPeQwZnTn4kmsoxMtEZ2GbAUdOHm19rJ0oScUTmqCRaDTRtts+WRqzi65nmHMV9KIeOSDnrv0W0+EeErT1I6ehaLFLO3Zyu5kSew+SdgtWrRPDpTBSx2i5t10seE9uDZMUILXazzODEGDEi0ECjp4WG9eWkw/4vqC4Q81fRRoRbzl8SZw6dB48lof7Fu8XoHQUmeczC7F29Qqu0UnwcowqU+UdfL5q6fPVd5vgJv5/OzlCoONnhheRYtAcmlZee0MKDcn/3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYeei6SZcVZxGnMlsYmYsEkttjI1rAXmMoWB8ROufiU=;
 b=KmA+mNN6BGrx8c/5459c/mfn/2wt1UmOLJ5scbHQ3HxA18dauc2HRvPrJkDXQrW71xKE3Bc5alP9tmLbTMCBUyWw9q07er8Tl83VGrE0Vc8zfM/iRfl2zuA8we1N9uwJpNXD/57V7YFq3a5HXFjQHBCaiIpwPxfnjoPqyYQjjow=
Received: from PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10)
 by CY8PR11MB6889.namprd11.prod.outlook.com (2603:10b6:930:5e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Mon, 3 Oct
 2022 09:33:41 +0000
Received: from PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::782e:76ed:b02d:c99a]) by PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::782e:76ed:b02d:c99a%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 09:33:41 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Thread-Topic: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Thread-Index: AQHY1DNRRCKA3W+lZk2MiTdViI2XRa335cAAgARc1ICAABepAIAAFpsA
Date:   Mon, 3 Oct 2022 09:33:41 +0000
Message-ID: <YzquziZD+T145jo0@DEN-LT-70577>
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-2-daniel.machon@microchip.com>
 <87leq1uiyc.fsf@nvidia.com> <YzqH/zuzvh35PVvF@DEN-LT-70577>
 <87czb9xpsi.fsf@nvidia.com>
In-Reply-To: <87czb9xpsi.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5580:EE_|CY8PR11MB6889:EE_
x-ms-office365-filtering-correlation-id: 929a3a86-d031-4ec2-7521-08daa5225bc0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8JYAXBcsc9pVeC9KMPnilru7CGj7CRn2bDO5nw1RrSYIP9cOpZHGrBJU5Mljwlg7CC2v8Ic2h7zUdsNU8KKDndxagbuH9I9DI+Dk4NZiBXsiplZD+2TmyA7yskX/0TuBTqS4avcNU1z7lNqwE+X7RxvwxZEGY++0NSb6Gx/2qfRPEavEUxUJrqRkh6T2UxlSIIiaJw8UoO6XhcSftSgKJvlZDrE1G6SeFo0SyFYCGxQ9KUpQA0keTs46fL6Ey+MQqxRgV63DCcjkdeo38yZ7URZUdII8VYiFObocbP0jb/FbTUEn/nqXBp1o3oInVNpIiNW8rGmrKQbsyhO5VqBtTfpDCOc/WMXiYWCJFzabTBOetEvNk6PgejYh6QjUvgVUyuNp4TTOTFQRCPLCJiUGlwG4i612nO+Km7VETdZBNe+a1fzRur3PaPDeKywWLraIbC1aZ149kwA9L0kVwrcuZP2O1jadqxWVe93CwlXEuiO8jPc9jul31y7EyEOfb8OfSflAStxeDwhjnU5Kdazj9Ich3i8VEr7Z4DJWroIMUPV9/bkuvVBeQFL35QNSo2r4HU3xdDLm3yWJqH580tdM5jilcuXvz93a4PzPHnJ8yVn3s7BXMPSD2nlIIKGc3dnlgOYFiR0ZjHWt4BJPLTQ1X2YxF1behROB8kX78tmxedCKq+0TBhUfOqSabe+BTLW7Y2RCFZ5Qhz0PU2lKrG4M5u64mYzGcdMK6CtBeJTAsh4FfNNqi/pmaU3Wd+eW5vS9mP60B3SJFdiM++DYoPDavE8u0kC07vsdpuJSAaNEG14=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5580.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199015)(316002)(54906003)(6916009)(6506007)(6512007)(9686003)(86362001)(38100700002)(66946007)(76116006)(66476007)(33716001)(6486002)(8676002)(71200400001)(4326008)(26005)(66556008)(478600001)(91956017)(7416002)(186003)(5660300002)(64756008)(66446008)(41300700001)(8936002)(122000001)(2906002)(38070700005)(67856001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ht9j2MPYFBWcIMBtm3mwsF7zs4RnyWF07D9DxwT/fufjjk+RxS1is8+n0KTa?=
 =?us-ascii?Q?L59mxvSfDtri0tCgh5LvA9HDIvsKA7tic6mU+zsCN6c1WMc6EWujMrY1eSKN?=
 =?us-ascii?Q?E/OJN4yTbqeTAsAvV9kIGel2XwEXGIVBVfeNfgVal29GmFUbPSGy3LBLs3e8?=
 =?us-ascii?Q?4V2c9pbjJ6hYnA44Dv1f4NvxkjcroVZXFqQPbHrj/8n/Df0ZKxKEPXIX6s63?=
 =?us-ascii?Q?8Chzu23akCqlu3M5/D0fpgT8HbI6DfwN6UUG/P29mQ5Dse4RLWsL50eZi06L?=
 =?us-ascii?Q?p1EzYie15EeXGgoQsrOY34GHV75zYT960Imqd5SbDaOGGZtblXqJZ1/7c6Pw?=
 =?us-ascii?Q?M4fjyQn0USlw7GUeEqKsI/K1WNpbUm2F1a1FAPSWpgcJme16260fTkKoAj6P?=
 =?us-ascii?Q?7K8W9Q6wEkREkkS5XF0Q/ig2xftD9L6k3iHnklsu/ucb56DIDjYJ0S+jw+zs?=
 =?us-ascii?Q?t28TdLCaacaIiAcrJIK1fbSsjKzUQh8+MRhDp1CaTX4RBieYR6+l3zVS7HVs?=
 =?us-ascii?Q?nnq7bNMvRDTj7AwgGIG9NzdFAPVWsI3KugubJqTPpoFszZiXALovDj6tVgf2?=
 =?us-ascii?Q?vNx4MpCKbydAm/IwFwzQx6H9Tve3e6Fd73Zh4L6DtapiRVppCrKoRvdyXNo+?=
 =?us-ascii?Q?HFfO/wtJp7vlxfzso987f4OdraQvgmJjmlVXRxsGHdC+fuoz4DB/hF1KFKn6?=
 =?us-ascii?Q?WJ0CV8UHzHOqw/t+LHpd9+xeci1iP7AiU0LnpSSAPTr0qlt1azQnpvCv165+?=
 =?us-ascii?Q?nNdEm/bhi7xcbr8lmOasqjPn9gWDW6wYpM7CC8IBL+Fer0SDu4c2eCqny1zs?=
 =?us-ascii?Q?RezBZEkQDU177ZEtMolAT4kkJ0COLhsKTKMqvujDOQsNFX1FJDSzJLXY2c+f?=
 =?us-ascii?Q?e0z1UUkX5UtwqzePHqkInC3H7uHIzB7CRt6QdFXPpveTd2jZHscP8WQ7Iz2k?=
 =?us-ascii?Q?e6d6m6AtX8epKhNQtoiwo7JBHsRGdG6NnRnjC7fI0cJ0xSUy4BAzSP29ou5b?=
 =?us-ascii?Q?SBUmWEsGajIawyI9t98tME6AumKsduRe92KGLLSqyaNYtPmG3plUfZXdCC14?=
 =?us-ascii?Q?DA2Mqag0xAZLe+vvu2IlgJ0+y6Txt6m/0R6zBixDChF62k7JxS8V4FVuB8EK?=
 =?us-ascii?Q?zwKMR/FQynZ01SB+PBgBqHkNyamhgl9wWvu7m9noxLJTczJjHlGIKppaVZ5s?=
 =?us-ascii?Q?xllKwkbpaL3TEQliPbGGXAwNBbmmPZwfTC7n0SO7IHnDOYt/0h8mWTjuhZoB?=
 =?us-ascii?Q?jNCiDOKm3yYnw9duU/o9mV9nVITt5wxkOihWy0aAIt2398/Vnqg81wv633/3?=
 =?us-ascii?Q?9tUDl2GeeUI5dcLQ55SvpCYn4kJGUY+IVb7lPSSHoErRineu6RfIwJJ2RcqZ?=
 =?us-ascii?Q?bfP3IzwTdzbHnenFHYi2/DCWUR2YB4mocfqICyvZmNMgW+CAuI8/oQiVNg/+?=
 =?us-ascii?Q?dsUpwU3srM4DPCYHmGMvpqmGXHuEgg+2ExZF4RakbyCkLHiu1k7h2O5S3s+d?=
 =?us-ascii?Q?jXa5B+T9SQPUzO3iqVgGJHZ5mc67LqIfuU6naLonwl55IAZ4TZx6WG3e32ou?=
 =?us-ascii?Q?ctR9bmLHd3BvHzvgxJz5N2Q+W/QyagxIXGpmkSb5DFnndvqGySXcFSR0W8rJ?=
 =?us-ascii?Q?u+O+wfaDSl7hwAMHXv7PaLc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FBA6F8A70B557043B45BD38B9C893BF5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5580.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929a3a86-d031-4ec2-7521-08daa5225bc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 09:33:41.3000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LSArfjyfkncSFNAZMMsB0XTTDEPOzM1remYOGq/tCw4gR2mPAUbTy4UYI9PQp0OcK+/qv5qBJgnpqZQmtbh3cehpHVm8IRKr7wJweHVAiOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6889
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den Mon, Oct 03, 2022 at 10:22:48AM +0200 skrev Petr Machata:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> <Daniel.Machon@microchip.com> writes:
>=20
> > Right, I see your point. But. First thought; this starts to look a litt=
le
> > hackish.
>=20
> So it is. That's what poking backward compatible holes in an existing
> API gets you. Look at modern C++ syntax for an extreme example :)
>=20
> But read Jakub's email. It looks like we don't actually need to worry
> about this.
>=20
> > Looking through the 802.1Q-2018 std again, sel bits 0, 6 and 7 are
> > reserved (implicit for future standard implementation?). Do we know of
> > any cases, where a new standard version would introduce new values beyo=
nd
> > what was reserved in the first place for future use? I dont know myself=
.
> >
> > I am just trying to raise a question of whether using the std APP attr
> > with a new high (255) selector, really could be preferred over this new
> > non-std APP attr with new packed payload.
>=20
> Yeah. We'll need to patch lldpad anyway. We can basically choose which
> way we patch it. And BTW, using the too-short attribute payload of
> course breaks it _as well_, because they don't do any payload size
> validation.

Right, unless we reconstruct std app entry payload from the "too-short"
attribute payload, before adding it the the app list or passing it to the=20
driver.

Anyway. Considering Jakub's mail. I think this patch version with a non-std
attribute to do non-std app table contributions separates non-std from std
stuff nicely and is preffered over just adding the new selector. So if we c=
an=20
agree on this, I will prepare a new v. with the other changes suggested.

Wrt. lldpad we can then patch it to react on attrs or selectors > 7.=
