Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F2D4A6BD1
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 07:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244984AbiBBGxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 01:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244763AbiBBGwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 01:52:39 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E155C061778;
        Tue,  1 Feb 2022 22:44:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtu1A0h82rSLUdumNN4G7NUxtHUUIKP04V/lCH15Ew2m3Lv6DMlPlrsktuH1AYrtBjhAd3+mTZ7ZQeHpeHxsxQ/xhs9vtBVDbuSyHGVZsz5vlfFn9xeDZxWy+D6B2hM9/XKDUteAJ9eXxdk+qn3WSSjv3AANlzIvV5uMjEMbVlkcD8voxBh0ZsQ4us1YzzYcUhgWguFJ8Q1Ax3HRhrch0C0ysUf6Nmq/3+gYpYO0ExBdUjgmv2NFuSM9av2ZSKYmqJIrKdAv3YddNgogyFbEDnT45rHBjozTnh6SxWTR7R6Oe8SLaOnIzmmsu8LP6S0IOjzJtPC7PB/MuaRivo6BlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4PLNJnem/PtDrgnJG2L56P/Q2fANwD1rUJvDxKTinuc=;
 b=HqZjnxrXqXLsaU8Bpb4Sgjo8JM0d67pbqFT5f/qLg20h5so2OOI+LvK5O7Kl8adhsy2Ka5sxOm9NmohwYTf2fJctWhgXgEodkRepc8IMUxDmTGNG6ui/q1clEnFX0+gBYmn1TqZoGvuAMqnerjR85EA1+Nw3m+1z+YpoVWbEKFL8l93Op7znbgVatLTGyDBt4QZZMBS8AXnoTbBbBGD8LsqYEK3+KGT/clQKKFdA8rDmu9XbcRpByOl0Y6A14N72YJmoXYVpZ+wcBMAfa3Gp71g0fWyKyuwUr3qpiuTBfrI9CNLGYSfwMdYenpZIOUDSdAQ6oeV5Ke6XnrgKcg8MbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PLNJnem/PtDrgnJG2L56P/Q2fANwD1rUJvDxKTinuc=;
 b=RecSJIpJfb0/k1o7QUF94R0lkrMzzDeLRWHesTpXdF93R2wCohLTbzwWKwfEzm/VaxZMjU68zW9sW+/VgGLAAbrMu9pDGXS9SJamGMicW5sdB4YYyYigyph7r4rp+UIMMvRg9hiHbheGu18gwVGLatCxfzoc1R71FV3V+KpUgKU4Q5lhF8bxKIC764FnR2x8ma2qi6FHlSxSYeJs2w4Cq2EJuYNFe8b2UeSX6Fo3Ln037KOSQat5TklR27HMXfylTGrqH0yiaxiLK3MflZDFZtulkoGVnwJ2hTk4ZRHXsQjK8wBzF2tQOWD/6nUdaUJkTYAYWKxh97wd249lm0IMIA==
