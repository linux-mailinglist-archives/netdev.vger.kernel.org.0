Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B48D642FC9
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbiLESUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiLESU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:20:29 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2106.outbound.protection.outlook.com [40.107.94.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B243C101F9;
        Mon,  5 Dec 2022 10:20:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEFsgq6tmK0T0eiBLQ90jEJ8bxcJbL39ubMUWr6xrAGQdW/82copW/3CJJYt4BQ9RWWkHo+rIfXkm+qvJQFJW4oMk0JWICuE7HbgWii7toXbE01D8UiHHJ6KEgOCBRfxv2c/DeI4pyPl/vQbC+sn6xoRLQ3riBohOSuJpfWUgwIEQ6utN7H/Md8X43Xe19evH3zgJ87zrFYlNGAyvtgtaZ1F52uNT25jx0HxdvtTzpY8/Rp+8wyqKBMaEXGqAPz0s9CF2uTBSAO9/gPPOpKX7gxpAky6ZhLYHjl9f2xCLdKBJR0aOExWilBn6kc+NF78wtPOrwnbFXRZw8Zo+RJFdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hldi0WhjMDFqUptkLBGQAT6YHVCB8XY20ceQA80lwGc=;
 b=d6qovIJIJ3BO/drTquFKa+GXm5t7GQPhgiXHqLA3KHnXNQAJG5vyfM7VRsMNp5Lp7k7kR58XXHdf+Djt8i6gsNSW+PoZbTkaFAtmLeaux1Ypc5Kuacl0mzMhtg701SfOD03DkdELeIx/Or53i+DeGNgEGrtv+m/4rt+aiLyFnfC4LH8VAleY2xfu5NYbchd3X8NrOYUOPyyIX4v0xmXbn25dmR4+wa7UkUK8wePdOmQlDOShhltsbAYtyodp1lrdIHn8S7RAQUkVzb4Uaqx0/6vH5qoTioJ3cno7F9A2swbzCvfnz5+qTtlJqC9r2NK1Fqwyb61yF6Ii14r8EeUehg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hldi0WhjMDFqUptkLBGQAT6YHVCB8XY20ceQA80lwGc=;
 b=wUna5HQjq/t8m6ZQ24rTHRdTLHiQH/UC8ZV3cDhhpnNR6Njzdl9LdroMZryok8Q1WHtp9l8p9V7VENHnpDE1xMYoiVRjleXFmEXr2hdUSJf+Oh3Z9NeM6YpKzHKSRHJlzsdmgdEJpBGDAkUkyTziLTMP3eMIg0292vuqC9x2KyY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4947.namprd10.prod.outlook.com
 (2603:10b6:208:326::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 18:20:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 18:20:22 +0000
Date:   Mon, 5 Dec 2022 18:20:15 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 net-next 3/9] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <Y46m3/oqtoqJWFlv@COLIN-DESKTOP1.localdomain>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-4-colin.foster@in-advantage.com>
 <bfc6810b-3c21-201b-3c4f-a0def3928597@arinc9.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bfc6810b-3c21-201b-3c4f-a0def3928597@arinc9.com>
X-ClientProxiedBy: MW4PR04CA0120.namprd04.prod.outlook.com
 (2603:10b6:303:83::35) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB4947:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a679a08-9a26-4a59-cd1a-08dad6ed5f8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vz3unIWbLezmUkBKR3MRyr+9r1V2cOnwaaAEIWgH2DCrw92yy3sfC3eZhAEzNwFC2wzoC0/871Eh/OMsWMBu77nYF/zPRxnBnRlOJC5R8TDYTQd7d94i+S9o7SYzGIyJ5Welu4qqUALMzs9++eGzhvoeoWZ6KAop+gExCgZ6lpcaBeHRjBETnawrGQHDsSm82LefY9Rny3DnGKhS0QfvZb72aK/eR6cQ5FPFlphPyW9dMiSG4GzBrkgNgi/cnzDQPwfABiAmTo/N3Mm8PTRcBHh502c1i3O4WCMXH1hXL7XxKJzZ7PmMQjBIq+geZ0wWUuaWYnyu+3NZtmzfRDgfknKaJsp99Ygvql9O8ALENwhxCaDgd/1W09iPUXRPQTJCL+zX9ml8d9pu+aE2Z0fubmafj3XAdT4dQgZ8HINanDtFRUlyxCstlIJWem5petUjpbfakKxPvDSS9MYif+izoCqnMJlndKv8YMaUHFMNz3QVbwvo1Wog9DGXVmR1d9ZCCmtOu5b8r3gupOkzLh7H6MEU1/wsK8eBzvFuvtFUoWHg47OEq26gHdDbrJJnFI+bPof9/VOf/+yWNPdcj86Sg6PKI5XLYPI2ea9pXGMr+CeooClFZTg/9a4CWusrFfNtBR/rk/L8SVaVXuLW6wlYEZXhF6C9za2rGJj+Dx5i87w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39830400003)(396003)(366004)(376002)(451199015)(83380400001)(86362001)(38100700002)(7416002)(7406005)(5660300002)(44832011)(41300700001)(8936002)(2906002)(4326008)(8676002)(26005)(186003)(53546011)(9686003)(6506007)(6512007)(6666004)(316002)(54906003)(6916009)(66946007)(966005)(66476007)(66556008)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEd2bDBDT29BbWhrdWFDZFJzT0FuTVB0QWkzVm1yaml0Zi8zVk1yMEQrRXpH?=
 =?utf-8?B?ZW5teVBGZDRSOUVPSTNBQ2h2VzdBdmhLMnB2Zit5blpYVkpZK2l0MERpR3I4?=
 =?utf-8?B?QVlWRi9IR2c4M0ZPU2FobWlUVC9iT0xGRnBONHNocXpiWmZOOFdCdkl4OTk3?=
 =?utf-8?B?d1ViZm9pWWtuaXpLTEpkYnJhR3k3M2FzNDUyVHhzb3VkRi9JOS8wNFord0xX?=
 =?utf-8?B?QnUzUUh0dWo1NGZGYmtzWjMrV1I0Q2R6SHlmQmlla2plUUZEWUFsM0I1OEJr?=
 =?utf-8?B?VzBJZU5raGY3bGFqc3hDdTRaS2hmSXJ4bnlVaTFmM25iTTUvTUVSSkFzZzBj?=
 =?utf-8?B?QUQwUCs1THo3aWh0N3JDSXAyQjN6OGNWdkJiQ2xwaGw4dk1wTm1qWUhkUjYx?=
 =?utf-8?B?dU02TWdVbklmdmlRZEVlK2RkTy9JRnFiamdVSFdlWUluSUozWitqeEI3R3A3?=
 =?utf-8?B?MmNGSi81V1hTM2p2WnE1TFJPcW1rMXB3K0lsMUNIWXdGUXJ6clMwYVNtdEpy?=
 =?utf-8?B?c2NHOFNnaXYzUzBXUUVUMHhjQ1IwL2FoWXd3L1Z3MkpVekRxWTcvMHkwYzYy?=
 =?utf-8?B?OGJST1o0TUpQZ09PSVVGQmJGK3JtV1VrOHpKeElMRTdaRkxoM2dZdWhEMDBN?=
 =?utf-8?B?N1NKT0crN2xVaW5KR25EdklxUmFOOWg2L09mQ2MxY0tVNzlwQW93TFR3S0pp?=
 =?utf-8?B?a0ltRkFZckdWb3JDNmJZSU9MRjRGdHhPYkEwYllkWnlhOCtqM2FIN2tCMmI5?=
 =?utf-8?B?K1ppZStEWEU1T0ZCa1ZXY2JiVXluYm8vaXNuRlAzbWNlb3pZaG05dGhjcEtk?=
 =?utf-8?B?ckt6RGd4RkMzMVZkc0l1MmxsSGV3bmo0YW9SaVpLRmN1djdLTzNwN0ZkQ3gv?=
 =?utf-8?B?c09vdWpEMDJ4dVdtKzc1cXRMK1VZNTg0YWE5c3BHZWhsaXNMYXlsQ29zU0Yw?=
 =?utf-8?B?TkgxTW93eGpTbUN6NGN6RzBxUmhaUzJwUFRIbThyUTdneTN2ZDdRY3ErTFNx?=
 =?utf-8?B?Vi8rWHh3QnZjSUNnZU83Tm9BMm4vR25rTiszRjJuVitidXdyMTFxemtyZkMx?=
 =?utf-8?B?dTRQbld5ZXUwc3Y2Vy9JYnZZNkcrMFd0SGxJenlBalpXVW5YbmF4MFg2a1N3?=
 =?utf-8?B?UWRNOFdSYlRXeWdCTkVraUg0NFEzQUhvN2FvTHZBTXFUYTlCZEhobWZJN0dn?=
 =?utf-8?B?ZmV0V1c0QmlBRzlWQnl1NGJJNnl2anNWUXFlTlFWWnpFR1ZESWZobFlISWlM?=
 =?utf-8?B?NzJ5eG8yU3RHQkw2ZTFSRWF4OTFvLzJ1ZWYxaUlYbWUxVkdvSEQ0UlN4SmFp?=
 =?utf-8?B?dFQ0eElBNkdFdUFIbVBQREsxZWw4M2hjV2RsNnl4cmtaNEhDMHFhRzBxV0pn?=
 =?utf-8?B?VnExdjd0ZUJvaVcxUG92UklyQXFCb3FaczkxL3ZFa2lPbmNIa1NOM0lob0N4?=
 =?utf-8?B?L0QwQWhlNmlhNFJGa3I1OVl3dlJVQXJBdGNEb3hINVRrdjlwS0g3dGJldDFZ?=
 =?utf-8?B?UTVqMlk2MEl6NDlDeE13ZDJMVUYwaGdzZDVrSXdvZU91SzdYa2g0LzFFYzNU?=
 =?utf-8?B?dG9TSXZ3clQySGpkazhvaVpUZ1h5d1F3c3N1bVNtS1UyYjFSbHRVYzhiUVRY?=
 =?utf-8?B?Zm5RUEpZazJQK1ZiUm1KdkQwWkpFSHdvUFA5ek1aYlJ4b0ZmL1o0dGFLYU9G?=
 =?utf-8?B?QktMVjEyTzc3V2dSam9qS2Z1d0F5QlhIck13bGVCTmdWYUNEL0ZxK0VYNzZR?=
 =?utf-8?B?cmROU1ZFZzBVajNoQWtrRG5YSUcvdUtTcXR1T05WeGl4S1FqZGtmY3hlTWly?=
 =?utf-8?B?czhhY3gzbzBwazhTdGtpVmdKTVBSdldNdlR1NDRPQmlxWFpBUDJaNXM3YWlC?=
 =?utf-8?B?dlMwYjl2c2tNeThvS3JMZlhnb1RxUThFdzl5UTc2bDhMSHovS0s1eW9CQlVP?=
 =?utf-8?B?dmhiSVFiejZyQ2N1eGFtbkVtMVhpKzV6b3RxNjdNRTZ4bEJUcjJ2V3FvZVp2?=
 =?utf-8?B?dkZUREwxMGtoenhicmZSK0RtOUVMQUdiNUJkcjRBRFd5REhZRFBBRDRzc1dS?=
 =?utf-8?B?cVN6WkY0b25NQnhDOHZmSFA3aVRLMFE5dDV6MkVPOGs0dDQ3NTZ6U3Erbkkr?=
 =?utf-8?B?eDI4eEp3eHpVRXdnMGNpMDNLYTF1T1FUQzFETFAvS3k1c3o0bnoxRG5Bc2hC?=
 =?utf-8?B?T3c9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a679a08-9a26-4a59-cd1a-08dad6ed5f8b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 18:20:22.7435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eSzIVLhjkK9XYXIc2iwo2uZUZJZ6Ml5VjhRn0K+84rn1VcwiJTqH81G4+IGFtnwnpDZ/Yl+lKnVAIXEVOQ0l4P7k+s1GARUn3liw0BBzSvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4947
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 03, 2022 at 12:45:34AM +0300, Arınç ÜNAL wrote:
> On 2.12.2022 23:45, Colin Foster wrote:
> > DSA switches can fall into one of two categories: switches where all ports
> > follow standard '(ethernet-)?port' properties, and switches that have
> > additional properties for the ports.
> > 
> > The scenario where DSA ports are all standardized can be handled by
> > swtiches with a reference to the new 'dsa.yaml#/$defs/ethernet-ports'.
> > 
> > The scenario where DSA ports require additional properties can reference
> > '$dsa.yaml#' directly. This will allow switches to reference these standard
> > defitions of the DSA switch, but add additional properties under the port
> > nodes.
> > 
> > Suggested-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > Acked-by: Alvin Šipraga <alsi@bang-olufsen.dk> # realtek
> > ---
> > 
> > v3 -> v4
> >    * Rename "$defs/base" to "$defs/ethernet-ports" to avoid implication of a
> >      "base class" and fix commit message accordingly
> >    * Add the following to the common etherent-ports node:
> >        "additionalProperties: false"
> >        "#address-cells" property
> >        "#size-cells" property
> >    * Fix "etherenet-ports@[0-9]+" to correctly be "ethernet-port@[0-9]+"
> >    * Remove unnecessary newline
> >    * Apply changes to mediatek,mt7530.yaml that were previously in a separate patch
> >    * Add Reviewed and Acked tags
> > 
> > v3
> >    * New patch
> > 
> > ---
> >   .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
> >   .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
> >   .../devicetree/bindings/net/dsa/dsa.yaml      | 25 ++++++++++++++++---
> >   .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
> >   .../bindings/net/dsa/mediatek,mt7530.yaml     | 16 +++---------
> >   .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
> >   .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
> >   .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
> >   .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
> >   .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
> >   .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
> >   11 files changed, 35 insertions(+), 24 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> > index 259a0c6547f3..5888e3a0169a 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> > @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
> >   title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
> >   allOf:
> > -  - $ref: dsa.yaml#
> > +  - $ref: dsa.yaml#/$defs/ethernet-ports
> >   maintainers:
> >     - George McCollister <george.mccollister@gmail.com>
> > diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> > index 1219b830b1a4..5bef4128d175 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> > @@ -66,7 +66,7 @@ required:
> >     - reg
> >   allOf:
> > -  - $ref: dsa.yaml#
> > +  - $ref: dsa.yaml#/$defs/ethernet-ports
> >     - if:
> >         properties:
> >           compatible:
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > index b9d48e357e77..b9e366e46aed 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > @@ -19,9 +19,6 @@ description:
> >   select: false
> >   properties:
> > -  $nodename:
> > -    pattern: "^(ethernet-)?switch(@.*)?$"
> > -
> >     dsa,member:
> >       minItems: 2
> >       maxItems: 2
> > @@ -58,4 +55,26 @@ oneOf:
> >   additionalProperties: true
> > +$defs:
> > +  ethernet-ports:
> > +    description: A DSA switch without any extra port properties
> > +    $ref: '#/'
> > +
> > +    patternProperties:
> > +      "^(ethernet-)?ports$":
> > +        type: object
> > +        additionalProperties: false
> > +
> > +        properties:
> > +          '#address-cells':
> > +            const: 1
> > +          '#size-cells':
> > +            const: 0
> > +
> > +        patternProperties:
> > +          "^(ethernet-)?port@[0-9]+$":
> > +            description: Ethernet switch ports
> > +            $ref: dsa-port.yaml#
> > +            unevaluatedProperties: false
> > +
> >   ...
> > diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> > index 73b774eadd0b..748ef9983ce2 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> > @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
> >   title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
> >   allOf:
> > -  - $ref: dsa.yaml#
> > +  - $ref: dsa.yaml#/$defs/ethernet-ports
> >   maintainers:
> >     - Andrew Lunn <andrew@lunn.ch>
> > diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > index f2e9ff3f580b..b815272531fa 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > @@ -156,17 +156,6 @@ patternProperties:
> >       patternProperties:
> >         "^(ethernet-)?port@[0-9]+$":
> > -        type: object
> > -        description: Ethernet switch ports
> > -
> > -        unevaluatedProperties: false
> > -
> > -        properties:
> > -          reg:
> > -            description:
> > -              Port address described must be 5 or 6 for CPU port and from 0 to 5
> > -              for user ports.
> 
> This shouldn't be moved. Please reread our conversation on the previous
> version.

I see - I missed your point. My apologies. This binding should keep the
reg properties where they were. I'll wait a few more days for any
additional feedback.

> 
> > -
> >           allOf:
> >             - $ref: dsa-port.yaml#
> >             - if:
> > @@ -174,6 +163,9 @@ patternProperties:
> >               then:
> >                 properties:
> >                   reg:
> > +                  description:
> > +                    Port address described must be 5 or 6 for CPU port and from
> > +                    0 to 5 for user ports
> 
> Arınç
