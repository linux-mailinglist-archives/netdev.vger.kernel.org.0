Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413E257C4FE
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 09:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiGUHHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 03:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGUHHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 03:07:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E77C77A4E;
        Thu, 21 Jul 2022 00:07:53 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26L0pcXU024995;
        Thu, 21 Jul 2022 07:07:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=0anNjqchislcWtvZupmdwhJZ1b73sSmmRuR7SRbJcV4=;
 b=Xhq7gLcXbxVvq4oge+z59UnTChcGnf201ElybT5+t0gs7BnxazPbVsYxTkSGB0PgGxj3
 MbQDxRviOa+Hx1xjFAzux6rj9jtgaTjPi/e+PKs1mNx7AHRdFHxlsZb76KEWLtBNIqhw
 +LwfTR0+Iq4rT0QEN8/HSBHn2HcjP/Gx5IGT4B6fPbDjwb1UsYFie5UfRjtuqTLvWBpd
 0WkWcRtQKgyVbgwEQoifWsj+BcrZNYnI4md3tMJTx6tk5Rctl45j3WkGYcDZgObRmogq
 eJippLz3TJUFluRpAZ3OJfJeTmFasZ49fm12rasZR9pOgCbnr828dMcO9jDSmxCA5e5r JA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbnvtkmmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 07:07:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26L5jLZI007944;
        Thu, 21 Jul 2022 07:07:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k4w0ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 07:07:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VArX4+Cye+ET4uio7ZVsHQ+z2tD4VyJf2G1JZ0LHoFH0evpoZEXcNfYb7gcGYbS83YAMaFDD0vZxDOIjAxaXwCq7ceIaT0vdmMfKodm/dqfz4zUbBwx9gMbMeBavsi9PkYdZlfuvhIaWMnlO4BtNyFbCAugVvL9ZnD1luisJQFEd8iHkz9HYBEoGpZ9NQBNcRNd7X48HlHEL+0u8Ty61j3f5i51t/rRQlXKDhojS0jmJjWosRpemGTLU3xQLPysUPB4Nl9OLW4w8pjoUEm3DLnMD5WSzRoANPdArmg+QI3LUcM06GZdLvJ2Fsn7uweCWbGBYZ2vgqBJZlAHJNV5I7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0anNjqchislcWtvZupmdwhJZ1b73sSmmRuR7SRbJcV4=;
 b=hmMrQBnwbFZeJgLRyIuwR6xdyTOiV/+csDb3ncXmCBXjBCpmAKxkNeKGQ8JH7D8WONsgZ4SQzk13tViGtYwq8aXZMDcIJWaARElS4Y4hPeQlJw9RtgjiraVoIaiHoz1ldTAapmfWV/vcireIZgeW2NIhoIyBc3e+wgznwqZCq2zde4PRwbk72KOOrc3i+BgESq3X2GjLZQlYRA97sZNLk74Br/sms4DdsOspqHJ7fvstZyApPtojPa3UpaOwF/CkrTRgNqVOJXfDziRFFIZmdi+yMFuC/E0nTqA8r8NCM63LL0XZ9GFXMw5GpwbYnJDTWE3GL5pDvgGcwZasfC91Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0anNjqchislcWtvZupmdwhJZ1b73sSmmRuR7SRbJcV4=;
 b=HT0hNUL8oGtAtj3ar9pJk8UI4pCquf3NpjmgNjuVUYk0JVL8EjyoqGQo2g3Fk54BteicVUJmQKAKLFeCYgFXQ4gaaGvZtW28nYtYhP6pwjCLSah8TjrRJv2As8ZbTNwHynxfEmq7loI1a9gZe5LWdTy7yTBj9fAl5l9wHVAyIac=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB5497.namprd10.prod.outlook.com
 (2603:10b6:610:ec::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Thu, 21 Jul
 2022 07:07:19 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::24dc:9f9a:c139:5c97]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::24dc:9f9a:c139:5c97%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 07:07:19 +0000
Date:   Thu, 21 Jul 2022 10:07:07 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     xiaolinkui <xiaolinkui@gmail.com>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gustavoars@kernel.org,
        quic_jjohnson@quicinc.com, keescook@chromium.org, johan@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: Re: [PATCH] wireless: ath6kl: fix out of bound from length.
