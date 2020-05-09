Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234611CBC20
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 03:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgEIBgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 21:36:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14720 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727828AbgEIBgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 21:36:42 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0491ZdgU018947;
        Fri, 8 May 2020 18:36:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=brL3DxfaH8SS2hKI4jSi055eQXQuvSBFvBfBBSmID6Y=;
 b=FKgDsNfSA1rTsLeR1rThc0esoYMYTGpMrvLT4Xi370pQeNMoF4E3exBS9hLU9+Z7Wzaa
 fxzffX/k9B/WpSXG/728tdlFq83pv8aqdF7YNttKbqsyrojqFaQ7DaoFKp29sIF7vU0S
 caXrKyqu4iG2LCUsiLgxS1rX0v13obx9M2U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30vtcyq7e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 18:36:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 18:36:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYz1ZBINrmdfYGGjl/1F73gY9/SstMde9yAb5zg4HWCiUZHYExB9zAEuQjdaUeQgf2UDYNJiZU5E8jv84QTFNOfW/k8yXvDIxHBlWW7yKt42B7jamOpd7f/rzPafh7DVNZ8P6eTdOFT52ncldUJyIpC17q/CMN9DKSHQmTnRrn3wDwOC+ao07HUTEqEtAv18DYeDGd72CYAegrP7+R2E4hYedxW/XKVq4dl6vp200Ho9jYT8CZm6WbKJaSslsomICJrcjBZ7V2YUEPdrVnwvbMBEiKJozF9iarq54xqfE+4k6+hGnGn90hNqqEp4Xn3YwV3AkDvcBz0isAjx92POqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brL3DxfaH8SS2hKI4jSi055eQXQuvSBFvBfBBSmID6Y=;
 b=JzjhsfM0jrqZYQ+bAA5ELTITdGLL98CtwI5wlx6sukXwMdvwEONcoh7bACuLc243Nt9lb0/g3mZaTKjmxkXDyXkfSzjz4Y36Uy+tLXNTdlH2ft9N7rgCrIHTnRazodK/T/qjNBdeE5wdpnHScky7xNFICzjdaE3nbh7RvghZ6s+1fILp3lzn0G5rdiNCMQVn1PySytukLIGQ0tLVppSc9fvAU823knvdeyJNONyQF7YITsbcAPYOkyFlrT2A6X+3NJ+lI+Ms18B1uFkZ+n081LP5iU+nIYcEGUVS0X/+P3FhpnCgg1pr6QQcBNASpKo3oiSqA/fbbcvr05IzHstytg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brL3DxfaH8SS2hKI4jSi055eQXQuvSBFvBfBBSmID6Y=;
 b=B/OtlJWu699O1d2tSlHUExD+ulk1fBWtHu7HLjJ9gaqHshrQpctrpQm6AHwPLlbRqkN4wuQxsVY+XyYLQa68cWOdfp6rxxpOcp+satOUIlBJV1qIZk9ttFuvo3irdYpuK/UzfaY0emqywObww1B1nTXM4DqaCuE5ixecsryCiIY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3253.namprd15.prod.outlook.com (2603:10b6:a03:104::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Sat, 9 May
 2020 01:36:25 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sat, 9 May 2020
 01:36:25 +0000
Subject: Re: [PATCH bpf-next v3 03/21] bpf: support bpf tracing/iter programs
 for BPF_LINK_CREATE
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
 <20200507053918.1542509-1-yhs@fb.com>
 <CAEf4BzaV6u1eTta4h4+mftQCQVOGPf0Q++B8tZxho+Uq3M1=mA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <849a051d-5c42-a61c-91ef-15a2bdb2b509@fb.com>
Date:   Fri, 8 May 2020 18:36:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEf4BzaV6u1eTta4h4+mftQCQVOGPf0Q++B8tZxho+Uq3M1=mA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0057.namprd17.prod.outlook.com
 (2603:10b6:a03:167::34) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from joshferguson-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:6692) by BY5PR17CA0057.namprd17.prod.outlook.com (2603:10b6:a03:167::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Sat, 9 May 2020 01:36:24 +0000
X-Originating-IP: [2620:10d:c090:400::5:6692]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfc2dc16-d9d8-46d8-acef-08d7f3b962d2
X-MS-TrafficTypeDiagnostic: BYAPR15MB3253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3253D3DC985F6EA87EBB1296D3A30@BYAPR15MB3253.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ABq7caNUJ/CoeoTLAAXhQB4TGdSSVTjM+g8TxroeDfIPYtpkE035Q7WxbTT5OvaRt/kUUmgC3BguZcRmIxNlz56WF54RA5hwIEcm95k1iieD33e2RhlUjxegKl9L6DNywblQdkdBmEop2rI64dW9dgpWdjbCfeC2Fx+O1CA+4E/Bj/lA6bHnFqQehgnRJ84RqkURCW4Yzvpfi2Lvtbsic748OiUJ2VKrEAASZ6JJHMZm7n26cihB3KumVsOxgzHlAyql4eHyXDVVVbLgL0Ed90/mMhMZLwJdRtduxj4zapX8JjP+N7WaONtDUgt0xptyuhMHcAfWRCVbIEtSlPSyE8GgX9BafXkDN+Pe3kBFB/Hm5FbTEPlSsiJI2WAZHj4ItpINgj6uYuNaEtgjf8sHKPEOknLRylpHbe+a2BiFer+sFMRK+aEADpVQDK+3wKNVpSx8DGrLVz1a/3TynTzSsMissarJuTCaON+xSV0Ts4vnTgmWl9wjhdm/PQec6PLLMAH3K20Jcm5FSY16vROojchau1MF4RK9HJ7v5PLGKqMZR759JuQ8VBwG7euusMyX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(136003)(39860400002)(376002)(366004)(33430700001)(53546011)(31696002)(2906002)(478600001)(31686004)(36756003)(186003)(6486002)(6916009)(6506007)(6666004)(33440700001)(5660300002)(66946007)(54906003)(66476007)(66556008)(4326008)(8936002)(2616005)(6512007)(316002)(16526019)(86362001)(52116002)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3w/K4/BXuBEL5DS1IQ70Dbk5zNcHEjnw/RKJhWBbl7t9JLZkFkTP9kYLfYHBL50vmd9dXcVpd0wl0rtQi8dPMvS0d2JL+RG2TATO7NtUrRHbc1dUflvvZPE1ylF7IWUo4ClpIPl6Vah4aTiN8DL97TftSQ7IKDSDt5PqRy//GZ0lmLeIXT22gFRFB38Cj2DXNn7vy5Pr0lKoZdio0/fd2qTiISs3vSAgqIS864Lmc8SO4xK5S4jhpH1STyavTU3aXZzjEiercAeAaYznonMmy6xTk4X6jTWb4WAZwUM+3u5kXmIeQOJ0oORA4lejtfDfnQCvwP0DXr7brscHtVnH4KhIZAJTPY/Js0yl3VddjQwYMA+oMh91Dc4fRZ47y+q7z4UMVba4uIW2OsAxxmh17Y6qk+FSMjzH41vQrZE4xPOUXEwDtoBN9GHq8F3LAZxqhsaEXOUNEO4//YNMKBe9XM8KNeI2838yoo8US4lRyI7PfMh4YYQTBarRaurD00XJYaSI11zIb7OcwFxESXYwRg==
X-MS-Exchange-CrossTenant-Network-Message-Id: dfc2dc16-d9d8-46d8-acef-08d7f3b962d2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 01:36:25.0966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4VHpBL1mdn4Dbop9wH75Eel2M869KzvxHgnisCCTcpJ9el6PZNKWN6lggls/ZOoP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3253
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_20:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 clxscore=1015 suspectscore=2 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090012
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 11:24 AM, Andrii Nakryiko wrote:
> On Wed, May 6, 2020 at 10:41 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Given a bpf program, the step to create an anonymous bpf iterator is:
>>    - create a bpf_iter_link, which combines bpf program and the target.
>>      In the future, there could be more information recorded in the link.
>>      A link_fd will be returned to the user space.
>>    - create an anonymous bpf iterator with the given link_fd.
>>
>> The bpf_iter_link can be pinned to bpffs mount file system to
>> create a file based bpf iterator as well.
>>
>> The benefit to use of bpf_iter_link:
>>    - using bpf link simplifies design and implementation as bpf link
>>      is used for other tracing bpf programs.
>>    - for file based bpf iterator, bpf_iter_link provides a standard
>>      way to replace underlying bpf programs.
>>    - for both anonymous and free based iterators, bpf link query
>>      capability can be leveraged.
>>
>> The patch added support of tracing/iter programs for BPF_LINK_CREATE.
>> A new link type BPF_LINK_TYPE_ITER is added to facilitate link
>> querying. Currently, only prog_id is needed, so there is no
>> additional in-kernel show_fdinfo() and fill_link_info() hook
>> is needed for BPF_LINK_TYPE_ITER link.
>>
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
> 
> still looks good, but I realized show_fdinfo and fill_link_info is
> missing, see request for a follow-up below :)
> 
> 
>>   include/linux/bpf.h            |  1 +
>>   include/linux/bpf_types.h      |  1 +
>>   include/uapi/linux/bpf.h       |  1 +
>>   kernel/bpf/bpf_iter.c          | 62 ++++++++++++++++++++++++++++++++++
>>   kernel/bpf/syscall.c           | 14 ++++++++
>>   tools/include/uapi/linux/bpf.h |  1 +
>>   6 files changed, 80 insertions(+)
>>
> 
> [...]
> 
>> +static const struct bpf_link_ops bpf_iter_link_lops = {
>> +       .release = bpf_iter_link_release,
>> +       .dealloc = bpf_iter_link_dealloc,
>> +};
> 
> Link infra supports .show_fdinfo and .fill_link_info methods, there is
> no need to block on this, but it would be great to implement them from
> BPF_LINK_TYPE_ITER as well in the same release as a follow-up. Thanks!

The reason I did not implement is due to we do not have additional 
information beyond prog_id to present. The prog_id itself gives all
information about this link. I looked at tracing program 
show_fdinfo/fill_link_info, the additional attach_type is printed.
But attach_type is obvious for BPF_LINK_TYPE_ITER which does not
need print.

In the future when we add more stuff to parameterize the bpf_iter,
will need to implement these two callbacks as well as bpftool.

> 
> 
> [...]
> 
