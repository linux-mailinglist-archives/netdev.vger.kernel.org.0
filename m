Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2296863DCC8
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiK3SNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiK3SNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:13:01 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA0C1AF17;
        Wed, 30 Nov 2022 10:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669831979; x=1701367979;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TVHzia00OKIpvouQ0QyIYlUD/mCnkIt8tWHN/gK8c9U=;
  b=Wh9paAdqh+/nMrB66v7GxHneOEQ86Unzesz2YSZYhva/h17R+J8qilaV
   nS3XiMATB5qXwciK4+xkPCNEamViu5eUlOad7GDth7f4g5MtYyWzAUG6k
   dPkoN2ZAIH2j7Bg+/XEzLLrJTTC+QsjcYV/LckngZJCvKqPo950FY/P/H
   vhvPcJSGgrM2E9Zz8AFqUASy2GNsGtCid1s4lyQpF/ffa21wB69cQ6Juq
   y/3sA1hlcXHneKh5EaM/gemcNSNjetHLPve+GCuVGkgSsEKpHfEbu0KRU
   FthR4I6o9dcUQYKUPfc+iPIqxIjJq3cnyvS7lF8fTDPQO7ASXOaaHNbVY
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="191187677"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 11:12:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 11:12:56 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 11:12:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aj7z2ms/mwb04S0vqS7vc9PUlPL/C+ZvLFHj9030rNq2Qyw2N+qyAFCCwE/9rL8KVlss1tqE7GYbL7cvPjZnnFdiSTHwBAAHcSyHjaQ6m0uMvDaTqD/FKr4Lb2qedF3oVRsvR+30hamp19MWVdJrjpM/Mk/aRyCwDxManmEJGvXj1KH4XJhy0+GB7Gsr4ieW2DnbGojQ914HoDD6MqGAcnj9umqq+r913SyKEQNltH2SnNKPBZBQ77Zv95bcJDVW7G8lFC71CO922VH3pm/PM/cIBv7nPaceuNrMYVWw/9NvXy3NJVGerDRN/rh/qocsoFjwOXoWU0S7jBYyvgkwUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SgN5rhofwXfG03Xpwx6/dLOGopZSbAJLEaT+XiOMltM=;
 b=DB5dEZN6kOSDiYkJl/zsNZm6nbwmtA+HFGFzmvHYIymWEZGPzWBGRC/xKnWY2tnwkx0zvLD8wmgIXyFxOqTGWGm0ym3mBvyECttk8Lt8Y2YMIfqyRweko6Dbp5uZSkqccb3FMUoboeAkt3+cwaWTyKmEsH8pmtXba/j6pCtnxPy9+bOmYEDWSg0/eUuKWB9Cxy97ZZ8lOZD7eVfax1GEZINK62AENNnci/CjT+1rcArghREUeU/OE0DMjICZSHIR2RNA/dYpTqS/kWEI8B11e4VWQOVDCkTo/LiWTn7r9Y1qwtfRpWRc4Y9s7WOUVujNmv02H0AaeJrmIohfbr5hFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SgN5rhofwXfG03Xpwx6/dLOGopZSbAJLEaT+XiOMltM=;
 b=bF0hW5z8Hzl8veuvE8HfDaIH4xvAzB8qPjdESBFzZjFWGKfDFX5PiRP5X1njRjC7tBkNBGRHt558asOVKsL9MPjNKr06aaMCJ5ctJXGySckyiEnFPKNxp1Iwk7Yfk87wicXN4e6HPjFLIklerwx4xC/3BYdhOZBbg46Z7dKAGb4=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by DM4PR11MB6382.namprd11.prod.outlook.com (2603:10b6:8:be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 18:12:54 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%10]) with mapi id 15.20.5857.023; Wed, 30 Nov
 2022 18:12:54 +0000
From:   <Jerry.Ray@microchip.com>
To:     <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Thread-Topic: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Thread-Index: AQHZA2vPxK4eDIuP5kOkg3W32g1dkK5U+YSAgAKmf0CAABFlAIAAFinA
Date:   Wed, 30 Nov 2022 18:12:54 +0000
Message-ID: <MWHPR11MB1693909B5E06A7791F0FD079EF159@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221128205521.32116-1-jerry.ray@microchip.com>
        <20221128152145.486c6e4b@kernel.org>
        <MWHPR11MB1693E002721F0696949C5DCBEF159@MWHPR11MB1693.namprd11.prod.outlook.com>
 <20221130085226.16c1ffc3@kernel.org>
