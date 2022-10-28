Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8D361134D
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiJ1NoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiJ1NoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:44:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AF2DDB4E;
        Fri, 28 Oct 2022 06:44:18 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SBNmPG030079;
        Fri, 28 Oct 2022 13:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=eXv9YJ5eXRP8/vI4rh7TXd1Y+o6j0LOlhfNS4Ph0eck=;
 b=OiFl9tq54dThlOm9j4tJA56hlzj8ztJ5Z7mMRlwU2LYjHWuPA8iA1M2+NIqQHeBR7Dp4
 RQvghTkgtZZ1S+onFkF7bNytp4Q12OoP/IbA7zwKCIv79tgISL8wj2CDDqjm4c87EW6/
 H3+I4czhWL/P50YqoMHvBUd1UCWDrxBqqh5nxGLkuQC978ja6muAuzdbEHt1V+Qp/HxM
 Oy+2s7NAtqOy+DIq1cvYaSjULHKbIJxK8NGdG7ynSaOEtUFgCfuYvUnoP0ZdSjiJ0luF
 6ELG0oip2GLIpGiElZc6QLvsWpUyAqmCQpTUpxIlivQcyRDTQmBF16WNvFmEmuAd6YBn gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfagv553h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 13:43:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SABl8L032702;
        Fri, 28 Oct 2022 13:43:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagp47jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 13:43:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+qJ6KbqEzXUb2XymYAQNqNt7tcnKS4JMt8lyzGcJoXfqM1zgU1CJ1zsJxhG/GHVmQNYNbwnRO+1xG+lv3jM7Z7+BO7hQhs+GyWj71/BPlrV+9F7QjQUe0AMIY6gnD+uGP8ahTsusOLf88ISH3oJuYSjBq5Lx4fBBjPSTzSCBgbrr9NtKE6Z/qN1+dUAak4V1yF9XdvX/8th/rYzbYQJTtRkBsJ3wMc8XGCiqi9LQXkS5k0ezzCQOJYW+9cIwpEfn7JKkomIhq0G3ykQwfTl5HplqIG15oK3LHBkmUptRl6iWKAQr1R8hK8Xvz0uglZGwI49B2ARWC15FT7XgHMByA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXv9YJ5eXRP8/vI4rh7TXd1Y+o6j0LOlhfNS4Ph0eck=;
 b=fLeU+O51hLQAayHlrlo2BL3UBVRTWCvQvf30jQtYUPT4sOBGhC0GFfokqNDvxviNFaO1Ljh7nLtX6BgjeA1d4RM+TwXQPT9OdhaMGLevCFREXChIWElPlUElkzL0UriSZUPXS7Wp2In7w60zlUYfDOBMKb0v66rEpZChhWXSWSVK5hT7HjVjXBiT/bNNQoOvTulbhS+CH2LX1v1cW1Tg1jdBjjPOzEi/AFel4zUo0jXLO2EC538VWO7hvm7dRa4TbAzQSVsJ9JKrN+OkUXBYLQvR2JDjejUQIuER6RatwBMyWkEcYwKOoElgQ3vll22I6U5+5vo2qUiP0pOByolhkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXv9YJ5eXRP8/vI4rh7TXd1Y+o6j0LOlhfNS4Ph0eck=;
 b=ZvvHVjBCfb8XSDgHF9QrpNsgCo8HHuY4U213da0haTd8bhlkT9qR2hIXyGCF6irECCCQj1jfYrtzT5Pd1T2LQPgpggry0wMyQZOp0tIEfFjzclp+fs6xLXIwbptXDx/xyVF8NBvi6HLR6YKKDdSqat0Kl+9fRYVGIutTkjz9Ddw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BY5PR10MB4354.namprd10.prod.outlook.com
 (2603:10b6:a03:20c::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 13:43:29 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 13:43:29 +0000
Date:   Fri, 28 Oct 2022 16:43:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>,
        Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/15] hamradio: baycom: remove BAYCOM_MAGIC
