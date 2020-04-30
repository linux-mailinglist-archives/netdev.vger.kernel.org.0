Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCD81C0452
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgD3SD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:03:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9052 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbgD3SD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:03:26 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UHsLng008134;
        Thu, 30 Apr 2020 11:03:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=R8sx9E9OKfHCJsIiVcDLxBNIAU/WhUNZhFJef5n7AeI=;
 b=D6RkyhNAQTsfVxpZrYx3gAebpRdZG6Luah1JP8OosFe96xuPsFu+F2f4zVUzPo1WV03Q
 SDRdT2LTOzvOGzUxrAQIcKqkw6xmCEvIkObAwLJ5qdPa8Eo/WWAS8U5mtHdSjNikKuk0
 OGsDBI7H9mRDxm69VLZSVa/TGiijPVdtnN8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30q6y11jnb-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Apr 2020 11:03:12 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 30 Apr 2020 11:03:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vv2BSV6LpbDRZLeIEv+cXRnYkYrFn77mq2CnudFFRx4tgCOpx7wa/OBwOAg2kl46/sjybMrUsxs2xEsA1HmGJ011A1Qj8NOqMqmfp6+LuKXUelr+HQd0piygBY5uW7sslqf79JBuFjmmaodLQb0EaYxG6fUHO6+FJnSXEt4ZP3ApDKjNbkkC1BjwPwhLs3fICWA/Y3x7n0f35Zd1q04SZ3a/GnpYVF7KfSsZNhZioMG4bndjq+88LIEn7UNV4XXBNwu4yOomyUPq82+OO/BSXCtaHfN8cejE5nsgtIpBLgytxQSofey1GvK40iPGcxozNpqJoy49brPPXifZwkApwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8sx9E9OKfHCJsIiVcDLxBNIAU/WhUNZhFJef5n7AeI=;
 b=UEUpTk8nm2n3dYDvD2W8Utn/ldNGzNThsZtQPfJBrabxRCwX4yPKu80hqF8M2Esw/lgykKb56wBHjSbMLgftQdcTQYZgrVXbt7PAZhM9iOQA4IyX+EWSS4k/J+sci+Q9gjEjck03qaW03+Ht8fzHitpFy9hQOiGtK+rSoP5P21f9fNcngK5ysuVgYcX3Aw1zaz2kOh1Pk72G/Kx///STXD41BCDaFJFuXN7125OIpOColZWetHTjVkiPq2nObhywFcED4XlsuevEvMjh2EZeUltuaZ5anJAlGGL28F15WZ291JYNik9JCRXHHUKV6FK0LHMEkZFec6BByZV6IpoxbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8sx9E9OKfHCJsIiVcDLxBNIAU/WhUNZhFJef5n7AeI=;
 b=hHlC3remEOUueNkxxGv/OrY+s/7lv55nlTjmxx41xV5aFcHT3DyPktcQ7WSAEUTDg28dM9nkJc+MG/wyqQDnlJtUuUjshLnbirvbR00+In4GqYiehubm/eHTGgIQmy2Yg5G4miXnOPzWdTkHhBvaaqY/01wJeqSW2WoELCH196Y=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2341.namprd15.prod.outlook.com (2603:10b6:a02:81::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Thu, 30 Apr
 2020 18:03:07 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 18:03:07 +0000
Subject: Re: [PATCH bpf-next v1 08/19] bpf: create file bpf iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201244.2995241-1-yhs@fb.com>
 <CAEf4BzY1gor=j9kh2JxZAQc4SoyaRoVGA_7UK9z_Nb0FpCudkQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <419c2909-349a-2495-e2dd-1cd647e21d4a@fb.com>
Date:   Thu, 30 Apr 2020 11:02:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzY1gor=j9kh2JxZAQc4SoyaRoVGA_7UK9z_Nb0FpCudkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1701CA0013.namprd17.prod.outlook.com
 (2603:10b6:301:14::23) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:ea21) by MWHPR1701CA0013.namprd17.prod.outlook.com (2603:10b6:301:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 18:03:05 +0000
X-Originating-IP: [2620:10d:c090:400::5:ea21]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e413baa-8ef6-4ac0-61eb-08d7ed30bc33
X-MS-TrafficTypeDiagnostic: BYAPR15MB2341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2341C21BC9D9439974CE1104D3AA0@BYAPR15MB2341.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(39860400002)(136003)(376002)(346002)(6506007)(53546011)(52116002)(8676002)(36756003)(31696002)(478600001)(16526019)(186003)(86362001)(8936002)(66556008)(66946007)(66476007)(5660300002)(54906003)(2906002)(31686004)(6916009)(6512007)(4326008)(6666004)(6486002)(2616005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YvkHviBfvAZmTNzHMvNyEbpdjD4WtUCTGeqPZ6GJxkvJVaLEgc0dthmQLrUZa+36JaYpapxC64PcmSpmlRr7jgZnZd9blUkTHlzdfg8BuajfNRyTfw59zIzWqv5sq4WCE3Rpp9Q0n84eS/csoSXbv670DFpoFx1V0JS7WJZrSwofopwlHweJycwWRgZJb17IZeCMcGFjs+Q2WqS/DIwYcD5VnVGzM/mV/h05ED+3DxJ4dDmHVbwcj9jxXll5EMIeJGTXFgcXk7VMCpFznbr6Gma3f77Z7Q31ryDZIFMayD7elp0Iic8XdSA5vdXmb8Dw4kmWc/5LO1a82SdrRrWHEu5VYE44DJijjcndkQeqAZd1Pi2lNdjij1nuwzbMvgEInrR1u14PADABqoiihdYDCXG48EfSgA4u7Klzpu7E7TOVB6RTqkkeDSUk8a64qutl
X-MS-Exchange-AntiSpam-MessageData: mQ5t2d1qBaVioI7RwHSi0A+rVSl1D3G4dSUt2tbs1Lv2W67gDX1W/xOtQMXhjVI0hjCf6BCHko49w0CqIPplRJXF1T3RhgKHmRSGygrF3FC2mTicwz0mgRqC9NOJIADDTG1x6xLV49Q06/C6Vt5aRjSq3e/WX0ldzl0EwK4BsQIOjigpVyvlK8FvrT+X/hulTBRiSqkyAHXjlICREPRhTB4+yzeVvfQaR4asE7dVv8Q8CwLsQKH4rFKLRL5U82ogtt8aqxSAaI4mTTvY5xljyXOcO5z3Amtm6GMIV2k+eo/sbFTeAI5m6xBuZqXNihz54LPnRO5fqWQAIBQ7N8f34F08xPljVp6V42DfHkaa8fwHKclD10hcQsPyM0i4VIphwxhOhKgar08Bwx42j6abvAb2YBC3qYNUh+ngvd7rd/DI/jg64gGbLz3adJDv+RyT9KUiwVQHO+u7caooGRRn/a48Zl7dAa1Bd/zgQbLA+GSHn8rlZC64TQfsNkWWvjtxuJxKptPEVJKQ9/hOsx/35GINd6k/B0GARe6istWi8Dm5pnS9WlcOufmAQTpL98Df5WJ2ChGtGbdT4kYdK93PWoGLDFUsZwL8lpq9C49UImSurHRiRVXDEpIFjmkTlqf1lFnhU+2mvOjtUJIFdMVwQhQyWD4ryU6eoXr+Vu+Gl/kUSKza7HwDIPy7xt3qQxJ53j7yM2MhvY5L4T3ZK7X45HdiyhsTr1BLwzOM6yF0xk7vu31EJAIEq/1WmXApmx/FX9kcincgwl64dGqEDnTQXGXPoPhfZ09by+VXjt6q6et+3bXD/AbJGD3u/gQ+srp7L4yo0ErfUe/vO+V73/WgUQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e413baa-8ef6-4ac0-61eb-08d7ed30bc33
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 18:03:07.0410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xA6nIXjIFEa/94ukusRC7efLfLuHv9wYYoIAoUtNi1ikpnzmS5WMemj161kHaapi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2341
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_11:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/20 1:40 PM, Andrii Nakryiko wrote:
> On Mon, Apr 27, 2020 at 1:18 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> A new obj type BPF_TYPE_ITER is added to bpffs.
>> To produce a file bpf iterator, the fd must be
>> corresponding to a link_fd assocciated with a
>> trace/iter program. When the pinned file is
>> opened, a seq_file will be generated.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h   |  3 +++
>>   kernel/bpf/bpf_iter.c | 48 ++++++++++++++++++++++++++++++++++++++++++-
>>   kernel/bpf/inode.c    | 28 +++++++++++++++++++++++++
>>   kernel/bpf/syscall.c  |  2 +-
>>   4 files changed, 79 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 0f0cafc65a04..601b3299b7e4 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1021,6 +1021,8 @@ static inline void bpf_enable_instrumentation(void)
>>
>>   extern const struct file_operations bpf_map_fops;
>>   extern const struct file_operations bpf_prog_fops;
>> +extern const struct file_operations bpf_link_fops;
>> +extern const struct file_operations bpffs_iter_fops;
>>
>>   #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
>>          extern const struct bpf_prog_ops _name ## _prog_ops; \
>> @@ -1136,6 +1138,7 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>>   int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
>>                            struct bpf_prog *new_prog);
>>   int bpf_iter_new_fd(struct bpf_link *link);
>> +void *bpf_iter_get_from_fd(u32 ufd);
>>
>>   int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
>> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
>> index 1f4e778d1814..f5e933236996 100644
>> --- a/kernel/bpf/bpf_iter.c
>> +++ b/kernel/bpf/bpf_iter.c
>> @@ -123,7 +123,8 @@ struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_size,
>>   {
>>          struct extra_priv_data *extra_data;
>>
>> -       if (seq->file->f_op != &anon_bpf_iter_fops)
>> +       if (seq->file->f_op != &anon_bpf_iter_fops &&
>> +           seq->file->f_op != &bpffs_iter_fops)
> 
> Do we really need anon_bpf_iter_fops and bpffs_iter_fops? Seems like
> the only difference is bpffs_iter_open. Could it be implemented as
> part of anon_bpf_iter_ops as well? Seems like open() is never called
> for anon_inode_file, so it should work for both?

Yes, open() will not be used for anon_bpf_iter. I used two
file_operations just for this reason. But I guess, I can
just use one. It won't hurt.

> 
>>                  return NULL;
>>
>>          extra_data = get_extra_priv_dptr(seq->private, priv_data_size);
>> @@ -310,3 +311,48 @@ int bpf_iter_new_fd(struct bpf_link *link)
>>          put_unused_fd(fd);
>>          return err;
>>   }
>> +
>> +static int bpffs_iter_open(struct inode *inode, struct file *file)
>> +{
>> +       struct bpf_iter_link *link = inode->i_private;
>> +
>> +       return prepare_seq_file(file, link);
>> +}
>> +
>> +static int bpffs_iter_release(struct inode *inode, struct file *file)
>> +{
>> +       return anon_iter_release(inode, file);
>> +}
>> +
>> +const struct file_operations bpffs_iter_fops = {
>> +       .open           = bpffs_iter_open,
>> +       .read           = seq_read,
>> +       .release        = bpffs_iter_release,
>> +};
>> +
>> +void *bpf_iter_get_from_fd(u32 ufd)
> 
> return struct bpf_iter_link * here, given this is specific constructor
> for bpf_iter_link?
> 
>> +{
>> +       struct bpf_link *link;
>> +       struct bpf_prog *prog;
>> +       struct fd f;
>> +
>> +       f = fdget(ufd);
>> +       if (!f.file)
>> +               return ERR_PTR(-EBADF);
>> +       if (f.file->f_op != &bpf_link_fops) {
>> +               link = ERR_PTR(-EINVAL);
>> +               goto out;
>> +       }
>> +
>> +       link = f.file->private_data;
>> +       prog = link->prog;
>> +       if (prog->expected_attach_type != BPF_TRACE_ITER) {
>> +               link = ERR_PTR(-EINVAL);
>> +               goto out;
>> +       }
>> +
>> +       bpf_link_inc(link);
>> +out:
>> +       fdput(f);
>> +       return link;
>> +}
>> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
>> index 95087d9f4ed3..de4493983a37 100644
>> --- a/kernel/bpf/inode.c
>> +++ b/kernel/bpf/inode.c
>> @@ -26,6 +26,7 @@ enum bpf_type {
>>          BPF_TYPE_PROG,
>>          BPF_TYPE_MAP,
>>          BPF_TYPE_LINK,
>> +       BPF_TYPE_ITER,
> 
> Adding ITER as an alternative type of pinned object to BPF_TYPE_LINK
> seems undesirable. We can allow opening bpf_iter's seq_file by doing
> the same trick as is done for bpf_maps, supporting seq_show (see
> bpf_mkmap() and bpf_map_support_seq_show()). Do you think we can do
> the same here? If we later see that more kinds of links would want to
> allow direct open() to create a file with some output from BPF
> program, we can generalize this as part of bpf_link infrastructure.
> For now having a custom check similar to bpf_map's seems sufficient.
> 
> What do you think?

Sounds good. Will use the mechanism similar to bpf_map.

> 
>>   };
>>
>>   static void *bpf_any_get(void *raw, enum bpf_type type)
>> @@ -38,6 +39,7 @@ static void *bpf_any_get(void *raw, enum bpf_type type)
>>                  bpf_map_inc_with_uref(raw);
>>                  break;
>>          case BPF_TYPE_LINK:
>> +       case BPF_TYPE_ITER:
>>                  bpf_link_inc(raw);
>>                  break;
>>          default:
>> @@ -58,6 +60,7 @@ static void bpf_any_put(void *raw, enum bpf_type type)
>>                  bpf_map_put_with_uref(raw);
>>                  break;
>>          case BPF_TYPE_LINK:
>> +       case BPF_TYPE_ITER:
>>                  bpf_link_put(raw);
>>                  break;
>>          default:
>> @@ -82,6 +85,15 @@ static void *bpf_fd_probe_obj(u32 ufd, enum bpf_type *type)
>>                  return raw;
>>          }
>>
> 
> [...]
> 
