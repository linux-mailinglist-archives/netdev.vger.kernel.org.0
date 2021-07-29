Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AAB3DA267
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbhG2Lpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 07:45:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3054 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231594AbhG2Lph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 07:45:37 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TBepcK029589;
        Thu, 29 Jul 2021 11:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=1D+pjro4g/d9sYlK6a2H0GawvFlaKpnhi8OjFzt8y9c=;
 b=WaV9zPF8d6aCaAcMIXGJUGcUqR1xY8cuIgT8pS9jLmooL/4yXL8hcLvAo8lXY636f9bb
 MF7ExtPv/VvjNSgXukI3OiTGedo2BWdg9WZRJfI9wwWaNscD4dzBvL0fErffh7gY+yGx
 NFV93DY//+4ZDT7YNyaBqLKspabVqhWoOcW2N92cRFz5vrka9LHxT+veE31+piP31rQO
 Fr3KPog/s0kh5EgTZGnM2SZ/KP9xchvlZivgpEW1UT1wHdOnMCmQQqICBk7g/aTHZsKP
 YI6b1hRvqetDZVc8Pr+Qo2fK49N4KACXGd4DDFkouUaCM+SwXiOmnlPGmHWDxvJQBxZS wQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=1D+pjro4g/d9sYlK6a2H0GawvFlaKpnhi8OjFzt8y9c=;
 b=qyJ3Ls7+Y3ImpgCynhI15ykGcEcwgnZQ2VB4Y6mZqYfFumYmd5WBqMSsLH6FGi/nNpq8
 2J6K04rQzYfnwMJdI+zGyOLfe2Rta7myIse26qtbAQkIYTiURhO8vfTsEYbYdNXZLhNR
 J+UzLMrJib0IGSrw4goXaUDYLXGSs8rBcSq2WlxlTCrAziQNccZtlJNdRSDcCcRAbapb
 0dIGD18345Buze2V9zDNUGqZIdZJJ2TVEufFIQzaIwisuDGaQ49uq/K5Nuysg5m5vsAM
 eB5Y3y+/WzmwZRp9R3HncKMkeWBfafPpyZTWKhYOggDWd2pPVUJaMD/b0EzNe3GbRdul 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3rukgdv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 11:45:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16TBfYen104362;
        Thu, 29 Jul 2021 11:45:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3a23579360-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 11:45:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HS2vefFeluwAumJbcF1cw99ZgZvlul6oYiGbf+DPreH2cA2LrhGDUPTRrm335okk8dJ4BGKo2ZQNfPeWWGWhFwCnENn21Qr/IxViNf5qJmnd2pZmeM7qGaQPqc5hQACKyY4uU55eQtmYCyOBJcPMfiOLKRNcSt8hzS08rAEfncTrb4p2Nju/PcS/Go6nsbnTChiz9i07vbgaOCCwrAqRgucPUHyJTe9ljbuRjcgMvOgGrqtKh/DsP8IQxweTX4tcx0LpfcW5Njc3vT/IPkkeHei3TGy9zUM5KLn1RCl59JUhOKgfFY7QOY6NL2nrHoFlJHefYmRCxQM3SZguwmkgZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1D+pjro4g/d9sYlK6a2H0GawvFlaKpnhi8OjFzt8y9c=;
 b=LGzbuhfnfkbS09pZD7KBStjgq7X+lNgFyTCLe6oLWTTLDHHdhcz6fWNsiW1367C72VTvqBkN6t9U6BQobVVE8yFPkU2J1RaeQH9rmtDTo22H9Y0W3W8CNqbEzqOiNaLa/bj+e4eqMkgK+yzBJtoLhkaK8ZWl6bW6xGDNVDZsVEvsEdi9aPAxcKCkAEbZhIoxIwJMwYb0js/VRI4dKGdizVgpGIJwlBYOfQCMqH5twlvuQzHvvjtNwxhNf0pSVXEc9P5dSJgis7KthQSKv2TV1CdX9p6HofZiUhcpAbDcFvfLANbK7VqUjXYxbUB8zrTVJYXb19xmE13LL3L184mukg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1D+pjro4g/d9sYlK6a2H0GawvFlaKpnhi8OjFzt8y9c=;
 b=rm4HifqkQoAVp70nP4CQluzyggW/7Kl73+RtFmjw1amszPwEozH4OaVa6bvphCdFBFhQDqg9fk9iQPT1At745DNpZ46C8Y21cLKnf9GYg9bB+CHzPC0VybgmjbIShGZwyMMnBuFdxRhFnfdyni6d7dFnEzjQxy+FjVvlZK/7E2w=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1549.namprd10.prod.outlook.com
 (2603:10b6:300:26::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 11:45:07 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.032; Thu, 29 Jul 2021
 11:45:06 +0000
Date:   Thu, 29 Jul 2021 14:44:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        angelo@kernel-space.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] can: flexcan: Fix an uninitialized variable issue
Message-ID: <20210729114442.GT1931@kadam>
References: <a55780a2f4c8f1895b6bcbac4d3f8312b2731079.1627557857.git.christophe.jaillet@wanadoo.fr>
 <20210729113101.n5aucrwu56lyqhg7@pengutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729113101.n5aucrwu56lyqhg7@pengutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::8)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Thu, 29 Jul 2021 11:44:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6618d13e-4cc6-420c-a33f-08d952864fb8
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB15499751F3C1CD64284A1C948EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: clHsdlggNPCt7akXyY4SIT22lbWToa3JmXW9oT962jtUHxpt/c8JyLnNavIEpKCFIBMQhhlSCN3w9hBFJuIGWYD6R4COpyNDLYwWbk+Eu7Kc/NicFfqKnXxaLW8Ac/elSGAiJv0FOCR+9yJcyxJY96y7wQ5tCAHxklACh7wYwwLtj7wDlrXPTDmeqDUj61FgQ+BBIqkMl9SzWOzyF+VVsAQOTmxmgo1dXo57E/C03ax2Js0iDRJOeYA1SYG+vJZbPCAX3XKiql3QiT9RiotdHKtrSEXvcpcaB5AiDYrLAv69SoTFCqkRvfZ9MUcJBeF2u2VQFE+VzZQihBQ9qvE2NVPMC+Thj+HsOP/PACD53ZFl2yQg9y2xMgxsDHUEG8ZrAP28CDkm0wXVKRNHiBHr8y99/V3toZ368Yt5+SXVXOChIr+WOxVROt9mTzin3v46hxV+ZsDM16tGoSj5ZGLf9XkhqxczlCdbudzVrFuOi18mLkO6uN0gHuucB0vKLS11CBCzNForgpQZo1tav3/8/mumPEvSFEBrklKMXgE6e1m3CLMt5YjYXdOEtcM93amnRtvAPLrWoOEUqzfNWmdyUmS3Y+cnV7DqhrzY/JJ820tF3tODNfCXiz9tBgBwY2PCQZJ2VzNPVgBBv2ie4HJ1z7o0+0QBPoCdV4S1QzZJXqHSJkIzRRbLlhS1MufjNMPedkUYl5+2dqh8uX2ChvoZ+9WZIAl0/vIwbUbOpiY46EWLJ2cE5bkL6KPENWxnbl1ZsjueUXUZ/lby1X4Wx0FPygAM1LA8vJRhLk+uN0LUfN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016002)(6916009)(53546011)(8936002)(966005)(52116002)(8676002)(508600001)(86362001)(44832011)(83380400001)(9686003)(6496006)(956004)(33716001)(1076003)(26005)(7416002)(2906002)(9576002)(66946007)(66556008)(66476007)(38350700002)(38100700002)(4744005)(4326008)(5660300002)(6666004)(316002)(33656002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zW4WzwFFzkbR1LF+IBc5QZ/nieIn1KbeHd/ZizPI693FNVtqS9cHMjei6aZg?=
 =?us-ascii?Q?eaFHWQ5m69wI2Vwt9ZImJvigohkBVQb6LpYlHOvfjI3Z47dG4wP//CT3CT0h?=
 =?us-ascii?Q?jpt+Qhof+CAdB74GruvdQfiwddO/QuIUjArCXW7WrfMV4FmBHY4jutU2XaYa?=
 =?us-ascii?Q?jJDkzzd7ZqtwLwHKL27sIbTkLKqfjvw+vzz56wWetf2bhETHvv9wnC1RIlnx?=
 =?us-ascii?Q?b2KRLKziSb8E28eYLCwX2TErNLDgNv4aajXGpFRSKDfVOt5cqnSrqU8rWSbV?=
 =?us-ascii?Q?mIAHSqa0s98fHVC098XTgywqjx5WP0PEuCphoYtb/d4D6k+Eqy4PvkFFF4pw?=
 =?us-ascii?Q?DkFwU6ajZZrays2EnfW0fNNc+3YjSaYAu5OlrE1One1PfwElZRRhmR/8zEw7?=
 =?us-ascii?Q?DI1lX0rOwtoMiP4QZvrrFOWAQ75w/CI7pXCHCa5J3bMPkfgRPi+CCOEnF+Wg?=
 =?us-ascii?Q?KpLRMqr+dRsf6lBvF7sY6csN2UkjKQXRRy8CoQpe2de2Tc0HWUHm7xBM+4NP?=
 =?us-ascii?Q?aEj/3nXYrEsKE9HuoB9zyzQdKM8gfqcNPr4NWHR2kQ3euduATBuiwSNQjpCk?=
 =?us-ascii?Q?1RCHiKpf1WZvQ3eFX53D3G8pVe0mfOkmApvwaqZIVwua7xWgDhEKA1Wbvs5H?=
 =?us-ascii?Q?tYcwxayAiEO5FXe5VpVtPb5FvhSARb/z3PtmX9uc6K7WVZEG1FIFxfKqnQ0P?=
 =?us-ascii?Q?GB+EUavV3ol+zDFohoTQPUeaN+QaDbcV5u4N5kTdArXyAIjN93DmEH53xhO6?=
 =?us-ascii?Q?KVdLiM9F2qNVEC1AJBTcDnteQqvwUITO3aqgnODrb2qACGArjhFhRtnJHJe0?=
 =?us-ascii?Q?So1L83ZFTorQlEEDtZwNbuKCzvw12x+R50crWr+CQ6Odnx/tRsX3+BWA+7iH?=
 =?us-ascii?Q?rGNWt+gB6xXMgho9By5eE/c5hmTO86+yY865HjjIn9q7kWg4M1ToB67xSvyd?=
 =?us-ascii?Q?qEqlMO8pVT745acDOZ8HNrsoAZt8mpP+/t4WbugC8Rs9HDOGwqcyQg1/HnzB?=
 =?us-ascii?Q?dGvzezvrxYLvTaaj42QIXPJAkioeOSRQaVmlyOgoeZxpZpLcKxmHSDvCTLud?=
 =?us-ascii?Q?ksOa7P6eJQHXzqF5U8uBX3cR8ixdBjKhKzdgY3Ru4gswsVJ7QI/vmaeyXMU1?=
 =?us-ascii?Q?9mXQssfOzph/uyc+qZuKirb+GpZ0OMKIayXuY92OEOpE/vULiY43f9u8gjl+?=
 =?us-ascii?Q?y45F+aCgE2XE5VbJuwm41fFfqQRRsss2AoDMxtRk3Mq8h7Tx9euWK9hebxl2?=
 =?us-ascii?Q?TLkKr9rkuHJzxGaMS9sYhYzujfUQhrACYL6C/DV9qlUh1VkEYi/cCukVjmBg?=
 =?us-ascii?Q?RrtacHDlb1lWiyoRA3Hb0LM6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6618d13e-4cc6-420c-a33f-08d952864fb8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 11:45:06.8380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+F6NP7ZJNEt7XPMvCfdTRfUF2B6w/7kov/+HTMnmT5oef0YlsuslTs4H2dd3A0dpXRNlO39btpRwuDC9o+55TVeYh16NiDlGHu3LTkb5xw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=930
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290075
X-Proofpoint-GUID: bAltNr3Jg931tHnoy6rpmeMv5AoMcJjN
X-Proofpoint-ORIG-GUID: bAltNr3Jg931tHnoy6rpmeMv5AoMcJjN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 01:31:01PM +0200, Marc Kleine-Budde wrote:
> On 29.07.2021 13:27:42, Christophe JAILLET wrote:
> > If both 'clk_ipg' and 'clk_per' are NULL, we return an un-init value.
> > So set 'err' to 0, to return success in such a case.
> 
> Thanks for the patch, a similar one has been posted before:
> https://lore.kernel.org/linux-can/20210728075428.1493568-1-mkl@pengutronix.de/
> 
> > Fixes: d9cead75b1c6 ("can: flexcan: add mcf5441x support")
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > ---
> > Another way to fix it is to remove the NULL checks for 'clk_ipg' and
> > 'clk_per' that been added in commit d9cead75b1c6.
> > 
> > They look useless to me because 'clk_prepare_enable()' returns 0 if it is
> > passed a NULL pointer.
> 
> ACK, while the common clock framework's clk_prepare_enable() can handle
> NULL pointers, the clock framework used on the mcf5441x doesn't.

Huh?  It looks like it just uses the regular stuff?

regards,
dan carpenter

