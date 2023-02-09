Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79091690CC4
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjBIPUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjBIPU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:20:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0270270F;
        Thu,  9 Feb 2023 07:20:27 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319BO67h014329;
        Thu, 9 Feb 2023 15:20:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=MbWLhbQ1oLHaC5/TrUb8e0wMYld1xFo1o68FvY00M5I=;
 b=PDd46ruixxZL9ij1J0LpZmWpeLbCH9Qnuk0q+W3+i6KNdVuVFhxPy3hU/I9sAoxN2IBn
 C8sIcBigfBDcGuXW1N81YA4g8h27+XRT7ie/ftEJryWcp1RpJFljH3yG6GwPTDWv0DgR
 xds/ag83Y8kxK9XpaxDGKeiJTWukdQhTWR2dtyW2uyCrCcAA6bv9l1Y4/IH+PlHFDx/D
 KF+tFIBxUzLGdiHxeQ8Q5F2b9Tj5m+vbjcIZJyMUN18MP4niWNOPLt3Cbeqa3Peu1uVH
 s3Y45UmehO7cXxzYZQxIqFOXRyir8F6XarPytOoaB5x1rXQvnN8BX0pwI7JCBA+G35Ib 1Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfdck1be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Feb 2023 15:20:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 319FHg2K002663;
        Thu, 9 Feb 2023 15:20:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtfg484-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Feb 2023 15:20:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDAxKqDshDqvGJAKcOzwPp74lznKC8lTQxUQeWJQfjY5xHsbNpweEF8WH/yX/NgypEqDMnkRfgeOtwfxMiR52ke5m6ax1YMRA0MqDtCMNjKbz7DOyKtu8AmylBHhjGQzhahFYzOeMLX+dY8tJKzMCvWVlHaAt+Ug5vTfOCjE/TRrndrfpDtg0ku0eVvVCN/vRitlDfuWC6lUFLhCRpusRUHDOQTeto4AAteF+4GJI7zp0JNjQ5VwX+VHs0ra9NKqMe2T+P5ZymiwljOcar+vxluT/GRcMYQz1VqrTpNPvsRhFCPoSK0AZ8pVPEqHKBAKd+ueqHxUxhFN4OebE0SXSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MbWLhbQ1oLHaC5/TrUb8e0wMYld1xFo1o68FvY00M5I=;
 b=FRHvkGNnOe9N/bpkTv/pEe3Bj7Ea2zipYt65YE7kCHbNcojuWBEf6XNZgegEXBEYItg/vvQPWX48jKksc79ddhNJqdFGk3SOAPHk9ckLRdOX6U293yQWhq7/fWf5h0rZ7+NW3ei1FNS1pY+8JFh91FcWHsW1EAZK/H4sDH173x2hY1AhWe/OcugA8JpkWCdnntq9lY9qZNLg73Xpv/ZxLaa+DalNI9lAshb0ZMSFiMIBkhUVdIefMXMa2RXNs9kANymtFqwgbDOz86ZNgfukrk3a0lOTY2OT51l06iJ2oj9wfTJ2Ip7qu83JbtqHyAskW57ejVc/0i87b1RN/G/5vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbWLhbQ1oLHaC5/TrUb8e0wMYld1xFo1o68FvY00M5I=;
 b=iT6/yXhQ+1XS8eYtSVuoWpJz4KPS8RWELj4SoNBWdhDJyZFgZbxmxE91Ui/icrP40+xNFfdpu3ynb9eDrvsE25fM5g0pJorCN4gs7j5Id1EEdSPGV56XTMFswk2menA9sL2DEgQAAwOdkecg8U5M9oo7a8yECL8OaXjIvR9/rPM=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by CO1PR10MB4499.namprd10.prod.outlook.com (2603:10b6:303:6d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 15:20:08 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::ae2:4810:d708:fe8b]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::ae2:4810:d708:fe8b%2]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 15:20:08 +0000
