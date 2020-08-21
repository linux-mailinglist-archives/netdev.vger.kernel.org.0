Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F374D24E336
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 00:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgHUWVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 18:21:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5554 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbgHUWVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 18:21:11 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LMKCNE025616;
        Fri, 21 Aug 2020 15:20:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=zHC3Xgo17oOVTix6IMnPw8W65mLrTZxQUIxPE2i9VDk=;
 b=ZQSRSQz7DZ6Yd9/2uEZL0w4oj8Gt79LCHoCBIryrR/HmR335kl27xJYaFe2XrIEIVN1Y
 66r9Ke/wOFI5GGcLShV4oOFJkJvFQMdLrv7g+w5X2cxt7DBhkzEYjVu0SMbbzkbrNlOg
 c3cXvSSrky5ym8lmAEHiBHsWWml/oHEjBLw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3318g0wm2a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Aug 2020 15:20:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 15:20:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQ9AGscsYrRBwKoWaPTE3P5Z5U1jUAw0XvYgSdxXA6NFtcysGWdf6huiTblR+7A3v5eiTLT+7XeJmN4x10TzZiR3lVWkH3NvwfCVVcc41eNEiQAXdn9XUekD1CraVDqXQcTTNpanJ5JV//g+KYW1iJU1QzadpFN4WK1H9k5UNs5OLx8LkAriXlXpmbbFr4tfFZDD17x51+HaYQcYeBp8rCKTT/kmSn1YyZbp/4iDAv/CybE5srTo0PyotgsHDyoe1sYyoZ/VJe2y/JZVUeugJOzjW20YSIXoF8TuMGZ5Y1cESCcRz9bQp1/Rcyr21RvuqD6O9GXn7VkoMTH6u2VE5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHC3Xgo17oOVTix6IMnPw8W65mLrTZxQUIxPE2i9VDk=;
 b=FII+uajdaZn7j6fga5CcECO/2SvMoGPivFkI/qhAotKq6nW6cs9z0leNC+cKpVnt7TNgom3xVv5lg5S/DaTXJxt5so14z5dxCmHy7SlHtYQZAqRRt8YwtIjd3sYSsBhcbgJWT9taZhxdI9kgfEmZkwOddWiaQ3eyo9YVozchM53kTelORTntZ4grQPu0p0hkH1B65TW+XeKtUmS2VZ4mmUPgfdC+du/T8qKhmrtaEgivuHjPjSZbqG2IMPOwrqu1bOziusr2WNnMSVAyLKip1aSJdPlqBbimv6xPgedSxH5TjeKG402nSaOV+r7kiY/wc87RL4z5QexwpLHwWHxxag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHC3Xgo17oOVTix6IMnPw8W65mLrTZxQUIxPE2i9VDk=;
 b=hh4r1hjVKgziB47x7TweO++8Z4Ey0FYtScr9OWaxlWSoW/J/unelQIP/7ISa4sdZ8GAJzaUNfiVdsTMjaJMOe3iY0lLZU2SjphDTwss98Wv1dP5wdlTXMa08Kt/v0E98DflNgVYrTPPCVSlOAW6H8UT9OjCTx0+e6S8qO2pTj50=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14) by SA0PR15MB3952.namprd15.prod.outlook.com
 (2603:10b6:806:8d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 21 Aug
 2020 22:20:45 +0000
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::e1a8:24c:73df:fe9a]) by SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::e1a8:24c:73df:fe9a%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 22:20:45 +0000
Date:   Fri, 21 Aug 2020 15:20:36 -0700
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH bpf-next v4 00/30] bpf: switch to memcg-based memory
 accounting
