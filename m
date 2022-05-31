Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC534538FD4
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 13:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343776AbiEaL0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 07:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343768AbiEaL0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 07:26:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6565C770;
        Tue, 31 May 2022 04:26:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VBFcfZ017680;
        Tue, 31 May 2022 11:26:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=IOC4f5e4yp24KgLZQ6zcVPNmJFJdhkDQp8FgH+UxCeg=;
 b=hsJuD7Wkh7jpzUHaeqxr2csidPzHNb/jGcqiNfOJA4qCNJAK9KyJew+Bz31oYPqSrzNI
 /G/3DmBjN4dSK5sy5xPEkaJos36vOJtEx1bwlPG5A6wgsCHP73YdWKEfat0X3WNnkHnT
 sr2WnX00Jz1l5wWUK4KlDybjcbMFpqH9ChY6UZpeIICBhT5TRi/OcRkPm2FQOaxGqaZN
 qU+4n/Wcs1SzoR+GGiESYopr1iN82/P1oVlPDiqEvTfY49I17aZP4c/CTqFpwf0n4iZp
 EddMcOGLN8Dj/SI52dIa20/mwjdnctwyDJHg4YNz/44nxwwJERLnMOOkT8x3AwjHjoBH pw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbcaumvfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 11:26:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24VBGlOv001444;
        Tue, 31 May 2022 11:26:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8kh5mtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 11:26:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfjNTulVvMQYwT8p3b6zcewSVTctDvyIHygvH6o11d1hiI493+lXTi/AU4Y8KdP9ghnKesJtnb1B7/bwTRO0xdXSygaPDV5Cj/zQemQsxHSGZMwLH4ovGZCGGW7df4/8GZaMnoCLZZbHyY/o7lrQ6zurRZhZs/aGL+zWwCoXy2tJZGGCw+XwIxBYRiGIdJ9g2T2UCqNo45ohQwA3gt8UxEjykyvhT2cbJ9xOMRlFSKrLGAfS1LxkY8XEvqnXYkAkpkn6Ux5Ap04Lgd2v2s6qBq+Se8GkMESQ+Z4gVj/5gHMu+FXUQd0G6BRv8bg7axrNl3Q0JFHS1QHqHE+jyjTzlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IOC4f5e4yp24KgLZQ6zcVPNmJFJdhkDQp8FgH+UxCeg=;
 b=no5EWgjU6fjus5VC1+GpCmvqIHbt70iiDVFjgLovMpFQS/joPD+EmToJN6V96HDRUbnrfBWd+GMygS5OLZYOcZLUPcen/RdFWRufnK6oa+4zTukCgd+9057y3w4brW4Ux41MT8UQKUjQr9RTv+W4bYwW7zOOqIBG9KDDpzIOPK3GUm4Y6I8r/Akljp7PM7woAt8qenm506QTEhmWWl6qDfGdQKIsuFUU8UfO3st0o+hhqnY5rNppgV/KVj8x4lnl/qIX2+HTtNA+ZNX6iMajTREW3yLCrseENqrK7CnkxecHKf0iIW/x01vGRiuev/Pnw8GMMzcvwZ69IkE+H7HU0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IOC4f5e4yp24KgLZQ6zcVPNmJFJdhkDQp8FgH+UxCeg=;
 b=Du8u39d4Gx2C+A5FHsRVwL83dCB7N82AbxYq5sNTfjfYPPBCNzdMXW2zD17i5z+qmrVkUWeQj6yIi2XGsJex4xCQdsliAKOBbzxLMSDDpc1mGz3XUyl+0qYLGzr0epXEjlzwH/6FlhbGQalyJISShgdvbjxFD6zbqrYXYXWJ0RA=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BL0PR10MB2788.namprd10.prod.outlook.com
 (2603:10b6:208:79::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Tue, 31 May
 2022 11:26:12 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 11:26:12 +0000
Date:   Tue, 31 May 2022 14:25:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] netlink: fix missing destruction of rhash table in
 error case
Message-ID: <20220531112551.GT2146@kadam>
References: <20220529153456.4183738-1-cgxu519@mykernel.net>
 <20220529153456.4183738-2-cgxu519@mykernel.net>
 <e530dc2021d43a29b64f985d7365319eab0d5595.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e530dc2021d43a29b64f985d7365319eab0d5595.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0001.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::13)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76507558-00d7-40fb-0630-08da42f85d76
