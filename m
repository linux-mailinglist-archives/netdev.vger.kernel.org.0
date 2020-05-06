Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4A41C7889
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgEFRs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:48:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35234 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729681AbgEFRs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 13:48:28 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046HdeCE028275;
        Wed, 6 May 2020 10:48:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Itx9RP0K1sHne4XY2yO3XsazbQIQRVZ7dVaR+r62pWo=;
 b=UdCeeRB5/OOdl+uigRd9Hl7vtwsBA7dVG0sS9Br088KZT/TX3dv+6I7wVDblKjBXWh2+
 fQxDnB5gyQvhNbLLEze6jEId9MzcXTJZHfhrI5gwplOnQRvLcR/cL7kM4srKxnTTTVyb
 Sqj+cz3y/2QjFGuS47qmw8IsH5iOWPKfIH8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30v0hp0grx-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 10:48:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 10:48:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6rIb1Mm+CPHRVgAiabPcVH22Op/HeLesxZje1lHbi/hCQLSfRHe+J4Wio/+jX++e3Z29836i5PfwPEB7G1wLC0CnKHBkePpi4EGoVehI2sxXIq+RihuJ9SfzzjV6f+5UWHfr5uZ2luiXOK0g7v4Pvd4LKi3CDdQJfLPK/UZL3u4YVHWpWQ/4MKIbY+iVqt43PUqzM44ILS92ImP8CNvw8e2ku6v5s36xkjBANCh79HYli3+BbcVRUmSA8k7RnByfEpZDNQ81GF6vwgb3cnMOtF7ynVEMCNqXp88con3ZfXXY4wsS8J4lxQyVopAO/f2FOwpKEfgkTFmEGFz5U/1mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Itx9RP0K1sHne4XY2yO3XsazbQIQRVZ7dVaR+r62pWo=;
 b=W/dBHmvaLP2SYhOP5eNaq+mQO4h5a6ccVELC/SFPbg+wTrRexvV3Bh7BHtE0zBxC6J7tKbg1aE4+0Pp/2R8FuwYTjroV6yf+DKPlp694hyTE0mkvfEwbjzZkSC8KSYQ1Qrpl1aokGpj+dz+u2lcOQkXoVD9rlqsY/CQvnK938qWZ+C1dqidB3OruxkJ1pADZbCpPt+PntkvDRRrRhEhHR15YdYpqFLcE9/e9r3VusFHRUc7Kivj9cmDNGifqO06vGJgyXF7uliDCfPQr2AGYwskxGYvKXWQNsWC5/bR0UEaMV2wgKh5PG8LKDaxxmuWyIywpuMDJG+zCJSaWKVqRSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Itx9RP0K1sHne4XY2yO3XsazbQIQRVZ7dVaR+r62pWo=;
 b=dM5/UYGn/0WRLQrIxcQqwo6XgKI335KonSzcWdcTxZNcfDRs8oHCuP1CNKQh6EwiIiLOmvoUTHdTvSD36un4J0MjlBatwQBItK3Vv6stZw1o3uJ1jZGHYwQhnUJgRwDSUFHPrUL9HPCCGli3UXnag5mhXJ8ei8sKhNS167aGu4A=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3110.namprd15.prod.outlook.com (2603:10b6:a03:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Wed, 6 May
 2020 17:32:06 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 17:32:06 +0000
Subject: Re: [PATCH bpf-next v2 10/20] net: bpf: add netlink and ipv6_route
 bpf_iter targets
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062558.2048168-1-yhs@fb.com>
 <CAEf4BzbtR71iWPdNmjy0kvfQC4xQr+MFe6Vh2k6Kzu0cfsVVzg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d1589865-b891-458b-3d24-acc4b4c4f504@fb.com>
Date:   Wed, 6 May 2020 10:32:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzbtR71iWPdNmjy0kvfQC4xQr+MFe6Vh2k6Kzu0cfsVVzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0003.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:f689) by BYAPR02CA0003.namprd02.prod.outlook.com (2603:10b6:a02:ee::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Wed, 6 May 2020 17:32:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:f689]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75f47fb3-272e-46f4-a92a-08d7f1e36557
X-MS-TrafficTypeDiagnostic: BYAPR15MB3110:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3110D4D1BAE4D0B1E0D84BB1D3A40@BYAPR15MB3110.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hnX6E8RQD2qbiysyV+QMYK7kSKKXqZU3KMVXoGykTSHWy3F36mxr4EkHuc/Im98NPJnGx9TwT10/dfqTq8C77TAUzX/78a6H8AV5oi4VLItrIU0lF5vQ6h3HDfb9fSoBdZJIhkLRiyUjOxCiUn2Zo1MXeWESKezHXWHaSr7T8MlomGRAkzWtX9RFCu/po8xeFGYBHkERs0Ch/LxIUEcSyBAuxIE0xakmHw6t4YukaiBd8t1mLKZnEX+PTP6f3aU4tWrHdteDFTya3Y/EKUsAMzvojjibJA8tE5tZDbCpIBuX3oTFuwotW335fc+0RF2psIUzH4qowB3LXqqAzJaPYqn37hNt1tZ+yw1Qn40jEcfMpyCFP5u9yxKPS2R2xgTofXKB8bAmabS1oFlWKK3LQkkrpxWHoM13JbBgyH8+E5ZHErNBR9z0sjy1WBsJTaC63XxGlB7QYYEWLBaknzxukvmJuH1O2SMUffnVeMhOTUSQ3uGdtqPknuSa/s2eXFWBCP86aDDLB+nkH9aC6w7Qdy9TOO3qJakNGi6QJ91r8SAfzXVYzx9a0uyCg+eC1MlW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(396003)(136003)(376002)(346002)(33430700001)(33440700001)(66556008)(66946007)(316002)(66476007)(52116002)(5660300002)(53546011)(186003)(6506007)(16526019)(54906003)(2616005)(478600001)(31696002)(6512007)(6486002)(8676002)(31686004)(6916009)(4326008)(86362001)(2906002)(8936002)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: OBJtIjxqjaUXtJnQn4SN9CvaAl8QytYmmkf9iufASoCQmV1RE4On3IJJTnCH8kK07WRQOwNCtktv2Uy6eFdEvKZU0k4imyjBeTrL7YHVTfHSuHQmdDn8s5D55Z91woaFMpjxXYE6olUYfeO+676luBKVLKVitqqZerkThdORPbIBi6fJJANTHYcEHudfTirwlQ68oFVd4YIjU/hdZ7/+i/Eh63Oj0NXMj0TpS6425XjkTt+lL/bCwTbsglMsGhGmZdX5pbk1v4c+tJgk76OQivEvzGafpVcwwLNevCSDWd4HG+pt3pJeGJfCFd7J0yyrTqKY0xsmXdcQJ0DVw4F6vUP6HC4BypCw6H6beM65JWX1/7GPHTG9YXfSql9AYUW41okOI0aue4vg2RWQqs82SIY9YU/7mCe2sAn7KfPa/AFz4FFhYaNtGz5wivxSNJK+FTY0C8qqu4Cjtc9BSqJu1NG2kCPzUU9FrCB3SZVATFbejiwA4RG//sCMAtTRXGIDgT/VuIs8g99ebQMx+y5yglqepOeYo1BkNIsiKreO+eV6gpvAHQgwfkUl2HycUgCc+jW/VuMe7608SC7I8RMaW/AxxF8SqYQcDQejuPrv5pbp3aJFTbQVo2+EjbN4mO78Ykmy5kVT4MY+ENULIOR/zGb8WoD85JBKomkO4u+5/hio4AR021s0AW/PR/bU9rIJ6bWkpuuOnzhsIufpkt0h5DQDXQbW3sYtjgGAlV996Xi41Lb/ViezsK/qSW7MmPHrTUTOkejIS9a3viBYZIy+WYIKx9g1ky6PEnWMw0yBrJJZGMibjYT/tl3LJYPQ/ICMwTZqSjmLlM6OM83At0TpoA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f47fb3-272e-46f4-a92a-08d7f1e36557
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 17:32:06.3804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7t2Kpn/ZWDtOs+Zaglqwch9/wPSI8UMv+wX1/QVhA6T23XivLRmG7ISN11lUCeWZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3110
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 10:21 PM, Andrii Nakryiko wrote:
> On Sun, May 3, 2020 at 11:29 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> This patch added netlink and ipv6_route targets, using
>> the same seq_ops (except show() and minor changes for stop())
>> for /proc/net/{netlink,ipv6_route}.
>>
>> The net namespace for these targets are the current net
>> namespace at file open stage, similar to
>> /proc/net/{netlink,ipv6_route} reference counting
>> the net namespace at seq_file open stage.
>>
>> Since module is not supported for now, ipv6_route is
>> supported only if the IPV6 is built-in, i.e., not compiled
>> as a module. The restriction can be lifted once module
>> is properly supported for bpf_iter.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   fs/proc/proc_net.c       | 19 +++++++++
>>   include/linux/proc_fs.h  |  3 ++
>>   net/ipv6/ip6_fib.c       | 65 +++++++++++++++++++++++++++++-
>>   net/ipv6/route.c         | 27 +++++++++++++
>>   net/netlink/af_netlink.c | 87 +++++++++++++++++++++++++++++++++++++++-
>>   5 files changed, 197 insertions(+), 4 deletions(-)
>>
> 
> [...]
> 
>>   int __init ip6_route_init(void)
>>   {
>>          int ret;
>> @@ -6455,6 +6474,14 @@ int __init ip6_route_init(void)
>>          if (ret)
>>                  goto out_register_late_subsys;
>>
>> +#if IS_BUILTIN(CONFIG_IPV6)
>> +#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
>> +       ret = bpf_iter_register();
>> +       if (ret)
>> +               goto out_register_late_subsys;
> 
> Seems like bpf_iter infra is missing unregistering API.
> ip6_route_init(), if fails, undoes all the registrations, so probably
> should also unregister ipv6_route target as well?

Yes, it is. But not in this function. In this function, 
bpf_iter_register() is the last one possibly causing error,
so there is no need to unregister here.

But there is another cleanup funciton called outside of this
function, I need to do proper unregister there.

Thanks for catching this.

> 
>> +#endif
>> +#endif
>> +
>>          for_each_possible_cpu(cpu) {
>>                  struct uncached_list *ul = per_cpu_ptr(&rt6_uncached_list, cpu);
>>
> 
> [...]
> 
>> +static void netlink_seq_stop(struct seq_file *seq, void *v)
>> +{
>> +       struct bpf_iter_meta meta;
>> +       struct bpf_prog *prog;
>> +
>> +       if (!v) {
>> +               meta.seq = seq;
>> +               prog = bpf_iter_get_info(&meta, true);
>> +               if (prog)
>> +                       netlink_prog_seq_show(prog, &meta, v);
> 
> nit: netlink_prog_seq_show() can return failure (from BPF program),
> but you are not returning it. Given seq_file's stop is not supposed to
> fail, you can explicitly cast result to (void)? I think it's done in

Yes, we can do this. An explicit casting expressed the intention.

> few other places in BPF code, when return result is explicitly
> ignored.
> 
> 
>> +       }
>> +
>> +       netlink_native_seq_stop(seq, v);
>> +}
>> +#else
> 
> [...]
> 
