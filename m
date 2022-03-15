Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63294D9362
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 05:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344800AbiCOEfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 00:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239466AbiCOEfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 00:35:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F60335844;
        Mon, 14 Mar 2022 21:33:58 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F38Ntm019883;
        Tue, 15 Mar 2022 04:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ldi62J4Ff7yhCr3jQU/wooi75MxMT2ZMHuJhgqU4Ceo=;
 b=ExlwCuAxR51v6gTbwxWKpWwKn0YpXZPnYEe0OJKf4GcfDTDmUg7yYlTfrlkDrcEJlMTl
 WSz3TvYwAeFNfrTEuMERPzel8DtN36rSmhGQ3X+vuzwoyq06LTyCHGg0TtuZ7GKn57eK
 avt2PjSn7BS7stRbDdMxIMfJOl9uRhkaw/9zgNc7OZ/cOmP4xgUhHtfiI3onBQUJ3I1F
 /XD1HNITRWvFDWCDWG6CDzDZJPIHWSyk/I4coAom4bNJY//REldRvOm6QDr1USW/Y7hy
 SGfBxUqSxx9bv3j+hmuxu+4v0xJ7aMSnVTnCsFv/h/Kv9d3uIlBujlf9N4ogQUvFzp39 Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5xwhxfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 04:33:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22F4Gupg187819;
        Tue, 15 Mar 2022 04:33:19 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by userp3020.oracle.com with ESMTP id 3et6578ert-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 04:33:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ca7IPDAHjCIqEVa0mHtecY6dG7fqX8TLCztCddmeZG9LGM5KIG4l2h7X6VcAE7ddUrATdH5eN+Vyf1e2p+xW6yKOe7/EmtuvONcv1ZTWxqCPf1QWTi0M8drT2azGiMvE4UBeNYD9s9Ugv32DAlV/Ho3IMcCMn2Gj67T6M5HP1u6FlQhTH6N1qkI7sfmLewFw8xzZ+s0sloEDcQh/ooLp+EAfyJep1JMuDWk5o8q2lK01UaBkpZk8nW94Is4Vd946LS8+BiC9EXPAC1UBB0kWZnc7tHVieetT9z/BylIVbBdOat1Pj3QB547SBjBM22gbo/Rtz7MN82bYOIsk6i+NQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ldi62J4Ff7yhCr3jQU/wooi75MxMT2ZMHuJhgqU4Ceo=;
 b=FOJEAA2+CEkH0FYfk+ql5xL1OWCB97StHjWDcScX35mBFFh9SIZmqvjAGJqiK2jqYFkITZMViaY6mk3VBd3QGUqSRc2IrOr1nRnro8m1K5r21UQXABl8O8834b2lbqvimJ2aWieVkYehVdAyQAJHOPgxYfJMDarpTMwp9+GA9tQ+EgWZqSIwO21XSAU1NqhOhCSiRoAip7xeC9zIilE6Nqkmf0g42zvhYj1Kk2ZcDIW8VZi8ThaIazyKJvKmjzgVceCXeabigfl0/HoCx3womodvwmaPpbeXSL3EkEpflS1YnaFfvKK8RKddApA7NN2qZCJowpluAWqBGF4FUF8yZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ldi62J4Ff7yhCr3jQU/wooi75MxMT2ZMHuJhgqU4Ceo=;
 b=jTriNuVobyaDDyHAKckeANzwO8h1OW/Bc1nlbWLR4utXUprp4ZStNF7qW5IHaRQPNmhqS/AO2elLQwevd/8tuLMXbA4qk9yrAJvgnZ66g5jxP4MbKCNd2bOTbMqSc99Lyt64OQCFtHvYahh/T+CHM7szAGSc2JkxkVrlr3/f3v4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5028.namprd10.prod.outlook.com (2603:10b6:208:307::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Tue, 15 Mar
 2022 04:33:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 04:33:17 +0000
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     linux-can@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-spi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
        platform-driver-x86@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        linux-leds@vger.kernel.org, Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-clk@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-rdma@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        linux-power@fi.rohmeurope.com, Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 00/30] fix typos in comments
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zglrbztt.fsf@ca-mkp.ca.oracle.com>
References: <20220314115354.144023-1-Julia.Lawall@inria.fr>
Date:   Tue, 15 Mar 2022 00:33:14 -0400
In-Reply-To: <20220314115354.144023-1-Julia.Lawall@inria.fr> (Julia Lawall's
        message of "Mon, 14 Mar 2022 12:53:24 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0081.namprd11.prod.outlook.com
 (2603:10b6:806:d2::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd5f9ca8-fce4-4820-e21a-08da063cecd4
X-MS-TrafficTypeDiagnostic: BLAPR10MB5028:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB5028127E1E39C6C1DCBF78D48E109@BLAPR10MB5028.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lIr1rn61tLrVbwe/rkp9ZS/r+tAe7lTiShG8NUYZ14vZdHOMPNbaxaGRcBo6E2TCLCl5Na13o3wqDPeNU5FRwDRU66QCiuUTZgEhHPpf5WDGBZyb2J8kZ0hk4d9pTDz/JlhJdAMrIWwZkgUcq1B4T90Ls/Ts723KZuKhEbfxtqlwHPLaEl2eDk7FOIuYE83pynWqfxAnsknZqFXuxBq6BFpnHlIzCLLOwHKGwbLdPwCtxf7fEJUbQeZncJD102rFGdjXSkCAnau1tQV4ENZE/A3GWzT1nAoVmORJQKMXBPqjYvjnz+rJW9ALDhoLZYyWf/8hxCsfXKgkBnKuJ49sUz2lL4nyUeY5Rgc8Hnh6SF4hkrqoSxI23CL0bXLh3YZoosxSrQQftn5kUlMOyC8/oIFsdR/cujF6fMilrpkZ95v0YxFbhTrXrEeEUA9iYEU53vBdq3JXwv3rSmFfWh0hasP2h86ejtOUkBZ+jYO6RVTJaeEX/welJLNeRSdGUuvI5dk6gaP7swmia5UzA/rLJzZigd8JsRFs0876/JE37mmVCiU//WVsNwxVT5Du25b0lzQC6E/91/vLT/n3F0BYtdRsTrU3R6FfGMruE3ZH2QuOWKaU1kwUaQlHcYhLIQ57VHP1dHCEKwBjrziZ9/S0qmqQE1KXN2VDexHqK/EhW9XBW7CdhvsnCZF3r3OB7vUqZo26OiAUJP1b8AWwzlau/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(558084003)(6506007)(36916002)(38100700002)(38350700002)(52116002)(8936002)(7406005)(7416002)(5660300002)(6666004)(6512007)(86362001)(26005)(186003)(316002)(66556008)(66476007)(6916009)(54906003)(66946007)(6486002)(8676002)(4326008)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WYqdkY6Mseq/zoJXKJt5QO5ieNGEvzdme7kIJIZDXe8z95T58HJC9392QsdN?=
 =?us-ascii?Q?ejXkgq0syWYUon9U/8Y7Z6ei02SaQ9oTec3FkWvLm9Dw18fxeFmFumc58Syy?=
 =?us-ascii?Q?i+qOPQzKSYbqhYn6uyYrwpV7fCBr6TmytjEoNeS+08JJcLBp7qdMVCVzdGSh?=
 =?us-ascii?Q?W8V0gHrzEj9W8isXO1BqpsVfh6qrlq3EZmsIKaWIMsiL91tV9RNZAXMAT+yB?=
 =?us-ascii?Q?6Taw4E/WP9T0sL21jSqA8FqKpbv2XK4GHfl2vOv5M8AJI1S2097GZnDccZTW?=
 =?us-ascii?Q?xg3whI9AjpYpuBRZ46110N/DxZ+JW+cvoifkcoQJS3pjem9X9y5uFUOI1bvh?=
 =?us-ascii?Q?kTKbyrC19iH5Tak4z3X/yP1bI9jhQrCmBaDbubcSstW0am0sEaO08BmkPWg4?=
 =?us-ascii?Q?8RrQzCEWsd3QLY+lWtM4OrIJxF6pAunNPS0pZIYWNg8BxoXuFYLR4u+AqFPf?=
 =?us-ascii?Q?dU55vsPpvNM1E4T2hW1zz90ewEANY1MWfOg0RFwmHqzM+mpuAGZ+uyDfWyJf?=
 =?us-ascii?Q?3kRLLhXGd87GYUAfdHMlEUheErUcnPMjRgN28yRnVyDgiPsr3ypwEXbGw+a3?=
 =?us-ascii?Q?Jz4dLJvgxpFfRiDQ+OhECQUNsBgVo6L8ZgL+dnNXY9t6FQPZYfLmQ+cLSJwj?=
 =?us-ascii?Q?jl4H0zj25gS9S95s1YjusMvTNqhrFf5BMyR/S47DggMcvak17I+gPBZnfpxi?=
 =?us-ascii?Q?WwDvsiF64/G7PC86zW5pdiu5DQOwFANRRLzs7/G4oaaYx2nOCQX/UxNjNhSU?=
 =?us-ascii?Q?Y762IVfeGGZHOY22fpJyW3CMpqZuXtaLlFK7j+MOc03uzZEQMEFLpPWabgtq?=
 =?us-ascii?Q?4v+ztKL/2dDEa/llO815m/9bSPLKlsErQ0iqkkGfNRkqoX0mfjKLnJTjTiU+?=
 =?us-ascii?Q?ZnuZJ4lu12xFF0Bphn5IGLgGXDhsYwPrIkMYnVD25TSJvKrPjdo9REndkuln?=
 =?us-ascii?Q?K86h1u4Hr6EcmewHrk36Cs4BB1PiRLJPfq8YKEFdUjb0QRSUu/tT6drOtUty?=
 =?us-ascii?Q?NCayFuhfgvMSTk/0VYCKwZhcM93MUBRjhAGY3j7KNzE96bIY3gYkba4i8A4r?=
 =?us-ascii?Q?bY0MvYxsb7Bk5V5FSEacBzhrhRRYt0Ho2TRPIYMiWIeXJZWNFx+p8l1WS34u?=
 =?us-ascii?Q?xTPgXw2sM9cxd/UG7Kr3CNegrseZXcW3e48pzZA2mh728nyHTuKhT3tNL5v0?=
 =?us-ascii?Q?skwvOAYmjzjAcuOo7y0UnbeO7FLxCW1oh+KYHLFJK+BiMJ85xLV6z20UbeDn?=
 =?us-ascii?Q?0EF8tLZymXYjqD1r64o0ovK9j1Ks73SE2OxW0m8YrzMNpD1K7baL3oEidlIX?=
 =?us-ascii?Q?jKgt1RiGr9TZHqCbGoIEpx/CNRXGrCI6badUa9iGhdSiNwfBhP0FnZYfS+F7?=
 =?us-ascii?Q?1HmiklAMhxjy05xdm2o7nvQ9cZaCvSWwxCk4qeIQyYtHb2y+ZUdBjjzDbsAt?=
 =?us-ascii?Q?Eygq6u4UFECMqOQCxaOd+dlooWT5Iu5TgDZ/WtDwJwyJPrqidTO5Cw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5f9ca8-fce4-4820-e21a-08da063cecd4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 04:33:16.9101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jp1TQ137dJS0aBKzTXtG8DTrjUrlcvwsR3Rv3Hwv4WYgucNthzTxAX2MtM2dphZQ2UWnLHml7Iywf/+efZWBApDZjzpofxxXtMMYd6zKOZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5028
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10286 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=792
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150026
X-Proofpoint-GUID: XsDWZTts2S_zEVh5fz9KD5b_DHEyjX5o
X-Proofpoint-ORIG-GUID: XsDWZTts2S_zEVh5fz9KD5b_DHEyjX5o
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Julia,

>  drivers/scsi/aic7xxx/aicasm/aicasm.c                |    2 +-
>  drivers/scsi/elx/libefc_sli/sli4.c                  |    2 +-
>  drivers/scsi/lpfc/lpfc_mbox.c                       |    2 +-
>  drivers/scsi/qla2xxx/qla_gs.c                       |    2 +-

Applied patches 2, 17, 24, and 25 to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
