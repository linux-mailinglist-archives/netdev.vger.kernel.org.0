Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233053D8B2F
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbhG1J5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:57:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48376 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231770AbhG1J5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 05:57:10 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S9tNC1016985;
        Wed, 28 Jul 2021 09:57:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=LPI6SCYXJRCPiDJHUhmlHIUEXfosJfPUuzc8MyOW828=;
 b=bVlnyOJodkcGH27eadFs0muiOeD2jRi6eCGoQmzB7Al0VLlHkomsBqj2gvhFvVNRotFL
 yvQkJGJCfwIIcPqwYnao0DR4w2/JuS97N5WsqYnjiDb/TJM++fbEh5+0azI2+5tv/lwx
 LMARkK0ivAEuhfYi7rWIR9+pa4n6GdfrBTSR899Bqg3vh9h8svtdGLraKPECfd4WeJc5
 fyrBr1WpWkmxWPkcC0nC1uCowXpZQt0HFRtAJuOsHXrECCvnxaltTKcLQlcYb1zIXORp
 myyhmAF0oAxlTbFON/mQKz6WWYmD+5RS3m+qkVj/WvCUo39BvPjT5efqHbOtq8gZxmUP OQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=LPI6SCYXJRCPiDJHUhmlHIUEXfosJfPUuzc8MyOW828=;
 b=0ZgAH8pyVzGW0hxDLxkyw9bpbFQo1yiLgBmGh1oAKCaYwHgcz13psTOew53lCFXcHeF2
 T1giuSJcUM3SBnroLJZ1Jk9PPKb20tPm6EkhrjgH6A8WBeEmjgstJFXGyAIuOJZzk6b0
 TXPRn4pkjsPphCBqTlpDINOunitmohZfgJZaOu1xwUDkbw/FI2NFXf4gXIa11IYdMiek
 keMTVLmeSLTD5xB2bJmTJDk4rQp0rNXFOJsqOe+PLzIrtZjztXWVD5+wBlF9FSlZPrf/
 1CdvN4WP2+YidsTK/HCde0YvBXaN/us94x0ckCoT4NunThNO0au2bmhk812OAHoyf8EE 1A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w45a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:57:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S9ouBH119993;
        Wed, 28 Jul 2021 09:57:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3030.oracle.com with ESMTP id 3a2354u7m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:57:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5v5GSiI5sMuQ/T10tzJwP5hqhb+Ajg2rhO6DdaR9JI5IfwAZpzYSXVkLMWFrxCUeNdOYTjtymUdio6zlDSsMMwnDJ8SmiDA5+dKr/+mzgzig7eDTtS/KLFZN1FcFDue44zQhb0CoBYfcqd4bzryE4gUrSHAeBrmaAoV0CpQStbWalLKqVfGp0Dxlqlga6/AhJuETUWyFBiIRMJ2lVCwbG4AqSi8dpoh+xx85coxEbaF7RE0Es3D0lvB0OgM6DEgnMEO69RhaJEnEEIvrk8ajG3+nDOXwjG01RQX+nKcq8eZjQBJQsRY45qWYp+DzBxNz9dC8UGi7ObfDyURD5z5/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPI6SCYXJRCPiDJHUhmlHIUEXfosJfPUuzc8MyOW828=;
 b=ZqGOFWvlGZxlmYRqnKw6hR2F51GJFZUBvnhJ80+Zv+nLZ0cW00jkXDOJeqNCr+49p2Jm6sdGYxkOxU5sWpqfLjOHI8O1DnXliQWF+Lp2x9LAC80W1RIF1AOxrmJZTZeKcZyuxSJH4VI1eQ8C/Hd1s+e/I/62grKiKYPUIhRX2LcEwfN9pNdrSokX2JMa4nNE4ziJiOO1ud6hExARDB8zknu2sGlnGuzjQoN+okivXXxx56qnd+lLJQtX6eQpxNQhOahxx9gQveIKj8hTj8ztVDBUPN03ENbaZE68utr1xt/5FbRN8qzUklCvGpedGIdqJwpuQCkcNfq1w77yBCmN2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPI6SCYXJRCPiDJHUhmlHIUEXfosJfPUuzc8MyOW828=;
 b=UeIFMnTo//mDyhoVlLZjkJfgCEWS2V+wbj62BaU+wE3oX9zFrgis/oR/inowWpOm4q/5EgMHxDSMxXLMoTC8tGt4FKi3cU1X0hM3BK4LDNF4JquAk6vjvnvqqOJv82vxaijOyg+CdyKa368Zq15fssrMPoRkpUynI99YVl1ntZY=
