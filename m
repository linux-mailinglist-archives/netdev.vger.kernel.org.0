Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3F422FCD1
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgG0XQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:16:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726313AbgG0XQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 19:16:00 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06RN7Iuk014872;
        Mon, 27 Jul 2020 16:15:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=NmfcTJjN0IyDuAfHLwKbxC346sD4a4PSJ/de2fIauT0=;
 b=eG/CU3B6sXxsQKZOW8g7GOMOIDgyr4I5gEDOG0vH2OV/dGAn/+Jmh1I+UOMQ8O3i57gw
 sj7AeK8hwqwuRHOszfvcsaYiZE6UKbsToYhoYmMJ2EUPp9BfgaYv83sOKljrj5e+/aa4
 Nm/1PAo23O0lTEfOi+eW2Qadd7/xvoVcnro= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 32ggdmhpxy-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 27 Jul 2020 16:15:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 16:15:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IbeWD+8f2FDhhRz47BOnl7mf8Karm7m9zr8LpBJ5Q49BBnAjkAkz/ZTXxwYoxRVnaWlY/cgWg5i8/OYN+8mmeq8OyN/wHN44VmorWex8kiv4IoExzmys/5+B0gAhknEjNfuuhuUrVH4MJ2AYcuau3ByXsOeRru6lCDVH6t9gJG60DSwk2kwZ6uThyKIFZMtiDrWFszKCfuXlqMpmXfTGbWpKlw60IZiZiH4q98ZYL7+kwm7hlkPW/cVCRxXVNtS/flaG99j9YUddZ8DOBT/7b/THC6jEZaYBPSc1nL8NePprI5fEJZMT/Q284yAVbJtGJkXWbNIUZ+16l9xTgcuOSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmfcTJjN0IyDuAfHLwKbxC346sD4a4PSJ/de2fIauT0=;
 b=A4Ke15N3/N77S9T53jFFsOKqY7wbs7b95hCCwO8uNFtEW94AXt4wzd1w6YVPhyPonh5K4460A8cZyYOE854RCCS3nK/rG1spdLEzVuli2xMbTlT4udWq3sS7lijpIJ2vn9KvmKoc8lnCksIPD5X83Y4iRoEUhKy9kAZ2PaWvKX/9YPRz9HTdyvHxkzn1dvSpX8z4vOS5cOn9xCq6NG5AcQ31Hc5Ho8Ug/0wsE+Eva3n8DNQDP/hgnVMUYa+eSNQpwcT/DMFeqP00exEq8xo+WHyXMPWWWYDbSxqpFuhUSUXVSrNcyYtsFuDZM4CcA6ukOiCy8Cs0wU9pE9h1n1TxFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmfcTJjN0IyDuAfHLwKbxC346sD4a4PSJ/de2fIauT0=;
 b=SsrL7AOy986IJIgXfDcKIgKjXuVmCt3WQFiNnr4Jq4OPTVwhcocO0oBZ2ek+B2H2ui9LRCwcu5/DCU2k8oAg9VRGbE9njefePu3TAi4E3Txf8SM5r7UL7WC05IFYwupsZKMy7wMJ+KBn6ZSi06qv/VbzrUa9JYzn6MGbj449CA0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3477.namprd15.prod.outlook.com (2603:10b6:a03:10e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Mon, 27 Jul
 2020 23:15:41 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 23:15:41 +0000
Date:   Mon, 27 Jul 2020 16:15:38 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 29/35] bpf: libbpf: cleanup RLIMIT_MEMLOCK
 usage
Message-ID: <20200727231538.GA352883@carbon.DHCP.thefacebook.com>
References: <20200727184506.2279656-1-guro@fb.com>
 <20200727184506.2279656-30-guro@fb.com>
 <CAEf4BzZjbK4W1fmW07tMOJsRGCYNeBd6eqyFE_fSXAK6+0uHhw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZjbK4W1fmW07tMOJsRGCYNeBd6eqyFE_fSXAK6+0uHhw@mail.gmail.com>
