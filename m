Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A103D9F8B
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 10:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhG2I0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 04:26:37 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:65392 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234878AbhG2I0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 04:26:36 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T8D4Wm018537;
        Thu, 29 Jul 2021 08:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=kyM+opt8INuvqnS6uFUM+1Zh9Cw45KythbT+VDLvPp4=;
 b=e7fIvJof1TBEe7Bfs7IL7OEEuB2DyBLSZcqWecHAglh63mJdxZvKxcEA+yJuzgvSVP5s
 /4xbgtqZtk6C0gKK+NO8+Yq3L1YLiLneUZyst5Gvqs72I1UJQSMR5vZHCFZ6cOPLqnS5
 Z8Nw/VUpTRG/XW8GBRiBD+i5wvXXyb8cKqzqnmZ+vhgqGflH2AAaRdyhHseYtpk96bp/
 Zsm5djNAidJoAyJQukyCy0uwZNuLUSvZ5k+SWsCor/B75G177aV6LUG39QmOgu1+IvjI
 VGt29DqfrJ8vV1wWxT/b6MY82/v7tIHRWuCsklYCbKGjDtV/BgPmBGHT9CuzdgJs3VIq pA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=kyM+opt8INuvqnS6uFUM+1Zh9Cw45KythbT+VDLvPp4=;
 b=t6dOYKYf6SQ48P5vxQFpl0vZjfzgQhuyYGNhI32fjM5ENJ1V0bXJmq/BjebTqAM19XP2
 itm12WXlbcY0HQyfmzpBysv54l0gcCGYQU9uhxyIIv8Vua0aWVF6Rw9x+NqNsZ3BYJOy
 9fCqRi9OloGiHrXpZyvX48ouw+85wjoEhWcHzvzOjMXEUcPJtSF5aBe/uyNWqr65Yy3P
 f5iW8YbLnUFfTMT+9PZvZxpXHgE4fI+CnKxUHzDl0jlfEJEbwyrb8+zGlud0wVes38HF
 EAB7WxkjILW/ya0qiOAo+kb4u+2L9BwilMXGM8i7daNxL7i41ecj4GYqXvkFLr8OUrs6 dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3cdps9du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 08:26:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T8Pcx1038516;
        Thu, 29 Jul 2021 08:26:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3a234btr5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 08:26:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrto59E0Wq8/vJU2jmLvGYQvn5M9nGrj1DoEN5PNGnTQa4C1x/mVCdNFRAz4J6Z8M4PyFgpmpSYv0iYgZVfHFH5G2SvxAIF0zbIYVT+2NvBkLmfptrN3ss3rbCc7AAn07u9mcPLAJmKd9CxYUlkBrJ7BJcMz53hmFv7Qsh7k/vKmmNfcvOWshFS9pEvOWRRr8jo+Ysowr4txYyquBftLvacreEOPWW6Fumb91KzZPlBPcINobGSEl00yGOp5OsDZ1PO9vLAZOwJizjpLy39WxWv1wpbQExug3Cm8w1E0XQZI2lrzhEmQwD/1mhk500dxMy69KjCLcNg5FrZVg3qKkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyM+opt8INuvqnS6uFUM+1Zh9Cw45KythbT+VDLvPp4=;
 b=ZiH6Db8W/6ofzbWV8iX0YKR1PxNk1w/S8SR3os9TtUsfxeARTzs1JkqsQgMz5b/aFi54vUmf8uMEyNEYX/8SAhvzcIXaFLCKJBr8CpUebRamaRRYvMKe8XJ2D7h0lnHGZl6t+6nWCqzwWtPt/EpASXed6dAE5LEv44D6bzm8WRkNpWw4uAtxh6ulPQkCnNq0Os7iodG7ARBgPe9ElIobsTroIaiUl4zXa+j9+qY9nulg9/NMiVQNinekLAODeMbcZLtE034yHbOWlusfdgBNxkwEnOOOfboSc0DONc+GjVQ7R984OES3LnJ8EX/OrnKTzJfzRVmzZnI3td7VTvnepg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyM+opt8INuvqnS6uFUM+1Zh9Cw45KythbT+VDLvPp4=;
 b=O7ftGf+RCikJFKsfNWs5xAWuVF8Dl5tfAdFM0lgC6K639V88Z3QG4NIcRACQItl2z+EzdkjZITWJul5sKVs9YgHKHtsBa0B/atITMb5d69R4jKz7BgNcakTjuh7eFb+FUPABFebh0tAS+MrzsbfPRhIo3jPXAWntU7AQ/nhfF48=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1552.namprd10.prod.outlook.com
 (2603:10b6:300:24::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Thu, 29 Jul
 2021 08:26:24 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.032; Thu, 29 Jul 2021
 08:26:24 +0000
Date:   Thu, 29 Jul 2021 11:25:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 02/64] mac80211: Use flex-array for radiotap header bitmap
Message-ID: <20210729082546.GY25548@kadam>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-3-keescook@chromium.org>
 <20210728073556.GP1931@kadam>
 <202107281630.B0519DA@keescook>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202107281630.B0519DA@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JN2P275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 08:26:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87684f9c-81ad-4b85-2b60-08d9526a8d3b
