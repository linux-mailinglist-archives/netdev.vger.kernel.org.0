Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA577588FE6
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbiHCP4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238383AbiHCP4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:56:38 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2092.outbound.protection.outlook.com [40.107.243.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828A06326;
        Wed,  3 Aug 2022 08:56:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtgkwMPV6crjnjMZ3O4Efhq3QZMF6ytMHjHtuYRfrFFNzva2kpWhB/DUtYl1EZDqoThtHaExBmv8iDBn1jZ6fOL01CinzSGm6p87FwEAv6ZXrtDTP0A1TmjjjFVOr2hFE8hHe2+9QgNqFuKAWZ/s1X2uDW0W461tM4gMBiMUVuGi6/54OmRvqX9aFflNZUtC40vBpdT44pe1yuFk+qSWAV4eS8rJ6OTA5lBuBNSp3Ame+6YoK/MpkFfputAaY1NFWkk7D++F11BzLqLkwdATcTWmbb/4kc4ny1DazC7JbDbempwLyp9hS9qv9bwI12rMnXDRUj1KeoPAjfrdLJ1y5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdhm9oP38ZbOdH5FzR+09PgcD5jaOwPWHQ8aCn75ecg=;
 b=hHBUTvWJg1xOVbivgCls6GICiDdQ0LdbcG7bW/0cu5KhUNUiHL78Wmf+ClbUl6+IJTBdDZyhzHzkuqr/0q2H+1iCFSxQMGUgbZxmkVyvduSy0BkVjUifcrX1bZxMMxA8Uv1kULmEKpdqutgKGjkrw80kh0WKfd1F+LkJS7tp7DjI+srXwQI3YAFT1tgPB2XOKxYNVK5Y4XLV4LMNnI8JY+ywvYw8/vGjz5uZWGxtZvu0FbwRSQT1KRcT9ZzUiVP2icFEmU5rcZhgCTx30x4jDlmhc1QHEIBa0hSMBxas5Erx8AZw1y3QXHKVE0OV3+z3M6XrS2PIuE23zgfu6rOoSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdhm9oP38ZbOdH5FzR+09PgcD5jaOwPWHQ8aCn75ecg=;
 b=pWeYz1WkjsbKOkNG7LF+Gix8bjJXUgMKLzoidUSnXAVYI0u0rBMPdlYwm2nc3anGmvJbJUPcJM3r3lW8ePP4sZHwz0YHOgcdc10E0dww01Nvblk19lXBaKEXE/z6v1P0exXJWDIDk3AM3dK2qSYI9kwfXU4fFktM7kupgCUhVp8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3386.namprd10.prod.outlook.com
 (2603:10b6:5:1a1::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 15:56:33 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 15:56:33 +0000
Date:   Wed, 3 Aug 2022 08:56:28 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: Re: [PATCH v15 mfd 9/9] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <YuqarB067s+rqFKe@euler>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
 <20220803054728.1541104-10-colin.foster@in-advantage.com>
 <CAHp75Vc30VW_dYGodyw4mrMwFgTVyDFaMP2ZJXQEB2nFOB2RWw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vc30VW_dYGodyw4mrMwFgTVyDFaMP2ZJXQEB2nFOB2RWw@mail.gmail.com>
X-ClientProxiedBy: BYAPR11CA0063.namprd11.prod.outlook.com
 (2603:10b6:a03:80::40) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebb021eb-11f2-4eb6-6b1f-08da7568bcda
X-MS-TrafficTypeDiagnostic: DM6PR10MB3386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0AjaYuvr1mX40lHgfE5dGG7cnyiJ5Q8iW6I7jWYVnl91o0mt4BwYJ2MfMAgOE43Ogssb0A+JBrMgdpAsMjQWHaKiZ21PExXcC5nBNXL+CFgdTobmu8uHTKOEVSEAjENX4HrSPMaLuirF+2JvA1SUup1YY98BVkrSeJzTpJrxXwE7KbBjEd8pPtYLqMCnQGVDJyUUGuOzEpIYNl+W5DL2pQYjq6Tw/5ji/832Vhbc9hukSXaci7V+tujNYzb2c3P0cWhJMEhaYaSJxVDrbJiGUwEbmDAgoGViYFJZa8RDtci7NC/Pw9CL4oRK7VA2eDdHTyAw/CjI7hk2wgrkpeDhQwD6+rLnGJ5eIvrBVOoigYT0MGRdWDACHfOhE5xexfUiKECSeZBmF2YbNvq7ZAbRe6pDGlF3xLZB+/o9B+4nN/WGiYyq+fqaz0iygugRj2UXggdoybXsWt7ueYlAtcHGs5nKTXzQv/MsySn8tU1hu2wirVUqSnGcoOwzS0gOyxm21UU0C/DY0rVO68B5Ii49NVnN1rE6JLPkt62QumQyL/9Lg6xadSL0yPHCf0VllW6Qp7+fhXF1prlRh3VTvKL+9d1uRSEy0dFjCXB4F+SMZJ2lly1iGdtwqi7INEmWd/5ivzx02jn9dTJLXRavfEoj9+bXBlKXAF7/AWAVz/5Lc+CVsAG2KiQOlJTdUpzw58fnNiajCtBu0urvmW0x5hXUX62zUPEMu8MfTRulIZDMHA3ReLyER8bciTXbZWZNya5uBUwlGPnRgxmT3ocSmf49Q/CZmdqlD9eommwb6H6k/k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(376002)(366004)(346002)(396003)(39830400003)(186003)(6512007)(9686003)(26005)(478600001)(5660300002)(4326008)(6486002)(66556008)(66476007)(66946007)(44832011)(8676002)(7416002)(8936002)(83380400001)(38100700002)(6506007)(53546011)(54906003)(6916009)(41300700001)(107886003)(6666004)(2906002)(86362001)(316002)(33716001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sQoy8L/qvWzKZZm8UJXGGHBhmUcqiypMQdn64pfHAi9SGnpREimuqQviHPni?=
 =?us-ascii?Q?eggsi+GpRZA7icvbEZ3HGVv51GXm2qMSwhJiVwWV8WIkK4iEi0m4WTG4SICn?=
 =?us-ascii?Q?i/pmoPXBfAJOtovYE9rSYhp7dJHZ6hh1Z31o5BIEJ7OE0UmMTGz9toTElCMN?=
 =?us-ascii?Q?3jsgGd+wJQ/pStFZj03rtqa4YIY/JJos2+ci9qIludP2O3YdyNteUFmr8gle?=
 =?us-ascii?Q?ZxWARmhW4844kWy9hJVQMGAC4seWLKYf2j7198U1rsgJ8aeyamFQb9xSIDn0?=
 =?us-ascii?Q?VXSl3IdPoSb32+6yn0QtPT7I2+87mqqcaqipTxSuh8NIIcIQ/VcjEHpgNFiu?=
 =?us-ascii?Q?jVgKCSV687xmP6E/JwVFNrUT6111Rs/pqnens8arZeFrSME0TlHpeMmnJ49d?=
 =?us-ascii?Q?f84wuI73cK0JiQ9E8rJKQdmbqXwaQzV+7yk/1UQUwOTTqi4JCjcMJgccGuPQ?=
 =?us-ascii?Q?60Y573V6TqWC1BWWBqbmzRY7Rn9wyb+yE4DQ1lCZCyBDYADPvFnXYhHavY1S?=
 =?us-ascii?Q?A7yzVM1rRh23ptHeFPEVMDZgsE47JM+m5054kAgOhKsZ4XH5xB8n5aGqZJ7W?=
 =?us-ascii?Q?02MsZpSfFodQoIEt4i+VJYnzJgBzvN2yi2h2P92yWv8DjHYpe5O/ydKgf4Jq?=
 =?us-ascii?Q?dXyoDnWzYM0n/N2AChRVVicw09i3aonji08E6bSIwDtMGS1Sunji5RcvStIp?=
 =?us-ascii?Q?V2qdubKPTimN43fpMu9cq+I9zge+oT6GxGmb69gwEyOZZYoRicNodCYzTUyF?=
 =?us-ascii?Q?PKWQhajTpMXuy9xyAfIHVMGZkveGMsWLENZDb0iAg8Roq8uRO6EpEvQjELk1?=
 =?us-ascii?Q?vbTq307eH5WafgFuBfDERpdL/wFx0VJ6IPbA/Labv3sqo8C2laX8fTLzPtY4?=
 =?us-ascii?Q?SXcrRBig4sdFi1G2PM4I2vKOOOpvNYvCV1nEiOoWFl0vFJyN8ube2BJK/xjT?=
 =?us-ascii?Q?594Qmrwx3yrMbzUywj7TMixV4Qau5v9Px6Utvr8jEX/L1w2TkR63xI26TnNP?=
 =?us-ascii?Q?c4Ba5FjhPdNmdoUF54nZGMC4SySYqdyzzv8gwDjoeqWOoTppL3PM3TdeJ2XJ?=
 =?us-ascii?Q?zduxJIgxJjZm3cdGercprRwS7KEGZJr2B+PJMu/SDXQlavSmI7CzmPtK4a3T?=
 =?us-ascii?Q?Doh9js63/GnxauTTT9jtNF4Wm1AEWmz4vHaMBU7GYv45BdopaGnNPa80HiSZ?=
 =?us-ascii?Q?O2oGvEIHQIHufiFCXNiSnpmTRwjV5Ch4wZdyf6TtX+mRxKFFrtw9wWVT56wv?=
 =?us-ascii?Q?RwN0y505fPsmq/hIqk4LYw7yEYWdMU79daTMgjkG+qlB9SZLNyS29CmzI5gJ?=
 =?us-ascii?Q?NOPUl2aN6gc1uyKAIOeWZN0TzlF7inDaojHbqJeYKshgE3SqYJMyJXmTX6RN?=
 =?us-ascii?Q?nsDpedf+lqcLWjZ/HcI/rZ6GSWS4zgOYj40OZ868GLvQX4okV2/7+QmOX454?=
 =?us-ascii?Q?cTr/Zyk6VBPdVCKfCjC814OxAWTAOmdr9yW8jqzLJtNFQ2sLqZE/t2Ezhozw?=
 =?us-ascii?Q?ZKXb+FztnXpnE5BoX3dxi3V86OhEHcSTZR4CZmxeBieN4rx12int8/sGlQLS?=
 =?us-ascii?Q?GPyrTrZOF0m07bgiRo2luPkdXAOKeE49UpYRgti5oN/y2JqXEY50B8GJtS8m?=
 =?us-ascii?Q?mfTcGiJ2VEc/npqwwBPuaE4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb021eb-11f2-4eb6-6b1f-08da7568bcda
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 15:56:33.5419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t6jL0BvNWSXt0CA80tl7FiqwAddPJ535QBOq/TQJ5PTBh7iHnBFhXuLEsnGWRsgnVldggmpFbFuPxdjHV+OrmJZe+79ujHpcOpbCFZNArYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3386
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 01:45:04PM +0200, Andy Shevchenko wrote:
> On Wed, Aug 3, 2022 at 7:48 AM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > The VSC7512 is a networking chip that contains several peripherals. Many of
> > these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> > but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> > controlled externally.
> >
> > Utilize the existing drivers by referencing the chip as an MFD. Add support
> > for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.
> 
> 
> ...
> 
> > +#include <asm/byteorder.h>
> 
> Not sure I see the user of this header.

Interesting. And I think you uncovered one more issue.

I'd used byteorder at one time to modify the SPI payload (addr is always
big-endian, payload should always be native).

When I migrated to using the spi_bus_read() instead of spi_reg_read(),
this became handled much more elegantly in regmap itself. So this isn't
needed anymore.

I also have byteorder in include/linux/mfd/ocelot.h, where it also isn't
needed. It is checking:

#ifdef __LITTLE_ENDIAN
#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_LE
#else
#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_BE
#endif


That file should be replaced with
#include <linux/kconfig.h>

> 
> ...
> 
> > +struct regmap *ocelot_spi_init_regmap(struct device *dev, const struct resource *res)
> > +{
> > +       struct regmap_config regmap_config;
> > +
> > +       memcpy(&regmap_config, &ocelot_spi_regmap_config, sizeof(regmap_config));
> > +
> > +       regmap_config.name = res->name;
> 
> > +       regmap_config.max_register = res->end - res->start;
> 
> Hmm... First of all, resource_size() is for that (with - 1 to the
> result). But don't you need to use stride in the calculations?

DEFINE_RES_NAMED populates the resource .end with (_start) + (_size) - 1
so I don't think resource_size is correct to use here.

reg_stride gets handled at the top of regmap_read(), so I don't think
that's really needed either.


For reference:

#define VSC7512_DEVCPU_ORG_RES_START    0x71000000
#define VSC7512_DEVCPU_ORG_RES_SIZE     0x38


# pwd
/sys/kernel/debug/regmap/spi0.0-devcpu_org
# cat range
0-34
# cat registers
00: 00000000
04: 02000001
08: 00000001
0c: 00000000
10: 00000fff
14: 00000000
18: 00000000
1c: 00000000
20: 00000000
24: 00000000
28: 00000001
2c: 00000004
30: 00000001
34: 00000004


> 
> > +       regmap_config.reg_base = res->start;
> > +
> > +       return devm_regmap_init(dev, &ocelot_spi_regmap_bus, dev, &regmap_config);
> > +}
> 
> -- 
> With Best Regards,
> Andy Shevchenko