Message-ID: <20220721070707.GF2316@kadam>
References: <20220721032158.31479-1-xiaolinkui@kylinos.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721032158.31479-1-xiaolinkui@kylinos.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0059.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::9) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e287be99-e216-43b1-b702-08da6ae7a65e
X-MS-TrafficTypeDiagnostic: CH0PR10MB5497:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FbxiIB7oDRXlbutDoT9T3V1fVRZv7xDb7uK0S53ryjXX8DdexGa4/Lh/NugUlhPBI7KcHFLSMkL2vMHJyN4CyZz8S662/eu9CvttmJzPTRyOequ/14kj9dOxPPmaAWrVycUjXgSeaL5RKZej/jWl526et6NJqORyy/a5BUkzIztdQy+AiJiVh84PpZcfKuHasC/VEGKvEUO8ETx1edGtRYwh1R9RJaQHAKvPZV1l/cAHKVXx4zp033H9vkwRhJvXn3nKRcmu2P7IFCB8fxAroi64cVRY3uGwAuFp8NTTRX+e5UmOnbFmVsnBmH8TXDMseeqI8Fs+Ezx9cd1dvtQkvycU0Qgdq/fOSp2GkTGbSQEzX04Uw7RW05xNhnJFZCoWXmwd10OwCR+RhfP/WXUI9DBVePoud1Akh9hX5Di79Xtst0rY2SKMij/6kXKdjmV6WWNFbCuwYrH5uWJtZtFlS5PEwWloqTnBT51dnTfzoYL0MaExu7CPwuDbmYFQNy4DyZ8sUE71YN9jffkIteFakkYf+LFA0ZGVfxX3QklM/U+Cs4RMRp1hvgY6pzKbLYHNeG1ueSVcj3fZPjp351W3SRXUC0ctugDAvCjyu93w+/5KkD1D9Oyc6xUDsY2TH7cbWqH69x5RgmKKeYY/GaECpUUsGxSsxF7PxpzEd+MalaHiJHiLRclKrFtnU1SHEuycTVsQNH6rOmSy12fB77LQXQHbpV7OFsbQw7PtJeXTGE324p5C9Z0ZWyJTtaaRV59vVdw59zRkCQCRvgaT1QHWDOFGgcaSZMWIgp6Wgn2JLD3lx/OJpYeYB3akawvDoOlsBpXjRhfRHaEL/eOxuTPWLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(346002)(136003)(366004)(39860400002)(376002)(186003)(44832011)(33716001)(8676002)(38100700002)(1076003)(83380400001)(38350700002)(4326008)(66476007)(6666004)(66556008)(66946007)(316002)(6916009)(5660300002)(8936002)(52116002)(9686003)(6512007)(6506007)(7416002)(26005)(86362001)(4744005)(2906002)(478600001)(6486002)(33656002)(41300700001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bcawbXMM1OYkTswra6mgdelhWH9dJ4IlisJk40h2XeWx9ZupMuuUXH9hAIRz?=
 =?us-ascii?Q?kGXvanDVa1Q+H4D/EUIquqCF3XmLc2wdFIsRz3GcUAiEg6IgemiCj4uP76Vh?=
 =?us-ascii?Q?lJjigEw2/eMES0sKQEUoiTFekZ8zhD4nsjjTgTf8gpxNMTVwQIY9WQXypTwY?=
 =?us-ascii?Q?Lb0fWuQz0t5W2EPth2l03g0RRn8G8ril3vLwrcEyg9PUIXtxtOfb71rXlpQc?=
 =?us-ascii?Q?CpZx+ap4D9Z3H1zgcz0CTtyXohVKJakrIXZmk6b1iAL6WZCwY6IgEPLYolWM?=
 =?us-ascii?Q?xyzznLSmMOFcEHzk+CCV0PTa83waiCwDeEsNYXeAY3B7RDQKaxfjG+sp4h3r?=
 =?us-ascii?Q?7GEyP0dGOtab1sMfcpoGi/Hys1mBwyy3I2Kq4SQnrK7VguyItkCitk2HQydg?=
 =?us-ascii?Q?FFRS5Ywx+tEbQT0qh+YJ0iPr5sJ0Q79DXsQ1GJItCwkbneFIXF29p93N6irF?=
 =?us-ascii?Q?gl24bsfINELMoki75F1GPOgb8+fWGlNPN6l0j1dS7weqj9Gfq6ZSgXPA2M3z?=
 =?us-ascii?Q?S5PQrDEO0logxC2gOv3c11xS/XCvaAEo0wU8lY31+I5vhB8AVPdLbMxR+STe?=
 =?us-ascii?Q?WZdyeSwZAE4qH3Y3gUNgYcFHwmzjJSw5I3YaM8Znfp+aZBhW478kYuh52nFW?=
 =?us-ascii?Q?3EUU+Kh5mJv9dOXp0CFp3VoXHFAXx/eXYJmdP3Hs/1RWUNgjp5OZZBT5u0Or?=
 =?us-ascii?Q?LFd3UuKA1x59wYKhw5ndG1Z8Sir8+zqgvy9CGAbbX824c3igHI7iCP7dTj5H?=
 =?us-ascii?Q?xIQb/i1Fs+Xm0OatI/XujhzGp0wbGi3pWHO9o3st62QBievRrwZxbvA5IofB?=
 =?us-ascii?Q?hBfZcBQ5+BoY0il5PW61LLEt9KsCXpJjty/YmkMe2jqiZ5SzxEe/bEdR2tud?=
 =?us-ascii?Q?6w4SxXV1+26s8EOkH44Q80TqiaJQyewnvJ13WX2askNGByOH90oR2AFQqQ9I?=
 =?us-ascii?Q?GCUN9vSvPlgM1bZ/4ovrteWp3preNg47vnDe+MDYeViH7wEugxmTwla2PzZX?=
 =?us-ascii?Q?bgFCiBk+PI9IfkpSVqK1W2RDHLBDAB/U6zsOyEyL1oPjUfwe3RYhK5S6MJtF?=
 =?us-ascii?Q?AfG1vYOyoGJuwUZyPGuOzA1lYXMlG94NEN7F3GX5cedk54Vc2sMZ8U2WpxFY?=
 =?us-ascii?Q?5svGJ9hJGanrvzjWKcuZkMucOssIEzrEc1olMyfUTiAZrKYHReJhr7RcbgH+?=
 =?us-ascii?Q?0OvTogpS8YhonLqVOFcrF2RnFf9yGoqqTtlXdjjlJiZwEqpTyEx0nndVGAO3?=
 =?us-ascii?Q?gEQ2JSM+FVTY5+GrEf1+GgpWir2jNErASlRb7wRhbO17h9uehfVlzKAaDxn3?=
 =?us-ascii?Q?YwYqdmS20cTdwhKgt41lNdIzXRs/ccMH34iB3p0k3fBNgp5fApBl7vbaRJNO?=
 =?us-ascii?Q?HyILxevGZRp/pS4YIdk53TwHwIpu/cdcGMYZWh32HE4gpUUmBv2S+CaVgykf?=
 =?us-ascii?Q?DKfuPeaLfaaybOlCS23bzSlF2ADNs9xZrtIBaRrnYlMmTYQGXHbDbw5vbR9q?=
 =?us-ascii?Q?CXhCF8INq6zkAkSiFMOWL3ZupIMlj2yQ2TDrBSYsGUHWVKiyItVeiMnDmVTR?=
 =?us-ascii?Q?8DELC9Oq6ZDd6NDZQ5tHDzezADkIHs+HWMWLwU+94hI2/kSY400kauEwaCgo?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e287be99-e216-43b1-b702-08da6ae7a65e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 07:07:18.9436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4tiReDxj9H/A/gUAwxBGmykUcLLnTQbPSQHAVVWvlY7OBmQfulvUlxenU4cn4jRZ0I9k7ZRoWqjltzHVw1EodQdlGob79Me8vhYJg35m/+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5497
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_12,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=900 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210027
X-Proofpoint-GUID: MTrEjVhnUw7z3_Pr-B5PLls8gc3qOX2p
X-Proofpoint-ORIG-GUID: MTrEjVhnUw7z3_Pr-B5PLls8gc3qOX2p
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 11:21:58AM +0800, xiaolinkui wrote:
> From: Linkui Xiao <xiaolinkui@kylinos.cn>
> 
> If length from debug_buf.length is 4294967293 (0xfffffffd), the result of
> ALIGN(size, 4) will be 0.
> 
> 	length = ALIGN(length, 4);
> 
> In case of length == 4294967293 after four-byte aligned access, length will
> become 0.
> 
> 	ret = ath6kl_diag_read(ar, address, buf, length);
> 
> will fail to read.

It looks like "length" is untrustworthy.  Generally, I kind of distrust
all endian data by default, but I dug a bit deeper and I don't trust it.

Unfortunately, if "length" is larger than ATH6KL_FWLOG_PAYLOAD_SIZE
(1500) then we are screwed.  Can you add a check for that instead?
Please check my work on this because I didn't look *super* carefully.

No need to make any changes to the types, just add the upper bounds
check on ATH6KL_FWLOG_PAYLOAD_SIZE.  The type changes didn't fix the bug
on 32 bit systems anyway...

regards,
dan carpenter