X-ClientProxiedBy: BYAPR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::45) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:9930) by BYAPR05CA0032.namprd05.prod.outlook.com (2603:10b6:a03:c0::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.10 via Frontend Transport; Mon, 27 Jul 2020 23:15:40 +0000
X-Originating-IP: [2620:10d:c090:400::5:9930]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3cb0c2c-cb09-4acb-9433-08d83282fb13
X-MS-TrafficTypeDiagnostic: BYAPR15MB3477:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3477D7F3154B74CE2CBE26C9BE720@BYAPR15MB3477.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jvxa/wwD6pWHUwx8dt8jbMGzqBIftvRrQ8GPjw5v9bvB6SA0PdcEgoiSZWlOg2A2TEMCk2cbtaybxYd2f4yfQAKM0Qdfh2iLZgh4xwWUB8EQUM5dcniyBS6TbaSsQGxvg4J/mrURmGphUjVQvaDZ0lWNKvdtFID7c0Wn9SeUjJZRef5VETZ6N7Cnpl8LaR7+9PQG/zXwLK8YASKFGAl//Q6t4KT9JUJ44ZqGSDLT6F/sCsX1qRHVJZgMC6vAfJzoaIrUZO7/jsOJgJEql31++G0xiIo2XNS5sajrgIRlDYvHzec++XIjpdMrtP1pHB5WbwhuPguO445JC6JcKHvO4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(1076003)(4744005)(83380400001)(66946007)(8936002)(66556008)(66476007)(2906002)(52116002)(16526019)(9686003)(8676002)(478600001)(186003)(7696005)(55016002)(53546011)(316002)(86362001)(6506007)(5660300002)(6916009)(4326008)(33656002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: y0irvZwOTm98S+72aC1sDW/tmzuWFRpXBufgt9n/U5LbcU29sELYYctfaNEUZ8YEyOpE76+porDhRw+MxJVbtSgXnmSRRSjVOgDIzY7Y3TH8PtC+kIHPLLyaFl9jzn26a8E3i5U0L3qreOstIReffrmwNw1/tbYlDKKmEi5z37t/uoDtEnhHn46u+GZGEyM1uVIe0wyhWApIKc3ptGR6geNzJFLyus08tWGS3/fFjZ4Aeeez+8mYfm/6uQimUB3Tdus2luINQ/LiGGtxCuTCcxSxO2dZi9wz7Um6M1uhiNgU7I2ssF1TFXTvXAwLCT/5wA/e+IU3SOwLX6FspCjhU+5aTGQAZslg5Kz7C/BbeKjYpv+9l5H33OjahbUmU7XGV/WTCq9nz8wHfZBh6sGeXS7SJGYNr0T09NBaPvpRoVHH4fwwMnnqGCTjExWXvKuBHZSZT9EG+fCl+RkeG7nUqnD4jt8ZD7Z44wc14lIHWkfHojqkVaxBorUgGMnD7qIWnpMEYAxyRCDor64O3VsLqw==
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cb0c2c-cb09-4acb-9433-08d83282fb13
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 23:15:41.4335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WPpPnxGeUEsiy9kFOFHI4IwDdWaYf6BQIhZb4b46P0K+F7e/glyu6uJC7Y/QYnOP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3477
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 clxscore=1011 bulkscore=0 lowpriorityscore=0 suspectscore=1
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:05:11PM -0700, Andrii Nakryiko wrote:
> On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > As bpf is not using memlock rlimit for memory accounting anymore,
> > let's remove the related code from libbpf.
> >
> > Bpf operations can't fail because of exceeding the limit anymore.
> >
> 
> They can't in the newest kernel, but libbpf will keep working and
> supporting old kernels for a very long time now. So please don't
> remove any of this.

Yeah, good point, agree.
So we just can drop this patch from the series, no other changes
are needed.

> 
> But it would be nice to add a detection of whether kernel needs a
> RLIMIT_MEMLOCK bump or not. Is there some simple and reliable way to
> detect this from user-space?

Hm, the best idea I can think of is to wait for -EPERM before bumping.
We can in theory look for the presence of memory.stat::percpu in cgroupfs,
but it's way to cryptic.

Thanks!
