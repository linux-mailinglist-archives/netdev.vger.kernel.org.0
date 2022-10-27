Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4CF60EEDB
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbiJ0D5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiJ0D5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:57:12 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D397B99393;
        Wed, 26 Oct 2022 20:57:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcZjiUIE6GgUb/4UBrr55GR4AOyLybUUyCryI8vgHri8wvfmmxAvV43orQcl81H91OQH2YtL9t7nJ85wmOkYJgWSz53bZSpc70X2UaSgd3N5sJJpvq+UQQHvsr7AUZW9k9IYAp+ML4C1NMlUnGTiiLni7Rh+GfDe1E7oh7edPeDCYlnKQ6fvZoCoUYQvGKUxqHgPNkUG4lUaAd5DhC7tT0MQ9hNABIXIkXjkaiMHZIbLi8E3Muk6EZKziAWn/7iyUPx/UH/cwkh7fRNXQcePgoaPwt8yZoK1rBhTiBYIE3orrz/ogAX6/54urX4bmum1XSzq80Sk/xoCHjn9Mlu1eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9TytjepmL2F7eN6Ky07gjGB40djEGj1r/Jd5FWBgwU4=;
 b=edYid3zNRs3t2HBlLjpKrCvFLWvkV8g/n6zBO/8GgPDn9RhcDh9GvNYhNP73diCXwiSRcRA36BPsmdmVL3HddRX4GcQB77fz2mMwq5TM0TjaNHwlZqLdDBoyM73ntMrfuRVfh591RxWy1HBFT19npCcQROatLYdQcQlj6PQOKJGQrcCWaOxA96pyxYBYMrGLelL93Wq0SG97kPCKEh7oOSRqITU0Y1bYipIWkB+RWfrB/hhSjf0Eyt71//Ad903ag9SrJNM7QHSPAYMnc6z26Vr8OEbNkRu3pK0noZsLpDpT0Sz6bh6GBrkY63iwcRvHksqJfNmvHt39PkU8B43Kbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TytjepmL2F7eN6Ky07gjGB40djEGj1r/Jd5FWBgwU4=;
 b=XJUusFkUGSkb6KfuUbNuqVVfVgDhJ/SO9iXzdfO+AMdD1kjHNqyGebwqUO/iwhkKOmJoWxgOOqBrmsts7AZVIMgSSRkxjYPn1VM0NGm7teEnkOV/COYcVYnObgpkJh6jHb7JsXlYfu6V0imeroT1XHy39Uh86R9WSsh84DxL2h8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5631.namprd10.prod.outlook.com
 (2603:10b6:a03:3e1::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 03:57:09 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492%5]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 03:57:09 +0000
Date:   Wed, 26 Oct 2022 20:57:02 -0700
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
Subject: Re: [PATCH v1 net-next 7/7] dt-bindings: net: mscc,vsc7514-switch:
 utilize generic ethernet-switch.yaml
Message-ID: <Y1oBjtQeZlzwMfoD@euler>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-8-colin.foster@in-advantage.com>
 <20221026174704.GA809642-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026174704.GA809642-robh@kernel.org>
