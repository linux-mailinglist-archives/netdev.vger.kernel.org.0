Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C824088C0
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 12:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238940AbhIMKHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 06:07:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41348 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238752AbhIMKHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 06:07:49 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DA0aGQ009081;
        Mon, 13 Sep 2021 10:06:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=j4ROwgYfG05ezG3SYDZz4AFPVGekBN1PMh9zz5VVU+U=;
 b=ejjXCn8+Y3mtTKkQs6xbOQRxDEvk8Nw/e8BVuj1SjjoSzZu8pd1FJLeo5YTjvjYQB3HP
 w80DwuYTCyx9fZIhM9h41heP0mujQwsxYLwHsCmMkNeEWuSZAVLVwIOsU2G+UujtXIq6
 FImBPUBVDBv5H2JiYLAqSPpOVl55E/nn7We57U4yj1ytFi09doy1BcB0TyAY+xUGXBxV
 4vn+5OBE91aSMTIIjWQ4YzCd9kzChcabKc+JbpgJ51ud9G2TJQ1CB3yRZKt95NAF9e0A
 lkKpoIH05QrP3tpnUa2z2hLBQQzhoTTdjxc+viHz+tXsrC7vXmV5Edz39cNZq8vJQ8/b +g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2020-01-29;
 bh=j4ROwgYfG05ezG3SYDZz4AFPVGekBN1PMh9zz5VVU+U=;
 b=mSIi/HiScmxvQDYt2TukD3OKmv3MlZtvRrPW+dK5/idhspho+yRzXYR+euu+Rp9BQtqg
 +92KJ7/y5kWvt7SXngRXMqyPUFGHF3yQh/U78Bc/z6UcwxuZU0logS4HC+e/qz009xQU
 s2zUrmBCzxygTqrOyykq5/YmZuXDVANSkFTz3DhRaMagr656mMZiaGuh3/vx+rNNnpFh
 ODtlAICTac93YIl3eNn2eOVPeLaVhEpxMW1EFvg7QI0C3YYx97/VyQOTLdzAe1vE1C3m
 Inq8TgMACUOjTAiiSIoPQPRciRnWu3EFeB2ZIkXTZpLSw9Js+zYtQE8ok9t1ysikl5oT ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k9rsxvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 10:06:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DA1MO2108816;
        Mon, 13 Sep 2021 10:06:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by userp3020.oracle.com with ESMTP id 3b167q7eh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 10:06:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sm9G5l3Ho/OjwwqyQgDv9w+4ZEBlW9fQXXP+WpwnrVA4yAP/B6pYKXjpfCsSBcTBp3cevKoeNQJNVnxqNCnrBdwwL0LXBG7xi93XJviQsTrj/q92RS1rUYIpHwS/kJ5D8yA0QoXLCVvu1NyE7N57Ac1cThgAcx5L6iG5mTS2CGiX8t/U4VLyZfI3q8OSzUOnh2v/t6L1gdCnS/KDvSJcoMmauhV7yAKJffN4fgNOTe5NY4cfTO/jf6VUOejjmRyfzEDmxUcfK9MlqcaFlbC2e+m+J0orJQLYqEjJZATv8ci8FQSiv/VYvEKsY7m26WWC8BfRCspKVLfZ4ZuunLEBHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JTbcZMwlwFYwwUEzl/QHRAZngvibKYQYn9cXsokTLMc=;
 b=dgPB7StmiYnp9PTq8B55cwPQ5i63gogWbtayfYDcEfESGTCM37mkRx7fIYm+eAvI75xE8KwMC7wKrM5ZdIOjL2PWveEAOI085LHS63tlMTiO/RumjyOc3u5l28HaXhVKDKHZAsetl17SE/k79N8Fy2o7klGKnDGEoahKZekaTaFoHfWMxO2qoMMoW4Htfsf4QD3vtfLZcFmD/JJxzdG0sqt/WrO7VTToAQ7Cd4IikEh9nwt4Wv9JVXlF1suzouJBU+CpxZls66AMSMpUWGMvN7uPAv6Ks/tYf2LS5R4FFN2cvL8d3+JEwTiJUa3RK1aLrzc8KzsJrP8CgQJLDNlodA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTbcZMwlwFYwwUEzl/QHRAZngvibKYQYn9cXsokTLMc=;
 b=u1mPCPqux4mZI2b23lk2e9+wI6txznk85haOMqFiR3pASYRMWFudnTOblYMxVE88Je0dC4c6p0odJ4EkvXnE2l6Ppo0dP0zPS5m/AI3UKiehxPFxWerPTQcweLxX7O9Ra89IxWhWJqRV/t+CzKd1HNLmZU5NrqSai5rxla3+kr0=
