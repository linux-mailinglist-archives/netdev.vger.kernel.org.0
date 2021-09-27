Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB51641980B
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhI0Pky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:40:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49340 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235100AbhI0Pks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:40:48 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RF5lUL032536;
        Mon, 27 Sep 2021 15:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=BWK+Ljs2CAkKQ6fmkueH8N58Cio+BqoApS6vaqDoTIU=;
 b=YzVNmknVyzIJTN5bgpEV77Pbpyafgk8VuSuFSNLzAQt85dS7jpACMdGfnSQppqcqJpR3
 wVq6fCZt5tszBGHqG1smQ8szI2+2THTWV/qDWYaNIxlVfnvM04u+6FJJT/PV6zawx4Jl
 h9/314ImghO3xxGlMDtJu3CMC1V3NxObvqfnUgWYDe/gJEwmWzuU6DUUMnn4ieZsoPlQ
 KMMLCq8gK7JUVRLKC0KAWFBVD/OUJLzB1jAX54JM4/oKuOySs1+T08aT8m6tfbzN86M7
 Pjo5F9hLjIC0ZG/BuE/ENGgoxnQYYT/sB7o1IIaGvFbxbSoneoijShRG1UbUYq1i7UNu Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbexcs91t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 15:38:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18RFaMwK082354;
        Mon, 27 Sep 2021 15:38:42 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by userp3020.oracle.com with ESMTP id 3badhr6m1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 15:38:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQc+SwKm+5zSrCRY+Ceded+fyWlE8rTLckftSotOyK+zqMryH2hE4OLtsYC+hjyJ0G6pFe2c8NGHLUh8eF2sssBFuBAiHfM8YzIZSLPoxcZ3zb6GQrRFZpYdBXb2lewCastb8jtfoC+jsskW1Y0+C2LjLXEBZMBz26bkVARzNLS1h0KZyV8IN/WEuux4tUtjZOkHKU0Yr9yPOh50a9SPV4LgWJlR5piQ72uWbSqtGvjtMDhVPSZ5CKltF+FAEw7Cy90DjgEA/26YVhJhgVdHG+rISF52htIT41RIoHmj7zKNgVtTF26JeEag5gEDuExDuwaq31JhDqjPZ5WbSltTCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BWK+Ljs2CAkKQ6fmkueH8N58Cio+BqoApS6vaqDoTIU=;
 b=iuSFU3T1yFVfs6g/xCNrRqZchLwcMCO51EO96d+3dkaR+miHsy96WN97Bd/xlRmlgpap564BsT5cE6AuiihRMV5cm1GBqo9Iff+twDqi2MOsSpMzZDuOe7c8JXM1pw7F6kp6H7iilV+ReNNCZfnsC96/nfp29aiTbSAg3gsNJYpI6nHY+Y/4XX+xNI6qiyP9z1WdidAHq1z9Ug3xi4Cxy49dFG82N+3p7DahXCQ6wrpj9plaQBcYdSOPK0MrLT3lHuFtu2lHUWySqkde2/g/w+3o0wcEcqbspl/sMDGZSsn7tC0m+FtDXQQCljq+aYcCwpDqtXqutS/1P4goqImKAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWK+Ljs2CAkKQ6fmkueH8N58Cio+BqoApS6vaqDoTIU=;
 b=l3jN5CwSYQtxUs61dqeQc0CTbFSUsMBSl7lts/WdC2lPViJxzMPqNY62wt1diMhu6nbozxhlk5o7w9WKGiz6jAeM6Gek++HL5BaprDkCiggAjgNFI2rzLxAHTautrCwnnrNbuh1/0bsk7h4Cpqa+MJBR+2WK3AUgLsHt1oJU/UI=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4641.namprd10.prod.outlook.com
 (2603:10b6:303:6d::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 15:38:39 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 15:38:39 +0000
Date:   Mon, 27 Sep 2021 18:38:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] nfc: avoid potential race condition
Message-ID: <20210927153822.GH2048@kadam>
References: <20210923065051.GA25122@kili>
 <3760c70c-299c-89bf-5a4a-22e8d564ef92@canonical.com>
 <20210923122220.GB2083@kadam>
 <47358bea-e761-b823-dfbd-cd8e0a2a69a6@canonical.com>
 <20210924131441.6598ba3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <81b648d2-0e20-e5ac-e2ff-a1b8b8ea83a8@canonical.com>
 <20210927072605.45291daf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1af270c3-8a4f-6c62-bb6c-b454a507f443@canonical.com>
 <20210927151325.GJ2083@kadam>
 <b05d4811-d207-1bfc-a56a-81b44808b7bf@canonical.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b05d4811-d207-1bfc-a56a-81b44808b7bf@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0016.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::28)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0016.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 15:38:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4771086-a54e-4d61-8728-08d981cce088