X-ClientProxiedBy: MW4PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:303:6a::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SJ0PR10MB5631:EE_
X-MS-Office365-Filtering-Correlation-Id: e61922c1-d781-48b6-1db8-08dab7cf4fd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qim9Kwp76gpsKgz+nKTepvfNALzH+1KNTzdZYW6NIbk1iCpQFzhXaMSacx7TVNA6qGycTaEZuEdOwOcfLG3upt53eV4dmzquOnFcN8lWoWPQOuWb8vMVCqWE+OWhAWsZR904WAnvDMGquTJt6U5K3i0HPQZr9fVLAZW3Wo9Iyo6mEgLBSTJO9YMkiWE8QUjim+1CNX39DzAlpdhMBdJS8rbojFRVDQOdwCsj27JlPKLUXCtzaTti2LavrNtCNHHbx8p1hlvbpUl9Ozw8XFi1XT8tQEbyoY6ERo15NGJXTk1tjJY78U19lplDSgUntjxBU7HlkNIFq9OPtHthFwDn/ZwmW+dW3bhGTlRsEIvPh++cQ/9iTzibKDjcbsP80V3M2hpKWNeo1fmYadH1l21SGkRjc/0Sjhv9tQaLtdTo3f7ySp0RZPof+SZ4Xz7iJGpQscsfue/nCV2CHTJa7a1UUWKPDA+4SRDLOtQT2XcKU+xRKkju/fpqJKoRLkFJoalTga0vFLEcHBbUUowIUUa2kwWpXPkrTCbDloDqKph01x9dbFujgROinhICtNXUvQnoj6qvjh0zPKmgPEnzZQJU4HNlx+2Brom4xzpcsFFynI20wrK3sTEV9iAnTftfq8DxOqcsueA3+HhLMyi2BOM8dRI2LQEmlzMrykluDOqQeMX+qHWaZ2NVeTI60qa1RKxmgrDp2gFAuol13uulsnBcbr1JW1bqwzfRCrcoBR2z5H4PlFssh1tGHZuDnqoA70qtm6gIqvYuCZWJtTrOHZOh5uDidkyjc/roP9EFS2+E1O308LirjXuZ2Neld6bYFoFE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(366004)(396003)(346002)(39840400004)(136003)(451199015)(86362001)(2906002)(44832011)(38100700002)(186003)(83380400001)(6506007)(4326008)(316002)(6486002)(6512007)(6666004)(26005)(66476007)(9686003)(6916009)(54906003)(8676002)(66946007)(66556008)(5660300002)(41300700001)(33716001)(8936002)(7416002)(478600001)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3mrh1udW5gb2LUvNBbAJ1ggPglZMsXt4vZLKwKUPczkrP0W9V4++b1SaAqp2?=
 =?us-ascii?Q?Gj9GI2LAp75YfS0xdyxl9ojT5RMW62VGdtTkXCKCsm6Ep6bRU+eJh8T7Bkeg?=
 =?us-ascii?Q?suMVAvUmzaZGK0XY64fPNo6jb6IGExmV+q8acZEy+HXXQjFdQ5uFAoNWV0+U?=
 =?us-ascii?Q?QjhtqwFzKaaax2QuIBNsTHsgByPBnfc1iLz5Os2Ip/nToxxeXlAwc81cLGjW?=
 =?us-ascii?Q?TAYaD4nUq5fi8eG7rTmiIRCFYTHdYhNZut+B9y3HKEzZW+jv+r7gQak324Vo?=
 =?us-ascii?Q?kSP5BlvEuFadfGejaO7bJvmfUG4J/JvycjF5/+tCXksiVB87Y2UsJRdOPIy9?=
 =?us-ascii?Q?kikB7pDby+c2ri7nx3gvMm+lWAZOYUeXmPEntDjvSc8NKoSlh474beENwpan?=
 =?us-ascii?Q?9aF7ej5JiPNcj9Df9P66XOZJmdSh6P3mEnBdcRVeVcrFV8N5/320wBmXLKJd?=
 =?us-ascii?Q?gBpnixcYGTRHNmV8RfURnvUqkPo5vtUsdA+DfwKfW7v2G0Zfa4NfbymSZLyN?=
 =?us-ascii?Q?hbypj3UF85j5safJ+tC2pTFTTfIVs+0nGXHJjCbcWC+TbfG2mpw//ioLKu/o?=
 =?us-ascii?Q?2jVyCqzOwxSURSPzEaYWevhi9G+ikU3ZakeyAfncaNdAT/XV+/HfZyJp7pXX?=
 =?us-ascii?Q?bnFcF4RD44BH7TGAkAYZSAvW/zmYj1Q6R1xSVuvnx4QzBF08EjdL39+3EzN3?=
 =?us-ascii?Q?+PdKPadAt9AvAPVB9Ntn6KvVWVR69oldQeKR1tazRZ4/9G0+5LWNLdbVaLCz?=
 =?us-ascii?Q?dB0uvL+k1hjiDLgSzOebk2T6uWYRZd1VoWsQEQEITNxQB9WZYQh4L1POR1i4?=
 =?us-ascii?Q?JLYYRvjPvrKwKDA6Wsk2vTZ1+UeA82qiOHy09rI+8P5rC4dzExR2KOofcbxg?=
 =?us-ascii?Q?gtIJYZGgGIRajJuiSYoqUeAaVO/2tVUnTFRSZQwH49qcsRSs25xoAvZ7l+xL?=
 =?us-ascii?Q?Eo5k7j5kpyxSHhVXWOki7Wcda/wwWaM7JSOlB3K7j5C0fHi9dcPmrQqBLHkp?=
 =?us-ascii?Q?I2DySD4GBNKfXXPYuTP00GvjgnbZrGgLA6KXYzixTjVf7fzcoDQjXfA9eMIk?=
 =?us-ascii?Q?nH+u/5GGzeAMxEpRNpenfl26An2GqW16UAdlxqtvLcBbvrS0CZijSNNZnp1B?=
 =?us-ascii?Q?bCwWo7i5MZHwSGgMysEGhcuGcD4C6e/ES3Ky3DfVvAGXU4aQw9PDcg1kGj5i?=
 =?us-ascii?Q?5m+puriguDyqCJR9LPvvepn6esJv90975uZyKRMSKHlDVejyCMP8K5sjP1UQ?=
 =?us-ascii?Q?AYe3ghr4hxMr1VKavwgrwuAAsb93+ZVrGgpVQzreI3jwxncyrV3Q6JxoWrL7?=
 =?us-ascii?Q?4hgOEfGR6ID47OpDQYWM6frUBED1073cBRIAEeFSQyri2KS+PS7tRmo0hnnZ?=
 =?us-ascii?Q?uFgKpY7/Mwrp+1BBZ3UDozhVQ88/v0tCyfuL9l6XMl6C/cdtGS4oG+TqDYPN?=
 =?us-ascii?Q?ru9/mpG0ucuNnm9dbVodsVbM/qecIR45u4mIAtVW/7QBZz56WO+TaHn6maX0?=
 =?us-ascii?Q?8TGAiPsc+uSRUY67TY6Gc1x7BvbimAFIw7C+Ao9mwcHT1wMXQ72iXbAF4BOX?=
 =?us-ascii?Q?aNYWPeB69sY/BlBIxLfifq+L9pm5mQ7xU0uzdeasfF6LlnS8cNZJyzaozUA9?=
 =?us-ascii?Q?JaSk5DeoJor6biUgWv5/SxY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e61922c1-d781-48b6-1db8-08dab7cf4fd3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 03:57:09.2473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +aqkp3kNrPyO1Ga3d2WbblIq+AEMaDPoea3ZWhQwNYcadxmP8eABXjTb3DIx0jQn20tJ4s+YKO9wBtbWk+JqU+3BmqMTvGe5guFPchZTkBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5631
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 12:47:04PM -0500, Rob Herring wrote:
> On Mon, Oct 24, 2022 at 10:03:55PM -0700, Colin Foster wrote:
> > Several bindings for ethernet switches are available for non-dsa switches
> > by way of ethernet-switch.yaml. Remove these duplicate entries and utilize
> > the common bindings for the VSC7514.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  .../bindings/net/mscc,vsc7514-switch.yaml     | 36 +------------------
> >  1 file changed, 1 insertion(+), 35 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> > index ee0a504bdb24..1703bd46c3ca 100644
> > --- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> > +++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> > @@ -19,11 +19,8 @@ description: |
> >    packet extraction/injection.
> >  
> >  properties:
> > -  $nodename:
> > -    pattern: "^switch@[0-9a-f]+$"
> > -
> >    compatible:
> > -    const: mscc,vsc7514-switch
> > +    $ref: ethernet-switch.yaml#
> 
> ??? 'compatible' is a node?

I need to look more into this. The compatible string should remain
mscc,vsc7514-switch, but I think the pattern properties should
probably be updated to "^(ethernet-)switch@[0-9a-f]+$" to match
ethernet-switch.yaml.

I didn't think the ethernet-switch.yaml could be at the top level for
the 7514, but I must have been mistaken. Either way - not under
compatible as you're pointing out. Much appreciated.

> 
> Rob