Date:   Thu, 9 Feb 2023 10:20:04 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, Mukesh Ojha <quic_mojha@quicinc.com>
Subject: Re: [PATCH 03/24] Documentation: core-api: correct spelling
Message-ID: <20230209152004.n2tk5wr4exnah7xt@parnassus.localdomain>
References: <20230209071400.31476-1-rdunlap@infradead.org>
 <20230209071400.31476-4-rdunlap@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209071400.31476-4-rdunlap@infradead.org>
X-ClientProxiedBy: MN2PR20CA0065.namprd20.prod.outlook.com
 (2603:10b6:208:235::34) To PH7PR10MB5698.namprd10.prod.outlook.com
 (2603:10b6:510:126::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB5698:EE_|CO1PR10MB4499:EE_
X-MS-Office365-Filtering-Correlation-Id: 555003b2-aac9-4d00-b9ce-08db0ab1210a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7zYaqb5RtZsqJJYXUAlx4xb5Otnbe4XGFPNL+Ts6VmfUKqYS+O/owdtgbCDK3D1Du2lhH5jm0Z/018/WHYigYEvQj0S+kUQbZuw+h2tBMeKj+6Mei8hfEpF45KRU6ZVppHhg9kjaoTGNrlfgCXCKh0/AUMhRN6+gp+s3Ey3M2wD8FUWuWa6shv/QBnZ3knBX2RvWqV++VTSS9coy51Y+BvQWIahF+yk6lEag7Fha6JEC1UEefpxoxpjHZ+/Sn57twsGxgoWzpQEWHGsEUWjKPp/x7o1Fe1ikVuP6Xl/YbVD7kiMOmH2tmMtBtIbJnl3hxnGj5qLHNXzhzN5G07IjIFCZfWsocK0YTfLuLF44BM/nIzmg11pia+Czzy2SBAo4oegCP97GUiReGaR9VjH4R/4CltdMOrtgbp9lC9S9wOQORU097ThFcy3p1s945aC2SV9HUyvcZIiEUWOTQLPAdFSUXciJz407PtE3Eo3gmuvYcOJgu8EclVED78jfpkiPhDHu0zHRmHXDw05YDSieCK2T2q9Xqhxl2aD2OUfocTXAnw1HiO8xX2GLfdBXlwx/7AcAO1NMWvN2R+XPugsihf8IsPVCVK9OkpIFFq0P4vbRS8RzeYFYrqYHYsxnwn/pGoA+3WmhgKXfJJv2oW8bqa+q32ASNzhd6fnublKsOPd5gRXgJ4hYf2pKHs1kmYHs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199018)(83380400001)(2906002)(26005)(186003)(6916009)(9686003)(6512007)(6506007)(6666004)(1076003)(8936002)(4326008)(5660300002)(41300700001)(8676002)(6486002)(478600001)(86362001)(38100700002)(66946007)(66556008)(316002)(66476007)(54906003)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LNQvphLeVqWHU7Qclwcs3LCMXjFAc7sfPTk6ky+gmDSJu8wvT9AArlf1CWLh?=
 =?us-ascii?Q?9EI2HEDIYA+hNhUNhiwchkPicO66883FVWVvex+fciSax9WBO0midqcC/ARK?=
 =?us-ascii?Q?by+y/lWtR8HCyaibY36OPbKWy5Yy59b18b+jO0HdhpTh4A39HHFIgrPrOJ0d?=
 =?us-ascii?Q?e5jzFzMNTihbvDBJuKhgUv97ZtpF9NR7ozJjpTPhGj5rBClTSv0cyiZGx0fO?=
 =?us-ascii?Q?5lSmDIwfYxPXoTMiCee7qlFwDrJCOWy4YHl0UJkQcAVkjr8G6vt8Tx3ePWag?=
 =?us-ascii?Q?hPHu3YW8rlh8oZhOPe5yOIVj9amNnHziiD46MRyvFiRMp3ZE2o4HKli+Tlk6?=
 =?us-ascii?Q?co+f69U3NwpnbdYHabqmMq659SjnhQDWYEGHjfV/+yTH6WwiWFaZIYuNBDqR?=
 =?us-ascii?Q?ySWKJO8GPRFRI42LyyfpXcJd6EA9ngZfZV9bc6BUWfk4PRzNT3438K4M++c3?=
 =?us-ascii?Q?U/Cu6wSEhQ1uKNiNghLVVqI36Wg+NMKsy3KQx7v24aT5+IYzxI9uoCFdooqi?=
 =?us-ascii?Q?OWRFG/eApossPez35QueK7QqydkS+cfmdsqd1aU3AOmPWs+zxWHwL9glxUNU?=
 =?us-ascii?Q?yeUukkW4/07XeFx1KsAlRc4oerG27BW6Jao3jOtPHTJaMXzrbA8+YO4rLZwF?=
 =?us-ascii?Q?pzSWxCGss4ABc+mZpx8huAHCuPvV9BXdEek86Qi/0VjVBP0jYLzV85FITE/s?=
 =?us-ascii?Q?9Va1QeHyqQuztWCn/eu5FK6AYWwN7ngxv36m+U2AeLHPYAifiEkQ0Fax0jNO?=
 =?us-ascii?Q?tDKSRKLhjNxlB8BEzLRXuUQ8+KiDYveuryxqQsVnTLbdf3sR6RNxQtoSfCX0?=
 =?us-ascii?Q?1MIYD06EfzYnGySerQGLVP/DL1Hek+0l+gChCj4J5n49sDnV3Upmjfhq9hN5?=
 =?us-ascii?Q?IMLso9GB+pEHOZ2Le8GUIhMWmv2HgcCjVsVTnaVqgHiw1R44qosw9bAYLYoY?=
 =?us-ascii?Q?fiH0d9oZQm0l4Y8jBLlunf5DSujMB6qQDTtx0Bry5oWRWnSlRnHxfI0XkZRM?=
 =?us-ascii?Q?xZdt2R7OrMJOn7oFedufCrC/dW1cPATT4svBqu9N3VJqEdnatrTeJQygUBF2?=
 =?us-ascii?Q?BboiPDLiwhe+PnDcMrUi/Ub4FOdZ8V84XRN/+HKfLb4nJKJj8/luhlOod2+R?=
 =?us-ascii?Q?58IQ5TkHh1lYHP2KtZfYluOccZvcVlzSvPZ86dn2s5BZfyofzMT2fKf01cIm?=
 =?us-ascii?Q?f1+doLV35pW0baKEu5t15m6n/tgPQqf2FZJvJ/AOjfyuxwsEKAv29/6lGBM6?=
 =?us-ascii?Q?7/LnXtYGuLXiiVjeK0NOsQ0C8RDy6f4bNmCYkVtfVBHoOeCPQIdiuiNwrlOy?=
 =?us-ascii?Q?y7HAV6EleWMc4wTExIJgVjO+X3zLEMj8MrnbX/2ug6opq1vW1BOMT+qN92wN?=
 =?us-ascii?Q?H/HdH9vt4nvTRPoTijw78ZxvWZz2s/WPM+1oINF167Vr9a3QpdKgWRgKhAqI?=
 =?us-ascii?Q?S9hxBw9z4Oc5ITgGmJqtihuTsu+lQUhQKpy2idM1CEFFJuvWOxHx94FnKsgh?=
 =?us-ascii?Q?9Xv2+1GBrqc/RZg0hniORy5SCW6cphWHpxn0aVyLgIdmaNmiCYwXGvlhBxad?=
 =?us-ascii?Q?n43QCEbupGOQyWzhb47W8vzrTfKInQS+PxCwYbGBzcyh2YNb+B9iW+x2iTHR?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zFak8G4H9RFu1zAlnwwlWr+GM14t7KQSrm/WFpHzesdGHPH/K6xuSkNc7Ef2/k4fL/ijVklfJJSXjUlLHmy012atvckUcu4CNPzaH07OnjC9BME7wIee5xry1EOIgwCa+slwHgLMeo+37W5g1tzCs+ABLj1mvxw9s1V0carfl1jGBEE3vV6Yznr0D+QfapEwEEgJwfWeqSIZxHvlV63vsDRdIbiDyBmEbJJGZCIcjG+FbURfo264uBENUH1OxpjPXMfiXeB8Ujk5cdlbASrUcs+27jspJXpMZ9CpGjSOJCLw0mbdKQdlJmr3q77YBzeMKAq/271bVm2GTm9JBntHfc+T5XjZclX8apgkcfrv4GFfELGB/UDJW8HI6JnHCRSiodAW5u901WYab8A79B4yieqIj1xsrTZxK88d/qVLzLIFhfJ+gKThpwRdeZmrHolccuwWxlGQqLX6P9v2ZyVdqHHJICkFu2K5g6H6CBqqh6D/aAO5VQU7ld94iDUJ0i5XpfdY9ofTqSxIRqMhwO6aEqciyABUDhZJzYIAqmTd0XIOn6NmKpv9Nq9V6d1pmLmhz4DFyvm4R04gHUlKWAlho9VLNwJTVPQTddfUIWADFWr2Noe+HkK3UYbT0dKSny/xi/jKyOoxurWOL3msC5H3cP5iPC0g8vOVGS7O6giue8eVlJNAiA0kM6pgtiBmD0IyO2h1diWaH4DQh+gT0ueAAy0pJ2ibMS2TrIHsUZrmLy6cQcFtzUzYIjWrrehDqaW440tJG6TRiRsZZAXZq3AXeb27Fp5LX0zorRsDKIXS35qZH/WNMyiVo6XFcyFWEnN+GuzqfH6APMV9J6pSuSE061jog6RliIqFzjmtyA6mWsyzrN7/9SBNnK3FsrMuxHtT13wF7jOthbmOgPb/QxzVmg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 555003b2-aac9-4d00-b9ce-08db0ab1210a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 15:20:08.4928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rSjxS6fBLe9PZdzECAsRyWHKaAD/85Hn8MGinjmGhuNoNHG1gpI7oTfAmOP0uI6GSIhkymCA1ss6HpHrD7dPPxVfI07TP8vky8Wztg2kc5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4499
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-09_11,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090146
X-Proofpoint-GUID: uKHdDLTjp1l41sppSd1WbJdLamaQofmH
X-Proofpoint-ORIG-GUID: uKHdDLTjp1l41sppSd1WbJdLamaQofmH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 11:13:39PM -0800, Randy Dunlap wrote:
> Correct spelling problems for Documentation/core-api/ as reported
> by codespell.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>

