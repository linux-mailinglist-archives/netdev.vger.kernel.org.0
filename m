Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6FF4A6B09
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244561AbiBBEsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:48:05 -0500
Received: from mail-sn1anam02on2071.outbound.protection.outlook.com ([40.107.96.71]:53394
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232561AbiBBEqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 23:46:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKJnHTJjEZb/j5Qc+nBEzbt/lRnaDGfriCSIwKBmPNA6m6k3krbSm9qx2ghKDJFKUmGBUXiQNOJpB8WDAVdxYRKpkgKGdcYF9V8cbg9gS3sdLqnUTEoBRyN5nkhmwn2NzJo+9ISw6tQzrus+ozD+HHiE4eW5aW/TSJg7nKhNPM6NnQeCOt4whGA03HNJxJnS96NHUoCITA589uoGnah2r5U1VtZYcEI0SMP9ZEam9zbIfb+yGnJO4qnVKjLIWxaSRvleMbxgPcj0rNOv4aY48oUjiZgbdWIzVClNniWthPtV8KSlN4OSdJVwyrM1iy6DOL5M1YVVwy0OA/w5mCZKkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cDo+M8duniDgzDmN33yWVCHGFx5DcZBRGZKNcnTVwUo=;
 b=iF6oQWi8QoaMpMvkB600hKLfTQB2C4v4K0WF5KAMh77jNvRaTXwT6AABSSdOtdglAreBKDdns0Fhg1pcPs7tpBzoIujQYN701obDLLcl0VsAGCdfd3Wm/zly8awg9z9k89Zsq/YMjCj2KdxFqp+Qc+uZi0WeTL+HGZW13Lrg5QaIOYVVe0teGG176fhcDWSLjzMy4ygGoxeiqJtL1z1C33U2qKeuP9MzRxRiaCaz2tyhJ/VQDA28C5T5EfFU0FFckk047qhly1RGq1fRkeHHh56PU+Bx3DjxlR8uEU+B8Mg3C8KKhW1drfF3+j+zG6HWK1TWKlaaYl+SO0D7mw04EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDo+M8duniDgzDmN33yWVCHGFx5DcZBRGZKNcnTVwUo=;
 b=E2h2WXSC4EsgFDSrcgj3zmVIsQUbS0YCiAaK7GI5NpInKuTmkRvHMFmLKnCucHtn1zW490WohUC0a20v28pcOCWbJjNomN+WuHpvmfmEz4F1TiY8HxXjCzM+7R4/bsZ3BXcPd/jksazb4jCd6TtaenFrmD6t6xRpLH0m30d32AmKIPvFprRbkFRfY2T93yuv5eejQ0dUtCjXQITP0xNWv7dJaEpEgJBvP4qHz+YmKS1IWZqX624ijhxovxpXHYCTVLfTE+/sp1a9j4vvItPK2PhULHdiOLoD6JgvVUpu/q/YNWMYJWf0YiRWJkxAWhRWxyOY/GlGGHnzJHDdunKvsQ==
Received: from DM5PR1201MB0234.namprd12.prod.outlook.com (2603:10b6:4:56::22)
 by CY4PR12MB1304.namprd12.prod.outlook.com (2603:10b6:903:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 04:46:06 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM5PR1201MB0234.namprd12.prod.outlook.com (2603:10b6:4:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21; Wed, 2 Feb
 2022 04:46:04 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%4]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 04:46:04 +0000
Date:   Tue, 1 Feb 2022 20:46:03 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Chris Snook <chris.snook@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>, l.stelmach@samsung.com,
        rafal@milecki.pl, Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Liming Sun <limings@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Gary Guo <gary@garyguo.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, intel-wired-lan@lists.osuosl.org,
        linux-hyperv@vger.kernel.org, oss-drivers@corigine.com,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs
 to y
Message-ID: <20220202044603.tuchbk72iujdyxi4@sx1>
References: <20220131172450.4905-1-saeed@kernel.org>
 <20220131095905.08722670@hermes.local>
 <CAMuHMdU17cBzivFm9q-VwF9EG5MX75Qct=is=F2h+Kc+VddZ4g@mail.gmail.com>
 <20220131183540.6ekn3z7tudy5ocdl@sx1>
 <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
 <20220131121027.4fe3e8dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7dc930c6-4ffc-0dd0-8385-d7956e7d16ff@gmail.com>
 <20220131151315.4ec5f2d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dd1497ca-b1da-311a-e5fc-7c7265eb3ddf@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <dd1497ca-b1da-311a-e5fc-7c7265eb3ddf@gmail.com>
X-ClientProxiedBy: SJ0PR03CA0181.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::6) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ebde5f5-cb61-4f5f-7423-08d9e606eb39
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0234:EE_|CY4PR12MB1304:EE_
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0234FE0709C571345BA7004EB3279@DM5PR1201MB0234.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ecc360KYiYAKCsClQXujGhWwvbRxdbrQuMoR5Ncr+22gS/OMmOQw04CkYlFZKNlAAeyGaknwYSNUyb+Ixt4Hn+b6UmFcexMqvtVuqUurDMKuEb+/xC5RdKUENGJtS0xGsIp7RCrdZLhn/trZ4+uKWMMCV64LiMtIjz9WoZbNk+iUY/gFYpSGQRq4P1VlXYtnANxgTyO2uRU//I0s1RPYemNfeMjdK5+6MRsXjfgBIbXP3mlqj0RCZdadAW2p9V5cTNqI9qfI+Di6VAse++lsSllqK1ltErcnFRZhUHcgVaBFHaVxpfOGGn/8Mrn6RWub+NbqU8H1I3yGhz9AJ/phZDeh7/3JyMxXCitxUtnsmmpVQTE+8GWMYom1o7xp4rEKNPczmQ8/FeUsDc+wX1s3m45nftxoG912ZuSejEh0tMJMIzZFU2M7HVdZ4m7Mrx3+XYYCZ+0uTrs8FpBK5FvuDA4FaP9AVK/BIzVDifolgJQbVAGe8qnWphnDjfGFn3tZA8Ellv5CHWLCRRAWxppq2zj1QfE+A7xZOH+fmyzG3laJMnG5xgx08QfAm+KcQ7oXBkNUZpT989hXS+S3nZJwrvaq8ZEzjCnExN8eS+sgUwOjDKeqZm6j9nBbDhX/aKnrP+UyF9K60OXZbh1leZ5VPFFwNUHd6S/sdV3C8R5MUVJPsdLw+lWHsYO95EP7qj5hvmNRRX7yTv1xoFl/BnFnK1o6QlBBFZcwdy3smfY0EM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0234.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(83380400001)(186003)(1076003)(26005)(7336002)(5660300002)(7416002)(2906002)(7406005)(7366002)(6486002)(38350700002)(86362001)(54906003)(8676002)(4326008)(508600001)(6916009)(66556008)(66476007)(66946007)(33716001)(316002)(52116002)(8936002)(9686003)(38100700002)(6512007)(6506007)(129723003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qPpn9NtHv4YKwq76GEJtwBWiWDIOaj8cphrVBzqHvqcM7oaRQuRD8LDAR7MI?=
 =?us-ascii?Q?I2O+w54m9NeiaFIWYobRDZSvIwEm/R90EkKt+Z4H9hlqlFZee1oKpWkBl/De?=
 =?us-ascii?Q?UzNpIysuJirstZRJeuVK3QMjSCdI0bHiQMnAgJeao9IxDA7yi34g2MyGzhAg?=
 =?us-ascii?Q?92xWRLUfb5bLXas2juI6fkoFJKjbLTX0QcGjEAqBntDb8qQN87LZDEJuCcp/?=
 =?us-ascii?Q?AD6BmUfZZt0B2c4UA8lEdCcowIYf8BNl63jvBr9dJz7iSRzIBmB3Z8PxyOYu?=
 =?us-ascii?Q?tkQg9+ApNcnqspeA0TBqHC1EpxgiswKp0ZDZKWYOImsHU1b2JE9xLCxrXFgh?=
 =?us-ascii?Q?QUqVxrGriSjMeFpZsoAqYGA/i8cZ0W5CMwbo9jtVLl/DegEOE3jvhHkPdZPF?=
 =?us-ascii?Q?QotQ5CNg6cgmWTVJo2chJwGWKJ5VUJJLvZMmJG6B3MXg2VdBOHjWxThW72gU?=
 =?us-ascii?Q?uWv/hFDWtY7QJlvUrPMOYgA+XhEOSJy9rFl5TP4HIHBoeIHmUsTY6u8+xrmt?=
 =?us-ascii?Q?lStcfD2xFR/v/1SE4nSyqVTetrgbq/OBzLLoJBFu5a75DsF+tCvXXlFbMq8Q?=
 =?us-ascii?Q?SqY0TxzVBDv/RVEPhWeS08LZGukeIYm3+y5nliKSaeLZxyPuvfFNImVQM2M7?=
 =?us-ascii?Q?h5LG9FxmqCZBM2kj0Pjzgu7NAJTa8eoA+091LXm8yONKTSxGZXN+qvw1sPIJ?=
 =?us-ascii?Q?/7qQo4vstVDMbKvCynXttj3aHvHvN/dHgRdu2OGi1jKwByNLU3dt/3oAoUk8?=
 =?us-ascii?Q?pUn9iJmBP/kEBp3RHMwuU1i7jYuukjg0NrT75zSxFVxR51dwOuMB+x0g/hNV?=
 =?us-ascii?Q?Ka6zif+EJpkW4y7LRwKNflF3QEHB360frFsAeJ5ykE1HdmyjACSJ500uUyX0?=
 =?us-ascii?Q?3zd1XHKRESXVwz7A8OE785EfD680emYqgTgkAUUTx+MxAnjE2OIwPzuvGWNo?=
 =?us-ascii?Q?e/vwyc6uXO7XIupTyIMyQn1ImfBN3gHYOGWl7P07T9pf+gTGMrhRMbmEAjP4?=
 =?us-ascii?Q?vU/6meC5o7QhbfvfvorscDfXn59kUhU+JQn86ZXksUv32fcj3QchNI0JmN20?=
 =?us-ascii?Q?U+85MDQpm6g6g6C9Gf3dYhghhrjqUeRUyBdiIlHgKoxIY3rPTH47ePJWVExA?=
 =?us-ascii?Q?+ROcI2vznVuoSc1oTt4TgtFtC0vSc0zTq1gJSCKtU16gawNgk7cYEEVPKtQG?=
 =?us-ascii?Q?TzO0oBOd6+cguZ7Nc3cmnGz+13695PcJsJMvmTosS8YU4sL2eLGso1mTXOR+?=
 =?us-ascii?Q?R7ojvovxkrHwZptIZcwIZ/EJPCcjkM00FY6V24fMuSw3iDfdmcOyT7r9jCwF?=
 =?us-ascii?Q?30L33nRLLKLY/C7fXit3veJuAYjYBeg6f9wNTVOmEUn5E5cMdr7J5Jf829Q1?=
 =?us-ascii?Q?7UGAksNImqzSDppQn9vJ9YwxNBkkFSeIMqrKC6o2M2g6JM8O9b9dDcO0maTj?=
 =?us-ascii?Q?/Bmkwb8jcC+E++0GM99S7X+ZL7BSHC0yG6ijjw8oTa1eaX8ss9SGjP3VL/44?=
 =?us-ascii?Q?NG+UZ4f59ti9HtFS9gI0G0FLcIILlDBayJExesJT8M5s70fsx/HUGj33ZrDS?=
 =?us-ascii?Q?YlDYYPruNdecHMZBE4FxemUfjljH2pyCLe/cvLpeVOxliS2cASVODUCT2VvI?=
 =?us-ascii?Q?lFvMFui7ororOA90yiR5HO0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ebde5f5-cb61-4f5f-7423-08d9e606eb39
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 04:46:04.1969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7oJSbAfxmD0OlWe3xUiryamV7TIraJVyDFfYkzXkOaUnFnloh2ZEH5AI/tlLH/m2SHeKRvg0SsB2sjkdBpvAFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31 Jan 15:19, Florian Fainelli wrote:
>
>
>On 1/31/2022 3:13 PM, Jakub Kicinski wrote:
>>On Mon, 31 Jan 2022 15:06:01 -0800 Florian Fainelli wrote:
>>>>>Right, but once you start hiding NET_VENDOR_DRIVER_XYZ under a
>>>>>NET_VENDOR_XYZ Kconfig symbol dependency, if NET_VENDOR_XYZ is not set
>>>>>to Y, then you have no way to select NET_VENDOR_DRIVER_XYZ and so your
>>>>>old defconfig breaks.
>>>>
>>>>To be clear do we actually care about *old* configs or *def* configs?
>>>
>>>I think we care about oldconfig but maybe less so about defconfigs which
>>>are in tree and can be updated.
>>
>>The oldconfigs would have to not be updated on any intervening kernel
>>in the last 10+ years to break, right? Or is there another way that an
>>oldconfig would not have the vendor config set to y at this point?
>
>That sounds very unrealistic, so yes, I don't think at this point that 
>would happen. Even if you had your 15 year old .config file and ran 
>make oldconfig today, you would have some work to do to make sure it 
>still runs on your hardware.

I am getting mixed messages here, on one hand we know that this patch
might break some old or def configs, but on the other hand people claim
that they have to manually fixup their own configs every time 
"something in configs" changes and they are fine with that. 

Obviously I belong to the 2nd camp, hence this patch..

I can sum it up with "it's fine to controllably break *some* .configs for 
the greater good" .. that's my .2cent.

Thanks,
Saeed.