X-MS-TrafficTypeDiagnostic: MWHPR10MB1552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB15526299AF160B228C50B7198EEB9@MWHPR10MB1552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ziPfKNc1tVZELjg8XUks0dI5k0ZBLCvgFP1DLBdX4FGCEJmZWeqOcLvYvII/b5PdggMWnpIO0jXLTpDlpujZ+UPBR1yCujeZM94ypDqWIsPmJforK6JopsEniNIDG48guiEkju/dExlBMoRwzK/9xqsutRozkfJZTcXVHYf7aux0Jd9lv3fQMHBwK3U5q8qHFUX3nSU+TcjUPX16znZeVlFjHo8t5u/5lzXgmHHXZQosNHF2NXgf35xPssExEy68mOYgPjMBC+7sIgoMGHv1w/hQIkqNE+ePTU+DdJ0fS32V5S4k1aceDSp6JIGJrpbLpWENo2jEViyZ0MwkM+fJSxjemAO15Xt7gIx+Q9pqk7QVcw8TxkcH9rML2V/wnhyZHE3mZrdt9Kxbn2XbI7pc1UcVM+RG6GrNNTDS891uYudoLJnKQGAgo5cgS51TrWC9VrRz8tQkU8x4zq1IEu5chdiqIFbZKSYE1SoH1jaLrEkGYHJAHs88dgkAJPJEdP4D30vwDrBwt3RQdEnJWHkj/ajSY6DIenqvuyhUoIz0uYfKPKPoxuCT3kQH703Mmx68BrN36zwMwpkIiRmODjxiLZ4u3C6tAXCfvud91ctcViMTOnt5Cl7/0iAm9XrTzD5O6nmVnw3WiylGFvR/Zq2n77A3kUzUoHBsO7Peun7m3JEIfwPN50ySKGvJBnJk5ykHAXox/4K8/tg5TYNm7tp+5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(346002)(396003)(33716001)(9686003)(55016002)(478600001)(33656002)(6666004)(66946007)(7416002)(6496006)(52116002)(44832011)(26005)(4326008)(956004)(6916009)(186003)(54906003)(316002)(66476007)(86362001)(38350700002)(558084003)(38100700002)(8676002)(9576002)(1076003)(8936002)(5660300002)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RwA9D+eMh1VTnsHWOu6l+/ddd98Jib2pN0mqIMjIDQwJyP5VT9370/oFchfC?=
 =?us-ascii?Q?qRZjrmHh/JylOjEoP26Av+ohi0oXTc/WZ0LJ1rLNZUU5EBXTssM2UMIQm/hW?=
 =?us-ascii?Q?YzGpAVfnhua6DINEBIx9KtrhA3770ua21rrbmHtrGUn9dTtBWbOyyVaQR56U?=
 =?us-ascii?Q?NYpZ7dtbxv6VrWsTKFwoWBrXYa1krgtc3jt/X+Cs+qhBexkoT5uJD9B9WzC4?=
 =?us-ascii?Q?bLdPKNt5+ajegMGbfQwdlGJzQA3232dqr3miT86pobqAzvbtrJ07mW2ROY2s?=
 =?us-ascii?Q?nW7YtHpuLTvujAkc/N4Msu5s4dsjsXwt5GG7UJFWYaZKNYDsXLI5c/PvyYrw?=
 =?us-ascii?Q?0VjSvHhCqNAZ+M/ZIwWwmhZw6AnuizkuNAw9Q/oe4/wBVy+SVxPK/1UkNhMu?=
 =?us-ascii?Q?mdeHm+FUe6oG2t4fzVbrvMsRjUQCD5GchofYRNb6rgxJfHEm9EeMJtlAVRhX?=
 =?us-ascii?Q?Z7mSQVg6GyQRlkbT/9QslvdbjPdLUH2/F6lv6eXhezqelIevMLf5YMH/9CyQ?=
 =?us-ascii?Q?fqOduhWrwTbyJ1KxqMa683fGRpYnbR90S0EFb1YnWEXKT4kGlFD6gjQPe19z?=
 =?us-ascii?Q?OVRmFu7FORxV8FRH/k/PwD6Dl8KSlOcY//eqZwtu7n587ZXuyW+Qb5SFN/Bx?=
 =?us-ascii?Q?Txmr52Y2JC+VCFryD/wp64ShAUgPfFlouCmQh6FdEX5ZognyyRG/YKu4FxdN?=
 =?us-ascii?Q?lQQ/rE4ptJWNRSpnJikjWP165q+K7lJPtMTfIsNKFjGuA3Ne4ow9Tm9qR6XV?=
 =?us-ascii?Q?I2yEEWlx2q4PtgePBv+pzuh5Ufbujl8BEwbRYXUUayN5Oz04uAjc0yw4Gt3z?=
 =?us-ascii?Q?/Ga5XCBvwV4qUgKuQBVQdx08fg09JIy5K4BOFLWIyMEydsbRl6cXKD35siA5?=
 =?us-ascii?Q?gbnkn/dw7tynsBCaepKZtH6te+WFBBKZgnWZDwlcWZUKDZ7yNopF47QrQbin?=
 =?us-ascii?Q?Qvk8y0McjD6mHx8mV2NIyvcuPNlYANub14g3wAnxokG8D1pd2HgO2caxDNHC?=
 =?us-ascii?Q?YfuRL0EPjvvzu6teKeW9StX/ZHq+vhVcHnqbhXlX0+iPcqFeqLYa59v7OB+8?=
 =?us-ascii?Q?F4T6RTl/65Hg5Iyi/oDQtpqikL3bGsYh87KDcyvfPCkvIrI05mdAhT/Y8a42?=
 =?us-ascii?Q?4flvtL3RrGqDnvneH6q2ipZBeWwGz0K7F5p5eRVlOBMW4f2lV4xsMMH6TIch?=
 =?us-ascii?Q?bucwUgJarEFOalbEWVAwL8XE8Rjf7nJHmfe+Nf/UA96CLXCnbp+frGw1Pa+k?=
 =?us-ascii?Q?fG5c+iVWg8eb1BNoW4G+i2D45cBIcsEwXecrpRcqDxKa+FF1HhIzrj27Rv18?=
 =?us-ascii?Q?jTPoPwkD3PtPFqbmuIq2nuH1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87684f9c-81ad-4b85-2b60-08d9526a8d3b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 08:26:24.0920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZoHloAbdKBp2wkdrt7HOY59ADdAXVfzDIbp9uJMZ0pcmKpRPXB9zcjsewO2Wjoo7I0b2WwvI7QyJDZ6Ls6iyaqfsLfQCU6RbrWuwH7BwbIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1552
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=858 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107290055
X-Proofpoint-GUID: UkpOdzQxQknQB1rmAJsPty-M5JC4D9u9
X-Proofpoint-ORIG-GUID: UkpOdzQxQknQB1rmAJsPty-M5JC4D9u9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 04:33:18PM -0700, Kees Cook wrote:
> 
> Ah-ha, got it:
> 

Thanks, Kees!  Nice!

regards,
dan carpenter

