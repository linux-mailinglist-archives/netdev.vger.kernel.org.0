Return-Path: <netdev+bounces-5911-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B40E71351E
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 16:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A62F11C20A3E
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 14:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2E3125C1;
	Sat, 27 May 2023 14:14:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A835111CA1
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 14:14:02 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2091.outbound.protection.outlook.com [40.107.101.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930E4E1;
	Sat, 27 May 2023 07:13:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtacG3VqE8sDHh/UmGU9U+12p6VigjPu6a5L9tZysE2My7w/IYAy4zE9qYsA4+qXb55GquoGuy3sA/FeRrfFkBwBJPthDK0gQaQoIUf+ssglVkjilvfk2/Gqd+IPgmLESCvzidib93aKXC6ZwXdVS9pG9GL2zWH5ssN6GdhlWFqjUrmVVzHh5aSmja/i4uVDEs6JfJPKMc3qk8udcL38phJTt4wU/qka03faNaMn4So8Stb33Z+XYWGDEFOlSG8Sk2LROV+0KV6UrGv1R0j42m9JevpwY+ROBz+BRRkZ0Nzrp42aRZb/7yAeYn4p2u5f9SXhveZ24faLkdcRpNNWkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xS9Coa+2txA4KyUllsZLmdVQgwbwxtnHV9Zx66hxvA4=;
 b=CyyyITFajwtr0QunQMgCNeLF+Gw4vif6I7z+Yk8zcwE5ykipufhlof+enqJargJoLDDku3HR6Ex4uLtBTsQX79vt6+BPZHBxYo1zYX7nqDRi0FlGbmqfLxvRQz2C0KwEXQYF6Ka5IVB0puHp0FWM+UN+OysLk2O+Ftjd7F1xVfl70j20EVrK8jD+z7JT1ZuHFuAnVmx0LlkaTs9F6XiPyslJIvbH5RCqHODoCIyEfv70JJNXHV1iR0YzGsHLnMq+sMLvX38cy9gCuVIgAxmNZf34CnHvyO9rEKwBdycQU4ZLyZMmIaOc0fCZXqOBGmCuaxe58GzYbAspkUQvC+Ikeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xS9Coa+2txA4KyUllsZLmdVQgwbwxtnHV9Zx66hxvA4=;
 b=IKrlOKfmEok3Fb2BqTtrnk2ySOffwNkoCdufAd41K7hEHSsTDkLEpMLUhrP8R8EolqeHkBl2tF81F1rXOKHe21JdDEZa0sysQAjxde8nF58T8xp12MBRgVH8zhFz8AzeXCd4e3WT0HfpO2kwiT2dETeDMtwsqMQDYapbU/VrxKA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5191.namprd13.prod.outlook.com (2603:10b6:8:d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.19; Sat, 27 May 2023 14:13:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 14:13:52 +0000
Date: Sat, 27 May 2023 16:13:25 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Srivatsa Bhat <srivatsab@vmware.com>,
	"srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
	Alexey Makhalov <amakhalov@vmware.com>,
	Vasavi Sirnapalli <vsirnapalli@vmware.com>,
	Ajay Kaher <akaher@vmware.com>, Tapas Kundu <tkundu@vmware.com>,
	Keerthana Kalyanasundaram <keerthanak@vmware.com>
Subject: Re: [PATCH v2] net/sctp: Make sha1 as default algorithm if fips is
 enabled
Message-ID: <ZHIQBUEvo49G9j/0@corigine.com>
References: <1679493880-26421-1-git-send-email-kashwindayan@vmware.com>
 <ZBtpJO3ycoNHXj0p@corigine.com>
 <4BCFED42-2BBD-42B0-91C5-B12FEE000812@vmware.com>
 <964CD5A7-95E2-406D-9A52-F80390DC9F79@vmware.com>
 <B70BBC83-2B9F-4C49-943D-74C424EA4DCE@vmware.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B70BBC83-2B9F-4C49-943D-74C424EA4DCE@vmware.com>
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5191:EE_
X-MS-Office365-Filtering-Correlation-Id: b43cd07e-86c5-4dac-1fc6-08db5ebc9964
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BUwXo9tsA57GRDS6U6L1MYhHnHDa2f2JVc45QItuY0vJtk/TqrJOdV/Avr8gAiK4jwrgyNRhs9Hp5VtGe5oMDq79cSMH3umPbxmdWbA3mtcDtV6u+ZugutOzK86XsnYnl1eY1Ng0J/aJnuZWDCAjtPjR1y6tJgGTpMgp/XrjMgll7oBmWp8fkoyW+X+Z/9t/DHzFnUmiSsvQkwf0N5hN4uFsBUAW9BkHDkpzeoupE32S1OBvwzRFa1wJG5P11bKKkC9YUNLx661zKiG8ACQzi47QjMaOuf/7tIc1Q9Dq4ieMDNweLjLIZ/Ce5V43HWJIOlA6YFJbEgCmk6tqn5q2XPVx+S/L0kp61Wtp7iyU5zTweRIUJRzg4UH9fq9GU4Eo2Jv5W1DjbQBBhvQo8MOOsZIc9qkQnD0jkBwdFqkYTRtLsp1n6kpGoJca7lTxVNETLxEGIm6dQiXnb8yXyvBfyMZoMe1V+14W7GRpQgxmdhTi2TybgBW1oqKMtME1yAA6G5DVTX3Tc2Hl6opHGmc3efzV26O7Drza/N0v64m695qaBleowmGCP02A+JIVXMUa
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39830400003)(376002)(346002)(136003)(396003)(451199021)(4326008)(86362001)(36756003)(186003)(8936002)(53546011)(8676002)(41300700001)(83380400001)(6512007)(6506007)(2616005)(7416002)(5660300002)(54906003)(478600001)(6916009)(66946007)(66476007)(66556008)(316002)(6486002)(6666004)(38100700002)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e2Ch5nh7MFAqDZlKL5WXiZdrFLQngnlqyVD+HtagM1yIk+GBf5LjMBb7C03+?=
 =?us-ascii?Q?lyog2SUeJnDRQE4jkClyLCzFkCc8emaWXoTyPOs+jwHdVxWmoD4fL2niL675?=
 =?us-ascii?Q?L7e1EfTv55JYLCjhXsF2FTgj2zGyKUK2+lUPqyU/iTp6ebW9sDhHE3Q9pp7b?=
 =?us-ascii?Q?WOuCXNv+wtchtHQKNXqD7DAnjUACEfEK+umANYDBJeTpfmFxoBdO9JIOWWwg?=
 =?us-ascii?Q?gUJGPiCcLKqvWeLKUjlMbAaixoGrSbVokH8khvjXhUf/aT73gMmXTeV5iEwI?=
 =?us-ascii?Q?DDkP6FVoZvoLLEgstCKzGpiEK24NRHvEcly4c1ZE4VO8CViTogTnOQ4YdI5C?=
 =?us-ascii?Q?3Ra9HTSwUL5C30sDrQsgL/XcMkz+aXlMfyM6ELUby9vuw3JwZ6T2aqL+9ieL?=
 =?us-ascii?Q?uWn6d1wXRsz6+VjfJ0ng5mRmuQzdo9lzlbeXTTcO5z16oVNPBenxljHKJ10L?=
 =?us-ascii?Q?J+BfbZzXKU2LUi/epo+YA/O2ywyxSwB1oRqfF8BjxfSZj5/KUF/hkNuEzZt5?=
 =?us-ascii?Q?ZMfx3IF3uRC/YBPnlz1RXcDUWFiN7DW4YrsEyypkfOqIBzH+XI69KUcetBul?=
 =?us-ascii?Q?k3CgXrDR8bI7dAHeSPhkrN+Y3XzRBaVPQXvZjgtBZjjNzyFqS7pf9nC1FMTb?=
 =?us-ascii?Q?TfxTR18InEOENfaJnIix3g7FmuRf6x79MoDk7JPcXLqrAw14TdpjJ1VJggRo?=
 =?us-ascii?Q?jIy+ypWiArc3rAIh8oMQW3dgnW1fpeAS4SKUUwechh6GQBLOfUmsaK6ByCuv?=
 =?us-ascii?Q?LBiJJP/VKBGFOZlwL4EqkZAQa8Xpi2DYggmSTdFy+QQhRK3v+M+9fTlCB5GD?=
 =?us-ascii?Q?VtfW0GnSyVllqbEAMCYdvhpsUlyFnc/C3UJYsEcs9ikrdyLIV9Hu10HYEMnT?=
 =?us-ascii?Q?6OxDZjTNzBtXbmEnXJD8a8rAMoOAJYLOsyerotE+uV1hzdaF1YmjNdONVFxY?=
 =?us-ascii?Q?0oH7rgSJvHATchtoYcLJVogcOU+umY2pLyDlRBqjT8vpFwViRtxj7yGnzGUg?=
 =?us-ascii?Q?3qwKOMvwgyNWVf5IMd2BUhKk2NDTC5UicuhpwC8u21jBnh9bMednZpe8ZkTQ?=
 =?us-ascii?Q?U6z/z6bGMUFi9FAReFhDMTL9HMzneSJNVqu/vcUTQR4Z8s/RNOseNs0JT8sz?=
 =?us-ascii?Q?CSVe9dtzoG9VqyjpVVWES8L4ibkRH0pTF6nuT4gl92nGXZbidGPMwGl5WlI/?=
 =?us-ascii?Q?iYRa/8z191a9MQWkMTF1eLFARB9aUTe1Xdg2WL8HK7wGwCsOWKliprxOEnvh?=
 =?us-ascii?Q?pJ9Leh+oLSFEPe1NQC0Q9lCYcxyM7aR19v4g29wJJyKr/CxHLDPELPR/5ipM?=
 =?us-ascii?Q?3ZSmljc5y7wuAWbZxB2XorVG80LtGUClMJEg4X9muhnnJshPcXzIzbMYhQJ6?=
 =?us-ascii?Q?QgnfUmt2rkGvMf/aBnb5l5gIB9N4o15DPotQ0DI5kGlZY86yWgiNnFoJYWsU?=
 =?us-ascii?Q?qFCQ5oAQwbaCVAj85StXb1MInRodJPQbnHoKhuqE4Cz3Bt9+MmKr3xGdjh9w?=
 =?us-ascii?Q?pMmc4ix5JNdTNbYEEFzNOj444InN+BM4YcFKPGfCfpFu8gng5WeM4moYE7CV?=
 =?us-ascii?Q?x73ezmuNcd4TG5aWEXAi6dA+FFj+4YzmuzWeYsfx2uak9CKHO4LnQJMlxVL3?=
 =?us-ascii?Q?IA3qgDpJK1A2WeguRJHTDbqOk8KpHp3mmFg/1s2Qw9yva/tKzCI+quQsnjZP?=
 =?us-ascii?Q?WqhPdw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b43cd07e-86c5-4dac-1fc6-08db5ebc9964
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2023 14:13:52.6728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OAk/xCzs0OAaNlob69tn3fqx2XSay+7pRJdDxoC6Pt/t9vDh6V7fvPNLxD3tmuGFi3iymPLkaLqMkeqUcW/t3avs3M6oc2NL5Mwg3JoyXXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5191
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 07:49:26AM +0000, Ashwin Dayanand Kamat wrote:
> 
> 
> > On 25-Mar-2023, at 12:03 PM, Ashwin Dayanand Kamat <kashwindayan@vmware.com> wrote:
> > 
> > 
> >> On 23-Mar-2023, at 2:16 AM, Simon Horman <simon.horman@corigine.com> wrote:
> >> 
> >> !! External Email
> >> 
> >> On Wed, Mar 22, 2023 at 07:34:40PM +0530, Ashwin Dayanand Kamat wrote:
> >>> MD5 is not FIPS compliant. But still md5 was used as the default
> >>> algorithm for sctp if fips was enabled.
> >>> Due to this, listen() system call in ltp tests was failing for sctp
> >>> in fips environment, with below error message.
> >>> 
> >>> [ 6397.892677] sctp: failed to load transform for md5: -2
> >>> 
> >>> Fix is to not assign md5 as default algorithm for sctp
> >>> if fips_enabled is true. Instead make sha1 as default algorithm.
> >>> 
> >>> Fixes: ltp testcase failure "cve-2018-5803 sctp_big_chunk"
> >>> Signed-off-by: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
> >>> ---
> >>> v2:
> >>> the listener can still fail if fips mode is enabled after
> >>> that the netns is initialized. So taking action in sctp_listen_start()
> >>> and buming a ratelimited notice the selected hmac is changed due to fips.
> >>> ---
> >>> net/sctp/socket.c | 10 ++++++++++
> >>> 1 file changed, 10 insertions(+)
> >>> 
> >>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> >>> index b91616f819de..a1107f42869e 100644
> >>> --- a/net/sctp/socket.c
> >>> +++ b/net/sctp/socket.c
> >>> @@ -49,6 +49,7 @@
> >>> #include <linux/poll.h>
> >>> #include <linux/init.h>
> >>> #include <linux/slab.h>
> >>> +#include <linux/fips.h>
> >>> #include <linux/file.h>
> >>> #include <linux/compat.h>
> >>> #include <linux/rhashtable.h>
> >>> @@ -8496,6 +8497,15 @@ static int sctp_listen_start(struct sock *sk, int backlog)
> >>> struct crypto_shash *tfm = NULL;
> >>> char alg[32];
> >>> 
> >>> + if (fips_enabled && !strcmp(sp->sctp_hmac_alg, "md5")) {
> >>> +#if (IS_ENABLED(CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1))
> >> 
> >> I'm probably misunderstanding things, but would
> >> IS_ENABLED(CONFIG_SCTP_COOKIE_HMAC_SHA1)
> >> be more appropriate here?
> >> 
> > 
> > Hi Simon,
> > I have moved the same check from sctp_init() to here based on the review for v1 patch.
> > Please let me know if there is any alternative which can be used?
> > 
> > Thanks,
> > Ashwin Kamat
> > 
> Hi Team,
> Any update on this?

Hi Ashwin,

I don't recall exactly what I was thinking 2 months ago.
But looking at this a second time it seems that I may have misread your
patch: I now have no objections to it in its original form.


