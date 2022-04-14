Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F22550082C
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 10:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240449AbiDNIYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 04:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237076AbiDNIYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 04:24:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD98D5D18E;
        Thu, 14 Apr 2022 01:21:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23E41v1G022836;
        Thu, 14 Apr 2022 08:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=Dsacdj6MqR/0GF8CdllAj/IYNiexZ4QOai2jRr0BtDQ=;
 b=UrXNxOxL3MFZu0Nv2LZNj8rNsN+i/i4Bc/AXwuv4Oh/y5k4Iiel2EUR2F3SIBMRdyjEk
 dqkkw1J+rHc7ojij3odpNtN9pzWTAK6JDpBldBnS64wK9J/LosyDSPmBhUEfsxJ6qLtV
 VgMcoBJk40gyPebvygrJjn/iNI9H/NpKt7TYOBFZwxZOc3WJtWUNuOXF1JC5uLj3YV0w
 wpl17t7nhXCtRcQ7r6Rl3T9sTbzVnhV3/ANoU/omNsuX4OFiRbwH8vmiWwUX9IgcKOHD
 Wqd69wSGZwyyibLM7NCgqt40OjZ2iLb1rjrpeEdylCnFK4O9PrFFylyRxC+DUIl0T0WT aA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jdbrjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 08:21:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23E8BVWl006150;
        Thu, 14 Apr 2022 08:21:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k574ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 08:21:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FK1oFGLV5o4NMoWBs32Uv3oGizC3WKpqtoUARj2mg5y/KjpYbyWlVO3ATGZNl1gEC7ULG2q9JqEUyk9/1D56HtdLUWSNzzev8h4kzVs2l7krLFuxga2inIXWy5RqVR2g84PzW6+8xbMnza5rXS6QLU9xwJpcaKOtDG6RKo8vLZECIYvODPB+H+5qS42Sv7Nj3jNsw8PbtHNJDoJg68RJF//8F2s8sBHeH+99i8ZFYm6rkK4KwbK+O3OE1l9nrs85glZykn3EbSIj+6tXaDECO1bGh511nib6jsb1X9r7sXZLDHonGE8U+OQ4odibRWfgBFfFENOte98qgiezMQLj5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dsacdj6MqR/0GF8CdllAj/IYNiexZ4QOai2jRr0BtDQ=;
 b=K8BTLPbB5AKjKOpLKSKAnT/eaMjOMRhLPI2fA7CwNy0rcXkW52dqe+ruUfPiOQoy+IJfzEcL8W+677EYnbAzWmUjST+z1mQSZEy87ocFzJvxzgVUjmI1ChzmwddF9Njy2eEQM2wklbnYoRea5b8bXMcBgXesy5LFr6c7nns+MJw9NOjLohoUPsfgNOQ5dXRJm14hFOhOAdfKzs9f1PSm+Jn7xJBz/wG9LlaTaW4n86m+L2oi3meYOTBgtjdusgYF6Jl9w7vC0xTTnx16QdV7lAEzzzJQlDcbpKvJAUwTLZ0pupfSZjl5C3afe/AKEFLud/DD8SSq38k6nnWZxW2HGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dsacdj6MqR/0GF8CdllAj/IYNiexZ4QOai2jRr0BtDQ=;
 b=aiEeTyYO4FNCxDG+fEzbeZkzmQDi8s+i+IVoG3WksSUA9XzDpuCRvnkG45Fqsh72OBY+QN17DhDldM3yTjRyEyqHjtpTqPOdi+bo5KMAKT2Vw0SNmOzMJP4t9hgrYlIseYjfs+RIUgfwbr59Gt7xlJt9F6tJ9WKV9ZlM+Ho/7a0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB5115.namprd10.prod.outlook.com
 (2603:10b6:610:c4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 08:21:31 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5144.022; Thu, 14 Apr 2022
 08:21:31 +0000
Date:   Thu, 14 Apr 2022 11:21:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     David Kahurani <k.kahurani@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com>,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        syzkaller-bugs@googlegroups.com, arnd@arndb.de,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Message-ID: <20220414082115.GA12805@kadam>
References: <20220404151036.265901-1-k.kahurani@gmail.com>
 <20220404153151.GF3293@kadam>
 <CAAZOf25i_mLO9igOY5wiUaxLOsxMt3jrvytSm1wm95R-bdKysA@mail.gmail.com>
 <20220413153249.GZ12805@kadam>
 <523330e4-cbd7-62a6-9368-417534ddb0b6@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523330e4-cbd7-62a6-9368-417534ddb0b6@suse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0141.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:51::15) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6682c66-bdb1-49d8-cb49-08da1defc728