X-MS-TrafficTypeDiagnostic: BL0PR10MB2788:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2788468E04996EB0EB1E25248EDC9@BL0PR10MB2788.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AjUHdMoipoZEJ/lpNCyGRYRiO/fLFwkBqpRuS+93mvxTemhFSlsXkmbTiukobXdSHsSFXbgRcM/ZgMQ0Z4U7plB9GqE5ZT0vdWzMtubde7EuRAq7yq1MhU0AtlMkDKWYxsFlwD6chbkyKyRDYxJvitQtRM9SWweZ+asDAFJZjxMDSi0hJI882JuNBn9YTMjXJ3yKiFrf7DfQHnNU4u9mn3KM6LivuGD3hCmNxVabcE7seD6smE9FWgXUWySH94vFceOy21i8fHScQH/8jsgCRA4HQ7rtP5IIubO8Va1whIkNiAWrhkunQoaAV2/pEPMNWfOF8N5bwkNT1XDC5zrNhANOTcDdrPewQff5N5FW2x19OtOkmtbUMQ16UYcub650+MvvAX32qoPOQT7YBneUJ/zdqMq7NNu9jS6dZzn90cxN1Mppypd4eAZtPdVv8l+NCtk8gkpZG+IltwNONSAeWNaHDzSp4pSbjl8tk0yTc6wMv/PEOpCNdCn1Zf0yUt8yOjy1y2QwyqWjwoJbsKfDZ22YLon4EWfuyKizn4q4xLOhwB49QqOM4omyhp7AzcXDNBHGoSNmP61WbDQtT+eulFug4yGB+Q5wlHX7yMZGXeiYqy13FklS6Ev7+HQJAORA0nwbOhG0naZjeyToeVjSmCeWZpTYccR049auvCd5NGsqEWWa8NJ3wSH5aCsg2pxxIdo80auBneQi/N6PaqHelQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66556008)(86362001)(44832011)(2906002)(66946007)(66476007)(33716001)(38350700002)(8936002)(38100700002)(5660300002)(6666004)(6916009)(52116002)(9686003)(6506007)(26005)(6486002)(6512007)(508600001)(8676002)(4326008)(83380400001)(316002)(186003)(33656002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1advguOHXZremp7Y2KEKkO9KuZH1QSIt99FvZbriC1BeRnHPFWp+SZaVpgZ/?=
 =?us-ascii?Q?tcqWpE5Z/hLpx/ctbMXR1lbo2BMr9AZldyF52A1h6VbKXzITjUe1AxykIp5j?=
 =?us-ascii?Q?l5I/oAB1oNcVhgWTIC3fpZAAy+vy3sq9xhLni147S7kmuLYJn6JMlP2sggbx?=
 =?us-ascii?Q?fNPbY5nfZlHlqBAFqb5VAl1PihGvS2nYP7v6QV0mZ4PbT6QLq33oVkfuT/IA?=
 =?us-ascii?Q?HtR6L2V583y4Kc71h6ZYIMVktnSz/yI1rp+Jf/G29S1Sw82UGPxVDR4WlgZo?=
 =?us-ascii?Q?9I0M5el1rreGj+OtVmVfRxA7YywX+wszVQh4hQ8T8C9pR4z6ilnBPffBpXl7?=
 =?us-ascii?Q?m9PVDGrTSUWCRconQ06FMDXxsEKZrIjbOESJl8qFI8r8gOk1l3WBj9NdtCW0?=
 =?us-ascii?Q?xId03fpUKSd5sL4aFxFaxGrZs1n7Ovowt33njuLB9CcGiSbHvCYPTfYG/8JL?=
 =?us-ascii?Q?AMqiDSD6jr4OSmPXp8bVSFTjG+HJiUAZVC4VYg1EvHvXT6ayjCKeDFVftdzV?=
 =?us-ascii?Q?OLtSMsvAbEgtF3TLT+PgqaX0tYsoM5CFtRGlRPrYyZlMYZRPxi+aGUcYDBQS?=
 =?us-ascii?Q?Nt+QsdUj2OSy+uJWetQQ7D0IMhOOVn2PqpcJqeX6GL8kll/zLRaF2Gw31pSN?=
 =?us-ascii?Q?qBCTPHd8NWTQb25YV1NXnduzCB16n7pc19p2KL3JpdxanddeFbejVXs0JasT?=
 =?us-ascii?Q?bNLV+yEKoOYo+Ady8WnNIBQ5cU2iTETJ4oqxZpQpwoIFe9sRfsGzvlmCjPQl?=
 =?us-ascii?Q?ypM6yfLyDY1MTOAmAQlHxcSf32et/QIOKpPjJLKYmbLwztmsTnf8cOKDQYf3?=
 =?us-ascii?Q?81Tpyitc8pMzDajhreGmB+bq6BRCFAAv/Ua9LCR9l5VwUUbwSpXQplcDt0MF?=
 =?us-ascii?Q?dafNypt6pud9zVUnMgNe/RjgAnGlCBvOrqtnuD6onYRuKbjYbHGdnwCEo45T?=
 =?us-ascii?Q?2K8kx48EFS9MABScZuV0/r4qKa32RDmcln+V5eT9gQvpge+HFg+kEwEF7vio?=
 =?us-ascii?Q?0j2xGn137OVtpsAkQ5XqR81LAeXW7Z6/psAaaJPMwUBh2lb2+9Mh6qPm9f1a?=
 =?us-ascii?Q?g6ymO2ZyjLkEj9K2D10InHwrrYVVeqVzFnS3ViAMlC5HddWm38rxbfrR3BHJ?=
 =?us-ascii?Q?KR5My8NWYpO7dwxWaJxpqZGlmcXDmfztoODECHUiFD9AmfDRWP2VpsAgVu+X?=
 =?us-ascii?Q?Ol88sTggLHo0ITaswp04PiySjPiTaFAY9oplMaEv7XHRWPlEyiZlZyATwnAo?=
 =?us-ascii?Q?UOpsK/NaEREdENPZK4zL1u0T3+sNQJWH9ifywPpqbl0R+T9TVopnWHH+2QlX?=
 =?us-ascii?Q?PWhJvTwZB0h5cIbaZZcmzZ9hOXNiesLBR/GtnyLxJ3QuD3UoVzU3BMyInFPV?=
 =?us-ascii?Q?04Lzv3zqynQpwn6/KTqN3LaxH+mEdf3qo9eEHNy/nWeSkcANnk7XQgUIwPiX?=
 =?us-ascii?Q?lTPtadSIbcdldyFXk6KaKe5qvMz55a26yep8CpI3q4bB6PCevGdgpUYtzF+5?=
 =?us-ascii?Q?oZl0Qsj5YMnYPcZcl2CKeisK8iozWghpP/oog/AU78/i4jZAsiAR4F0aRJmi?=
 =?us-ascii?Q?zOfJ93ifBIDf77bfGmVgl/HqFvKuobesS31ZyeYt6FfzGpHqJsEJ4VlBFMGR?=
 =?us-ascii?Q?mWPVTEGjyv9+ndDm+9OfjK722q/Kn+1PdHb1k+yEddBTQ9g56Wz098RiF0yh?=
 =?us-ascii?Q?vymXXZh90VqByFG/o2oGq/y9TEKYYpeJG1TIihYtUpvCrrEGzLe2zQUmQaiD?=
 =?us-ascii?Q?+0XRg9JXxJRZq9a2HMKr1ofQgHAZjGY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76507558-00d7-40fb-0630-08da42f85d76
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 11:26:12.3215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmDZZDNTYESsu9rJhLIHss9FQCnN+lwydNTfM40ODiHa0mScAqlq1cog/I14c/lKubjVDtrwhz6PsY/PuCIpL72mZVV9lFEAhUOZRYnnlhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2788
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-05-31_04:2022-05-30,2022-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310059
X-Proofpoint-ORIG-GUID: rUGgWoV7vPLCpacYteClb4WUotAXGvKD
X-Proofpoint-GUID: rUGgWoV7vPLCpacYteClb4WUotAXGvKD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 10:43:09AM +0200, Paolo Abeni wrote:
> Hello,
> 
> On Sun, 2022-05-29 at 23:34 +0800, Chengguang Xu wrote:
> > Fix missing destruction(when '(--i) == 0') for error case in
> > netlink_proto_init().
> > 
> > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> > ---
> >  net/netlink/af_netlink.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> > index 0cd91f813a3b..bd0b090a378b 100644
> > --- a/net/netlink/af_netlink.c
> > +++ b/net/netlink/af_netlink.c
> > @@ -2887,7 +2887,7 @@ static int __init netlink_proto_init(void)
> >  	for (i = 0; i < MAX_LINKS; i++) {
> >  		if (rhashtable_init(&nl_table[i].hash,
> >  				    &netlink_rhashtable_params) < 0) {
> > -			while (--i > 0)
> > +			while (--i >= 0)
> >  				rhashtable_destroy(&nl_table[i].hash);
> >  			kfree(nl_table);
> >  			goto panic;
> 
> The patch looks correct to me, but it looks like each patch in this
> series is targeting a different tree. I suggest to re-send, splitting
> the series into individual patches, and sending each of them to the
> appropriate tree. You can retain Dan's Review tag.

Since it looks like you're going to be resending these then could you
add Fixes tags?  Please keep my Review tag.

regards,
dan carpenter

