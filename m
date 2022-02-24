Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415584C2F01
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiBXPJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbiBXPJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:09:23 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF04B177D02;
        Thu, 24 Feb 2022 07:08:52 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYSGM023288;
        Thu, 24 Feb 2022 15:08:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=cNsuNrqNw4Yhr/lOLM8S1DvYK1T8iknNnUmFXZ3brII=;
 b=PCN4KDzhvW06TnjP6xWiFbFFpXz9SL8A/K/GUajAd6PHOA+ctjJJMo0zcmU9UpOFQo0I
 gaW7VagujNOCjNDCBwmSUlzfRa4yrfZ58M52SM+UlQ6/3UeHv4C3qB/lIeU4YapUNHjA
 dx5xIOpw7IvNctnwjtCgGC+rtljNBVL9AYmr/llX469RF9p9gpo6LgPAyRyt+UpZOqI2
 QoKNUAHgqTyZ0Je5VC8vMffgegenMI5ILW/sbLb/yO0KIsmKsJaRqfyg3HX1YGXlhCVU
 NGfZLifYM3GreSDSftTW19rfMpwqzwsmORaa/9a8BOh4aCDAQbJsCQ09p5mrgEkt9eKX ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfay029-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 15:08:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OF6sOB026799;
        Thu, 24 Feb 2022 15:08:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3020.oracle.com with ESMTP id 3eat0qwr8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 15:08:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqXwQOw9zimVdP/aG0l6lUS1ikneSHxuN/0HAHEoqQz1r+NrE94fDdSDN8uKTI8WdINt0LVqbeejMbyU2KeDABzagwzVb+T4j5V/nu3QSnZueF8ZtzMKGK/YggBpyT5nh4p8+tXe/46UzgWkak8kLZ7ucssvlsdvzfAjK72RFU28c4MGIiZ9u128BX2D/bQxy9l9q8LIF0vhamd9LtjlRAlrIVufRqvpLqRH0pKKYDhVhfEIQPIfmzo3y/1kX8ykEPpl0pyXI89AiNuL8XtEK1Gkt2RBdC76Ck5U3ejEgVYLHVVry5UH9TgBfBdjpJWCKl3vFNPiy6z9KsIBcJAerw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cNsuNrqNw4Yhr/lOLM8S1DvYK1T8iknNnUmFXZ3brII=;
 b=ZmKgbY8glPlXae0nzFwUb6RhI0DuX37G6+LwVsVFsJF+/Xt2mOcUBO8dHf85k78YDBmSAaDq1PZ2Fk8c/r9uLnXvmhHRjZ6SR8KyFeR2nkYmH7ThlhcX8clqR3dl9qTJAx9LoyvlTva4ksSDAw9fMFiF3hsOzp2AK9uRSIOWmqNVP+XBEHjBVDLAGFyQ68N5XLLMb3gx03okM8/7Y9VL8EpW6IPF1uK/J2HRRo68JwGIZGBEgNbz8ybY4TuVOAoNmNJ+Y/i1Der7WNLPxGbma4iaF5rkOzyg57O4PPvFHhlkkmu5A0lCMCqFMRIIAhftQe8hoWZcOTsgKDPeZNCViA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNsuNrqNw4Yhr/lOLM8S1DvYK1T8iknNnUmFXZ3brII=;
 b=IfRuzCzM8YOFpMHkSylIvmXqDQIuck7fF8zcMLJ4S8Kx28XfjH5uZy33vl3WBfdK3+E1J3Gx92BVxf8+MFL7gt1KVIZ81Kab8kQefzBUQ28/LFqTB+2fL2FSfCjXnb2gHTuxqQ0S/o4nieRXFKN1eU+Nbterut0hE0M6OSVwjYk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB5392.namprd10.prod.outlook.com
 (2603:10b6:5:297::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 15:08:37 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.4995.027; Thu, 24 Feb 2022
 15:08:36 +0000
Date:   Thu, 24 Feb 2022 18:08:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Colin Ian King <colin.i.king@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: make array voice_priority static const
Message-ID: <20220224150810.GN3965@kadam>
References: <20220222121749.87513-1-colin.i.king@gmail.com>
 <31aa626d-3d39-ca5f-c91d-47aa5bf7715b@quicinc.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31aa626d-3d39-ca5f-c91d-47aa5bf7715b@quicinc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0057.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::9)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 677c46b9-6761-4bdb-91fa-08d9f7a787b2
