Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0015F3F9DA5
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240295AbhH0RSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:18:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48500 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233925AbhH0RSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:18:31 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RGOvvM002206;
        Fri, 27 Aug 2021 17:17:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=H48VK1deJLe0PU6fe35IE+8KLX2c8vaBdM/dZhMLQkg=;
 b=NaPl8I2wZssrOkpQ4Ty96lvmAkEBVoEzpC9vlFH40z5biDvx1up0pG+RWFeR0E3Xp38H
 8tBkK/+Nz5ZsuvayzrUozNVU3rX4aOmdkI1nE4nIzqLoSkDji758GVxXxhiEqzeeNd/g
 p/hz5cdOcLsC/D/nbeWV6MEAm6MdJe0bg2U8IVqH6rXH5FNB3+u1bzlNZhuwYRS95yWx
 hyJsv1BLrAQ59yRAqCXAHcIUoDfGxiTvn0kt3KUChHvmOh9jgbO99K31/8Sy1YffUEG5
 2bmxUXaMWuW1mqEM7BoE4jzY2Ccf8FC2SreLfjflyq0nz6zqjId3ZoNJhWYQOjxyCZgH jQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=H48VK1deJLe0PU6fe35IE+8KLX2c8vaBdM/dZhMLQkg=;
 b=mWoWGb1ZmSdL2xDvTjKWw/BbQvM/8d0dK5xPqqD34dC6uCVdcdro9jLrOeOZXcWNy1mY
 KRZ+PrDWwqtAZsBJNoZr5tk41aPt+somlUeh6jfH/w6xBFn8Mgzw30pdql9XgudlW6IC
 +XtqpmIsJEUmvrlWQ6dfhB1F4o8e90sJBmTUlAhvzeZnxLcV9AIKTweJUptMFep7Bdo0
 cuqs6C8tsiZ9fmR+VbYplB/0EytrdgloQGDj/K8SCp77MQ3AiJBvlxXyvRsDT72X4Xr4
 RGIK5xCWXbk9y1RecQvR3cuMCLn78C1J1iAsqwb8IBikZf+qw+3BvTLwhne/DC9OiOBj DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3apvjr174w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 17:17:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RHFqwh130541;
        Fri, 27 Aug 2021 17:17:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3030.oracle.com with ESMTP id 3ajpm51vtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 17:17:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRShieCxAm2aMOXCl7ebbn/zNMzuEr28VgTg26RPXW7CqNKjx0TXDiebgeBdOLeQcHPlGay0FEr27TCZ2nNS+j1ZfFdbpP1qGgqqkty/M4at/3kdFbjkgMyg0CUewV8iqegOovRrFN6v5nPM2ynwN6vevnWlLl5PyBfREJQR7qgYzEZcrSchtlay7sZH9BNXfk1NssbzFcHw9KbDBVzJegjrab8xlMkNYcavdjGdlTFPTc0/A5amnuEp8NU6tWdcaaQQdtR8hFX9xVEABY5jSrBmQTJQQAuXvbEICpC4K8pNHNmBcoWP4IAuN+AHAzP/WomfRCpTsWlLWzymaNDF+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H48VK1deJLe0PU6fe35IE+8KLX2c8vaBdM/dZhMLQkg=;
 b=e3p0t7xvQEIix/L08tNKs3IYxBHy2cCO5Ik48isUrFnNz5YoVrbjjDJjWE8PfvqM5KJDRjVnt+SZ+sqsvSWeqcXg7D+8nwxrvtIkRxzmCtJR6sWwbAxJHpZk5og5mpAu8mm3GHSRtEPztSU44YXwhpx8ptEonCQ2KQdq6snsaS++fQsWwXKGHuBytHQhkC9ssma9gWgH5K0/S2dJ32Uxbpe/RTzpwUyU+LBTwcmx+qo5BdZxI4RQq9VB7KkaooiCjPLPuhWpyP4zd5BqKIBAsZL21FHy9PmiitIxO5rH4Bzv0yoD/iMTgYNY8tzweAQviUkDye7oLiDgnH1AIhJG7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H48VK1deJLe0PU6fe35IE+8KLX2c8vaBdM/dZhMLQkg=;
 b=kmFglyG+h8iVZeT31p7bcoZD0UDyJE6j9SBZhGnN92Ubj62RCCjVBVuFGBuU1fO/Cg9SNqVHaBH9We8X3RUDT7XbtgxWzyhpVBzjuTJy2g2QQlVP6PQMBUHY8O+U2dOTXdt95Q/dJxLYCUtKYrCOsFAK0CvBArPZL39FbI+q5hY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2399.namprd10.prod.outlook.com
 (2603:10b6:301:30::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Fri, 27 Aug
 2021 17:17:33 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4457.019; Fri, 27 Aug 2021
 17:17:33 +0000
Date:   Fri, 27 Aug 2021 20:17:16 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: qrtr: make checks in qrtr_endpoint_post()
 stricter
Message-ID: <20210827171715.GO7722@kadam>
References: <20210827132428.GA8934@kili>
 <CAFcO6XMo2rFJqb1zZyPgEDtChLHNq26WfhAd5WC+9NMnRNM8uw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFcO6XMo2rFJqb1zZyPgEDtChLHNq26WfhAd5WC+9NMnRNM8uw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0017.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::29)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (62.8.83.99) by JN2P275CA0017.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Fri, 27 Aug 2021 17:17:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eadd3c79-2383-4eea-1cbd-08d9697e8ece
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2399:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB239922740DA5F434D07184DE8EC89@MWHPR1001MB2399.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ykGMKhdptx5I8ysfY0+o71nR0V1jCzuuB6gAyEpkGk+kVl9yRp5nPBkRKw6A625IUPZOc2nCzOCuwypJUtYjdUI1mYJlNZWn61/jhm0wJ4NOX3lo2owacRAMa7D/7E/iJ+DPRR32KENP8PWYJI0urb/un0623YnsL+nTdwFW/8FKj1DEtIwQAS1N4CEPu9AQDBLZbNz4r0KgC5N4aBTRfw/bCD0F0x6Bd4GqwreYONoF3q9fQHOUIGoHF6NsK8NgMHRJua0ut+DkEL6faB4xxbuLssYe0mVd1V22huSDoPvvtZrlhwYApVTxTidie98rhRKxIaYJXqk3/CwNgaJhVdOUdRgaKL3uCJ+HFCXJMK5faPvwHu9mVN8Eyk5Dq2+pVzUGCv+m0lU5pyEAWXiYqgMF6x01hppjk4IH9s0gd5EIYPLDC/eGhcZqVqjT61nevW425zFP+IWtTomlq2mGa1dEhNNVlGx/XMQN8PTnyOXaZCIYeAtNVZRuMkBlkwQ/NBlzM87XFKqtxnSgYXIdbzU4PseuxBPSo0CMmWl7W0jVcIFGeD6ai1Ty6K1QqFmkSc/V+V6d60MEbwD7QCsaGrz+C7XeRPIbQPA3iUYF1zxvN7lqoWQCmcjW6bzrtGIf0bygHlXJPRgp612nNTGzeIQB19rqMZC1qnD1F78xqBpS2L57JWDgy5GfVqgmkaUCkQoVMraOlCMtPDRnU7s6zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39860400002)(346002)(83380400001)(8936002)(86362001)(66946007)(8676002)(55016002)(1076003)(66476007)(6916009)(44832011)(6666004)(9686003)(956004)(52116002)(66556008)(54906003)(316002)(6496006)(33656002)(478600001)(186003)(9576002)(38350700002)(4326008)(33716001)(38100700002)(2906002)(53546011)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7lvDP8h5MDVH5iGd5/hVjQIzm1lfZh9W2k12YC5me6kEx0PX6zm5RRfpcI/Y?=
 =?us-ascii?Q?Xyvo7H7J4h9ww/+D/MSX0dEofbDOYm1c31jXdpusbQlFsvSIOoAdhnNDDBmX?=
 =?us-ascii?Q?JJRch+H78cmtspEg19mVQFohmbnvbGFWhAIa/x3SWFFx6yEpTyNZTPn/CbbH?=
 =?us-ascii?Q?+I5rytsdDy75BtupUnQrDpfZVfJEI2+MoRHKx8gCyebcCQWXzfTutvBNmcOs?=
 =?us-ascii?Q?AGLEXBx+nGhlSfRf8i8BZTFcpl2NpBiZQFRbqNq30lUXY6FGpMEN+wiFPFpa?=
 =?us-ascii?Q?7CQuatbM67gCMZjGoRDMeGMi3PCUqdsav+n11JgnoxCvHtm4xSOdba6nV982?=
 =?us-ascii?Q?CoRqSQ8lIDGJ4WtbL/ESUnyUMOby6THZB8mlCBxhVOaTfDErq1TslNbgQ3s2?=
 =?us-ascii?Q?GNOoPIdzK0JgORN9iVd3DOK3JkpLSVixD8GuqgTMnTTwWGRhxNRA2HZ3Q5W3?=
 =?us-ascii?Q?AlDZomEl+VV+uaRtcL79QifDHxk0vDIAGVynqpXLAkuEHnPWsguYw6dk46EQ?=
 =?us-ascii?Q?gYHwt3BI29PQXkhOWAD8cZevGzJP1KRKxuF0UjPf7VA38Tal+1aene+J9WgU?=
 =?us-ascii?Q?H92IyWZstkZVQL/hvQgg4ZVe9+HyE2Hv/GqSagbILA5y4f8QrogOA1J4GxdX?=
 =?us-ascii?Q?Hcqi9iXuMAAKNM3xsn5jhHLzeJEzg76cVIdS5G7j/cxwBHYJG/RpnVcvxk48?=
 =?us-ascii?Q?S7LvR0M3FJYbH7DGdUVAh8xj2vk9ceA/YvyuhJADqVMBRik4N3BFwRIHR+g5?=
 =?us-ascii?Q?lEa8Bbjv/G3umjMVoz3TBGZjVvl9Br93vMOfFrizamRbh3HIBAGS3/M+0ZOU?=
 =?us-ascii?Q?UBwlSSZ3GIWXZEqrbNEwbp1zhMWYNLWeiHdKRn7m3H1A2pUVoliYzLt9f2jC?=
 =?us-ascii?Q?kLnSlYgFnQiMLOLVPzCvh+UcNR+kq5+tcMxaUzkK3EggVfQ/mlHPfH8nnft/?=
 =?us-ascii?Q?fuZj/6YB3O2Cz9NNDbwd+xUx1H+P36yQfKfGdYo9QYjGUF5fplwRIojnc33l?=
 =?us-ascii?Q?d/SJhrFHQZ9EiHHCQdAXwMudYvl0tavebqoSYYKeDoLDf2MmMSpzFoXXG6VA?=
 =?us-ascii?Q?MMGHjoQzDLEDd+TmyWPTYUwRqQIYD+Vh2NFkb/rshSbJUXLYZ5zpkc+B/0g0?=
 =?us-ascii?Q?rQhGFbDcczGyz4lupNwQ/iO6BA231+rfxXK0RjtERofxYyA62HyY2YRWFb05?=
 =?us-ascii?Q?88CFPsi5/2/Oy2NSHZFpr1s2lTD/yOWF1KrBLIW/8Dsf1pH8G8QZyRCxdKbN?=
 =?us-ascii?Q?ojlqK7qHEBRIC9SzqlI5VGqvflPcEWnNQGkEMRsEswQvY4EmAPp6UkP/IOYf?=
 =?us-ascii?Q?6K0e9ehj3/oONybOl6epG6FD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eadd3c79-2383-4eea-1cbd-08d9697e8ece
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 17:17:33.4854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U7Cq9MMrpOTt9K04N+TO9gPFo8c6P3HCATNFv39dORMuyNnyfz1kIMRwsNy/4jtRt19c08uPeeASk+RJu8jPrCwPO3IiHrU0mSW1b42N3Ic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2399
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270104
X-Proofpoint-GUID: vYSnnc2RcHzRvOFYmf_I4mVPEpen4Egg
X-Proofpoint-ORIG-GUID: vYSnnc2RcHzRvOFYmf_I4mVPEpen4Egg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 11:35:31PM +0800, butt3rflyh4ck wrote:
> On Fri, Aug 27, 2021 at 9:24 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > These checks are still not strict enough.  The main problem is that if
> > "cb->type == QRTR_TYPE_NEW_SERVER" is true then "len - hdrlen" is
> > guaranteed to be 4 but we need to be at least 16 bytes.  In fact, we
> > can reject everything smaller than sizeof(*pkt) which is 20 bytes.
> >
> > Also I don't like the ALIGN(size, 4).  It's better to just insist that
> > data is needs to be aligned at the start.
> >
> > Fixes: 0baa99ee353c ("net: qrtr: Allow non-immediate node routing")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > This was from review.  Not tested.
> >
> >  net/qrtr/qrtr.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > index b8508e35d20e..dbb647f5481b 100644
> > --- a/net/qrtr/qrtr.c
> > +++ b/net/qrtr/qrtr.c
> > @@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
> >                 goto err;
> >         }
> >
> 
> > -       if (!size || len != ALIGN(size, 4) + hdrlen)
> > +       if (!size || size % 3 || len != size + hdrlen)
> 
> Hi, (size % 3)  is wrong, is it (size & 3), right ?
> 

Yeah.  Thanks for catching that.  I means & 3.

regards,
dan carpenter
