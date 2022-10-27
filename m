Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A18160EF14
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 06:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiJ0EgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 00:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiJ0EgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 00:36:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F360BE500;
        Wed, 26 Oct 2022 21:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666845362; x=1698381362;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QejvPV1refVH7tIzMoYJyzQqXM9dvY0i7WvXLdv7hTo=;
  b=XpKqywVEYqrW/L5hd4Eq5EwMdq18dLuFqZwqfgJ0pNfC20p/vFYS1j4t
   otpCZ/syL2EqtOs29gyDEfs9wU5LPuLMgJHno8hPJjsI8b6/mYANBJ5Cs
   yI7mODA8G7naatxke4zW19/6Vj50ub9YNXWU6pliSkaGy+ZmlagFNLRxO
   98waHB3Z9z++zBPlZQ/Ep85w5FEe405uA9LVv0MVAv8r1XmdaPsokgrU3
   lZNXoPezdF2gWmchhJm8vxpe07u4tVMutk8wariHN3rTLAcFqFMxWgOwQ
   QkJMLWpSE/2XKpZdRo7r20vt1CtFG07wBobaKpQpHcJHCqh2bRfco4FPR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="306856992"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="306856992"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 21:35:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="663474457"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="663474457"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 26 Oct 2022 21:35:57 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 21:35:57 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 21:35:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 26 Oct 2022 21:35:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 26 Oct 2022 21:35:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKSIRFMtHDyvRDCJio6oH7h1bJ4MDdrYYORPq/zSRLFHcoatLtACEoo2IXb0M7B8vR7dZAyM5THwN8RBvw8rXM3+xa8tI8oQfUvOvuH9rgZPIg2KmUHEJlcczKl3q/NaM68ljmmuV5oKzUeUlzYyZEgTBNFLf+bwDzRtJRObatizRUOw8XwVCsYn4QKPDK8I1/JwGyke1WLnLINR4PcOmXl7d/yGVEBeQjRacwH8JDZF8A38f5ObKnEWU07b17exUmKjntb4mjW3pnFlY3DXRH1453PSgXdOw2YVbEde2a/pCbZejHFENw0m8xj+Us6yeYiWWiMJm/TTtUUBuu02Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QejvPV1refVH7tIzMoYJyzQqXM9dvY0i7WvXLdv7hTo=;
 b=VWIJWHWzU6KLbC4pFm4t6pRubSRzoVBJt97ZdsIAKPs8NnZ5L5w4V76NRAYMIswaRXfff6YUr9S2SQt8P/dIv0b8LPuWFmQ8rrOOnnptQIZHCvY7RhQroVdUrzIrCOQ/DgDgaToXZPpkX8ugIsxL0ef8MhHndhQAFq/jzkXFU7bpDAPB4bQxCWPfolvKE0Sh4qr1MLTSGarCbLlgSipi3o198A8Do+8jBEj3cjbgk8LFue91+ipxT24ZtNRdSUY0YWXMIG3VUomQHZT09Zv4sK6E095xHpiwOEgCQ5br+LmOFoT6t7ghSz1lyYRDH/vScdL4BgdnDpi6ALWsZpKXyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY5PR11MB4337.namprd11.prod.outlook.com (2603:10b6:a03:1c1::14)
 by SN7PR11MB6898.namprd11.prod.outlook.com (2603:10b6:806:2a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Thu, 27 Oct
 2022 04:35:49 +0000
Received: from BY5PR11MB4337.namprd11.prod.outlook.com
 ([fe80::4720:666c:6710:e87b]) by BY5PR11MB4337.namprd11.prod.outlook.com
 ([fe80::4720:666c:6710:e87b%4]) with mapi id 15.20.5746.023; Thu, 27 Oct 2022
 04:35:49 +0000
From:   "Jamaluddin, Aminuddin" <aminuddin.jamaluddin@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Subject: RE: [PATCH net 1/1] net: phy: marvell: add link status check before
 enabling phy loopback
Thread-Topic: [PATCH net 1/1] net: phy: marvell: add link status check before
 enabling phy loopback
Thread-Index: AQHYuFxMKg+SoAedC0ayqAwz26yoSq2/m/mAgAd8s1CAAEtqAIAYyijggAdk9QCAORJv4A==
Date:   Thu, 27 Oct 2022 04:35:49 +0000
Message-ID: <BY5PR11MB4337F996C04AFCDC219EF9C181339@BY5PR11MB4337.namprd11.prod.outlook.com>
References: <20220825082238.11056-1-aminuddin.jamaluddin@intel.com>
 <Ywd4oUPEssQ+/OBE@lunn.ch>
 <DM6PR11MB43480C1D3526031F79592A7F81799@DM6PR11MB4348.namprd11.prod.outlook.com>
 <Yw3/vIDAr9W7zZwv@lunn.ch>
 <DM6PR11MB43489B7C27B0A3F3EA18909B81499@DM6PR11MB4348.namprd11.prod.outlook.com>
 <Yyj/NORWrGglz/HJ@lunn.ch>
In-Reply-To: <Yyj/NORWrGglz/HJ@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR11MB4337:EE_|SN7PR11MB6898:EE_
x-ms-office365-filtering-correlation-id: 580edc0f-419c-499d-2d44-08dab7d4b955
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gp2prqIl+dm0w8uPxnTHH/sBDycvbNHqBANURNnEn6jVEmLdJseBXN8MZzkVm8YNWR8/yVm9aIZibJ4i9r5h6ZI97qpqHiPAKTPGn22/PaOUZQGxfAWEK64wV8gXX+cbahnto3nLwvdmNq8nvGIY3fXN9Zjr5KRwUS58ZMV4J3Fo5GL9TZ8SQ1RRTnISbPTAWsRvOh+4aRVEMMVrh3hL4LLw8N4Px9FZ0mt9pVyX9GrMy7vRMkimCdtylvAbUFLnlgKqwwtlpiCgP0NE4j90Bd4i+LvV88+rNvwHs03ALJ4FItiljy8HO21UCL/oJGt04cKOrJ2VPFwJX8KBU+vujjYqw9r5GazNsROC/idXMY+aTz1byQpeMyoO4jJzaLKdMh0qJHXpeCqtwLo5IECZ5mpni4+uH+33Ht3uXZvo1nsiJeV2gbp8zJxvK40t31LC6qhuhloXgvmUuXwUTAlNdSEYnwfL0YhEDZOfgRxTNDBIva1d66uXF24GhxbTQte4EmGHr552K8H3qSU2nG/1R/e6dbPC7Iwv+zyLcvsSoDIxFc06Ia6r0NIP0BJWjlBNLl6tgbJ7XsQ7XYIGFxOXSjeTWs8YdB6MAXv41bI7i2W28aB4IOFoW4KXJe5AL+x+fsw24cJepAA3OvZXf65kNxWQnGQ4j0OEZdmBxfN8QRenGHiwWpGTrhHrvNYHodxvftNN6LgUFApLPLUwYg1w9yB2gUFkXllC6it1BXRhK7bXcf4fdcsSyISr5DS/OssnK2Fm7GVvqVFeMTbOuTtXAPIFk+uZgXll+CfsD+OVpWEFFQU3G3NOGZOtU5MS1jisVWFkwJcr2imWLDtKOeejSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4337.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(966005)(71200400001)(86362001)(478600001)(83380400001)(76116006)(53546011)(66476007)(66946007)(107886003)(64756008)(7696005)(8676002)(6506007)(66556008)(7416002)(41300700001)(52536014)(8936002)(5660300002)(9686003)(6916009)(26005)(2906002)(55016003)(122000001)(38100700002)(33656002)(186003)(4326008)(54906003)(82960400001)(66446008)(38070700005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j++8/r941AfFEHjRxFscZu2B+eCaE/IDjbh7ehnt5Oe2so0zH3g4EuPUO6+p?=
 =?us-ascii?Q?xJ2Ew7YBNWtlK0yt+zDNqGmd3Q6qKK818d/sAiOvYBhbFLfh2fl6NDEyXQB/?=
 =?us-ascii?Q?8U9/4YEuAWkqREPY/BmElpv2chG12BPr7S70yjCg0zwaHQdbmn3iTDAjPUAg?=
 =?us-ascii?Q?gd8il10r7A1puYknQXzzqxY2UEx+l04g6HrD825G6KDugF92sCCmWOAxTZdR?=
 =?us-ascii?Q?hmlZpSo7bpn8XaZtW1LF98mpsf72hDbtOdno6RlHIkzG5qIib3c2Ht+6J5xv?=
 =?us-ascii?Q?1QL05a2YYGF1MNA+FLsn4i8k5LU3AIa/RzayFOvjsTWM+p7wSqjS2fQIVnyz?=
 =?us-ascii?Q?lPqET0gUjkBuY27vm2iO97XTqRikHVWf5h8qd4rsg2FEclPWIMwLQZJF4XA4?=
 =?us-ascii?Q?xv7/Cr8x/YZvks4NjrWQTlPLLQz9I8YrqNge5IPY9Uz4J8KLZc5z5SQ60JKj?=
 =?us-ascii?Q?vvrdjn1BqTzNTvndZt1BIh9EJPL8UEeLCiFc0scJf8BLGqaFKKyclp6GsfxH?=
 =?us-ascii?Q?rNGuiHkEfpsr61rCnbg6x1Dhyp2Lt9c9Lxu+LCwSPiRsnxqIMuQC+MsUOVVv?=
 =?us-ascii?Q?S0SShyKUtSOfb9YBd4UKW4BxyRz24BkqESiCfw35K41PexJ+uYKoOIR/juvW?=
 =?us-ascii?Q?uevI6WNhLc60Cox5e/39ORJVJxvEqqQJdKeNgsrLEz+Z/Fnco2aMrpJVU4us?=
 =?us-ascii?Q?WZkq43/zGR5Fjp+WjpgI5/zzlwVpiRR9CRYxLK3qKpMbcLzzHcb+RZbcphco?=
 =?us-ascii?Q?dF9BbSgYdB60X/H6WTPKNSCuh0rmJ2nMFjjtsutV86JyYSHcBvf6QYNsGUi6?=
 =?us-ascii?Q?cHookzXMsNvTNkR+P7ZcFiD5nBP1Xet4Qf4YEAsCXCtp/y9mAFO0v2HFI2BE?=
 =?us-ascii?Q?H9XXCQGIJUVQFa5naliUkBxd7Xb8n7T/isGil2Ob0ucbaT6p7ZQdiDGKbCEo?=
 =?us-ascii?Q?xIjx+WrGS7YYhw/ebTURcCk9hBMzcjxFN4z0yk/q5KdM92Noveq6eqJUcSXK?=
 =?us-ascii?Q?/xKuh/4YXhxdfFYQs3sg3K/vefmldq1d/PglpT3jsTo/tqScfHRam4N24dkU?=
 =?us-ascii?Q?jMewAJRju01gYC75N1eEsaXyof8meVDL9U9YUf9onUzFfQtnR3At1y8Ni1i7?=
 =?us-ascii?Q?g5ZhBvIX1Irz+uRGi90ItJ7LrLRYEez+XGjqHwS3LzrbmCEyhLo0I5ouXOqr?=
 =?us-ascii?Q?hn6sPPZ16upOyrXD2u+ATC0s1JZY4mr5EuI+iVrV4GZQXJOY3NgX2LYC5xs9?=
 =?us-ascii?Q?ItSofQKTa8OYabjTkolcREiz6ONshOGhqDmpKjoh3Fg0cheeAIXOnvKHxPMs?=
 =?us-ascii?Q?swMAtl127BkANW38maaOD3QmizYGphfyBYGsKCl+vXdsjEECX54tHwmmG0iN?=
 =?us-ascii?Q?8RxDZrc0aKzeTVVCVKYR/3bVzZ5O+piwVUX2wdkKElEiR1oodgl5rT1joaJW?=
 =?us-ascii?Q?JuqfQY9CP6m2cH1PavIqOW1b1/yMIxxXJ9BZZSKum/RNZaQrgwPhWuy9WRQu?=
 =?us-ascii?Q?v96psjh7+oMCqQVDGKBDNR006WhnN8CfLCY3Fg+jCLSsDnkYhpjj2rYTsn8Q?=
 =?us-ascii?Q?TcrbemH7BvFNumWRZMZSmiX9LfxkgXYa6EPJ9ZBMjHS/9qatlai5d4Ft1NYG?=
 =?us-ascii?Q?3A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4337.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 580edc0f-419c-499d-2d44-08dab7d4b955
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 04:35:49.6507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UbAeMGQqWd5HxxYOWIg1LZsL06nEWlwZ1o1Sgfxh8RLGQIFIxBmoHhSpZmEOFdgrXHVau4eapCYim7gvPJR+GQU+FIS1PBYSLO2slQ4ynbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6898
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, 20 September, 2022 7:46 AM
> To: Jamaluddin, Aminuddin <aminuddin.jamaluddin@intel.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> <linux@armlinux.org.uk>; David S . Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Ismail, Mohammad Athari
> <mohammad.athari.ismail@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org; Tan, Tee Min
> <tee.min.tan@intel.com>; Zulkifli, Muhammad Husaini
> <muhammad.husaini.zulkifli@intel.com>
> Subject: Re: [PATCH net 1/1] net: phy: marvell: add link status check bef=
ore
> enabling phy loopback
>=20
> > > > Its required cabled plug in, back to back connection.
> > >
> > > Loopback should not require that. The whole point of loopback in the
> > > PHY is you can do it without needing a cable.
> > >
> > > > >
> > > > > Have you tested this with the cable unplugged?
> > > >
> > > > Yes we have and its expected to have the timeout. But the
> > > > self-test required the link to be up first before it can be run.
> > >
> > > So you get an ETIMEDOUT, and then skip the code which actually sets
> > > the LOOPBACK bit?
> >
> > If cable unplugged, test result will be displayed as 1. See comments be=
low.
> >
> > >
> > > Please look at this again, and make it work without a cable.
> >
> > Related to this the flow without cable, what we see in the codes during
> debugging.
> > After the phy loopback bit was set.
> > The test will be run through this __stmmac_test_loopback()
> > https://elixir.bootlin.com/linux/v5.19.8/source/drivers/net/ethernet/s
> > tmicro/stmmac/stmmac_selftests.c#L320
> > Here, it will have another set of checking in dev_direct_xmit(),
> __dev_direct_xmit().
> > returning value 1(NET_XMIT_DROP)
> > https://elixir.bootlin.com/linux/v5.19.8/source/net/core/dev.c#L4288
> > Which means the interface is not available or the interface link status=
 is not
> up.
> > For this case the interface link status is not up.
> > Thus failing the phy loopback test.
> > https://elixir.bootlin.com/linux/v5.19.8/source/net/core/dev.c#L4296
> > Since we don't own this __stmmac_test_loopback(), we conclude the
> behaviour was as expected.
> >
> > >
> > > Maybe you are addressing the wrong issue? Is the PHY actually
> > > performing loopback, but reporting the link is down? Maybe you need t=
o
> fake a link up?
> > > Maybe you need the self test to not care about the link state, all
> > > it really needs is that packets get looped?
> >
> > When bit 14 was set, the link will be broken.
> > But before the self-test was triggered it requires link to be up as sta=
ted
> above comments.
>=20
> You have not said anything about my comment:
>=20
> > Maybe you need to fake a link up?
>=20
> My guess is, some PHYs are going to report link up when put into loopback=
.
> Others might not. For the Marvell PHY, it looks like you need to make
> marvell_read_status() return that the link is up if loopback is enabled.
>=20

We able to do the PHY loopback test, after fake link up without=20
cable plugged on as suggested above.=20
We will provide version 2 patch with minimum code changes=20
without having the status link check.
Only need to increase the msleep(200) to msleep(1000) inside
m88e1510_loopback() function.

Amin
