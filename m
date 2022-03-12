Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8BF94D6F97
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 15:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiCLOqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 09:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiCLOqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 09:46:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9201FF417;
        Sat, 12 Mar 2022 06:45:43 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22CDWFSC006842;
        Sat, 12 Mar 2022 14:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=bWnxhGqn7plLX/Wzh98CfZyE1QTOD6IQoDY+PmTuTGw=;
 b=1NzUBzTJPT0Sj5Q+VgzuCgf8HAJvSzDB2eWvoNQSwN+Wg+Y6fHrUCsABvWWZXucLO//Q
 iBV/+Vix0tXJBe+BSBHX47mKQGaB2nXpBEFFe8ASTxWxJ+7pzgxOZtb+cFmCIySlLP42
 euQq7wsap7kT+Ky7YJVLr/hR7EBBCsKLNMQ6wg42gyPQWJOUaz+AY43Ut1HJHjlirNza
 QnOhvyGfotssaoR2FoomP/gvd7ukjPJkYjIsJ8sl1b+s7te/Z1AxJTEdQObNkmBgEVcp
 DritDzRs12BqfG+OFVdQ+YymQM6vUOvrAycuHNomeKCniO13GG2SsJYHb5AitBWo0NsT Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3erhxcgnbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Mar 2022 14:45:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22CEfSPl008324;
        Sat, 12 Mar 2022 14:45:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 3erkayp1dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Mar 2022 14:45:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqOlK/yTq8BMwulaVbCBRP07iToGEGEezDt1X3aZLLgE408kg0Wq7dTPZwefMrMpp5hftdYVyrkdQqbWcPZ3k8I5kGYwQgPoK70KxsZjOina7sHhGnshQN4OKbF8UbRgfbnjdrQzD4D0MPIj8YtghXe8FXB947lP5EpkynQvD9hNwSaMk8YDTtwrWzsbuKYqdlKtPEDz8iugbiHyg3/qIBJO7rTAi58xekbK8531x6HHCAKFZuqU453ue15rDh4ZXa2rCr6oYN7yZdYQ94mT4Xvb15LC4pX9iKM6+ZgaZP33nBz2RkrO5aVxixIYeg7eN38PiIinH6n2Oi4pi+pRRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWnxhGqn7plLX/Wzh98CfZyE1QTOD6IQoDY+PmTuTGw=;
 b=julhFRfxoR/hf6ICC+v8l8MpvZhn4dckDvHm3Z0VCpd654W/hdyTs4ik0oaTNlGJa/8fByx5ybZODvb6hBxZToh8F9risBvlnOuUldv8JwbOd0jt6nURY4DwEvgi6bl8KB2+//1PI8+5LjZ/g3W6nrb5o2nCSnvs0zfYzuKRhCek24tiVttfWzCPVoVJ3gMA0PL0TewyrhSM12g9PmDi5frE6cgenJPxyBrEk+rQSVRKRj7sDXgEAqyjkav0MUfvvmYy78H4PRpMndh6fORk+17q+NHXtBfDGAmTsHjyWsDqwIZISKpEctaOaFUjgCN6oq731UrMqzfwibdqHGY34A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWnxhGqn7plLX/Wzh98CfZyE1QTOD6IQoDY+PmTuTGw=;
 b=xrrAS/vfmug7Uljn8ERTgfErKS8YeOW5Q7kett6WaLRLmcMU7YZ1P1vD71NZpdEnD1ArR+DXMlWAFI+BacSehszburCIFYBmJM6h7KKzb8XZnPDwG8rSEo3lX535eM9oMmrpWXcPlfq4SUDUv9iTVtM0WNmfyrKJgORzmSEqoIk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH2PR10MB4055.namprd10.prod.outlook.com
 (2603:10b6:610:5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Sat, 12 Mar
 2022 14:45:30 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5061.022; Sat, 12 Mar 2022
 14:45:29 +0000
Date:   Sat, 12 Mar 2022 17:45:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mike Lothian <mike@fireburn.co.uk>
Cc:     luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, luiz.von.dentz@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 12/15] Bluetooth: hci_event: Use of a function table to
 handle HCI events