In-Reply-To: <20221130085226.16c1ffc3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|DM4PR11MB6382:EE_
x-ms-office365-filtering-correlation-id: e442a461-4f5b-44ff-2304-08dad2fe8078
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pldCIFXjURf986/HrETImGqIZpTvsnPrj8eVMhrynQLcYwgdYOl/bt4Nvk2ikcUK/jJzmCIC1InlydAVjJ7ljZfqIolMPKxPID1/QhUct7DlkVwoieKk3qWtHhHSgirk4uVoamKzfL2wfLjUTLrvSAgrcT25jWsuDPMgcfmgHrikaaCl5JTvztNgz1n1X4p7nTtHU9Hz3Lgi63CMYutAtpaS6NWDuwr2+ULzSoEtLEXtrU7FxTxJsv6VYJAoJ0qTnxE1jrPOBELd+1bq/J9yS6ZiheIN/K6IPw5oCoW69/4jMhXMMFny7mC+4a8nYXW+XHauopf8Yg3vM6nLpM9wzOxknmrQbFqwK/Go7uAN5Rxc7scMmTt6XVjUlMzbnQFgFmCD2VcDqophsccrhsP+ixzwm3Oqlr6k4wOOhg703vA1Ta+N/LGS7P7mtWROYsgNpc5B7q7niC71cCfrCENWUcDpUX/IU2mFvuWrd3DrPHjG6qrx7MCgqdtjxylBFvU4hR/M9K0EGAXr1VCP7weqr5zLQNZicXZSDtHRMNnxDg91WLWS9AICTJe0xHMPBeZAayJAExQyChNMENlgIOZVfN6K7ZRyVD6CaeM46cSu6n8gAwVWXVFPqKyyrQjtQMtCp8U30aoM40cVnsoSDeTHQOaGm3EInBkzGWMZ5jnTc4q1Hra0QNahFE7L/xhxL+XlCM9gP6GMIPLA5y2TNs7Png==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199015)(38070700005)(55016003)(33656002)(86362001)(54906003)(316002)(6916009)(76116006)(5660300002)(41300700001)(4744005)(71200400001)(8936002)(66476007)(66556008)(4326008)(66946007)(52536014)(8676002)(2906002)(478600001)(66446008)(64756008)(83380400001)(122000001)(7696005)(9686003)(26005)(6506007)(38100700002)(186003)(66899015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?llgqfZTp65sow6o4xNeh6gOBeq3iqDGmHI/5e6hk6VAA+1sJP4gHwJjhinPV?=
 =?us-ascii?Q?IvyvYyfH7m8jOWz8RBt0ZTqOxG9FGrwfWmuJ329hjDEE1VWBCQY1wVFNdjX2?=
 =?us-ascii?Q?jMyLQwMzxFgW70/6V0l0kYZAY2Xswk6DIQQQtgqiVj4olTA485sPEplAyBO3?=
 =?us-ascii?Q?IFNljLNzm/qwDOOmLMcQt9UKiC553D2yIlGakU1861JZHm9ugFwd++u3AVP/?=
 =?us-ascii?Q?axjEWtR9UiexjguO/LP46Sb9yn57TelG3O5nRCYXv0vAo4AkX5Ow12HWRDK2?=
 =?us-ascii?Q?9g+b/YchJsWzkHzUIJLgq/oJnYKRWPJRDbc6EXpt0/EWRCwkuEv5n+T846uC?=
 =?us-ascii?Q?NL2510hFg44qtH/aHYmgqHy9QJWLnz6bE5iHaTVWY+RLEBA6g3L1vPzroZkg?=
 =?us-ascii?Q?GLWH/928KVWbr1kszcJEAdIYWnxFP2LS3L9vPiac95tyPDS8vOuMp0wqXtbQ?=
 =?us-ascii?Q?yrzad5zHZJe7uCupB0c9LFCs2wHPaGPdS633/3ZxhTICcWAcZBqoh0U10SWB?=
 =?us-ascii?Q?hlo4vCwdGHWdyBr1BwhhJaUVQPx1Rn/IsojD3UUFFQOWvsAz+A5DlTwr2gjs?=
 =?us-ascii?Q?KGrXLvslljxukxHPUIXSy9NNE8O7JXMPWSfjTwON75/vCNJw8GnO3eUjamLM?=
 =?us-ascii?Q?auAQ3sDcQl37XFC+gI2Xtr2jtqTrrdnV0i3WG1ar6+/HAJEmJ7bMvVY9e7Qg?=
 =?us-ascii?Q?wC/ZupQtHnU5wZ76qhs5/CWjACe0oF2xGMzfX4SwXu6NNmlEFCbUYSr5M4tm?=
 =?us-ascii?Q?l4/GQYz21nTFBGPh5kzklu4XxTXIhVSJaelrECK3S6gdYwua0Rv/rh644gvV?=
 =?us-ascii?Q?/c/QUXe+bNATbTIkZwlYArcbMymwthC1SIro+FRZ70o5ijQLwk+fwc1iHZbs?=
 =?us-ascii?Q?9cLapi+kYujq0d0YAeYpx/TVrkRFlYko3OhFoIJ6IM3mPd8giokECkfeCTq2?=
 =?us-ascii?Q?TZzKzb+Ym1jSublI3SH/qq29F7Tn1awwqmXlY+mxxP9NSLLSSiqO1Em5eV82?=
 =?us-ascii?Q?DpfY4c3/Os8LTuISlhioIG3/33llvXk13mybtQHW05QDw+oIbnyjHFsRUNX0?=
 =?us-ascii?Q?BrISjeZhEEJjhlhSc00GJB2df2llg2rFSe/CYKVK+wjh2nvwdzoctF8rD9Ao?=
 =?us-ascii?Q?Q/vQ2VA5K53Bik66wunSAmhk98YKvWITajXQwI+pj947DVpFnjT8DY7QryJe?=
 =?us-ascii?Q?48oVCurf6HP9JiS+2iizjG22mBG/B2KCbPfNdl2SrbMi4Ph+vPksdD+c0pVJ?=
 =?us-ascii?Q?MtalGBgTL2YlJOUgSte77eHMBlVnUVUQcfsF7zUXgAi6eIgvyGG8M93fBSw8?=
 =?us-ascii?Q?gJ/3HYloVW83AzqJl8FBk4jB1TbUx7jBEdaf0/XsLUD1GrXGzoj8PfHbqmvc?=
 =?us-ascii?Q?yFMDFrL1jUUbdx5PpP2bYHMLDWaOYv/aOwFrTcEDwaS7+H8IpWHO3qDkZhs/?=
 =?us-ascii?Q?NdNWH2JLufQ4WXm9Vymx133HZC5swTksWoP2oSh5BEuf7h/zPe1j69M6ByP9?=
 =?us-ascii?Q?Gz4Tgbaoq04WVU6VDXTHvCQ1FUbCydtL/ciwWjigC8WiUQ9aeXJOUQfYAHeC?=
 =?us-ascii?Q?9uxdC0f5uJEIj39u2PKZUfLPuPJI9ptZ73RcNB+1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e442a461-4f5b-44ff-2304-08dad2fe8078
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 18:12:54.4917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8I6Pq+32qpTdkmABTyte6ohIye8+5i9YUSfoEygokBmOa7dsVZAfDNPDZr8SOhYvN+9XF5bHYkbSvorttCg0tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6382
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> Why not add them there as well?
>>>
>>> Are these drops accounted for in any drop / error statistics within
>>> rtnl_link_stats?
>>>
>>> It's okay to provide implementation specific breakdown via ethtool -S
>>> but user must be able to notice that there are some drops / errors in
>>> the system by looking at standard stats.
>>
>> The idea here is to provide the statistics as documented in the part
>> datasheet.  In the future, I'll be looking to add support for the stats6=
4
>> API and will deal with appropriately sorting the available hardware stat=
s
>> into the rtnl_link_stats buckets.
>
>Upstream we care about providing reasonably uniform experience across
>drivers and vendors. Because I don't know you and therefore don't trust
>you to follow up you must do the standard thing in the same patch set,
>pretty please.
>

Won't be able to get to stats64 this cycle.  Looking to migrate to phylink
first.  This is a pretty old driver.

Understand you don't know me - yet. =20

Regards,
Jerry.
