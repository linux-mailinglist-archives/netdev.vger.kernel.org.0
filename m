Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEDE5E9FD9
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 12:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbiIZKaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 06:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbiIZK3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 06:29:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFC039B9E;
        Mon, 26 Sep 2022 03:19:16 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28Q8k5tt030467;
        Mon, 26 Sep 2022 10:18:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=CxU2AnEsYLXVnDv+qL/aH/xo+fOZf4+Hc2Gs3NPeYK4=;
 b=v7FlCDv4ISMUL/3lkmc4jwb6uHrt9nw/GYITd6H/oZJVXIilM96nf9sC7vip9Jb1WZ6g
 szjeehZ6GWLcKqpHCsqnnjXzoYU0gUCasKeLCu+pLMYtwpb2Lngd+Vai8ayCjr5To99Z
 //QR51Rwju7HyDCJ7XjeKof/kuNL2A4A9oYnNCu1Beoikm9sSovoZAM7G5US8lBqVX4o
 zG094WXcLffxlV3iIncrXepfdEe0yo0k9RwhGOC2A42EwpXrrdxSE3QFm+3rItQSUzfh
 OBKgXJ2x3Sq/ukLJ9jc6kiR3DyyDvwiPGQyyK9ONk9z6QzcQBRKhrN5dbaqBWsGOnhTy Ig== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssubb65d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 10:18:45 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28Q96VaF002639;
        Mon, 26 Sep 2022 10:18:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprt338v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 10:18:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qu4Ju++H4EUXPpSGcXSKjteCF/m6/c3uqdj7BHsBISdVAAXg/uB7s3sGWuCUfUJaIGvNWHIeADaMiqRdBCOP5lyia7EjuPww84SddBHbVMLx07a1Cp+vY3bPOgyww5pO+dYoRg6yPqvjWD6LkGuil4NHPK5jnlV35/c8CeufvawGlXFS7rSPV3zQqQUDOiwqWL/NqQ37UjGusb1bzK5kG0GDqgMU/7rsyv4M2p64x4/swxu1IZoDrRy0yY9aMB/+KdJjIoyVNCSNMrwsncORgzxhmuRTl9ljL1ap/VUyoV3WOHY3SYsW9W+mxVAjhiUutbW9EjEPJfj7LKwG70840g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxU2AnEsYLXVnDv+qL/aH/xo+fOZf4+Hc2Gs3NPeYK4=;
 b=BDLxGQmIod4xJX96B5v431bR18tcKV1KY9w0D1nZsPfWtcmZvhxWo+kxBlUPTmuXU3dlzH/Isi9vYmuyNVDmQl7GoLQRA2Yui6jM15foENxNC7HHp42lRH2tRtvXVS7iRDM+/hLCpb+uWUVBbuQSkrINRtO2At0OgNCn8HG1mJyUUlveDb5JAxatv4HT1gDCs0tt4kHJsJnYzf1v00M0/yb7UMkkdTCQXsQ66H/QHwbQSvXHa5ZfIe4lHTVtCexUw26uFvfFUh39I7+gcEieY407IpGB9VMAC0SU5iDjYoo5srDeVyAQoXjLmoH8krQAbMUTQJUSv9yTzHnShsSbTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxU2AnEsYLXVnDv+qL/aH/xo+fOZf4+Hc2Gs3NPeYK4=;
 b=SzBbPeoVrsNI3qAhC7llYPP4cx5c9wDVgfOjGKwZdoS2FNlf9KyYm4IGh2j6roRf6c9YGvQVijqfa0/dZ1BhGqoh75fWZzCHFEOU09Qu52GMSb8/yxNU2iOyGKzgdg/2yT10agZULB1D7OXVAy/crlqwegs64bcp6XZWQchLL9U=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB5794.namprd10.prod.outlook.com
 (2603:10b6:510:f4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 10:18:41 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 10:18:41 +0000
Date:   Mon, 26 Sep 2022 13:18:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     syzbot <syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Subject: Re: [syzbot] WARNING in u32_change
Message-ID: <YzF8cdiKQKG9l73k@kadam>
References: <000000000000a96c0b05e97f0444@google.com>
 <CAM0EoMnJ=STtk5BnZ9oJtnkXY2Q+Px2cKa4gowFRGpp40UNKww@mail.gmail.com>
 <CAM0EoMm9uBQQepMb5bda1vR-Okw-tPp2nnf6TvfA0FzPu_D_2A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMm9uBQQepMb5bda1vR-Okw-tPp2nnf6TvfA0FzPu_D_2A@mail.gmail.com>
X-ClientProxiedBy: JNAP275CA0015.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::20)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|PH0PR10MB5794:EE_
X-MS-Office365-Filtering-Correlation-Id: b5241d76-a948-405b-84f0-08da9fa87c49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9UkdO3/r01YXAA30TcGUip7bw8GTqpWvOK9oE9THuK+BnSwGw9T0RLWQMV5F5+vwJgMueguLkfzSCUW3v4T9hbLEmhgUJc22wwh/tZcmJgqumNLNZT4W243UA+IRvVBbnnfGmagytqufL74DrVlTaNfDhfyegExuOVVdwaTs7gAoIt0bIFCBxTpinQyJLswY85+HQeDk1lBj6z+6UXYCZQHBwiroEXA4KI5+MCloXsyX60sIjGB/mmgnh4HIw10TG1twCDHNlvTRPlnXKLd5dzj6bBFTdYIIISp/X5PHdj/6bmfTCaqdd+kmJiTwJaOAyA1JfoybLJA3nyuQnVSoiODznDKhUVjkAmpwkBNHnRRbyTSjEiQs/8PgCXwg10R7bteGoV+RWThpW2Ed+gEc2Wbogg1eYSLJOLY1ui8K/uTHPJMi0IUvVFa3uqZv3SPvhIslots5ZNo0arVkB3nhgSna+bAjS9xLgfA6A7DnsDdZVWTcxTPFRM2hUGcpQonWxmRHpJIO+yRy7MpUfO8fGLelaxqspiuaRVtx+8FVGGC6kCs2e5Cw/aHuPMj7VORMWHQDNDoqCz9j/1AbqaBr4BdYfDJVVw+fFgrZupRZxFFxxUwXETnqY9RUBfAHX4Bpqh8Q4b8j+azIztv8VBYUhKbHJM++GYTRlW0Q1cVLdSlCp/deJnLtl7w88+oNQO3QvQYgx8hC+vkhrAQsmBk8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199015)(6916009)(316002)(6486002)(478600001)(83380400001)(66476007)(66946007)(66556008)(8676002)(4326008)(41300700001)(6666004)(6506007)(5660300002)(9686003)(53546011)(44832011)(7416002)(6512007)(26005)(2906002)(8936002)(186003)(38100700002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V8SvV0DxzuWQ/Qux3/Hks0AsVpv2Wew64nqtJy6aYe2qkFZt1YiLFViLuUyg?=
 =?us-ascii?Q?AqdaRKWvNRBrR+jqiUtrRb09WpYB5xAMHEN8ApjZFKqQYgKO5h1EsBLwyUqN?=
 =?us-ascii?Q?Fo/A1muxTzgXAAVlH/J0HWCmm+ramUcSE7gO6osAzQr/6RV/vs7W9ZZd4+og?=
 =?us-ascii?Q?pr2chYIECGcOX9cVa18ycnQ0KS04hz73gO8qjKViN1w+iWlwBTxCFbEDDqNj?=
 =?us-ascii?Q?e2Xk4YpbUk+FCjQ1ITvyEl4xar8AZOq2kfqDSy3Q5LdF7y/XF6XhKDq3/9e1?=
 =?us-ascii?Q?8GkFdIe2dNaRRclBDWHkIOzGU0ggJlBIpmZpjgoY+jmL+q0aoGB+hv44x0tJ?=
 =?us-ascii?Q?hvWa6vsoX6ZyW1FusV11jlMKAv5u8VVvyuKFyOL/EFYXbuSGdNcmolaBv+tE?=
 =?us-ascii?Q?zkCOqMSkOPVh1GBMifPiKOVKeBwboXO2Pktyo2oozCXLtlhnImQ3mPSQNVsD?=
 =?us-ascii?Q?CrwKtDwSLg3+Tnn7xzyGZMaxJvJN19XvjzCmX2JrpCTn8g4tOU8ul6QmzURe?=
 =?us-ascii?Q?oBrODAj6DjKU6J5IorNyYqplRGfWHXX4an8H39S4T8agCQazGL+W3OvY67ez?=
 =?us-ascii?Q?/cosweuhE+HN5BRj5frwNIjkW6/QA7vshnpOD3+ffL5C7JO3VWcNsz5SbQZh?=
 =?us-ascii?Q?GKctPVsF8IthBlDB8dfmRnTzeCTxIsP49gzWIFcAv982nKA1e/EXz01LGae5?=
 =?us-ascii?Q?BJb/vDZwpUrCTmA1PJukqjKhM4FmpK66m+BPeyVOboxCxTxvqzY1/zFfuJ+9?=
 =?us-ascii?Q?wLifuiqvn8SQdD0w00zFHL4nb7dxq8HNQfPmNz0e6BODnXt5dyk/0EdhwRQs?=
 =?us-ascii?Q?nEvRrc/xsM98j/X5y+azXWOtXB0jAaKlQ+SIkjVpFhhvyb7Jd8wvBOXGKSzF?=
 =?us-ascii?Q?qRs+/YQ/40is4olLz1DB5yDrISt013Cb9G/Vixt0IbbBQQm5V3XKp+GuvbJu?=
 =?us-ascii?Q?bQJQqVPKg3p3S0xIokc/8ZYHtmcTLvx47kT6xe5QAikQ1dcmWzDgjo8RuW7p?=
 =?us-ascii?Q?/aDcr7U4wfgAH4rk7lt4zB04KWlJtbmuDw51p2S+L2ksbRIZqBcC+tIShXG3?=
 =?us-ascii?Q?IckW1flJmvNxojsaH9V9uHPx26QlMQXb/EnS8W7BRVzer8LzGN7zJjdjDw00?=
 =?us-ascii?Q?owFpFf9fermsjuvvoVNI6hJ3Xhu4Hlx4EovwJG4G6795+/KCAqibBXWU/cnN?=
 =?us-ascii?Q?j1kDWweTfmYZqWDytayQSKgeJMJTzFQ2tsofEEuYvis2g7HNGebn4ynGHLkd?=
 =?us-ascii?Q?8hHbg3aHPAchZ+pBmpWpAwYSS5EKrkV8sBC82kPEgNuvbAMsr4AyKqCiv3lu?=
 =?us-ascii?Q?cZoYAIgNwtXIiDexrrOkh8ZzhYBRNux+yVDAbHr/Ec60O9GfWa6UyhvyX4rT?=
 =?us-ascii?Q?Uv0wNUtwC/6nYBQrFuXUkdGd8PZ62UiG16oLi9X0JHpBGYQEoDxLTmfSD0Hb?=
 =?us-ascii?Q?bFVamIGuVRhG9PDWqK91tad7NkD4IkSWTHYZwvsGWYqzOFCasC5rkZDMHJwf?=
 =?us-ascii?Q?DgkHohjaBm/VTNzq30oY1ipujwpDclihIjyDZdYIaCDCZfqqfpcqmLDp74s4?=
 =?us-ascii?Q?c5tLJHrtAiEjwtXQMcrC3EpBuGeGmuuRWJ5xJWOg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5241d76-a948-405b-84f0-08da9fa87c49
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 10:18:41.7517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2s1q2M2mCKM3aqyHAMH6HAM7dxWoIYkf7nKq1EO9HYlEp8haBpDZ8RoaGRc0I5ns5Fz/dmLgToz9KMo77wJPDtRM0pm+ABPmXFLgon7NKZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_08,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260065
X-Proofpoint-GUID: xk1oJwikq05gZxPzuAxQ1BfSftH7NBlE
X-Proofpoint-ORIG-GUID: xk1oJwikq05gZxPzuAxQ1BfSftH7NBlE
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 12:14:44PM -0400, Jamal Hadi Salim wrote:
> On Sun, Sep 25, 2022 at 11:38 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >
> > Is there a way to tell the boat "looking into it?"
> 
> 
> I guess I have to swim across to it to get the message;->
> 
> I couldnt see the warning message  but it is obvious by inspection that
> the memcpy is broken. We should add more test coverage.
> This should fix it. Will send a formal patch later:
> 
> diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> index 4d27300c2..591cbbf27 100644
> --- a/net/sched/cls_u32.c
> +++ b/net/sched/cls_u32.c
> @@ -1019,7 +1019,7 @@ static int u32_change(struct net *net, struct
> sk_buff *in_skb,
>         }
> 
>         s = nla_data(tb[TCA_U32_SEL]);
> -       sel_size = struct_size(s, keys, s->nkeys);
> +       sel_size = struct_size(s, keys, s->nkeys) + sizeof(n->sel);

Smatch will soon start complaining about these.  Can we instead do:

	sel_size = size_add(struct_size(s, keys, s->nkeys), sizeof(n->sel));

Probably eventually Smatch will be able to detect some times when
struct_size() is used for readability and not for safety so maybe it
won't warn...

regards,
dan carpenter
