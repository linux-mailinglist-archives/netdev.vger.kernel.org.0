Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5E7649017
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 19:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLJSDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 13:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiLJSC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 13:02:57 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2138.outbound.protection.outlook.com [40.107.220.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06A06179;
        Sat, 10 Dec 2022 10:02:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yocr/C66K4NySUXMn+MnRzctgSxH6VGtxU/EuOXMXRrSttKRQXXExN9JMFmQ1VfoZF8xPCJZGALKTILn+MiqX46ptYkVlFZkW1rXvLnxkTLadbJFW24a5g2Bqa4zdUx1+UHP/KFN3oSe6P8UobEjLy4WYh+wDOFGxR0vIi1pFMjsXSuiVVZ7cD8dUiU0sSy9erg9V1AeJhg4TI4NZbJ1mSLPDw23Wly1ymWOgOAMWArFyePwpNZVVDaPGJDMWo/aKVVgcQLW+wTp+2JZCj5Gbn5w1VEKI9WckweHTqIG+khxCNCF749d2XreZPdOjy54WDf3fx24uaMVHHVOPzXxUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3e/rTDe5rDlOS8xoZhx8OMQalncieQUoom0yzMoAMg=;
 b=O9NaoPTLCFEvKM3ZDCvrjT5zFN+Fo+Gsf4FAQPzznWvWhICaUZA9naHRHog9AZ2Fu7yof4xH6eCJPdLfkcTl10M2qtU7H170C9U9a+l+SswY0Fsm/YLYjT6SADdFZhnFFg8Yibx+h4DitCOcCRQRkrAM1S6lw5xFQCnGtfCBEW2MHtXY1doXXInMVTWsHcH69edfpa1U4I7eOTmS9RD0AVS+DJaiVZqRKbOBAD7OIzeIVw9mkT4zeer+SbpP4Fw3DDnmWgqGv2Nd8k1enxeeanLpTxMDy7xeK2M2fDtT6w7q0Io+wj+6DBRKaEio7BVQm480Oq6I2GgRmJL8KmkWAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3e/rTDe5rDlOS8xoZhx8OMQalncieQUoom0yzMoAMg=;
 b=hCgSXpQvsAUhQJELVLOUHsddYFaANAT1uBo0SmD5SvjVHqhzscvOuyNQD4oXnQqQVKAnJNFJL1xfNcDnOPaG0SvREjNnsTE7Fx1yTpvzYLApEwMi9P+twft+Ztcbpsqv6uHmd1oc30X9QNEjTC3CLxWTeNfQkvRXJcv0ifg99lE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4897.namprd10.prod.outlook.com
 (2603:10b6:208:30f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 18:02:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.019; Sat, 10 Dec 2022
 18:02:48 +0000
Date:   Sat, 10 Dec 2022 10:02:43 -0800
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
Subject: Re: [PATCH v5 net-next 04/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <Y5TJw+zcEDf2ItZ5@euler>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-5-colin.foster@in-advantage.com>
 <1df417b5-a924-33d4-a302-eb526f7124b4@arinc9.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1df417b5-a924-33d4-a302-eb526f7124b4@arinc9.com>
X-ClientProxiedBy: BY3PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:217::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB4897:EE_
X-MS-Office365-Filtering-Correlation-Id: 6178d276-0e66-4845-30a4-08dadad8beec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ov38+xffhCr+VSSf0jn65pBMEkIWvtiEOS4iF+OKQvV5HVdyNfGe34BftHXMX5e0r9WwQ01fnd4HS6xosSUrrenxf/uGe5iNYqRLYOizWGnLF2VOP8RgN7xbCCVCOzGUrlHjGmAV2AD5Db+wd2w0N1/xH+KfhnkYlvNZL7NYgxDiYLOTvzCMBNO+UZzBcHIK44YIk7e2vL8de2+HaiudXu5tC1O0uiQBJnqftTUVBq3Q5XYKB9CU2mzuBBgiMjpZkpX0CZ9S+3TeeWuoI//5ruxwezCz4ZKfjJoC5knTJu333VEkj+ockEMP2+4UzeWboz8c4kkWVj3cGlpKYtinuOOWRTGlLE6cuuFjTutzfLT0TdCyJCEZguPmceeF9WS81GNkIC+NWiy1E9tooWByHPKwL1N4fcubLusf9pZE0exIGO/D4kci5XjNlx7idUXH8ug2TAnu+QqYtwhBo4bPNYc7Z3xXN8/o/9wxzS77QtQEFk8RDzBvEXk9vb55MVWoLmhe3B0lf64AsVV+t1Pfs7Enku20dHhHp4guCqBimYUswEumlkgKytW0lQ1cKbaLOYp1JFDkwE/P1ZecJvJMJz/tpKx0gPlqi/09qkqA4ngZepLJCDY9sagMkODyGyJxl76YZE0eAXkMx4QG0x8N9KbVX1ZciGp0/8oh1ggJzzlsCao+q4QOOSkK38UzX7/sGZ/9dOJkRdeXUAtz6jkaCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(39840400004)(366004)(136003)(396003)(376002)(451199015)(66574015)(41300700001)(38100700002)(66556008)(66946007)(4326008)(5660300002)(66476007)(8676002)(8936002)(83380400001)(86362001)(478600001)(54906003)(966005)(33716001)(6486002)(26005)(6512007)(9686003)(2906002)(44832011)(6666004)(7416002)(7406005)(316002)(6916009)(53546011)(6506007)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmxyVG95TXhQZFVIeHdJV0JzUXdqZkFsbVVxYmxYeHZub1JOU1hMUEQxM0Ir?=
 =?utf-8?B?ZTdMTGZINDlqMWxKQ3JNWEkxSjYrWmJ3S3dscXAzRWpvODAvb0dIbzRmazI2?=
 =?utf-8?B?SnVORUFjajBDT3dhajhUQW96VzNrMWVIYWJxc1liUmRlL1Z4VTBLc1AvbHJk?=
 =?utf-8?B?ZFJsRW1pdDdndzZFdWV3Y052NzJ5M1QwYTdSbTJLOGYydkhWM0loRXVROHA0?=
 =?utf-8?B?U2MvSHRsQjhUeVVFK2x1Ryt1QTEwVnFmR0NVYUZtREs2T09nMHFtK3lhVnFs?=
 =?utf-8?B?aURGOURTMWJlTmEwYjFRbkt5cDhVd3k3OWNoOUNzNklkR1NuQlVFamlUV3ZZ?=
 =?utf-8?B?VEtZdG8rTUlhdmZ3K3doeE5aM3hsbGdoTW9zSmtCSlRudVB6ejFKdXJKRjlU?=
 =?utf-8?B?ZisxV00yclN1NjZ3a0JBVzBlTUJVWC9MamgrUmlqejZMUUo5MkszbVRFejR5?=
 =?utf-8?B?ZW4wRkZiNUxoaWxJeHJCSTVjajNYQng0bDZoci9QNVFYZk8yanNUblhHY2hS?=
 =?utf-8?B?TGN5R0poMUVmeTZQQVJEOGtxSUZkRWpXNUtScUJmcTRsTk5wZkxtZXRTMWxX?=
 =?utf-8?B?V0VLVjVSQUhheENKYXo2QTRuZTkzQVp4M2ZzZU93VXlsMlNFRzNGYmFydWkv?=
 =?utf-8?B?NUJnTE5ZbkdnZEFrRFFUTUJCSG04RkdYeXBUcXZpZEg1N2gwL211MjV1djhD?=
 =?utf-8?B?Y2RxTWJMNkQ2T0R5WW54WENnN1B6MUtEUG5iK3dkUmF0MFI5NVNpRW1ndmdy?=
 =?utf-8?B?ejRrR1M0a0dwSktHWk9mclJBWGNyTmNxYjkrVG5Gb1NSN01KbFZjWGJBN3BV?=
 =?utf-8?B?TU52cWxGNUxiKyttcG83OUpoY2xrbmdqSjFUM0ppOUNRS3ZHQzQzSlJ2dllh?=
 =?utf-8?B?cDByN1NKZ0o1OUNQOUMyUzhKVlU4UHd6NlBMWjNXclFyL2dVZXhGbmNldEpo?=
 =?utf-8?B?RnIzTWtYSmd4clZJODBBd084TU5zSW45SXEydSs4YU0xaGJmUFhQWmFDR1NM?=
 =?utf-8?B?NUplaXJXZEpia25uRVEzNGtsZEdyV2tLWXE1czIwQ1ZpaTl3K2tFd0pFWVU0?=
 =?utf-8?B?d25XK1RjYlpSL0EwT0g5YWp6ODlnNlFRM0c2UlBScmtlTk1wYXhDaE1qY2hx?=
 =?utf-8?B?ZEtEa1doRy9rcmkyUnVQK2k4bUJHMWpKTVU1LzZBZjZWUkhnMnBLUHQ0dTQw?=
 =?utf-8?B?ZzEvM08rWFdSNUxzSG44bVhmdWRTVk0xeUVwUDdPUmJZdDYwUkp4dmVSYTRh?=
 =?utf-8?B?MlIvbDVUd3BEc1NwNENXcGdLRnZFbVZxUEE4dk10THAySksxTDNUODUwbzl0?=
 =?utf-8?B?amZ1Y3BmcU1wTDBKWHYyYitCZWdXMVNYeHo1b0RraWdKYlY1Kzhjci9kdU1J?=
 =?utf-8?B?dDFNM2tnRnJNdnJqbWpQZ29NbWUrRUhlYW9uSjJ2d05zb2JoakdSc1lnSlpR?=
 =?utf-8?B?bEhONUpNSnlpVWMyTmJTUE40NTlsa0VKaWR4aXduTGdtZGhIbDBCZUE5cGFs?=
 =?utf-8?B?cHBDVGIwQlp5b0tIUW11L0cxNVp3MHVWS01xUElLUHk3RVZOeGpsK3EzYXU0?=
 =?utf-8?B?K3NmU3h2NjU2MGI5L2ZPRVd2TW9XSmhGdE1oUENTcWxMeEkzYnoxYXlKV25l?=
 =?utf-8?B?eGdvWjdyY3c0MmJmOUtBdFpLdWJPWlpIQTJ5UlA1dHF2WGxqbGNEVjRVaVRF?=
 =?utf-8?B?SkZYRXc4cGJkZTNEN1RPNEpDWDg1WVpOQmFZOTkrUXFPY2pQSE10akw1dEY1?=
 =?utf-8?B?dy80dUhrbjMrZTVOeWNVWXNXMW1HeWZnWW5vK0RoTkloZ2J6ZjhzTFhpaWxE?=
 =?utf-8?B?cEJxNmQwKzFNRFg1K1FkVWdWL2VPcTl6N0FQVlhJcTlYMjlRQ1dSUDBEd3Jy?=
 =?utf-8?B?SDJ6R1JWVllUUXNFd01PMHI0LzdNYWFsaDdTc2JmdmJWV09hNVJrRVltbW9Y?=
 =?utf-8?B?aGlKeFFkV1Q0dmRZWkFZSks2eGxOWWRkOWwyd1ljbm5oSWpRcHZ1T0E4YkNn?=
 =?utf-8?B?WGNRRGVRQUNQajVrM0FuUDRzYjBEN2YvcWRBQ2JuQlVSd1JCSktGU0xES2RO?=
 =?utf-8?B?U29iMHd5WS9hLytUVWI4SFk4T01VbGxCNTFRSW5GaTBqNGQ1aC9Ga3hPSmVk?=
 =?utf-8?B?SEZ2bC83dkFSaGF0S24xSjUzNHdOQjA2ME1SalJLeTc4dzZjYU1QeEJhOFV6?=
 =?utf-8?Q?w2lqkCsEecPypWoX1kbvVAY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6178d276-0e66-4845-30a4-08dadad8beec
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 18:02:47.9474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ALMRrMXxxxA12SIhVkR1cYWFqESdCSPJ4muZ31MxZTdQ8QJlnvSs0ywX66GT9ksohlII1+z86he4D2uviyNJOi2jLo/QBv82/tm3neIm404=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arınç,
On Sat, Dec 10, 2022 at 07:24:42PM +0300, Arınç ÜNAL wrote:
> On 10.12.2022 06:30, Colin Foster wrote:
> > DSA a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > @@ -58,4 +58,26 @@ oneOf:
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
> 
> I've got moderate experience in json-schema but shouldn't you put 'type:
> object' here like you did for "^(ethernet-)?ports$"?

I can't say for sure, but adding "type: object" here and removing it
from mediatek,mt7530.yaml still causes the same issue I mention below.

Rob's initial suggestion for this patch set (which was basically the
entire implementation... many thanks again Rob) can be found here:
https://lore.kernel.org/netdev/20221104200212.GA2315642-robh@kernel.org/

From what I can tell, the omission of "type: object" here was
intentional. At the very least, it doesn't seem to have any effect on
warnings.

> 
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
> > index f2e9ff3f580b..20312f5d1944 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > @@ -157,9 +157,6 @@ patternProperties:
> >       patternProperties:
> >         "^(ethernet-)?port@[0-9]+$":
> >           type: object
> 
> This line was being removed on the previous version. Must be related to
> above.

Without the 'object' type here, I get the following warning:

Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml: patternProperties:^(ethernet-)?ports$:patternProperties:^(ethernet-)?port@[0-9]+$: 'anyOf' conditional failed, one must be fixed:
        'type' is a required property
        '$ref' is a required property
        hint: node schemas must have a type or $ref
        from schema $id: http://devicetree.org/meta-schemas/core.yaml#
./Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml: Error in referenced schema matching $id: http://devicetree.org/schemas/net/dsa/mediatek,mt7530.yaml
  SCHEMA  Documentation/devicetree/bindings/processed-schema.json
/home/colin/src/work/linux_vsc/linux-imx/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml: ignoring, error in schema: patternProperties: ^(ethernet-)?ports$: patternProperties: ^(ethernet-)?port@[0-9]+$


I'm testing this now and I'm noticing something is going on with the
"ref: dsa-port.yaml"


Everything seems to work fine (in that I don't see any warnings) when I
have this diff:


diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 20312f5d1944..db0122020f98 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yam
@@ -156,8 +156,7 @@ patternProperties:

     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
-        type: object
-
+        $ref: dsa-port.yaml#
         properties:
           reg:
             description:
@@ -165,7 +164,6 @@ patternProperties:
               for user ports.

         allOf:
-          - $ref: dsa-port.yaml#
           - if:
               required: [ ethernet ]
             then:



This one has me [still] scratching my head...



> 
> > -        description: Ethernet switch ports
> > -
> > -        unevaluatedProperties: false
> >           properties:
> >             reg:
> 
> Arınç