Message-ID: <Y1vccrsHSnF1QOIb@kadam>
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <47c2bffb-6bfe-7f5d-0d2d-3cbb99d31019@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47c2bffb-6bfe-7f5d-0d2d-3cbb99d31019@gmail.com>
X-ClientProxiedBy: JNXP275CA0008.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::20)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|BY5PR10MB4354:EE_
X-MS-Office365-Filtering-Correlation-Id: f4642085-5d91-4d88-66da-08dab8ea6514
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KwtdMyEQk+YazD4GfgfbhEsX/BNVzY6K9FLnmOLg3rLfwO9MuD6PLUbY1XyFnA7HUAa05A9YVi3er2rMbwaQqwDIEZpS+xys4CdJmx3xwb4ba5tFG/ZOPLEMFHd5dtE6cFWgCINbsQ2j1tLC68F8tBZud3oLwA9eJl5UqxjiwJdY1mu9yocDZQYOk9nvI4KcMPRJnICZDuL8GCztR4aE+almFXRqB+b2BUn+HswS+tH/U1QGDY4G7CK3tU05ouX+A3PR79YXfNnzLDJ7fgXtcyiLF9Rb5h1RUhZaYLSkCtCqe27RDGzlnm0eurV3cSR9/X1F9uF9v4pMW0E79H5HGWI57YkzMnHb5vVyUyVjlhkbFozsVYxH4anfeDW36FcjcXFIpDTGNo5Y1JoF5gZIgcZZVtfuOyxh7AfFJEZXFLywfmL803aP3AQ+C2TuJt6vkzDczlu/3Q3+g8WJD/wosJ0ImHcKEfaLPzJk9Yl79ze6XT8pKjAM1SggA/6STXo24BTGSsP8GUNkyufbakV4Wlhr6mmrn/GiLRvqUwg+P8gNCheGHOQnInqFj5xNmTO3Z4LrO7jMDIiOUdWGrWR3bIG1NTt8llNoCMLoVXSRjbMlVt8Jt8rKZMLPd0BfFv0X1Uer98aCo4qtmm5LFf8G9n7uC3uzH+ZqgS12jO2f4ZyCWlk/+kHbZWn4lOLrhx2A7kd15PcimKNV/JKhOLTe1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(346002)(39860400002)(396003)(366004)(136003)(451199015)(2906002)(4744005)(7416002)(5660300002)(44832011)(38100700002)(86362001)(9686003)(6512007)(6666004)(26005)(6486002)(478600001)(54906003)(316002)(6916009)(186003)(53546011)(41300700001)(8936002)(66556008)(4326008)(8676002)(66946007)(66476007)(6506007)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmE5a0VXN0NVc3UranJqaFdUV0NSZzdEV2NIV3lFODh3MW4ydkxWdjJLRS93?=
 =?utf-8?B?VG5jM290Z3FpWjQ4S1RZVlZtVDV6dFFpRTBwTkhDeWJGbkdUSUpiY3crcUky?=
 =?utf-8?B?anVwVmlpVm9OdUN6dU83V2pLWVNoWlpCa2hBcDZPWGZpeGN3ODgvSUptbTlv?=
 =?utf-8?B?bUd1KzFxemw1RmF6ODJYZkpQZVdLYzBKZ05MZjZBelEwSExndlJsbjNBRzRV?=
 =?utf-8?B?aVlRemtGdXNrQXdxelcrSUxtOVdaVGdiMEQwMVBxdEFTUTJJRERFcTNGeDVK?=
 =?utf-8?B?N2RIdDVVNGF5T2FNOStIUlRnZTJCclpkWXB2bUhRQ0lWSUdVR1dHUjFHcFkr?=
 =?utf-8?B?bVdkNUxxSGpqOUcwb2VnaFFmT2VMcitKY3Q5cWNUQng2WGtmdGlxcWJvZllT?=
 =?utf-8?B?bzIwaURwRDBMU3VyQVlhWTRDMEFQSzhDYS9SYUlDZFlQUGszMzhvbnU2VHds?=
 =?utf-8?B?S0E5L284djFBK0FtNS9CL21Ra2V1RWNVS0IydHBuVkFkKzJIL0g3cDF6eVRl?=
 =?utf-8?B?VVpLWFYyWkkvWmE2OXpsTHdSNC9XaUF5SFVSYm4veWRpaExYU3dTd2pRcjlE?=
 =?utf-8?B?WmVMNTRtVFZQd0hQVkRDa2JqZVFwck5yWVhUcnZRcytEOEgyUzlQR25GVXlM?=
 =?utf-8?B?RDJtQ2k0aWdYM0ZXNkdrS3gxRElBajVrMkZLaFd0a3VydVRhYWdIQ0dXZldn?=
 =?utf-8?B?NEZzcHBhYS9vdSt6VnFHbGFGZW1QUmdITlNnd2MvRWJwM0dJRjZCQ1BGVjF6?=
 =?utf-8?B?cFFSMC9XRytNL3V1ZXFxK1ZCZ3NlL3dWbGpiS1lhLzI3ZWN3bXNpUmU2ejFC?=
 =?utf-8?B?V1VxOGtCcXdVWXVHMm5WekVpbzBnUGJxUEowNlNhdDBEcnU4M2JnU3RKcTM1?=
 =?utf-8?B?QXNDUitDLy85TFkrSUhGVEZuOG13RFVGWmk0OWRqd1dKd1FjSFJZbHJtemkx?=
 =?utf-8?B?Y2dMaWtIMkdYTzIrbFJhWHRYWmtRU1hINkkvVnpsT3lHdHBBUkdhOXJIYTBL?=
 =?utf-8?B?VHg2UTRkOGVsODBacGR4Nm5YUnhydzR3dXBsK2hUK3orZmhKaWRpblBuWXZE?=
 =?utf-8?B?SExCUzdJM09ndHVMYWRIZ1htR0JudldwNG1ZRzNuQkkxbXdzNmhPY0hOWDZj?=
 =?utf-8?B?bC9LUk90Q3pabWdzZFBzTjdLVE9ZNFZRbUZkMTBqb1JMbDRUUyt1V2REVW05?=
 =?utf-8?B?K0RFa2s3SWZWa21oQ2I0bkVuTUFHMGlnaFc0SnBZdlFoV1VDT1BIaFFrUmZm?=
 =?utf-8?B?YUtqdW8vdEcxcDRCWVVJelBzTkF1RzJmYUFPdm5YaEczUzNTdTBZNjBQUmx4?=
 =?utf-8?B?NjFqdlRGaUxlTzkwbWdBOU5HYW84SnlHRllhK1FNeDhMc3lYNXpHOTF2NkZV?=
 =?utf-8?B?ZVUrTlB2UWt2L2hYRGQra3J3UG5HN1hvT1hpUURWVk5DTXBodXhMSUVrSkM2?=
 =?utf-8?B?VWtrVExnSWNtQmxZZjZlcklLbWJ4NlFEWlErcUtBNitDanRpTWVtZXg2TzJk?=
 =?utf-8?B?Sm1ndXdDZnk0STUwc1lqVnZscHdyUkRaRUFKWkVJWlhDeVFRV3ZQdjQxWEpz?=
 =?utf-8?B?NzR5Zkd4SlIvcjIvSVpNK1Z2OHRiKzdNeUZ4KzRwSWJOdWgzRGt5SWl1anVE?=
 =?utf-8?B?Wkc5NjB4czNtQXdyMVdEcXFjWklGZjM3VWtxY1cvdERXQzN5Q3pvTG1VbE9w?=
 =?utf-8?B?dlJCU20zWVNhNGF6Q3BvRGFxZGVlbHFVcytNZWZheW5TYnkydU43SFczOHhx?=
 =?utf-8?B?d2lPbEUzVE1PNFRVNmxqNmhhbmYrQnpnV1YxNG9xUlRiT21reCs3UnExeVB4?=
 =?utf-8?B?WDVsSHJnamRSbi92S0p1UXZnVGNteDZWQVFHSmJUbk5pU1JlVUpVOFZSTDRy?=
 =?utf-8?B?TnFlVkcybFFsNkprYUttbjRnRGdSbHMrU3FSYk9SZmtmS0NuRHZIWU5yNW9n?=
 =?utf-8?B?TVNzUFlpMG5OZUEvbm53TEpYejRGMDkvV0ZHM282aGZNUlI3dm9XVVhQeHIz?=
 =?utf-8?B?NCs1MVZCRVRNRFR3UllrcTFnWGNsN3JpTU9tZTQ3TGNKWkQ5eE5ERmxZdU9R?=
 =?utf-8?B?cnlseDlrbk9QaXRoQnRzRFYralRDeWU3VGxMWi85aWhmY0tmMVF5NTF1L2Vk?=
 =?utf-8?B?VWhFMUhVeTQ2M0dHYk1QdU5kVUQrYVhsVXFTMVZZVDNBVmI3cjZxdFF5aGkw?=
 =?utf-8?B?RHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4642085-5d91-4d88-66da-08dab8ea6514
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 13:43:28.9508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CTZkvXyYGTOQeAdyapbbZvUyYyTtdTm2ZkT15Sypetvzvj2THJiibDHLPgi0hjWdOXBe4xtEVHb3gRTBC3QiVrsqXBDTCuhQZgEOLtU4Fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4354
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=912 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280085
X-Proofpoint-ORIG-GUID: lLDe-3qHVtAUKfO7PWU-yLjwHHZeGbli
X-Proofpoint-GUID: lLDe-3qHVtAUKfO7PWU-yLjwHHZeGbli
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 08:13:49PM +0700, Bagas Sanjaya wrote:
> On 10/27/22 05:42, наб wrote:
> > Since defanging in v2.6.12-rc1 it's set exactly once per port on probe
> > and checked exactly once per port on unload: it's useless. Kill it.
> > 
> 
> What do you mean by defanging in that release?

I was also curious about this, but I accidentally sent my question
privately instead of to the list.

> 
> Also, s/Kill it/Remove BAYCOM_MAGIC from magic numbers table/ (your
> wording is kinda mature).
> 

The kernel has almost 13 thousand kills...

$ git grep -i kill | wc -l
12975
$

It's fine.

regards,
dan carpenter

