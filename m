Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0464092D2
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 16:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345006AbhIMOPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 10:15:54 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5278 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344350AbhIMOOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 10:14:17 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DDJgHh012951;
        Mon, 13 Sep 2021 14:12:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=N8MJj9Z2dgNR82ILC7vUFKZi8+z2RS5+DKPKjD1eeGQ=;
 b=rHwuXd2pPcHvETjXASs4MWfaxS0fOfEw0SbofvnbphZYCmdKmn9uE6ffbbEB2Age7V5u
 1g+TOROqLn4+RBv0TSJk1mdeuH0Bp1aJj+q+vNH4deTfGaZXagJC8JVNCVT7gKI98L2h
 QyzAhALGhZeOp4v50Ugk7fq43Xshhb24ioEAWGxEOdl8zNb4Jhl3c+rWNlxpapMhAu5F
 3z0vlfeDPqil884YV8OhmPipp8ke29XKvuIiqbZisSsB8A0oDZn5O3j9bgxQjEL/j73W
 KyFMpUjZAYhkMT73o/roSgRljgNEFN6xzX8y+YrI8WAtEw7pXy6WNSBkuRMJhWhYxleI LA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2020-01-29;
 bh=N8MJj9Z2dgNR82ILC7vUFKZi8+z2RS5+DKPKjD1eeGQ=;
 b=MGNu+sldc17QQ9Z4bPzVUnQ6+l9xtRrIQdX2f8ICIJb4h3dMMlEJva9IWDpvDXGRtOH3
 Lq6+6yC3C4d/Q5C9JWJ2nVRb29ua7XbYbXIaXcHpMlL2Uom8U/Hc6Kboxt0kb9/wQzRy
 O0/7SyBGgS+Wy/jtpmkg4Ut1diaGGJIfnzvXu1YyEftPplQ/dZKBjPbVkTPo2yTKdlVv
 /M6M1VO03X3qI9/SeOBgHi7kCXPMgBk7U/C3U30+EGsmvHn3E1m3RZLsje6G2xxfGp6n
 UUss7WyrU8I3HhN0LBOvqVQcysIXKEy4nv69gO0lvGhR2noyDPG3teEW2LTfl3NbZQa/ yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1jkjatfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 14:12:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DE3RcL173245;
        Mon, 13 Sep 2021 14:12:52 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by userp3020.oracle.com with ESMTP id 3b167qgk5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 14:12:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ESGZmxBknv/P2QUAOkkarM1nTT6JIMPWUQEfQQD6xCc0JbeWqKxn27FiVBwWeQRmP7KdWDypjKjAxrZwZbRduAcfScsS/O6WhEcSLMQSfbqCZLuL8i+sqKV4Ztg2L7/kO8Oo+HHSPbkv9aIbNuMrAr1QrvRZ8iRoNQe9HMbQWQdBdmwGge5AY4AEUQ7M1yXU9KDSuxb9xssYlIdkAulZQkJRfbskmwHYPbZ2vzPbacTMb1b7xVjOpjUDFEkG0iU5jyMjoiFCt7Y9Elb5E3VF80a8+eXNNKk7bJnOA8qR7D75oaI4LhKlUyUSMLOyBMdo5/grSrI+ThvyiPKlC7WsFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TSRdyBhTa6WxfXmvZOW1a4rGVDb53A0VlqcbQuXIgbE=;
 b=lIdEk+o4zhxi47K0eA8cWC76jQUjdkqVnQvLf4eamMFrUhk/G9MfMMKG/d3K98pEOaGO3x9z4FcNN1FJMIMkR4ozz+O96O39cDkywdxEUJnXU5G4duis7nmGQVTAJfz0ii75w8dhOIEB5UYcxnWHup9qaYwdEw5Ah4WHQSwhMWcShgFmfrCRfSPjkYWIEqq82HtVan8PW2yuAIIaGDJLFUKD9qSS7IWObRkI/ctGXcvBsgBl5pVjIiVgsgBhunMNNtXSsdvp2fgOxA9vBVL0Lj5Xzi689pNNAYaBGjfUCK4QiAOvWiGNF+Ml5Fp1iLTanUOzaIFWErpxZHMNP982vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSRdyBhTa6WxfXmvZOW1a4rGVDb53A0VlqcbQuXIgbE=;
 b=vGhIqNTuxm/H0KoI4ewXYUmbxuExby9QgkVAORUAy3kzG+GPOjO5Kw9suqVvB98CP44B/EKgK0tjkdbK5ZxuwMjl+NFSKdGrmr+b8El5bEXLmoNw9fEKeifTh2V7xdqavtAjBAvuexTKlT68BjyhSS43UNKJcwnnUoGmZcf2IZ0=
