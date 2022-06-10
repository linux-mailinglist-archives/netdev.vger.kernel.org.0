Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3440A545A9D
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiFJDhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiFJDhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:37:39 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A0E3AA5A;
        Thu,  9 Jun 2022 20:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654832256; x=1686368256;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lB1+V0f6aXIH+/lfdcTuOTgs46Vce13m1EWuabl4+84=;
  b=bVMqbMduAP/0VJnNg27QmaPeiJMG5nfgR7jQZdCGM5JJIA21efDUEfhp
   zFy0QnXEtXDVOQXd6zL2FwG/AhGrAfz1ilQaeS1ybB/JKLbfEHyyQk/WJ
   BV4lXDXClpJc78LGE4bt/Svwg5VrIOjdO0YjPVLST0AssuU7+oW82eW35
   nuqdoMgn62i0GXOU8EKXid8sJkaM44fpHqcFYfSHY0QAvn+IcugfQIzYp
   rw6cMhJ8zAauw09MeA76iMRsPhmWPt2+QwPOtEuew5Rc9mAU6Raqi567v
   4GasDPHOEmobx/9bBusrRIOAghSyQ5vdI8DLQyWb/iH3REDyIgyWX/edi
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="363826947"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="363826947"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 20:37:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="908683143"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jun 2022 20:37:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 9 Jun 2022 20:37:35 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 9 Jun 2022 20:37:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 9 Jun 2022 20:37:34 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 9 Jun 2022 20:37:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0MT4fpXXVTBFjtnjpm9U+92Yb6ENV2WmBr7H0ZJSMok32eIp0jnOFdhLH15AYyAGw7QMrD8wxY0GbO1XD9GsMt5VOxAJoU/tr+piGlMry9TxI0armD5mzOy4PYhcmdR9HFKH9RRhnVBGAepDjT2MCiTFjL5GB5OMOoHaPEVp/iKOol6KAabCIWBJ2FOFPCDiOSO528Xc/X6KmiLzdOJ2FhsUIc/G7oiCX5r1eCi+tAuaAFAUOFZ/amvLXEwTZh99s6mVEb5l+FrU6SgXyXj+nkRzjQgEDIgoGv5QAko6n75K6WN/v3w+KlxJpbCHkz1i1J+q4ZMSDzJHeTMBJFU2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSeY8fd/MVHQT8S1wavi1dSCQDoBIHAjdj/24iuFT9s=;
 b=V9gwvXY02cBp3B0ujwHHiyg/Lxj92ij8vT/MVcfN33ZXkBTeflVCWErP29WD4lndxHkwvRds8GwhejpM4u6SlHeXrLYSPMhPW23iESmprQOTZAx+1fywCQoMZMqDpAc4uM16AP2l/cUn+kBHJaDubDxjQsbM1NaW1Z4nZp2hIQ++IW4J0P9VeVJ+HJLmDJks79Lb8Y1w0+J9MLtydX4f1EEXdr6E54Q5ud9WM7DzYefLpIMHa6xlt46L5Km7iSEVNMR2tzrOax3nzH7YFVSgBPvFXss5zgFgAy4OHjp8+ndBobNSqvyoa7LvV35uwwslxJS/RDtwYCJbdsvlqtV7Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6095.namprd11.prod.outlook.com (2603:10b6:8:aa::14) by
 DS0PR11MB6422.namprd11.prod.outlook.com (2603:10b6:8:c6::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Fri, 10 Jun 2022 03:37:32 +0000
Received: from DM4PR11MB6095.namprd11.prod.outlook.com
 ([fe80::40e5:e77a:f307:cbb3]) by DM4PR11MB6095.namprd11.prod.outlook.com
 ([fe80::40e5:e77a:f307:cbb3%4]) with mapi id 15.20.5314.019; Fri, 10 Jun 2022
 03:37:32 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Riva, Emilio" <emilio.riva@ericsson.com>
Subject: RE: [PATCH net-next v2 0/7] pcs-xpcs, stmmac: add 1000BASE-X AN for
 network switch
Thread-Topic: [PATCH net-next v2 0/7] pcs-xpcs, stmmac: add 1000BASE-X AN for
 network switch
Thread-Index: AQHYfHsADZjbSVqcIU+eQNlLC8+Ikq1H/bpg
Date:   Fri, 10 Jun 2022 03:37:32 +0000
Message-ID: <DM4PR11MB60955991A4970811F0283D9BCAA69@DM4PR11MB6095.namprd11.prod.outlook.com>
References: <20220610032941.113690-1-boon.leong.ong@intel.com>
In-Reply-To: <20220610032941.113690-1-boon.leong.ong@intel.com>
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
x-ms-office365-filtering-correlation-id: e12b6feb-32b1-4915-21e7-08da4a928d99
x-ms-traffictypediagnostic: DS0PR11MB6422:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DS0PR11MB642236ABDCCE1E65CF04F1B6CAA69@DS0PR11MB6422.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S+KRH9U2dI4MtPP2MRub7Ed8QTs63jIXYGqUwKLPmI3S3CfLImWcZCaUL0EbxmHdDg7yhlDYhWET/2Dtla5tCAQxMPHcCoVHWQCh0H5aE9CLlAsUjvlkfStcEu6UnImN115YcQTY3SNxucYciGMv/HpZ3KVE+i5+ibpifSUOEdZ+DrevRquRmNhPlnJrlt6iM9VLB/nSHRvTo8M1brWC4iQOigeMOs3i2xocjwPKiW5MYKdlwKUHWCqqFF2fkur9qgZgyuUyWM30SkVIOJ+9DWZVshgCZgceNrsYkQ6CfRt/YxLBJ4og6LZaCQuQFP0xmi6s6pS98iL/Nm/zQ8pIP/CzstyjxYjUCzpBGM/VLzlUOwj+YBGfuZnTujYexMNZ7Vmu2TmoahpQTOv2Vl7Ky2Hn56NgpO8Z/+hwH2XBX8ZTDHif/UEXjYSLm8EYagVSQwkf8naVcfz2o8ZE8vUS9e72XSuWRL8UWCQXUwzZcqCjk8wGDJ9gUeZrcpfkreAtiS//fOH/kwbGL/D4myTSOrtlOfNgo85EgtVKsAppwSEoi8HNQKkie9x2EKz2YcuVqrA6kkm0hFgroJuUVgkb/9jfSX7h1vYZV2aUyfablAsL9sbHQdqe49Yx0EpVyhF1NGHmdiRUz0K/pSJ+wPCyLBIHXqvXrWgPxAVZgtigNgvkAxsVYZ1Xf6gsOb3/u0AiZom+m9Nuattp5pNuiUgoOFekeTIxVlnHzg9RExQqvw80qtWlaz1ZfSGKqLUn59x3zzO5DQg9XOAJJcs22lHIMdMHZTRYldDYJa7OBzMpPGz05vcieoTh2AgWB08b+TnMDfXFDO614WVxDovScpiH+TW9YvgovNjUtRDmtcKwQvE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(7696005)(30864003)(71200400001)(2906002)(186003)(38100700002)(83380400001)(6506007)(7416002)(55016003)(26005)(64756008)(38070700005)(33656002)(86362001)(9686003)(8936002)(66446008)(966005)(921005)(122000001)(8676002)(66476007)(508600001)(66556008)(66946007)(76116006)(4326008)(316002)(110136005)(52536014)(82960400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IMhzOy2YZIK51s/I3g6cuKKFQ+1SiinzC2LLYMRjAZjxFqEDkjqY58LRrd5I?=
 =?us-ascii?Q?N4vXEG4/oZBPiv/EfPSpm7HhE4T2XOHd2IW8aCggOnw0n5l66FP6D1aDWnN3?=
 =?us-ascii?Q?r/f2QmNdiNt9hj/+yX5QrxIpOotYuxavuRAmxs9QxxxuSrzMoMlBhBWvfbMD?=
 =?us-ascii?Q?O+clUnCcbT9DPDlbpqLtVQ5xz4/YcYt6gF+/vyNGGCVVqK9S6zhznB7wcd9P?=
 =?us-ascii?Q?f/GeWwQUGgLDphKDg6j/mPflDENLTNsPFOW0P5l5/ka4vPb8GZkaQJJTwPrp?=
 =?us-ascii?Q?wBAEn45wlJFxdR3yfZOt+Q+zYKjqHW6rIVwj0Iz/3D64eVP+nrFw2HetDYHC?=
 =?us-ascii?Q?s17Kxh9ANSZuCDplYiACFxUet+TBR55DKSp6Q9dP6878z6SXk92KWgMRv85B?=
 =?us-ascii?Q?v2DlQCci7H1wDyMq/7vbNi/oZZqFCspUlqMyEMGsOb3SGfFegLXjsN4QZ6FO?=
 =?us-ascii?Q?BAAR5Ee6CbNHMHJZV/Y2lcvdqaujIrJlNoX4EAdADc4olBnqG3UQ8IFLPlWF?=
 =?us-ascii?Q?EiLmf+YXd73X2xk5CfGEFRJ7jRIB7yd4D1tDSZYtZFytYYqiO0CSk2Prj9um?=
 =?us-ascii?Q?10KV/pxqpqVx2AwXCmlP6MiHpv8hYDV3xdqDd2hHhkLCFGZAkKLRP1KFgFMf?=
 =?us-ascii?Q?PkVm+FL17uuLn2q9NS25bM/tpQJey07P5zFtMkzgkzEEtrumnicvmOhgJ5fj?=
 =?us-ascii?Q?qkJa1ODOfzovnc0qWctBu7ZvXWlsK0mVQDhnGxtxoAxyYdyWj4nO1H/yApmT?=
 =?us-ascii?Q?YvAIMM4APNJZiB0AzzI9ofgl1/1kYBWRnOUUAZN5ktNWLb4r8Rcw7xFHL3Sq?=
 =?us-ascii?Q?6AwcXwXfQz3jWHMFdiXP62eDPxN1wO/johcOI4Fno35FlYPygRNCc8xEGXzM?=
 =?us-ascii?Q?JtGW1SRbJCvVl4HwKxISmaHdxM8RP0VpIj7+Qusw/9YL+TScpf6goWpLe4HE?=
 =?us-ascii?Q?vCTHyp2qgvDpczp4Hv6wXLof6ymZVeHWeH4IEvXK+Yj+7wFq29g4+kPlk0/h?=
 =?us-ascii?Q?TDowTTeE9iromTCpyyP5YvOr54sEpilxN8en2in++Jr2IDNwdbKdjBgzBBYj?=
 =?us-ascii?Q?VCcO3yzo7AiifmEQexVCjjmwLKmdjxJuKCCxJeO89MtFsm1ev71MQkVUOhcD?=
 =?us-ascii?Q?+eXUSYnk1GdYdWMue0RhF6wBB3jJ3WTlBV7a2T9IZD2UmoJFSxbzBaURQGT4?=
 =?us-ascii?Q?DRp3fVmwpAILtsgdan2BsonxQcF1yIkM55KE2pbUbV8gaqHbp+4ffCNnuhHI?=
 =?us-ascii?Q?xz8LTJKBKdwQ+B6dOZrTauu+b3ovKzopAdMIJF6HeP1ctnxEm3jktflBCWCx?=
 =?us-ascii?Q?2YCIKH+BqBQf0wZAYin18Wc1x/qhwUBTzvETYBo5HWA/oCin3ytclYtnMThI?=
 =?us-ascii?Q?40bm1GhcVFR7J1JxFEMQtVXT+HDPsMizeggsF1ohERfej8vA5y1vQ+mAZUkL?=
 =?us-ascii?Q?C/Rt8D9/gGIOg0yL/F3Tf1zpVz2V6xfyR9yZf8M7Sr07C6i8GxybPwQMnmT0?=
 =?us-ascii?Q?HWJ+olL0oCb/rRANfON/gH9Ss1C3pR/6ar62JXttQCLpyE0Z9n6tyQl7dsp+?=
 =?us-ascii?Q?cSIM/RtlK1RaakGxKft5NvJHKsKDxkjfekeps1rj+rMLa9vjtMOtNJ6D0FYv?=
 =?us-ascii?Q?LK+l0Yb0IANYda9ErDFLY7yAH5jMHT0SMdAHI4jimq72d5cVOT0eV9uIZFkS?=
 =?us-ascii?Q?gGymrrK/RuP1lNGVR7RS7W7uGTuNSnixMot5hD36RGwssFkiiyVdCEujY3qq?=
 =?us-ascii?Q?VaJZLQ0mtIz3LpgHp8JcAscQIqIdB1s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e12b6feb-32b1-4915-21e7-08da4a928d99
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2022 03:37:32.7493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fty6yZgMn0xz7dI7z1gIpKvXBY4SL1NLmXL7ckGBRsuHMlRK4AMVzu5ggVzTWUSPVt3BFvt/MzWgHGEKQvYnV/tESjV1l60QaT3haelvAZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6422
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My bad in missing the 1/7 patch. Please ignore these series. I will be send=
ing v3.=20

>-----Original Message-----
>From: Ong, Boon Leong <boon.leong.ong@intel.com>
>Sent: Friday, June 10, 2022 11:30 AM
>To: Alexandre Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
><Jose.Abreu@synopsys.com>; Andrew Lunn <andrew@lunn.ch>; Heiner
>Kallweit <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; Pao=
lo
>Abeni <pabeni@redhat.com>; David S . Miller <davem@davemloft.net>; Eric
>Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
>Vladimir Oltean <olteanv@gmail.com>; Vivien Didelot
><vivien.didelot@gmail.com>; Florian Fainelli <f.fainelli@gmail.com>; Maxim=
e
>Coquelin <mcoquelin.stm32@gmail.com>; Giuseppe Cavallaro
><peppe.cavallaro@st.com>
>Cc: netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com;
>linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Riva,
>Emilio <emilio.riva@ericsson.com>; Ong, Boon Leong
><boon.leong.ong@intel.com>
>Subject: [PATCH net-next v2 0/7] pcs-xpcs, stmmac: add 1000BASE-X AN for
>network switch
>
>Hi,
>
>Thanks Russell King [1] and Andrew Lunn [2] for v1 review and suggestion.
>Since then, I have worked on refactoring the implementation as follow:
>
>v2 changes:
>1/7 - [New] Update xpcs_do_config to accept advertising input
>2/7 - [New] Fix to compilation issue introduced v1. Update xpcs_do_config
>            for sja1105.
>3/7 - Same as 3/4 of v1 series.
>4/7 - [Fix] Fix numerous issues identified by Russell King [1].
>5/7 - [New] Make fixed-link setting takes precedence over ovr_an_inband.
>            This is a fix to a bug introduced earlier. Separate patch
>            will be sent later.
>6/7 - [New] Allow phy-mode ACPI _DSD setting for dwmac-intel to overwrite
>            the phy_interface detected through PCI DevID.
>7/7 - [New] Make mdio register flow to skip PHY scanning if fixed-link
>            is specified.
>
>I have tested the patch-series on a 3-port SGMII Ethernet on Elkhart Lake
>customer platform and PSE GbE1 (0000:00:1d.2) is setup for fixed-link
>with below ACPI _DSD modification based on [3]:-
>
>        Device (OTN1)
>        {
>            <snippet-remove>
>
>            Name (_DSD, Package () {
>                ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>                    Package () {
>                        Package () {"phy-mode", "1000base-x"},
>                    },
>                ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
>                    Package () {
>                        Package () {"fixed-link", "LNK0"}
>                    }
>            })
>
>            Name (LNK0, Package(){ // Data-only subnode of port
>                ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>                    Package () {
>                        Package () {"speed", 1000},
>                        Package () {"full-duplex", 1}
>                    }
>            })
>        }
>
>The modified ACPI DSDT table is inserted into OS based on [4] for
>testing purpose. This method will not be required if respective BIOS has
>the matching ACPI _DSD changes. In gist, we avoid the need to add board
>specific DMI based configuration to Linux driver and let ACPI DSDT table
>customized according to hardware/port configuration design to decide how
>the driver is loaded up per port-basis.
>
>From dmesg below (whereby non-relevant section removed), we can see that:-
>
>[    4.112037] intel-eth-pci 0000:00:1d.1 eno1: configuring for inband/sgm=
ii
>link mode
>[    4.132016] intel-eth-pci 0000:00:1d.2 eno2: configuring for
>fixed/1000base-x link mode
>[    4.162069] intel-eth-pci 0000:00:1e.4 eno3: configuring for inband/sgm=
ii
>link mode
>
>--------------------------------------------------------------------------=
--------------------------------
>-
>[    1.471347] intel-eth-pci 0000:00:1d.1: stmmac_config_multi_msi: multi =
MSI
>enablement successful
>[    1.471518] intel-eth-pci 0000:00:1d.1: User ID: 0x51, Synopsys ID: 0x5=
2
>[    1.471525] intel-eth-pci 0000:00:1d.1:      DWMAC4/5
>[    1.471531] intel-eth-pci 0000:00:1d.1: DMA HW capability register
>supported
>[    1.471533] intel-eth-pci 0000:00:1d.1: RX Checksum Offload Engine
>supported
>[    1.471535] intel-eth-pci 0000:00:1d.1: TX Checksum insertion supported
>[    1.471536] intel-eth-pci 0000:00:1d.1: TSO supported
>[    1.471537] intel-eth-pci 0000:00:1d.1: Enable RX Mitigation via HW
>Watchdog Timer
>[    1.471542] intel-eth-pci 0000:00:1d.1: device MAC address
>a8:a1:59:9d:2b:64
>[    1.471545] intel-eth-pci 0000:00:1d.1: Enabled L3L4 Flow TC (entries=
=3D2)
>[    1.471547] intel-eth-pci 0000:00:1d.1: Enabled RFS Flow TC (entries=3D=
10)
>[    1.471552] intel-eth-pci 0000:00:1d.1: Enabling HW TC (entries=3D256,
>max_off=3D256)
>[    1.471555] intel-eth-pci 0000:00:1d.1: TSO feature enabled
>[    1.471556] intel-eth-pci 0000:00:1d.1: Using 32 bits DMA width
>[    1.471770] mdio_bus stmmac-2: GPIO lookup for consumer reset
>[    1.471774] mdio_bus stmmac-2: using lookup tables for GPIO lookup
>[    1.471777] mdio_bus stmmac-2: No GPIO consumer reset found
>[    1.481872] mdio_bus stmmac-2:01: GPIO lookup for consumer reset
>[    1.481879] mdio_bus stmmac-2:01: using lookup tables for GPIO lookup
>[    1.481881] mdio_bus stmmac-2:01: No GPIO consumer reset found
>[    1.483206] Maxlinear Ethernet GPY215B stmmac-2:01: Firmware Version:
>0x8764 (release)
>
>[    1.683631] Maxlinear Ethernet GPY215B stmmac-2:01: attached PHY driver
>(mii_bus:phy_addr=3Dstmmac-2:01, irq=3DPOLL)
>
>[    1.749607] intel-eth-pci 0000:00:1d.2: stmmac_config_multi_msi: multi =
MSI
>enablement successful
>[    1.749677] intel-eth-pci 0000:00:1d.2: User ID: 0x51, Synopsys ID: 0x5=
2
>[    1.749681] intel-eth-pci 0000:00:1d.2:      DWMAC4/5
>[    1.749688] intel-eth-pci 0000:00:1d.2: DMA HW capability register
>supported
>[    1.749690] intel-eth-pci 0000:00:1d.2: RX Checksum Offload Engine
>supported
>[    1.749692] intel-eth-pci 0000:00:1d.2: TX Checksum insertion supported
>[    1.749693] intel-eth-pci 0000:00:1d.2: TSO supported
>[    1.749694] intel-eth-pci 0000:00:1d.2: Enable RX Mitigation via HW
>Watchdog Timer
>[    1.749701] intel-eth-pci 0000:00:1d.2: device MAC address
>a8:a1:59:9d:2b:46
>[    1.749703] intel-eth-pci 0000:00:1d.2: Enabled L3L4 Flow TC (entries=
=3D2)
>[    1.749705] intel-eth-pci 0000:00:1d.2: Enabled RFS Flow TC (entries=3D=
10)
>[    1.749710] intel-eth-pci 0000:00:1d.2: Enabling HW TC (entries=3D256,
>max_off=3D256)
>[    1.749712] intel-eth-pci 0000:00:1d.2: TSO feature enabled
>[    1.749714] intel-eth-pci 0000:00:1d.2: Using 32 bits DMA width
>
>[    1.749821] mdio_bus stmmac-3: GPIO lookup for consumer reset
>[    1.749823] mdio_bus stmmac-3: using lookup tables for GPIO lookup
>[    1.749825] mdio_bus stmmac-3: No GPIO consumer reset found
>[    1.759184] mdio_bus stmmac-3:01: GPIO lookup for consumer reset
>[    1.759188] mdio_bus stmmac-3:01: using lookup tables for GPIO lookup
>[    1.759190] mdio_bus stmmac-3:01: No GPIO consumer reset found
>[    1.760419] Maxlinear Ethernet GPY215B stmmac-3:01: Firmware Version:
>0x8764 (release)
>
>[    2.025792] intel-eth-pci 0000:00:1e.4: stmmac_config_multi_msi: multi =
MSI
>enablement successful
>[    2.025876] intel-eth-pci 0000:00:1e.4: User ID: 0x51, Synopsys ID: 0x5=
2
>[    2.025881] intel-eth-pci 0000:00:1e.4:      DWMAC4/5
>[    2.025887] sdhci-pci 0000:00:1a.1: No GPIO consumer (null) found
>[    2.025888] intel-eth-pci 0000:00:1e.4: DMA HW capability register
>supported
>[    2.025891] intel-eth-pci 0000:00:1e.4: RX Checksum Offload Engine
>supported
>[    2.025893] intel-eth-pci 0000:00:1e.4: TX Checksum insertion supported
>[    2.025894] intel-eth-pci 0000:00:1e.4: TSO supported
>[    2.025896] intel-eth-pci 0000:00:1e.4: Enable RX Mitigation via HW
>Watchdog Timer
>[    2.025913] intel-eth-pci 0000:00:1e.4: device MAC address
>a8:a1:59:9d:2b:7a
>[    2.025915] intel-eth-pci 0000:00:1e.4: Enabled L3L4 Flow TC (entries=
=3D2)
>[    2.025917] intel-eth-pci 0000:00:1e.4: Enabled RFS Flow TC (entries=3D=
10)
>[    2.025924] intel-eth-pci 0000:00:1e.4: Enabling HW TC (entries=3D256,
>max_off=3D256)
>[    2.025926] intel-eth-pci 0000:00:1e.4: TSO feature enabled
>[    2.025928] intel-eth-pci 0000:00:1e.4: Using 40 bits DMA width
>[    2.026024] mdio_bus stmmac-1: GPIO lookup for consumer reset
>[    2.026027] mdio_bus stmmac-1: using lookup tables for GPIO lookup
>[    2.026029] mdio_bus stmmac-1: No GPIO consumer reset found
>[    2.035547] mdio_bus stmmac-1:01: GPIO lookup for consumer reset
>[    2.035551] mdio_bus stmmac-1:01: using lookup tables for GPIO lookup
>[    2.035553] mdio_bus stmmac-1:01: No GPIO consumer reset found
>[    2.036905] Maxlinear Ethernet GPY215B stmmac-1:01: Firmware Version:
>0x8764 (release)
>
>[    2.239477] Maxlinear Ethernet GPY215B stmmac-1:01: attached PHY driver
>(mii_bus:phy_addr=3Dstmmac-1:01, irq=3DPOLL)
>
>[    2.305510] intel-eth-pci 0000:00:1d.2 eno2: renamed from eth1
>[    2.315038] intel-eth-pci 0000:00:1d.1 eno1: renamed from eth0
>[    2.320776] intel-eth-pci 0000:00:1e.4 eno3: renamed from eth2
>
>[    4.098137] intel-eth-pci 0000:00:1d.1 eno1: Register
>MEM_TYPE_PAGE_POOL RxQ-0
>[    4.098647] intel-eth-pci 0000:00:1d.1 eno1: Register
>MEM_TYPE_PAGE_POOL RxQ-1
>[    4.099187] intel-eth-pci 0000:00:1d.1 eno1: Register
>MEM_TYPE_PAGE_POOL RxQ-2
>[    4.099695] intel-eth-pci 0000:00:1d.1 eno1: Register
>MEM_TYPE_PAGE_POOL RxQ-3
>[    4.100168] intel-eth-pci 0000:00:1d.1 eno1: Register
>MEM_TYPE_PAGE_POOL RxQ-4
>[    4.100636] intel-eth-pci 0000:00:1d.1 eno1: Register
>MEM_TYPE_PAGE_POOL RxQ-5
>[    4.101114] intel-eth-pci 0000:00:1d.1 eno1: Register
>MEM_TYPE_PAGE_POOL RxQ-6
>[    4.101586] intel-eth-pci 0000:00:1d.1 eno1: Register
>MEM_TYPE_PAGE_POOL RxQ-7
>[    4.111664] dwmac4: Master AXI performs any burst length
>[    4.111750] intel-eth-pci 0000:00:1d.1 eno1: Enabling Safety Features
>[    4.111795] intel-eth-pci 0000:00:1d.1 eno1: IEEE 1588-2008 Advanced
>Timestamp supported
>[    4.111897] intel-eth-pci 0000:00:1d.1 eno1: registered PTP clock
>[    4.112033] intel-eth-pci 0000:00:1d.1 eno1: FPE workqueue start
>[    4.112037] intel-eth-pci 0000:00:1d.1 eno1: configuring for inband/sgm=
ii
>link mode
>[    4.113621] 8021q: adding VLAN 0 to HW filter on device eno1
>
>[    4.118316] intel-eth-pci 0000:00:1d.2 eno2: Register
>MEM_TYPE_PAGE_POOL RxQ-0
>[    4.118835] intel-eth-pci 0000:00:1d.2 eno2: Register
>MEM_TYPE_PAGE_POOL RxQ-1
>[    4.119338] intel-eth-pci 0000:00:1d.2 eno2: Register
>MEM_TYPE_PAGE_POOL RxQ-2
>[    4.119815] intel-eth-pci 0000:00:1d.2 eno2: Register
>MEM_TYPE_PAGE_POOL RxQ-3
>[    4.120282] intel-eth-pci 0000:00:1d.2 eno2: Register
>MEM_TYPE_PAGE_POOL RxQ-4
>[    4.120758] intel-eth-pci 0000:00:1d.2 eno2: Register
>MEM_TYPE_PAGE_POOL RxQ-5
>[    4.121228] intel-eth-pci 0000:00:1d.2 eno2: Register
>MEM_TYPE_PAGE_POOL RxQ-6
>[    4.121706] intel-eth-pci 0000:00:1d.2 eno2: Register
>MEM_TYPE_PAGE_POOL RxQ-7
>[    4.131662] dwmac4: Master AXI performs any burst length
>[    4.131744] intel-eth-pci 0000:00:1d.2 eno2: Enabling Safety Features
>[    4.131790] intel-eth-pci 0000:00:1d.2 eno2: IEEE 1588-2008 Advanced
>Timestamp supported
>[    4.131873] intel-eth-pci 0000:00:1d.2 eno2: registered PTP clock
>[    4.132010] intel-eth-pci 0000:00:1d.2 eno2: FPE workqueue start
>[    4.132016] intel-eth-pci 0000:00:1d.2 eno2: configuring for
>fixed/1000base-x link mode
>[    4.133517] 8021q: adding VLAN 0 to HW filter on device eno2
>[    4.133677] intel-eth-pci 0000:00:1d.2 eno2: Link is Up - 1Gbps/Full - =
flow
>control off
>[    4.133687] IPv6: ADDRCONF(NETDEV_CHANGE): eno2: link becomes ready
>
>[    4.138058] intel-eth-pci 0000:00:1e.4 eno3: Register
>MEM_TYPE_PAGE_POOL RxQ-0
>[    4.138557] intel-eth-pci 0000:00:1e.4 eno3: Register
>MEM_TYPE_PAGE_POOL RxQ-1
>[    4.139105] intel-eth-pci 0000:00:1e.4 eno3: Register
>MEM_TYPE_PAGE_POOL RxQ-2
>[    4.139581] intel-eth-pci 0000:00:1e.4 eno3: Register
>MEM_TYPE_PAGE_POOL RxQ-3
>[    4.140071] intel-eth-pci 0000:00:1e.4 eno3: Register
>MEM_TYPE_PAGE_POOL RxQ-4
>[    4.140547] intel-eth-pci 0000:00:1e.4 eno3: Register
>MEM_TYPE_PAGE_POOL RxQ-5
>[    4.141041] intel-eth-pci 0000:00:1e.4 eno3: Register
>MEM_TYPE_PAGE_POOL RxQ-6
>[    4.141519] intel-eth-pci 0000:00:1e.4 eno3: Register
>MEM_TYPE_PAGE_POOL RxQ-7
>[    4.151671] dwmac4: Master AXI performs any burst length
>[    4.151751] intel-eth-pci 0000:00:1e.4 eno3: Enabling Safety Features
>[    4.161830] intel-eth-pci 0000:00:1e.4 eno3: IEEE 1588-2008 Advanced
>Timestamp supported
>[    4.161916] intel-eth-pci 0000:00:1e.4 eno3: registered PTP clock
>[    4.162063] intel-eth-pci 0000:00:1e.4 eno3: FPE workqueue start
>[    4.162069] intel-eth-pci 0000:00:1e.4 eno3: configuring for inband/sgm=
ii
>link mode
>--------------------------------------------------------------------------=
--------------------------------
>-
>
>Also, thanks to Emilio Riva from Ericsson who has been helping me in testi=
ng
>the patch
>on his system too.
>
>Reference:
>[1] https://patchwork.kernel.org/comment/24826650/
>[2] https://patchwork.kernel.org/comment/24827101/
>[3] https://www.kernel.org/doc/html/latest/firmware-
>guide/acpi/dsd/phy.html#mac-node-example-with-a-fixed-link-subnode
>[4] https://www.kernel.org/doc/html/latest/admin-
>guide/acpi/initrd_table_override.html
>
>Thanks
>Boon Leong
>
>Ong Boon Leong (7):
>  net: pcs: xpcs: prepare xpcs_do_config to accept advertising input
>  net: dsa: sja1105: update xpcs_do_config additional input
>  stmmac: intel: prepare to support 1000BASE-X phy interface setting
>  net: pcs: xpcs: add CL37 1000BASE-X AN support
>  net: phylink: unset ovr_an_inband if fixed-link is selected
>  stmmac: intel: add phy-mode ACPI _DSD setting support
>  net: stmmac: make mdio register skips PHY scanning for fixed-link
>
> drivers/net/dsa/sja1105/sja1105_main.c        |   2 +-
> .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  19 +-
> .../net/ethernet/stmicro/stmmac/stmmac_main.c |  11 +-
> .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  14 ++
> drivers/net/pcs/pcs-xpcs.c                    | 186 +++++++++++++++++-
> drivers/net/phy/phylink.c                     |   4 +-
> include/linux/pcs/pcs-xpcs.h                  |   3 +-
> 7 files changed, 226 insertions(+), 13 deletions(-)
>
>--
>2.25.1

