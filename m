Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B80D426559
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 09:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhJHHqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 03:46:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65288 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229788AbhJHHqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 03:46:48 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19876drX029271;
        Fri, 8 Oct 2021 07:44:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=PtLGmLKspHykvIpUO6yEcw1yUFUZ22zA4RS3cVbkroI=;
 b=MwDiTTABOLQXbj61NZOx1ZMJAJ2nxuIByTTk5jvHgx946SqT5a4Qt/0W0T4/uPPiXkp3
 tPiCA6kGmo84O87/kl5qTUU1IHIy4TZzgwycGnmeoAFpo8xfe2577y5GLpttM+27Qknk
 AyOr2tH3OXEHd0W+meeHR7Fiw+9Zug0IkrT5rzf735+lO5Ocqrmc9MRAL4emQbNo3/dO
 jQ3hiICupojhEDI3Zt8YMDdqLKZukbkIDy6etRQuiWnOV0cAJRm6zvUZhynqMqcPSicv
 rvcwCoGaiCjmPr3AdbwmH8cwZ8dldLJ9sJL3HaBU9MTdOcnceIKQla+mt7SAbqBBy0G/ sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bhwfdq8b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 07:44:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1987asOq069599;
        Fri, 8 Oct 2021 07:44:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3020.oracle.com with ESMTP id 3bf16y2k9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 07:44:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOX+av9/rw3qrNQvARhwCTdIyTv+ml8EvRmd1Jth7WPo4SPAGRvtxEwcuA57ZiUcvLlrY30ZLcUkbb2ZY6FiqAHzuMJiSHCnQgr1UDz3skQnt3aMT+MGHyzEtqlmxFSeDvjFgbbixw8VpMA7soIkBN2bv8IIykw5VF/RJh1+8ENfW/72zWCoBjk9ZyqUo2qYhNtv0F1M82d4rCXLgmNoDhbpWNZzgm5vXagyTDDb/S13wOBO/SiOY6JbVOPr1mcvZ31xFVGq2xYkpllz+oWi3Js0ltTws5wSKKRmVKQ8KfeXoMlXAQARGsYrkOKUd5uuu9kMOVp2nb41Z46PnXXMyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtLGmLKspHykvIpUO6yEcw1yUFUZ22zA4RS3cVbkroI=;
 b=iOtGxHfR5LubEs6QoEuT70R4KTsXfcIn2yKbqPg3YuW1QqLnOvZEiG7SjwO+AmxLrB65gAH9rUhZXBXdOCGdxIUnGqWTG+Y2L7gzfunlp/967BNFc2i4YAm1/L+5QpcW346BnpsFGAUsf/s7DsU9j3Jemiuqxz7RXe9gN3mOYICpj+nmj9JynJIarePkyxc5OYGino4CpkWkW98nzoMzp8ZdHXSIresO81vekakP2uPts2T5MOvZAhepGGjWxVP5hKQ3ClpltMjrtLuxMbVSzvrBVSbCqDClifrlgPpKgi8naKFDDQOyBCAG/oV7tQYB53jaPcHkUQTOL8BNe116+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtLGmLKspHykvIpUO6yEcw1yUFUZ22zA4RS3cVbkroI=;
 b=xQ9l79DDTK+qwOX6xUWX+sYMaCuIL6vCfB3hW3MZC/85v5teNMnY6xq1aSohdqi/xNIHDE7VjbqpUJINPWa0IQXo1SPCh3F6dox3XNBCOvbjRtVBVkufK8rF1Yq7dzbDUpsc9+iEGnBeYqsPjpXnf4j4vg00W+UScywC6XZkmJE=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1904.namprd10.prod.outlook.com
 (2603:10b6:300:10a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 07:44:20 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4566.025; Fri, 8 Oct 2021
 07:44:20 +0000
Date:   Fri, 8 Oct 2021 10:43:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] carl9170: Fix error return -EAGAIN if not started
Message-ID: <20211008074359.GF2048@kadam>
References: <20211008001558.32416-1-colin.king@canonical.com>
 <20211008055854.GE2048@kadam>
 <382b719f-f14e-2963-284d-c0b38dedc4ae@canonical.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <382b719f-f14e-2963-284d-c0b38dedc4ae@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0003.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::8)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0003.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19 via Frontend Transport; Fri, 8 Oct 2021 07:44:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0bec2c8-6bcf-4787-353d-08d98a2f6ff3
