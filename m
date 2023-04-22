Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD3C6EBA83
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 19:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDVQ74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 12:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjDVQ7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 12:59:54 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2043.outbound.protection.outlook.com [40.107.15.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBBC26A1
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 09:59:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGNRdpnAGEgyImmvGLeIIzkc62qXLul+Btvms0tPwLJoHroJCqENgx01bXOB8jpIWW9B4oeV3/Itn8XMU7PK7+uFbVGVcYb1MvOTWIPI30m9uit11Ig1ePY+y7wC3dQ/0XYf1dL2erTc4p9oa7XaWo0nzsqk7GTvQLUvevktMIPU3riD6L7tJpZB6mCNjd0ASNatoTO/kQcu0r8Ypt31Xlhn2Vme4FQNrklCEw3/J0pRSFfsobgBmgONusMR+RiRapO2mnOQHcuolKjh8MGfNtbS13CZ74pkYNw205FFEsPtNDraJVr78MsZT4OnfYpqOSBrpmPKwOWKeXiVKuco0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVIbmV8BB+ib4CrC9MKgyl4K0LMiiE8dit19UKh3/Dw=;
 b=HWTdmq+mj5s9wGTjKzDNNc2i6yE63+2qrEhvui/u147RwsOglO/WwUZ5mOC8sikdTksfAY+3WsgTPOzyRKFGo7/Aqd8epLQPNnPUry9JB7F4LuaNorlkpOZRmUQ3BrKxWgU36ujd60//BSd+hO3TSZRJGuPIdUWIsRohC7EyhzmZjPaEBjESFHPZrfRwN+Ntn1SK4gHdK0RKKcExnzS/hGKfnGsdEjaP39azvEx5sjY1o553KYqXJpe3USF/JRyupr+42pBXQqwv8lEOUMmbD10i+pnKaQP8KBG7Mftg0APN0mHbVFFXl1Zc6HOAnI2GrTw4uyD/xeKG8HAEoLhTBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVIbmV8BB+ib4CrC9MKgyl4K0LMiiE8dit19UKh3/Dw=;
 b=fg8/WE06QdBX2Hjrh2NQKzA85/7hKTrUzs2si8x0EUK9PmdXQyKeUmtdT3pgW964ShVJQ/EHy2AJOpKDwQ+WwmVAuyi0LZxtQqg38uNFstMxQsLFZq+PSPYfdZ8BD3ihUp48cbVDTzhQMvhZbfhdfnhMgAFe2bDr6u9WzECCwig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB7176.eurprd04.prod.outlook.com (2603:10a6:20b:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Sat, 22 Apr
 2023 16:59:49 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Sat, 22 Apr 2023
 16:59:49 +0000
Date:   Sat, 22 Apr 2023 19:59:45 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v2 iproute2-next 00/10] Add tc-mqprio and tc-taprio
 support for preemptible traffic classes
Message-ID: <20230422165945.7df2xbpeg3llgt7x@skbuf>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
 <535c37f2-df90-ae4b-5b5a-8bf75916ad22@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535c37f2-df90-ae4b-5b5a-8bf75916ad22@kernel.org>
X-ClientProxiedBy: FR3P281CA0040.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB7176:EE_
X-MS-Office365-Filtering-Correlation-Id: d755d307-cae2-46db-82c0-08db4352fb1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5hURmzp0wutkRUX/8hGwniXZVgmOUvVxBAI/KeS+6NfHoPdGyExRIHmShl4mjw8xkF5Yosq5yZScvpHQIzDPHpXos+/CDcir1vKClJybzhw8LtYSQgpdWYJNpJkXBZCceeNV4MXio09JwCdm1AqZF8CvvA34Xnq/C/PzTMBUOt9f7SBrzqxQFtfkDwO8BARHFREGHdgEl0RHzj6xe5uMQumOE2ftTPv9PjgKpdfgn6GB+JbX2jRQsHYE2vTHUq/Qt2FYQYtjpD+4M7nodK8jQVvU1QZiC1J1FS8qqEe4drslqr2cHbw0CIpzrob1X+5fSV/oA8rhUe3zxPqhOdUvMavwGWnqI3PWrxOVj9tctLp7XuhIF2onwyFpDQGBf5SACbEaSlPtMy4CAjw+WPyA56GoCPIQeUzEMDcaa5DIwd3476GXSYI05R6nXRcoOvykyp08xLBxlfzzOO/PJ3GsRHrRBOIfyNFDErCXJCxoKHPGk8ChrK54vP/IXLKp6vMtPu9L9GguHK/W0cfmhLwkJO3QUV8Irr7++pWm6tKmWGqJuEKwNeMfWt4TL4W8d7ik
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(396003)(39850400004)(136003)(346002)(376002)(451199021)(6506007)(6512007)(9686003)(1076003)(26005)(83380400001)(33716001)(186003)(38100700002)(4744005)(2906002)(44832011)(5660300002)(478600001)(8676002)(8936002)(86362001)(6916009)(66476007)(66556008)(41300700001)(4326008)(316002)(6486002)(66946007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kepXRhF3SpFDSI8IbZhsrXz416fnYYyY0b9rMUPnhZsU/ceX+z0HWkR2kCll?=
 =?us-ascii?Q?quuzPnaW64ifZz1qVBwY4f2KTXcif5ewFHchgTj3WRhFCgTImTC/2wv0OwJd?=
 =?us-ascii?Q?2ehgK9v/dZx+o5ugZRpzR6LqfEEUUKdtL5tMtkpNxOWPiQBE2lBMiRgE6E3q?=
 =?us-ascii?Q?I7+KdSNCcSkhR/VzoeWau5K19pOrvBFimZmA7BdMOapxBgrCUof84rR92T1g?=
 =?us-ascii?Q?DkwxClU/3TEIqb6fNFH0kUykBirOejXluBuDxvOKUjJErywz5pNrKq9Pd20m?=
 =?us-ascii?Q?KezQL7zvXxgnLNRUA4oJSUK+xAWEB0xDzqn+7wBRZ2Om3ImhfCUdmvfVH2bG?=
 =?us-ascii?Q?439j1MJa90Mle4D17b21oG5TtoHyOnjYXi6Tr+kROgU+9Zt0pcBewgkG8O6p?=
 =?us-ascii?Q?dPOJI+9fXa31pt2Qfb0i8VAo44wzzWBYkUYkOotVGXAttl7bBiB3UZ2Rnep+?=
 =?us-ascii?Q?9vk3DKgYYRmJmcxp3E8VTeDRpLpz1iJJ0zgDoZdc+jtmtFUk5p5zabN44rNz?=
 =?us-ascii?Q?puw2yKUT42NtJ/nm4wveoRmeZklbggMf4CLxh23AGDl7exQOURkpcooyVnvk?=
 =?us-ascii?Q?RYmCI+HiSVwf4uVOl5+CBslC+3XWVHIbQVA5xvUXnl7rje+TYa2fMcgy8ixi?=
 =?us-ascii?Q?6ECZBY4zc5Qfmto9P690w8eW9qicpWZXBWgTAP/HHvX5Pa36l7gXZdA31icC?=
 =?us-ascii?Q?10RzYcmGZJ+8EhshWIVIDiWiEM+cf2iuCkKlqXvnRkp4tGYbJ/uJFvCRsnUe?=
 =?us-ascii?Q?/aJCP+qoNyhsfuYwxr+W6bbyY/UT1CEHcGd8GgIln8XPr9vaKDbZyQOQtL8v?=
 =?us-ascii?Q?Jm8SveR/QQ3/8+TiOv6z9iY3fiQlxnDvDknPGmIWRxBLyarkVX2n9wXvUnt8?=
 =?us-ascii?Q?+AYqNduhR87uJxNH0JFXCPySjcEtQPlHvmYlIYlpE1v5pg3Eatzvvj2ZwHV/?=
 =?us-ascii?Q?VGDWYwTRkjFJ9i7Wzm8N9eanMVVLe/D02rX1kT4n5VZSh4EzFM+z+3uwbxYH?=
 =?us-ascii?Q?y0yQenjpzMU8KXOnvRxDNr3tz9yauUpqwRN3QKtNtv7KptJSIlS5cY6JDphF?=
 =?us-ascii?Q?WxZIPzO4iBx3FpxGWiEX1ohEDZGmLcPqhnWPk7X/8ZQxk0PjXSSLmMzCCQAL?=
 =?us-ascii?Q?nHmUiCeAXS+sccyDwnemCoyeMGtwi33LwMztaBZnWRE64hz2DIL5O6UZQtdm?=
 =?us-ascii?Q?s2eDQsHFHv/BUyVN37hSkQAjREeGUSTN+C8be0tojqzgAh5a92Ulb4WNgGtL?=
 =?us-ascii?Q?bTbWDE8oSp+xXUFhvxeA4z45F7oMuTHQYw2L8AeKzSVT3AuQ4FEoq3LGcHXg?=
 =?us-ascii?Q?mEwI5OOHjEiVilB4KIug+yqasprfwxTJXzr77zNa6UQTs4dIKfcTbNgvUxXg?=
 =?us-ascii?Q?mQyt3tQ+myqAg0PN9gHNLzDavB79pXYv+L+GbZKMlzQUK9sKHcgMSVtoX6bN?=
 =?us-ascii?Q?N5r1dUNBskt5opultUWlM+VRKFgYmXHOyjo6FMztp2Xi1RkWTu3V1TqoY4Ep?=
 =?us-ascii?Q?rrQilQ3EkcD2/9HkUjQraX4oqhpu1Z+EOHlw09vLcq1pPV8WSEHmHTJJj2cV?=
 =?us-ascii?Q?wjQxtGV0OBziMUQqKqE+s3bNTZUbkUgSpjTaEDnPIVAlyPlCuiRUxsmZsMWA?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d755d307-cae2-46db-82c0-08db4352fb1e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 16:59:48.9184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3VMI+XWsh67S+ZKatSf7SMchGvez+i0MjKv/SQFvixmVfh5JqywYH+VTzonSfKUKbrBUzWRQf0YEawPrI0v7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7176
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 10:14:01AM -0600, David Ahern wrote:
> Thanks for updating the man pages. These should go through main first; I
> can sync to main after those are applied and before your set if needed.
> 
> ... and updated headers.
> 
> Repost the patches as 2 sets with the man page fixes targeted at main
> and the new preemptible work for -next.

So the status is as follows: patches 01-06 apply cleanly to the current
iproute2/main, and after another iproute2 -> iproute2-next merge, patch
07 can be skipped and patches 08-10 also apply cleanly to the resulting
iproute2-next branch.

Unless there are changes I need to make to the contents of the patches,
could you take these from the lists, or is that a no-no?
