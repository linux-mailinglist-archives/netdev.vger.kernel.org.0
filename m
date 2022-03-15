Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FAC4D98B7
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 11:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347083AbiCOK2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 06:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbiCOK2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 06:28:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0ED46154;
        Tue, 15 Mar 2022 03:27:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F8YYAk003078;
        Tue, 15 Mar 2022 10:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=uusPRFoA5VyALwEqg9bJD/peiLniv3l+1YwMZLISwbQ=;
 b=X1/o+tIGw1SCv7flu9cCjw73MgL6ZuEI7zWnLPcunfnCNpWvhgAxs3l10H9X2vE/wJOa
 GqjbkwybfiQNnOKDfaEICU5Fl6aqlkaBSnhYPZrLPqCH3iblww6lMCbAqsl4VZIT1Kwl
 FeRWxVvvJIs3NWbRflyt/kCwBgC5LeONBwbgCgoMfuvXe6ROb42JlFRjpsEw+mv660gL
 D0jBBr9ovHcgMmJSFk5EOj8zGlihp5VBkTfXg35wWtHRoT2S3D+mrbV47LIJuQtPHObA
 +fiShWATcx8DTKcvoePL9CsDxehkswnovxKjrCVbeBV+kAI0y7S/iISRBSSSXIwM+jCZ ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5fu2sr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 10:27:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22FAAH5h032891;
        Tue, 15 Mar 2022 10:27:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3020.oracle.com with ESMTP id 3et657gm3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 10:27:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLCj/4som/1KkOkn5bLg4UcA5X49xoZpB7iPx6Xn7uvZ4HS/FmYEfkWCLFGOa2J6wuZfyNW1wZ2XIY8HFSxihYZYQciNv0p3u4Y7AXPXOiWD2mMHiRkg2fyCXtu5uqhYPmb4/2rm47MV3yCNKSR399zZZ0ASjWjnpWTu6Fwpl7q/ZaFsh7Aw9z/YU3ySImorKCZLY6WmB9D6oAOS6LVEC/j2aiqluntLGYpKrWDCBb72y0eZvHfRfXeelzX+epTRvXnY93FP503dFR1ZPkMIREVJhw6Mm1Xu/XAfUVp9zBZB+y7ajrq+2QSuVxWvN1g4/Pa3Sj1/8IDQIaOa5b87GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uusPRFoA5VyALwEqg9bJD/peiLniv3l+1YwMZLISwbQ=;
 b=FHrg8DJo45qqI6A7FnZm78eIT00qlSkURPDw0iYRDbL9FivX223tNSKFQM973szbdpvWEUb5aSSMAH2CIhja+zhuXWQupH07xlm2j8+B85J05NGI0R2mylDIp5dLdNGR3Yo5anP76DRjAxoYCtskYxZWrIdAvdusJeI1qKAXNwv7qCmxaYvX2qrHowfkpJWWY0YJCLI3ejgRIaKEQKitZ61RiC9lVQbQH6x8H205vEUefpkDxnt0vH5dXb0vPLszuXb+PHeWSzNESKTi4gdFxxKQ9EQcztKPij2cYVp9gXbmHh92tlsHaJcwMNxBy285030nzdOHLRvuffralYHcug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uusPRFoA5VyALwEqg9bJD/peiLniv3l+1YwMZLISwbQ=;
 b=K1UUi6LtsfcKsTJe4JiqqHgQN+AmjASoZ+Nxavq14EJ/UDPGEdqizpZLh2nWslKYFVwcZmDK71bf6CCcFxXVwuEOKXxP6JcItO1evJxMl//njC/isqMBzCrWOY8Vl33EKN5pV2DJNb7vgDQvRLhuiJvKvFlts5LhPT/3efsvQeg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR1001MB2121.namprd10.prod.outlook.com
 (2603:10b6:4:32::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 10:27:10 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5061.022; Tue, 15 Mar 2022
 10:27:10 +0000
Date:   Tue, 15 Mar 2022 13:26:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        ralf@linux-mips.org, jreuter@yaina.de, thomas@osterried.de
Subject: Re: [PATCH net V4 1/2] ax25: Fix refcount leaks caused by
 ax25_cb_del()
Message-ID: <20220315102657.GX3315@kadam>
References: <20220315015403.79201-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315015403.79201-1-duoming@zju.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0001.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71b171b7-23aa-47aa-7b4b-08da066e5d02
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2121:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB21212A660B1CBBECAE9C20EA8E109@DM5PR1001MB2121.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: spLBXJ/9icyGw3uEi+zcn9J9aS9yfX/PiRs9oGW4koC0zzhEfZUdBwNf5mX93tjJkE/GGFEKOh1uOIL0Os1cXv6GanG5Y5TBIXHwG9XWunwcgchfc0mLBnAZh6Y4M7jtRbuJPJjUcH1TgiBz+Kh+gh8/lWoZTwkzL4p7zLWNLzIpJoVIqQm96P1HOKL1xZhfSaw4mKsiUWfRqrJ8YwvqBqDCLsCO0hqjM45jM9ENQiVeMq9GloIa65Vd8jwCF6GYGuC5pp7OdkXlQ5WtNaj3IHMGYNYjDvZfvAgWXY9VlX9JFhoMIpQDK1U7G+NduOxMkNZDP625h68QaJxh4pdxEzWsH6TQjlKziaCHs3hjMMch6fV1fkkgrpMJeTTFbtxE8D4FXDR4mP9GyS3gVAwf05a7uChDdqPCy8XASSq/lDNjQR54ilUKMMKAy9PgkivQocZ1oDFEPU5pMnaFlriQlh1okTPkf5q/Qlc+Lt4Jwi3KTwP9vZ94kCX9LUWCh8xZlhQxu0IFAayRLpxVeZd/2bYGM8ZolHV0r+uYSC5kdaF6RWS5WhYHWpNknmUUP8BbNg6pj7lFTa52bTn5P63F+0ZWcwsmUnj+rSHxWxALhZXjPPeU2F+bcunY6zXeARXLNQ/VqSXIkWlLfj7H0FAD4l88Y60Ioe69YtlIpWWNb09amo+gOaQQxclEVnnT/v7QS393yqN1tHURoK1q6rb4qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38350700002)(38100700002)(83380400001)(6916009)(316002)(1076003)(6486002)(66946007)(33656002)(66556008)(66476007)(508600001)(8676002)(4326008)(2906002)(44832011)(86362001)(52116002)(6506007)(5660300002)(33716001)(26005)(186003)(8936002)(9686003)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o8YHvebht3LHFsSfNFye9nwDSKiR0sxKMpmCv6tktXNXOg0wLVHjgXL5vr8c?=
 =?us-ascii?Q?gmNoBfP4nKQjhnP6JtU74QjGOlllHC5gRD46gKsvwA/ZcdK9C7sAKF5lZmqc?=
 =?us-ascii?Q?4FsKvdVhV9/2ENt0gb+Z3l2MisR4guSeoYnA46G002sVnmA+mAZrcInkEGQh?=
 =?us-ascii?Q?sWVlb32WzucAnxKGvc6sUQwNyMRIK+YgFtW6yUOb0HqDsthAwggb3PaXYrRs?=
 =?us-ascii?Q?slwEb2DTx0FjnDMkD9ullIwj7N8e8YNbNCKnscXxuFCLOwf1kXbl0Qq1FDgp?=
 =?us-ascii?Q?hAPBstoHkZa5Y1GxMA4q0LAtiNe2F1ULpfrgftptjxLH+mVafXk2Py9a2Co7?=
 =?us-ascii?Q?D5Jc422UdMstqFnbRUcjZcutV/H+AIfiGb4zOWLrda7cDcq3Cn9WkqUoxTQV?=
 =?us-ascii?Q?N686X0GUVhZ+DRHZ2TCr4ag659UC7nq7GVCVKr84q78pWQ/jrp8xc+f4dsFQ?=
 =?us-ascii?Q?1RWuOmDHtN3j/aicv5NFAfpUpNhCH2osxAWVGc332eWpHFoNBtyK0wZ8VXq3?=
 =?us-ascii?Q?/idlGFJEFn3nkRXJB+W46RsZOZr4lSzd41DI4csHA5XVBoVBnkfKMs9K+JhK?=
 =?us-ascii?Q?MswFKZVRT96kAe1mLc4fC2/z2oCci6H4NGC1Y16BW+Ormv79D4T4bc0WbAH3?=
 =?us-ascii?Q?H1ppDl8cMfMInAkDKiocRbhpZ1KdGwXYuOTi5hz1e4le39K8RDl2scDS2KeC?=
 =?us-ascii?Q?ksYSaaqhU/N0rYIfor8zBqLzXzJA7FVIP0J7n8ahAdAuivibaL7w0dwokLtn?=
 =?us-ascii?Q?b/59eLuxePFZoTHhX/1jVy1hqfwCTra2YL9PKp6Y4itfjXdYfs3xcm/Tpndy?=
 =?us-ascii?Q?bluw++jhZ9pHAdnBNfoDU6jQ5BuBFQDbIZbj4sitzkeGUaYIzBr2BrloUgos?=
 =?us-ascii?Q?yldRRQn9sjHcH9fI9Fe3gFeB4J43D+IUUgRVV6oHY/cTUwTwBlLkpxVKolfG?=
 =?us-ascii?Q?IASfWyHbyPEG/3Bxlu6ksUSSbGhRs3KDELtdM4H+JRj//w4g5/+nIqjpS9Ws?=
 =?us-ascii?Q?4pXJ0M8DcbiUUTV/VNbLwKN9cg634TGFYWkcDi5adkHGZTsahvwaYZpUpjCk?=
 =?us-ascii?Q?yYroqlwBsJzniUBk05WqbG6ChB8M65pMp4P38r436CGoWAeK91lY/JyzMDZ3?=
 =?us-ascii?Q?bu2RX7EvDNSk0btq+GLUuXmEW1b3gwZhoJ+sABGL81+wryT/TiZ3L6OKtD1p?=
 =?us-ascii?Q?SZ5+AJGg8OcyNMxcNcxHSz+eZ+Ifp9rLiOoo9k3FyuqV/h2w8INnnGjVLoD+?=
 =?us-ascii?Q?75ExIWrWt5igU5jlJxxXWewCdc8rtN6r+Q7cnhnOAY/5T5nZIiM7ehHjQIQ0?=
 =?us-ascii?Q?ZsZMj3Ug884iX9sNxo/AomPeyETEYREPAWiKx3VR9H12Px4RbA2JlqBzfiZY?=
 =?us-ascii?Q?w2XbFWv63KpbG77pJ61j7nRv2FowOqOxHIG9mvfNhUKkZis3PboYzxCq2V0w?=
 =?us-ascii?Q?+oAbxDbYQPE9E0YYAW1D00E5Y5a4xKxspXiw4YKKNYKuVPFuWYkj7g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71b171b7-23aa-47aa-7b4b-08da066e5d02
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 10:27:10.5615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1nknQsbuDY8RfQqY4fUPl0jcgiG2ZyV03bjbR/OEfp6noI5GnbQXgK9JCn7rJoBuAWA2cyUaa+MCDF3adxZfaQbrT+duyivaM0qC1HeYcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2121
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10286 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150067
X-Proofpoint-GUID: Jo6Ls-ViIjGKdWZGmBRyGvPFuvgY5fhz
X-Proofpoint-ORIG-GUID: Jo6Ls-ViIjGKdWZGmBRyGvPFuvgY5fhz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 09:54:03AM +0800, Duoming Zhou wrote:
> The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev to
> avoid UAF bugs") and commit feef318c855a ("ax25: fix UAF bugs of
> net_device caused by rebinding operation") increase the refcounts of
> ax25_dev and net_device in ax25_bind() and decrease the matching refcounts
> in ax25_kill_by_device() in order to prevent UAF bugs, but there are
> reference count leaks.
> 
> The root cause of refcount leaks is shown below:
> 
>      (Thread 1)                      |      (Thread 2)
> ax25_bind()                          |
>  ...                                 |
>  ax25_addr_ax25dev()                 |
>   ax25_dev_hold()   //(1)            |
>   ...                                |
>  dev_hold_track()   //(2)            |
>  ...                                 | ax25_destroy_socket()
>                                      |  ax25_cb_del()
>                                      |   ...
>                                      |   hlist_del_init() //(3)
>                                      |
>                                      |
>      (Thread 3)                      |
> ax25_kill_by_device()                |
>  ...                                 |
>  ax25_for_each(s, &ax25_list) {      |
>   if (s->ax25_dev == ax25_dev) //(4) |
>    ...                               |
> 
> Firstly, we use ax25_bind() to increase the refcount of ax25_dev in
> position (1) and increase the refcount of net_device in position (2).
> Then, we use ax25_cb_del() invoked by ax25_destroy_socket() to delete
> ax25_cb in hlist in position (3) before calling ax25_kill_by_device().
> Finally, the decrements of refcounts in ax25_kill_by_device() will not
> be executed, because no s->ax25_dev equals to ax25_dev in position (4).
> 
> This patch adds decrements of refcounts in ax25_release() and use
> lock_sock() to do synchronization. If refcounts decrease in ax25_release(),
> the decrements of refcounts in ax25_kill_by_device() will not be
> executed and vice versa.
> 
> Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
> Fixes: 87563a043cef ("ax25: fix reference count leaks of ax25_dev")
> Fixes: feef318c855a ("ax25: fix UAF bugs of net_device caused by rebinding operation")
> Reported-by: Thomas Osterried <thomas@osterried.de>
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes in V4:
>   - Add decrements of refcounts in ax25_release() instead of using any additional variables.

I'm happy that this is simpler.  I'm not super happy about the
if (sk->sk_wq) check.  That seems like a fragile side-effect condition
instead of something deliberate.  But I don't know networking so maybe
this is something which we can rely on.

When you sent the earlier patch then I asked if the devices in
ax25_kill_by_device() were always bound and if we could just use a local
variable instead of something tied to the ax25_dev struct.  I still
wonder about that.  In other words, could we just do this?

regards,
dan carpenter

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 6bd097180772..4af9d9a939c6 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -78,6 +78,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 	ax25_dev *ax25_dev;
 	ax25_cb *s;
 	struct sock *sk;
+	bool found = false;
 
 	if ((ax25_dev = ax25_dev_ax25dev(dev)) == NULL)
 		return;
@@ -86,6 +87,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 again:
 	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
+			found = true;
 			sk = s->sk;
 			if (!sk) {
 				spin_unlock_bh(&ax25_list_lock);
@@ -115,6 +117,11 @@ static void ax25_kill_by_device(struct net_device *dev)
 		}
 	}
 	spin_unlock_bh(&ax25_list_lock);
+
+	if (!found) {
+		dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
+		ax25_dev_put(ax25_dev);
+	}
 }
 
 /*