X-MS-TrafficTypeDiagnostic: MWHPR10MB1904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB190409EDA1B6C4FFCBFC53D78EB29@MWHPR10MB1904.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tDSQdS2kuvtERTU83R3IvW0Hrbb8R72MUYnurnjw1FxV++qTPYJN6sO/5RQRa2NQqbPZYk9WJ8SxcSjpV2VfGYfp/KwCRqOVcI8pCGwmptljDNafmaJ3IXGUZ5Fh2sGN4ZIzJQgeAlr79CrAKhY1E6CI8NWrzPq8u3D28G5kmEWXxv2g7Hkb1+1SdSqIQm6npC4Vbad84msC9pguWryv5RN94p8RhsmlhVzlQO7oTw90CwwFrS3zOU0r6mfLLr2j4SaevPg1aYeHoA+9q6Jdu6XQpaDfYb2jt29BOBQhj/0HD0B0Zaf0h9A8RSKMwE1DDVCOSMY+vKf4i4AAnXNjdzA0k54GQOWminXQCWxNKLR0BcOMwxah/BfvfVxT5PGnAkW/jT/1wi2b6OOwkjnyAEhf3b8tIEkvHQx1zriDxTjSYqXJAGvVLGzZUhulhcXKt53tIugJdFV6CdxiQxTAX3ehnx1t4mpBN2jW6ZWzj/h3c8TAcaUSjVGE+4rdixqfKBuKlxDC69ObvLpLlzE6D3yv12aZdPPpV2iOJvUAKDk8q02siNnJ3nH5zhLwS/oAn7AWHcflRvTA6Md7R0Ps6sIV5sTSxBBUMG6FJFPskJPZw4ciVebQuSk4RPnEqGEuVEKT3SIR3sySTziuZbujVkqi3+g73ihIYjwUkCBOEhdDroR2NFo/NRqaIn6qAHdfTFy2HdVIzlG+dzKCvdnRoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(9576002)(6666004)(1076003)(6496006)(55016002)(9686003)(7416002)(508600001)(38350700002)(2906002)(5660300002)(4326008)(8936002)(6916009)(8676002)(83380400001)(38100700002)(186003)(86362001)(33656002)(956004)(44832011)(26005)(53546011)(66556008)(66946007)(66476007)(33716001)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iQxTITsmRdYtYdNJl6BF0kNu/4LditLrTDyWrgwiLP6lNMsqGsGWVL5+GhPO?=
 =?us-ascii?Q?M1pxifwM8ybcrmd9Q6M277JKGhyxQFXjPGHAn4yXLZTnNC2mGzYKyYYYNeNB?=
 =?us-ascii?Q?EH/e3aw+MWYpTydAUwvbVuyRXcox+aTfCbotsYBFNe5S0omcd4hl6P3imlXL?=
 =?us-ascii?Q?wTtQoPd1f/aZWpqEL/+bkA4WZQHzhDal+QnNQJVS7sohWKByRW/Hyn5062cf?=
 =?us-ascii?Q?HhQ92OSWosA7nlFeoaiMel0ndgRaIzjcfTH5cB370o+MCf0YaAfGPiPsRz0C?=
 =?us-ascii?Q?Xq/ANamtav+sn7K90nBAXQP5ryizXlmshY/p5JVwD3BN5zv04d3EjnOYeanb?=
 =?us-ascii?Q?AMwROiaqjjGEaluLSw7unH1SLG9QI9JIDL+mHDGv8etHMv1S241C9FwKW10c?=
 =?us-ascii?Q?wsHr9+KVF//0k3hj5Z+9PZIoojZdlAEv5Hb9ZV2kULzBa7YwxzE0lqx0yPL2?=
 =?us-ascii?Q?G8MSSl0Jti5YWKOHbqNXogZNe7Kn+pPMKSwsrWt2ZBYdFiaIS78OpyiJvOAw?=
 =?us-ascii?Q?B53cfAWdgTUOuUk1o4t588xIRy+VCFAmne1Y64O/S06hwGKHzxKcdrkfGm3x?=
 =?us-ascii?Q?rrMHT7h8QwK9SXjHttAwkW+eZblGYDJ4cmV1J2wpClbtDXVUZhVM+F6qKwU0?=
 =?us-ascii?Q?SeI/NdlWJKP9idK6ed1D/IQDhm/z8WAsLQ0r8YBgP9O85UX1/7UIR0jm99HD?=
 =?us-ascii?Q?kIzibSRrGjzL1+NmC3BmaQ6R9Gyq1TwWEo+DS8At6uatRwP7CjC7ln3MrGE4?=
 =?us-ascii?Q?uzFqwxTZKt/7RUER8H42jxHR99ouOip+3k4Dp2Y77+6Pmza2PyMkogiuLVkI?=
 =?us-ascii?Q?BjlqLEM0GaA3LbZFi5btvxtl2aIG+zHkCHLvddZYxDYVT/1k3wXXaGs7NkGG?=
 =?us-ascii?Q?+yoom/IjeaYyAV7OSJR0xwheXjj1yQ0ZsiS3mS2LgduwNV24OyJQnQFGmjTk?=
 =?us-ascii?Q?6obKH+WCI/WadiJvjKTpbRQPpkRV+EUS8Q5k6Jpv8t6B5prsx8vT5V+nLZIs?=
 =?us-ascii?Q?bU1FMscOywybsXUWTPuHSCU6qX+4lbEHGUNVeXp4jDem4tK2Tij7Jmymzj+H?=
 =?us-ascii?Q?A6BCqzesd+e/dYIcCB1D9aDyJEw0afzl+K7gfzl3A+m7oi8GE9mPYDKlSZ7V?=
 =?us-ascii?Q?1ZmL80vrYtBLinpwCDgLEAolAmb3ropd15ctf6OrGiPndtJ1tq/dljrf9+Ro?=
 =?us-ascii?Q?++HPGwg7KYraCQnXwMKSfMNd58jUnnE07JDtA0396vCnzv/F0sRsOnQwwWQW?=
 =?us-ascii?Q?pCvo8I9ymqqPBP7bpuG2Zqne1CouL+PyPTuR7deYHy9eGwAMLj1RH41YwDfD?=
 =?us-ascii?Q?EXIX5/kMOpvKUPAil/ty69Za?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0bec2c8-6bcf-4787-353d-08d98a2f6ff3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 07:44:19.9989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F0vcYZWK+NYEBSFhqZC0zI/g/zuccIvZzjkFBzHNkE9RJyV/SC2mzkJoBGgwO6IBnwG7lELemH93XyelE4BNUjq4XDk/rWpgmCdsaWrrvbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1904
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10130 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080045
X-Proofpoint-ORIG-GUID: 96AiINMVGEF91KhIsbVI6cCQHdEfQL5a
X-Proofpoint-GUID: 96AiINMVGEF91KhIsbVI6cCQHdEfQL5a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 08:31:29AM +0100, Colin Ian King wrote:
> On 08/10/2021 06:58, Dan Carpenter wrote:
> > On Fri, Oct 08, 2021 at 01:15:58AM +0100, Colin King wrote:
> > > From: Colin Ian King <colin.king@canonical.com>
> > > 
> > > There is an error return path where the error return is being
> > > assigned to err rather than count and the error exit path does
> > > not return -EAGAIN as expected. Fix this by setting the error
> > > return to variable count as this is the value that is returned
> > > at the end of the function.
> > > 
> > > Addresses-Coverity: ("Unused value")
> > > Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
> > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > ---
> > >   drivers/net/wireless/ath/carl9170/debug.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
> > > index bb40889d7c72..f163c6bdac8f 100644
> > > --- a/drivers/net/wireless/ath/carl9170/debug.c
> > > +++ b/drivers/net/wireless/ath/carl9170/debug.c
> > > @@ -628,7 +628,7 @@ static ssize_t carl9170_debugfs_bug_write(struct ar9170 *ar, const char *buf,
> > >   	case 'R':
> > >   		if (!IS_STARTED(ar)) {
> > > -			err = -EAGAIN;
> > > +			count = -EAGAIN;
> > >   			goto out;
> > 
> > This is ugly.  The bug wouldn't have happened with a direct return, it's
> > only the goto out which causes it.  Better to replace all the error
> > paths with direct returns.  There are two other direct returns so it's
> > not like a new thing...
> 
> Yep, I agree it was ugly, I was trying to keep to the coding style and
> reduce the patch delta size. I can do a V2 if the maintainers deem it's a
> cleaner solution.
> 
> > 
> > Goto out on the success path is fine here, though.
> 
> Yep. I believe that a goto to one exit return point (may possibly?) make the
> code smaller rather than a sprinkling of returns in a function, so I'm never
> sure if this is a win or not with these kind of cases.
> 

My default position is to hate goto out labels, but today I'm thinking
maybe they kind of make sense for read/write "return count;" functions...

This is debugfs code and debugfs code is always the worst code in any
driver...

The other style anti-patten here is to have two variables which store
error codes.  Maybe it would be better to do something like below.  Or
your patch is also find...  Let's just go with that.  It's fine.

regards,
dan carpenter

diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index bb40889d7c72..8ccd0d3bea4c 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -616,7 +616,7 @@ DEBUGFS_DECLARE_RW_FILE(hw_ioread32, CARL9170_DEBUG_RING_SIZE * 40);
 static ssize_t carl9170_debugfs_bug_write(struct ar9170 *ar, const char *buf,
 					  size_t count)
 {
-	int err;
+	int err = 0;
 
 	if (count < 1)
 		return -EINVAL;
@@ -638,7 +638,7 @@ static ssize_t carl9170_debugfs_bug_write(struct ar9170 *ar, const char *buf,
 	case 'M':
 		err = carl9170_mac_reset(ar);
 		if (err < 0)
-			count = err;
+			goto out;
 
 		goto out;
 
@@ -646,7 +646,7 @@ static ssize_t carl9170_debugfs_bug_write(struct ar9170 *ar, const char *buf,
 		err = carl9170_set_channel(ar, ar->hw->conf.chandef.chan,
 			cfg80211_get_chandef_type(&ar->hw->conf.chandef));
 		if (err < 0)
-			count = err;
+			goto out;
 
 		goto out;
 
@@ -657,6 +657,8 @@ static ssize_t carl9170_debugfs_bug_write(struct ar9170 *ar, const char *buf,
 	carl9170_restart(ar, CARL9170_RR_USER_REQUEST);
 
 out:
+	if (err < 0)
+		return err;
 	return count;
 }
 

