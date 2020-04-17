Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23A51AE852
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 00:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgDQWjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 18:39:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14012 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728770AbgDQWjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 18:39:06 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03HMcVHc019592;
        Fri, 17 Apr 2020 15:38:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8awsTdtUXUkacfl7t6lf7HqPpjb5Hk45wGMQI1xpF68=;
 b=lblLDBr1GvRLfQbu3KNaOfZLEqdgbNoIQNAOUV8ZBuI85tVe+DtLSQAZuyVp5B2Unbj0
 kiU80TT6BN8rO0yGLwTjcZ85Obc+lNDErtRLFcQVS/yy5VfwJ0zzA3qymmj2vOD31JrH
 iTTYWnZY/J0NxW8fjNitlsd0Jh6d+L95kws= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30em7utsxy-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 17 Apr 2020 15:38:33 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 17 Apr 2020 15:38:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsGHhyOtmKznwUo37T/xur5NZlmf0OD7wkuZhlj/bvSByNnZ1AMLLaujyteSuD9kWZrtUdTtTrZn6EqKxiwrKRQEEgLeiw1Np0FM/50ogtLfQD7b1RPmFC0dXkqJfTxiuzVM6FuTiTjnavEZcu2APAwqJyAqX0OftnhXiF84atNO7Iq93aIrSvTgPE+p7EfKeMturXSZ+zSHJW7m1mz6BOR3WESk+XYOz7XE8/6Xnz4gwbB6SbdmYAKiS0hmx02fXOk17bbiVWAvNYmkFx5gABNfu9K/0J7JsojN6hkdfhbIYcbUZkWPz2dyeme5P5jkzdv34seP34ZagMCt/x+DtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8awsTdtUXUkacfl7t6lf7HqPpjb5Hk45wGMQI1xpF68=;
 b=ZadIrsWnDcM2zVpCQ8w7sOo/v5SYUcpDdrOMTZo/eS2GkyHrAGWkVT8VBXQ199QJxzezFJP6N70CyMUptauz+cWe+x731grFKLgs/SHyTQnzs0HASQdQCn2Bho15gJzOVFOP8Mx8TKCI95D1DmTteqRT72eM5XRIpupsikwZ+2vneXxeWnfLn/COpTSFgu3Td+83uBhkvnqZVBFaAZWQoRE6d1u416XmKyWxJc4bpZQLwoVMNetJAAx0TXs37MFTBOjV9Fed3XFmwkU4bBzKXU9PxLN14TAyLPVcvqCu4XBPvaH1gy6cIV4cheHKVpwxetM/bmxzmmVEBn+hrbvMUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8awsTdtUXUkacfl7t6lf7HqPpjb5Hk45wGMQI1xpF68=;
 b=JXpnxhepp3LbjY7/w/FTKIYV6PwpZ1OwyQ4M669ytO/YqNd4+s/RMnSMwQ6JIcHmwMZxf8XsHPxzgzYS6qDpbdfGivzrlTdsTiVgnwgauPaPPOjbTVCct5cW/rR9ZbXf9YuCZiBpBqnId+tDmrrxOikHUN9V3AMvnPKHnkD5BkQ=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB3333.namprd15.prod.outlook.com (2603:10b6:a03:10c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 17 Apr
 2020 22:38:30 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2900.028; Fri, 17 Apr 2020
 22:38:30 +0000
Date:   Fri, 17 Apr 2020 15:38:28 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     Christoph Hellwig <hch@lst.de>, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH 6/6] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <20200417223828.GA41441@rdna-mbp>
References: <20200417064146.1086644-1-hch@lst.de>
 <20200417064146.1086644-7-hch@lst.de>
 <20200417193910.GA7011@rdna-mbp>
 <20200417195015.GO5820@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200417195015.GO5820@bombadil.infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: CO2PR05CA0078.namprd05.prod.outlook.com
 (2603:10b6:102:2::46) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:6540) by CO2PR05CA0078.namprd05.prod.outlook.com (2603:10b6:102:2::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.6 via Frontend Transport; Fri, 17 Apr 2020 22:38:29 +0000
X-Originating-IP: [2620:10d:c090:400::5:6540]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61d6c455-2065-4947-97ef-08d7e3200d51
X-MS-TrafficTypeDiagnostic: BYAPR15MB3333:
X-Microsoft-Antispam-PRVS: <BYAPR15MB33331A99E453CC3C536AB771A8D90@BYAPR15MB3333.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:519;
X-Forefront-PRVS: 0376ECF4DD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(7916004)(136003)(346002)(366004)(376002)(396003)(39860400002)(1076003)(316002)(7416002)(16526019)(86362001)(186003)(54906003)(4744005)(81156014)(8676002)(8936002)(52116002)(33656002)(66946007)(66556008)(478600001)(6486002)(6496006)(6916009)(66476007)(5660300002)(4326008)(33716001)(9686003)(2906002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IZgbSAktu/lNtxM70jMH4ZCg3RCH8ymHj/uzYjYPigDjjXARF7v2ImyU3yrvaSqSW/hN+ZQML306UDT0vrR/4lK6uneWLzlXmLxu7AoKcqQz8kKEWePDtiBw+8bdeWiGLGLb8kWOQQIkVmOWmjC48oYs9gz0fEPyZsBw4aSDxl3hnikQRvw2XqwnSW7fi7OmoTlyxqd11iF2k3DJFD0kkpnmg067Pdl7NGRBT9BK91Tk8WRfD1E7MJmJc9DIHInEdQiY12ZVPyzI4W5C7R+6IOXaix5E6+f1TpZDYGZaw8dKp7ZRtGdRotOz6C1qh4ZLMFN+xyK6VujCr9jqRhFXtWlQwbA+ntMdTHhUp+8BS4sSZx2PS7oFMjwJeSEd6kjTgVHGRAnUF7WdoXIVaQwaKEQuL9k7m7axCSC4g2vXs0LkRJklJHNYa8VjnvPBYxS3
X-MS-Exchange-AntiSpam-MessageData: S150+3KneqW/WeFesQtLePM0Ez74L4EQSxoVLPM+8H08AylhjujfgF+Frp/h57dFdnuGF7HGcYgvHIehZ4eVj8PNrLS78tKi0dhy2OKmCxqOqwtEWcM88n/Rj8LIaVJe8Bj02MA4mO0SPeyOKdyIzPp8igUlzk+jInflV52WTuKD1ua5mPOKkhfj3tk9E5+b
X-MS-Exchange-CrossTenant-Network-Message-Id: 61d6c455-2065-4947-97ef-08d7e3200d51
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2020 22:38:30.2691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bu7PZ9VjFlyqfhXpkMd6fzQyWlrunnpjTyF3Nhjy35+QGqIBieWRqlOtdwBp8xwp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3333
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-17_10:2020-04-17,2020-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1011 malwarescore=0
 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0 mlxlogscore=886
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthew Wilcox <willy@infradead.org> [Fri, 2020-04-17 12:50 -0700]:
> On Fri, Apr 17, 2020 at 12:39:10PM -0700, Andrey Ignatov wrote:
> > Though it breaks tools/testing/selftests/bpf/test_sysctl.c. I spent some
> > time debugging and found a couple of problems -- see below. But there is
> > something else .. Still I figured it's a good idea to give an early
> > heads-up.
> 
> "see below"?  Really?  You're going to say that and then make people
> scroll through thousands of lines of quoted material to find your new
> contributions?  Please, learn to trim appropriately.

Ack.

> 
> Here's about what you should have sent:

Thanks.

-- 
Andrey Ignatov
