Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF1A3ECF31
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 09:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhHPHQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 03:16:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54448 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233899AbhHPHQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 03:16:21 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17G7BprZ018515;
        Mon, 16 Aug 2021 07:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=G19JHkDUNFtEm3udHiVlL6OEVCXuD4KqRGzyuMjkmhA=;
 b=ONs+q30IFB19mGxc7f+Yb/Vx7LlXxeJgO0X/WnGPMwARw3D/qm6JbVqt+BxsURRl85Gv
 6gPQQyZr65iXX+57+7Hkocdot4zQVPcq/CWmSe5HbFoymBstZ9ECAxtCHUtFmUvqFgs8
 ui8jEbqeOHr4eScto/hS/SWb7xSTCDKEIMxZeRXPLQkT6jzhYdyKxapFsNmmipiiJSGD
 K/4iZJOx9nUJjvzr20bMDhkNQ1JN09bhBKTBeUE+JVZeJ1GIhJX/u9Uc0exDRYxT6Vax
 fALn9XWpJoeUydKEzQahlXa5aODlE0zRLJ1/R1ne7DTRJoY5ETq+wgXuKOe6dAT3PJ4A Ew== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=G19JHkDUNFtEm3udHiVlL6OEVCXuD4KqRGzyuMjkmhA=;
 b=Wyuw+SEZ+Y2FuPP4VQymljj/vwKVy5sAoNjV56KHwhO7mzstikZN+szzvZRwnPA1MhEs
 Ll+G6anFashbOtaRuL1TR9gIvudCx6aJPRAqW4gL7tQbKOvdlP6BFFOR9AGQKGK8dk7i
 OZjwpT3HpPXxMhlts5pbxx3aFJqhVDvK4EWEcgW3mbnFZnh+TIYURkbf/JZZTAjcQeNL
 9qThmaLpvdTigl/aMDsIxjLq4WF/oqYEjG8kDPYpigDx2xEJ813yLs+qZHF3EFHu8Dst
 LrJ+YzQJacDhq8aBVpTS1KMxaJvtK0bz0MdjNawSbeJScozGU38nff+tfl35+lXm/qBD Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afdbd0kn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 07:13:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17G7Aoib117324;
        Mon, 16 Aug 2021 07:13:37 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by userp3030.oracle.com with ESMTP id 3ae2xwpnjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 07:13:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/i2LdSlkRUP8cSVbepN9BzIF50zRjdxUa2SZ2a3+23DGFZ6uM1usLeoLdFow28XxwADo4hwLaPmPb3OYaGbMZ0kJZvGastA462AGdt1j0nHHssQpj4dxjErRQspdpEU3be78YbWkco1yu/zHBj0ufQNUoh+qwLuVG/AzMmGoEviCZhjUt7wn16Dirqx/7TPFf/MGfgcSPuSjGPa8PaZZpBi04AWqSCCanEJqcBZIDe9XyOB5tGAmcOnMTw6arAuAw82ZRN/GPFcV4ZW/ey+VWns6S6SVJL1X1tGwCdV5J/lYwUn/kUfh6J0fRGGYWo3Kl68UfgVSr//mstVaBAuIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G19JHkDUNFtEm3udHiVlL6OEVCXuD4KqRGzyuMjkmhA=;
 b=TMmtNkOSMJc0J3Q+ZIqlBa5YHSunl8PsspgXII94lkrJErlunMg+9UarTroSERjphrB4hNpSUgx/ViMQode2Ttj1R7ccTIxwRkIwOUxo1rQdvJiS6Q4Z7GTQthjYfHE6pNKbFdbBUVRhU8ZR+QKtbc/vMjebO9xOX0SN+4sT/tesDmpPx3ZQdWG/Kpc1vZ83gn3JD+e1RtWiRGU3APZR2i0D4bvpBneLjlE4N0G+mXzJ62tZ93Dh5hRYTVzuiYlmKwol5On21OeZK80kOFP5nX7bqd2QWjuoo2tiRv7ms6DYdGRR5hZFTTY+6VSKw1Kth7+1vw0hO+1/xSdvWRrQvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G19JHkDUNFtEm3udHiVlL6OEVCXuD4KqRGzyuMjkmhA=;
 b=sSsTGgZfQtRxTb+CnmGLOttLoBzjDXQUdwcZkDkmDwl4MFWqandRI1Ee3eAjFdS/yzT7If6aUg5v0ea9fDX8fIuX1aiiHmQnZM0LjQbT4cAakbNXIdxH6lmxgouvM/9knxkYIqf4+Qa4MaTXGnDCs1Cld/OBwD9cAd7yhDPZ/Bk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1904.namprd10.prod.outlook.com
 (2603:10b6:300:10a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 07:13:34 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 07:13:34 +0000
Date:   Mon, 16 Aug 2021 10:13:16 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Kevin Dawson <hal@kd.net.au>, ajk@comnets.uni-bremen.de,
        davem@davemloft.net, kuba@kernel.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: 6pack: fix slab-out-of-bounds in decode_data
Message-ID: <20210816071316.GF1931@kadam>
References: <20210813112855.11170-1-paskripkin@gmail.com>
 <20210813145834.GC1931@kadam>
 <20210814002345.GA19994@auricle.kd>
 <1021b8cb-e763-255f-1df9-753ed2934b69@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1021b8cb-e763-255f-1df9-753ed2934b69@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0020.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::32)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (62.8.83.99) by JN2P275CA0020.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Mon, 16 Aug 2021 07:13:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 898c3e79-e698-4e0a-8b15-08d960855c62
