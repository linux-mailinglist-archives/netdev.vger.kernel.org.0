Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09AC060EEE8
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 06:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiJ0EGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 00:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbiJ0EGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 00:06:19 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2113.outbound.protection.outlook.com [40.107.102.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48925BB3B6;
        Wed, 26 Oct 2022 21:06:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0+S3aJf9Bi3F9NZV8m7EuFWI83eBjhFClpmWIcSLzGUvHBjdoi1Il0dueuJ6mFJIfFlGKwZrmHzeX9HClDNkIULImgtdPlfV+cpaUXI35XfKWRZqkBEZ9hawTUk5PcRu506JcELYh2Jw9R/jvy7Lp7LdztegqguongtvJueAzriQMRXPba2fiYklfLt0IoXV12H5XZ8OQmv8NV2/kvo49c36q1HVFJRh3inqMmvt2wK6bwrsUKQ0bJI9akRlc+BAi9NDDrXuZBgp9LwB4Few+BRLKq98ak933ZTDQKV0dWVMAESxtQxdBgCt2VsN5IY6tFqzhG4lP9Wksz1j5kGMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r09eI3XPeddwrj/RKSU0E+lq8KdETTRgZ5nuzTEgFWc=;
 b=luPenzcKyxAf2hJTuKZqTyX0yalxsAJlb46KOfZLODoccPDzSoLNFvZpBVwn2FMxdwut8hOGs2Q1KI+N2ReDEzu4zf4WY8DnZtXPYZ4iDZoLvklcgtzLUFR1P4AKfXPpDH4ohtVRbW85aKo/+GhmGuaNyfZZdYG+hDz/J579sfAHy1ECCKlUd+4WJi/AosSizvj2ygDKKeH5v3oMmpFoqEkD9g+IOJVKPf6iim9KAqZRzukD9yXadvabDd2GK/VHU8tGLwN7ZA4uaAc24RO8GodN3tyivdEYffHaswHb9wGcFjjjYWjQ68OLWiL8HA4vnegJJRoay9jsH8Gg0Dm3kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r09eI3XPeddwrj/RKSU0E+lq8KdETTRgZ5nuzTEgFWc=;
 b=P5A8UyBFGaKz73TVyKt9GrlzOBUPVgpUSg+5/uwxG1W/fspBLyBoAGanDmOsiyeC7Raroj/IaMt2oUr0qyx5++ZXTgX9c95p2SqXwKUMXT5ARjBaoti3vLexUz2phKH7eEMCYm7XYmVhb7a3F4/P0eg5c6Ubey91K2Bawy6wT/4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BL3PR10MB6138.namprd10.prod.outlook.com
 (2603:10b6:208:3b9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Thu, 27 Oct
 2022 04:06:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492%5]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 04:06:13 +0000
Date:   Wed, 26 Oct 2022 21:06:08 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v1 net-next 6/7] dt-bindings: net: add generic
 ethernet-switch-port binding
Message-ID: <Y1oDsKfRKHC1Mok9@euler>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-7-colin.foster@in-advantage.com>
 <20221026174421.GA794561-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026174421.GA794561-robh@kernel.org>