Authentication-Results: silabs.com; dkim=none (message not signed)
 header.d=none;silabs.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1295.namprd10.prod.outlook.com
 (2603:10b6:300:1e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 14:12:50 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 14:12:50 +0000
Date:   Mon, 13 Sep 2021 17:12:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v3 00/32] staging/wfx: usual maintenance
Message-ID: <20210913141232.GK7203@kadam>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0044.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::32)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0044.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 14:12:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00429e06-c08e-4d98-be3f-08d976c091bf
X-MS-TrafficTypeDiagnostic: MWHPR10MB1295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB12952D9CBB6A06A35A7CDF5A8ED99@MWHPR10MB1295.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LsgDrPZoW/MYcR1InMKzVKUn9vjJldC1NkoyEdVxReHa5RxbDwhHn3gcq3NCHZ3oNTWmKXZu8WOwjMddIVepKbS2N4kRaxF7rAXFuHHC8dTxvXjAowszL46Zj73cAUba0dGI02emk+3wy+cg6TjRvQ5uLgXmqnFVDhf9WndhgItIpxbLuVmClcw/JhkZ+pZgRmagR/qG67P28lj+96fbYehTPW+zIwF5jU0W4+IPQMR8jwMRPs7rR6Gvyq6Bc2d4fobf0I5qjBLdrftD+2fxcmfgkek/8o9zX9fH89CnzXZqaok3BrrNmfz83lu45+VtDwuiI9DBw8uqf9yVLg9Hpww8sK4xkqi4YwcTL9kMcZRmRU8kOHwxcVEfikjE2eOSHvnBqguZsD0o7VjvuMOgGUCrP4C3TuCJJ8qSU/sCAPUmOdGOeygrhibWFpkvFgk5gsUNsstPkjBr2qfH5Yi3bHK3apXyIR030ueDKx3GkC3HF2jvWTc/7oIQvtm6fs4zVn4d89DqwGKSTbcx5QKbKHnkLR3c8MZ3lxOJi0kxrKrbnAjvEl/BmREp5T/bQ3RsLi9bc1I7ibgQadKUnmULwhHLLE9I/cB0ck/e9DplWjSoqmxnK8fpBXWFC3vRdGdSAcGr9vZVQTe2mcU+sPg4NAYD7zXuHn4sbJdICmONtusy7xLKSe7Pv02AGFtjM5IFIgskqwOJQ7A3tKgSsep/VvgjwgUi20BoI8twKxt1bcGWvG47b62dzvS4Ay5fmiL7AMsEcpy+xpaV43m2uBrxMlC/IXcBSPyW7XTHFnjXE3c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(6916009)(66574015)(5660300002)(33656002)(1076003)(83380400001)(8936002)(956004)(86362001)(38100700002)(38350700002)(508600001)(55016002)(44832011)(186003)(33716001)(6496006)(52116002)(6666004)(8676002)(316002)(66476007)(9576002)(4326008)(66556008)(2906002)(9686003)(26005)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?qMdxRaXyBxTGYRDHYvYm5ys3Vakwv7nqHbsDl5FWQIWMXlXxRP4zi/I37c?=
 =?iso-8859-1?Q?H1Y7VcbyehQxtls7c/npnzB1dOgJYZhh9iS1WjCkh0mMWkeXWiSI3MeOcB?=
 =?iso-8859-1?Q?ehDbEJ9R+lfFm/N0WHPXJJgHTYkkoXLAwT8UAdClPqtiZ7WE1n7B84xF+O?=
 =?iso-8859-1?Q?/ixd4FbNGQFHuOpFoiKh6djFuv79Mdj2sn3efeKzMRe5gBr8JT7mbyAjRP?=
 =?iso-8859-1?Q?YzzV6CqC/DYvkBRflGiT/5sU1N1/MsqxU3bQTR9dxFqZ1hBSZYox5wUciI?=
 =?iso-8859-1?Q?XafRHO3sPwebvIOWIsnoaCUyEGFzkNLgEq2YrUHakNfIjOLXGBwNF1Wp9z?=
 =?iso-8859-1?Q?3CyumESVRAg/uNsQh/3LugesrWShjAGpOMhwcshrTKSURbP3zDRwRurGNy?=
 =?iso-8859-1?Q?UFoc9e/Y8KygmnvSpFpzU2Bh/4yGSijVohS5aZfgfbh/XEdXEJ7KL0hXwg?=
 =?iso-8859-1?Q?qcTmBXetHNPhA/f7nfsisuCF1gAQSh/2mj3Z/DgamkedgCQ6Lj/b9p9PJC?=
 =?iso-8859-1?Q?ZgEzUejFJI3QojHMY3+vBImIUUfi41f4y02renxdMICQEzDNelfkyg1V6r?=
 =?iso-8859-1?Q?Ix4DVyHIR0hBX0eQgWiYkNOk8XVjc1piD4LyNwMW5oU/MgDTkchIcG8qNv?=
 =?iso-8859-1?Q?/2u39WLF2ql93vrHcX8a9ZG1RrBvy8DP8oeoby4LbszWQJkCmWKxj7D6n9?=
 =?iso-8859-1?Q?sYpuJi3Anu62qc6Nu9Kve1jAsuNWyJ6zLCBf7bB187u3G+VM3dw3rUWV8e?=
 =?iso-8859-1?Q?Szpzm8g8X/2zhETUbNQlnT2osOPSQRFfutbRwS5QD/iz1IqlavalkDLm6K?=
 =?iso-8859-1?Q?8OZgoEdqgOYuCCGAVNCfNnwyLgkPes5aYBs3RSGsYLEN8rqh//mQ08huyy?=
 =?iso-8859-1?Q?6+x3wbNluxpL14CsskirhcwDCDlUxZQBJ8+uYC93OpgAN/fDzJGvyCFCX+?=
 =?iso-8859-1?Q?w0ziUXCpT3Le87jQS+oIsfXkY1+fhY2pvXbbC8aokrKIoD+tPAEDZP+j+N?=
 =?iso-8859-1?Q?+D3tCuZgvuosJVW+/DlL7dIaCx0NI8+l6zog61Gv/z+NPULYWaoGxEP7GQ?=
 =?iso-8859-1?Q?jQXOdeTubFDkHiZXj8SvDeoFUWfqjfi7XzYo2Reg5U9N8tdfmZM8ST3vSl?=
 =?iso-8859-1?Q?jFUzutxXKWlpf2lhvVsRU3eMtcSZQVn5KIB4J5NgQ9LKQs1hFT54AxiExP?=
 =?iso-8859-1?Q?Y7JyoJzUuLC9vd/L8jvduFPVal1s0RZkPSnAe+9td6guUdKCLGqSuhEUZM?=
 =?iso-8859-1?Q?ntHK91vrPF4A3ByfurOqbN8B22tHUNjoqAnaR0kboY757dneeZFGnUn9vy?=
 =?iso-8859-1?Q?sKu0Psu2aPrl0Nk+UwzHfQnOTjQBLRyoFxMvlA3UMpQZoS3Cz8CU+Ox5qO?=
 =?iso-8859-1?Q?/vOZIiz3eE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00429e06-c08e-4d98-be3f-08d976c091bf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 14:12:50.2895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtIIzkxjx1CYGSXRqPVhuMjdRIX7CTyGybkyJy4ZbRqRZVGxVpfk07V58za1e3Ujtc+D5WiRsfPQ+PMfN5fWeU+oYNGJoT7+yIXTvmd8Ec0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1295
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=732 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130094
X-Proofpoint-GUID: dLZfUTphEuHmx6Doo8iA-UM82EwhzTtg
X-Proofpoint-ORIG-GUID: dLZfUTphEuHmx6Doo8iA-UM82EwhzTtg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 03:01:31PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Hi,
> 
> The following PR contains now usual maintenance for the wfx driver. I have
> more-or-less sorted the patches by importance:
>     - the first ones and the two last ones are fixes for a few corner-cases
>       reported by users
>     - the patches 9 and 10 add support for CSA and TDLS
>     - then the end of the series is mostly cosmetics and nitpicking
> 
> I have wait longer than I initially wanted before to send this PR. It is
> because didn't want to conflict with the PR currently in review[1] to
> relocate this driver into the main tree. However, this PR started to be
> very large and nothing seems to move on main-tree side so I decided to not
> wait longer.
> 
> Kalle, I am going to send a new version of [1] as soon as this PR will be
> accepted. I hope you will have time to review it one day :-).
> 
> [1] https://lore.kernel.org/all/20210315132501.441681-1-Jerome.Pouiller@silabs.com/
> 
> v3:
>   - Fix patch 11 and drop patch 33 (Dan)
>   - Fix one missing C99 comment
>   - Drop useless WARN_ON() (Dan)

Thanks!  Only dropping patch 11 and 33 was really required, but I'm
happy you dropped the WARN_ON() as well.

regards,
dan carpenter
