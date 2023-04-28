Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9D76F19EF
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 15:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346346AbjD1NsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 09:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjD1NsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 09:48:07 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DC9171E;
        Fri, 28 Apr 2023 06:48:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeBEMNnZpjuHGwALY8tjh/vYK8N0/1VZghuZ3MRLCqyZ7WCqGu1ADwSAuVheunka7txOJOJr+P9Jgld/0XZs19WssBAhbJvSg+WIHldrzd9OdwAE9VVHfv01EmJuDuqZYBmay691Fy6mXxpcsgjrFyXC4AeJBHt+vYR1I6db6GfK+km7gM0KCmTM8qtulRYvQGWr1ldaCubDPO8cevZyOTJeDbUUp1vVAHab0Anh1R3BKjM++tiBP9Uzg8mXOI+s/RzBIchorsnSZmFWMqP6RjGCbFy8v+Pm0nLICuA46SDUOGgicTIJEmuH64ah8hVn3Ig4SgSpOr4hwDu6FyLWwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Of1HD/t+Y25GDQ5qFM4/JjFQh382tDMVq+jAJ59YvfQ=;
 b=OKRsuihTzIVMWAJ71Snx85Zb0XxRO/TZSYYbpjs5cujgrkYnsbGU59wIbFXxlaBPpLTJmbO+Ypzj2D6bF6VrBrzg+Acqhmm9p3sSw22D5AJrcUpZ4OqJPCthOztGrXkgD6XOr87ByJeIxp7jjQmmbPtHOnEX4T02dEPDVM9M9o7PVuL3Pof2Ci/6sFuEbSbmqaFF6UoJiepIevH0pKMww8JJLBC6aaE37dCUAYJ7jys+tZBpWW1FjTiEyn+y5Glf8zU77loXf6DiYJSZCOahi2Rz+4YB3WSVIIJ3G9OpWGI/cMSKmG/p7v3xy1S453hUKm2qoNcguuVbbhDaYTNIHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Of1HD/t+Y25GDQ5qFM4/JjFQh382tDMVq+jAJ59YvfQ=;
 b=RpIgKxtcskO1Eca8Ylps1OfNJVFMHIJnsU7I+0lgoW3NW+nPb2z5zNENVd3hBKgq9LboViySppkuVAA/wXY/kN3lD22eIX6eoibv+n0LsOvfiiN4t5RrF1HnutFLg9p3mcigKWKDbX+VRfFnFehxJRlW5E/y635EOQQLAA9YD68=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4487.namprd13.prod.outlook.com (2603:10b6:a03:1d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 13:48:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 13:48:01 +0000
Date:   Fri, 28 Apr 2023 15:47:52 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Md Danish Anwar <a0501179@ti.com>
Cc:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Tero Kristo <kristo@kernel.org>,
        Suman Anna <s-anna@ti.com>, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch,
        Randy Dunlap <rdunlap@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [EXTERNAL] Re: [RFC PATCH v6 2/2] net: ti: icssg-prueth: Add
 ICSSG ethernet driver
Message-ID: <ZEvOiMSIIYG6nmsu@corigine.com>
References: <20230424053233.2338782-1-danishanwar@ti.com>
 <20230424053233.2338782-3-danishanwar@ti.com>
 <ZEl2zh879QAX+QsK@corigine.com>
 <9c97e367-56d6-689e-856a-c1a6ff575b63@ti.com>
 <ff6fe35f-ca4b-a48d-777f-196b771a14d3@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff6fe35f-ca4b-a48d-777f-196b771a14d3@ti.com>
X-ClientProxiedBy: AS4P250CA0006.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4487:EE_
X-MS-Office365-Filtering-Correlation-Id: cdf81be2-8fc0-48b9-ab7d-08db47ef2eb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NYb8W0GjOdJQc5PdtTJb+CquYoPq23yuUrVIl9fG7Ym6n2V/Oqr7s/qGna2j9mULo+0gz9CYUX1fnxViO88gs6rdIjz3UM0duGMYBqY9dxnfO3JelsrHPxKVxbqpymE/uu6wBiykXr4feT22C21FRzh8hmByFdkP1Fq/iTYJTQxFg+ZZsIlGGBzt/DxcgTs6zmgjqfEUgpkfda9Uvv7GOlgQ7BRthOZcOpeu/Co7XH4ua7R041VV5Tp6CNd9p/zJOrrZ3JCrjerTib8J29E8s5Drkf+fvuffRDkXwaxTgNpy8fx02KBmKedcQb+qUQ0ryn1ZAfpS5HhMln/1gLZVjSwg+XjIW5SaiOaCe4z1AzcvwCOn/th8ix2Lqyt+D3ON9Pr3h4K4SJiOAkC+bzgRl21TDUivdZAFxiCTJ09I6hCgGneyYn8MtPHVQXKQExqaazNO1wc+wC9ON1+v+97eQxRCpajDJ/ikTZ7wS6oS61I/vxpFa5XJk+UN3s6vBNwJtyGvjOU+mhqY4AjDLp3RVDpSR4acZgu2gzThjyc0Sn1Og8hCTfqK9+d39K5L9EYjOtzJuiHtsFvLgheikHpAnGDZmI+90RNeT1RZ/oi3NIY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(39830400003)(346002)(136003)(451199021)(54906003)(478600001)(5660300002)(8936002)(8676002)(36756003)(86362001)(2906002)(7416002)(44832011)(38100700002)(66556008)(66476007)(66946007)(4326008)(6916009)(316002)(41300700001)(186003)(6512007)(6506007)(53546011)(83380400001)(2616005)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SjBV3PZKu8MqXRqdlKZglRPC/KbJlJZYIcXnQSRys5xA45/z3saeym4IechY?=
 =?us-ascii?Q?KkGc1dpfySdO8VwMUAM7w6dGzzt4O4ZXkeurN8vXU2TdijpAtrU9nSFzdl0p?=
 =?us-ascii?Q?SKUHtH2l4mJq0se3haM/9Aft1jfDVb5AGHIq+bsYzHT6PiNTAzRwLhF17aQK?=
 =?us-ascii?Q?wk+lRW3FHB0U3njvppb5AV4/TNiL68QtNStBkeXOVCKBgYHDdCFvqchJCCLK?=
 =?us-ascii?Q?pDNzKW9tM078v8esmt87hpQ1hpbtIWEZmJSHhKDHKKdgXCAwmCqN+IcOXCse?=
 =?us-ascii?Q?3JmUdIH2141w6SF4Q7dEjBUAXnLTnG2TxBVxE+qqAQCcTQhqai57EZ+EU+WM?=
 =?us-ascii?Q?bRZJ6xxMWI1L26yMoFmZhQlmomORsk+MJJ6mFC9NB1qvj0wqWYTbSsJj2l57?=
 =?us-ascii?Q?yIcib/EEQmTY8cBiUlrpC1x5DlYi2oPuVBa46No9Qm2Panl/tZN8/SdxRPk3?=
 =?us-ascii?Q?Qikj1BRGs/zpxr0mTs27Bw2GXt021/k5huvcax0yY38EILoNrA3uSUl2x4f3?=
 =?us-ascii?Q?M6LSRfyvLnhApoon8cuinwJQUsywngoRpvAAus5Vx8uiep+36XmucL9PBjRk?=
 =?us-ascii?Q?701Tk4gTitJK2CJfqRZvfBUJDZx7fbRC4ZpeXcBShG5zZAGol1BTuYVPYe5L?=
 =?us-ascii?Q?+EjZYviIqp/qvwm5blt3ZairleOp0/D+N19EgWxkvwwlbegmSNe1HXz8rd/y?=
 =?us-ascii?Q?N96W3jlXIB+PkTYY4rHpU1TCn50a7T+K4RCN90Sco7YxeCEn8Kb0jQBNVFtL?=
 =?us-ascii?Q?77MyKveLzO5aOsgUl4H22+WuyQIiI5tPnDeMvjKfIW4xfjG1dk2UcxEXdi0H?=
 =?us-ascii?Q?rwhjKtXuHXiy6q4ofI9oBd3l+1SnKjeSi/uQvYP3ySekuU7NjeRH1peOT6yR?=
 =?us-ascii?Q?/4eKsVjoeLtVYAbGf/qHT0aTsYhA2ulVEbz/bEI+WidkfbPBu7wvYJ1HsFEm?=
 =?us-ascii?Q?idf6usyC0yI61UkhRG6Vb6VloSmRp/QDVy8toIh+GoJL2q3n962I9Fa7Q4MH?=
 =?us-ascii?Q?qKntc3WL9aPFWtplNoYPEx2FNN/Ahakz6MP4LP5Mx3yfaSx3kIRJ1652hY/r?=
 =?us-ascii?Q?8eeEfwvRuUu7/e9/XqRVoR/arXfe4wZptXlzG4R121CUR6n2s7HPKLqWD7c9?=
 =?us-ascii?Q?ksWMgQotQhLpa3oIPgyg/UDGoBZhuN2AEMMPaDONQoMYaJJQB1zPgIM/Krrk?=
 =?us-ascii?Q?E3TUXfiz6bZo+dPj9ghAW5HOh7qqpeNWVLIg6wG8eY1tVUGSjTtw2H5n2xps?=
 =?us-ascii?Q?GMpqadlVnTUHxXJcg4RdhQ8wpsrdJeZVishjISSqtTPb5NxM6KAXY4urJtpM?=
 =?us-ascii?Q?+QMiEDdqZfkmbCEJ0AS1ldj+6NyitaqwUB+y8/GjX5ptxszLLYvJoYlGuqtr?=
 =?us-ascii?Q?mPUACoxrRj5LS0fAaWpyKDC5+5NPS7aIHyZlvDCuWswQlZ7xvWOH6BOXRkxP?=
 =?us-ascii?Q?NR5FDCDZ3NZ88equ9oxqv66C8eMQdc0WR44xWxemE4U0RMJj2V0fbSc7LhtR?=
 =?us-ascii?Q?rDzLLkoQzulRkeB+Q8nO6XXQ8jdYfywFyplzfVjzyNcx/Y1nXWPISAZFqnoN?=
 =?us-ascii?Q?z3CKhsbj9qnh8A7Nr+wOA/tJfGnzCC0byjbkkyfISRSFMcd6usZ0qukn6jbY?=
 =?us-ascii?Q?XNOQIw/84JjcBDjJZtpjA3luCbP1nPKrNnObGSXoKcTPwjAt3LiCAWzaPVIe?=
 =?us-ascii?Q?RgKnUg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdf81be2-8fc0-48b9-ab7d-08db47ef2eb3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 13:48:01.2347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VvWLNx3dqU6BT5q0+DPlcqFRuUdyglnLs9s6ATTnU6ELUHq4T83fCOqXqku6BPMcnjaoRkFTXiqsRbb2zpNh0uHdY0BhUPdJnU4DlxGUzus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4487
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 02:36:42PM +0530, Md Danish Anwar wrote:
> Hi Simon.
> 
> On 27/04/23 12:42, Md Danish Anwar wrote:
> > Hi Simon,
> > Thanks for the comments.
> > 
> > On 27/04/23 00:39, Simon Horman wrote:
> >> On Mon, Apr 24, 2023 at 11:02:33AM +0530, MD Danish Anwar wrote:
> >>> From: Roger Quadros <rogerq@ti.com>
> >>>
> >>> This is the Ethernet driver for TI AM654 Silicon rev. 2
> >>> with the ICSSG PRU Sub-system running dual-EMAC firmware.
> >>>
> 
> [ ... ]
> 
> >>
> >> ...
> >>
> >>> +MODULE_AUTHOR("Roger Quadros <rogerq@ti.com>");
> >>> +MODULE_AUTHOR("Puranjay Mohan <p-mohan@ti.com>");
> >>> +MODULE_AUTHOR("Md Danish Anwar <danishanwar@ti.com>");
> >>> +MODULE_DESCRIPTION("PRUSS ICSSG Ethernet Driver");
> >>> +MODULE_LICENSE("GPL");
> >>
> >> SPDK says GPL-2.0, so perhaps this should be "GPL v2" ?
> >>
> 
> I am getting checkpatch warning while changing GPL version.
> 
> WARNING: Prefer "GPL" over "GPL v2" - see commit bf7fbeeae6db ("module: Cure
> the MODULE_LICENSE "GPL" vs. "GPL v2" bogosity")
> #3602: FILE: drivers/net/ethernet/ti/icssg_prueth.c:1866:
> +MODULE_LICENSE("GPL v2");
> 
> Should I ignore this warning and change it to "GPL v2"

I guess that "GPL" is correct after all.
Sorry for the noise.