> ---
>  Documentation/core-api/packing.rst |    2 +-
>  Documentation/core-api/padata.rst  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff -- a/Documentation/core-api/packing.rst b/Documentation/core-api/packing.rst
> --- a/Documentation/core-api/packing.rst
> +++ b/Documentation/core-api/packing.rst
> @@ -161,6 +161,6 @@ xxx_packing() that calls it using the pr
>  
>  The packing() function returns an int-encoded error code, which protects the
>  programmer against incorrect API use.  The errors are not expected to occur
> -durring runtime, therefore it is reasonable for xxx_packing() to return void
> +during runtime, therefore it is reasonable for xxx_packing() to return void
>  and simply swallow those errors. Optionally it can dump stack or print the
>  error description.
> diff -- a/Documentation/core-api/padata.rst b/Documentation/core-api/padata.rst
> --- a/Documentation/core-api/padata.rst
> +++ b/Documentation/core-api/padata.rst
> @@ -42,7 +42,7 @@ padata_shells associated with it, each a
>  Modifying cpumasks
>  ------------------
>  
> -The CPUs used to run jobs can be changed in two ways, programatically with
> +The CPUs used to run jobs can be changed in two ways, programmatically with
>  padata_set_cpumask() or via sysfs.  The former is defined::
>  
>      int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
