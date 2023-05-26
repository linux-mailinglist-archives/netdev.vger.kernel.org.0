Return-Path: <netdev+bounces-5557-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0BF871218A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C7DB1C20FBD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00DCA94F;
	Fri, 26 May 2023 07:52:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1B853B5
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:52:52 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2114.outbound.protection.outlook.com [40.107.237.114])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5212B6;
	Fri, 26 May 2023 00:52:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGjNWUZAQZobLmyg9L9gNr89mUYzkqsv1vAV2oEym2hP8iNROH2KCU09nYSIEXNjMJH0hNH+prIHh2C2ORGe8E6V4V/jKPK2VUuFvzsfqReb8G0P/kN3ICxmbbtk5dPxDFBw7yuxWmWiPz/+2KlAK+fvoS7K0Lmv3ZvyQj5in5ws1PC1kgnwEzhvET2wP5jQti5gbd3g/g7HugUpj7g85RRMDt7AoZuDJBXznlZ6fjsZjm4UaBZPFWJEVoFO4mhgHOaqA8wuTpURvVt1F5/g0qS/Ze2qER2YKwoHhS9OJIaZgXK5a9rSvIDJlCOlOTFLH+CyT6GkfIhtk5Sl48yUcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30Z2APp6ni1jJscahtcw1cU+8C1n66/zJMkbMRoLpPs=;
 b=mkU3Wb2+GsOuwqPTdTzyf5/gfJEFa7kXOVnuADni9gdzCuxBBfnOwq2WTlRQheIDbnzTVAG2zO47u++nFfvG8ouxYMxkiJewK6Ckhkl8/AHsNh2hwPpJfBsYBFUGZSw9LfFRAkMxikoBi3c1/gIqD0UUpimQyhrhdivULaQNwg8up2j+0eI9aFbiGD7dcEIgdD6MvLzqmx7gdpbAQtWXvdJd34+nyuPb61JClOiyFwIKJO9bEnQZWxj360GVhoR1xBerYj5b3yvxcYAd2CMHqexpbPwfBmY5GFb7/6c6FrPbMumbkzbOugrQrJ0W649eUf96absLJyueNzYpKsytCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30Z2APp6ni1jJscahtcw1cU+8C1n66/zJMkbMRoLpPs=;
 b=ncx0G6d+bALuhkhNnIUYV6GqXQbzVCIQWJz6mRs3OvP77sG+dXHJe4AmaHfSg3u3ZUPaosCH0OZKKTGtiEt6Ld6fqydYktBk2cwBsxIS36IuytMGJBEzStrcTASbAsS31crCjd5KbcD/tPGH4mpqqutJK+eT6APTUme9FUrj6KI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5037.namprd13.prod.outlook.com (2603:10b6:806:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Fri, 26 May
 2023 07:52:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 07:52:48 +0000
Date: Fri, 26 May 2023 09:52:42 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Foster Snowhill <forst@pen.gy>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Georgi Valkov <gvalkov@gmail.com>, linux-usb@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] usbnet: ipheth: fix risk of NULL pointer
 deallocation