X-ClientProxiedBy: BYAPR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::44) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BL3PR10MB6138:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ee4f566-e50d-471c-c269-08dab7d0966a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OYAgI84CndWvVU3B4MmcXbMuf1h4Xx8exuxq3gblrloIPcLTfb8GU0GGHU6a523Jb4KVbkGVRt7r+b+VIRlWJDYKFg7A9o6ra4/Baqc+YuZHAN64cjHU+SpJT1VUhhCi6sYGOQbeKh11jCHGqrkUhTM5U8OHmlKwnMHasMWAODshLUDrcTwnmMpO+pEWYUOOhMJQH6qsy1YaU2Tsr5r+wuZ5+eVGdOyL22tFk0+gSWKDSvyjToWg1Xi+szg0A5iY0Kx0WQdveo+Sfnvh8uzlp/5Fq7xXfjp9YUNjq55Mbmui6Kdpw9/ZGPnUsqpkXyk4KJGyhP6dTO+1E0tWLu9mAw4JIJtl73LNdnU9qPyL3exmBvgDuH70/MOhZMdrnfpwbtTqeL4jWBbZ1oqolf7gchylogH1FBIupP9pdecCPdL3VEdjIIJCGzWpfSpRLKxqYNAQRDDbNPq8iRbnOTEpkTMoK4vuPET6YIBiy2ifq5V6PfZ+OMYLBY0Sjd0PZAB473lJKyUpGVH/D5NxRM1cmI8iMlYZnBhGADgYlcbGdEjyt6KNI2vB2yPFexVwCZPaz+nCFFIfnKTQsVq1p7aScOiRc3RwRGVV1Hr9/kuY/WNitZnJU+RBJejFUsdFqZzYXYV6OolqGNhq1Ik25hiSF6PS8m0DZT1hCdFO9kmNi3ELEmkCSI8Czy/2BF1Eu6vhlN4mGCGe7goaEzInWE1n7nQQrYu0k0iSL3QHfIEBfn1V3iyW0zIChIP946Z+bjNOYeH9TDhv8AaGCwN9ffCap0SmHTO8x7nj6ZsH1sfbjoQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(136003)(346002)(376002)(396003)(39840400004)(451199015)(6512007)(66946007)(83380400001)(186003)(44832011)(38100700002)(5660300002)(2906002)(7416002)(4326008)(6666004)(6506007)(6486002)(26005)(86362001)(316002)(9686003)(66476007)(66556008)(54906003)(33716001)(478600001)(8936002)(41300700001)(8676002)(6916009)(966005)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XAJd07R2z0whrU2wi6PSvHz+fn8emWYsvL9wRwfUa3NXjOB6M3MHdyiAZDdN?=
 =?us-ascii?Q?n6Wd3otWcaklP3uXIRyXQ5yzGsI8arxV9IE7nzWj+rBGkX2CX1y+UF6itMU8?=
 =?us-ascii?Q?aJ4IdQyHUucVFAxCFVGVDupSUTEYmw4sFPig2U+NsGfchXj0+vgJgzn4SRDc?=
 =?us-ascii?Q?2V6I0G4Sge/6hMzvYQxbOrD3tTe7HvqzozVr6h502z/5MBdRHtb/pWz5x5AQ?=
 =?us-ascii?Q?ofCST+tvVRVkcisphT6vEtYoiakCIlfnerLMgwknV8rsvY8Y0PWAOocXtRY7?=
 =?us-ascii?Q?uECWENxdlReu6IF5D75WUTD+nTzE6fJXk3iKWAwDcdetj43Vd3lpzO9UgS9a?=
 =?us-ascii?Q?FnUtvDNKqeUKQoo2jipPfI6Jn9mwAm6LCuNHzX+ZjTJkltn9CuqZgoy1IfX/?=
 =?us-ascii?Q?vG35xsx8yVbtSX0XGDGYp5qoQfd8k8hB9lRsbvk6JwSKizdwWonKKV86+Feb?=
 =?us-ascii?Q?UalfxtVsKNe/DA42rEIaHUZOvjKzx15CqyGN+2TDLen2bzPLbE9j1ystZgpL?=
 =?us-ascii?Q?F6om4+JwHXHut5WarQeXH0J1YX3F/ihKzDOAn3OHvMcGq+uF4kP+7La8bD0e?=
 =?us-ascii?Q?idVrmAERhCax4UQghvC40cVJNzToZEWFCAfFt0Ik6eYHpJLTNlybN9TwC7HU?=
 =?us-ascii?Q?nlLHcLkCQE9xWOcP/5LzITPe6Flwjwg7PYqqaRYZIJpQeQMAuNgvrteEF203?=
 =?us-ascii?Q?5bRm9GYu0u88u0wss4FLy2fmODTIr9P+LjqrJWYpXmfD0Q8naT2O2JszgWQV?=
 =?us-ascii?Q?gGx4tRUl7fONexMtr4UD5Yklsdx9w4r144+Y6E8v98YB9l+dH+THr+E4beCn?=
 =?us-ascii?Q?ajgNk9udIZ9YocacKZsfraIcr24qjq3KU8hmGM258D3TfFkNBG8lSiFcAd++?=
 =?us-ascii?Q?ErAZmgSgbISys71KIuFCwBJsONOjzrfHNB3RdBBj2gP3YMdgThUwOaMs+r2R?=
 =?us-ascii?Q?HJCrkQUsfJTxA+h9ZiJZsyErrCMLurz4UvXRQEJmGdcnzDhpeWiEg8+X4ZeB?=
 =?us-ascii?Q?w1M+mXcB0DuSlpotHVLCAUfxttAZb+toUtQwNyAcHREgsaFi5EEDQw8FvzKq?=
 =?us-ascii?Q?5OagfkcMUwhBjscCvl4DYULnBY/ny05VGhX4zwCVRvRPT1UHjnevEfJh+sPb?=
 =?us-ascii?Q?ENmLjLVFzld9CqrMcQunjQAqu7slU/lID36hsYJCH0HPi77+782R64Cf45uN?=
 =?us-ascii?Q?TMF/DoF/JzscxR6X581HeRZvAY8h/JE4oR0K11cfZEMpHy3cOVagRdMRNmV+?=
 =?us-ascii?Q?m1Z+8OuzJ1vU2u+KFMn+VJQuasKJkWZFNKYn46rLOdPCG5IFPR2k0Y44fb08?=
 =?us-ascii?Q?QmDPt7czvimtNz3iM2E5VmYsDXnTvQT9pz1gvye4zuc3M17hXmmCD4nB7dIw?=
 =?us-ascii?Q?RYvOBVpmXUvbYUNGLeiijbDJPLTaNC/HyIWuyOTym7C1PcqITwwGjVyuyuzF?=
 =?us-ascii?Q?HeMDFm1XYHefjZmLlAhMfL/YQaj7ewVLtsSLbnD0JFQ8hh+rtrnv23Ae7Aia?=
 =?us-ascii?Q?7Ue/wLcCHxF5aiLJIDGuEAqAmkZvsyOVUJxUPEGusWfUsrZkJDQBkKGAbNeb?=
 =?us-ascii?Q?EZbP0MHF/dytb+sv8G1OXhepttDMGaMSTDY07xnjXeo/TwBM1Zj0nOazXw2n?=
 =?us-ascii?Q?CfW829WNHtF0942IM+L656E=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ee4f566-e50d-471c-c269-08dab7d0966a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 04:06:13.4599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQEFHzdZQqgl7a107pewH+9AG88HuU+2OucNVqk6Lt3zIyLzZNf2+i98KzNbWLbDfzI+32PaPJzhuUxnSioOqPE0GNzPaIy5xxUTHT9+rIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6138
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 12:44:21PM -0500, Rob Herring wrote:
> On Mon, Oct 24, 2022 at 10:03:54PM -0700, Colin Foster wrote:
> > The dsa-port.yaml binding had several references that can be common to all
> > ethernet ports, not just dsa-specific ones. Break out the generic bindings
> > to ethernet-switch-port.yaml they can be used by non-dsa drivers.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  .../devicetree/bindings/net/dsa/dsa-port.yaml | 26 +----------
> >  .../bindings/net/ethernet-switch-port.yaml    | 44 +++++++++++++++++++
> >  .../bindings/net/ethernet-switch.yaml         |  4 +-
> >  MAINTAINERS                                   |  1 +
> >  4 files changed, 50 insertions(+), 25 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> > index 10ad7e71097b..c5144e733511 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> > @@ -4,7 +4,7 @@
> >  $id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
> >  $schema: http://devicetree.org/meta-schemas/core.yaml#
> >  
> > -title: Ethernet Switch port Device Tree Bindings
> > +title: DSA Switch port Device Tree Bindings
> >  
> >  maintainers:
> >    - Andrew Lunn <andrew@lunn.ch>
> > @@ -15,12 +15,9 @@ description:
> >    Ethernet switch port Description
> >  
> >  allOf:
> > -  - $ref: /schemas/net/ethernet-controller.yaml#
> > +  - $ref: /schemas/net/ethernet-switch-port.yaml#
> >  
> >  properties:
> > -  reg:
> > -    description: Port number
> > -
> >    label:
> >      description:
> >        Describes the label associated with this port, which will become
> > @@ -57,25 +54,6 @@ properties:
> >        - rtl8_4t
> >        - seville
> >  
> > -  phy-handle: true
> > -
> > -  phy-mode: true
> > -
> > -  fixed-link: true
> > -
> > -  mac-address: true
> > -
> > -  sfp: true
> > -
> > -  managed: true
> > -
> > -  rx-internal-delay-ps: true
> > -
> > -  tx-internal-delay-ps: true
> > -
> > -required:
> > -  - reg
> > -
> >  # CPU and DSA ports must have phylink-compatible link descriptions
> >  if:
> >    oneOf:
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> > new file mode 100644
> > index 000000000000..cb1e5e12bf0a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> > @@ -0,0 +1,44 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/ethernet-switch-port.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Ethernet Switch port Device Tree Bindings
> > +
> > +maintainers:
> > +  - Andrew Lunn <andrew@lunn.ch>
> > +  - Florian Fainelli <f.fainelli@gmail.com>
> > +  - Vivien Didelot <vivien.didelot@gmail.com>
> > +
> > +description:
> > +  Ethernet switch port Description
> > +
> > +$ref: ethernet-controller.yaml#
> > +
> > +properties:
> > +  reg:
> > +    description: Port number
> > +
> > +  phy-handle: true
> > +
> > +  phy-mode: true
> > +
> > +  fixed-link: true
> > +
> > +  mac-address: true
> > +
> > +  sfp: true
> > +
> > +  managed: true
> > +
> > +  rx-internal-delay-ps: true
> > +
> > +  tx-internal-delay-ps: true
> > +
> > +required:
> > +  - reg
> > +
> > +additionalProperties: true
> > +
> > +...
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
> > index fbaac536673d..f698857619da 100644
> > --- a/Documentation/devicetree/bindings/net/ethernet-switch.yaml
> > +++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
> > @@ -36,7 +36,9 @@ patternProperties:
> >          type: object
> >          description: Ethernet switch ports
> >  
> > -        $ref: /schemas/net/dsa/dsa-port.yaml#
> > +        allOf:
> > +          - $ref: /schemas/net/dsa/dsa-port.yaml#
> > +          - $ref: ethernet-switch-port.yaml#
> 
> dsa-port.yaml references ethernet-switch-port.yaml, so you shouldn't 
> need both here.
> 
> I imagine what you were trying to do here was say it is either one of 
> these, not both. I don't think this is going work for the same reasons I 
> mentioned with unevaluatedProperties.

Oh, that was definitely a mistake for me to reference
ethernet-switch-port.yaml. And that was exactly requested of me when
Vladimir helped guide me down this path:

"""
6. The ethernet-switch.yaml will have "$ref: ethernet-switch-port.yaml#"
   and "$ref: dsa-port.yaml". The dsa-port.yaml schema will *not* have
   "$ref: ethernet-switch-port.yaml#", just its custom additions.
   I'm not 100% on this, but I think there will be a problem if:
   - dsa.yaml references ethernet-switch.yaml
     - ethernet-switch.yaml references ethernet-switch-port.yaml
   - dsa.yaml also references dsa-port.yaml
     - dsa-port.yaml references ethernet-switch-port.yaml
   because ethernet-switch-port.yaml will be referenced twice. Again,
   not sure if this is a problem. If it isn't, things can be simpler,
   just make dsa-port.yaml reference ethernet-switch-port.yaml, and skip
   steps 2 and 3 since dsa-port.yaml containing just the DSA specifics
   is no longer problematic.
"""

I might have been testing to see if this was necessary and since I
didn't notice any dt_binding_check errors this might have slipped into
the patch set. But my intent was to reference both here and remove the
reference in dsa-port.yaml.

> 
> Rob
