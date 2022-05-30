Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A71E5384F5
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbiE3Pb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237141AbiE3PZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:25:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EA3147834;
        Mon, 30 May 2022 07:28:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UBbrif003335;
        Mon, 30 May 2022 14:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=Eh3hGqTPE9V1zQbdUok+0KSvn0gc1dE2U1PNkR2Qn+8=;
 b=TMJUrwRXftidZszM2xqW/WeGNELv7yNZNNPm5sGVbbuQNCax/Ux50DnmnnpVR5sI2uK7
 UFg3Mggd8XnTYCxtDlIC51GTD4wJjRef7ULnMwMQlZxtmeK3BfRle4VW2DZwbEvm1OrK
 ngMfrVW4E5Co50YRhIu1fRzC9dsZI/dmgVBiQsT1MGV40KDO5ZJj1Zj7lRRiB2p0udAA
 v+MJsovUrNvv1JTve7S/MFtjYuMapEqQedX3/VwlcQ12eizLLYNNWxqDusvuSdSYIfKl
 SxVUa2WUui/L0MkRFbHNw64o7wxaWRkCiYZrpkipVN+yqb1ZHDHWIbYvibU6E2D3uBKW SQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc6x35g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 14:27:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24UEFN25006668;
        Mon, 30 May 2022 14:27:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8jw7x3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 14:27:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9cVizEbGI95XmzCG3GY1SwAGSfUrtEiWjCJKZhB2ppVMQJpZLZe9BMMAGVkTnejaz7PAHO2ugnp0rnb69oxputlzfpVXRdP1bApkRAC01V013LQ/L6U71q63y2A3swo9lXijiBQkteudXzP2h6bDffwDGzDWCKcZt7S7DSYS0A9KHQkfkDmlvpqsm/FF8pwtLA3FpHB7pMhGtdruFbDNR2lO18xSFXmmPEUszegOxCOcq0DwPguOPvqnzX3Umk3FAochSXdpH898+qxqCtTXVkaQeaNhFa0wLxJIgmX5i2TjPShVGOq9Kyi1gxuVyCoS2CHHolIfx4l6DBnRvBIeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eh3hGqTPE9V1zQbdUok+0KSvn0gc1dE2U1PNkR2Qn+8=;
 b=d+TZw+Zn6C52vMtfQe+ISebfYcth00Ove6xuS5ooLxVM5WjismpHFtBb1ZcxwsJnOLZQQsrG3Q8xwOFPw3oIW0pn/EVYczzUnK+43eN8YQUw2gO6FFLPlRs0c4g7MC2d3P7NMQlp8w9fkhEl0HL+xKWtY8c+qDRQhFTq8Si66+Ha+yNMeFA7YxYEBqxdJn8oKRw3J3EmwYCGfO8pcaL2Q3jLis8r7ebjyirK2hpLsNdI0Lz0I3g8iMwBsN8I2Y/Y1OvuFNRxKK38zYWIqQ1sxb3EXoLuxPdjbC8vHEciN5IsR8V/3sIdOiL0KHR/CB/WUL6UbsrA7zYbG2c7a2CkJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eh3hGqTPE9V1zQbdUok+0KSvn0gc1dE2U1PNkR2Qn+8=;
 b=SPt3bsY8HGwyTRPd2ZlxoP4+qBf3/zWSC8njWCdBq9sRENJYQuewJV03PR/kezcSv2Ihb1PQoOyPLnuszIVs+szRKMUe7auHwHKHGtDNLo6EvPbeSCJSiNiQU46unqU9Z0MQDej1q+25aPbzqdTe6t4cJga4/d4UNlc4N/sYoAw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN0PR10MB5272.namprd10.prod.outlook.com
 (2603:10b6:408:124::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Mon, 30 May
 2022 14:27:55 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 14:27:55 +0000
Date:   Mon, 30 May 2022 17:27:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        Eli Cohen <elic@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Longpeng <longpeng2@huawei.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        "hanand@xilinx.com" <hanand@xilinx.com>
Subject: Re: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
Message-ID: <20220530142725.GU2168@kadam>
References: <20220525105922.2413991-3-eperezma@redhat.com>
 <BL1PR12MB582520CC9CE024149141327499D69@BL1PR12MB5825.namprd12.prod.outlook.com>
 <CAJaqyWc9_ErCg4whLKrjNyP5z2DZno-LJm7PN=-9uk7PUT4fJw@mail.gmail.com>
 <20220526090706.maf645wayelb7mcp@sgarzare-redhat>
 <CAJaqyWf7PumZXy1g3PbbTNCdn3u1XH3XQF73tw2w8Py5yLkSAg@mail.gmail.com>
 <20220526132038.GF2168@kadam>
 <CAJaqyWe4311B6SK997eijEJyhwnAxkBUGJ_0iuDNd=wZSt0DmQ@mail.gmail.com>
 <20220526190630.GJ2168@kadam>
 <CAJaqyWdfWgC-uthR0aCjitCrBf=ca=Ee1oAB=JumffK=eSLgng@mail.gmail.com>
 <20220527073654.GM2168@kadam>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527073654.GM2168@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0002.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37d887e0-721e-4e7c-ccb7-08da4248962c
X-MS-TrafficTypeDiagnostic: BN0PR10MB5272:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB52720419460C20BEFA6F7FD98EDD9@BN0PR10MB5272.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4RZouvnY2sUyuwmW12sTcBuUrkRtxnR1I9bEXO6dSySKmBytYC5H/jAtT5sL8Gv8bjkT4oZOAxPDvHLQvijO38WrMekS0uyqulYvhfaJsZNZvD68+H67+furGn8e8FTdqWbVYYecBlzIJL1zV5S2W9qYm0eRsjY9N2liWBuzju5qaDSUq2vFZtD14GNIrS6SLsBnZwngMLjHqyCGEGRQx157FD3Q4b5pugnTZ0xyP2ac2KXkt/FFlR8Ji0xAtF/RdYavIymRH0t+C41CyjzvwWxTBK3tbdIR7OW4vDXoRoehyVcKEYPQJIzrY9uoU3woC7sl6VkIetCJ9AdKYxAwzY+KKBKiC6+RslXVB78Knxh3UCzNXFj6dEY1qb8HlJv0UcfIwmDxFl1FR9vnE52ZJSnyWi2Nnwj+VDz3cYoJSeg4Asp2x/z9qpL84SYV2WBJecEvymR00LsFoCopWfSgNbZjLk370zuNZNY3IDCe7ZGHc4qqJTwQi2eMgpJX2FKvNbf5gGJePsGnRhUy0yQGbm8BdNHXuOdlLmrMgsoRhtXVVKtXg9x4hyqDJ2/boE3Rs4+7K2mbloALsDUffi9ETp3CDyYpOqOBTW1BN4C6KbFnw75WZJKJCgJyIMyt0sri0W4FjdJFJsDGe6pft+OQM331IGALJh7gTqQ0jVPMbDHTvGpsG9AWPhRLZ/mRGCoH9T4Kn+ouhCMtyTKOiivh+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(6666004)(8676002)(6486002)(44832011)(66556008)(4326008)(66476007)(7416002)(33716001)(66946007)(54906003)(316002)(5660300002)(52116002)(508600001)(6916009)(26005)(6506007)(6512007)(9686003)(33656002)(38350700002)(1076003)(38100700002)(86362001)(83380400001)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZJvOYFFyqFnRaQ+Hc4n3Da1Wnp3N/M2dtCl6l6RRV0tRjIV4ccL6i+PlC8Gs?=
 =?us-ascii?Q?IwzVCVfHlphrpglDd+5UPOmLrUxmBh5jqyfsoR53spCWMLLtYYFmjLg4j4gE?=
 =?us-ascii?Q?6dxNS8qpf6ftvPcpwtVRc/DgNU/t+79dAuNzuyb+bYQDiA+th+ToU/D77jRd?=
 =?us-ascii?Q?tLjm4h3HDVbnzfbw2zN6tFr8rzClPzIakCG/o2o1LTW0E01KPQztnAhr1ZD5?=
 =?us-ascii?Q?uO6FqgYPBXoZFL9XQkegQVGix9AHuFERhNXKFp6lbQB0ciGv+nmSlj4s6a3A?=
 =?us-ascii?Q?hhD1u4rWYo+aIKD2NizwvS+haqtsP9UZZJiyjwmGpgjiRTmoNBkUfQoCHF0T?=
 =?us-ascii?Q?a94DKhy9t0FO0wNS10jQ5R3cZQ9VkgE/kiL98PRjeeA3ECAB4w4QokyYcll0?=
 =?us-ascii?Q?VcHvq6+uLPfCkc47qHJY+Yldiv4Uut4yGYjzrAk04UoUUk111STWdVHsYeB/?=
 =?us-ascii?Q?dH1vD7TDy/+vZ2Es4PlQeMxrptohCPFlERbOOU/+0uTQ9HDxslbwIdgfK+Wg?=
 =?us-ascii?Q?7vnavyNwSnwu/SG+XFjF0HS5a7KlXtSxgIQ69SHEoRdmsR6zXzfLIo83Xuqe?=
 =?us-ascii?Q?OlXnGkLBFB4z3D9U0oD+Gl72jisc5Jzf9gZ2jCmXalp+BzsUTzg9pY3zmSCf?=
 =?us-ascii?Q?gMT0hrFLIWTRSYrvxXWMa+J7LpEDLA2F5j4YKpC/NIKIT06PEBU0OF9ZcYSL?=
 =?us-ascii?Q?ac0a1yabMUqYIlfdKOe7sif2VpPmwacHpU5B7V2sZnBeW6oIO9L0hEKivRu3?=
 =?us-ascii?Q?/VXPfQWGNsyZL/qYLcWW7E4Ed1DlGSI/LoqZqQ5egQTBMQ13+b5CrXh5iUtV?=
 =?us-ascii?Q?YnTYNxTugn4VqNaS12gxmQvunZ3C35HtJBA8KNINJ6SxJnl5DykxqJLaH7WW?=
 =?us-ascii?Q?nP6vaUxAm9zuLZMMUwdjsmO8gS/Sn2Zw48UO9RWEYFqg+iy3xhgL/YHuTk9X?=
 =?us-ascii?Q?P7D1kvW3Jw6UMeRDTMsuKle6/QcIdWKExxad9KowSxuN+cbs0lA9PiDA+Tzd?=
 =?us-ascii?Q?+EjJ7VNl6ERpLJ9DQmxgKcxjunq4APznaVpCSfvYBWDKz4egsrLGJ27Q1J4w?=
 =?us-ascii?Q?OhHg6h6YuSd5TfW/xhYANbMYHWfgMjoKLhYHY0YXFiG3p/obyMPoA8nMHYJ5?=
 =?us-ascii?Q?zE3DSR0ytMW3rzwOm50/2dW1exaa68/25Blqq7cIWaCts7vuu6aBOHW/dUdM?=
 =?us-ascii?Q?YZMlSaDR6TzEjfpb2na7HOraWPjUZ/omAn7jhGSC/jAJpZTFapsUbi65O6jd?=
 =?us-ascii?Q?3Oyr5JmvbXe7rrCJjpw6ZlIo9u/xsKDVdA2ebuZC06THJ+RSnIm5LN7jof+d?=
 =?us-ascii?Q?VKuw4dABsFkUkTICqh+l3Vm1X7jnSbEkhk12waY3moLI7xhalkEDypOLtL/D?=
 =?us-ascii?Q?nwkCm8TLjJJ6Sw6GOj9Z72r03WcF04fmqc6WNBFl1VKoCuN8ukpec1p22FVe?=
 =?us-ascii?Q?pTrETf68HVfohJH4nNMdZDsOaV+fa793gb+CwPd9LYrqdAL7+f1mg4AMW7v9?=
 =?us-ascii?Q?4kAIMQWWXRnxda+sAmngN22xUE9yvvgaHBxxpC51BRvMBrHPN33xvQ8bPxWT?=
 =?us-ascii?Q?mmeLikw25i9SIb8eaFuqYpy2RvzQCtK5ooVuTRNZOzyBgSio85+JRE4hv8lc?=
 =?us-ascii?Q?vFO+e2n4D8rjmMUE73+zvfSPi0+/OO1KD293kpiX2ynGR50+wz+vKqKXL9/K?=
 =?us-ascii?Q?c/fTqocZt/ZXSxn3HOL+OtEAS+vGir9CmrA0kqg5l8EDh2QRXrrgFC42vNnx?=
 =?us-ascii?Q?VwW4XgJkZ4Rmd67tMKkf3rd7IVCtCXo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d887e0-721e-4e7c-ccb7-08da4248962c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 14:27:55.3911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IOODWtycYq4ULsympuCZ38MSIsYG20ThJidYWJKaRy2yRbbX1lWXJM9/lhdq4jQCAzUVy5RCZps5/oSTQAh6UWxwWpM4GDuaakkZwZwVvdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5272
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-30_05:2022-05-30,2022-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300075
X-Proofpoint-GUID: daDRscZ9FCioRZekyb3L16boc0TI3vrc
X-Proofpoint-ORIG-GUID: daDRscZ9FCioRZekyb3L16boc0TI3vrc
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 10:36:55AM +0300, Dan Carpenter wrote:
> static void match_pointer(struct expression *ret_value)
> {
>         struct symbol *type;
>         char *name;
> 
>         type = cur_func_return_type();
>         if (!type || sval_type_max(type).value != 1)
>                 return;
> 
>         if (!is_pointer(ret_value))
>                 return;
> 
>         name = expr_to_str(ret_value);
>         sm_msg("'%s' return pointer cast to bool", name);
>         free_string(name);
> }

I found a bug in Smatch with this check.  With the Smatch bug fixed then
there is only only place which does a legitimate implied pointer to bool
cast.  A different function returns NULL on error instead of false.

drivers/gpu/drm/i915/display/intel_dmc.c:249 intel_dmc_has_payload() 'i915->dmc.dmc_info[0]->payload' return pointer cast to bool
drivers/net/wireless/rndis_wlan.c:1980 rndis_bss_info_update() '(0)' return pointer cast to bool
drivers/net/wireless/rndis_wlan.c:1989 rndis_bss_info_update() '(0)' return pointer cast to bool
drivers/net/wireless/rndis_wlan.c:1995 rndis_bss_info_update() '(0)' return pointer cast to bool

regards,
dan carpenter