Message-ID: <ZHBlShZDu3C8VOl3@corigine.com>
References: <20230525194255.4516-1-forst@pen.gy>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525194255.4516-1-forst@pen.gy>
X-ClientProxiedBy: AM0PR02CA0186.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: e5f49e43-685c-4b26-9f2c-08db5dbe3320
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GVO3CUORW0Rince/Pv3eE5+WmWKt+H+Bl9RBuoQn2vT5cZwGftCaqSvolvucAIlx7bXaLgy/L5mVMORGoH4rPjxxHi2E/1UZDH0ks08KGkdLJ5Hy/bkA0SVZoMkTKbUE0QRswOlt7g7JXW7gBJfQtM9OoR3zqYQsmfdPQSaFV+0Gb0ulcl6lw0Qh7V8m+6BJcPJAyLskBfO/q2OVQ4ITdngEKZMLE+MJo4BMMLkuWYm/W9jnQafhS502a4akJj9Zsqs9yqqjVFN3YrsA2vxw8yd6bp1qkKfTdEelq+Py/wMaj/d0Xc10bB5fw90PMfS7T+pB6Fm5RujKmzKHrRoW/VCWFZE4EsLDzOh0LDFYo/RPzPvto7Q6hOrrdNLjQGqY3RppxZWPLU6eJQw/A6OrxQub8hl+A6RDip31ePuT+oJCWsRlxzeOMMwBJtXlgaLkcjnX3eofH+NIFJbe1ud8MMXvSSUXBz2sAyGcVKjqkH1S8MlZ2cUMA90HW59RuUQ+fv8S6RFkOWa27Ydbq4lAwmpHtr62y3Gblpy+NATPUuQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(136003)(39840400004)(396003)(451199021)(2616005)(6512007)(8676002)(8936002)(83380400001)(86362001)(38100700002)(6506007)(36756003)(66946007)(2906002)(41300700001)(66476007)(66556008)(6916009)(6666004)(4326008)(966005)(316002)(5660300002)(6486002)(54906003)(186003)(44832011)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OJVv1ra/Co+z2fnQ8Mpb0etbalgEgwSbQ4S0eahurNZvb/GK4HXX8JKDlmpD?=
 =?us-ascii?Q?ty/1eOHbzbuYggrGplv0dPcoQq456iSgLY1Lc5xFsjyPee2ED8Ik1j0vrW6D?=
 =?us-ascii?Q?4SAolCD8zn0GTeMFEE3ZhyOo6hqp2ybLeDVKDpr+RfXOriDlJRp+8qh1ca5i?=
 =?us-ascii?Q?Af8gEbtpKjKUpakUYYvUxydVUt2j3d0dEMSjKIf9Q2Nh0K0E7nQvDC4D769j?=
 =?us-ascii?Q?dhoQtAPQAXdJFH6tIVT1C2ln9BTO0BFIHHP3oHPPyg4+I3ecUM61ZX/LOcmR?=
 =?us-ascii?Q?i1JKtgp6iJk0i7hyVPMDzR/1HtjM+UDsXE2uRmwQqRM0430qoRWhJLIENYg7?=
 =?us-ascii?Q?IeJmJhPM0IJMVhfYdvxzvF4LGwF+xdMWHzyQ4Lvvdi2LBo6fpXyZTJoC1gRz?=
 =?us-ascii?Q?sVgRn1mmthfCf1uo6kvMkPcvMrMdAe03zbj+nyqikziADqfZRK76zGTMMv1X?=
 =?us-ascii?Q?iQ1YF2wP1z8ztZMfcQiDTcx8xlAM00K9mQeFektc/5pwqU8nWdL4Yx/0Y6VK?=
 =?us-ascii?Q?5XoEBwc9/92XYov56tbsQb2kR8Dq/xAmrgRIt7h+mYUiwPB0aAha5Lo3GS1u?=
 =?us-ascii?Q?jgI2VCUUD7aF6pdyJPqxFaoda7PuHG4tBxLLMrQ9wjJlJJPT23/Fb0vs7pbz?=
 =?us-ascii?Q?alXRBKmRALieszwNdlld/xaMm+UdyTpRr25kCiMe0Np/eTHzCiKisInoLpVT?=
 =?us-ascii?Q?vnK3gTJwdOXG3/HXHXZum2VvGlCQ1Ia2oeM/osybjRhSBaOuq8AKhilRyuc0?=
 =?us-ascii?Q?SB+Vr6BXaF+FOr0ReX+FGMaMd04wB1wau6uEdiVv2E32Sqn2G/KOPJwdYaEi?=
 =?us-ascii?Q?mZc8bOJAN27WlsPpYf/Os8AW3xfz1IUnHE6FIMb4K+qhmoa3Cn0fZvoNC95H?=
 =?us-ascii?Q?C+FyJP6+uU3fKPFxHpW9Z3NfOYfBlg0Xao/q8ZSdOUkrfxfhU+e4yCGnK0L9?=
 =?us-ascii?Q?P7MiMC5TNIx1M3aUFZJkCTs34L3RefaaY908Twd5KjTDCxbN7wL5Cq1xQDJu?=
 =?us-ascii?Q?4aLQKNR7T1Bk+mCTJeleJGYuT1VUm+aga+0j7Zi1HVEUjGB8CdKd+kyz2/QV?=
 =?us-ascii?Q?97OmVQo9a0h9OsUUvGNOocS0lB7u+DMs2edSXmpbZ+WhCQSZNcvWQMmjek6V?=
 =?us-ascii?Q?XqTAZJ12taqYlL6rMMTTIacv2/LMRXz+Khjhw2PvnDu5LBSaCOwJsM39r0TT?=
 =?us-ascii?Q?rq1fCxjRoFwEpcVeks0KNDp6+JyG3IGCsCRvbhYUo4yVOck0McZtDY1iWNrG?=
 =?us-ascii?Q?HWS0bcMqUCbA9n/5qEiXvbtFKo3SA60KJbq+KGQO0D51cKgCWKBj5ZS8Yc1a?=
 =?us-ascii?Q?XScmV31m5+v0ex2A9UuHIJseteXDCi0DWE6f7HqWWda1dU65uZ2yeu6wPOAg?=
 =?us-ascii?Q?EUwE7aEBnUb0BX/Dr9+2E81WVFdPeBYyoUqSDT6ElE8JCeG3a9S9gXxRhoGC?=
 =?us-ascii?Q?K8OfoHcAPKrufgEHdhVfeTEpWf9v8o6auebXCNz9I4dUbNQAtMAYZ+y7wQ2A?=
 =?us-ascii?Q?DcTyJURCEsGN1fHkzHLqLdTzz/Tn3BdH+aBRXixLJc0Ns5OlZPeW06EjdzO3?=
 =?us-ascii?Q?qFMstwyXhEaa70SkO9dZ10G5+N6RazO1nVHRey8goAMkcQdTuyljz0NsDVZu?=
 =?us-ascii?Q?CxOjfqXGJA90iejfxFcisA9RKs3n+7SxqEjPNLADVSStxPkZEYS6P9OVIrlr?=
 =?us-ascii?Q?clmTzQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f49e43-685c-4b26-9f2c-08db5dbe3320
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 07:52:48.7023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eb58E3phWSb1yOiQw5VXgIVLxGEi4x5kPjKSElwp/gv8KDgdu97AaDXXwaSN0T1RWjR85oSyg7nWa3IzEj01lFQHQ9l8PuzN2TCNo6NamAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5037
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 09:42:54PM +0200, Foster Snowhill wrote:
> From: Georgi Valkov <gvalkov@gmail.com>
> 
> The cleanup precedure in ipheth_probe will attempt to free a
> NULL pointer in dev->ctrl_buf if the memory allocation for
> this buffer is not successful. Rearrange the goto labels to
> avoid this risk.

Hi Georgi and Foster,

kfree will ignore a NULL argument, so I think the existing code is safe.
But given the name of the label I do agree there is scope for a cleanup
here.

Could you consider rewording the patch description accordingly?

> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>

If Georgi is the author of the patch, which seems to be the case,
then the above is correct. But as the patch is being posted by Foster
I think it should be followed by a Signed-off-by line for Foster.

Link: https://www.kernel.org/doc/html/latest/process/submitting-patches.html?highlight=signed+off#developer-s-certificate-of-origin-1-1

> ---
>  drivers/net/usb/ipheth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
> index 6a769df0b..8875a3d0e 100644
> --- a/drivers/net/usb/ipheth.c
> +++ b/drivers/net/usb/ipheth.c
> @@ -510,8 +510,8 @@ static int ipheth_probe(struct usb_interface *intf,
>         ipheth_free_urbs(dev);
>  err_alloc_urbs:
>  err_get_macaddr:
> -err_alloc_ctrl_buf:
>         kfree(dev->ctrl_buf);
> +err_alloc_ctrl_buf:
>  err_endpoints:
>         free_netdev(netdev);
>         return retval;

-- 
pw-bot: cr


