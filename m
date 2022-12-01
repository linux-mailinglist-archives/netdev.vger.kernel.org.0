Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCF063F494
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiLAP44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiLAP4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:56:55 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C71EB2758;
        Thu,  1 Dec 2022 07:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669910212; x=1701446212;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uI9m+iXmCEYfgSocWmqBHyuwdQtvg6O2PnUB2P9ZIF8=;
  b=wy+PpEvmLw7X8bU/eBbdog2WcPsB1TPiHxGV9syPSFHsoepefKMELORg
   sJqJsY/GgAxdBoUsI5/H/MKV+8xinJbA49al4Kv4PNdlx5TbDTyaopApr
   22gFJAY5O/v6OkTuPQSTuNu35mc2Nnwowrl3xaF7pnaNGW2gPe5DFJazH
   bLlSm4a8wYUOB7t7X1tq7msNsIMpCji2itK9XiteTmuc7BGqzMJjnwfXM
   uYduVnVG1JmWzxTq3N/xR+y9d3TdngzlCngdduBxX4qk1byHZxG+j3rLq
   P2Gn7BE6YpCLhw73pmBNkzzFxXVeHcoRqOTnOMB6VqIyKuZFZ0HxSXSBa
   g==;
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="189574055"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2022 08:56:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Dec 2022 08:56:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 1 Dec 2022 08:56:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXXgf6PSnfX86DTufMGoo4lhPg8uMk6HtFhus2c0dx81DnmejIrqw3LFg65voLCwdHUyqqz5ZsrhGT5OrkeXrrXlccPqwGYHtPSBygVuTGpqjglCX0NH3gpGF1zAGwHtepfaxntFGx1P7NPrGP43VTFkUTzb0Mh54C6FVek9nQIv2LjYixokSIs1+cEZKsAZpU/uVoDdAgP40U0DN7Y6V3g5QT8F06MT7lUXMP5iKoRJAzL5pHIR9MYVEDFPEKGpwECbDjSfiku7zwkRJJZtcRHc5T91pbNx4TLncIt6HlN/NxIFZGIyKZztaXMK8MVLhZGopytewzfOqVb+2BefNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQXGG0nmeOKPH/KqIdlgD2HFDIrafZPNX4c+iCp13z0=;
 b=A5Kzj4VMbSp8A4NANvlMhyLKd6laWmnbaFrHuzCUtJYN9+rP0bWjmo+v26ZHEWl6i8XjVyhOePXOSobCDj9Zke+SX/Oc7MhhG9GhBQkghlTiJq5HG1OXs63xj67b5dE/6uN+Z5mhId4dts1sq5rk8wmJzBA8ASlA6ECOGFK3nepdwAmGiuntILCVjk9ndvA6qNAOWI+YLMXoTqWRw2acZIRJ1wtLd4gRQ7PZ3IE4w0zeGgVQPe3xFhwnsHL3nMSfe8aAhigPLNkQitHe/9Fp+0zR1z/OhYVkqo/8A3C8t2Tn0UicDs7gap1TitGi4NIEbiEXKzBb2e0kPQ6fAX7Y3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQXGG0nmeOKPH/KqIdlgD2HFDIrafZPNX4c+iCp13z0=;
 b=ncSW5NGoMctFlCkgPRoZ/tdhvsWQw8eHdspJjFq0rQEqW9VKcbHfUMn8UWJOMyZU7KmntOe06fVzEulPiidhtSx7dgHUa6OtBuxEJOc95JprqiqMmoX1JYavxrP6WJY1A76OhNfBjA7BydnufURfXm5oKIrwmJnTDY/Gfz5EjIM=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by MN0PR11MB6109.namprd11.prod.outlook.com (2603:10b6:208:3cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 15:56:47 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%11]) with mapi id 15.20.5880.008; Thu, 1 Dec 2022
 15:56:47 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <kuba@kernel.org>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Thread-Topic: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Thread-Index: AQHZA2vPxK4eDIuP5kOkg3W32g1dkK5U+YSAgAKmf0CAABFlAIAAFinAgAAKzwCAAWG+UA==
Date:   Thu, 1 Dec 2022 15:56:47 +0000
Message-ID: <MWHPR11MB1693FA23D320DC2DE585C696EF149@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221128205521.32116-1-jerry.ray@microchip.com>
 <20221128152145.486c6e4b@kernel.org>
 <MWHPR11MB1693E002721F0696949C5DCBEF159@MWHPR11MB1693.namprd11.prod.outlook.com>
 <20221130085226.16c1ffc3@kernel.org>
 <MWHPR11MB1693909B5E06A7791F0FD079EF159@MWHPR11MB1693.namprd11.prod.outlook.com>
 <20221130185026.pxdv7daoiqliz7qq@skbuf>
