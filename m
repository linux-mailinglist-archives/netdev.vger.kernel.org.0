Return-Path: <netdev+bounces-6872-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 201DB7187F4
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:03:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B833B1C20EDC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540FA1801F;
	Wed, 31 May 2023 17:03:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DF317736
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 17:03:14 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2120.outbound.protection.outlook.com [40.107.212.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81503139;
	Wed, 31 May 2023 10:03:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Puu08xSwKHZGjixwCJavPsPe3PcbCHEwQVFiXO4X51H/xvHep6Zwlv8DdjnMUNoaY3h2rCYc1io9qbhzc2Y5FNYHpMg2ipTZSk2DNoNF12+Nvwxy1NWtZtr1TtYA/YKvBDqdKCvh5H52mSJcYd2ohqOXaQ0TrZnzEx+Qo3ergN46R7gOL7suRBTnnjODyzc+m9bMTr03aX8emvDBx/YNXYzeh24QAyIkVdOdqPVRI8Vb6Pa5pWbSJmu9B/FSJISc8n1ly6pvR65GPQghKclfSxufzr6xpwpVyDVzJlch6KLYrLhE+EjRdcQv1BDA/sBa2eNwQqsJZPt35PYMtDBhag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISmg6vTKkuqnUPwvHsEl5XLHMcQyMZAZ5zRIBeuCsVk=;
 b=cVvQ/3gYLnruQJQNE0CQ+3umLaJO/9bNWknFxsRaP7lk+qi44ahWCmV2x01Hw6bfCVzHoyDWUNF6QO1wp27DmBxxzz1n0nT1TLeVl48OlWbwDowN+kFZ6lopYuWk61Rtdv15tJE+qNVn88zmAaUyJxc7KsBIHv8c4kO9o0YiDKez43V7WyTWwPzSb5AdpoWHwZCSlefJczgdR8h3RvASLsIo6atGd+p4uDnDdyhYRcyp1ABveWzEq9J89xgtUSJkHaQAlOyseW4BDcffPpMoq9bNLrkJ5D+nTomIE6+Cdhz/1FDhL1XCbJnyWKq5+posQJ51V9uVWEUdCRtCr2BYFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISmg6vTKkuqnUPwvHsEl5XLHMcQyMZAZ5zRIBeuCsVk=;
 b=IlI8K9MxxiWY3aeRJVpJKDepZ2BnqlUlPXX9ywRoe5uLz5ngJHbg8y+iqXVEB4AmkCaOTxBp5kqJQaZkQ0Qn24xIE41L9C23dwxgJsYQE0M+M+1sNVb5pVNTwPCkUFCtmK9KE1T99t8bXg6a8eYSNW+A1TAJfEGTAMYSc2LdBuk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4839.namprd13.prod.outlook.com (2603:10b6:303:f9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 17:03:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 17:03:00 +0000
Date: Wed, 31 May 2023 19:02:52 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/6] net: Block MSG_SENDPAGE_* from being
 passed to sendmsg() by userspace
Message-ID: <ZHd9vCcBNtjkqeqg@corigine.com>
References: <20230531124528.699123-1-dhowells@redhat.com>
 <20230531124528.699123-3-dhowells@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531124528.699123-3-dhowells@redhat.com>
X-ClientProxiedBy: AS4P190CA0043.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4839:EE_
X-MS-Office365-Filtering-Correlation-Id: a1fcdcbf-5a09-46f8-caec-08db61f8e399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M+oztPPB44I074oovH3o9XoOeiqXHeymXD0b8QxFnGcRe6GsNbrjNmgqSWMwmHOVd5dmcPg5HQ/7GiJrcwfVIxGseLpFTc5S7lprfv4U2MH9TVayOCAk4uKL7VugNHRFF8otG3tV+0SwKLmu3RK4SpTqanVyCxtAiPlTlcM9NxH2bdHQiOVQRVWnKjcZPBPf2CxXGgR3nbzMkaV3hkmrEQsBp3bvOQYH5OczTWlvMIgdH3tSfW/NOnWNXneSV+QW5xzOVvFxxwQaSs9MyWYRaV9+hpRVcD6y5kNU39IcRqBOUu+UBVn2YlofjCEel0nfqJJqh1tqPJUYhqPO57KFzRE2imPBOhK+QqzQo+FSer5YtkhRqCBifI3NR97A2W0C1zGF7G27uz6fv4mgNU2vi4YpWbYjkPtt3KRuJYVazx/Ld3F6kOAT/SM4kmxEHr9Ab4T/8i3gaZhFVU6z81clf1arZQycvEc9HGrDFRCSx+MfEfGq7WsWjlf48DAEvXp83fWZn/kcVbL0K+iGJ71gkxvfsRt8djSLi+bO1mcc8tB+KQNQ8nZ5nn/Fu7Yi6GWeriPhRhrQA4iKw5uTSs242Q4d2MCwdxUlPTB0h2ddEpA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(39840400004)(366004)(376002)(451199021)(6486002)(86362001)(41300700001)(478600001)(6916009)(6666004)(4326008)(44832011)(316002)(66946007)(36756003)(66556008)(66476007)(7416002)(5660300002)(2906002)(4744005)(186003)(6506007)(6512007)(83380400001)(8676002)(54906003)(38100700002)(8936002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?61BJzjAl+CaFtLMdncEcfnq7xPWk9kFploZSkMglcPWwxib+b2mVTWQ7FydH?=
 =?us-ascii?Q?mCv3lITNnHLoz15a8/nFKeFJzdTvu1kUtrqgeaMKDdMJj3s7sKcBdOTHnAUj?=
 =?us-ascii?Q?TPEVXbIEKF45k4yD6IrF4FVt3RY6wC7jrkwxNPBhwDktR2XDR8mIPFyBEL8v?=
 =?us-ascii?Q?gSN2c1plJFXt5rqYK6hAGsBb3FwZiJ99G59oWdPmh5uXTuLw9rTxNqgs54nl?=
 =?us-ascii?Q?g1Jn84faz3/imQw9Vn2bvfBWsJaAMzz322RmeJoNUxtbfXJXiAnKM927QBRH?=
 =?us-ascii?Q?kM/dMm2xE6bMBGJ7Rmij714EacVtHAW/kStzX8muJ4OooHzV5nbkei5cSukE?=
 =?us-ascii?Q?G1amzo3uE7Tn6JICqk/QfHdrPJmFPNcuHDfMKlN+jQXfG1Y5GOeoqfmX8GNu?=
 =?us-ascii?Q?QNU5ruvh4KfQnhuvkqkdoBgW2PpTXEyjYAaYu4qA1gvbYF6yVMEfNFlW5dEa?=
 =?us-ascii?Q?dP9uhyqkg565qVVI1gjIC0VCcKdNjwTMuMpcn5XxJkrxINHHzNS1Ers+rHem?=
 =?us-ascii?Q?IzNjZGdCACbz/ijz2snkCIFB3+7j400T4yc6oSdpEdks1JIvXgCSpC96e/jT?=
 =?us-ascii?Q?ouhbX6hX/XvFktvWA2ON7vXWHwM9tfIpah9ZvOv7J07YYHoZ1Ra3Z+cVpLGj?=
 =?us-ascii?Q?WAwZMmgwoP6oBPuyr70rQnkLCohuB1HT2iyKQGTDrWG32ywBfpHPypCnKXHH?=
 =?us-ascii?Q?6EkyOHRO/PpLD4GSJeNbJ27AR4NUV0Xuslt4jM4irBEMnvl73lN16S+mniWu?=
 =?us-ascii?Q?3qadZAnHUoX9uizcNdvfxZ2RdL/rvLEVhylP/d4CMMHVUriNlUIyha8aoHA9?=
 =?us-ascii?Q?o6Kv7X0cHL3qZ6bWxkUhQXclCCmOpTf2k9SlLqfZo3xTdlTllM+3Ft58el0P?=
 =?us-ascii?Q?xcNsJMFF+Q4x/3bT/i8X+4+mDU9bda6fC455xiQ84qTp0nVfVFt642Ugjgdo?=
 =?us-ascii?Q?LWh05KWfZJZhmDE+xQzPQ8kaYeNaYNSmB7EQiqpO/zkw5HqnnHWib//IbSTz?=
 =?us-ascii?Q?in57ci3Ur7UW3vnZNtMCauEeX7DsAqGNubrRG4Lao5o3PW85RAaBBoUC5Gbw?=
 =?us-ascii?Q?XHEb860Irat2JwXnmnSE9qzEvP0BQ8v2da9RUcfug68u7YmgmnMSFNv2q5Wh?=
 =?us-ascii?Q?YBMj+V5QahLAoPzSoTbvvn787/UNI9L+7ca0TV/AbSGlucghr8m+Usqxck1O?=
 =?us-ascii?Q?ZIB/QoVjjhHpqlEOkE6o6gl8pDaJWH0CwCqCgotdXhELAKhih1qASKyDbHg+?=
 =?us-ascii?Q?63g87DjCVzYZcOID6oJbwvwoIWzDGdYkqzeuNivlL1JKHFSB8M4OT4/Mj/nG?=
 =?us-ascii?Q?evqcQznAlPcqlFvmqB2u/k9n4lXd9p+8HvdUZjEKPl8wrMlAeUJgsiJTljTq?=
 =?us-ascii?Q?JcYfMItOBxOljsVQdNLSQk1lLYxr6iEZK9zDtnizhBZ/9xuerFtAimUVFDfU?=
 =?us-ascii?Q?I/fLNfWc35S3l44DmKOBlqiKz4cbc14rtQ10n32w3E3bnLT8tt1QPXE979An?=
 =?us-ascii?Q?2xUaRj0C8daKg4YvrhiJdIKsUzatnVIQdvMZ9wi974F5MbeQivJUlyUfBDcR?=
 =?us-ascii?Q?e5yvhJ/9cc4vRvkg0tSV+VL0jLIQcXnlCpElN31qAeWSrOrMey9AlknIXWKs?=
 =?us-ascii?Q?CinMzkUqmZ4GScsMF30P98Qj6SeXwC8H0DSOkwsbjhakp4F4tVuLIGo93RMH?=
 =?us-ascii?Q?OhUkrA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1fcdcbf-5a09-46f8-caec-08db61f8e399
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 17:03:00.2736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 44HFhWcAyLr5fcV728HBXFWxkHsQGS5keuMgPfEiBaZQm5mcY12dEwFjRegkVcJ0kFQ9B2gkBoM0qfH4dz039m/ub3n25bjertEmEId58w4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4839
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 01:45:24PM +0100, David Howells wrote:
> It is necessary to allow MSG_SENDPAGE_* to be passed into ->sendmsg() to
> allow sendmsg(MSG_SPLICE_PAGES) to replace ->sendpage().  Unblocking them
> in the network protocol, however, allows these flags to be passed in by
> userspace too[1].
> 
> Fix this by marking MSG_SENDPAGE_NOPOLICY, MSG_SENDPAGE_NOTLAST and
> MSG_SENDPAGE_DECRYPTED as internal flags, which causes sendmsg() to object
> if they are passed to sendmsg() by userspace.  Network protocol ->sendmsg()
> implementations can then allow them through.
> 
> Note that it should be possible to remove MSG_SENDPAGE_NOTLAST once
> sendpage is removed as a whole slew of pages will be passed in in one go by

Hi David,

on the off-chance that you need to respin for some other reason:

	s/in in/in/

> splice through sendmsg, with MSG_MORE being set if it has more data waiting
> in the pipe.

...

