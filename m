Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D2452990C
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 07:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbiEQF3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 01:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiEQF3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 01:29:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C992C65C;
        Mon, 16 May 2022 22:29:23 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24H3jUPl024500;
        Tue, 17 May 2022 05:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=X1zJpycB62lzSjbYMb7bSL4OgUBjHWyxKE+4cSxS9fQ=;
 b=vkVOsgCIEzCyhQqVY8DWEtYhb9eQf1nKvh5NCRzw5l4ZztI9KiazXM9E61HJAsqRol8G
 ADFafTgHZoku9ejcP+BeAZKt3wXSvpaYrSWsIdxJM3dRqd29FZoX+XubjzZbDSqm3CAR
 Q9YehY8NS1hqmmsBeC2hxNklp0rymIHOxiA23a/yMoSysZLgX4e4hynsYFuxDSfpKFzS
 mcku5DPtwPWWwuG4UG2kd83xdr/o9WYPD5lRuy1V+GFR5Ivs/PSrkwvkS6nVfbaFtiVI
 QctuACFzMED3ILqTu6kGIyppqXXVKAG/hG6dSVbOqjVurkovxHdGpZnnj6opkByFsaAM WQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22uc51pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 05:29:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H5FucU014910;
        Tue, 17 May 2022 05:29:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v87wct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 05:29:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFCMOu5ZrWOQolLc66qQ5y+XJPCL7B5QqfZwSt1CjfXTgP8iMFFdPtzavBZDNKxUIusZ0oHHxALzXIIrJcLuLddMEvA8+y82CiWO2k4igIaI1oWCf91nHZvJqa8Kt5hkpAekcj7+rqD/vCH/ueI+rEYunxM5rSmJB1RsRf2mtiJffwfeHYfdW3llqrVsJMnuQqWpMQnDooceVril+97oAEHoI8EstEtglYQn33QLdBrN2/KeBhS2vvpR8tBQmbdmIy8JOfG9XXxAWoYreyNGtNexAAkKsPAX55zH6l46kIQw67JLVpQsPZePkFlB+QuRI56CAjrdVCPTAqwmpgndLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1zJpycB62lzSjbYMb7bSL4OgUBjHWyxKE+4cSxS9fQ=;
 b=hvSsfRjpwzf+3obNHmxDEGrZdsk9innMiW483HYOPoAsEqhCI3j4WTfn69Id2yo9T5/ApaWu/w4Dc5S3ji/AyA7YLz59mblCCxffj+Pax77XVb6rzA7auVBcGgmGHRRvxgDs//2PSRmZT/OOwZpHpE2/jNBsZmG7hOZNs/3pO9+SITmHHmYRmAaGG0Ne1q+XgBF6udrvna8kQY8QH+TlTvprR5vxu11TO/cnXf+lRwXeo9vzlEvWoLSrQiAwk+TKz8L++2rv/yNLj4bG4voqSJQEb06+yNGNYzLStOfQkg3uh3fCR/5WzPGVGZy8s34ZRXlNWUgY4WBCJJ6ZOS5LCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1zJpycB62lzSjbYMb7bSL4OgUBjHWyxKE+4cSxS9fQ=;
 b=C5jIg4QQlJkjoptEYYOEFJiC/ba313MDOI0ToDnhO6rGr16CxobnyCKtoyqg+iM1JODQZzdMh/deWvxNo4ZsVGpoayKeLKNdXO8rSZyPvqnl552plaZ44JKSA1vWpvFD78UHjZ29JV8qkq/uMpx6weCh1IKcUxscekrw7K3FQUg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SN4PR10MB5638.namprd10.prod.outlook.com
 (2603:10b6:806:209::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 05:29:10 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba%5]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 05:29:10 +0000
Date:   Tue, 17 May 2022 08:28:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Veerasenareddy Burru <vburru@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Satananda Burla <sburla@marvell.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] octeon_ep: Fix irq releasing in the error handling
 path of octep_request_irqs()
Message-ID: <20220517052859.GN4009@kadam>
References: <cover.1652629833.git.christophe.jaillet@wanadoo.fr>
 <a1b6f082fff4e68007914577961113bc452c8030.1652629833.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1b6f082fff4e68007914577961113bc452c8030.1652629833.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0026.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7229b4c5-83ed-48e7-92b8-08da37c62bbb