X-MS-TrafficTypeDiagnostic: MWHPR10MB1904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1904D51331BA261B133988E88EFD9@MWHPR10MB1904.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DNSVa2PNUgMe7BkekPlxxpY0AI2hl4p63PCCLODsCVjxJS9G+DIVH5D/Hpxrss8Itz8Ik/uVKzPp0gzcF9V5tXQkzaXFskZ/RAmaw+xVOSqABM7m/S5+KUjlCpHqXfKVPj9OSCHXZKi9v5rpLg9KOKoQoee1UlmW242t11JphSUHF8qwssyNbwSjiAP0LGiJndMG5CpKSwxfpotgFixynly8Urv2fkcBzr0OpqP4ho/SRM0XvaPzFey5hRvtUa/uSdzLv1HkAxEtH2r+8fjtK0/o4xz4vHLicyEZUMrP8DERgVMsHgNNbP6kHAxIbRx2wqtCeZM5Yu4kyqXzdF3XdJzkqxjTE2mPxl6+FvG06BkqQr3SMyqCQODFkM0JuAgtzrU5nSK7+bHYUhJVj24LTpA0feCRb2m5m+cq7lEROkBRQ/yMFV2eBIoBGjFoWQtzBED0Sk8OItCFzmzFGg76xqQukZdWPnA0U6J3PJIaUZLFHypnR46AUGLRpRBemxWzgbfbcZmqwpHZ4r/LMSlRRakPkAbqJBx/w6w+WrSAcmFWde99d/hG+0HaHqzvYRAEHJh/kPl6e6DxUQtoTVAg2ShuTaEcOqpxz5TrHG4SHPjySQc5Qo0bnta3oNLuDAphQ2zRTFArKJ9qZ+I8GB0Y5TJCmQHIxZLXEJU0kMKi+L8nxKEkTc8Q2+YyTcCh/JEgUt2P/LJAOiKdzZ72GSleXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(396003)(346002)(53546011)(33656002)(38350700002)(4326008)(1076003)(6666004)(8936002)(8676002)(66946007)(38100700002)(316002)(9576002)(86362001)(83380400001)(956004)(44832011)(52116002)(186003)(6916009)(2906002)(26005)(66556008)(66476007)(5660300002)(478600001)(33716001)(55016002)(9686003)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4vnn9fDrs4kuoQEk4gyc3yYFjY6N9+mmqGc32PS8y0jjk3hMjK6vSauOS1eM?=
 =?us-ascii?Q?Mt8VkzGrufKQXH01OAXSToFtRREGIzt4h0kO0GGMpMOix7+ZAQrwks3qaCO+?=
 =?us-ascii?Q?HmO0NhHGg45HMVwFcqTocZuGVfIQoO2qgm0Kl4GQ6AVValdvPeFZcWCFtWa5?=
 =?us-ascii?Q?Dhe8idMnkoUIKcSMkDFrXYDnkDCSZAAniU6gei/YMghb1Op1lIfd4Bfviuhc?=
 =?us-ascii?Q?Wz1FPxTU91y1IgvAKew8G6gOZ6tY2Otyf7pW98wAWLkTDUr9eFWzSjOA1dZC?=
 =?us-ascii?Q?S/h7xFTFtrvpEE06jAB0awC56zMBXmlhVoXtUOBd9iNLj2V8qfThpUNS3IhT?=
 =?us-ascii?Q?HPwQMOzW6+lebHOmQz6Md4tlyX1qZ3LR7DmAx9BLzl3SBWu/BkmX7wwH8xIb?=
 =?us-ascii?Q?VA7aMyUimIDJFsuQWBc3gwDMK6eSAMQP6LuUbGDxtTUCIRq8pT/OKZD3gX8x?=
 =?us-ascii?Q?7iYvdt8sl9RAS1nzNIFpck7NeQ6zz/hwbWoi3rVPD2HaouNJKHR0Wi7MjqCT?=
 =?us-ascii?Q?dUwMr5UMWhXajAC08cZ9CXdQvI0le9pv0COQ1BBplnfAalsSUnhPWhch9aw8?=
 =?us-ascii?Q?/DKLD/pLJIjfyvzskJqovLLcyaNMmCN/buVKI3k8X2Fpp5YjYQLiFou21q55?=
 =?us-ascii?Q?1jin6y+VkOdpKVzJJ80p9agSy8rkmAlnhBC/aG6ETKwh12/KbGYbl6RCYIf9?=
 =?us-ascii?Q?dZR72wg9aoL7Xuy+BdGRHiZBdYVXx6kPwIWyGUcgEVOO+Q7wdFSrRR6m3crR?=
 =?us-ascii?Q?5F5orW8QIYHXYEg1KEXY/VwnsmiK3Lg+ctBocGL5cTlUnNCyCF+ux4asgO/G?=
 =?us-ascii?Q?nusiKeNMUUf4Rb7K6Crz+r/nnFG7lyG2z2yi03OEH37XgsiiNzgNUTclW16Q?=
 =?us-ascii?Q?souwGm/579GzNriMHPsW862sznuPvlqRT/8RmPbUW8rPEfCeV0sYxvMeN+AR?=
 =?us-ascii?Q?R9fLY/M8T+qd4Kb12CjHY5PLskLKyyW2hCg1TRkrwys5Js2ZIPj+qSmdVwcG?=
 =?us-ascii?Q?ukkVvJInq0SKSiBp8O6HYupeH2KNhimdT25APBMrKyl1QLtA+GM2LcyYK4vG?=
 =?us-ascii?Q?bYgfubvMpYskTXHhd6Jm3dtvca1KSrtAk9KO8MOkNtP4hHOsjhOqpyZzdMlr?=
 =?us-ascii?Q?ShKw2IJqtQIVF5BU4tKYg8VBLMNkwf3+iefuHJgUtPdPgHuqq04y9lwLO+NU?=
 =?us-ascii?Q?+g6LICwTNLt5mvyOJBFz7EA0EWR+KEsvgqhLvzKCinUdc5OD3Vg/6cg4AbUO?=
 =?us-ascii?Q?maaf/vcZ4wOytvjC4JfwBWECC+K+fyArRH+1C/B0s41NT0DrrvgNY/+fTTzB?=
 =?us-ascii?Q?aHjkf5a722JiySfOxBS6ycle?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898c3e79-e698-4e0a-8b15-08d960855c62
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 07:13:34.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +XwBMDDhYAhyKFVLwzYGCKukRDxh26cfpLWeI0Pb38kGbg0IvUexW72qGQ41mEh5feEUeGWVyWVrnY4sdqMV0vjxLcksZOtJs78JKXyKmak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1904
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10077 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160046
X-Proofpoint-ORIG-GUID: I6DCTsxZTUVyzn_jdNPJONNti-29Hmqk
X-Proofpoint-GUID: I6DCTsxZTUVyzn_jdNPJONNti-29Hmqk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 05:17:44PM +0300, Pavel Skripkin wrote:
> On 8/14/21 3:23 AM, Kevin Dawson wrote:
> > On Fri, Aug 13, 2021 at 05:58:34PM +0300, Dan Carpenter wrote:
> > > On Fri, Aug 13, 2021 at 02:28:55PM +0300, Pavel Skripkin wrote:
> > > > Syzbot reported slab-out-of bounds write in decode_data().
> > > > The problem was in missing validation checks.
> > > > > Syzbot's reproducer generated malicious input, which caused
> > > > decode_data() to be called a lot in sixpack_decode(). Since
> > > > rx_count_cooked is only 400 bytes and noone reported before,
> > > > that 400 bytes is not enough, let's just check if input is malicious
> > > > and complain about buffer overrun.
> > > > > ...
> > > > > diff --git a/drivers/net/hamradio/6pack.c
> > > b/drivers/net/hamradio/6pack.c
> > > > index fcf3af76b6d7..f4ffc2a80ab7 100644
> > > > --- a/drivers/net/hamradio/6pack.c
> > > > +++ b/drivers/net/hamradio/6pack.c
> > > > @@ -827,6 +827,12 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
> > > >  		return;
> > > >  	}
> > > >  > +	if (sp->rx_count_cooked + 3 >= sizeof(sp->cooked_buf)) {
> > > 
> > > It should be + 2 instead of + 3.
> > > 
> > > We write three bytes.  idx, idx + 1, idx + 2.  Otherwise, good fix!
> > 
> > I would suggest that the statement be:
> > 
> > 	if (sp->rx_count_cooked + 3 > sizeof(sp->cooked_buf)) {
> > 
> > or even, because it's a buffer overrun test:
> > 
> > 	if (sp->rx_count_cooked > sizeof(sp->cooked_buf) - 3) {
> > 
> 
> Hmm, I think, it will be more straightforward for someone not aware about
> driver details.
> 
> @Dan, can I add your Reviewed-by tag to v3 and what do you think about
> Kevin's suggestion?
> 

I don't care.  Sure.  I'm also fine with leaving it as is.  I've been
using "idx + 2 >= sizeof()" enough recently that it has become an idiom
for me.  But that's probably a bias on my part.

I guess "idx + 3 > sizeof()" is probably the most readable.  Moving
the + 3 to the other side would prevent integer overflows but we're not
concerned about that here and no need to over engineer things if it
hurts readability.

regards,
dan carpenter