Received: from PH0PR12MB5433.namprd12.prod.outlook.com (2603:10b6:510:e1::22)
 by DM6PR12MB4060.namprd12.prod.outlook.com (2603:10b6:5:216::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Wed, 2 Feb
 2022 06:44:16 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by PH0PR12MB5433.namprd12.prod.outlook.com (2603:10b6:510:e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Wed, 2 Feb
 2022 06:44:14 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%4]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 06:44:14 +0000
Date:   Tue, 1 Feb 2022 22:44:12 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        Shannon Nelson <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
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
        Rob Herring <robh@kernel.org>,
        "l.stelmach@samsung.com" <l.stelmach@samsung.com>,
        "rafal@milecki.pl" <rafal@milecki.pl>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
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
        Gary Guo <gary@garyguo.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs
 to y
Message-ID: <20220202064412.d3w4acki3khcgox7@sx1>
References: <20220131183540.6ekn3z7tudy5ocdl@sx1>
 <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
 <20220131121027.4fe3e8dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7dc930c6-4ffc-0dd0-8385-d7956e7d16ff@gmail.com>
 <20220131151315.4ec5f2d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dd1497ca-b1da-311a-e5fc-7c7265eb3ddf@gmail.com>
 <20220202044603.tuchbk72iujdyxi4@sx1>
 <20220201205818.2f28cfe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220202051609.h55eto4rdbfhw5t7@sx1>
 <8566b1e3-2c99-1e63-5606-aad8525a5378@csgroup.eu>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8566b1e3-2c99-1e63-5606-aad8525a5378@csgroup.eu>
X-ClientProxiedBy: SJ0PR05CA0131.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::16) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49b95cbb-180d-4318-7803-08d9e6176d69
X-MS-TrafficTypeDiagnostic: PH0PR12MB5433:EE_|DM6PR12MB4060:EE_
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr,ExtAddr
X-Microsoft-Antispam-PRVS: <PH0PR12MB543372291C0D9306A5AD9904B3279@PH0PR12MB5433.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y1BUaF4t7+9fg7zLNXQsl/EbTMs4x+1YAZjt8xz8qx3johDKhccRyQd8d35vpzIBezSuizRQtO+nTA1iR29fbV5D+IWQY5mChyMTb6/9ZBN4jxyHg3KavqN7oaELXQ3bQIlchXB9Konqsp57K6zaTTz8lzALOarSnawIgGhxbPE8kBB2Jr6RfugBxGFltUnnyAESkKu3U5rjwcQBb8THAGo3zqraLy2mcoDnfql70y117a2fLXiBNRXPmL0wojbdDwGpH3y1PvrfUWh4Yenfl8O0sv2JxZq33h+hvdKDctBdCj8DWoZ/O8QAaBtRBiLNinVlIScGVRI5xqg6YHoaRwPt49iLfQ7zdNKUbJn/gC/0Mbt36Bqxb4ojYZ3eSF1oDVWNaNC0xX/DgCAx+alur2js01TGZlo7dh9N57XHWC3M/6778JyBOAdY8sgNcqjL6C37eyX+00imxn22QiRVu8WhzIuikBU+lTIMoFMn4x432YkN7kx6KFg91XFbYPrrpMJpNebO12KrVUetShxSeXQmsYHf54yFnxeh07f2MVAwKPruYMve/KrAN4ZHVZ2sSvgk36sz3ZJ2v69WMoSnXWywDvEXFRYASFYnxrmUYQG2fNk2wRpDTFzNi6Tbtv3BsyOoSgz/2CEz1vQEUp5hN5L3zwgESGk5reM+9ZFNaOwjRCLJr/rWXhifFeohFjDPz4X8y684xdxQ7pksua0KjLYvrIWT/OP+GNDpMnW/y/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5433.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(38350700002)(8936002)(8676002)(66476007)(66574015)(38100700002)(7336002)(4326008)(66556008)(66946007)(7416002)(83380400001)(7406005)(7366002)(2906002)(5660300002)(86362001)(6512007)(54906003)(9686003)(6506007)(186003)(1076003)(316002)(33716001)(508600001)(26005)(6916009)(52116002)(6486002)(129723003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?XS2UnmNt/PmF/KefAAAJgTMe/otcJAurEJc20+QbeH8f74Vwpe/08h+qlQ?=
 =?iso-8859-1?Q?RZdxksqB2lgT2lwVGRRlkKz/XyqaXqnGiTtpu2Aiz4gc+GhzM4gIAKTVRt?=
 =?iso-8859-1?Q?m51EVIIPOCPj0UZU+hmXAn7Ot/eNB+LjLiNg+Km5ZE35pdz/knGXCv+P4J?=
 =?iso-8859-1?Q?e00YUd9dU13daz0q9VMJQKgrOn0TiHvVeL/bTljuuSwKv6+H3vuuXSfzSC?=
 =?iso-8859-1?Q?HZtGUYVpPPe5Dmy2/hV1PDNGVkIAcCwTdWpkXrkSBWueyjAjSzGEAvW7tN?=
 =?iso-8859-1?Q?NXM7KdNKbjDWQq+0GjCRU1HSVvC0ln3sNjGgnhM8fSQKof+AOotN9pq9fL?=
 =?iso-8859-1?Q?D5rYOnfgpieSJ4pjqPnXHqWRMq9gcBPoHIAe/jp6w6eqEFlSVvOSYPB1er?=
 =?iso-8859-1?Q?PX1CNFi43PNOPqMmuQJ8OGToPgfR7I+X0vy4JNO6BmsHpY8E1FQEQ9mkcS?=
 =?iso-8859-1?Q?5puFjAIAISMLYEGkZG+wfOVGBP3rAzAP7BPbmcMODhKLQP60epUhqw4+5A?=
 =?iso-8859-1?Q?+Gam0d0c3iP2n+hWn4aNsE1XYSCL4MBnoJNH51qVi7TTOQry7BQkHxlEaV?=
 =?iso-8859-1?Q?3rbEXO0dFT9ReIJ7GKfU1sr3LsbS3JoX5qZM0ZdsvWH5Ov3VCv4QhFO642?=
 =?iso-8859-1?Q?W1nxA2XyU33WUhXE50IwAZLkzk24qzsphz3NkqFqdUotZGTclcBK/KJ2iI?=
 =?iso-8859-1?Q?/enbNzylU1cFhngNuH5LHhoVPX/CyqOMsE3KRSv3hld1Z90jbeqFbj94ME?=
 =?iso-8859-1?Q?0E5eDWQU3XEVIHf+aO7V2tdrK5XKYhLgxLebpl7nOCK5VBqU47fZnWufbD?=
 =?iso-8859-1?Q?sBlu2xbaB2AVtr05K3iAi4jbqAMOaiL/StgEQlj6BHh1+Us2k5z4ANg45J?=
 =?iso-8859-1?Q?c3Ksnzc+G8ssbHpBPwgcz00rbOAH+giXCbJgOMu2/b9DW70BhRrpz9hJQy?=
 =?iso-8859-1?Q?SuXHjtu0cBbzYnoKp+8aocu8NVaxpdrCMISVUFqSA8yNU2DBn9lgC+P+vW?=
 =?iso-8859-1?Q?ZJ6w7Bv6Kl2AG2zoUg+X7kc780PrN1qaDoSPQMhUSdFgnT5oWz9mxJijyr?=
 =?iso-8859-1?Q?21jHppEnOQ3+TbJHCV4KQmzymhmYDgLVTPLvNFwwjDFhHb+o5hNWRV9v2u?=
 =?iso-8859-1?Q?ncD74OVb8ywaYfBl2jx6x1VgR5OwNoEUbJv8eLvwI1YgbeFmrydpN9qn8n?=
 =?iso-8859-1?Q?0AK7CDpMMfs8fDDm7Hiq3fxglE8tGZ2i/byT95Hd9eGH/uvsk5vmpdymhr?=
 =?iso-8859-1?Q?B9x8zdeP4rgS7nxF2iiH8PiaowlSqwWuhHWDthwnfRupw98AGYgxTCX3Ua?=
 =?iso-8859-1?Q?CkhNEVPqh0/OE7l0T4BYKIXIFXK51zLDgr/iw88e2fhgOKN2tvOrgIpUhk?=
 =?iso-8859-1?Q?I970An3ApEj5yz6nHE1hneaAKnr/FfNU6y6B5f5PzOuEEoVpak3GU/RJlW?=
 =?iso-8859-1?Q?HCh1rs8AoWb+kiC0t2CeB/ydfvqPttU8iK6LWJpReUTdtCw6r0v6v7ZdHS?=
 =?iso-8859-1?Q?SwrKaRmnirxPazxYj7LJx/sZygwPsGi/gWzIoeL1bOFDSHjRHpcQra0TA1?=
 =?iso-8859-1?Q?jnZ89HohlKQuBOOmQJw3Odi0sGiDEPsHGdkpw1Jp7+d/bB0UAWPAsbl1KD?=
 =?iso-8859-1?Q?JN30yHLg/bxx7aF/OfcgRjSUnmXPEfRbKVE60Y+oc6iNewQkFS4s9VAAHz?=
 =?iso-8859-1?Q?u5nnzBs23djgLkSWYGw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b95cbb-180d-4318-7803-08d9e6176d69
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 06:44:14.5462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: igLNgteLmtwgxpw8Kzr0vnE9h6zQzO+ypJDIJ2xo4X9o0eHtMfvGdieWY9WJVmDiYFJLTVRqAad7wE3AwY5X2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4060
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02 Feb 06:30, Christophe Leroy wrote:
>
>
>Le 02/02/2022 à 06:16, Saeed Mahameed a écrit :
>> On 01 Feb 20:58, Jakub Kicinski wrote:
>>> On Tue, 1 Feb 2022 20:46:03 -0800 Saeed Mahameed wrote:
>>>> I am getting mixed messages here, on one hand we know that this patch
>>>> might break some old or def configs, but on the other hand people claim
>>>> that they have to manually fixup their own configs every time
>>>> "something in configs" changes and they are fine with that.
>>>>
>>>> Obviously I belong to the 2nd camp, hence this patch..
>>>>
>>>> I can sum it up with "it's fine to controllably break *some* .configs
>>>> for
>>>> the greater good" .. that's my .2cent.
>>>
>>> I think we agree that we don't care about oldconfigs IOW someone's
>>> random config.
>>>
>>> But we do care about defconfigs in the tree, if those indeed include
>>> ethernet drivers which would get masked out by vendor=n - they need
>>> fixin':
>>>
>>> $ find arch/ | grep defconfig
>>> arch/x86/configs/i386_defconfig
>>> arch/x86/configs/x86_64_defconfig
>>> arch/ia64/configs/generic_defconfig
>>> arch/ia64/configs/gensparse_defconfig
>>> ...
>>>
>>> First one from the top:
>>>
>>> $ make O=build_tmp/ i386_defconfig
>>> $ $EDITOR drivers/net/ethernet/intel/Kconfig
>>> $ git diff
>>> diff --git a/drivers/net/ethernet/intel/Kconfig
>>> b/drivers/net/ethernet/intel/Kconfig
>>> index 3facb55b7161..b9fdf2a835b0 100644
>>> --- a/drivers/net/ethernet/intel/Kconfig
>>> +++ b/drivers/net/ethernet/intel/Kconfig
>>> @@ -5,7 +5,6 @@
>>>
>>> config NET_VENDOR_INTEL
>>>        bool "Intel devices"
>>> -       default y
>>>        help
>>>          If you have a network (Ethernet) card belonging to this
>>> class, say Y.
>>>
>>> $ make O=build_tmp/ i386_defconfig
>>> $ diff -urpb build_tmp/.config.old build_tmp/.config
>>> --- build_tmp/.config.old    2022-02-01 20:55:37.087373905 -0800
>>> +++ build_tmp/.config    2022-02-01 20:56:32.126044628 -0800
>>> @@ -1784,22 +1784,7 @@ CONFIG_NET_VENDOR_GOOGLE=y
>>> # CONFIG_GVE is not set
>>> CONFIG_NET_VENDOR_HUAWEI=y
>>> # CONFIG_HINIC is not set
>>> -CONFIG_NET_VENDOR_I825XX=y
>>> -CONFIG_NET_VENDOR_INTEL=y
>>> -CONFIG_E100=y
>>> -CONFIG_E1000=y
>>> -CONFIG_E1000E=y
>>> -CONFIG_E1000E_HWTS=y
>>> -# CONFIG_IGB is not set
>>> -# CONFIG_IGBVF is not set
>>> -# CONFIG_IXGB is not set
>>> -# CONFIG_IXGBE is not set
>>> -# CONFIG_IXGBEVF is not set
>>> -# CONFIG_I40E is not set
>>> -# CONFIG_I40EVF is not set
>>> -# CONFIG_ICE is not set
>>> -# CONFIG_FM10K is not set
>>> -# CONFIG_IGC is not set
>>> +# CONFIG_NET_VENDOR_INTEL is not set
>>
>> We can introduce CONFIG_NET_LEGACY_VENDOR that selects all current vendors.
>> it will be off by default but will be added where needed in the defconfigs
>
>Why such a hack ?
>

Reduced chance of error.

>I think we can fix all defconfig with some scripting, all you have to do
>it to add the relevant CONFIG_NET_VENDOR_SOMEONE=y wherever you find one
>of its boards in the defconfig.
>

Such a script could easily mess up!
I can't think of a clever easily verifiable way to map boards to their VENDORS.
Add to that dispersing the VENDORS configs accurately.

I might be just tired though, i will give it a shot in the morning :) 

>Christophe
