Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323436488F1
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 20:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLITZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 14:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLITZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 14:25:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40487A1981;
        Fri,  9 Dec 2022 11:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670613918; x=1702149918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z7t8hVvxs+9GQuAUASAOGqgWRN+kYGF9dy1rffDPZN4=;
  b=TEJgPLX/JbYXkk8hJjAfs72VI4RMijxozshMp41V54WypYDGWpgpCajj
   bK5bn4EYGThERYybDx2+ihq6LP8D+M3+O54rYzqPRVsJgaAoASst2kW/4
   FKr57/N80otYwCuaGyd6XKT+wCtlJvBy3tswC5lfqf6IRZ7S7eFFREg9Z
   effLgNIGnAEVGGN+CJJagPCw3nkuloBwNws/sKBUuqFgo7F3VbptShNyL
   V229nkXEjSOtOg1BSYTSGddmo7hKmcH8zo+80lbRvv4CWAj+JcxOVbWjy
   YrQYSeD8RMye9mYuDvShWEKz8UobT+Q41sVJ0GLTY1wXwkkBstC16hZgI
   w==;
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="192438723"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 12:25:17 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 12:25:17 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Fri, 9 Dec 2022 12:25:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LewtnuYmkxhOKNqPVR0LfIfE9Qm1TF+sZOHRRuE25hImShtDC/kWU/17qiXfcdri7N/3DaPqmZSf3JD6Wq/o6hpLoLQL99P7jNvslmKHjkbsgRSfMPs0sRl78DJl5OHw8y6SO+UnIVePw743ca6m5jYG+STyR3LYV3WJBhIvVlj3AUuZ+XXJ6X3g0eHAaEVTWKBEW0otI9XXCAYQl1vjHw2AewitQIQH2ZHEyqReyDv5/bzkSsDmBoSQ0f2BrGk53SMGiHqV8rmNJI3fXFnECKcKSZsdHBBvl0O0wjBO7e0fg+eozqBzsIHtQNPZ1qpDfg5YBEqaLGsFN2Xhg8xzMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Hb9H1mZb1dSoHxXtdl4Lzht+IZtoe5fHXo/Vbtxdzk=;
 b=VLEUb34GwED1xVQYTMp4Uiz3uSlpxNMMfditqjFyvB4hDE9arVqJiN84+76UygUXfx1tLO5w1tZ3OniSmr5YSYbGcQ5hHSr5YQDsGUbUoTQjRneYM1orLkPdejrkRhYcbHNs68JPBTUbHgMg2peeZQ0XykmbLyVReobIf0G2+oR4RwXDoYJXjp5LZvxoka/rkBtMIhiqBq/AeK6JAs8zKyt2ElL40e3LELc47wGVIxWqPGqXv8ZyZoh+vh8OSE6j2YUw9lVO4lhginCzCfkwzabXmlRaChGixlukTNuLxYzKxQEpYA3dk0M/fX+tQzwNukqiB7Zs977t+3Vdcq0K8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Hb9H1mZb1dSoHxXtdl4Lzht+IZtoe5fHXo/Vbtxdzk=;
 b=NvsnFKLncJchPEmHB12hn64kYBGJmslxZBd0mYfcbYWIHFU/i1YvT5r1l2a1o0i2gawvvigjDY4pIhdn/J6PulOi0G7fEPx8yiBX708ZujMsyDIw6UlvBZXVt5AJSC1fJVnXzFYDnJycCjOW3CUhWJvpOQ6d++5ZTERUyYOzS7E=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by SJ0PR11MB4926.namprd11.prod.outlook.com (2603:10b6:a03:2d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 19:25:15 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%11]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 19:25:15 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next v4 1/2] dsa: lan9303: Whitespace Only
Thread-Topic: [PATCH net-next v4 1/2] dsa: lan9303: Whitespace Only
Thread-Index: AQHZCpOgZla8D/uq20SFIW/S2Vlkp65kOv0AgAF+sCA=
Date:   Fri, 9 Dec 2022 19:25:15 +0000
Message-ID: <MWHPR11MB169375D09616C6EC3119B972EF1C9@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221207232828.7367-1-jerry.ray@microchip.com>
 <20221207232828.7367-2-jerry.ray@microchip.com>
 <20221208171112.eimyx4szcug5wr6u@skbuf>