Message-ID: <20200821222036.GB2250889@carbon.dhcp.thefacebook.com>
References: <20200821150134.2581465-1-guro@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821150134.2581465-1-guro@fb.com>
X-ClientProxiedBy: BYAPR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::18) To SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BYAPR05CA0005.namprd05.prod.outlook.com (2603:10b6:a03:c0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Fri, 21 Aug 2020 22:20:44 +0000
X-Originating-IP: [2620:10d:c090:400::5:1692]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7aa0062b-1e4f-4d8a-5d3f-08d8462072a7
X-MS-TrafficTypeDiagnostic: SA0PR15MB3952:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB39523EADEEFEDB1C0ED3C9EABE5B0@SA0PR15MB3952.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vmHsZuAbYe4ZlMcfix4L/GhKK8fHS3KjtqGzJBxQhFaupw1/hbFNurcPLck4ecv2vuEheh/nfFvAcpdyHOHBQZCvq+JgbrW9iOBcTYtvkLykmiB1IjQ28OVylrlxXHgqUCLrP2Eo19FzbTLELj6yyjafH9/KWNwr1raJh3B+x8YwMnzjV9YoBgUtCnHjMyzxlM/uHpYwSugI6bqXuNHyf0ERSV6WyPYV9NZzcPePIbj/He2DQSX254m9LMAuSY4yD9rQlADCFBfFC98H80v/xTmZQxjuMvDl3x+7MeWHZU25Ruq5B3ntP2jQ241JlIKODEhrbKCdkretpW0r/gMWP9uBrsSgdTt8CjX99XMV/GMhjroOapJSqFwed5LcDn41
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB4141.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(8936002)(5660300002)(6666004)(6916009)(2906002)(16576012)(956004)(8676002)(86362001)(33656002)(316002)(83380400001)(186003)(15650500001)(54906003)(1076003)(6486002)(110011004)(66946007)(478600001)(66476007)(9686003)(66556008)(52116002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2ElhtghiJT7yhr/AAIUtK1QMMnMy/iDeTHOvPfdjhFrNA8ykDxvm/BYxvDOdE0DkPAsUug/NFLMwDQrr3JcsiBi/3XYtNzxy8MHSVjfyP0VihH4+8i3l4LaOQojSSfm218lnEorE/pC/dqh0+CS6sh177SVndfRVYLEeghR5kQs6EHSzknDqTYX4BMC8TiUL+odExLpZ2MEPF8PQ8p/KU/J7/J+wwc3r4VYWGEhggo5GBPIc3hZoA9FStJRIUF9z5Bj8foOfbvZxcDP5O0rPe3jzAehOSCldA4XxO4FgIGA7X/Q0CXcuzICTCdBukRH+/H8ylmuNf4MgX5VuwPZXXzR8H5LsvzkLyG7/9/0ZWlv8sUFEgKQ1RnCAtDyPAFzI7x+Ez2FaTzYdiJ9e6Pt+4UAoz5xqx/41hMcbJ5yZQlc9uOXRwIFnunlA0VCzKjDnf+K2lUPvFYknATg7YVheYJnCZ6R/0veCJA8TeGIpmatH2HZb73Ynzq+qWRk3+8rhUMZf7WKvpoIpdwOyiInx2PZh75xk4y+qMLm9CHCyPt+AI8TYxzQqafrYQ1eqjdlzjFCQtKWZE4Xg3SURAcfnqWUl09eBQsDxXRGDPM/WDIFdse4vcDqqv1CuFbK/u+QlGzBc0VCsMAq/Nlgl10x4UF5nRd0iK8dmkR4HAfhPiV8=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa0062b-1e4f-4d8a-5d3f-08d8462072a7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB4141.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 22:20:45.2102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOoQ+Kr9Hj3nvjifzy67jv7Fy/emA20JurwXqF1ZhiU8fAosZVOT3hfh6PZ5dkdc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3952
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_10:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxlogscore=736 suspectscore=34 mlxscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210208
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 08:01:04AM -0700, Roman Gushchin wrote:
> Currently bpf is using the memlock rlimit for the memory accounting.
> This approach has its downsides and over time has created a significant
> amount of problems:
> 
> 1) The limit is per-user, but because most bpf operations are performed
>    as root, the limit has a little value.
> 
> 2) It's hard to come up with a specific maximum value. Especially because
>    the counter is shared with non-bpf users (e.g. memlock() users).
>    Any specific value is either too low and creates false failures
>    or too high and useless.
> 
> 3) Charging is not connected to the actual memory allocation. Bpf code
>    should manually calculate the estimated cost and precharge the counter,
>    and then take care of uncharging, including all fail paths.
>    It adds to the code complexity and makes it easy to leak a charge.
> 
> 4) There is no simple way of getting the current value of the counter.
>    We've used drgn for it, but it's far from being convenient.
> 
> 5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
>    a function to "explain" this case for users.
> 
> In order to overcome these problems let's switch to the memcg-based
> memory accounting of bpf objects. With the recent addition of the percpu
> memory accounting, now it's possible to provide a comprehensive accounting
> of the memory used by bpf programs and maps.
> 
> This approach has the following advantages:
> 1) The limit is per-cgroup and hierarchical. It's way more flexible and allows
>    a better control over memory usage by different workloads. Of course, it
>    requires enabled cgroups and kernel memory accounting and properly configured
>    cgroup tree, but it's a default configuration for a modern Linux system.
> 
> 2) The actual memory consumption is taken into account. It happens automatically
>    on the allocation time if __GFP_ACCOUNT flags is passed. Uncharging is also
>    performed automatically on releasing the memory. So the code on the bpf side
>    becomes simpler and safer.
> 
> 3) There is a simple way to get the current value and statistics.
> 
> In general, if a process performs a bpf operation (e.g. creates or updates
> a map), it's memory cgroup is charged. However map updates performed from
> an interrupt context are charged to the memory cgroup which contained
> the process, which created the map.
> 
> Providing a 1:1 replacement for the rlimit-based memory accounting is
> a non-goal of this patchset. Users and memory cgroups are completely
> orthogonal, so it's not possible even in theory.
> Memcg-based memory accounting requires a properly configured cgroup tree
> to be actually useful. However, it's the way how the memory is managed
> on a modern Linux system.
> 
> 
> The patchset consists of the following parts:
> 1) an auxiliary patch by Johanness, which adds an ability to charge
>    a custom memory cgroup from an interrupt context
> 2) memcg-based accounting for various bpf objects: progs and maps
> 3) removal of the rlimit-based accounting
> 4) removal of rlimit adjustments in userspace samples

As a note, I've resent the first patch from the series as a standalone
patch to linux-mm@, because a similar change is required by other non-related
patchset. This should avoid further merge conflicts.

I did some renamings in the patch, so v5 of this patchset is expected.
Please, don't merge v4. Feedback is highly appreciated though.

Thanks!
