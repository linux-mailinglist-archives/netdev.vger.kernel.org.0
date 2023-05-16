Return-Path: <netdev+bounces-2913-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F7667047FD
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:37:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D9A128163A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E9292C723;
	Tue, 16 May 2023 08:37:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7832C722
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:37:46 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2099.outbound.protection.outlook.com [40.107.212.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E4A4C3B;
	Tue, 16 May 2023 01:37:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g23JEsSKQKWeSWzcsk6SxYuJ+d+NatKKMpJq9/102pkSN0l1ul0zygOTFnvSkoYOjKOaFEY1Ys1ALJ2QRQvzWfD7meFmuRf4b6PNoqToRKbBbGo3NXAGEA4GV8lhczeH8wg2H833puGBKX7lOUUqH0QZ5hfiN1oCmN7ovY964IIJgJvYJmYDkwdM18mJR5oD/sVtMu90uONeXOhNG921s5NCKhQEOCySz5/FSq4kTo4p6GPD+820Y4bWic7q+/lGEnCP93JcsRmsoCYU6ZRj8eq3THhh0JVnBlO+igcSXClGogiOtUOpupL4SjYMflXoFp77FugaVAYEfSqyZL0NEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6L/buSjQTz29cSfQVXuu5fAv2EIC8EKt7/nOgvLYqQ=;
 b=cUx7DBp/OaR9428NjbMYZj90YE3pLX9lE2FCkJursxMHq9Tja/G4+DIKVOkq++k6EwC6opaNH2jBIz//RE/rhbmuwxF7CGBW7dj9PBeAgALFfMiXDtqxzN4/lpHvFoCYonKEaAYkeC/E6/CEvdxpP7SxGWnALvjU0f5glTXprw4llx88cxDfhYb2aBCHv4+mXc9IlPeHmgnoOrW+mN/AuTc6JebOxXQlCz/z/v6tH/p/zIl3Scr7WP/88pZJa+nc5CcY64VTnkWLtyr3taewhCnVzN0fn8Ze9g4dWywvxoGwpItYG0PfeZCi/QX0FXS5f3MoBeVj3C/8PXD8wSnKLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6L/buSjQTz29cSfQVXuu5fAv2EIC8EKt7/nOgvLYqQ=;
 b=F+M91k9nA1LcjvnpGaA6V4f5RF5FDDE8+36dfxnD09fcnhnYZPwnc8UtKvGg95sUIm/DMJBN1MdUOUsns86L/kyZO5jwJ+XLozTRE3Agw/X2i5idwsu5zaLiTKqmga32XvAeOt3AmrNA6LY1+WUCyFYft4iAlRiDIfTCNQKBJ94=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3669.namprd13.prod.outlook.com (2603:10b6:610:a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 08:37:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 08:37:32 +0000
Date: Tue, 16 May 2023 10:37:25 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: wil6210: wmi: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <ZGNAxZgv7SKXig3q@corigine.com>
References: <ZGKHM+MWFsuqzTjm@work>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGKHM+MWFsuqzTjm@work>
X-ClientProxiedBy: AS4P191CA0022.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3669:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bd84928-8823-45c4-03c4-08db55e8ca4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+UXf9iGU0vgZ4L7QIaanWFr9ffFAANyVMQ1eEXinMF78a4cQZIfvYckIE6nWpfFXtsqG1TDuws5Qh+wOJfUqpWks2Zd41xEgH8YwyRPzHpHUP6qAdYtKm1wglNofK1bUNYkeCUSl5qVHc1ODjzldBD0QWBerc/EtpqZIGqnBfDq+SUC1IVfmcYtxYMZXMeVttotXZHlerDuV5V//2gq0AagDlMx+EnWaGPU169Rd+I7Y73FyoeZYxn7ufZuETUSCGdrxX+XRuniIbL8m2j/sKxl78iQlspcbTxXxILknHEbh27C2lDp9jEUR5UHzwhfT0WY7ewjpqkhEUGLR8JO/mvUI5S2DPrImxSkWpU7Z+wljOdHdQ/zcgGYtIZq+kRhV3q3Q+o0oYBkTcHV5Xhn3k+5b+yuw+5QfOWCpW91E00PMSFFSGsVAnwAyPwl+tYhmVhwXRXN3mDPZhc4IjI8ZKn7iWOZxDxeDdeUV+F4uSnF9aJFP0zi2S9xl2OzS/XgmrAynvjz9quIFC6QGRQx8i+DAQnW027yyWdqNNZnQS9I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(376002)(346002)(39840400004)(451199021)(38100700002)(36756003)(86362001)(316002)(6916009)(41300700001)(4326008)(186003)(5660300002)(6506007)(8936002)(8676002)(7416002)(54906003)(6512007)(44832011)(4744005)(2616005)(2906002)(66946007)(66476007)(966005)(66556008)(6666004)(6486002)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+0UlobRGZPlZnp0eorAFIafAo5xXnQCg2firtzsDCroNBwcbpzq8nSgp2wXz?=
 =?us-ascii?Q?f3kQriIiC10WyXCOoNpA9mQSn1pXG5RNxyLvHkCFoAsJwRg5ItIjKapmFbwO?=
 =?us-ascii?Q?7vW0MWEef/Da4E2x1lvrcnlWX/6Vdcir9z3FhGNHSMKd1ImEXFVrdvIgsMfh?=
 =?us-ascii?Q?f4Jp5Bidp9k8XW0P+Tr2ajDrwOCAENrZ1oOqtjZ/zuhuiHe88Pugji+HOQiO?=
 =?us-ascii?Q?XQACvR7PSLNIsTJ4VCQzzo56qMzGxMRudBg5rNqhfLCn/boudymILQorK03P?=
 =?us-ascii?Q?Yh7Y3FX2rHKjorTUduSKxFmgxip4ug4WDE4Y9UG67QqfoyuerTAde72oUNzj?=
 =?us-ascii?Q?5hmV+VDwGUMhLvEGUxDcipveMZwpfSC7WkIaxsyOIwyOtqrHWbNhAy6Tyb4/?=
 =?us-ascii?Q?DcIln7Nc8AniuUQ8jxacSYyolLwaflDOxNRN/4tDvGhIwK9toUhInU+L4pN3?=
 =?us-ascii?Q?XI+z3rQg2tNxLLZSt2v+KxQHKm5s8nOPNHgIiWbdaesSUfAHSRs37uFjDMXv?=
 =?us-ascii?Q?P55WO6iMt9IrJd5Bi6v3GHHleSGIwXRvyJHp96OMcwFLy0jQ4PQyuRNRccsv?=
 =?us-ascii?Q?Xqbc4kqeP73pXsVhz4SGg8mo6/FgcZChkXaQguSv31yKaxUni4pLs6w/KGOs?=
 =?us-ascii?Q?sSNMo77QEw4uPp+Yq3JBJNwqDPPByjZb+m6YFEZjtOM06B+A7deR9UjseUFY?=
 =?us-ascii?Q?riellz4KNjG7ZU9bD2NGs5yG4Njj95ZmfMSVy5ZeGGNA+aSZFUv89/uTcIj2?=
 =?us-ascii?Q?4dUtaa+/irW875WlJSs8JwZalQ5CMtlW7dQlXryXCT5jB1z84UO2jbpWIdq+?=
 =?us-ascii?Q?f4xFzML6mBf7/dIthqsWzg7AKl3QLbRQPzfNRmiWqcvv7cxOOONpDYGpVuG/?=
 =?us-ascii?Q?yvqk38gOYtlLca8VlK9nIu4JOUjzgds5GidfcBJz0gWnhgez17t0jOIXZBSp?=
 =?us-ascii?Q?/H8SH8JLps53TjrN9XdIdlDGdE85zeC/Np6d28xLEQyE4gHm7FvDk8hKN5uw?=
 =?us-ascii?Q?ym4ypfRGwxsJWCtT0ydrkQIh4DDZ5sHn0IPzH60kjE/t0TunijRLjCGS44+e?=
 =?us-ascii?Q?SboBy2m+OOl6scKD6OYe7oYm5hSAYN4rI7MPMArT5tw+q9fX67PAkBQo8nDM?=
 =?us-ascii?Q?Xl73pZsrMKJO/0rViIjPB2GEUtLwh5JK0OmtKEj1xXE9YpKMTEssrozhCI6V?=
 =?us-ascii?Q?T6G0ODkT6ussGtWdca5iqGpp/W4/t16pZxSsfP5VZJWfUcKUqonaYrwNH/Pc?=
 =?us-ascii?Q?UfubyPTKLjsqPLsj8R2H1eZR+TDzcw+ziflyfFBX8kI1aahXNzY7vMTUzvBt?=
 =?us-ascii?Q?zSKKqyrunUmXmbXHaEUJar21pirwpcciPySUfnPixm6W0dgfb6JCBAIFUq32?=
 =?us-ascii?Q?tdles5EGnu1IJrVqNXP2zn8H2k3gkjztne3TCZEesGhLiLl1GBTK7ya3d49i?=
 =?us-ascii?Q?wQHYAQPb3RI3XsjzVhcDADZAN/lcvrkQfDPJP/Xbbu52eR+xI3V6o9D5vCMV?=
 =?us-ascii?Q?ivoA/4NKQCf5a93FXZKySeBksJVtAUKj44pNZXJbawi0i/kJLT2VHcTTVgts?=
 =?us-ascii?Q?4OEX20o0NsPS098ySm9CktJj9V8gaOHQrBBQTpkjr6AypZvEtJq0JmD+vWVl?=
 =?us-ascii?Q?gfw/IDx/wJTm0Oyo3AiYWwA8ygYxTJe8HqL45+Iv8S4NreTj/HkvxBAMlyem?=
 =?us-ascii?Q?2dxG9g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd84928-8823-45c4-03c4-08db55e8ca4e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 08:37:31.9367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QAmBe/IzkAUKjrQGBco1GMCjTGe4nCOWhBvyXPrdZccGHDTG0LvPAUFRUhpS+jcOhCFPjhAGpPVlB7/Cf7JvbteCcXk3OxalNKkFnDwMd9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3669
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:25:39PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated, and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations alone in structs with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members alone in structs.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/288
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


