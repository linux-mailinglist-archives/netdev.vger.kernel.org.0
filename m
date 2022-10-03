Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569405F387C
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 00:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiJCWAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 18:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiJCWAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 18:00:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B3D1057B;
        Mon,  3 Oct 2022 15:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664834405; x=1696370405;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qbhQcEJ1dyUvhZ7FwAv7CYdBzrIhUwfO/2+spCk4M5M=;
  b=FTAIi8msZJcBNTs2gfk+NNtHoPQx2L/73onvnvM35OE+Cw3df80BhYsC
   cMXq6bA7lczgNefXt9QEmCrTNOPz48Plq+xdXOVc5a5ypM5Vh/TkQFY0t
   oaY7qGSrYNa/3J5jN0oHPLG4WDBQJKAFuqkeeWYdTGjnWrp1TiZdDfPiM
   9qadyOCSqUm+hPNgyMcQKe64KcpKd3bqlF0iA9sxTuVS+QpX5950Ja4qu
   Ci3g9oKRO495eBDZqf4Gui+PH2JniXzhvKY0n01UwQo984adt358NfVUC
   6qRvrGngWcU8l/YY+vPKFZL1uJqqfdmwGsR7cFtxuVT/an9tq2xqyZWZb
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="176843652"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Oct 2022 15:00:00 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 3 Oct 2022 14:59:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 3 Oct 2022 14:59:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8OIhZvJIYCGqQiL/P1/9c5rAatMY8G0OADe1BHiOkJAPZifbRFaz2rrts7SPh/OgQRCgOpZREKUwCRUGOatciSCgAn5ydLv+PXclRK5NpSnCHf4U4x0/oYrqczE+detD4MPW6Lct4cs9/pt61J+cojQTdxDBPR0x55RW/194FKDylcvOSQVbWeWDvqu7ThdYcRFgrVEgE8EK7mxVRzTwkN1nWa7fbOtuxb5gqRtj/xRZoW1Aijejfe96BE0HRNPpUzBQHrgw/+JYAEA0lWoK9dnLJFsGbIGovKlQWx1mdKR+oHXyEeYmHG7T6TdtnySz1i4qhw23h8pHgKgNXxptA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbhQcEJ1dyUvhZ7FwAv7CYdBzrIhUwfO/2+spCk4M5M=;
 b=G1G7xIt1X02iZ7eEkvjOxD920lotgdM/S4ziNR3kW5fAHWgoA5W8oG5c4Rc65VoOBJUfJq840Y0WZohPAW4FtCXEUQRELz9Ov3OY14DHCDuLINSRhNiitkZ53OkkPDJxvGWSfvShc0sVDeSabKysbhdSwan5SJhS+ttu0C8dotqV35YaiagILOCHZRJRgIaD3HYOldbqtFlJOubu9HiN9OLu+xRJZLgme6t8bicakRipAliaGHRuGbvYK5wgbzvRS6DhePk7jwSEJPkZ6ZKmNuHLtzv5kjEiKKwNgJCNWKGHJlDu2Fh9Xs1OX7JURcALsKeMIO26Ro1lBuK26oRVew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbhQcEJ1dyUvhZ7FwAv7CYdBzrIhUwfO/2+spCk4M5M=;
 b=hfthcAuGucZZrdFuk5u14DW647XpxBxa4d6+eyNWMKLltgxl1Ju/aE6iCMzATHZGG8NXzCl6IvDg0LZsw0aTSdcWD62CgK8upCq6N0eJfUNN0oBTi96GoBlsYu+8moY8glEc2TfjsUIhwyfBy3gkA92rne02APPUIBWFv8g2a68=
Received: from PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10)
 by PH7PR11MB6356.namprd11.prod.outlook.com (2603:10b6:510:1fc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Mon, 3 Oct
 2022 21:59:49 +0000
Received: from PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::782e:76ed:b02d:c99a]) by PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::782e:76ed:b02d:c99a%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 21:59:49 +0000
From:   <Daniel.Machon@microchip.com>
To:     <kuba@kernel.org>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <Lars.Povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <joe@perches.com>, <linux@armlinux.org.uk>,
        <Horatiu.Vultur@microchip.com>, <Julia.Lawall@inria.fr>,
        <vladimir.oltean@nxp.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Thread-Topic: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Thread-Index: AQHY1DNRRCKA3W+lZk2MiTdViI2XRa335cAAgADSrQCAA5l7gIAAjykAgABgQQA=
