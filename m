Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D345A455F1E
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhKRPNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:13:23 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11808 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231879AbhKRPNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 10:13:20 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIErQ3J000713;
        Thu, 18 Nov 2021 15:10:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=yGzZSNfm258Or96NXuGOfDyI9lt3WX+vX9Rvc0b/IGo=;
 b=JG4TR8FHqNZyEoDPkL8zZNTb1IVcVyVvNMv0TEZ/vRw6BmlUiH/6GJFhc0aSeKe5zNFJ
 vP1Rt9Ui6Yj2oFRBYHr0ncMnxMT/aZBfbA4QlGNj3Y5D0Lyki8dXmlE6HtXj9+HoTLK8
 Vo0eMejoZR9AbG/ViZDxXIFA5FfWm70Y8ta56QsvmIVy2EY3otoJEdTrzMm7loUoXR5S
 vTeNhz3st5U0Cr9VSYiP1FEtk3271zx1IG0UkOo2Ke9357YhVBd+2ZmbrAWSHsuZ2ucA
 u84X2pBY+m6pIjPVLJ3Fn7iFea9mZ21amlLIHoLr4OAhX9wstatKfPDp5T3+U8tGqVsb /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd205g8yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 15:10:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AIF0lP5030819;
        Thu, 18 Nov 2021 15:10:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by aserp3020.oracle.com with ESMTP id 3ca568q6ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 15:10:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/dGmD6T0B8eZT67/E8h5fF5JvfvOn4zAvN4XOaLFd2HAgGGNtNTqzNVKeU8lLfEg91BgAoVieCYkI++91Ezkh7UbO6l4dkyKy/crkZge9nb2HQLoPZ9UrMKMCvgy+IXHCNsyc65fOqjSvYmqQSD1xAAZNNkjPLbrhhMELO+IX9hgu+mJ4JqcHCkMC4iyHuUTrxHFTbCU+UGqJRiIU//ZOtxQMg9xRvjTI3gtADrHpS4d4L4x18JK6F/a8uSVjL1voiVgFuImkwwnEb5LkRvi4N3MoA9e9cUIGihR8tbGJNiQRkh+dtDBXDJ/YPUJSyBB0+vnHEo7VvvVFV6hqDbGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGzZSNfm258Or96NXuGOfDyI9lt3WX+vX9Rvc0b/IGo=;
 b=D8b681G9jOr8BTJ0S31YYWp6Uf7QECAUfFca0Ylrba5fdamgknim4Txv0NtGJI+4N9Tp4yTtsFCNIgJExDkOKs2HK6+JsUS9zxJ5I8V/HlpFyZybXGlJ7F5SiQjAqAagbRiPP6v5glx6aYS4Dl46FZsW57Q6yqI66QZelWDBrbYVH1Sk/o05cosTn5QFHHoQ0fm021NjWGRHjb4Hf0kICTW+klu+KokHHFOBqL7gMWH0GuhwxnRrDx7dBDPJRRcVa4xz+xLLLD0RDxEwx9EbAZXsRZtXVSPryyeUiqsnb60oDZkR16TPEE+FZbyKHJryvl9B6AyTau8YokMZgy9DNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGzZSNfm258Or96NXuGOfDyI9lt3WX+vX9Rvc0b/IGo=;
 b=E5+0yrW2SoY5u+LG4kPPkA3PCh6jH0/ofngnnQrkwpffYiI8S6EBQy8cYxce5omZhfovgM6eMF5kAdEEsKeGBHuEwJyvQyspfVabbGEp800fyopgx055G7+fmXBFDvMVGWW1RFOu2/lcyBRf5sd0PG0+rqPUDJwJjTxTKQ3dTBU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2094.namprd10.prod.outlook.com
 (2603:10b6:301:2b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Thu, 18 Nov
 2021 15:10:10 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Thu, 18 Nov 2021
 15:10:10 +0000
Date:   Thu, 18 Nov 2021 18:09:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, aelior@marvell.com,
        skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bnx2x: fix variable dereferenced before check
Message-ID: <20211118150937.GP27562@kadam>
References: <20211113223636.11446-1-paskripkin@gmail.com>
 <YZYULWjK34xL6BeW@hovoldconsulting.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZYULWjK34xL6BeW@hovoldconsulting.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0005.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::10)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0005.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Thu, 18 Nov 2021 15:09:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec3928fa-8e66-4bae-86ca-08d9aaa5835b
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2094:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2094E83C81DA984BDE7C22C38E9B9@MWHPR1001MB2094.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m/IRkErodqlxsn2qN/45ZZA75Xo0Z15/Wn/ubY7ISFXUSwIvr+4a7/bLDlc8+WAqv2nZ3IhM1BlANQfXpa4q5N3Qe+vTTTactPCwoHYk2QZc8+45cMUAlyZAa4nHJBC9sLDWphJnUrJ/aMrqKVdGtwm8ZtzrPr46o/dVJ7TgNtrI9/a2aKUgs5CMwFgymnTJTgHNrmOF+kRDVBGlcuZYVZ6VAmI73JlPY29g+IRfulA83INwe1Miwpqyh9C3I5tZPlK6lowKfaAxfdeV1iQLr4pmHDMry8mKynQ7/vrDu4s9/fzmsv9OVdG0rxe6vTGmhoCrwT0y9LZF8iMpURwKP0Ml0eEVL7zZ3vjXbbvMzbt2rjjol2CATb14OvJovRsz1UXzDvy/R0w+/2OgMeenO5CqnFjOC/d8sWv+Mjje5wTMDKTS8mMN/7n10Fn4ylsvHrvM9GJUpATleh++ZJiVhqKX0FjWAho2XVrhoqWkf28Q30opCCe/xBVK3QpCNqe/mRUISGIzc9nYT1jpHUp8KnzTyKkFWI4qvGBX29GLaIJ+g+3ciYXKu5j08Etyka3Hm5h5iGjkZ1D38HML6YSqrOi6G0lYxllmW0LSmDUwl4n7il2P5QltzIKJiLah1EYV+VdZPYt9taf7vAnNY0ozcjty07smbvQjBV5M4w5RSlzDstF7WJDlZPAnEYWpHXvp2NRaC9rNFw+eLaLw/peq3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(38100700002)(8936002)(38350700002)(4326008)(186003)(2906002)(6496006)(66946007)(33716001)(33656002)(956004)(66476007)(52116002)(508600001)(86362001)(316002)(5660300002)(4744005)(6666004)(1076003)(55016002)(26005)(9686003)(66556008)(8676002)(9576002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?exdZwMKceONfbobkXVoGyo/6xJRO8e1r3nsjY2maMTR5vNn+JdkgExzIeY2t?=
 =?us-ascii?Q?QiOrXhr6gjihLhhRMzxFCYlEbFgPg111Gnfks2pBX4o4Tw6YGZQwXORrl2Vo?=
 =?us-ascii?Q?TNU8meAC/6FGPjoysAKR6Sna8UhkuGbFIHlM8krjHbaxW/6cJVl0Cx478Uz8?=
 =?us-ascii?Q?otCysD3AV84kDQj9fJHGvyv7JCAtklVOGlROAe8McGq0Crqt4zoTJF9fQVgK?=
 =?us-ascii?Q?XG8s77IqHl3A0K32u75jXM+BmswV/9ZRngMcGNGGycvongnSQW98XE8xBUnp?=
 =?us-ascii?Q?dWRZnLNAS2iBeQxxYYdPpsL6reycjcItVjuuo88nF6YYIkEnBHUvh5advNPT?=
 =?us-ascii?Q?ZIQnOeW62Wr0QWC8UKySKmvKG7Lh7IgBt5GNolwFxo8QuHBsoy9C8J3ydHMQ?=
 =?us-ascii?Q?1wgdXKTY/FeIl9e5whRb1/QNMBvlElyZLqF0EUi/lz4FgdfNGMdrYmQLF01f?=
 =?us-ascii?Q?FTQpGxVEU9jqBDcJmBofMHkvmDVJns2053H8IwOAsTVMJvWDdL+ltn4Nn08e?=
 =?us-ascii?Q?1NAYXAs8DjGajqBhmtX5GlAzRko0t9hkdFS5vTwH/oYYlNIWfFjBVGjaEaal?=
 =?us-ascii?Q?UKl2Z+gRtslBrREGjQQZyYREDy91lvR/AdkyAZem6kt3U9+dC97dtOik3rpP?=
 =?us-ascii?Q?NFyL1cKAKfDqYfLu1jO5ZqcO62MbxRCNuBTipTrn4CMB+2CX7+1CINKbRxrp?=
 =?us-ascii?Q?a1H4KoMMi/t+0HaTjvZ1Bjo2if3gCBYbOjf1YTW1kZwxUm7n8tnskMZsvM9d?=
 =?us-ascii?Q?ehJQAJ0aNHDhB0FAIr4H8hb6hMEPbGEPGL9p56KNQZEEZkZWSckuoIJ8XDyv?=
 =?us-ascii?Q?wu6QAYi7pZ9yxXiDVLQ7TLVaxJ4KEJIqMWIePr8KLfKJX43P5rMgJfOj7xcY?=
 =?us-ascii?Q?BdbncdjVUbqI652/WrP3R2ZsKzfWX39rACKwu1EKhMY7xPPspbpazYxiyXAL?=
 =?us-ascii?Q?E4RyhcVGcpX5FWVYp3FPtBDokwGYbmT3Qd6IyZ5ais5ogkIQmFa+m7edqhlV?=
 =?us-ascii?Q?v+MEodF8PiCZGNzJZNFncp/llenuPJoCaaUh10s6xrAKDCVEkunqLBe6EMVY?=
 =?us-ascii?Q?U4kenEZGZQTLBU25cON+m5DI61xHCYNWXdx+zxyrE6cPnEUMl5r8gQ84JNMD?=
 =?us-ascii?Q?6JisdENcuthSKO/VG5OXUrVx4iaqgj1dKr4DEyfEEv6qyo0PVAixI/CRmrWt?=
 =?us-ascii?Q?XorbQ+GhVWrU52aj+o4Ycnw8SBXxiKgxKwUqMOc2LQrDJzsIppt+WEuOreyp?=
 =?us-ascii?Q?pW0t4fDAg9uooMJFnxHd0GqPuw0ilBwYPly16fDgOkmZ7Gr8nGR/Lx91qMXa?=
 =?us-ascii?Q?2T4kOKpQE8Zsh4+k8GVFHdn6Vm5Sr5MQrG5pyOhBgCBIB6d0bvexnI57TiWM?=
 =?us-ascii?Q?fvlaGAJawWug1rJtwn6XHWLUuv4WnVDl6UdQz1majKHUD2z6OJH81+jVK7pm?=
 =?us-ascii?Q?Nh7EV2M7O7HIC310mOV0zXc6jjVKpjtY5Oa8ppsCLe1CwxBhPxS0GxIaS3uk?=
 =?us-ascii?Q?4oeSr4novx6PYr9S6sK8SlQQnRcKnYhfCDQ7knosJILZpcsOpN6h71tH2Mkc?=
 =?us-ascii?Q?j0Z49cWSShdspn85T+8HT/43V25W3sHu2RhNC/SYjY9tP9fGW8SIBGVFvyU8?=
 =?us-ascii?Q?tzYV7hvrEUBryVMshBCYXl8MwvSaiwCOcSkJSuPS9wSG5x316m3DwCNULijf?=
 =?us-ascii?Q?UmKYKQCAaHkqudPMgrqjO5n1x/A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3928fa-8e66-4bae-86ca-08d9aaa5835b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 15:10:10.4522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBH3Ip25pgvsY2Pylf0uj5yB5PmxoBP4rMrg1o5FO7rdMpXfcS+9J+oanMXYYFdtsNslVrVsb8xK3qzwsa/4XVRfhTEn0yeX9y4hLnJcuzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2094
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10171 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=996 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111180084
X-Proofpoint-ORIG-GUID: 2Hq1_5zovrbTuOdKe8K7ROCT_LFKowOB
X-Proofpoint-GUID: 2Hq1_5zovrbTuOdKe8K7ROCT_LFKowOB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 09:51:57AM +0100, Johan Hovold wrote:
> [ Adding Dan. ]
> 
> On Sun, Nov 14, 2021 at 01:36:36AM +0300, Pavel Skripkin wrote:
> > Smatch says:
> > 	bnx2x_init_ops.h:640 bnx2x_ilt_client_mem_op()
> > 	warn: variable dereferenced before check 'ilt' (see line 638)
> > 
> > Move ilt_cli variable initialization _after_ ilt validation, because
> > it's unsafe to deref the pointer before validation check.
> 
> It seems smatch is confused here. There is no dereference happening
> until after the check, we're just determining the address when
> initialising ilt_cli.

Yep.  You're right.  I will fix this.  I've written a fix and I'll test
it tonight.

regards,
dan carpenter