In-Reply-To: <20221208171112.eimyx4szcug5wr6u@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|SJ0PR11MB4926:EE_
x-ms-office365-filtering-correlation-id: b4e3ce5a-bc34-4167-67d9-08dada1b1993
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mn6c2iZ6ieOlxNgjdKGrBYJbLkzOvpXXgvOXNLN+ypnZ7DQRcYjvlQjyRrsmCa3PxLBQTIBcn0iNO5EQ3q7dHAqiq432sOSgAT7868jmY2fAuBOmV5+9cZSkwrQ/voJs0pndtrH9mei+AeeFHVfUe3OczWC/A1XqVmZlocQQCdVs4B6v3DTr3LugOhbmRqx3Q93tkw3rpiJi6K43+XMIz8+7bw+g9jpJYV5V65veEMLtGn9IhcJGhhNRwAm9ey5gf7lzTORfJBu8qyDgNfMZUR2bImH7g4kwq4svRbhOU9F0KFLCoGBEMyPLdfhhMW5AfCHft5TGmpJGqtWv5F1T25B+FmEwmecawi9ir0Vw2q0cbAoLm69zWNHlPK3PjQpkMfwnqC6pPgwib3eLiWPKt7XR/MrdGD96FsyCI/78uVulq2bdnEQD3Ca+aCb+YTv4ggS1LTvf+hDeCQOy3n4D7Cy62yKJ+3NVuZGn1sef8vhY6Vs8V75eGdIeSLFTIXstvHMXIPn/rhmHNwXFVwjqya02Z/WYQCBeHKVXdXlQ0L5f/g/Hc8JcCBabFZz6o19APOITFiarfw8Pm8qJ/ZFT58h8+Koe9y6hKLP0/mPW2WK+WxPbfqGj410ib6VXCIQMMihD60Co2r3u7qeAgaVXs/EIjw9lZHIsArBXnJ4uk51tTK5HFf9mYdXITTrEOuqIGA8ks17XLNGKL+TiyoXwtA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(86362001)(2906002)(71200400001)(186003)(38070700005)(6506007)(9686003)(4744005)(7416002)(7696005)(5660300002)(38100700002)(122000001)(52536014)(26005)(8936002)(478600001)(33656002)(41300700001)(316002)(83380400001)(76116006)(66946007)(66476007)(66446008)(64756008)(4326008)(66556008)(54906003)(55016003)(6916009)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oT6G3zJluPZta57Ly78x4tI7C8j+ke5esO8dca8UXJUAXFcdjnOqTABt7etN?=
 =?us-ascii?Q?2COPDr4U6VbSdDf9tsI5jhfk4+KLUt53d3qNoZz0+0xCMFbUvgkIo0J3ddtA?=
 =?us-ascii?Q?6OSC8KIR/wqpN3RD4713w3c1zoNwAlaIRvpaWioZXMeUMQYsd8oNkExtt+eW?=
 =?us-ascii?Q?B3feuVbjbwVjyBXuyFCj9swd6K64y7ijoFVvZf7PwzKxULy63St6pw0+IulH?=
 =?us-ascii?Q?A2TdIb2lHAyvYss3Ut5fbqwRiERxmK78vj40YW+w4ppSdf3DOv815qx+XTKv?=
 =?us-ascii?Q?jZGF8Wlr+TlKoAv5urHTp8sS4toHbPxRh1yCiZIHEOMDIkt+MrRW+UhIAHk/?=
 =?us-ascii?Q?vEamssctdRpxLaggU4sjYuQASd5SRQTOVe6ima6VRpxTm9ao2PApHIc9Utiz?=
 =?us-ascii?Q?v4gVelig1W+heW1u5IUUmV/Q/jCNm+GxkqtbFM26nJ+8SIMpOvqTMvvd+YpN?=
 =?us-ascii?Q?VXZRglXTJgflP1h//7a1jHjonW75s9frmk6Si8o/KzQE6ciMedpvRDkKbxdp?=
 =?us-ascii?Q?YCbt0YwbP/Ljoj5Q0bpuO/1+DzGATCqgB38y1a5vqBF+APWlF1C8ypoqDR0F?=
 =?us-ascii?Q?ZCR+oVGFex6bigQd9DlzCOS/1EvZjLI3uupOTw8/aYPyYgxrsWWACDy1w5HV?=
 =?us-ascii?Q?1hsHYX5Wa/PawokeQKZ9DrUnWopd9a3W/oEcAJsW1fc7aE3KQYt9Uf7P5PP9?=
 =?us-ascii?Q?l2li4F83t9Z9sWKFbhfw31xKxNQZXDMO95ppNkk0R43mb1wDbjayJpa1lQQ5?=
 =?us-ascii?Q?duq4niWTXV+OdMGID3P63MM5LYSgAjxPIS6d8jVTNF2/igK5RGufwonEUtpf?=
 =?us-ascii?Q?6qcyuYU91T54aa0JLwMyEyHL+VlnjSE5IjmuSQ0mFV/2Nqt2T58ZBRhGPv3n?=
 =?us-ascii?Q?AB/rewE8/iA5Lu3ZUwotqE4y15ug/sPvk+yCXUwX3lRVs6IjV4eBnTDzFOsI?=
 =?us-ascii?Q?GpRBWsY+rHgjgLDgzU2EuIAcCjBaOug2hKHx1D2TrUj7mj0fGhVbJdhB6s/R?=
 =?us-ascii?Q?ZQOOEObcOuzuYVKUZYMbxCI+5VcfHCrod1cVaFVnJkKvzdzywqe0PL+UevZZ?=
 =?us-ascii?Q?GH/oOLECRtAXzB2ygGYldg5uVgKF11N4ElsRpdccdKkSwfgPOYXxeg2eabXZ?=
 =?us-ascii?Q?zuiAapBK65a0kN5thlhFpk8AvqVqhH4uVlde47G6haQxcGUunwuxiYWie8RF?=
 =?us-ascii?Q?ZK/ksiWsmwCEFitof/BOesD0fd7R7QA9c8CBdvBWbHKlAkra7y0SH84m75n2?=
 =?us-ascii?Q?/M94Lov6FDVHWDH8kL5Auw6+PaUQVhVMa29yHduZ6K7yvQd/UmXtBRlc+GH7?=
 =?us-ascii?Q?nINNg/6mB4F5R37Nac9gc5+E/Y32VJhrimy0jty5X+rfg9kP5dsi1Aqu8QY1?=
 =?us-ascii?Q?/hZgyqX6KTB55x3W0YKIkON5MxRuxZDGdHlLR/fzVQJccNdgFrD0LlbJkXgH?=
 =?us-ascii?Q?c3eNdh9bvshzOSaJWiiBWPJnPR+wpbv8RPsAqlid412/3hrtNlTVzLRUMd/r?=
 =?us-ascii?Q?bVPMRFm1TVYYClBrqZy6CDCJS31DaihH+FGXxFyacXNGyyP/DgC95cKX5NvL?=
 =?us-ascii?Q?63fQhK5R2OmpTnskvV4LFHFVabg+IzBMFjo9JrWZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e3ce5a-bc34-4167-67d9-08dada1b1993
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 19:25:15.3784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JJcmWlU9X5RGyVvS/PlRajEuTWSfDX5QjHbdWOov0HBdyz60DrhtffP4JQI8H5Rb8GFEyu18vC8q9RMOmFV1kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4926
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Please name the commit message something more specific than "Whitespace O=
nly",
> that is likely to not be confused with some other patch. A "Whitespace On=
ly"
> patch can take place anywhere in this file. Like "align dsa_switch_ops me=
mbers".
>=20
> Do you use a text editor which highlights tabs? The members above this
> line are aligned with tabs, the ones below with spaces. Still not
> exactly what I'd call "consistent".
>=20

Hi Vladimir,

Thank you for your comments.  I will rename the patch to be more explicit a=
nd
will address the tabs-spaces issue you pointed out.

I'll look for a better Linux-based text editor this weekend.  Do you have a
recommendation?

Regards,
Jerry.
