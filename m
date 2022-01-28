Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C14049F73A
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347846AbiA1KWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:22:25 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13800 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229864AbiA1KWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:22:24 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20S7FMw1015087;
        Fri, 28 Jan 2022 10:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=gKTXcDUiS+j3L2+9qGzLMrZeM1hXs5ycU9nOQrkIUYY=;
 b=abErvfTQ5gQpSGyd+fFfgUTiSw2ZB6M8RLREWIaZ5rOxb3I9NFl4JL3B6qqY2XlXBNXz
 e///kNfNoxKUZQ1prmVmbnLIXnZ2MFv7OI0Pk5c7cU/M1FAHhAmWzx7ugHvhZImeckn8
 Uk/mespmEC+hhPWFRATC6u1FPmkhgSSEUXWPmxYvaUxXDCxD6uoXeu0YTR8+PM/22IAw
 yU8qIi4Pw4r4trgnhlgM7e0LmjrgWLwTIhJDcDdpQKBZ7+OX/cVfEPQJPyHIBfzcnTIS
 GwSbEvPbbRhuGWs9KlaRg8VwTEQmrTOaiPozQUoFw0nDi3K3FtEv/9jR/4WWQOOiYW2E Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3duvsj2uvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 10:22:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20SAGuiR188745;
        Fri, 28 Jan 2022 10:22:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3dtaxc4h26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 10:22:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQl6qcNT8QpfhpQEPCQi7wnbHMTnEyNnp29ZiQF7s9mLWPH5v/01tyTaEWTL5eWVLY8H44XhrSaNyTHQGw+OOR8bLbnNLRazduvsT4deIaQzVfJ2AlM+zipreAb5G2iCK3uwuts4iU4QE8DPaV96RLPjuiffgWgKYDt/jTfOrImTUiBSvU44BI2PfNjn3eZlhOulBeD5E0tOHeLtALbQINg1ABM0+D4mR1Aa54oGoCueptIar2UlEWVgz7aSAVyr+HT0tj0iZF9hzV3Ow75WH87gVc22XwHlSRtZ+blmcY64g8ikNx9JdSGcvDgtNj25sOfpInqCkyg59utb+HOqKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKTXcDUiS+j3L2+9qGzLMrZeM1hXs5ycU9nOQrkIUYY=;
 b=XYalbLhy4X79gvNnom6tIluJ/kJOFu4rA/oYvH2QW8TVhQzfHo/1wLB/2eLhzMwEhEM0tMKO/YNyoX+BLTpBebgOsNDnPTOoNoe4ayter8l4Y8H+k0XcXh2tKeV00zxYlOM7jrBJNsSq1ZapZPf+lQxlrOp4xVirLM/u/xMQV5TYZlk7yZsT4P79so8Tg51Fr+SGLaCbVx8NTk595OUtqz6VxLrnS37OEbsTFRW5spw/ZVPvawEjY8drQzWg3dw0f3kCwKNuHCWvqiamGWEc8fDYn+y59k6qiI7OQHhcESvJqroJHOGF/IDm0gHcBY2F2+KE875wFbcqHg7behYQbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKTXcDUiS+j3L2+9qGzLMrZeM1hXs5ycU9nOQrkIUYY=;
 b=ZDrW6b31nfs7PJghAtiRs6eY/vvc+1VEvEoP9bI5AWvxEjY88QAFhyc5gOxmJiYVh6q50mMzZBvQp9bjht5uyTEG8qKAwzxtLDErePN22j/oK8tvssqqAUpstQ1riLSsgIwcDIBMuaT8dsN6k254mfmC69EeYvEGEVCZVBm3rkg=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by BLAPR10MB5380.namprd10.prod.outlook.com
 (2603:10b6:208:333::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Fri, 28 Jan
 2022 10:22:06 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::cdcc:584:3514:f052]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::cdcc:584:3514:f052%5]) with mapi id 15.20.4909.017; Fri, 28 Jan 2022
 10:22:06 +0000
Date:   Fri, 28 Jan 2022 13:21:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Ranch <linux-hams@trinnet.net>
Cc:     Thomas Osterried <thomas@osterried.de>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, ralf@linux-mips.org,
        linux-hams@vger.kernel.org