Date:   Mon, 3 Oct 2022 21:59:49 +0000
Message-ID: <YztdsF6b6SM9E5rw@DEN-LT-70577>
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-2-daniel.machon@microchip.com>
 <87leq1uiyc.fsf@nvidia.com> <20220930175452.1937dadd@kernel.org>
 <87pmf9xrrd.fsf@nvidia.com> <20221003092522.6aaa6d55@kernel.org>
In-Reply-To: <20221003092522.6aaa6d55@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5580:EE_|PH7PR11MB6356:EE_
x-ms-office365-filtering-correlation-id: 6dd61d64-06d1-4cc9-248c-08daa58a97d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aROVIGHgopRH3RZ50T5EE2zzoMkWFmojj0cOtqaEF0IBssM2fiYHFVnXxTz9iJbbL6k3XWXKvTD0ob9W+YED/Wir1+klnosu2k/eNzjDXm62rdoATuX3LVdp0PkBnEgGfRfbc2ULFy8HjRFcZByxmawonJPW8GDH5HdH6n1rGkR8aSOh2PKsEGc7z1aMiA4dTKAj1Mbr/c6KpfaGJb+56M1FAeP51vOIqIUoNo5TUw2ahMKgvOaBpMYPFcYIz7iwGc//0RGW3VehuV0GjI5DKCAFGubfoe57hdiqS/2ukOC75h+8ojRdHuRMrsGn/YdHvWUaIXSjxtlmIRsy885H3DkbI6bP05YO0EIdSL8TkwvmwvBLb4zeDSoTLwmTLBxeoakAgZqgxwmJsIizBv0+hk8M1ZqHILsEIhETnbSqKSBZh7jSmtILtnxTPQ2dJZEwXLvlG4EjINHLt71k7ylIh14874T784SlXunA4AG41KJRbYQRKq5lptrN22TEFeMdpH0jnXLYVvWAeSBYN8/WhA94AxgcPA8+YZpJVNRSMwHkZjw2tAy9Nnrr3HTg0t1+Hd5A1UzIPw6wAi4dCZKgnR/1fWCXX43hJGViAtcZ9KDXjwrCiV4IBigelgVzlH75CBHIhvIF/orndQhfX+78xmJmEwlyqYLkgkOoVqYlMgGjp7rTpj34f7ODFHFhepgVeAf787fZoPaWp5BVqMOuKLp9PtEzCb3TFxUQEbvBvKn351mHA02i0lXz4ktHmqMBclD9lVzHfqsLKM13VwBVgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5580.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199015)(71200400001)(33716001)(478600001)(6486002)(316002)(54906003)(6916009)(76116006)(64756008)(66446008)(66476007)(91956017)(8676002)(122000001)(186003)(6512007)(41300700001)(66556008)(38100700002)(4326008)(5660300002)(38070700005)(7416002)(6506007)(86362001)(8936002)(9686003)(26005)(66946007)(2906002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vFwFvVK8ZbDZzqid5W9a1dc/4zGa3KBO904Oj2BmPmlSPvqoGbfcVHOUcPv4?=
 =?us-ascii?Q?WX2I8YirMfD7eELOQ5wT1b1zsXRXPkxktQzny0ocrQ+OuUF/GHDPjhX/XbvX?=
 =?us-ascii?Q?osvz7+fEO1Rsf/iV6L7dgW+pDVavSHzcu7oSSHe6vl49MOgaQvpOWjtAz3Ts?=
 =?us-ascii?Q?cF5cU1c+eqz8Hwe8SttMgKNOJ9w9ktHe/1Iz/O8B6PtDcqE1QxO74hLYo6Tv?=
 =?us-ascii?Q?p/Kik/zduGWiRHJfpWPtwgZpNQ3QDQJwUh4PrRxsXZDPRSrZimQ5lK2JYBy7?=
 =?us-ascii?Q?lxIR0z3z0MEnoQWShTkOtUICNpcO9KTJ120KOgt8MSaSI+I5V7YCSBU6uPSS?=
 =?us-ascii?Q?2yFdZiFCP/dsOPTI5hG0k+qBkrMaQwB75j3nf4cY4nRNMfFizvpZKSXInP+K?=
 =?us-ascii?Q?d2gHnyBtHceuHuW+xCt0+ARcEZBWAJp6gitM+dDoic5hGqnlyzaQr09yJdW7?=
 =?us-ascii?Q?ef07Mjk87apd2778OBoP7Z3xyRUVOIFLbQwUa2Ij6OqaTkIvSc8jdm+oz1VK?=
 =?us-ascii?Q?32hhOTEd5MvVxtNZOBPcLq6inkOFCFyMo97ekl5yX2wJNA630ME/0WJW5dTB?=
 =?us-ascii?Q?SODdHT3DIVhODnAoLBgoYBJhUFnNomLDESEu30HUX3FEkFDYdk54VCm9UJKZ?=
 =?us-ascii?Q?AYZJ/yeSMMezEH3FOFJ05sjAk+c8RJ9nPpvnNvlaXD10woKCk6VU3IIpKEow?=
 =?us-ascii?Q?gA1Ha3t0eFKSoWvolwVJQXplNN+FgLmX3Clag8orN8MRf0xqQ2vYNkFryFex?=
 =?us-ascii?Q?clpYxdTy6zQMVa+i3RgBqg+u00iTkKjPfmnnoCsCKvBoGnf5smom1MUorOya?=
 =?us-ascii?Q?8DGxYVFc/swVU0LFFOrZ2xbKBJjKzqdMaJFm5cQoR2cKym+dvbSTXJBtWlbN?=
 =?us-ascii?Q?kckgnZXOyQ6khjk5xgrfJrt3s5WZUAbFdt0kHd7rbNlUgO4dCkT72z43Hyd2?=
 =?us-ascii?Q?fBn+KcwKtN+hk2/cLqLgRmvgM8Zl3H/bfK04552I4YeWuZ+9F+6nBlJ6fZTl?=
 =?us-ascii?Q?nyu6TwRwneo9nbq5WDTD3ipUgtL6+iSg+8cBi0dvRjWwiwksgxeTnWFx4PLc?=
 =?us-ascii?Q?PjDZHNDxf7x7MDpP9TDMdjsQdjzun9DEcF1VtZ7ny1R93wTgYc8PgbCh3kyE?=
 =?us-ascii?Q?HK26dltm3K+DgILpIWyCLIvW52CUkbJCOyyvLWdKaHyt0HUF4RtKImG5MTfJ?=
 =?us-ascii?Q?AFr5Yo4BYHj9Wko9Wj0A1coo7eIqrJVpeeyLGRMLLjNjgKJorfIZl4BYBtE7?=
 =?us-ascii?Q?/cjSRH6mDI2KZF/X6yWqYczOwxxcUy4CGVHUQ1fD3CHj06tnV96ax4/38kqO?=
 =?us-ascii?Q?MQnU+6S+OxlOOkUrB8hHVVB83Z3oSwICOPaoksofgP3or4a86lVoZ24kQHY4?=
 =?us-ascii?Q?M8/RsaMSTy3xKgIh1ZL2/MfrcSXAaC6LtkFsLibqbGUQZcF1cHLCo/GZJI2s?=
 =?us-ascii?Q?Y0eKT+Y/brzf4/GCxSN51kfwwwlZQODXMJYgnEe723y17MoNzuLtpq320TbH?=
 =?us-ascii?Q?apgI2ADW+Zl7GO9HaYSOaoQkobpM7J8RpHaHYIpcnbn6LaCwVL4V+x+QzUzV?=
 =?us-ascii?Q?TcwgCGXgP56yP3li9MyahRV28jW8WLNyrvusHGjdRhSffIw41xFdXdaEaLaU?=
 =?us-ascii?Q?4DYiHUo9QefmcgaEUIh7xPE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B6EE76AFA541948AA9FFCBD6FF76C87@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5580.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd61d64-06d1-4cc9-248c-08daa58a97d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 21:59:49.6791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BWik15/aQiJb4IvAb1X0bQ5H1KdVkc5Ot64czVqYQ6o/aPE/rxTJNyZCN3vh+NjCe/NXOpqWdfJ3euMt7ZiPCAmIQ5Prm9mrm2iSgDN/Bwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6356
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, 3 Oct 2022 09:52:59 +0200 Petr Machata wrote:
> > I assumed the policy is much more strict with changes like this. If you
> > think it's OK, I'm fine with it as well.
> >
> > The userspace (lldpad in particular) is doing the opposite thing BTW:
> > assuming everything in the nest is a DCB_ATTR_IEEE_APP. When we start
> > emitting the new attribute, it will get confused.
>=20
> Can you add an attribute or a flag to the request which would turn
> emitting the new attrs on?

As for this sparx5 impl. the new attrs or any other app attr, will not be
emitted by lldpad, since APP tx cannot be enabled when set/get_dcbx is not=
=20
supported. IIUIC.

If lldpad was idd able to emit the new pcp app entries, they would be
emitted as invalid TLV's (assuming 255 or 24 selector value), because the
selector would be either zero or seven, which is currently not used for
any selector by the std. We then have time to patch lldpad to do whatever
with the new attr. Wouldn't this be acceptable?

As for iproute2/dcb, the new attr will just get ignored with a warning.

