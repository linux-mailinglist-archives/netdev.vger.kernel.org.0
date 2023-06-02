Return-Path: <netdev+bounces-7458-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86EDA7205B0
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1487B1C20F73
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5C419E70;
	Fri,  2 Jun 2023 15:15:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ECD19BDD
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:15:23 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0599CE43;
	Fri,  2 Jun 2023 08:15:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2fKISemOoUpStM4T3ibnKvZzkH6I2Ol/3BN+9cur8ccaFaJ2rQy6pKLbjuaXWULetjXO77kkdC9/x+QtWrrYO5GiyIIW93YNT45WHwRSjk17KBBCJyaeEt2kvuEvsxPYbFCnsb0Dh1TFCSaB2zLvGQw8exg3PtSaBHD5tptl6STWc/uejUtQQiUbkvEkeEAZybghg7tjGfZpTxGKCv/7l0ugbwSnQgQQOryM8zheYvEfEWvcFx4firA/CSRdz0Oh+1zeIlAS8JWS0KdPyfuXnHCw1/k+uzNfQ8IeLRBmBf1Q/URNZES3UkjrbMxA6LkFkKWr+fD5Tn/gojNLkACsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tAERUP7tWwE4MNECYCM5/ajFW/6s/EdqUivVr3TQOU8=;
 b=PPAa6jX7TLdQXeVSykTMTQUopqiLOzWW4/xgsdbbvTHXUkx65eqqImge3+rj1Rca+KBhmAvkOgrukvSazMN3ahGkZLtaM7d6N8Mx/WoJr5U8KaDuRgofRAmoQfxb/Qf9tigcLfbebRNfCMRZ0+SRAYizRxUu1N4hR1onN3BkOdkqbyzBUd3H7+E7MFsmBHAxwHCNIPamc6war9b/L9dy/2adr6zaZkJ/OQANf63mGm95h8/R62fEZ11aFAOHL3r6ZLHrXmRdrLtwiqauQbFoU8FQ39NYEiFsVVCGapq66EhTeT5VJFDdfxo9cHNRdDgIEO/tFFEkfF7lYjYNVPaIYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAERUP7tWwE4MNECYCM5/ajFW/6s/EdqUivVr3TQOU8=;
 b=Gy9LvfJiuNS2cAtxM+YzL/AwZ+KKxES/EQOReLY/tj7Vl0gLa8vGl+kc60jLZFJyGfkEv3tDHpCDXOji4qywIezXSrTC/oeD0vJD56b7iaJaao6waMNBt+51vL8zIL24l20CWuqKd9+/N0qFmuhdLxU0EOruuq6qr7XxBRJJ4ug=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6220.namprd13.prod.outlook.com (2603:10b6:510:24b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Fri, 2 Jun
 2023 15:15:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.026; Fri, 2 Jun 2023
 15:15:17 +0000
Date: Fri, 2 Jun 2023 17:15:09 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, amakhalov@vmware.com,
	vsirnapalli@vmware.com, akaher@vmware.com, tkundu@vmware.com,
	keerthanak@vmware.com, Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH v3] net/sctp: Make sha1 as default algorithm if fips is
 enabled