Subject: Re: [PATCH net-next 06/15] net: ax25: remove route refcount
Message-ID: <20220128102147.GE1951@kadam>
References: <20220126191109.2822706-1-kuba@kernel.org>
 <20220126191109.2822706-7-kuba@kernel.org>
 <20220127091858.GF18529@x-berg.in-berlin.de>
 <f6749b58-ab8a-094c-5e07-c5a7ca5200c9@trinnet.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6749b58-ab8a-094c-5e07-c5a7ca5200c9@trinnet.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0034.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::11)
 To CY4PR1001MB2358.namprd10.prod.outlook.com (2603:10b6:910:4a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64e3573f-bae2-4718-8ee5-08d9e2480877
X-MS-TrafficTypeDiagnostic: BLAPR10MB5380:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB5380E2A6DD7B9A0EDEBB98B68E229@BLAPR10MB5380.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gA9w767jPFQKL3fljSyqhVb9MGhnHkVFxnJTmxA3vor+HvU1LUtVeIT0RIwaMpD+qcdU5N7M5Ty0EAHrlhfvzJhmsysIo8+nWTpMZAyovcCEFVOPn/JWDgb63F1WXkEXAhf67JtArETN3m4Vcj9HqTRkgLt68BVnHtt9oF/tgNpYMc4o30JIzjd43WZHwOOrq5g4+oiXhEC/TRZJMp/8ToH/Ym+7Bs4w0aXI1ySL/1tHfTO3ODNfruwD5eX5Ldt8C40JY9Rin0yVRmvTRsOe4XJiZl7OGvwEyb69GYruQ07tXH6QltTWX/eT65UDVPRLgOAYwNai+8N8cw/7G4xPl+sVGPfA6YeG+pNRV0kUZUI1Bv63i3fqAN4Ey3J6+EIbxzstThPkVNV6Wd9zIw/3u3rjk9cBmD0KFhJp+Vw7r8wH8lOC/fnwbA4FLCC6+vgAaV6NH5m+6j/mTSYmnhq5UueW6UkFYcbzz7IqkyizmSndNKqEptBgB3i79semNQpB8NUafYPFTYViHReG3wE2+qMfgVB0g1zN6NqsIvr2jEUq3i20LQRRD7D9w2ThU5+NP0ujMgrW0JQJiVWr4tjMJ8Sx/jnxPlUWkpjYy/IbBvpyvE4gW7qI29MTD2kxopbt0UvPDnoXiAfV8XDBITMY2kqPq9Ppic63dcm2LW9edZgqU3VmuDYc81b45LscRT6YLe6Y10B0nT9rx6syuOQEsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(316002)(66476007)(4744005)(6506007)(5660300002)(52116002)(66946007)(1076003)(186003)(6512007)(9686003)(26005)(83380400001)(44832011)(8936002)(4326008)(66556008)(8676002)(86362001)(6666004)(508600001)(6486002)(33656002)(54906003)(33716001)(2906002)(38100700002)(6916009)(38350700002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bhPyy8A7dTWy54vtP8oUfL33Cp04xVC4ff9KhMLK4f0wc4AdDU3nopnh/Xyx?=
 =?us-ascii?Q?8PfjxyhCYyZ1bRTM8Ws2SwagYxJaV32X+6qOXNmbbEwaBEB6FMucMXsHMqIJ?=
 =?us-ascii?Q?IMFHTwxZDYTUidVoVXZDFcoWgmbowe9HAdcvGhmnAqbPOZr0GE5EQmNnGwcv?=
 =?us-ascii?Q?Kvda4J6IWkYPmkPGgQcep6gh+2m7t1xUEWpSrHeExcqwo/aoBcGt93i3W1Th?=
 =?us-ascii?Q?WZbXGRktCzsrzRtbOgjh6i1zCvdYLOhPCckM6VAz61JTWjebm4gnVmrDVIpc?=
 =?us-ascii?Q?7a3aVEzhUiYkWU4SJqTfCiShP1dUNvLzMO/Du9Aeig64CaC6usXeHfOjzyD7?=
 =?us-ascii?Q?N2XjM9Gtkq/0Z79dgy9wsZk2uwG+mhYonCA48uc59Ezy4PqWJ+gkY6tGsT4j?=
 =?us-ascii?Q?3ZNDokU0OYy5JGKJLP0G88YemIudQKfzmiB2gnlNlxcjn67EcK29daYtDaom?=
 =?us-ascii?Q?cs7nz8nFdIGWOVkHGlKdfCgb/1NJNppSzyo14azBFfLF4dG/t2ux2h0smuW6?=
 =?us-ascii?Q?aZ0Jt6b9pxukSBbwjQ1f7vggmD7m1RpUke9oWpQe11LGxuyk40eXbzRsXEcP?=
 =?us-ascii?Q?NCe9nqjMYrah104J/FQUpZcWniVGLyCGnMGpXZ60TvdUTiMth4f6/bhVRaa9?=
 =?us-ascii?Q?mMLElSaiF6ol0rXfmrnhZZArHEyIwABwFYYh1Ht/6x4z4Glw4JxUVgrQCwb6?=
 =?us-ascii?Q?Srqe6/bSDWvwU0oVcvM+KHF0QBQOpLH/oq0OKLNRVz3cC4NsoFsBYyiRZVcp?=
 =?us-ascii?Q?btxrNevfoFA0B8+C1+u/rvuzfMCwqHkLeYhvyaHmG32J53TwfFu8ShF43SuG?=
 =?us-ascii?Q?TaTMAsnDISpFg0Dr55iBL4sf3DBs2inObH3GNNLPtdOdCoNzylP6V3S2ICCf?=
 =?us-ascii?Q?RJLFyjzv6RvwVS5cyZAKxNfMXNIyJ3dQxlYgU/13RZzUUQPWlgbbtkJWNd/1?=
 =?us-ascii?Q?nOacpqEFF/Nmlt16tiekiASz5ux6FDyO289IEix1VOCljgQMp30p8DTwYTEh?=
 =?us-ascii?Q?FqttyrM5Szkv49AdTB0m69V4HExMP1K5bmjVYNrc6K/KAH8TZRFasATjgXnq?=
 =?us-ascii?Q?2g0+rq7Llb+2scAffgGPi6yJV5Vg628SoGF6U+WWvidL+bMtmqEckM5qx1v4?=
 =?us-ascii?Q?BVu6fTrihFRVktl6GllFJP0leG/ZD22kwcoJvzUnmXIEVrcr/t8kLHiqeYSI?=
 =?us-ascii?Q?v2hjL/Bc9lP34fpy05T/sKUV5TYfPyV0EiFsSwUP0qVzXI5mqMF/ff2ymlOZ?=
 =?us-ascii?Q?EQ89ZqsZMR6LjwwSSkqCC0bKs4LNjAOUi4JQp+PEqij+CbRY4mGmFoUUVZsL?=
 =?us-ascii?Q?gaA+3bMI1Avh1nzcM6r3FUw1jiLYpalOzaa5vmAMsGbGdtTYMgnkqYqIJ3H9?=
 =?us-ascii?Q?w8jOyx84T2ef8MyAjrxc28MjbnHcPJ/fhnbZzVe5/nKneT36cG3q+jCOnR8t?=
 =?us-ascii?Q?wGFwbUhfjMCQYDne6kTZfkM3Q1I0NEl0MUQL/kL6Dcyc/wrnJYM/HXA5KLn3?=
 =?us-ascii?Q?8pek+iJ1KOqi9Dr9vipYC3qZJrqpAzLVjPPzJkDQAfcEzyBcu63JBfA+HiOJ?=
 =?us-ascii?Q?Hw8bn9Wd2aeFZrZSksy9uL6vJS3WxJ0lJ5jpJuBLBHglXdqh+UEp3S9Vli7M?=
 =?us-ascii?Q?6RQEQO1uQTxEyRgdoF9DXbD1p/uGkZs0zKbw50svjGdi+dTbtH0v4CxQrwAJ?=
 =?us-ascii?Q?HJgg3Zmfvo2GRSvp0n1PTYNNLMA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e3573f-bae2-4718-8ee5-08d9e2480877
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 10:22:06.0648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kp5KUOjTP7vv4q3IRsCODCrsCCLHULaXkE3zI8u/+8r4BO7ml2FJU0r4wp1p3MVIbe0FqVcraogmxKyLqj2SqIgMbQnXW3SVlFhF837l4Fk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5380
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10240 signatures=669575
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201280064
X-Proofpoint-ORIG-GUID: z-TmPTkVL2QXEoowLI2PSA3dB1VpFMJt
X-Proofpoint-GUID: z-TmPTkVL2QXEoowLI2PSA3dB1VpFMJt
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 07:58:40AM -0800, David Ranch wrote:
> 
> Curious, has this change been tested with an actual testbed to confirm it
> doesn't break anything?  We *have* to stop allowing good intentioned but
> naive developers from submitting patches when they've never tested the
> resulting change.

Hopefully Jakub is not *too* naive, given that he (along with Dave
Miller) have final say over everything networking related in the Linux
kernel.  :P

Plus, we all reviewed the patch and it's fine.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