Authentication-Results: silabs.com; dkim=none (message not signed)
 header.d=none;silabs.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2253.namprd10.prod.outlook.com
 (2603:10b6:301:30::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Mon, 13 Sep
 2021 10:06:23 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 10:06:23 +0000
Date:   Mon, 13 Sep 2021 13:06:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v2 13/33] staging: wfx: update with the firmware API 3.8
Message-ID: <20210913100605.GJ7203@kadam>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
 <20210913083045.1881321-14-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210913083045.1881321-14-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0056.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::8)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0056.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 10:06:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f29729d0-17ac-4228-0616-08d9769e2417
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2253056A64C240A22FE1A8798ED99@MWHPR1001MB2253.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ze9jAloUakRAksIkWymyK4uiMkaD9KDUA/dMu5oooPS/l/zFpBOpeBgHFCnyN2YAxgW2oPLX0mTqh3neF5BevrhCjeG1/n3TYxAR/gkR3sftgkMsph/jw78/sn/83H+iYmb7IrkkqXS/WHiu6pjx/Iac4rU3QNNgwmre2c2NgiYR2r36LeG1YMseYj83rR/LFfhCkDmPRaI3QowXA8r3ZdY1qP2k3TMKWsoSlaec6WKEmlwOd6rNCvCFKjLz7jLkYwTf3C2TQFYgFxmxU1Gp5T/MIoeQSX/Q8IOFbt/+kyf0LXu7ax9FkUmZ591PBqo0HwMpaWcJ39JhJteQNObEsbUM7ifs/1YH9gGEILMMyhv0lNzfGQCgXbG8L6LGTEvRVpbn27IWDb6XeT72lCwZzlZRLDIbDLi2qm1OQqDAHsMzKx7BntBPN6tH5axnm8dFxmdzZQu++fPF+3A/IrMkhsuPmZ5PAUEDHJ9Ncw8sOP/7ix88QH39sjnJXNYYzcrkBAJa4FGWyuIPhj2s6DmFEEg+X9urm9vlao3Zn9cBthKdseY2gHwHj3vYT1ezCepSEt6e3wu1a/OKdHtBoz1Dw+c/ImaQ8akD07JKrrCto9RO+abeebBhK5jKU/Pzk+ZSU0jAy2kL8O7jZYRf4jJmwVIz9U2U+7mc80va3ts3Bbi8IdClBWYhW0nbTmkNOKD3x3FBJBphW55CIHBhAfTKAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(396003)(376002)(346002)(44832011)(33656002)(33716001)(86362001)(186003)(66556008)(66946007)(66476007)(26005)(9686003)(83380400001)(38100700002)(956004)(38350700002)(8936002)(9576002)(316002)(478600001)(4326008)(2906002)(6666004)(54906003)(52116002)(6496006)(5660300002)(55016002)(6916009)(8676002)(1076003)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?MncH1JAvrJy/6GPO3z8KC1BoGDeaF9OLQfjr9cmk0a3/X7d+k6GX+MLvzl?=
 =?iso-8859-1?Q?j9sikZ+V8kRCMOBoFKF5DR93c+jaDehtl4CXeBNby8NwnBu20YsQr5Z3bk?=
 =?iso-8859-1?Q?LW+bW5nCd93gHoEA/nZC4y6MgJWxpfraFOATpzxWn7/fak27FdlxdId2Ga?=
 =?iso-8859-1?Q?KBR54gdyra2/Dv1mb7XVIzV2lZmWu/n6k4elgQLYdEHVXKClJ4wqsJzXTc?=
 =?iso-8859-1?Q?cG15eSSO1PrZ8AEc+crWqjLhdGBNCBd5K0FOtIX5MJ4Qc3Mk1bQmU0NGKJ?=
 =?iso-8859-1?Q?aEWlZz7HztDqjlR4v2vSXf95C9xYC8gFIVvkCSYYkU3GBYc/X2abAEzrdZ?=
 =?iso-8859-1?Q?HBhbTS6ypdQuy2jlpzuhw9T9s93coYGtJZ11oVkyfYXWl75tjDvzPoJ72E?=
 =?iso-8859-1?Q?33DynV+Q6vLV/z0x6nlSjIqCiPrjG6SDkN3yOZ3DQZugGhB/G/wGdWs4E+?=
 =?iso-8859-1?Q?8gfTwEDbnfXSwPXKmySjmQF7dp8P77/xMhiu+L6dq9zLLfZaN5rI5Vhs9U?=
 =?iso-8859-1?Q?WqzHxpxXA2hXOPsPN94Ggk5jz5vaNEClgkw0UvoVVop4eLUotTeFZsTOtd?=
 =?iso-8859-1?Q?WyYy0MEt7KcMQw7Apptzn7wL5c5a6sMR4PTV5M6JdLit0wKyfllcx0Yvx6?=
 =?iso-8859-1?Q?K2seWR82e1jBGLZTuV+47atdp/3iUUd6XCrjlQxakuv3qAhftdhbX4/0me?=
 =?iso-8859-1?Q?5oLUqT/dwEbHxv09mU1C2UA4yK696pJgmClYRpuwNdkbH9tqYgh3Pta3Tm?=
 =?iso-8859-1?Q?TN7PjC/CC47lpscZnMIOjFG3KF9U6AxqYtzq7AhPZYrLWyfkkl/xxgcl71?=
 =?iso-8859-1?Q?ioDIDCED3LwGiStLcis65X0lyDwSxx4ps2JZLakx9W4GtvW8a/yLuFxo7f?=
 =?iso-8859-1?Q?TZheEqGiubAkEj61d/vgK+TuBuPEpftCzPeRJdFDNAmY+lTrFDG3XZdS5I?=
 =?iso-8859-1?Q?WK3/4aIa8MAtsm8LKsUjr6+yASJ6XuJuU4vy0VWfotz0/57f3G2aXuDm3L?=
 =?iso-8859-1?Q?Yf8xNYXGz2CdwnCoDafSkQC7W9Up/dp7q9zq9DP6DMF3aS/BU+jn11hdOA?=
 =?iso-8859-1?Q?DpztG1B2UeSXgQkmlqIpxalUoOGKPahEfIZxi3SW7MY2rVOimuYpucVRVp?=
 =?iso-8859-1?Q?KQy6EY7r0uAPjkgBz3XDMZcWYUMGanarfBrMwdOgN7xbQV5MB0fr3D4wRr?=
 =?iso-8859-1?Q?M18M20wW2wNkcnCIuvv6Rhv4yoLVjbHoZZyLyWaS48xtFFXqu9E0kBxjVw?=
 =?iso-8859-1?Q?Dgk0asO9eX2rbPilDbBjO11OXAVCMBoeWAO93S75B+tGRFcGu6h3YU4zge?=
 =?iso-8859-1?Q?/Gu+mGKDjtswvr756XLRc0SHrn0NJMjLidtix5H5AinrMYsp0Lyr2gs4ce?=
 =?iso-8859-1?Q?gkxqf0hnUY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f29729d0-17ac-4228-0616-08d9769e2417
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 10:06:23.6322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W28+cYnxAQ/oCrfuRT+hBoxCy9VqGOum/R/nstJ/hKuI8gCmZO1u/RTEC+LCT/QQQ5QQDcKmLJd8l5UCrBGQWx6K0I2KnDF3GZi2UJJexJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2253
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130067
X-Proofpoint-ORIG-GUID: My0R8JSbQgnKb625IUhddbrYW1mUqIsU
X-Proofpoint-GUID: My0R8JSbQgnKb625IUhddbrYW1mUqIsU
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 10:30:25AM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> The firmware API 3.8 introduces new statistic counters. These changes
> are backward compatible.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/debug.c       | 3 +++
>  drivers/staging/wfx/hif_api_mib.h | 5 ++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wfx/debug.c b/drivers/staging/wfx/debug.c
> index eedada78c25f..e67ca0d818ba 100644
> --- a/drivers/staging/wfx/debug.c
> +++ b/drivers/staging/wfx/debug.c
> @@ -109,6 +109,9 @@ static int wfx_counters_show(struct seq_file *seq, void *v)
>  
>  	PUT_COUNTER(rx_beacon);
>  	PUT_COUNTER(miss_beacon);
> +	PUT_COUNTER(rx_dtim);
> +	PUT_COUNTER(rx_dtim_aid0_clr);
> +	PUT_COUNTER(rx_dtim_aid0_set);
>  
>  #undef PUT_COUNTER

Not related to the patch but the PUT_COUNTER macro should be called
something like PRINT_COUNTER.  It's not a get/put API.

regards,
dan carpenter

