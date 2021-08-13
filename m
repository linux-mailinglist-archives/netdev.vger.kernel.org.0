Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6953EB734
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 16:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241022AbhHMO73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 10:59:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3572 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241019AbhHMO72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 10:59:28 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DEtkuO010091;
        Fri, 13 Aug 2021 14:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=nIy5kOhV2tmCy63FhT/+hM0XM9wOm94PgL6RWcV/TAM=;
 b=eJ/YZw8Ad+v4CbUD8jyX1vTl/OT/tmyrHbLqNSI2RqsgXWNN+7XUDgUl1Gx9Ed6vEfx6
 sAWHWKu5urBBy4QgYeRsE8IAXHDX7EQN/fT6+0WcQuqiayQLXZKYHd7baMF9hd9HaPII
 EIXWQb2VPIFSPj49kxkid2+xX44iPj1VWm427/NHTYl0KhH5JIZhQ01RaJX3WC/O/M/K
 Y3v6Vh7mZuDCICKu3ok2TcNa9vF0FNBZhX6gR62Y2t1Msif+PywRFEXqoNlVZ5utpFYA
 4mR2dQduLY1DX+LsDMxRQ5a9iMtHQPvIPml4bMglKqte+oPrOB1mlLaaHo4S7YVswMQI 1A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=nIy5kOhV2tmCy63FhT/+hM0XM9wOm94PgL6RWcV/TAM=;
 b=bFKe5wHhkOOkbITLsUkL7YyMiWnBpxScOLhy7jy/mYisA7PuGcKdkVzJ9EMxMFjs9bzh
 rj6kZbEmWUZsVIqXqxCHOGO2KzAI199F5FtvNrR/ikDar5HRKru4B8tM+VpCwv/Mz4xq
 lp/GRaSFTZzkcXpl0H1/LvMGXHmecg+SEOzMresTIHp1NX4Doi/Co1xgyDsQP86CSqBl
 wwpYBlec5FnA5e+xLuMhC6FjMJVuzD1TlQmS5XVH+CWJ7j0X5kIDpyM6yNQ1Hyur0dxp
 epAlmTQ33+c1cpYpIjbF/9+JwTaoXlVCglknj96x3XPcYC35RB5JDCkm0mj4O7h4b+sl Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3adsja88kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 14:58:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DEuSim046155;
        Fri, 13 Aug 2021 14:58:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 3adrmd7u5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 14:58:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/EbVSSjAfHiJe6yLkx562gNYZ3wsIAPmuCYfNxM4FkehoGi2RfE03FDomcsZDDAcnFLiuidIUt79b0eDRtIqGfbN2fK91LlZLNMtbnIhOUfh33KXpa9xL2ds7W4C+KtsnDzHxTw+Os+kL0JeyFekK3LXq2alJ5s0DEVHn5Dr34ZuJjyt/DIdKU6uOWBigqrLViOXpDoJwgKroMuU6V9RslsNGqAt6sRnHanOWOD9AMOa5CjfUxI04hFQyLvrPQ6Pq5N1dWvT5zEVEiof1BaZxjop7bVr0nNpnuGSI1v5pSeruQIiZlwbdhCWTI+udQF9xz5vTb7EjIVvDMGhVCAAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIy5kOhV2tmCy63FhT/+hM0XM9wOm94PgL6RWcV/TAM=;
 b=W+muSROD/vRg54sTihfwPGvjL3BhUoUiWb366mNNiYA8Ny25uQP74u81TmSaBBYUgkHSEBJuJOET9wdW7Yju0eAot61YnOZxOHRGZ7CWNmIV8ZpIINNb2opFB9NtV/+m/MGX9GHodYhRub1UbWYlqIKUTOcoklcpqttESbMDrLoNFjIbLSo5Uw+WnDUVl6aqZZOQjZEuzZXikJpoHdM6/Tk5a8eoLCWsmJN2eBlyYH4U5osBRD6ffZwUnekpHKKhhHvBg4VELkj9gD9O4vU0GceFPSnqA964yAf94GRc5ESnExKKf1sMgHcccJcFZapbN13/yFju9+99VkECy4JR7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIy5kOhV2tmCy63FhT/+hM0XM9wOm94PgL6RWcV/TAM=;
 b=uov2IZwLyjUX2xo96tMeW3fXm8apfrlqa7Ua85ezEpZOw6js5xOA+S9AwSRIcvR7nOLsvDEk0d6CecHWAurvd6hWKaymWR/drNvmspkfuePPlWbQuVJrKVLA5cJ2vFXCQK1HjcSx7xBQZa7zNpw4qz4j9nXjFvMAv8MYXYwJHYg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1248.namprd10.prod.outlook.com
 (2603:10b6:301:8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Fri, 13 Aug
 2021 14:58:51 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 14:58:51 +0000
Date:   Fri, 13 Aug 2021 17:58:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: 6pack: fix slab-out-of-bounds in decode_data
Message-ID: <20210813145834.GC1931@kadam>
References: <20210813112855.11170-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813112855.11170-1-paskripkin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0007.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::19)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (62.8.83.99) by JN2P275CA0007.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Fri, 13 Aug 2021 14:58:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59fba5e9-b2a1-4e06-f5e3-08d95e6adc2e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1248:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1248C431B018B1AF2DC6A99B8EFA9@MWHPR10MB1248.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:136;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aIkOQgJnBXC/weDZ5wCpBNA6NcjqQ8MCPsqZyt7YobuOIKFAuGYyofctCOIod0dwg2kyhD1QIZ5lE78FkZM0fwaYLk9uaTiH0WKckzsmJuANo30Ehg2aRosGbV7vbDxyddEbKGdIMrtxV60QJGJEw4A9HXctQq8K1UGEOpnO+w/24fYXOlInJ6Ne0drG+1x73ZzNWB1Yc+tB5FiTQR9m0Jtxz5GTUx/A+Me/dRtFrIcPDg2mWumKspMTmXrZs6h9uupRRSfz68GcLYFFudW8LwBQox0lZOK/BWiqRWcdlyussGx/GMAHwp3WJahTmTDcE9kXfEXaGGMsw2ch8ejQAcgL3qAV28W4uS79TPkYzTYKwtG6WoKJk1aUlov/mGGuPAr6YV/xo5gTKaZV2ewR19BmxbGnJz/9PfeGpzEVL84KjkTCZTxIyR7Yo9hgfkoB6pspEGRW365ME23sBlZfBsTa8cMNaBYYjOWrvR7a6nFLCbDzMogLKRRlDRoGcY/Q115sn97EZ1xbLVh1Nc3lMDpeYHDs+ZXFTRcO6g6Zyyr8Sc1AEcDOzzEdRtXqQ2Q/vkb0ZEOujBwYGM9/gL0x1Sl56CQCVAXnXP7ign+1Um8Q0fjxsLnx78Vk3m5PE3eV57rxK/HesIdhyo9HkHAbcXLEvcW2vrM/wK+YIg2L0YJQ23MEfCzYJ9yLVxGSeKxsKIhOiTMiSexGc8KykIOlOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(366004)(396003)(346002)(44832011)(55016002)(6496006)(2906002)(9686003)(5660300002)(956004)(6916009)(1076003)(86362001)(316002)(33716001)(8676002)(26005)(4326008)(52116002)(6666004)(9576002)(66476007)(66556008)(66946007)(38350700002)(38100700002)(8936002)(186003)(33656002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wr5J+8PmVmdWoXuXiWzOsZyQ51o0bxgjE3DixuPKQchAhtH6auPbhYqqCd5p?=
 =?us-ascii?Q?dc6k80DbyuxWADKmQewP8tVR12Er93Jt4PFCktPze/3hJr4JaE3WxtGimyjQ?=
 =?us-ascii?Q?bUleyFhgAoU3MvBgXe0BjCv7maF94zMfYybOhIEoV5ae/WL+1YqErUGlYBFA?=
 =?us-ascii?Q?2LbQdcAziKyGFHvrday4ApQKwSOLxK3yEih1BSXOiYztvq6SFN75OX5DvJIP?=
 =?us-ascii?Q?ktK+ldp3cAuuyr1HlBNUfTQ6UeDTB0pKA3PGhL0p1b2KIexQPme8eEWeAyXw?=
 =?us-ascii?Q?F8poPLaaTR7HQy76R5gSkCBBO6LXbCeTdBtRRrJzj9L1XAYSbmUMAdqFyh9d?=
 =?us-ascii?Q?rhURrRFSPl61nRX80ODUoVG3DFwc4Y8YxRtn0ZaR6et/xyBsUvkXvaH49NLZ?=
 =?us-ascii?Q?b9kTJOROiyomLPSh2sP/hwWujVTXi6cpO+UVSm9OVwBnrx0pjsaMRpMxuFm4?=
 =?us-ascii?Q?yUFc2JVBOXfIQGgcu9pdyty9puMth71FHXjYyw7kgwgRI2n9UCa7BY7z63e7?=
 =?us-ascii?Q?EqDvQj6rhL1yrE+pevvYkyeepujM/MZ3gQTPNplI6nk2APZkiHJQsQGbGG8O?=
 =?us-ascii?Q?KML92mfJhK2GU6QqP5KFPUQjOU/8J0U67yAlmh2EjoI51+IrFBlsWyX+FzIu?=
 =?us-ascii?Q?8kL/WdPikTlDG23SWTOoSs62KZJ7qMmtIoWp+/ER6HyPsB6HPQI5brmKMJZ8?=
 =?us-ascii?Q?vtVaSASTsm9iBN9D/ID3RASpQi8pweAATBggRAEZUprNtO/blf+KWNngWBM5?=
 =?us-ascii?Q?4Y+osM0kVlelQEDFOfHuPfsRcqs/fQ5tdtaCIuLXhHKn+WhvP89mYDZ2BMrF?=
 =?us-ascii?Q?eitEQKWSDp90v3vW+YD2QSmjBY8OgYYQFXVtK0z/+PU19bu/d1nsSRxEGYIo?=
 =?us-ascii?Q?sYxzPIgMYdEbfX04GS3xAHGVCxOt2NYsF+kn493bM4fJrMuW4rS7dvrvbQG1?=
 =?us-ascii?Q?KAZn7e6F0pJ4ml1+/D0YjWJUs9ENmPOKazTtpxYRt+wDg23NFgX7djCfBhaR?=
 =?us-ascii?Q?NJWb3+hDxGPerkjTun7nL9JlsWITEPHTKo/CEuAYMmRe15WZ3FZS6PiIq7ri?=
 =?us-ascii?Q?9UpOql6/DUyHN0Nr6REKNbbAnIeik3rYy47gFhxC9HuWmxYEVWsY2Ic5gUK8?=
 =?us-ascii?Q?m88WJfP9R+/kqAGyBvoT3uvirLS1h5wj1PwwRmUDWD+Hfbi3h+i+XJAnM7j9?=
 =?us-ascii?Q?0DPT9uWOkE9T6nswIngP9Cp+XI352lhAQSV9QOdAy0N92ndgkW8dcw1r8Nfu?=
 =?us-ascii?Q?+KxMGJp9gSl0FAp0jkcSZZ0TBCvsIrc4ORQkuZ963FSMLiPZZPtSC3s6NE0/?=
 =?us-ascii?Q?zWJDg+RKghbJZahYorKpp4jP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59fba5e9-b2a1-4e06-f5e3-08d95e6adc2e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 14:58:51.1090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXqrHfSjiwXxA5x0O5FTMXlh7f0iCHwb3RNWPrZ8kRJcDVPo7gUJNpY+ko18f7GIDgIFItvoFUc6ZRIBR5mImFBgltnoTuwUSe+KSGBvlcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1248
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10075 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130089
X-Proofpoint-GUID: zgqg1jQ27Ba9tgzOlz_DK61-mCl0PWpK
X-Proofpoint-ORIG-GUID: zgqg1jQ27Ba9tgzOlz_DK61-mCl0PWpK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 02:28:55PM +0300, Pavel Skripkin wrote:
> Syzbot reported slab-out-of bounds write in decode_data().
> The problem was in missing validation checks.
> 
> Syzbot's reproducer generated malicious input, which caused
> decode_data() to be called a lot in sixpack_decode(). Since
> rx_count_cooked is only 400 bytes and noone reported before,
> that 400 bytes is not enough, let's just check if input is malicious
> and complain about buffer overrun.
> 
> Fail log:
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in drivers/net/hamradio/6pack.c:843
> Write of size 1 at addr ffff888087c5544e by task kworker/u4:0/7
> 
> CPU: 0 PID: 7 Comm: kworker/u4:0 Not tainted 5.6.0-rc3-syzkaller #0
> ...
> Workqueue: events_unbound flush_to_ldisc
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x197/0x210 lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
>  __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
>  kasan_report+0x12/0x20 mm/kasan/common.c:641
>  __asan_report_store1_noabort+0x17/0x20 mm/kasan/generic_report.c:137
>  decode_data.part.0+0x23b/0x270 drivers/net/hamradio/6pack.c:843
>  decode_data drivers/net/hamradio/6pack.c:965 [inline]
>  sixpack_decode drivers/net/hamradio/6pack.c:968 [inline]
> 
> Reported-and-tested-by: syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  drivers/net/hamradio/6pack.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
> index fcf3af76b6d7..f4ffc2a80ab7 100644
> --- a/drivers/net/hamradio/6pack.c
> +++ b/drivers/net/hamradio/6pack.c
> @@ -827,6 +827,12 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
>  		return;
>  	}
>  
> +	if (sp->rx_count_cooked + 3 >= sizeof(sp->cooked_buf)) {

It should be + 2 instead of + 3.

We write three bytes.  idx, idx + 1, idx + 2.  Otherwise, good fix!

regards,
dan carpenter

