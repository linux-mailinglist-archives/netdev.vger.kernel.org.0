Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACD75476B9
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 19:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbiFKRL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 13:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiFKRL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 13:11:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2114.outbound.protection.outlook.com [40.107.94.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688E16154;
        Sat, 11 Jun 2022 10:11:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXP9ESDIm+DSFG/etSEb/Ul+EyHGwM96QrW7yzZAKgJv0HO8bJBHIjCxYM8ALxPUCXp8PcX/bMHfjtet5Yipl/E1AVQKKU9QphTF+KAwRCjnYFMlFkZ5KQ0N7EB6NfOGfOXiBfT+zACt4gTUfQspbN/YGDYE/suZaRpzlktWNdwSVeViVCYho84xyGK1T5WBnKTXJX01eRNJPmGxFg5tHSDPXHwreGpd6+bsFfmI8UntTc+QvLC3WLnDCYgxLiVdxeuzJDxtoTiGATFzN9b7iKAK9IhlSN4pTWaHw+f/BB8+f0bD5Q1eBrd8vBbdFoZRhLJprpVTpxsIlt8KYbGYrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjgTyrNiQVmAtOIFTgOQG7Ne+pdk9hdtNHpOuAiyxrQ=;
 b=e0Gs5Jr2EyKui+wkrKSmbjeuuglSEuD+VcGTEQK5ginaaPtKWpSobAd2buvO9ZFNB0xpWTjOjrxBIP+R1qDouAAHF64Jwj5rnDI5VzJigpczfZtn9H9fWDMtT7BBXHUKSqc+FXp4xcljV+m6f3OTdBUn7DHkqL/depc0+r/c7KviuwIv1IZoexV2gkLC41mSB4G7vMwMweWf5iqGLYMuVSrcHSsgWa99GX4uDxurssKeKk44PEWHi4K+FLG/6ozq768lkfgSY2ekayKuzwjnM3MfYt20c6pmtlnyqpjc5W/PctYVwu++8MwTV200HiUpNjVk5wjzAlM5Hjm8SKYIRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjgTyrNiQVmAtOIFTgOQG7Ne+pdk9hdtNHpOuAiyxrQ=;
 b=TCV21UqTUs3nKy1B0FN/8JCqkaEPClSpY15CIn1C28lodcsQNsIdTiDX0FrkHe5qGSOliI6x3Pnlqm1Qrz4M66NrL4X3vhoMhEugW4k+o8PdnFQCqSt+4nr7LPRuuS9cENXc9HHZ832DxdM5I5SGKSh6OBVkfFeTW82vrnVMAEA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3499.namprd10.prod.outlook.com
 (2603:10b6:5:178::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Sat, 11 Jun
 2022 17:11:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Sat, 11 Jun 2022
 17:11:54 +0000
Date:   Sat, 11 Jun 2022 10:11:48 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>
Subject: Re: [PATCH v10 net-next 1/7] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <20220611171148.GA851137@euler>
References: <20220610202330.799510-1-colin.foster@in-advantage.com>
 <20220610202330.799510-2-colin.foster@in-advantage.com>
 <CAHp75Vc+V3APvBO8rJ0awu65iPbEoYKn5bn4GhC0DEvC4DiKiw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vc+V3APvBO8rJ0awu65iPbEoYKn5bn4GhC0DEvC4DiKiw@mail.gmail.com>
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ec4e7c9-47a6-4b16-fe3e-08da4bcd7bab
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3499D7091B626A82FD431EF6A4A99@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fF3uiSycn1jHekTYP1qLCNCnsrynrBWx0DOgbMMDK3gzXanyVsaV491r9i0NgWQM1VbYtyWMlm9PkZLE1jeLjZjSZ6mTVlHH7LuUM1RHNdvBKy0hfojAZ77z3d9FkG2Y3ojbnmmLbDVwe/OXDO1tdPhIH+LPCwn8mxCpELRbLAR/gt0m3TwKKaL0pqYB3WwFpiMJRljzqjx7ozmPXD/YQJNngSvAF3ar62AHYdlvrzcGoJuk+bzrc9lRm86udCo0epazqDiRicQ2J72x7RqtqDliMqmKhQEvLYAqjAFTMS9uADVFfKcSFMkJCWV8Isn/FuwN9lOIl+h2RdusoV6KxSIkj1EN3kslOU9esfG2l0VtYG4gvgrSUB/yN4BX2euZnQN7l854LqdmzWfcSURBFdHyNrsdsZV9d8i+QzVgJnVSS1OwhglT6E/NMUG2i+5tiYMP6PasSlBbguR/e+H7KUneV3Wo7p98X+xV3VDTXnmeWjB3QnQL38l2YLbZ0iX7bZkzm+QcLzZ5BuvACSLYH5EgOFuksVbqy5UhqzJAoDGR+yQ3rTPuM7/I1pYLMl6za4w8j4KsHvpndYilDrKIwAQJZCeDWBpuqF7QZV9Ja9GjJHnNliWjoJlDcM1Vo4xm5S8RIsmoDfW9JLZP5zOFF8emFyBxv0wqfvscN+NJxkCsYUyjzZ2CByDIjT6Ho97baXwvGmC5/jvZE7Ix1189Kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39830400003)(396003)(136003)(366004)(346002)(41300700001)(86362001)(33716001)(26005)(316002)(9686003)(7416002)(5660300002)(6666004)(2906002)(6486002)(8936002)(44832011)(83380400001)(33656002)(53546011)(38350700002)(1076003)(6506007)(6512007)(186003)(66946007)(6916009)(54906003)(66476007)(66556008)(4326008)(8676002)(508600001)(52116002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F2hlRyghtkRM1r2vOMq0QB8Dp81xiMOv/sJJhJtlqoevsYXRrKoJVkZA03Qv?=
 =?us-ascii?Q?iGb4BfkcnKxoGoh4Zry/EAlK9r/BE4i1nsW6mBPBCtgzSz7dxXv/sG8uDqVo?=
 =?us-ascii?Q?OE2mGSzFUONjVMxbxmk3gBB3p3E3yejPRwnhEELPvdGHjDrEk7J9t3/+oK+4?=
 =?us-ascii?Q?7PflavQ6Hx+QclkhNpqlaq+hPH2kB4pB+nhQf9DpF3tXxOc4S4oX8pGxbK7B?=
 =?us-ascii?Q?Y1nRog0sQApWzzQhuD/8xgCsWl2c091YgNvEdR1u170pBH/rY5IFZj8wO/NW?=
 =?us-ascii?Q?0y36Mdd4cvUdhx5QXu2Nu6GVVZnlr9wEpt4prXWMWDb16kcWE9tSnDgNGwt6?=
 =?us-ascii?Q?uoFicmi1q6RbSj7wT3PoRXBHI08JZwlw90nEAo0njpl5gXO88YoDA6oJFPMo?=
 =?us-ascii?Q?YnU2IOfc8npQwBDdWO6h1wfTKCY2QYwxVzBj/UdoIvXHQoDM8nHMLPgtqodt?=
 =?us-ascii?Q?Eskcl8i8hKucPipq+HIMbQwGKM+j+Qw9oznSa3RGLA9sbn1xsWg2AcQJ5bXL?=
 =?us-ascii?Q?PSak9FtEH2AB7MwQlUubC3Bx3WjejsH8zG8ex+539Nnw9EWbkQo81YSVTE0o?=
 =?us-ascii?Q?CAgswVjVjBfe6ze76VzC37wXl3NooSIrGtAp+BW1drCGGc4VJHwjv4mmoFiM?=
 =?us-ascii?Q?YJQDNyCQqB4C9zAoTYb0Su0J2DeZwgAjRaS5LvuxYGDF6Ca//W75xvaXcoyN?=
 =?us-ascii?Q?gAAi1xaCsgTumqpjGgxyBFlZNl6Gau43BmsnYsoSi7rZHhaqUYCeg7hM3Jqk?=
 =?us-ascii?Q?FNsVozqpuNAnVFpMy4H0nup+meq9YJBXlNlMmtCSpmeb/aVVGMqXMmGl0+VV?=
 =?us-ascii?Q?c/1yZTrRD+1KdEtcFjGQfmL0hZ51y1fts74I/vT5gpXZSZweQdpywKeQNKVr?=
 =?us-ascii?Q?OzD+aEAyy3KkRn5wy4Q+zbaxFjWrSEBlVg0y9S2D4K2yPkqRlQyUO5Cpqkmg?=
 =?us-ascii?Q?cLDyuBild5J7EcVhmcema6D3dN2V7a3B+lE9880p9YH26huFGV3PuFsJjdez?=
 =?us-ascii?Q?DSQ54c2gdetXfuYbw0cjWu2cJ8X3Cu2OHJ5YPUwGWDt369yoVfL9qCndxTIB?=
 =?us-ascii?Q?38VyjtK80Q22FMV3KiLRonUhI3oDhwb/XoaAXePc7veQz7Pi8paVrfhZ8lIO?=
 =?us-ascii?Q?4ZSdzIb7mx/o0Nn6FQxBnpWGLm/hYqBQdJzippsV78IbZkTPvhxVNFp/ZE1G?=
 =?us-ascii?Q?gJK48XeP6lK1N0q1rJSarzzvsTsa4IR5KO6qfYPHE8nVWn0fcOM16RLrM6sJ?=
 =?us-ascii?Q?9FxTB9wUjPyLZxqJUGwgPP1rzu0z6IVlYwEPeFnPgtKmlYYGv7HhwKFnJafQ?=
 =?us-ascii?Q?WBK6v49/rf38SFPcXvuCfz+4IufdrfcYmw2AZsu2dQ2744F1Fs/sJu9sOvmf?=
 =?us-ascii?Q?G+DHjcKoY3ba6MXy6ReD2tPoxxEOtsrZiUMBTDSOD5vJYG2bh+TGH2MsWf34?=
 =?us-ascii?Q?l7UBwYI31jn3ZhPNpQwAHUBUPQk5mR5fhhZ57aUFuGnAfdaxAzxUpEQQCh9I?=
 =?us-ascii?Q?Zk3APflFYut345bpJ+6vSonrk38X0TGFYgpegB1zjSdbkS/cKVqWbBM2W8nK?=
 =?us-ascii?Q?8EpdhUC6+XCw5NJH73Ge70PsbM5NzG+mVcepZvUuyYEKB1/efGzOXOnxWCeY?=
 =?us-ascii?Q?GLsBeB/9kv/ElHyaRE6Co56XtzaFOvUMw2uGb7Mis9rMOaWm6ftMlarhxTRL?=
 =?us-ascii?Q?ntzSdbCA6U/z25ru/1jmstZi2oaPM7PqgSrLYW8ZGuX5iQ2YpWAg+uGEgkgC?=
 =?us-ascii?Q?ZWWhxzqnVw1gcNcfqLLh/svDZ35FE2TmO0ozCHFRzFRd/Prb+VzH?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec4e7c9-47a6-4b16-fe3e-08da4bcd7bab
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 17:11:54.4094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H4aXLQuEQPYKC+PFS87zqc9my2ZvisloQWgavWNpqE5HrBkDqUAg1QLcvkUMB2ujHYeilCuHlifKCgNn/du76dl6f0yAk8N8LCGipSS0aDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Sat, Jun 11, 2022 at 12:37:26PM +0200, Andy Shevchenko wrote:
> On Fri, Jun 10, 2022 at 10:23 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > Several ocelot-related modules are designed for MMIO / regmaps. As such,
> > they often use a combination of devm_platform_get_and_ioremap_resource and
> > devm_regmap_init_mmio.
> >
> > Operating in an MFD might be different, in that it could be memory mapped,
> > or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
> > instead of IORESOURCE_MEM becomes necessary.
> >
> > When this happens, there's redundant logic that needs to be implemented in
> > every driver. In order to avoid this redundancy, utilize a single function
> > that, if the MFD scenario is enabled, will perform this fallback logic.
> 
> v10 has the same issues I have pointed out in v9.
> 
> Please, take your time and instead of bombing mailing lists with new
> versions try to look how other (most recent) drivers have been done.

Yes - I recognize that my decision to try to throw in a quick fix was
the wrong one. My apologies.

When you mention looking at more recent drivers - are you referencing
the submission process, or something else?

> 
> Also pay attention to the API design.

I understand if I'm making a helper function, that helper function
shouldn't change the API if it can be avoided. Hopefully the updates I
suggested are the correct ones.


Thanks again for the feedback.

> 
> -- 
> With Best Regards,
> Andy Shevchenko
