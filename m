Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02CD63B9D6
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 07:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiK2GdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 01:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiK2GdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 01:33:05 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2124.outbound.protection.outlook.com [40.107.220.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9162A51C30;
        Mon, 28 Nov 2022 22:33:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ac89ux4OT1CW4YSTudg0gBVcMQtLH5qFCHq/E8tAQSTaFh4lPr0er4xppx2pOJ70m4cL/9cQprtUl+IhfKRgaxf91nnZaSAK6qdPTCk7VDWOM5GEVdeq4JozwmLbQho4LeQM1Qt8cR/i3gSxueqeldyEMCZO2qrm5jxTs8kNjafRPtJV/5qLMpAyQ9+U0nU/dfaD5K0X4VAFqWvGVWJGAPN04UgsZEiEIBLgoXuH3eicX1zdiSi1bKM4zrfke+i2fOO4UvHQqsoyJXXPBB+PnhHTF9pzN3utLrm5WEWSUH5zrx3mAPKxv2WoNc8RD1qWDmqMdc0dz9YUfx6riKNoFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pl5u0A2tSkTto/yeYGigTXESkRSviMXULG916nTYdLw=;
 b=hasKXeDrGSek8Is9NVIRe7D0/5YwrtdrRw14L0lWAyEVJ7aZ1MFYE1PV/yYCbmr1m2nyFYVLfdi6/dNQixU4SMqKYdUzPc8XTT+yR3JRHAiAk6v4rEiwEnT6tlZV5h+pfaOKbb9Z+djcV6/47ARvyTFlMW3iPiUxptEt0dNJGnDi/TrW/ycaRml+9qkH6Y6fhTpAB1D3b6zKZ2P4Smr9MGGcw33dHeVH5DFkUCEdMLBYvWxlb00TksNrj+mcqPZHrdcnade/3OwvkZSS0zeFK8ds+9rdjtcl90VjtuuVcfD3Ghe54djXxNKEWW43wfTKF7O2KmeSNl39RKBcx6IgqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pl5u0A2tSkTto/yeYGigTXESkRSviMXULG916nTYdLw=;
 b=ovc0BCWYrsR2R+EqQovUgh+ezPDNHMrAt2bKl3aMjLoo2sOP9Vpd3aBtM7qbe0hKjQTKKcxqRjCzP/7LisSn+znd5Sk+PwK5lXThdTvzIqCP73xqQ4rutx1vXLAsZLtZJwfarBu465Bbrzz8WBjTW6FT8EKVCBbBBh5j6nEbraQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB4509.namprd10.prod.outlook.com
 (2603:10b6:a03:2d9::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 06:33:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 06:33:01 +0000
Date:   Mon, 28 Nov 2022 22:32:46 -0800
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
Subject: Re: [PATCH v3 net-next 06/10] dt-bindings: net: dsa:
 mediatek,mt7530: fix port description location
Message-ID: <Y4WnjiE2IxDgi5mc@euler>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-7-colin.foster@in-advantage.com>
 <08784493-7e85-9224-acfa-9a87cbd325e7@arinc9.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <08784493-7e85-9224-acfa-9a87cbd325e7@arinc9.com>
X-ClientProxiedBy: BY3PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:a03:254::18) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SJ0PR10MB4509:EE_
X-MS-Office365-Filtering-Correlation-Id: fe7ae3db-2d10-4271-e77c-08dad1d39016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6xtZgg6RhFUVdm/84A0G2qQD3flwsPDuGMgxizz457guEzROUzEvNXTG2tKNKaMRTXxHMdQQc6F6dYqnu8BqMejfXdV0EMc+9YAT66+IqHMGGR/5y7+OaJUciO+0IWpmkQSKxRWfbT9LiL74Ts/e51VbJMiFOmeCZXeZRXpcO6oP2KcXsooPhRWX/Lf3Jxqoz5xBR0LJ8R33IUHRvmUQc815qhh9RSjjbXeP2PWUXZ1L8UHIVlFgFIdZeQDjzu7F1JQGZsMxrAYuobxRr2XuReUKgJk1XzLB6iJMsvMg4sENCzLUu+CZLFGOSWEdCycATUw6dVmxuWeRHcGjZ8v8livLFvIQmtJbBNgckzYOpcS/hfkvG701uHdrdw5KOftmnfPEBRHnssDIX7oErfYNSZY92tO9Bp1HiBOTDBOpqhmcjY+UY/TfwReVXqTpEbFAHUbSkRNCRuUyC95Nzzpk19DqwIitbMWJeaGCgup1awm5hXtdSEwFvA9qcb6pIbIT3QToTBdtyUkxfPZW5uG6+GvH7Cw0SqyOejrdA4oIO3xCDbxTOYq9CoJP5Snln0gAQEAk+PabuDC+/2H53SlURKzFVIpa+qdvlu+YOPODSG1SHaiwXTjsGq4VJyaJ2SVrh+pbHYkslYFYMDkitFAGIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(346002)(376002)(39840400004)(136003)(396003)(451199015)(5660300002)(8936002)(66574015)(44832011)(7406005)(83380400001)(7416002)(8676002)(66946007)(66556008)(66476007)(4326008)(41300700001)(186003)(38100700002)(33716001)(53546011)(6916009)(6512007)(2906002)(86362001)(6506007)(478600001)(6666004)(54906003)(26005)(9686003)(6486002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1ZNbDZWWWI0VS81WStxbGtIbHFjRmxFM1RoL1gvUTd5a29WTHZTOWthcjBT?=
 =?utf-8?B?WUh2R0NOZEJqdVVLVjZyems1UU11c1NIWENubGp6WVdSL2w3ZTVZTkpYelJW?=
 =?utf-8?B?d2FKVDNTaW5tc0RNSVpkQzJIT0hnOWlNRU1QdlZmNC9ab2s3d2pRcGRnL0JH?=
 =?utf-8?B?UkxwZUo5WmpnNnhwMkJDc0E5R21lNHpYNzQ1TlhUMDIxNHhEM01idEVaQzdh?=
 =?utf-8?B?bTQySFlnR0pDckZYLzVkcnpTZHB6RGVqT2duS0pTTW9ET3lVZWRHamE2SUdY?=
 =?utf-8?B?d2dJNHhUR0RwOXdTazc2aW9kYVhNV0tnQmVxTkwxVzZDTS9JQWwreFRua1Vm?=
 =?utf-8?B?RDh6L1NZK2pDd1NzNlZaTFRvVkFCd0R3em1GUlNwL2ZXcEFwVXJUa3dPZHRF?=
 =?utf-8?B?NmQ5U0pOT1NGcTNDSHNhOW50SlYvb0hsZTVsYmd6d1FUTUs1MFM3ZWpxaU9W?=
 =?utf-8?B?UE9BRzhFNW1DdkRDVW1JMXZmRmNjZVExRjF6YU5VbDhTT0I1bXRTWWxQOWNp?=
 =?utf-8?B?NWVPT21nR0lZc2FzVlphMHhVdU5YbU8vb3FlMWlhOHhkMXhuQ3B4V1ZsOGxE?=
 =?utf-8?B?Q0lEc2RBMmtwZHFWN0FtV1J6eHJJZG02S0s4Qkc0UGEyV3NvSUV6aURRemVn?=
 =?utf-8?B?OThWb1RXdlZDVURZOHhnVTBvV25ScDk3bExZMzNic284aEpOOGJMbXFZNHB0?=
 =?utf-8?B?OGVvcTgxRzF5eHQ1dmJvMkhLSUxubXkrTWozanU4a0ZvL0NaYlBOWXFlSTJw?=
 =?utf-8?B?dFd5NVZlUktLNkFtM0tvdUpPcmsxNkNHUXQ5REp5cXlhQkJkYVhsb2MxMlZQ?=
 =?utf-8?B?clUwcjhZTCtUb3ZqR3NDZkdiUDZ0MEwwWklkWUNFTGt6dG1DQ1JVR2dZeWhq?=
 =?utf-8?B?UVZiS2dyRXYwZ3hZZnFLVENOSk9WQmRIUDd2WStXTDlZUkNHcS9Lc3hqMExn?=
 =?utf-8?B?R3NoR1p0M0JheUtqS0d5Rjl1ZFFDanQ5N09oNThZOXdhb0hNdGEwNzdRZHgy?=
 =?utf-8?B?dm1FLzVubExNb1NCeUhoT2RxUHB6VGFlcDdpNG9tM2Q1Z0VNdVFJYVdZNndj?=
 =?utf-8?B?bkhkME0wdXpQUHQ2NVVKK2U2ejNTQTVIS0IyOVVmdXorOE4yRVVXaC9NcXZV?=
 =?utf-8?B?d1A2Y0IwcEhiSFhRR1Uzck1DWk1qdVdnNHFtb1Z3R0p0SkNLQVBaUkRiQlBO?=
 =?utf-8?B?cFVhV2pVVjMyNzBISWpXWVRMRXRCY3AzUzZEUlk5NEdNa3pWOVppK1pxNzdR?=
 =?utf-8?B?NjRDbVdhbU9wTjNxbHNraVhPWW8zT3BUeCsxVm41UHg0eTZCempOSHFDSEU4?=
 =?utf-8?B?T3ZrUUZXUHh5RjhjZWJwajh6ZjZqMGZXbllsMitWSGxCdzNkSFBOY2FidHQz?=
 =?utf-8?B?OWdEbE9jS3pScGVJdXNuTFNZcFVxOWFYbmEwcmhGQSszQzRhTXAvWjA1azBh?=
 =?utf-8?B?ZXdYSVQ4ZHEyUk1waHN4UEJZdExucm40bCtlRGUzbEpiT2hJcFVBaDhxMlVy?=
 =?utf-8?B?N0U0NTgzeDBxaDVPdHlSRU9VS1ZQRlN6emVGRTArcUZ2VTc2S1h6bDI0MVRV?=
 =?utf-8?B?VnEwYWhySFpwNmlnSjg4OUtTSDlMK1lnekIxeEV0aEI2RXFFYjZSRXFsbCtF?=
 =?utf-8?B?cTBCOFQ5N2hGOUdhRlZ1bnp0QkQxOXd4MDBnZExXb2hMODh2aG9pZ1RnVWdV?=
 =?utf-8?B?Snpib1JtK2RTc2JUUm53eDIxaTRPUVJkRHAwZDAxRjRCaDMvQVFONUFCN1B4?=
 =?utf-8?B?bUM2ZEU5Tk1SNjFHbG1jZnBNU3JueE1ZMkEzWmdPZTNQNWx1WlhiZi8rckg3?=
 =?utf-8?B?aWt3QXAwVGJxb0FaajRreDd4Tk5JY3lEVkI4WTc2eVQ3NXR3eVE2aGxIMld0?=
 =?utf-8?B?Y28wdURZZkh0UEpkcGFGeGsydHNPNzRqWTZPM3lQbzQ1ZHlaUVVZMStpM0ZE?=
 =?utf-8?B?bDg0YytJeUEycmhZTHA2S0xKZUF1Wll3czVNN1hkamlGWXE3RTQwUlRNMzRS?=
 =?utf-8?B?dXFJYXErLzg1RmFJeW9JTzRxclBHQVBHUWc5LzZVUkwzVkt0RmxaZDBCaFRG?=
 =?utf-8?B?dmZwU3FBVGVjd25xTWpFeEtKRzZ1VnhRbGJkZWdmU3RUQTh5TDdiZjdidm9j?=
 =?utf-8?B?U3E3RUVvYmJSbGw4anJTenRaQnRPaVg0VzRwdFpuSFlRaXlYY1krb3F2Ylly?=
 =?utf-8?Q?aHwVzXoGJ0AwZuj+HlDTqcI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe7ae3db-2d10-4271-e77c-08dad1d39016
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 06:33:01.5196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7F8+koJRGxXvk0dKCkRUa59Dq89wMezGflxPdBgspG3p70IRA6HOq5vo5hzlH69l8srYXy7ZktGsQ/6aqTaqOucPbWri1BnMzLNmUnR5DF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4509
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arınç,

On Mon, Nov 28, 2022 at 11:28:31AM +0300, Arınç ÜNAL wrote:
> On 28.11.2022 01:47, Colin Foster wrote:
> > The description property was located where it applies to every port, not
> > just ports 5 or 6 (CPU ports). Fix this description.
> 
> I'm not sure I understand. The description for reg does apply to every port.
> Both CPU ports and user ports are described. This patch moves the
> description to under CPU ports only.

You're right. I misinterpreted what Rob suggested, so the commit message
isn't correct. I see now that reg applies to every port, but is only
restricted for CPU ports (if: required: [ ethernet ]).  I'll clean this
message up.

> 
> > 
> > Suggested-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> > 
> > v2 -> v3
> >    * New patch.
> > 
> > ---
> >   .../bindings/net/dsa/mediatek,mt7530.yaml          | 14 +++-----------
> >   1 file changed, 3 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > index 7df4ea1901ce..415e6c40787e 100644
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
> 
> Would be nice to mention these being removed on the patch log. Or remove
> them while doing ("dt-bindings: net: dsa: utilize base definitions for
> standard dsa switches").

Agreed. My gut is telling me this wants to be in a separate patch from
the generic DSA base definitions patch... but I can't say why for
certain. I'll plan to move these to the patch you suggest and add a comment
in there about how the type, description, and unevaluatedProperties of
mediatek,mt7530 is no longer needed as a result? Keep this patch as more
of a "restrict custom port description to CPU ports only" patch?

I also see that ("dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary
dsa-port reference") should probably be earlier in this patch set. I'll
plan to move that earlier in the series, before  ("dt-bindings: net: dsa:
utilize base definitions for standard dsa switches").

> 
> > -        properties:
> > -          reg:
> > -            description:
> > -              Port address described must be 5 or 6 for CPU port and from 0 to 5
> > -              for user ports.
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
> >                     enum:
> >                       - 5
> >                       - 6
> 
> Thank you for your efforts.

I greatly appreciate your help and feedback!

> 
> Arınç