X-MS-TrafficTypeDiagnostic: CH0PR10MB5115:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5115925BD45C0E296075A7838EEF9@CH0PR10MB5115.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D8z0WJf6lL1fyO2QrpqyujCswejN3OTPRzxh/8hT2Ep0E0WiRaVdqXfk0ROy1W12NOAxrOyZs/Ox1/EHywqIpo2MKAQsYucdrokb6XTx1D6ZfHtpM2/FfWFsznb/F/zu35krMppVvqmfsP6tXX2hyq25kf/EyrSfri2f1dHrGuAx02DoKdJBWeBvC6BmYVWGnTZs3Ji35P8JEuCN8m5EewlHe+hzCcZrJm9zM4/yn6Z68Q5T50X96Ox8IGSvdDvKsuWOja4wzgO5j8UjI2Yhm3DSpS3/v8j11TIKV4uIeItdyFI6DllovAaS9MEOaH5RUzDbfQT+hmJyNnGo34X4lbXlGoHVAH26i8GQ99D538VKcp2XJJEbg3p6dnF/biQ8BkTqS9E+ANjSFxTLlvNus6XBqxnt0Lm9UyqM/AuO0qcYlXq9nqyMbxfO+2FrxaTak5G7hywc1SFA5NBw6Y8PgO+l7+tbg6s4V22TuuA1KBr2r9sDwAzZjJAWbMJ0mpMkSZtzwmYQ9Ye25LH7YU3Q2aXhsMd/bZUPYR9Y+8RBVswq4bETqyzjE7BwB4UA+XrC9BtLWNKtXaqDiHcRft8cd3wQaAPJzKFf5VIUPiwpb+ksOqi1mk72dd/ycy1BS1eo7dObIfFZdsoz6IZRiEnkbg4USWuW4akzTTK9LryUyo9cLkWxZr9TzmPMMG+Vt9UjD9uQgEVVySskQ+X9HD9Bwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66556008)(66476007)(66946007)(4326008)(8676002)(53546011)(52116002)(86362001)(38350700002)(6506007)(54906003)(508600001)(83380400001)(6916009)(9686003)(6666004)(6512007)(6486002)(33716001)(26005)(38100700002)(5660300002)(186003)(316002)(8936002)(33656002)(7416002)(1076003)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AnWNq/gSEbOzyT+UZgW/owvq/yRVyxfhsat2LUAuhVrHrLZm2SxHWTdi8U3X?=
 =?us-ascii?Q?i3ISnmPJYXt3au/5hlfGgZHRgYAtsX76cIQc28IvbVcHF8WAW7Z6MdHtXZM0?=
 =?us-ascii?Q?AvFjIBN3qQ7aUnn8v/8fMuK5pDePSsCk6JQPjBLtr8mjie1Jp0cGTQaNZMP8?=
 =?us-ascii?Q?vgNnGYwABV60fT8zaqZMGeaYadpva1oy+mhashngQsnaZ3gCAWpC6CbjlPpi?=
 =?us-ascii?Q?hiHI4m2HHcsAe4j+F/1GVmdxZIc+5MjF5+I/wlxWsPS7n7I2xtVozDJO+Xco?=
 =?us-ascii?Q?c3bbmUUmp/bWSOSTDZxFEuK4/zMn9Ic4k7IHI/4vKs/Ps2eEFalz/eh1zu1m?=
 =?us-ascii?Q?XPmluKWaqT4J6W1rlsewlHX8GchhfOpjAijS1G1xD0IpltoZIy8Pv84n7/qw?=
 =?us-ascii?Q?6CXq/bOV5YWxQHiAgYoWak0xua1XSCLsTzWEow1xcKM0uCtTobFbXI9HmMTf?=
 =?us-ascii?Q?7LLnBNa6zCkeeWKR4GDz5Mu+0DTUlITReWKY52C7gLPakCfsAuSL7+loO5Jy?=
 =?us-ascii?Q?BmVZfsoH+60LumCePzEX6E29lcQmx9QAMrcSg/DVB2kUKCsyG95UPbl34QG8?=
 =?us-ascii?Q?zEOQgfbXCeGTdMFt/X4mLFci8lz1NtxPsAt+wk6tgbBnfwP2lHjYhyrdDGYn?=
 =?us-ascii?Q?rqncYOTpDpt1yA8r+EgBzJcVmgbMWgWacTqkWlR7M0pMYUCgb618Hd/PWJen?=
 =?us-ascii?Q?HHKLBOo/lreqyM8XeAjPnNC+denI/+i6lxpiuKzQTAWMH3dzg9FcbuihtF6b?=
 =?us-ascii?Q?u6fzFWa0a0w0d1CnusghTzZyXt3I8AvkRxW/M+hkeQxAuIYzQlkPSQXl6Oyp?=
 =?us-ascii?Q?2S5etYUJOHIo/XFFYmJYJMcQ5LwLDl4x9VxqKiLDy/fZlR+GODqXrS/oBCNu?=
 =?us-ascii?Q?DjB6sFq6eo+85Qfpow3ML7V9WV9mCLvFp5y1Pf1CUiReIKRC828FPDEhEL8H?=
 =?us-ascii?Q?vwJNMZ3/1spPgKxZK7a1ngOmMYL91uAQ2OQ4SnLzd/+P5wsbZ5tOgo0FuBFs?=
 =?us-ascii?Q?dZzNYEtDqoNm/px9s0LV+JFH6g+JcEwB1NiByguTeHqL98wB4NZ6/YZGygkd?=
 =?us-ascii?Q?OgxQQO4h8b65hX9958lPKDezmzNlhxWqOnxo0QiIKH/hNJASYvws9aj66E1J?=
 =?us-ascii?Q?GGzE0KimyBqjRtZpFBjYdVIWfzFpnTfBi+JKF57FZv/w9aIsW4nvMNv5k/MU?=
 =?us-ascii?Q?1ys8uKhSQuHzv9FPFAXTaigqgofNpsm2QHcbxsBjkb8HiZXxySKInHDqskMx?=
 =?us-ascii?Q?T8iwV1YDg/Fw2N2O5ttBxB49yI6Q8aevYYHlJYqZLNHXbsx6LSQXoDdaBN0N?=
 =?us-ascii?Q?oOhOuL8a2+NG4JSwojJLSzq81BFT8JPfKLW24Lp7T26Vq6qEYCP5imWLxQHI?=
 =?us-ascii?Q?+5exkIJrzT97rRtLS3sPIMw7wItm7Cnh/Q4zzO5KWDssW+vOq4rRnON9I/sb?=
 =?us-ascii?Q?4BecqIcnNomzLUKwLHmeolgUZshSNnqVu0rorz+fEG388jDH/iJ863gEVc9W?=
 =?us-ascii?Q?ITw0iopsTbVAUo365O+U69mQ9yL/nLetF2mpZ34xx92DJtz+bKy1phyYC5C4?=
 =?us-ascii?Q?GoZKdLgQzspdADKo8G+7Zpy5sQBy8o+g8JacNEQw1qhhKHmiv3vVmmqaKQN2?=
 =?us-ascii?Q?Ip0NjkpXwjVBprryY6V2JFhYSehySNZ+H9p9TGyLhMd091Do9+Mu+4ZA0O+C?=
 =?us-ascii?Q?q+S2M6OJFsWSqcchY2nHuhLFzjh+bJDevxRY3SVRHuT0AF1jN98bp8JbtlP8?=
 =?us-ascii?Q?Eudm6jR1fxfQ3K3FOrIT/LC48VDdxJE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6682c66-bdb1-49d8-cb49-08da1defc728
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 08:21:30.8793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sgOZvIfiZD16K6AYNpivlX0cSv6VMz8w+ohSMZ9tdn8MQ60hu4xvYbWX1PYJKKjy0pf9Kv5BSG/Mmoj8HNj7ngA1NszbKLrkKMccnsE1HtA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_02:2022-04-13,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140045
X-Proofpoint-ORIG-GUID: ML6XTp3WzEdh9h39wVyj3KTw-1Ws7Xw-
X-Proofpoint-GUID: ML6XTp3WzEdh9h39wVyj3KTw-1Ws7Xw-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 09:31:56AM +0200, Oliver Neukum wrote:
> 
> 
> On 13.04.22 17:32, Dan Carpenter wrote:
> >
> > Bug: buffer partially filled.  Information leak.
> >
> > If you return the bytes then the only correct way to write error
> > handling is:
> >
> > 	if (ret < 0)
> > 		return ret;
> > 	if (ret != size)
> > 		return -EIO;
> >
> You have to make up your mind on whether you ever need to read
> answer of a length not known before you try it. The alternative of
> passing a pointer to an integer for length is worse.

How is it worse?  Can you give an example, so I will write a static
checker rule for it?

There used to be more APIs that consistently caused bug after bug where
we mixed positives success values with negative error codes.  We
converted some bad offenders to return the positive as a parameter
and I was really happy about that.

Another example I used to see a lot is request_irq() saved to an
unsigned.  These days I think GCC warns about that?  Maybe the build
bots get to it before I do.

regards,
dan carpenter