In-Reply-To: <20221130185026.pxdv7daoiqliz7qq@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|MN0PR11MB6109:EE_
x-ms-office365-filtering-correlation-id: fa705c61-0037-46d5-3ba0-08dad3b4a6e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eDb1EVpHfF8FTKPehUtd7ixDTx57WbXmfYLp/HxnAAt2ynVJtwDuT3MHwpSeADpqRn/LGEnRjjZaMIrO5Ba4I8ZQb6Nn8wgVzCOX/VOmSvDtmXsez1y9blA8tSXhFOzEIbp76O81el0qwR5H4HHDSn2eXhXGtNfhkwI58lAwIjwlA6hSjRuWqMu1L+qEzNX2TwGX3vH26nEPLrfDjRLCFLZ4KyOiFlWYGe1F4J08arIS+SBP8O01LmIhIx1u0278J9aWpjw7CCx+iShZAb6521t4BncU0mmJqF8ZFocYsXPPswMKeTKQ93Z8nh7wVdQ7xay6SQa8fnFsHmPbqYSc4+GmJ6HKwhL4sZ/SL2w3j/85RMYySVUnjvLiwSXHraI+aWlT1n8heWVSlcRIg53e/HhZXYqpSBIrJuTe7ws0hwVYoJ6WO7AJTA05ExGnxWSYjYB4kC7wDmviiR+6L5ifd4TV8Wg/jTCYS8cEjBwPXPLKvBrzE1ku1295qt50h1opz/Df16FZAgpCcR6k56rKSMsfdF4XG0dfWaY6kGga8bSMq2OyxNm+NWereupNInDNAbW8FtTKGjDiMDbsL8ySNTEnaZSPBZ0rHRW7lp5J2ttCbDH3JvKXw+F5ebf9uKScwO/vD7pmIA3nUhnO9gG5EvNxZL8HhMVynagrwTKG85CoNv28iYjHqs74po2XU3TXLuXomXtedfNby+6L66CEwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199015)(33656002)(71200400001)(2906002)(64756008)(66476007)(86362001)(9686003)(6916009)(54906003)(6506007)(186003)(7696005)(316002)(26005)(66446008)(478600001)(38070700005)(41300700001)(8936002)(5660300002)(52536014)(8676002)(76116006)(66556008)(66946007)(38100700002)(4326008)(122000001)(66899015)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k3uQ9FXUR4ihFUMZYCatQRdV1Bf3Ytqts+laq84O9GOeXDsYVUJEWCoFjS5d?=
 =?us-ascii?Q?fLdLF7RbTBxI/M9ipRRvz7PhRQn+yxIX4z3rSsNpHTI7fxmJzVVnB+ETIDx7?=
 =?us-ascii?Q?jmF9pkgeOUrtp1+Bwjuy6ej020D5dUH4jFbJirv+4AzcQFtELpv890tKGvAa?=
 =?us-ascii?Q?EhS8vxw6QHOpvdBBJIwtgGUYR6mIx0g7m6QRQ8i5rnZRI1OFl9tBj/gHqE8J?=
 =?us-ascii?Q?zhrvOUGyBPMmlTYhIcekxhDBOA+alHaeFbF0IYkD5XdMgeFIJvbe6yNcz/3b?=
 =?us-ascii?Q?BRbbpX2EgQtyF8uF+fo6EGcHW5zClHDsGVRzLmSRqyrULY8azxlczMeQ4/bv?=
 =?us-ascii?Q?FgoBi7J7t/u707YtI1mYTnY57kD+w902vh38RGzjntqX4P+i2OeNNVC5rP++?=
 =?us-ascii?Q?CpJOxDDckEIoSI8Ydl/oHT9NZ2MlAzvxiugpcEmtGl9beSe5wSszsYEDGfK7?=
 =?us-ascii?Q?tuqqmSWy6MnYIrD6r5/bbBxJK0kdljngH3PXaSfMc2k3P2MmAcnMl9U/eWFc?=
 =?us-ascii?Q?l0eUOVi0V++6C3aviwCr5X1/Bbl6uR8IG26o9lR+WcjtxK4LX1nG4ssH1nCo?=
 =?us-ascii?Q?kMfIPZoGG7U142/w2FglazrnpEVh5b0eMFRGEMklaiS4W8ruv+xRn5RKu/0n?=
 =?us-ascii?Q?s+ZmHFhUnUNIkzImLCElwF8dZvCwmrGrCZWe/YVsDD/3B3Ip/fuhetEVeJe8?=
 =?us-ascii?Q?DU61VP1fwxNMVkjSebefib6VSOntSowPqtY5m/LgdyMpAdH2iJACFmCagAAc?=
 =?us-ascii?Q?I+QTAitEdkLEBVsBjUzF/e9NWhQHoIkGswVr2Sj2+U+4i+hfkGjXAjQqB2nR?=
 =?us-ascii?Q?ngo3ZMYo31vn+M1RJXhJmVtTzQOtcanmohF6suARxtevr53NgKTzjYEOh4lK?=
 =?us-ascii?Q?RxmIm//wP8XzhymcXn3K0MWsWntVjPAThBtw1FzCIPbdSgYu08uEaFMdc19R?=
 =?us-ascii?Q?QHgBzdjI7VqKpGtyVSiD6sjlBG8nEXjjT7GieLv4I8ol2f4BhVIY7nG+BlXz?=
 =?us-ascii?Q?hWXAA2fjuabjrhr0oX578KUlSuLvRYO2F+2yz0v5SDsNWMcOIuIkfcPL0ljq?=
 =?us-ascii?Q?Ep2shzePbtuUmwO2uFcdw6pxIB91vbjDcOOZOYwOa3ugaooecnAy93EuzCRn?=
 =?us-ascii?Q?/qIDmdQt2KRjXYVMku/lapgqNv2CmkwANuT2VS1Ka78bVVpQaj7qIQ3S6Rse?=
 =?us-ascii?Q?nwpu/5KambbfuTkkprAKNFPmFuJy3Og/gnZ70TJsP+Qk4z6XXDpUL5c0MdCD?=
 =?us-ascii?Q?eFpBGUVnEH5VlW9Vo/w5HwKwqdwj1JQI+bdy/Ql6Ab2iqKdKkfKPOxdqclVf?=
 =?us-ascii?Q?AJf0s+S5GiMTbIzpXqu/GPjs5SGqQiM3Q8HjkMx38UeAVQWMSOzbSZG7fKOg?=
 =?us-ascii?Q?VM7kELiqKV+deh9aSum7rcL3d/YDCOWQxBKsCdnaz4uZbbHHxpBDhgmronQ6?=
 =?us-ascii?Q?j/44lqYKhj8X43imjC/P6TRrkd+DPMF3PTFOmgjPTejtRpXXOsOjC7m+qrXj?=
 =?us-ascii?Q?N8+PzivWtaisn2rH3jtQXzqnYIKu/X/MoKlzut6tmTC2nRsqbVBUuWrL7njS?=
 =?us-ascii?Q?lK02y2CiVuudr7Ym5G1dQ+53v/XUKTkHbjn8M+2v?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa705c61-0037-46d5-3ba0-08dad3b4a6e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 15:56:47.3296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PW4SS5wFPsQ/XEFjaKrHas46piBGqPkInBk7oI+5Gxg77j6wkTwsVFPn1wfgrfc6CGqb+VQD186KeC66xE93sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6109
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Won't be able to get to stats64 this cycle.  Looking to migrate to phyli=
nk
>> first.  This is a pretty old driver.
>>
>> Understand you don't know me - yet.
>
>It would be good if you first prepared a bug fix patch for the existing
>kernel stack memory leakage, and submit that to the net.git tree.
>The net.git is merged back into net-next.git every ~Thursday, and
>generally speaking, either you wait for bug fixes to land back into
>net-next before you submit new net-next material in the same areas,
>or the netdev and linux-next maintainers will have to resolve the merge
>conflict between trees manually. Not a huge deal, but it is kind of a
>nuisance for backports (to not be able to linearize a series of cherry
>picks) and all in all, it's best to organize your work such that you
>don't conflict with yourself.
>

I'm unaware of a kernel stack memory leak.  Can you point me to a thread?

As for splitting bug fix patches, ...
A comment was made against my patch and I looked to make things consistent
with the existing code.  I failed to see the distinction of addressing the
issue with the patch and addressing the same issue with existing code.
Thanks for explaining the reasoning behind why separating the patches
matters.  I'll try to keep that in mind for future submissions.

Regards,
Jerry.
