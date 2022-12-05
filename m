Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399CF642E92
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiLERXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiLERXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:23:21 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2045.outbound.protection.outlook.com [40.107.6.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B6721AE
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:23:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dq1AfWOi4GF4znJN00FpKBI12TizBriUqrJ8aMYI8QYtI9TXoMwfH4zJ8XIl6lpVD5F5M0OwUIzOBSZ+fXteoQ/BEfqh93ZlVT/OBRDD7c9EHM/WvFVDFNiKhE5EjKTYUHB0eLZceS0V34com+t52iEvaRozs8KAVEdv0YAtwSLciytH/OJ8OrdIrCgT71lUzC/f3eEWfH2efK8RB6NrTMMHAc5ob3QWwHTMQ+LRtY8rOaug9ocrCFzAxADhZRskBgqkaav+DPzM3P2nV7ukGzhefSZYx2TarnkkmxaFVtbl7LJziKK//MYvVkm5/CQqoJmzNidHOpYEnDFBuhqtcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=baOXkWdV3VW4dJxhTjB+jlo18TsxMOdjH5vZh7gd5vs=;
 b=A5WXhr3q9m+mri+NqkILTWDi2w+uK9m3939fvBv9Pcp3AkocXtoFHXXnVW2pbl8XJBVg16feYdLbYQGYvXb2gu/GLJu4n38GdjAeNIwpyIP00cvY5Q8qalNFzfHjOroRkNQYsVWKsFioU/8NHQVsFvtZp7Fkt1jr5Hxn1RExJukuKk+TPMkHt1eJQfSJUiGhEwI2phpxFJvv36SwqaD/aUEUu54Uu0Ym7CukalODUZvFgpnK7JucHRUw0eAFhB2zkcdCkEvFDDlVk1iBvYe4Xv7bWb5rfnyI0XdkFwguODnz27aRbhPdFajD/oH+Har45CH+ALdM8M9CsVL2PEBP4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=baOXkWdV3VW4dJxhTjB+jlo18TsxMOdjH5vZh7gd5vs=;
 b=kHh7GVOM99vIQkwYw3Qp13Eedy/f1Itjug4HHmxn22OD8P7aw4DkayIrRniC7UXrxluRSo3t/itIfvetbB12ara4pjKPjrpDkFJFNf+q3w10Hv0MHMec6TSUPhHPomO8ZZG+w0KFUDaW9KkAh5NaW8ZBgQHnw9NedwVPo3Ig/gA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8158.eurprd04.prod.outlook.com (2603:10a6:102:1c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Mon, 5 Dec
 2022 17:23:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Mon, 5 Dec 2022
 17:23:16 +0000
Date:   Mon, 5 Dec 2022 19:23:13 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH iproute2-next 1/1] taprio: fix wrong for loop condition
 in add_tc_entries()
Message-ID: <20221205172313.hamtm5woa3czr2zt@skbuf>
References: <1669962342-2806-1-git-send-email-tee.min.tan@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669962342-2806-1-git-send-email-tee.min.tan@linux.intel.com>
X-ClientProxiedBy: FR2P281CA0030.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fe06cdf-42d8-4f15-0990-08dad6e5658b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nhS9IFLTwO34jY6KohsS2t73VTZwO7YnH1flElz6hBTSw47CuhWubZv4/QY0nM1BtFQtwJA6g5rUMpbuml5Pr5Qaj7lgmWu5COKX6D0z5fI3pNZIVoukfKU0ij+qwcj7z5/IvR51rRDodNkCdZjiYObR0UtULVCAZh8PV1rsbNoTDR73EGg3C+iTrNYCUxtf6KRTnu4US5HRYIDb4P8/HwAsYQxUvVU+QCgxWbkh+KWrKwLV/BwFJ6k76ZIEnaUPzt5KJoHQ2FOQKb3iEEHSFGZZfp3+6/NECi1Q3TVQmLxsTH84kgQJxT3uVr+BTlxIlawLl2c4RJJHDaXw/D+3n616SLieCegCZ5dHgqwr0GwS13Y+9PT2cBF4Q0cqIlLFJSVdruqx8LM/ztyLAGmB4LkLl6rwLshcd8NRlVBbsgq93aGbtrCBo38RpYXUldfe7pVIbnwmEGo5YBJC30TLo9w5aMC/XlbMmuZm9PPRuu7wr6+JR5I1025bAsRV6+A8Fn9Dpdg3NGOP9vtztKTBl8F6xFQLNvgLr6xXn+d0INLZzWN8x3wb/9F2gvwCC9lqVjUX0xpnTiSP3RRHmifjK3vcKS7PgQFr9bSL55/r1fOj7rIWRYz8LksKN+Y9rgLzKwOrLXOOTsdF2fBQvLZ4jA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199015)(2906002)(66946007)(41300700001)(186003)(1076003)(86362001)(66476007)(38100700002)(26005)(6512007)(9686003)(33716001)(44832011)(5660300002)(66556008)(8676002)(8936002)(4326008)(4744005)(316002)(478600001)(6666004)(6486002)(6916009)(54906003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UqFDgzVh5UQBD6PJP8YsE1nBnkWAt1+YUl0aD5JFGCLjvAol79u5AL1jkyGG?=
 =?us-ascii?Q?IrG41xR8ZFpCUOiTuO/x9QvRCI5Lf4c5JwrAtY0dYxzuyLt+kTaCN0qH3Vje?=
 =?us-ascii?Q?FzXWl6jQYW1RbNy3gm3K5h/hLTXBts8UMNV+kxUf3WKhCEn4+RLQva4/qnZc?=
 =?us-ascii?Q?KHXT2Pm+9JEH84H6U0JGec3KZhfjqnG9UYkB1V8JbkFOhelFC8k+QybZgYbA?=
 =?us-ascii?Q?nS1jiUchJBBVdtJdigZ8YDdu9lSr+7epLqikgXmb6sbirBreGzrEjfZxfNLP?=
 =?us-ascii?Q?9TGauy7vd/m0g8ld4C5U63dcH4hrWZ0cXKbwKtcrWfSgrkmcqmN9VugYYVbp?=
 =?us-ascii?Q?mpN47g8mnGDY4aWA+1csi4OeKlTR9Dhtgabtw6qwfMrFggz3jQHHCUzoQt+t?=
 =?us-ascii?Q?NUL7bkLTnX4btn3ZUUa6x8+LtkkTambrclFd5dOJtfoC3Xyu078ywNoRq81m?=
 =?us-ascii?Q?+dO2FO0aMrKxtI+dIh+DhrLsL0AG8rUvL5qmhRZruZFU7u9qALt3XfHhH809?=
 =?us-ascii?Q?x9mWxOp6SNIZ1Vrt/qkmTk6AHZQJQv3oE1Ygw/6bHA99lRs/mKEyt2kkYApz?=
 =?us-ascii?Q?vcRcXkX3N6wi2shwn7heGFaFe1Lm/XACZgnZ45N/9gVBY4EXzdP+6QN76coo?=
 =?us-ascii?Q?teCv6YBzf270HfclDOrPGmSEWgmdQ5QxbVDynqs3vr3I9IfGWyFugwXjR6Mo?=
 =?us-ascii?Q?max13jm6solrBOjbRvRjlZ7iJ2VqzrO3i0gJTE2vc7VspQgUEfl8jMWXAPUS?=
 =?us-ascii?Q?9/G8KtxB/bUwdmd9bxC/QytNlloF3BBwJ2euW1MF60FC3IdWIAkZtJARh83l?=
 =?us-ascii?Q?HO/KZNDzDolbIQEBgPEsdZxQWrrM7m1HZQeht5GnypZEDfKdyGP9kHgdXlya?=
 =?us-ascii?Q?MKiNPMxXGg7ScyraZRPNaAvhxyDtdo4f6Iegg8R4amEAyzkBW65WgPWVzta2?=
 =?us-ascii?Q?CLU/QuXzj7/6LGS/41QHka16Ao9S3NCwE7F2j5tdan3luyQYDMkux0N+cwuP?=
 =?us-ascii?Q?woxBL0TCvZFA3UrZ/6b+u9FaqXAOjsFNcrUZy1381XZ91gBP/y0NZCwFeJCp?=
 =?us-ascii?Q?mzVL4WW8qrA3fwSd5M2WmS/w1NVBoZC03HXAhw1MXab25jR916uEper/KpUQ?=
 =?us-ascii?Q?AagcTujt6foyMB8mN/9X8ltb9GCYFYS8cVZAIhUizslGlH2iG/vGaDbK0bNu?=
 =?us-ascii?Q?MUdWEVw5nSR3qbiLqtQRncIe2Av5JGPT75MoaPMYQUH2hKR6wIcs6/QUHswO?=
 =?us-ascii?Q?sP2fcUGGlMPgI7P9dExY/bxxbCrBdtt4UIQ17kr4hivBCywcRqVJRGQ1YnQ0?=
 =?us-ascii?Q?Ppl82qnY8XPlGTKrewR7jU61I5s6f5iGO0Cnthf1HcOaMG4cw3kXq0I8eQme?=
 =?us-ascii?Q?PY/a099cybC19NJ49eOD1MERisAybfBUhNmrFna+LJFHSfRVqbVmBqiYHUjB?=
 =?us-ascii?Q?omYDuy+iIp+CN2UEl0GgaPpveHTYhW8xjpjgRQ5lNgiOStb/HiCkJ2pkx3bC?=
 =?us-ascii?Q?R2WpvptPIAXzYiHArLehT/a2s3szh7gdpvTEglB6skd+RwJzyU9BfkHjMROw?=
 =?us-ascii?Q?pWE9uX2JdUgxLHb+JfKBP27EhAQ9li9ugJvJNQ/9EoLCWMlvSo2xCuZMXjYT?=
 =?us-ascii?Q?XQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe06cdf-42d8-4f15-0990-08dad6e5658b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 17:23:16.7999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EfjNCkT8BEradk/7FAfYuYp3PIzN93LfvDoU04n5RUWVITnX22JlPqpD/wwTkBrbE3hayAEa+pPOxjIv9+ISuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 02:25:42PM +0800, Tan Tee Min wrote:
> The for loop in add_tc_entries() mistakenly included the last entry
> index+1. Fix it to correctly loop the max_sdu entry between tc=0 and
> num_max_sdu_entries-1.
> 
> Fixes: b10a6509c195 ("taprio: support dumping and setting per-tc max SDU")
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