X-MS-TrafficTypeDiagnostic: DS7PR10MB5392:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB539288904074235D67039C558E3D9@DS7PR10MB5392.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l9B/dC6/ez1c2c9U7+18qAJu2RmXTPUcvafJw4Pr7PFA5kta2hGjPLrY8aaK/4h8QJYg0IgO1MSsfNh4xhJYOUgFbNoY+KFbpXJmNCy8R54BcNTm89seEpbIPNHxZ6tGHBFlIhG1/z3l1MBPeDUYpHzvOwxdKOSmy+j/smWxb08Gn61eBjzZQDa1Z3W7T4+7IuizhrIIV9dkFm9BFGGqTfEBfAWaHPUryblBOxiOW6u9P2D/7PEkizeEYFPbteKNjS5w0msqW0KhjjzkW623dCucIVDiTX7ef3S64cyK3NTIalAhT2Zq5g7/XlAbONlgFAQQv4CapEqgV+GZD9usB5AqjhDtRBsUxx2q73ISd/Sa12M1OKoNlJxeO1MiCsdebkNOxhWrOmJHAEwrf0mNWI0rlB5/MpphpecuahsJtG+rpkDTwn3M2hDzd6L93KvG5gSMrltcxU9BB+2ycql3PrgEsijsi45cYX+oCLhzLFMxE4g8Xwkzk95D0y8ZHEn7rRqsbPk4FMZR0wSipN7wk60Oxbb7/5YpjhwCVtK4rP6ODkxwEccoPvogXMuziYPmhOCvx1pLYDJtLElUj52Kg1rXaoUWSVMTTnu3BaaKV2QIjhQnEx7znxrM3VN5qrbn8y74oPSrbgetgbrrIpY73sQjRXdk01cHqjzdWMJgJ53AqekGnnYFa0MTZb+tY1A/ZzRATFA2xWxNQRSqNeD2jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8676002)(4326008)(66946007)(66556008)(66476007)(33716001)(38100700002)(38350700002)(186003)(1076003)(26005)(6512007)(9686003)(508600001)(86362001)(53546011)(52116002)(316002)(8936002)(7416002)(6506007)(6486002)(2906002)(54906003)(6666004)(5660300002)(83380400001)(44832011)(6916009)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tAZemm6wn7kxw7HgMjOmOd31Dgeh4NkuAWDZWjk2UcZ/lbnKiWVHRISilw/k?=
 =?us-ascii?Q?GjaHZ2cAfftdqrOYTJe1wSpffu5wlk1WiuOSZBkAbQS2f4raiQbk4Qq35xYM?=
 =?us-ascii?Q?69FTMM4mVh01oomYv/ng8yVznHttluKB8YUKFBR1DKSBldXEmxkBwbPRK9iu?=
 =?us-ascii?Q?CUkg15Nv6RVMiwRYrl8O46tbJ+1xp0+P9MMY4NEYyIPoDKNVpgZTi/LhXhUh?=
 =?us-ascii?Q?wiR6m8DxI/5AsPTH/EcQlelZSyoQsPFUzbM9PPfrXFRW7vyaeZGsxhVQi91b?=
 =?us-ascii?Q?lFvOE6fAsWZ/BTq/xzKXem11jM2iv4/nUDPEIknaLd27N3Pnof+btkErmonj?=
 =?us-ascii?Q?BQd03oNlAYd748WEXJoVVfY5xwy63dfjd7sg4OOQKQ16JPm4qPEEvfwUBw5w?=
 =?us-ascii?Q?xfEKNOTAgP4AukDmek5IZzuJQsq+bmbrpvJFIdBuiCxJcEMvmzhn8exU3lx1?=
 =?us-ascii?Q?imex70eL2TZ4DF9h0xKMDnFAjjuCfP4sKuyknTqy+InTA8yFLpGRhqonqkIN?=
 =?us-ascii?Q?Nh78jE/DucIdPtfAC/u5888nJdNNXtnO/oTGMfIjEwUUQc+uQcQWHCwmpkcw?=
 =?us-ascii?Q?rMx1przLixwRLIKqJebsI0ruySpSEzvHbwaIdh7gZ7nLt4+EYWP1DphZjPbj?=
 =?us-ascii?Q?uhXo6H5uRHJ1+rWWsE52FPa9cZM1roWMF9Ht5bhKEQGKsDWDD10nwJiMl/E7?=
 =?us-ascii?Q?GgO17JaJec99sx0Opd+1WYwGH62szdGlswNTXwryGa/fseyoV9Rilj8Xft2u?=
 =?us-ascii?Q?nJXGBkJZv5wsvqlIFGG/NbYki9etqHWeHoyUfXPDeD5DZfOGIJFi9c/FwuLl?=
 =?us-ascii?Q?aCGGTV/N0oCwJS+njHzLhTUWRlfQQ3q0IpAO4qN75XZqDdDwNSCrIHJuIt4a?=
 =?us-ascii?Q?evcBCd5YGHeblF28UDBpptY1nb8XIYSrBTURcercNoIsI48AgzxX+Cq2xnbl?=
 =?us-ascii?Q?3WUhYHBPKGFWGscJzd585XhgsysBH7/Sn72xWGP6GtWQXqreYZRS7+lt73Fx?=
 =?us-ascii?Q?i4S1LWuAvS3d516oU6lo1CwI3NznWYvYxQyeXApCttse+mHUqviKc3x/84hd?=
 =?us-ascii?Q?P9Et5Ptq4Pk4OxQMozvs5hmSxyqK03XXDygt5iIeYRvGlgNbgbzxS5ULJGY3?=
 =?us-ascii?Q?1PbXncWyIa8yRh0dORRt+MCE9nTI/MQ+qwTGp6poG2WlLFBLzpi3YfESM1yN?=
 =?us-ascii?Q?QePPb47hLHtsvkClk6dhzJV+UNpmjN/23xzyFcVi1sMFeDqZMIP81dFtGpsh?=
 =?us-ascii?Q?vsjpu9LWDy2/xB9fxgf0mGIhy8F2lGGTq4APZgtBEdQwYpUUca8Yu3ty0Bxr?=
 =?us-ascii?Q?KZDLhT8N0sCZyjxBXQyZIUiLHzHR5C5mq2br12XNW3Qwy5p0lmC5OQYzMjlK?=
 =?us-ascii?Q?y1o5d72SiOhzitmlOnIOpA3rU1PRK5lQSTmeX7x6tezAphDB0Kk8EY95LIDA?=
 =?us-ascii?Q?5HSmbr+oPQHVKsYJFpNmeXecWPzLPJ5lHTUsUbM8OfV1xCXewTHafhwc6EoR?=
 =?us-ascii?Q?DUSgVRR5cWHKeE6XVbMnNTfP7Itl+RfliTlZht7ARI42lx3jX1O+UoACU3xN?=
 =?us-ascii?Q?GYceGCV2XoPjpK7nw9MlgSzDrYAoJJN88hSZnwBMusHaCBoc1ibMIDmuVB3V?=
 =?us-ascii?Q?fXH48buJ8J1jpme1lR33MPNL2aB2Kuy5AL/HsLIsXCCZ70o8mhF0aN2KIEmn?=
 =?us-ascii?Q?ZuT+Hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 677c46b9-6761-4bdb-91fa-08d9f7a787b2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 15:08:36.8017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z/F/61hP2+v1MxZYfM4Q2YkzQrSezrr2pxjmRD9S9pYBhp7r52kFNXcoKkdj1BKuha1BjptBRRfghHJ5j265MDQq6e9AkibwEcO72vLAVao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5392
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240091
X-Proofpoint-GUID: KhlCTHCJOWFlCtpRCjiNi2Jhqe82ddXN
X-Proofpoint-ORIG-GUID: KhlCTHCJOWFlCtpRCjiNi2Jhqe82ddXN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 05:19:01PM -0800, Jeff Johnson wrote:
> On 2/22/2022 4:17 AM, Colin Ian King wrote:
> > Don't populate the read-only array voice_priority on the stack but
> > instead make it static const. Also makes the object code a little
> > smaller.
> > 
> > Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> > ---
> >   drivers/net/wireless/ath/ath9k/mci.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
> > index 39d46c203f6b..5e0ae7e6412f 100644
> > --- a/drivers/net/wireless/ath/ath9k/mci.c
> > +++ b/drivers/net/wireless/ath/ath9k/mci.c
> > @@ -43,7 +43,7 @@ static bool ath_mci_add_profile(struct ath_common *common,
> >   				struct ath_mci_profile_info *info)
> >   {
> >   	struct ath_mci_profile_info *entry;
> > -	u8 voice_priority[] = { 110, 110, 110, 112, 110, 110, 114, 116, 118 };
> > +	static const u8 voice_priority[] = { 110, 110, 110, 112, 110, 110, 114, 116, 118 };
> >   	if ((mci->num_sco == ATH_MCI_MAX_SCO_PROFILE) &&
> >   	    (info->type == MCI_GPM_COEX_PROFILE_VOICE))
> 
> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> 
> An additional cleanup that could be performed in that function:
> 
> 		if (info->voice_type < sizeof(voice_priority))
> 
> replace sizeof() with ARRAY_SIZE() so that it works correctly if the base
> type is ever changed from u8

You're right that ARRAY_SIZE() is better style but we have a bunch of
static analysis to catch the bug if someone changes the type to int or
whatever.

regards,
dan carpenter