Message-ID: <20220312144512.GQ3315@kadam>
References: <20211201000215.1134831-13-luiz.dentz@gmail.com>
 <20220125144639.2226-1-mike@fireburn.co.uk>
 <CAHbf0-FEVZZYg7U__YXqPmS=XETb2pObB-8CX+vh8=-HivppJA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbf0-FEVZZYg7U__YXqPmS=XETb2pObB-8CX+vh8=-HivppJA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0034.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::22)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16cfdfc0-ca92-4eb6-0dd4-08da0436f3e3
X-MS-TrafficTypeDiagnostic: CH2PR10MB4055:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB4055536BDA01734CF5C6D98E8E0D9@CH2PR10MB4055.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ek4awLD4sfAsrY7LTlEijzc/64kdtTQIKM/1Uhqj6+iJrZCThUb9Ayr+MNg7NjgKBrkufvXkjDj6gCLj8QjwVAgnrxs8xXbgxgzeZ2Z0XbuSbQxQHCKUAhNXDsgR6g6adTLjpqMntkhbTXq6tqR4Xwp+H0JNLOP1FWxvMVnyz6uJU4cHlF3ARBKdARIrQdhtopKVlZ0Gcpt4LPB2bT2oNUnARLngVdCvnpBPEORbcG9SQJ1aBHbL2M28ZoylBY/T/aJfRfTl3iGKbtWl0SV9ZM1mzJxADGACCdkFcWEkojAhuvWRe4Nu973o37m06FBjf4m/wBu9fIZijEsfaIpXvlLe1sWAWMqpby2ZybTrUlvR4tnwHd5kKWZvN6GlMCV5HFaN2sruGzDDvCFsqogmV8RNUVuA7z9S8JluzD+0ZZhn7eJe/xrJVLFUqXD8ZNY2OmgsP49If0OlQoIlRiqJ1m+1r5eKGDiThRN8c5dpsMOCCEtOE41MsmuVgtALmjWxGExWHvFETZYitdvHXTumxNuHlqcgbsg4woN0Z+8ymJz+3ZP77kA9v+mNWYlKa1UWMXLpjO9BjZDseEvgg/5LelzS09Br450SX4sOevrmX9o+IHoCn+ilD/kPSlP6MJRCuqV0KL0+RRBb8zLml7sGAOwIl27Mar5AannIsoePoaNuB7UZcN53EPKlVaTbRqb3PJKiqJxca3nxtFyEq/9NHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33656002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(316002)(83380400001)(8936002)(5660300002)(6486002)(33716001)(6666004)(186003)(44832011)(38100700002)(38350700002)(86362001)(26005)(6506007)(52116002)(53546011)(1076003)(6916009)(9686003)(4744005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?azLGyBMDbPjUREQTHtPBbVUKJZcL28dudPQ02penMO2RoBAyfMQ0Aj5/gcM6?=
 =?us-ascii?Q?Jgjs4Bvjq1tIrjRwQdX6IMmeMKLpy4NWfr8ewkiZacC7NGWGMP4mhFML3oGc?=
 =?us-ascii?Q?+SQnbk5AZDz44s4gf8+PqgTchXkNr2CXX0QHuAHymYn+EGBYvJ3YPS5xPJux?=
 =?us-ascii?Q?DNCIPLohbWL8VHog0L4BxP3T67Rt6bmsrrrm0MC8SWe25jUFscoqnoI0PIy4?=
 =?us-ascii?Q?vG3lVC17AX93NKi0zue3M9lkYYoDtDYc1aWVV64qEgPdydjHON/inHdNnffq?=
 =?us-ascii?Q?CwvQrQuusFHB73pULKz51sV19aO9+fojJq3G44vPbqOlfMX570QbvEOhJUmG?=
 =?us-ascii?Q?X+qomcULA0Z6Rnx0V9pjkLqKHBvLVsA3WGVyA2CuobSqvdwx3UMflz0TWQWL?=
 =?us-ascii?Q?fxogC9NLikZhmRyjOrqA/q5qkqz9JYnEnaPUvE1XlaoDxuhJP0vRyfA3q+d5?=
 =?us-ascii?Q?DTlycoxgXZ7rrws2ig9Xf9JN/qSoZ12ei+C7JqAaec7VkGN2zVijNz9+MU3K?=
 =?us-ascii?Q?IBmMbfbNVon5YbW4oJ0nO0xKqQWA98qIEl4jAR/mNu7qP4+XhpUVYjsAB4gT?=
 =?us-ascii?Q?+N3+DDnOr5Hy8zilDWU732iiFtowAOE90pLm7eZwLZcCS2kB2UTR5b827Zzl?=
 =?us-ascii?Q?XDzOzx1smGgaYR69FdH6m7Ggd5J+/SrbBqHKlrIftEOnj30CfF4yYIZCetjx?=
 =?us-ascii?Q?kazuZBD7HC6De7+HZ5i12EYOlSzMNBj2vEvWNyrSKdAcMkqLRShAFzJeBk5a?=
 =?us-ascii?Q?pxH7emzpU2qmsqdWCVNuARdWcuwX7GxINDLngo7Qeh7EgGBRY92KQYA8ymnr?=
 =?us-ascii?Q?QQMFqlcBM5LkfG9/DxMxXHgzA6jdRMILDKxt4voVE88ks4q8Y87Kgw4U/+Na?=
 =?us-ascii?Q?KXUmV+OfOkuiVt/ofm5zZ7vgssdhXKvwvA2j1U9KZAuuFvnJb9hnGjhQ9JBn?=
 =?us-ascii?Q?h28msA4/vjcRKsrq0lkTTvwpJbZigpChtWk30nZQLbyqUozcw5ZiGcR5YQSb?=
 =?us-ascii?Q?ra6bWWaWjPV3yLeLwRmoIUd0dbVoFUPyXrH0VUoSW7/2eym5PiMVC+ypElz2?=
 =?us-ascii?Q?L1pWCn6IEg6hmORBdshtzq6QiAYGb9NkBFWxUF//8HlbPprpioJuZ0qO7MXl?=
 =?us-ascii?Q?WZ68/wo6bREWcBfW50TxFNgzn69T4WRVGo0aqovWr32GLrHFHJ/QSkUgRNvB?=
 =?us-ascii?Q?o+4a/Mumzs/3Pmr4tg01L/WujdNGwxpBuVw7ZR+BdKAwNL44LmQlqhNRvx4v?=
 =?us-ascii?Q?KCzjFq5lIoFMXak3Ved5iHZyHYzncslnm4XiDuKI2Uhj/5WSVOqiRVh7CGGb?=
 =?us-ascii?Q?tDr5xvNgxNio598uoSgOrQ/IqnbOShE8IntVI+JEOA+ygx6LwY3RUojuwtWx?=
 =?us-ascii?Q?Pe5WhsLlBoHBzi9Ty44wfWSbsTLwqwRJnuoXJJUjU7/wVP4uzU1hLSI+MtXe?=
 =?us-ascii?Q?2fFbL4ytJQaYhuWEOlb9Hg36GdxCR9tMDoVcux4Mpf7+vFCN7v1cvA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16cfdfc0-ca92-4eb6-0dd4-08da0436f3e3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2022 14:45:29.7053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hS2LkC5CAxgqFU5YxqP0sFB3nc8VMxEGY5++Uxk8oG9Vg+ytGZ7PryYjsqF0IZGe1Gd2wXNBdIYLUkOAAU9nccpnyMLP+G3AJEPrBUc1Y38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4055
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10283 signatures=693140
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=936 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203120087
X-Proofpoint-GUID: q2o_buPiMHQiuMTnKnnfewzJChRb86Y1
X-Proofpoint-ORIG-GUID: q2o_buPiMHQiuMTnKnnfewzJChRb86Y1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 12, 2022 at 01:56:13AM +0000, Mike Lothian wrote:
> On Tue, 25 Jan 2022 at 14:46, Mike Lothian <mike@fireburn.co.uk> wrote:
> >
> > Hi
> >
> > This patch is causing a lot of spam in my dmesg at boot until it seems my wifi connects (or perhaps the bluetooth manager does something)
> >
> > Bluetooth: hci0: unexpected event 0xff length: 5 > 0
> >
> > Thanks
> >
> > Mike
> 
> Hi
> 
> Has there been any movement on this issue?
> 
> I'm currently running with this patch locally to make the dmesg spam go away
> 
> >From f786c85baac0ee93730998fa52cbd588c9f39286 Mon Sep 17 00:00:00 2001
> From: Mike Lothian <mike@fireburn.co.uk>
> Date: Tue, 25 Jan 2022 14:52:00 +0000
> Subject: [PATCH] Remove excessive bluetooth warning
> 
> ---

It seems reasonable enought to remove a spammy error message.

Can you resend your patch in the proper format with a proper subject,
commit message and signed-off-by line?

regards,
dan carpenter