Message-ID: <ZHoHfcMgYqO3l7Np@corigine.com>
References: <1685643474-18654-1-git-send-email-kashwindayan@vmware.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685643474-18654-1-git-send-email-kashwindayan@vmware.com>
X-ClientProxiedBy: AS4P192CA0036.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6220:EE_
X-MS-Office365-Filtering-Correlation-Id: ae704a03-8b8c-48e2-d673-08db637c2c1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	llNwST21VM1nWJmYHFDD4E6Y5JUUGeAcBZqsUDTxV2FHJP2xYWVrao7B2Vxj82eTG4d6dCDDHXLYrk27tHOgWqXGpEYNASt5NFrC0KWRtdknx8NiUBnK+n7MLVbmm9Ru49EawveQ6fmwotCWJ0s2YxkvOC1339/GZ0kyBiZv7++wd3sfucWRC0p76ynzY2hjoA+2CtOHT2+fKjn2BRLLouQ3xEleyI2Mh5gCIjeiswfAsyMnMNW/nq/Y/q+BpZqtKbUJyhg9MCWi+mSxd3thusQlT1UM20l/49U2lc9QC9TDf3J6KM4GcBCefwxo3WNKBAWs/apmAOmxn4EQx2zadJSeQA9VMbh/owaSqvVXV1LMAr6m4WUlvvYW6OOiwaSd18zMx82kNE6ltgYMcCTGaI0zEb0OEF1QOWiYY/8aP3fUotoX4P85968xmus94EexfMHE9Mqgj2QynTemw+Ag/kg6GAhdhirF7eS79/0AgbcoQqYP1e58q86+tgwogfsASes2vFSYOo/Dlsxu31jCmx+qnc+LWpgaxk7VODLBHT/0d+zLZZDH8lVS3DKaxV6aUC89TIoV431kCcJ+SfWoOrZLaAU5sqskJpzEhykTKhQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(376002)(136003)(366004)(346002)(451199021)(316002)(186003)(54906003)(6666004)(6486002)(86362001)(41300700001)(83380400001)(478600001)(2616005)(2906002)(26005)(44832011)(66476007)(66556008)(6916009)(66946007)(6512007)(5660300002)(7416002)(6506007)(36756003)(8676002)(38100700002)(4326008)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R/NxoXN21GTc1zH5YEfN7JhEYk9wdq/dfYC8iIAJD08Wj19SEG6Duus1MmtQ?=
 =?us-ascii?Q?1m8SQJCxV043oa95+xsaDTcoAws4/t4n5jDpwJr+8mnOv8qQCkKuDpe/j46H?=
 =?us-ascii?Q?MeripAI/anaf5BBLFoEGLdhSD77v2b9akfk2DETXAIVeHcDXADra07WKDBHG?=
 =?us-ascii?Q?CgofPXFiMr7U/4wmsBxFE/13DI1To7frUkx23A8HLk3AYp2NjqlsprX8xfKK?=
 =?us-ascii?Q?TAT8IMabp3zerXclJq2KOoxnvBtOYtn60WjpPreSemvdDrrYPBfaJ65LrWNA?=
 =?us-ascii?Q?3TByAIk//fwvEosSeTSSPiF9Szq52XB9jEjE05ft3g6LS8L28CKbTW1Xp8HH?=
 =?us-ascii?Q?nxx1NbUU+THBN+Vzdl5m1l2ylqUsB6wzm0bk1iVTEdA6kir+7jf19gG70DyB?=
 =?us-ascii?Q?sq2r3725vmNK8QQSVLwdvqL3R9ibqPFXKFA/7Z0ZMs9GPxUSRU3w+yPAByfS?=
 =?us-ascii?Q?BZgXFG2JytJUVzH5gfv7CPGasglhN/tx/YI7XkmmXqHHilhN1/eiTe05jAgZ?=
 =?us-ascii?Q?F1H1ue4cWHCwq8xahmXPAgtOKTmISmGSUdCmh4RuHOnpvaL+hQMfj+oodySv?=
 =?us-ascii?Q?FuQ72ry/XXMjsIw74WsoGAJTsMjPhWsXiGhNmq/mEBzBiZXdvZLviP4L7e/6?=
 =?us-ascii?Q?x2c9LoAgyqPfidhjw0etMklWL6m+bnSvXPZvNIAFY4FOj+tQ96DcQjHtYYRh?=
 =?us-ascii?Q?FRj5YlqM930T8XP8NNic8rDMca06woKenEol8CQlxLBrGRFj1YtcewetsGVi?=
 =?us-ascii?Q?RfRpfyOCEPAidhQ+k260rM9MJw0JkqaGP58WjsgJSTM2h+2jydfU//Sgx24E?=
 =?us-ascii?Q?K5dVu7gZqTGeszCIq1Qg2fcyZG3oZTeXbupqg+6rXNNYugYYR3XSoonc3MZ5?=
 =?us-ascii?Q?cKA1Gw9uuCaK+q3jzxyPFBweUdPGIxzgfKPOyFh8+7NzoXubzCUrpmT9XMk2?=
 =?us-ascii?Q?HlWTUmI0WWd7iMfFqytWrMAHF4u7E9pHLDy3o1ywF4g2yv4qAWfEbrqLC6v+?=
 =?us-ascii?Q?jlhqYROysIq+WKicMePPEbhRWoCbxwschQPoulKa00oSt/sPlJM1pw2QvfvM?=
 =?us-ascii?Q?nXDVLWOb58oJ9ce1AKypiKgi1Qd7ppUxci2hKR9io0JpxW7/M6LvEXgroeRz?=
 =?us-ascii?Q?fLQy7SLCPDNpjlcdj9t/oI2P/GUdxhFdoRFz57jog5hYV7EiICbPDX/zxSex?=
 =?us-ascii?Q?yMd//LC7s53G8f7woXMb9i00lDAc/s0RukWFkUQKgP3yqMjZpvhV+xCKqj8L?=
 =?us-ascii?Q?kQNuMkzCudpyVUpH3yQHq6j3kRETDik8piAkpLeo0GQgLes2wHXvrPxmI/ND?=
 =?us-ascii?Q?YzAV0i7mulvTw1p1MROTf6MwCNsxCqsrsJyLxHdJLNcIvG5tHDeYkpU2/VxK?=
 =?us-ascii?Q?xh58BShXNALiwIZzjGlSiKFd/laSOMm+vj3AJEfx5xjXkkO0Z/XQwXviFgAj?=
 =?us-ascii?Q?bAx0yo366alItbY2kEUviRugTrSPCPdun+TBNKC7bXG0Bx/q6WTQjnFrQcCS?=
 =?us-ascii?Q?eHLbyHuGuWwS9/mRwlqqlQsGUlTa1+XMJPMLk/d2nqKu7+Ym68aqraeZgwFc?=
 =?us-ascii?Q?lx4269LSZJutSJmA2uy43VyrqaAbJu06qOOoKukhj4+q3OGxWbGu84n4HwH9?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae704a03-8b8c-48e2-d673-08db637c2c1e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 15:15:17.2277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXvoIGFWYI6yz2X5ZMpJKuRYPm4m/B8nbq7M5WHAMgrvQB4+R8+nYwXyvp+tNMsJBkEC4Oh+vw1KAFXd6mE9JWzr5wODoThoZtyEkBXeBLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6220
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+ Xin Long

On Thu, Jun 01, 2023 at 11:47:54PM +0530, Ashwin Dayanand Kamat wrote:
> MD5 is not FIPS compliant. But still md5 was used as the
> default algorithm for sctp if fips was enabled.
> Due to this, listen() system call in ltp tests was
> failing for sctp in fips environment, with below error message.
> 
> [ 6397.892677] sctp: failed to load transform for md5: -2
> 
> Fix is to not assign md5 as default algorithm for sctp
> if fips_enabled is true. Instead make sha1 as default algorithm.
> The issue fixes ltp testcase failure "cve-2018-5803 sctp_big_chunk"
> 
> Signed-off-by: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
> ---
> v3:
> * Resolved hunk failures.
> * Changed the ratelimited notice to be more meaningful.
> * Used ternary condition for if/else condtion.
> v2:
> * The listener can still fail if fips mode is enabled after
>   that the netns is initialized.
> * Fixed this in sctp_listen_start() as suggested by
>   Paolo Abeni <pabeni@redhat.com>

FWIIW, this seems reasonable to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

