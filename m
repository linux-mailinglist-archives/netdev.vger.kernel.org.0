Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF411C1E29
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 22:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgEAT7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:59:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64530 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbgEAT7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 15:59:47 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 041Jk88R014956;
        Fri, 1 May 2020 12:59:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rXc+gdP6Y36hX8Tfh8A7yuFAcAGCzlAzP6Gv4d+1pqs=;
 b=jnACh+rsW66V8+eud5PBKX/5Jn8A2wL/H1SKzrIxtpW84q8XboDwYTPl7Lg540gjHiq5
 GNM/3IEGkhayfOzzHJlpVIfGroY1zNSkAGBTY/8t2W9OIMg3KkWNtt20Atn38nYjwwd+
 4pKwLng2kdC6qFq6VoxFigyzZT+ubzj9JYs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30r7ee5evm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 01 May 2020 12:59:33 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 1 May 2020 12:59:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sb8fjndoEjtJrVWz2Q2m3st3d5a6XN0NO+ZklNiTdnXP5yps7JrJ2CzjNTkLIScyGDX7vFcROLG6nl0oVeL8yatRBqIrlQrl3UuEOKiGRLe2+Hh+ODYafcijP/d5gPLegX43sc/nFTRLw1wWcnnN25CrWOWPlt4JnWAZQHfJ71VgKfzw6FfNlsm9KIs9wqy4yZ5vM72NJ27tuJ0lsFdTjoKDzL7lSD3txU6wqWi6yL7qlPO9PYUKFOpfbz7Jupw3OsbLRXYkXtY8EgudYD9uu/thsI6xWR+ls8tLdYJgjWJsaqR6FZ6PXo5NSdDIPFnc3T83JPQ9udDEe9MxEK+kRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXc+gdP6Y36hX8Tfh8A7yuFAcAGCzlAzP6Gv4d+1pqs=;
 b=hw4mbYI12MgdN2qt520jh0mfd4c7Biqhv44LagPr2LrkN0fp9akDyLmqVBXIeRFAi20ycCkUnBm2ckUipNo+GxZ3oSKdsPl0LMm8NyGP7zI9HWO7eECzmXJXEr8BBAYso+G32Db+PrCMG/Ef6g3h1Lk2yZ5EtYlP68vGUWHh5DY0NbgJfQ+PGfTsHHsV25UANac1CwZt/Ldo7f376wUxrQ/zxn5jZy3aBAwzrubAxdYaXGJviQzrtjE82P32+u5rc1yT+Mj3Z2jeGWDhocF9f8PpzXBW4d85Wl05ENipNQyU8HJQ02P6uew2O4ZUMRYp5ewKBuIf2Y1XpHoi7B6MHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXc+gdP6Y36hX8Tfh8A7yuFAcAGCzlAzP6Gv4d+1pqs=;
 b=TzO9j8GHhDYFMbhV52CSyCVI8z/ltKZfZRnp5ekAsF2RtNSHpc0aDFZafZoAj575Yg7fGPPQLl6Q6ENql9ZPvdJ1b15s0n77tohOrBH3p7skee4DuDTQpdjJ+a7G05y2zVkmB+1IsxG5kpEyzmN1AgI19i4TBAzGFPOSFSlTBLs=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3994.namprd15.prod.outlook.com (2603:10b6:303:45::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Fri, 1 May
 2020 19:59:32 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.027; Fri, 1 May 2020
 19:59:32 +0000
Date:   Fri, 1 May 2020 12:59:29 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>,
        <syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: fix use-after-free of bpf_link when
 priming half-fails
Message-ID: <20200501195929.4s6y7wee3u5usk4n@kafai-mbp>
References: <20200501185622.3088964-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501185622.3088964-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:a03:254::15) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:da44) by BY3PR05CA0010.namprd05.prod.outlook.com (2603:10b6:a03:254::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.18 via Frontend Transport; Fri, 1 May 2020 19:59:31 +0000
X-Originating-IP: [2620:10d:c090:400::5:da44]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eae9e542-261f-4726-312e-08d7ee0a2a06
X-MS-TrafficTypeDiagnostic: MW3PR15MB3994:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3994316AC8D1DD68DD73C48AD5AB0@MW3PR15MB3994.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0mzhjaRyHFx836B8ZY1jYWnL6bpYo4OoNBOkYU23yZ7tBlGKl5EMwImRVr8Qk0v98Vt9S5UhOSYM+w9fJpkB/sOhfFt2YUM9rwHg2FyJT6v/3muwTClFubuR59JtjPyWWEiHIBmoaiFljosBFc4jta5JYFHLrc2cLl/D8gAzhfoqVvfAPHBI4KDlCV2jzU/KXJmBK4m+GSlc3IjK1hkFbZPfI1l4ZL3W3ImoGGwUW7KOT7a6Oqsy9McVXfQE/5eEI/Q6OvXWjyA4750QZjp9Tima8GWIDfgzfRPQW7QvIBlop7aq+eLvA/12RwaQ+bgudv8jBv+d8MvkIbZWuhx5EjevebBJKFB8EvUV4qK+1kRJbI2U/Esdm50KUr0v1Xuazd7kxaGoHsmVgxP/ROxIPWKdw6gDLCJfcVMq5sjSD/y8pAE2DnFtCqBkzWzka2NP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(346002)(39860400002)(376002)(366004)(1076003)(478600001)(6862004)(2906002)(33716001)(6636002)(4744005)(9686003)(55016002)(66476007)(66946007)(316002)(66556008)(5660300002)(186003)(8676002)(6496006)(4326008)(52116002)(8936002)(16526019)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: GZ2OIiL4zqCzgumTFHJzZPUt/5Or68QpYboPw0JargDAvFrMlmDkA+clJFqWG6id5LFy03lz8zCHk3bSTkM/PK1Vo9Rhx0IFy+fHKOKvQ91RkwAqDoLW3oGpnxuUb1NcXfClwytpMRqz29MsAGO93Pjz24z0CShM9HOIqbXosLLlh3S2f/JpxGQcL8OmXLeXh2/BIRJYtHVB2Uoy9EQHvFotmEl80KfhUiudkVNSD0WCjx/NRLiUQmAmNAypBDi6d+/I9c9EKNqJ42fwsAC9Zs6RX8ETh1AEIVNuLp2/MYlaqYpFIYt0vNUK05Pqp8bq/JZC0uJhyt+48AwQgSwqLKj5lMkcDn9KoaI4fAvUU0eCi6gF8oQcI5zrLT7KmJqVpllCcROSfcUS168LdmPXdoGtM3oqAGfKWv1Q3XXBo6ANtgdaTYxwhjr05HhzGmM+HwrPUFawq0677ORTUkQNhnWdBaNmZn6IVouFuilw8opPC2rD081RQQ6e7vR+qEUqSAYGRDQ3M5l0BOugj79ojMksRsOhlGqYb4E+RA23vAUDZWVBaVeTBMW2bVQ05VyR8vsSciavHMFlmoL3KQCznBHIBX+Wr3Y/67+LtfedfHS0AL8TD8EF2xvfDSdFQVEOLcR2Rp/vsHAlwgzVPOxYIzyF2zDrBF6ISAYl6Yq0nysOJSCTL8u4D/xIN2oqd4HTGVCk1h7jhItwKonqdX8ETRtbPu4W/3jtSNnWVYKcDq6C4eFb074dJ4apCVtnhouDfAaNpQwX+g7r6+MdKdMCFAimsL0JS6xiHPKDNmQFz7+/gdomWBzaZlaPMk5gB45R1Cr/2lEtUxWIu7aTbEhnng==
X-MS-Exchange-CrossTenant-Network-Message-Id: eae9e542-261f-4726-312e-08d7ee0a2a06
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 19:59:32.0497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FX523xZocF/sKTvMGw5kKZZg5mn80Ls93JO0cD1yemPWJ+lL2s6q95xD9Xqu+2ec
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3994
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_14:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=2
 spamscore=0 mlxscore=0 impostorscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxlogscore=561
 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005010145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 11:56:22AM -0700, Andrii Nakryiko wrote:
> If bpf_link_prime() succeeds to allocate new anon file, but then fails to
> allocate ID for it, link priming is considered to be failed and user is
> supposed ot be able to directly kfree() bpf_link, because it was never exposed
> to user-space.
> 
> But at that point file already keeps a pointer to bpf_link and will eventually
> call bpf_link_release(), so if bpf_link was kfree()'d by caller, that would
> lead to use-after-free.
> 
> Fix this by first allocating ID and only then allocating file. Adding ID to
> link_idr is ok, because link at that point still doesn't have its ID set, so
> no user-space process can create a new FD for it.
Acked-by: Martin KaFai Lau <kafai@fb.com>