X-MS-TrafficTypeDiagnostic: CO1PR10MB4641:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4641FF9CE53425C2C4039D498EA79@CO1PR10MB4641.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fHElI6ez2niS+Mp6IZxpxQVWLECtIcGIMmkwOACycy/uUZuKEXQhKCc01YSC2mnU3z/ERw9O9AKuaBPHDUz365IzT/BctIVLKCzL4lKOb53thVVH/82y0ZMsOjdZtFPac/9luG+R4w7KV7shPy8RF0VuDcrUJgSDZK85kDLdrgJXjDai3iuHYi6wTnephM5L+rIJ80oTOU5ZGYd+Bq2T0szBja+KJ5+KFcIIY7lUc1oIqc0lEeonpJF3fdZ+WR2yI4m/7+1DE2jo5OSuGKE2r0jHg6rZOCEW1wOvzqBpWU1499Dgvn0yYNpPx5wzJ1AHH9Yd4M1TL8wHsyQxNCJV2ydYVVmJvGtjy+xUQQi8J5wVHXpTcXJLwNy/MpXCNNI8CVRLPbvvGgZHIxc2SMWkmSuNpEkBJv491FRyt1lRFAOfKvyFRwUYPZkEL00Pq5IYlfJ1IWboJR33mgbN1TZILajU0f4HmUlaDQhV3it01dOaXKLr+5YEEMizV0LrsI7E5BuIzJSEmgb16QEToVJqaetBj7wZ/nn4jHThMsrsP0Uk+zabSgDK5SbHzgPps38tIGqm+MBUnZRc/AmCjTg+phKGoFVutHWGp15vgoljV0WpXF5EytdrdHEVD+sG2tG8/+mnWH1viOSrqqtbZ42Q1d/78BIqegWSyL3hT022vzHYnyn9CT4cIMMr25WElfIRNq5RJ0qU2TwgevaUTBk+LA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(33716001)(508600001)(54906003)(66476007)(38100700002)(38350700002)(52116002)(186003)(316002)(66946007)(26005)(86362001)(33656002)(5660300002)(1076003)(6666004)(9576002)(6496006)(8936002)(8676002)(9686003)(44832011)(2906002)(956004)(4326008)(6916009)(55016002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LFayv2/2VSdmYGhMsVbgAeEEYHs9kJepxl0v60gCCzgTY74d/24zSxZX7IcW?=
 =?us-ascii?Q?oGPNSC9kzJ+0gR2jU9U2QYceBo+gGukONfnFKVn4pSwdBkNma2t5TT75AnUy?=
 =?us-ascii?Q?Tx71ijUrxywc3wlmcE9GT52S2bw9Nw2I+HQwmSnkqXNQPvNwMzMdPMotvn9x?=
 =?us-ascii?Q?qytStCQhrqbyiprMKKZF+7+UtOUoQ2WqLWrguAd9tHVua7L1PAG2B2637sxH?=
 =?us-ascii?Q?4fHx5Lr8/QiJ28MBk1b9h15IJUeZl+nGMWk+7N1ysW6RIkRdJwybTgaaELr5?=
 =?us-ascii?Q?s4VjbhAc6h3xcG8y1gFzfeUzE0Rrn+8a163sKsC7CdncWMem4cEVzM/ncCtO?=
 =?us-ascii?Q?Ifqa4+Lwp/2xhKzGlCDFm7nzyOXAUiZR7c3kLJZKVCu+oLPWR37gDBITbY3a?=
 =?us-ascii?Q?mGB/lAkMil9labXQ+BLlTHcqtJTVuP103Eh5Khk/Lt1Rx1jdRnF8hWChVn5v?=
 =?us-ascii?Q?ZWrfbtzWNlHMUkcLWrxJkg/ohhO8CNdf/Qol5qKISctHhPq8DsEy2FPGjVNX?=
 =?us-ascii?Q?tOlp+9nQ4NzI2YiP9l5xxrceebgBWAiYt6IFtYvBubm76oLZhuc70IvK4GSP?=
 =?us-ascii?Q?lzQausdkOCE9/xAlDeRrfsvjSc74jhPCAczyZ20znvt6nF3LQ17DscqiWAtb?=
 =?us-ascii?Q?mJalngtCg3qKkSCeKNBCpDcx+DXfUDGPtpVmdf84TFQOBIwsTOSJtsEDlYwS?=
 =?us-ascii?Q?NKqdx4I0uMzYX71dROGo/24ZcUaK4uXxXKV4Nn9KLfZeezU4KrhvJg94QeuB?=
 =?us-ascii?Q?7hQHgyHIAHaj2ioNDc2N1j1l4HQNC3cfkdfiFMI6tSB7tQYp/RrLJo15tmQc?=
 =?us-ascii?Q?/6TEa14vLVUUHzR2TQYLqy94TiuJk6YFVx1+xuPt58/JpygzOxyv11/x0cyF?=
 =?us-ascii?Q?RTZNB42pD/FWQ9YO6T5aSqddtiMnqrj2r/dW8Zc6TGbz03BxlIZ4DNvXgSN8?=
 =?us-ascii?Q?/njQ38qaMyaGycvC6mYHzVvfsrtcE8VbHaYjlFAYRYoSguYQYLSPbCt4U8gu?=
 =?us-ascii?Q?is6Edrvuw2Yc7tKuxtcAEFoPS442OLAma7FKEVGKgRi49YUZAFd3lma5ue35?=
 =?us-ascii?Q?glTlCIlCjfX+YKTu3a5dH8xwScOzzoq4o6DtRRJ/16PWnhv4G2CTv1snrsU8?=
 =?us-ascii?Q?kFMe4vFx9/KB2lXmiATCkoRbIJWOe4rD61T+7c0Bk+mt/kWqGJT5rt8yCOxy?=
 =?us-ascii?Q?+tEp1BsPkKdK1Qcnop5SBx1URWCgg7rOua1YtZABLNj1479RtLnZhFCADA/I?=
 =?us-ascii?Q?UrSQxtOVK15LOYaYFMERiqis5HOXifWZRC63IBwfazdcRW0YCf4TbpUMvsEE?=
 =?us-ascii?Q?qrOE6EDLEiq+imzIj47ynGk3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4771086-a54e-4d61-8728-08d981cce088
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 15:38:39.4528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/w4P5dhA+0vGz6z9asDspVqpLtj6iHmmcCiZl0uuNFjm5SL/eZwYyeNpFIuleeOqN6m0EY7CGCuZyeOvEA/o3n8XFXvrevkgHFV9xVHRME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4641
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=937 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270106
X-Proofpoint-ORIG-GUID: PzI_EPY0d9o7J6k-CyIrJD2xaBVQpwGs
X-Proofpoint-GUID: PzI_EPY0d9o7J6k-CyIrJD2xaBVQpwGs
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 05:27:18PM +0200, Krzysztof Kozlowski wrote:
> I don't mind, just take in mind that Sasha Levin was also pointing out
> that quality of fixes applied for RC is poor and usually does not
> receive proper testing or settle time.
> 
> Someone tested this fix? I did not.

I have not tested it.  I don't care when it reaches -stable just so long
as it does eventually.

regards,
dan carpenter