Authentication-Results: corigine.com; dkim=none (message not signed)
 header.d=none;corigine.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2160.namprd10.prod.outlook.com
 (2603:10b6:301:36::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Wed, 28 Jul
 2021 09:56:58 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 09:56:58 +0000
Date:   Wed, 28 Jul 2021 12:56:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, simon.horman@corigine.com,
        kuba@kernel.org, davem@davemloft.net, yinjun.zhang@corigine.com
Subject: Re: [PATCH net-next] nfp: flower-ct: fix error return code in
 nfp_fl_ct_add_offload()
Message-ID: <20210728095635.GT25548@kadam>
References: <20210728091631.2421865-1-yangyingliang@huawei.com>
 <0776b133-91f0-33ef-edc9-8f275798d44b@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0776b133-91f0-33ef-edc9-8f275798d44b@corigine.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0036.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::6)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0036.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 09:56:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f70a089a-1c66-4291-85a7-08d951ae0981
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2160:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB216087034B9897DBFD09427A8EEA9@MWHPR1001MB2160.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U8wUynkFM44ceGbycMVXRckxFyZtFjEAgDXLuiJ2+A0l3qo41oZH/1pzPL1+8BeymvOweXrllvknhpG+/ZPx4vq0i19KBussCp8pMrUqBuBaouliao6bYDF0GBqC595OmoxTEUFI8vw/aiTGr/CDCMCY0UoVLqP0qnHK1my5vqaDk6dcf/55yGyOxky08xeoEXymouFtC73Q85OXombeIPxgr/vKUQPs5crRashT/uTXUf3ADRS1o83Hf3aVuKyGtJGxFLoa+ZtA//zsVUf40BN674K2pKzsuMFN37qE7cVjUsot7qWQyivhyB6VkkyrV9gd2X9/pKtBIWlWwQSOGN/hN2B4jihpYa4YShFS8rHYNmGCswhl2q041DzJw14u25a9N2mGk2IPiNl5g+u6RN6vDJk19bUxGG0ctPG7GRBSnedoGgVFusKkZS1Cy+M3Ac1ER7bZYUuCkrzSDrdxfQJZmMsb6R4sOXu7LkhZWQUzN5+w3mOQVklvEugvFAwP9TO34rQtvDvFWBgoOanC/jNVrhECkbicrJn4stT9C01+eoVWL6q/Lx5sd20A2YhuuIhVRERC/JyCiuBvrFunyjpj6L6dlgRUdnTR9ebciFcQibs7rTCMS+AnY5p5UjU+wVVtt2KV/fbmYLVWIpQcqRZX5LL80vpuMgw0KYgaaV5gY6sctY+4hVjFHFGo4CE9MZFVRp2U/GRoUeeXP7lZ3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(346002)(396003)(366004)(478600001)(66556008)(33716001)(66476007)(6496006)(2906002)(86362001)(38350700002)(9576002)(66946007)(55016002)(8676002)(8936002)(6666004)(33656002)(956004)(9686003)(52116002)(44832011)(5660300002)(6916009)(316002)(26005)(53546011)(4326008)(38100700002)(1076003)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tvOV6strD8q9+N1Luis8pAP7YpJrH/XFu0ZbtL4tKMut2W5sDliqDw/+VLDM?=
 =?us-ascii?Q?A6kbfVDTEkvbRQcPX9+KUzzwmOIc6kqmmCPAG7ahNb4cXjJ95Fi8XnbCzHvo?=
 =?us-ascii?Q?mm/enejutssE9Wfbt3WxtryuVKxt6b+2TKjahAGpTOr+oT5TOjcIZ2VO5mjM?=
 =?us-ascii?Q?WOlb3493cUoYlAFK3rw2JolOg3XE55o1ncHlEfnWP471l4adUPusi9SWhOBt?=
 =?us-ascii?Q?kpzShM2uEWiVbSM6NR9l0GOapgqrSHjGGj7hM35W2aoWh28YcaWmQ6ma97qu?=
 =?us-ascii?Q?caXPy5RV6ahmVzxM+TdoFCjIwN/NMgh99lpdwVhYs5NqiOqrSO80RVKmjr0M?=
 =?us-ascii?Q?9/ECViW4k/y1/yD4KGPOkhY3h+KDF44NLdeuwyKdhy2Iiz9AMq1i6uEgixzb?=
 =?us-ascii?Q?9/Kch6EPN/yp/pla7NOiNlc5pqmy3JBUybckrWHRw4w/5PQjdAiyGs46mZ6R?=
 =?us-ascii?Q?lU+lP0zBC8eHeRVd8JEqJX4X+P4W+0WjomAiVdxJtP84lOoEkFv9Nf83x/jC?=
 =?us-ascii?Q?WO908inMQ8RIKCSiL1ksJhJV9aKvcvJdaWiKBTtrldBXnyTPtUIjLcN4beBZ?=
 =?us-ascii?Q?Oo5J1k43UIScV7n7oGWTlJkvojsIDcXuEF1h46GI/7YCMZ1SBQFyNMyyGSwS?=
 =?us-ascii?Q?qMgGjhPb4rEuV/BTw2CFpxSIVVIlP5ROXdybYfefNcjnWeylavrQHRx9Kbw2?=
 =?us-ascii?Q?UeeCOpTzTNsEe03sHEOZ/w0qkiyHSQzpBg4iEv37ZoVzm0gBo/dUvuW/fFgQ?=
 =?us-ascii?Q?ZogVZ1iLWDWJyaVFPimcNPYOBoajiqHR55OfZNwDrOsWnqNnbbLHnPzhiJ56?=
 =?us-ascii?Q?ztr+BkJuwMs4dklTogizwOUxPhwTpwTXZqBl0swJgtqIE+yiXwK1chVdy2Wo?=
 =?us-ascii?Q?+U0JGAkE6FUOowc+y1A+6ypwzsbV/KWmSrp8oNkQWq9ThZ9hJDaipqUgrjyd?=
 =?us-ascii?Q?O+YpsuEgwMNOlpthAMAgiUYxerBtF89xDHOZQWPqYW8a3YhK47KGeTjhI5gp?=
 =?us-ascii?Q?O5C3aXrZ4PmsCxoRW8ytp/0A4mu22vMBXI3swAKdYjHMZvvNHZcD0xUHd3Ea?=
 =?us-ascii?Q?mJAjgVHEoT7O43Q7AJbO6S94jQaX64jOlQERdZf4awqK/DYsR+jakC2rhp9X?=
 =?us-ascii?Q?UllflWX7JGhUpkEKtGAgsX1YBHWAtw5cG6nj/9P6ng3FntZsqf176CqxF/nx?=
 =?us-ascii?Q?zrnAz/MbReMzEiY1g9JCd9beI9FzrcQxPfooVgucydlsN3cPTc9q6L5v/Fz4?=
 =?us-ascii?Q?drIDvA4qRtG2PELZ4ke9g63na8eluAK8ZR7q2f2OSu7qMzMvk8YMwQwriD/h?=
 =?us-ascii?Q?bw4vPITVRhay0jrbquhrXarO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f70a089a-1c66-4291-85a7-08d951ae0981
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:56:58.1664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J2qu130MP2beGhLK02vZamsmLOunEzgOfoO6YJ2nnFS/w91nWs+sSGIFIuJzk1PvPvPsqo0H1cFKQmi1UzmWqGP0FKHW0zzAXBU6ZljbjUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2160
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280056
X-Proofpoint-ORIG-GUID: idKYIE-FyK6HE9N8GjElrpMNeW3nStsR
X-Proofpoint-GUID: idKYIE-FyK6HE9N8GjElrpMNeW3nStsR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:36:43AM +0200, Louis Peens wrote:
> 
> 
> On 2021/07/28 11:16, Yang Yingliang wrote:
> > If nfp_tunnel_add_ipv6_off() fails, it should return error code
> > in nfp_fl_ct_add_offload().
> > 
> > Fixes: 5a2b93041646 ("nfp: flower-ct: compile match sections of flow_payload")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Ah, thanks Yang, I was just preparing a patch for this myself. This was first reported by
> Dan Carpenter <dan.carpenter@oracle.com> on 26 Jul 2021 (added to CC).
> 
> 	'Hello Louis Peens,
> 
> 	The patch 5a2b93041646: "nfp: flower-ct: compile match sections of
> 	flow_payload" from Jul 22, 2021, leads to the following static
> 	checker warning:
> 	.....'
> 
> I'm not sure what the usual procedure would be for this, I would think adding
> another "Reported-by" line would be sufficient?'

Just leave it, it's fine.

> 
> Anyway, for the patch itself the change looks good to me, thanks:
> Signed-off-by: Louis Peens <louis.peens@corigine.com>

Normally it would be Acked-by.  Signed-off-by means you handled the
patch and it's like signing a legal document that you didn't violate
SCO copyrights etc.

regards,
dan carpenter

