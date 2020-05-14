Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E351D285C
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 08:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgENG7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 02:59:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64202 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725864AbgENG7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 02:59:04 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04E6wnRn001187;
        Wed, 13 May 2020 23:58:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=msjVmwgdz2DHaOwPz5DbuzAxhykk2b1PVJkZVQPJVoA=;
 b=QrQoKoDa5+uhWiqdUgZlJRBi9AQZQH9aCLOKWcuvtYZc0dRPCp2NPG2XKsgcbAi6zIFQ
 sul6dz+qpCkFMxAJJ7tt9QE/uPja7JknjtisWBTzuJoVYgf94MYZ8elPLGdYuSFJQZTF
 W2VTfGjR57Efzqw9i/z3DCTUdeHb9wvMKgM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3100wy9q4a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 May 2020 23:58:49 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 23:58:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjZTeAnWIJVrOOI3otOGhKvllotEQui+iKTs1dFfvR8QiXPCR/v/72R+QyzVvD4MdetAW/xZoGyIWsw7nEn8I9+qFjd7i+3vF8S6atg/mBdFGdCGUuRHobumEVt6jUK3x0893M8wKbRndAKi0SELR/Kwkmlngw2C3qK2bMb73amgDPdu1O4mkIXyqXviKS+cq2IdlBWUGk16Ktzf9z9RQfyVXpTzUB3/Phu/dKqFkNQv/9Ido1v2M8tJvp8uap8lt3oG6kT7w/Wwmsao2DSd7HNgwNqYRtKpYHQ5yPQFOuxjO5LhkCeHO+MtEmDhUsreMWxNqovfbzUTdMjHTHEsGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msjVmwgdz2DHaOwPz5DbuzAxhykk2b1PVJkZVQPJVoA=;
 b=BVK7574L9ltRYqztVO6yvTfpCnqX3nAvJFe4/qKL7xHRNjuyuFl2FUnUoeLGcxpFpn6l3IEZEYq0CiH6yPVqhvCPBfK5ffvoJ9GrHr6os811LVrnxpWT+yt5diqGTTwlw0KkAc5nTpcVE9MdN896XE4v3Yv0ilxna4x9JixPUoxjDf4O7xEwfN8Nnon9yvS/aPE4Im1NV8KNoGMviROz/e5FuyaJjLDWVUf0D8M1wlhhL/HiALa3oIb9U9mBqpYoWOvG1VTL7Te1o8ZWfoPR0vpYGOzneIoaAN6j+C8MamHc9v/ba4mlQFOj/QniPY/+9lEbpoKY87OKIY/lUN5qqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msjVmwgdz2DHaOwPz5DbuzAxhykk2b1PVJkZVQPJVoA=;
 b=XoLZIe7Prn9Xuj684LcNdO+TM5FduutUOW7Xwa6TT6o/kXi0JWsPU94S6F+nwTia0LUdt3PouptVwtSyg2hiRhGSlYRaEuncF1DWqmyxLM4EtlMpDN9V4Mv63nlXqMskntDw1hLo4pDvhBi82rEKCRPXcRHBhAicuia0zAKyy4U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3047.namprd15.prod.outlook.com (2603:10b6:a03:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Thu, 14 May
 2020 06:58:46 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 06:58:46 +0000
Subject: Re: [bpf-next PATCH 1/3] bpf: sk_msg add some generic helpers that
 may be useful from sk_msg
To:     John Fastabend <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <lmb@cloudflare.com>, <bpf@vger.kernel.org>,
        <jakub@cloudflare.com>, <netdev@vger.kernel.org>
References: <158939776371.17281.8506900883049313932.stgit@john-Precision-5820-Tower>
 <158939783014.17281.11169741455617229373.stgit@john-Precision-5820-Tower>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <0c74ab32-7e82-1750-e3a0-9dfb9f3bf5c5@fb.com>
Date:   Wed, 13 May 2020 23:58:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <158939783014.17281.11169741455617229373.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::20) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:7dec) by BY5PR03CA0010.namprd03.prod.outlook.com (2603:10b6:a03:1e0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Thu, 14 May 2020 06:58:46 +0000
X-Originating-IP: [2620:10d:c090:400::5:7dec]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8559d73-a2a0-4544-ef21-08d7f7d43f61
X-MS-TrafficTypeDiagnostic: BYAPR15MB3047:
X-Microsoft-Antispam-PRVS: <BYAPR15MB30472965FE5E2679F8A24E32D3BC0@BYAPR15MB3047.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 65aEbetZmitK3QaCMj0mjXEq4xaiEKY+exxrvqVXRlhj88bZd4Qmo2Vr3nrEJ/U2OQmy3/DVMe2K9xRdSjIAJYcJU33dzOnaB/yD4+kUJ4C9UPPJvx2lZkZtIxrruQeWCzH5lvysXEe4PD0+7P3vz21XyVbY8X8tIywBLgZg/TuuGaqpFl9KBwXglz6TDLAqNhCv75YwTa8+uUuhZ9ndOrGP4ESpLvTQoVdj6jEY2990ATl0YjHoF42j1co+HBMra5RVbVVLYgQ9qfWBjCiDJqKUR/7zqlf6ZePyxgwZEh0sRubEQHwIHLGJoYwMtgJFLQU7J9kVLxqm1R57S/Ip6phAiMVPcLiJSlLLsmeEXWr2aWlfrIlsslgHXHVUP/az73sya4eE6Lx7R/6A+7k7VuiHhIx0DIjqveuhR6LjEoYQaasFl4wicpaYv7r+xHRyifxv3IgtMAAj9BI9TOZltHB9TY2SJkwiXh70JlbEg+3W+tyVB5skFWbCt77UpjeRyhE1H9O5qtrF1OJJxXgvpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(136003)(366004)(396003)(39860400002)(66946007)(2616005)(52116002)(31696002)(478600001)(86362001)(4744005)(4326008)(8936002)(2906002)(5660300002)(6512007)(31686004)(53546011)(186003)(36756003)(66476007)(16526019)(8676002)(316002)(6506007)(66556008)(6486002)(41533002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: bUgS37GNCx48/dD1SePY4KmBNoWxYA7MgdfU9B5inYSiAhU1xVDhvgNELoDy5uZgYMw7SAQ8EmGXkkQ0Y1Noc+mw0myl2N4bW4sNCH5cSPGb0EHBok0aRRzmcoJp/llVPAdTJlwBkpc115lW1NW3OOrCceK0UOjMLi5RVIg2I3nIWQcEQbDtbo0NXkXJpNbNLFkjfAvOB28AOYIg3112y+BpK7AsqSOFLUVIMayD2MhLKURlCkX1YGmIWkn3KTSMNPq+Lv5OZzDm17EwtlBra08UUIWU/yQnVJChq5K4YCr2kIAJhWiDOwRMIJ85Emacya4Vx+q+9b9eL4UEgs8rGTGlgYg1xnyWAaDZ0kN6vGHX6244Oy3c2RGvY4bjOU1fNGHv0bQCjjjvmwxQhiAxxfdMqNCMqqyx4DRznmJ+JVFAfGHQMqnv3DmBzNf1TqamBDpXsVxwn/d0rNuLUe7Zd2nrABokd+yweg+tC1dIwcILVdeI4u7KwnivpItsv1gzp6uaupEfjUs0DhXyYxMMQg==
X-MS-Exchange-CrossTenant-Network-Message-Id: d8559d73-a2a0-4544-ef21-08d7f7d43f61
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 06:58:46.7153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJ8kf/VQbe6Vp8hfdC5h33Rq9qMqeWDJkefb36yOrwPV2ILe85ruk5XylPo+/6ch
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3047
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=910
 cotscore=-2147483648 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 phishscore=0 malwarescore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/20 12:23 PM, John Fastabend wrote:
> Add these generic helpers that may be useful to use from sk_msg programs.
> The helpers do not depend on ctx so we can simply add them here,
> 
>   BPF_FUNC_perf_event_output
>   BPF_FUNC_get_current_uid_gid
>   BPF_FUNC_get_current_pid_tgid
>   BPF_FUNC_get_current_comm
>   BPF_FUNC_get_current_cgroup_id
>   BPF_FUNC_get_current_ancestor_cgroup_id
>   BPF_FUNC_get_cgroup_classid
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
