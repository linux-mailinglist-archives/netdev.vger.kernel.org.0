Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C806DF28D
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 13:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjDLLIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 07:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDLLIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 07:08:49 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2064.outbound.protection.outlook.com [40.107.6.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3606A55
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrG8yAqzr0OqiwUF6OiVwb2NDrEmTMSlnJH8Scr0s0nXNJqA+AHD935xcTKRhp/s4jo+UcJcQvWNn8TmID6+amp+8cPwce7A5xEUJoHedvmlQukQt0o+/5hAyt5DZUL1lZZhQRC0bZnf7X7mqSibBzeWsP3Sbsi6kH5MFO7i3yknwlNJIGwrOE5sjF5M8d1AE5IuSzh3wfc/yRm+RmoX9Mdl6sTua74aZULIXnzQhBWWXSQVZ6kuefrHRHk9k8G3PzZ06o6VNd/G+ancYnSC9QqcZKZj9d0VoNfES3xGdA/Pktx/EDdpKBYwIPF3OpV786ZkjRueA1Rvuy4FGHqR/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VVwKfGZrhWZeLUGmQlaCBQb0joBoIwPcPLoWOXWk7IU=;
 b=IRr5czwJ87t031BLFBP4T6Vh79pofqcd9PrHLoXRnP9jyaUAA5rKuBoTWx/8BDnUQIZPMEku11q8OxiQua5ijgO6NKGrxReHc2RpqaFOlK7NHkavf6Rm8NrVkoaSpqZJPlxQOjCtzkxNpw/1sq1pSy5giGiTUdeuEaK/k/EVWSrn6BjgxLPweqMrn1nJ4ZKfQ1zYJbOoT8Vk5k3/RIuHwzacuM09Yqerx0NcPtq7Cfl/Tw8zGbqFlNB6IzFImYx6X65ceQDX3z16/RHGLB4188GHTtqeveP9dOjE7VF0pbQj1xgv/2cICbtCcAFbQIrzcM+tyv+jQX6jUdKB8Fe0ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVwKfGZrhWZeLUGmQlaCBQb0joBoIwPcPLoWOXWk7IU=;
 b=h0KTLihUrG7G5AnPopKtWoRG7D8u+VIFDiSrfQ+wRAAclR6UA7R9QanwDN8BGkFZ3MRgaeti1ycJxLkT3dzLRD9a5wJt7ow2eSKvUsoK2p0RRrJl2JBtcHWqWHxXelLcA5BsCfxWq2pcxZdP+rNpjfV6h2oJhGFDuH4r3+wvulI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6965.eurprd04.prod.outlook.com (2603:10a6:20b:104::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Wed, 12 Apr
 2023 11:08:43 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 11:08:43 +0000
Date:   Wed, 12 Apr 2023 14:08:40 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
Cc:     kuba@kernel.org, gerhard@engleder-embedded.com, glipus@gmail.com,
        kory.maincent@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        linux@armlinux.org.uk, maxime.chevallier@bootlin.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        robh+dt@kernel.org, thomas.petazzoni@bootlin.com,
        vadim.fedorenko@linux.dev
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230412110840.vmuudkuh5zb3u426@skbuf>
References: <20230406184646.0c7c2ab1@kernel.org>
 <20230412105034.178936-1-michael@walle.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412105034.178936-1-michael@walle.cc>
X-ClientProxiedBy: FR2P281CA0181.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6965:EE_
X-MS-Office365-Filtering-Correlation-Id: 2003449b-393a-4475-267b-08db3b46475e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grRe2QDSKgRSJ0XPDxzSAjJF6CiaSInAOihAn4miMACe1yvlKcTuEnKbEizioMxtENk1Z/7VIRabLOX3H0eTr111Q+ali+MV2ytX96HPGxOV8ns6ePDPxpzhxBcjD4fhzRd87cwHMCQLW0oBXrDVIZGi0xtCUL3Bbx/008HaIXqbwjhjtVTzRs0nARCuXRQXeh+R9BjBd+9lbh/ZLG8WU2tgnF5gIA6YzLDxGTKAcYLqyaQYaFV+GCySrj/l51XfELik7Q6nuYxZs8oOlfHgjV5dHPX+SzvsPnRF0M2NhNZ1eioI90gYgL0vrti8dzIzcv9h2MLJ4EZ5FLz3hIXMKkMAoxpK0zhlvVdWhdVdiuu2SU/a58+sYzqZy2mCHsx+vXm9Aes6Mjiap+TfoJZQzahOWYNwoewQHzmiyRe2D+GsQ00AL9ffS8uVEp/LKXjDqs1O0Uvh4KTGB5BeHbpQJ1TV4M8KBLM0/NlUx52REb5rd7gaRGg5yIUok8a2/hVf3UQw+DYKf0LfeA76Y5hKfmzxEfX3ReT2iNtTxujaydv5VJcNJbtgDpsM14URYG02QF22V831kad4YlSVe+fBW1ki2xFPaCWfTrRBgTdK1MT1Apb0kOoxEmw4MqDNFPuU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(86362001)(316002)(41300700001)(66946007)(66476007)(4326008)(66556008)(6486002)(8676002)(6916009)(478600001)(2906002)(33716001)(5660300002)(7416002)(8936002)(4744005)(44832011)(38100700002)(186003)(9686003)(6512007)(6506007)(26005)(1076003)(299355004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OOdgaABxtiqL79qiFkPwEVm/LisTqyVu1cxCZyG6ThCvXloIf46uRP5ma4pf?=
 =?us-ascii?Q?S1DJUkr8GLQTIfXlYKNxKhzdwRzjdMrN7wb7yAzFsi5E4fb9zarVeqyfmjmI?=
 =?us-ascii?Q?le10vZQDosuexrjeyyJoPeZfRjMsQfe89AftoP6yOkYH//5yb+4dtDgI8mEL?=
 =?us-ascii?Q?2Tfwlwe76OQeuNOioEI7nuC0Oe7S57UvLjb2utPygg2ChcsQLenoPrMzR9LA?=
 =?us-ascii?Q?5l4otoA1wQ1/sWJiZibdFXIu3knToy9CixAxO/itdO8ww69Ti+luPxZi5cvC?=
 =?us-ascii?Q?4yCdXvTeN4Cm4eJxotAsMqmjWXRoCC09BfW2dF8GmNplD2SX//OhuCrH5pTu?=
 =?us-ascii?Q?G/K4eIsOBtxj92sdIjKTRzX48KyH24D/uqB4qW3RHgezkmSZT3giOXQ3sT/u?=
 =?us-ascii?Q?g+TxB15K73EGUCLH4mvJoi0HMX7Xc5Iw6GX2I1vxUenLJsCTuzxkCcyS1o9Q?=
 =?us-ascii?Q?pc9dKQL4dJBBQrkPmERQhZAUhOwlnsssKdfenpq+QLRaT9Tj2bGEirplyDpU?=
 =?us-ascii?Q?ZvmT3/3/HwmqRQRTlcQegjtfmvJnOsc2dZ+BrdVJOGFDqfWlblKwvfdII5LH?=
 =?us-ascii?Q?wR+iStOEBAmm1Ko5jzxTyf93fRIwlDoeGTLGLyPidVIliOlcFyEeDXF3YTEm?=
 =?us-ascii?Q?hbV/dI/OuXAbdA43hv6lHnSqza/CewacbWPGLDtqZY7+viaNdyLNR37LjPHS?=
 =?us-ascii?Q?bflVD+2CO7wXC4AEzFGtJWtIm734uM7mL9BUwJ82AB/SN8tzkPoI5P4gPHKn?=
 =?us-ascii?Q?JeSn337b+83aKapSdCDfAD18VCc8pw3TNBHLFQmTTaHhYYVFEOr6OLQlEt9m?=
 =?us-ascii?Q?WSFMmqcCXNU/s626VEnt4PA2+STUM/hS77LUa132JPPrn44cYOG6CrFB3zU3?=
 =?us-ascii?Q?JFQbokymceS6wruPKfIuZu8W+uKzv9HFx2G8g9HigEo7Vk5DyonmU+Q86eBH?=
 =?us-ascii?Q?R/d4aGvZp3ovGbB0ovsGrOdUbkAuE2n6AbqtPmfj9wjhKBqlCcsOdiIRJs5r?=
 =?us-ascii?Q?GWRlK6lrJJ1rcFq/5q2TV2eO3sWS4EgrCYh0xk9jjTGlE8DRPlH9M7+wMXiW?=
 =?us-ascii?Q?t49zNL6RT10HTUnUBfdWxw/KOi92whVe23kmUBFhdeFrWrOEyg/ctupN3Wpa?=
 =?us-ascii?Q?oUC76fjcYB84ko4pAWu6zVKGGIUxNWqJJFb1lPz+EEsMnGh3h7kJIEVljyQD?=
 =?us-ascii?Q?Dzt2vPA9ZL2MiF0ZyRq32KkWQhm3Jq/kLDETyXdNo1INg4AtIxAlumeqmlZc?=
 =?us-ascii?Q?hefGZa6Avxx3nu54i6Aez5PwOfxQ55oCRcGQCh0fMKajjAa+Ei5ecaSjZvFR?=
 =?us-ascii?Q?siBT1LBAJT0LX9yAc313PJYSgLk/eCYqa16MR8M4AGuE4PL8OJc/yYZ1B18B?=
 =?us-ascii?Q?L6/dsrxAAExSRQnagDgH9JW5ZI7646j1mcvK7hYR3/KUbL/6hWyh4poY4WWa?=
 =?us-ascii?Q?cNNIZKDf2Z6u7Of+CON0AOMi3zf3lgdUpTtM1Oojnzqeo5GOmP+ZqwwfzB1M?=
 =?us-ascii?Q?WngNBIlPdKlUo5PqH+afVMUIqbGZVb4N76yfdLtB1+pur9aw2NXcNYpLTzeT?=
 =?us-ascii?Q?s7V9Hmcjp8qPYVnFp9cWGy6OoRfHDqu1QwRqAlzUfFUHTOk7XC0XFaoUFFhv?=
 =?us-ascii?Q?WQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2003449b-393a-4475-267b-08db3b46475e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 11:08:43.5489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8S2TdX2joFIe3vNSnKz5qA/xBOr31MflDozUT4EpCtiV4G57W1yZ3fOUbpZ+bcZhr8CDwZuCCrrINhOUn9CyDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6965
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 12:50:34PM +0200, Michael Walle wrote:
> >> +/* Hardware layer of the SO_TIMESTAMPING provider */
> >> +enum timestamping_layer {
> >> +	SOF_MAC_TIMESTAMPING =3D (1<<0),
> >> +	SOF_PHY_TIMESTAMPING =3D (1<<1),
> >
> > What does SOF_ stand for?
> 
> I'd guess start of frame. The timestamp will be taken at the
> beginning of the frame.

I would suggest (with all due respect) that it was an inapt adaptation
of the Socket Option Flags that can be seen in
Documentation/networking/timestamping.rst.

These are not socket option flags (because these settings are not per
socket), so the namespace/prefix is not really correctly used here.
