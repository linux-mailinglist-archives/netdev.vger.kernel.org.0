Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF2D63F583
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiLAQmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiLAQmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:42:15 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E748E5BB;
        Thu,  1 Dec 2022 08:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669912934; x=1701448934;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2zEe5u9puni9qu1os2KnSLqy5U5aW0pMnBjFrZpbnJc=;
  b=Tdd1QjKfmcoFhtTm/DTcImumtovHcHDH/tJAyXDhFkHxl4FjT4oVfH2f
   nfgeJbO015OuqAYSyIoHCVlgzgALUtEywo98/guaAZ66GchiT8b5fU3J7
   XryFT34JL7VnH2XljX849er4P9GOGzyRXLsUHNr8A/iznQvKJTDH7S9Sg
   WeFv0rVOiAaLdT91J6YnIWZH9pSgcrWFcErX04NStuB/WarFgt5qH8FCJ
   UngS+JcpLHF25D676dQ7JcY5XUjQsrzDsmKDTAPGnnwxaVhcb4Ic72mUl
   zeun/jDlu6XwNzmja5nhAEuGvctvq7VymdSQi5gHLM+5vRGHYjP5deoDA
   g==;
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="191328864"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2022 09:42:12 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Dec 2022 09:42:12 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 1 Dec 2022 09:42:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1ErI/oRGfcLneVf6knAkGb0dmev/0lEuPL6b5kgg/vgdTMzfin4AdP29E2mEqsV5+Ktk30RzldN+knHx+l1fSdSP+m/BtQgGDJR3RFzCGT6/qXljRQHi8eK25DxogYdedjLHxerS7R/GvLLJIuDDwah+lAKZR7cgrBe+16pAWYHBBnI/SKgeSsWl3ImbiiFTYkrdWpGbiiEGudeAz7+Ww1T6J11Z32v8KgyqO4QJW4RLLE86nclCI4B29K6UevjhRS2HR4ayCLRnVOXJ0PbbvLR2BzbdbHADPptnheH0uf9+3KNCFW3jO2tD12K8gdHgpddJ9t6t3AunsyMBre2Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4g4BIyXljXfnfH6ed+kYEY5j04jD+dfa/DIN+ZVLto=;
 b=mjMmDHGf0kD2uwI2Dmao8RkhZZ4hIlp/mE/s6J6YW3Ug+6xwEPxJUiGfU0dosQsIKmcIrPJ0VPtGhhlvzO9at5DWuJjG5TOnv7AJccGLMztBDUq8hFEH0sPPM/1p5vTDCj16YwzflKSH2XjNZRCc5U5/NKiKXgsk0W1PgXQovNqPIt0YIXqZoIPemnMPE37rgBiQ4wj0WCEIeRv5UuELxMmmID6uQ0431q8UwtQyT2BoZ8eHPiMP9sz6zBl+0nKqupug0cNXbUG1BJjFwzqMX+XjlT36Ky/QzvMvDySKGEgD2ZL0Dfyb2jQCDoeCSotcshBaUYexPXuauqEfrt1ChA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4g4BIyXljXfnfH6ed+kYEY5j04jD+dfa/DIN+ZVLto=;
 b=CtiN42QDWPKgpJ/5FLu7aNArYw8PE28eEqF2ay1JCsseCnqNzu3+NZRo6kJZV2LqQ+6Mbbeuosd5tRLuCgIlUGnQAtPG+wpZM66DSc3KpEqMaJNEuHe9zEVm0gck1E3LwmKbc6WwCobAOrLK5Yk3nXDxKOpp0YLS8eXnPGwFl7w=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by IA1PR11MB6290.namprd11.prod.outlook.com (2603:10b6:208:3e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 16:42:11 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%11]) with mapi id 15.20.5880.008; Thu, 1 Dec 2022
 16:42:10 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v4] dsa: lan9303: Add 3 ethtool stats
Thread-Topic: [PATCH net-next v4] dsa: lan9303: Add 3 ethtool stats
Thread-Index: AQHZBPd7JcFTQQToA0qvxVT5rs7YJ65X8puAgAFEzcA=
Date:   Thu, 1 Dec 2022 16:42:10 +0000
Message-ID: <MWHPR11MB1693DA619CAC5AA135B47424EF149@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221130200804.21778-1-jerry.ray@microchip.com>
 <20221130205651.4kgh7dpqp72ywbuq@skbuf>