X-MS-TrafficTypeDiagnostic: SN4PR10MB5638:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB56380508D737244E1EFF110A8ECE9@SN4PR10MB5638.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RR4tvScPGnXKGR4xt0g38ovmeuJljZfhGxwqxiKqlHT9wrHYxCGOesftQv3h3BT14No/Vultz0O+T2po1VwrPqlZxqDRzNFa3H91dgF/xtQGrNhOVZAHLecaLJnzczRWssP0Mexu82lVfiGC03yK0oNiBfIFfla64mxMPUZOM81tNpPWjkhRszmTbojMWPF/MS92H89NocnLAoog0OdE9C2dnZOxkXvGfVpCjj+ZzkttjbaukTHmljEGVJYepqm++d5HBXCo2be6Ll+uf3XRHu4Jm+f8TF7U6NGZnWQKxOcCbGm2An2hkNhUWACLyZjapHkeKSsik5Kzzv24976CCa6xWrdWTcPs5WQCecfLfvqW7tKSjrVISuefyPeZoOKr5ZuREMQNZJ3ee6a7vYSqfcgNu4m0EkYMuH8K9U7+lPctGxFQ53e1bft6vHR8/sjySX98COBMTW2rQmZ1jGQ6ENFheQIB3dI3JTtOMtTG1jW6r3vqEPRphTRPWq+kUZDh+W61uuwjrSn+HpFTegQXrxBjDM2ppxMqMBI3/Bg9PXBQvUnOYhucnEFPF2jphiJcM0AzIusayY5xxwRLvq4MwBWkq58DEy4FHwKd8MPFMasrfbKnW3daI8GS/5qxASIeEhcIU2CPMTey/jdZIplVwiLEkDSLDtpUybyMMTIZ7nh1RlVaXhvV7fiQ8ZUFzpjh7ib2/F2jVg0RvkBeQOmkJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8936002)(66476007)(52116002)(66946007)(38350700002)(4326008)(8676002)(44832011)(66556008)(508600001)(38100700002)(186003)(6666004)(7416002)(33656002)(5660300002)(6486002)(2906002)(6512007)(9686003)(33716001)(26005)(316002)(6916009)(54906003)(83380400001)(1076003)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hmTgUzWtPPtu0AkX7IUS8ECpRLfQ5GxnPoK0woupbTn06+qSMVVvcRMTVQLV?=
 =?us-ascii?Q?dZGYiB1MUAaxbO8QUFSNRGe4rdkPKP7dCJx12dQe0ohM0T5V7RoR29Ztt4xD?=
 =?us-ascii?Q?Wt++4ojCAmNFpEjQXVF7WAvxuFzNkv0mKdJULywDrgKaCzRWwJKYHx9gsWel?=
 =?us-ascii?Q?dfZN8H/wlxgqG2dbW601wtJ5jldmX9ibyitkpFs9sA6nr3BDhirtvZni3iHT?=
 =?us-ascii?Q?VtW2VIVvQe7HoOeRy+r0+WbigHvnMj7VqqGiyRHEbhRIY6UrSPEEZ9YI721/?=
 =?us-ascii?Q?shXIWn8TaVlGKTNEE/qQZHmR1CMDXweTrrqxZvA11h3svWSj0AxSo+PeLR4E?=
 =?us-ascii?Q?/8uTMRB+WrA/Duh1GOpFOctcHgmBghc5iy/Ddx830lUektvmhNqJNTniyIFk?=
 =?us-ascii?Q?AM5JpKr4DwCK24WEZNVbGOrWxT3X1VaPZkq0sS5zDQzFTW3WDGArT+MWXK/T?=
 =?us-ascii?Q?CzmrmJnQesLun33rorGRu2Air+cgW4DqM43eXAmhHBPQyu3heviH40VXqe2z?=
 =?us-ascii?Q?eRqoEhahjQ4LjML00cIOZIsyjh49g1C4yLKXCj/+9YqyFnaIcx9bVla9sLVD?=
 =?us-ascii?Q?xcDHTMa4PvdwkXkmKd+VdRe5e5RU+UjASTZvJ1UaLbw8GWo2Uous7MM4egM6?=
 =?us-ascii?Q?zC6EyB3HWugMzQieKw2FNg77krEqt927oMf9AJzpZJTNAO0ogAGdG4NLfQgS?=
 =?us-ascii?Q?b/CJNNXWvaQJjWNIeZWZu/Nbj5Ej7nVAEjjrl+KEYRNvkhFQjKW1pKNRYh4B?=
 =?us-ascii?Q?z+0d1yFMxcpqhDlrqstGvpmRaa5n4xNV3AxplBMxvunlc5rdOTqOdMpGIyHD?=
 =?us-ascii?Q?zvvbe4cDoUf/5xJ3aCRpHBmb0KWaDJpG+sWzPzk0m7yyi5W4CGpkwPa84Hlq?=
 =?us-ascii?Q?982DNu0AOA0YcGDku5q3Ak1222qC5pgvTolL/vg08ZmZS8sZ5qAAOCSvI03Z?=
 =?us-ascii?Q?m9LvQ7q3ajmsRi3lXD1xOpewdVzHti9p55jfB6PrLQPpEwUGKI36nfKMb2BZ?=
 =?us-ascii?Q?EmiHztE+2tIW/vErmVGXW2qo411zD57QBJdkIfFPAMZwqpmtOIS4sAWVFBdD?=
 =?us-ascii?Q?dhSn4W1LFsT2DVTl1tPJLd89ffETqOeVuqoW73DIJfZmcfaTwS9jRoB+TBZs?=
 =?us-ascii?Q?hX259GKF8739IT5uDMCI0wGIVVF3dh5cXrEHMPS9R0hmJtIWVOTEKETQB1YB?=
 =?us-ascii?Q?m+JLsO/EBSaLMgBDruTCSN5dp8NIbD9XXC1ov8uKz34vL8XgOZR3RnFDSDo3?=
 =?us-ascii?Q?rupky2Zz2PKVruU2T4XUCe6VN20CPD+Su00bAYS11QJKs9I7Q930uqqbUMqv?=
 =?us-ascii?Q?1riR1ral3j2YLwqUuIY0JpfG/vMoXaL1Rr9Pd52S7CI2vi/9dCUHHn5gO/Kc?=
 =?us-ascii?Q?426c1HxF4drV6xwlwoxR2Xz1BvYcqtv0HQ1ebeCThHX84k8bNW4Db/Hn0osq?=
 =?us-ascii?Q?ir52lpMtSq7Y3oBkoMhw0W6+lIfGF9t5pfL5uDo3uDHF/+oHq8sbX5sbPsRZ?=
 =?us-ascii?Q?GMHMYIaXbQcNyGf4Caq2ilsSlmClZitT0CxluWw2HZiL94H2IOg5TvTcSqbV?=
 =?us-ascii?Q?ZYwTByHfjuOY6Klegoh7l9Oplg/p0NZQP8PpPgOzLTbLXkNsV2GOTYH0aprU?=
 =?us-ascii?Q?aWmoPcWwtmjmW4s4ZW+UzfRiSsjeEC5S5eX2mVGxxO12RdeMp3ePrmCKGJMY?=
 =?us-ascii?Q?BZ/JXN9BNbI9fT8t+/cGf+qhXiZx40btVgo+KvZxdmxxH9/kBMDzHq5EpHjr?=
 =?us-ascii?Q?Mr3HS17NjcOHf85Oc2yDrlk4SBCY890=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7229b4c5-83ed-48e7-92b8-08da37c62bbb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 05:29:10.6392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlbxJ/5Xbkw/O3FWfa1qscmeto1bD1CAo4frQs+3udsjZhztewFCAXYfEU1Irw/bJGDOm9weq05Evl+BppB8lBEkvybfHtUNDOa1g2qn96c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5638
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-17_01:2022-05-16,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170033
X-Proofpoint-GUID: XcqjefkbyOMU6Xo5WmDCj0YMyQPVY84M
X-Proofpoint-ORIG-GUID: XcqjefkbyOMU6Xo5WmDCj0YMyQPVY84M
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 15, 2022 at 05:56:45PM +0200, Christophe JAILLET wrote:
> For the error handling to work as expected, the index in the
> 'oct->msix_entries' array must be tweaked because, when the irq are
> requested there is:
> 	msix_entry = &oct->msix_entries[i + num_non_ioq_msix];
> 
> So in the error handling path, 'i + num_non_ioq_msix' should be used
> instead of 'i'.
> 
> The 2nd argument of free_irq() also needs to be adjusted.
> 
> Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> I think that the wording above is awful, but I'm sure you get it.
> Feel free to rephrase everything to have it more readable.
> ---
>  drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> index 6b60a03574a0..4dcae805422b 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> @@ -257,10 +257,12 @@ static int octep_request_irqs(struct octep_device *oct)
>  
>  	return 0;
>  ioq_irq_err:
> +	i += num_non_ioq_msix;
>  	while (i > num_non_ioq_msix) {

This makes my mind hurt so badly.  Can we not just have two variables
for the two different loops instead of re-using i?

>  		--i;
>  		irq_set_affinity_hint(oct->msix_entries[i].vector, NULL);
> -		free_irq(oct->msix_entries[i].vector, oct->ioq_vector[i]);
> +		free_irq(oct->msix_entries[i].vector,
> +			 oct->ioq_vector[i - num_non_ioq_msix]);
>  	}

ioq_irq_err:
        while (--j >= 0) {
                ioq_vector = oct->ioq_vector[j];
                msix_entry = &oct->msix_entries[j + num_non_ioq_msix];

                irq_set_affinity_hint(msix_entry->vector, NULL);
                free_irq(msix_entry->vector, ioq_vector);
        }

regards,
dan carpenter