In-Reply-To: <20221130205651.4kgh7dpqp72ywbuq@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|IA1PR11MB6290:EE_
x-ms-office365-filtering-correlation-id: dd8a2b4c-5065-410c-7fd4-08dad3bafe0a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5AtlKo3zfLCPHszeGntrrDAVoYUdYhKBdkBDMuo7W0lqeesn/1Jwq7oi/Ib6gcp7KGXFjW8nxGjjfBkd994tfiiUAKnTmwmE5aPkAk6bIDd+2gAk+f5mVKi6zzcqwRYyGF0bhnK4JgkMbSd0+JIlI8A+cuTJziEJWQURvYxH7uOAmV6rkUl+vhqEEe4PLmX81aOYf7QWGGHim1QFZwUk4K2LVbjlumADw3KltDEwfZU+En6xZeAwIMZOxXVXXacA8s4+//ukwdyR4nz6Cs1cEPhpJOD7GHkbVAYvBUY26c0sfDlyeKNC5t7FJWQTCWehkw1+vDHk1/cz+nmG1Y6OF8bZJVxTOeTyHTKBH3dr0HjXPdWh4MAg3miv/Xfj6zxHjQqaFf9zzpvsV3YOH/uJSdG59nI9FxB8MLh4Td/EYNVyzyu/Vrgo96cZeBPpJc9tR7ju71wLIFE6LqiZJcRbLe131BN7tH+QopZfxZw8ZMWYxBH2Saf6Q8QKV/2S68dM+CLZNUv97F62XMEEbCF6IIPnEqXFIWWo59MeR59xDTzxZaacsbuo/lpHOluP/4YHqyUf0OT2kBmORVHglRdQHeGjfb+74R0E+oZ9akJHZJAH/BP+YZFB3wB9l/4F3N+VH5LgXTtnPjDo7jQwkeo/Dyg7TmjFRKtSLUOBV9ZbT/NPvyS0wig4g0rgDC09aqNiGV0aEnnQyRMJ1i/Np9U+Qw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199015)(55016003)(38070700005)(86362001)(33656002)(71200400001)(6506007)(7696005)(9686003)(26005)(478600001)(5660300002)(52536014)(41300700001)(8936002)(54906003)(4326008)(2906002)(6916009)(316002)(8676002)(66946007)(64756008)(66446008)(76116006)(66556008)(66476007)(38100700002)(122000001)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lE/QZ2MxgdEgmRJw41t8nngK+jnYmRaz9bssCKhZ6ockxBvUhUNnVuS8nQFN?=
 =?us-ascii?Q?TtVDFEZCUD/mo9e9ubV6b3ZheZi3PY+p/Qq7IKp9/bWazIVyz1dKpF3I4JCL?=
 =?us-ascii?Q?YvYtyTplz16kucWtbwrXdiaeZV0eYpZdkA4/oLweBVCFhoy5CaMRA3/UHcEs?=
 =?us-ascii?Q?pG+m9vD+3rVwmeN3dESpvjn0Lq56f2UxB8kaYGU/qauT3jKEsFSNzY41vw8+?=
 =?us-ascii?Q?Ra5TYCHHyhCQ3zUt3O1Ght9zajDykPnDXCmyFy3cyUz7Rgp1tCArWSD1BzVI?=
 =?us-ascii?Q?SSDm9Rky/eTvYWDOXowpSKWzgpR8Nc8Z292e1GkUVk5Fq9ODQ6TRY7uP/kMK?=
 =?us-ascii?Q?tg0YT/v3Cd6ntXyWj1GHYW0f1745ObgeARC57M4wtdp8JU2pQSVafEcqStfA?=
 =?us-ascii?Q?/BfM4zHXms7IYlJejOyB+CS52+FFryqEV9GFIGWNT2vFfwVspbBdJJ16pF0t?=
 =?us-ascii?Q?aDcD9d3uO40S+yhlduQz7MDm1LigWJyGDeQFYYPCD+sSUs58rE2pt0nb5hnA?=
 =?us-ascii?Q?bTnYjsI4KpHZHmTR/Ugf4a4iI9K0fNrOoQKsGBvYI3xhMZmfx0j4Z4gplG4O?=
 =?us-ascii?Q?AByHpNdSv9SqnBG+2zruBLAsnuYrt8mlxev+a3/m5adC/zfgl+coX12tCEEE?=
 =?us-ascii?Q?VvqLacGDhiunL0dEYFE8wjiZbleRvqXsMy8Oxb9FNM+aDGMwS3HV37w8XJKR?=
 =?us-ascii?Q?aTz054iGQ6c4hgauY0RfD+P5PXjEVS3AnF8ySAZlhGdioqtNahVm7AH3uKEo?=
 =?us-ascii?Q?bSBkqRXuKEZfU+POrnjElXx4SAOWXFXjJ9qRst8duqeBVjbGPG3vVWAeoba0?=
 =?us-ascii?Q?mT3EI1waEXaX9JMEkB5snfozF1+rpzeTSCKMPs+3mEpCOvxwaeRX8kEyemV9?=
 =?us-ascii?Q?w639p+C3joll2evvx9l8tg8kHouUk/J0dFsOalyj+c8A9nniiKZJARUMq14u?=
 =?us-ascii?Q?Wdx3gFb+nKeRyjaSdPyb9FON8Hn4Us8BkhyPIDbCABe5Ns43GlR02qVl4IRq?=
 =?us-ascii?Q?owI+BsmdMPtVFdLrp7awQLFCFvChniI38OdX73/Qtb2kMFd3/ZEGFPLBsLsR?=
 =?us-ascii?Q?QUQ22FSXjk4aHqv0CNbqOjF84RDMUwVUcsisQUJ08hdsX0eM8g/qDmzNNCIG?=
 =?us-ascii?Q?Uaygf1Jmm6CxpNkfcHD5Wbnh3fjAvmhkyUuLlpHYIkzQscgvpx4PgA/Fx5di?=
 =?us-ascii?Q?jf/lmPIScOtDY8l4X4iQHoiIYyp4q+gbarOfERUm1x3lwHaD0S4khWkpYwXz?=
 =?us-ascii?Q?79yHZk3hgsO+pKmwSLGQzXfLHtwn7c/1QhDJ9H8wVTESHdqTiPJSLqEVqzUC?=
 =?us-ascii?Q?aGwy8WId/f50S2NvXYSoKv9b5teSoBWSAhZWurWl4k/Ywg4iG1Qvo0IOj39M?=
 =?us-ascii?Q?CE2suiOEp6PSOnT6SDXvMlQXvyRKu2AuuV8yYjtbhXfCLlYtsDaRP6ejCnuw?=
 =?us-ascii?Q?+bsMCAHzZ47ArS15CeswN2CFJC3SwKoI5i+gaZsWNpReeJeRRaHTlPW/uJ2s?=
 =?us-ascii?Q?XRaWftOOCpJ5Dn+BqdlueRUXWvDcGWt6LrQ87p1icbxbTqPBlrXU3ndQ7flc?=
 =?us-ascii?Q?CXJDe215WuU800Vfsa3npur/wvHBLgRKyfTlqx+0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd8a2b4c-5065-410c-7fd4-08dad3bafe0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 16:42:10.5200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 35OYP+CKuR+q9BJB38B+Y+h4VNn7Rb2o2KWiHLn327cHSdk8654wAYg4BfwHzhH/AHSkl+mBJcWq8Z89uySt3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6290
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>  static void lan9303_get_ethtool_stats(struct dsa_switch *ds, int port,
>>                                     uint64_t *data)
>>  {
>>       struct lan9303 *chip =3D ds->priv;
>>       unsigned int u;
>>
>>       for (u =3D 0; u < ARRAY_SIZE(lan9303_mib); u++) {
>>               u32 reg;
>>               int ret;
>>
>>               ret =3D lan9303_read_switch_port(
>>                       chip, port, lan9303_mib[u].offset, &reg);
>>
>> -             if (ret)
>> +             if (ret) {
>>                       dev_warn(chip->dev, "Reading status port %d reg %u=
 failed\n",
>>                                port, lan9303_mib[u].offset);
>> +                     reg =3D 0;
>> +             }
>
>This part of the change still is unrelated and affects existing code.
>Bug fixes to existing code are submitted as separate patches. In some
>kernel trees, they are at the very least tagged with a Fixes: tag and
>put before other development work. In netdev, they are sent to a different
>git tree (net.git) which eventually lands in a different set of branches
>than net-next.git. You need to not mix bug fixes with development code.
>Andrew also suggested that you separate each logical change into a
>separate patch.
>
>This, plus the fact that Jakub asked you to also provide standardized
>counters, not just free-form ones, which you found it ok to disregard.
>
>I hope that only a misunderstanding is involved, because if it isn't,
>then Jakub will know you, alright, but as the person who disregards
>review feedback and expects that it'll just disappear. I think Jakub
>has pretty solid grounds to not expect that you'll come back with what
>has been requested.
>

I was hoping to get at least this change upstreamed this cycle and address
the standardized counters down the road.  get_stats64 will require PHYLINK.
I replied as such and was hoping to get the benefit of the doubt.
I have a patch set under internal review for migrating to phylink and addin=
g
support for the port_max_mtu api.

I have been asked to, and have plans for, adding VLAN support and then addi=
ng
Hardware Timestamping support for the LAN9354 variant.  I was hoping to sho=
w
some progress with this patchset, but if I need to pull it and pick it up
later then I'll shuffle things around. I wasn't disregarding Jakub's reques=
t
and apologize if was viewed that way. I'm simply trying to generate a corre=
ct
patchset on something relatively simple before moving on to more complicate=
d
patchsets.

>Sorry, this patch has a NACK from me at least until you come back with
>some clarifications, and split the change.
>
>>               data[u] =3D reg;
>>       }

My plan is to correct the issues pointed out in this patchset, but not exte=
nd
it to cover standardized counters. get_stats64 is a separate beast requirin=
g
a background thread to keep the stats stored in the driver accumulated and
up to date.  The current patch simply reads a few more registers from the
hardware when asked.

Regards,
Jerry.
