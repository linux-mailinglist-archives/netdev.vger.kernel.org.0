Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCFF5F9B81
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 10:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiJJI6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 04:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiJJI6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 04:58:43 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AFE6715C;
        Mon, 10 Oct 2022 01:58:42 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MmCPf51DlzHv53;
        Mon, 10 Oct 2022 16:53:42 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 10 Oct 2022 16:58:39 +0800
Message-ID: <b5094513-d4b7-05f2-1ed7-fed682fb9ac7@huawei.com>
Date:   Mon, 10 Oct 2022 16:58:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [bpf-next v7 1/3] bpftool: Add auto_attach for bpf prog
 load|loadall
To:     Quentin Monnet <quentin@isovalent.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <trix@redhat.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <llvm@lists.linux.dev>
References: <1664277676-2228-1-git-send-email-wangyufen@huawei.com>
 <83307f48-bef0-bff8-e3b5-f8df7a592678@isovalent.com>
 <0242ccfe-53e5-5b9d-9fd9-73fa8bd0d7a4@huawei.com>
 <5f26a827-0220-da23-f2fb-08f35ee7412e@isovalent.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <5f26a827-0220-da23-f2fb-08f35ee7412e@isovalent.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/10/10 16:40, Quentin Monnet 写道:
> Sat Oct 08 2022 06:16:42 GMT+0100 ~ wangyufen <wangyufen@huawei.com>
>> 在 2022/10/1 0:26, Quentin Monnet 写道:
>>> Tue Sep 27 2022 12:21:14 GMT+0100 ~ Wang Yufen <wangyufen@huawei.com>
>>>> Add auto_attach optional to support one-step load-attach-pin_link.
>>> Nit: Now "autoattach" instead of "auto_attach". Same in commit title.
>> will change in v8, thanks.
>>>> For example,
>>>>      $ bpftool prog loadall test.o /sys/fs/bpf/test autoattach
>>>>
>>>>      $ bpftool link
>>>>      26: tracing  name test1  tag f0da7d0058c00236  gpl
>>>>          loaded_at 2022-09-09T21:39:49+0800  uid 0
>>>>          xlated 88B  jited 55B  memlock 4096B  map_ids 3
>>>>          btf_id 55
>>>>      28: kprobe  name test3  tag 002ef1bef0723833  gpl
>>>>          loaded_at 2022-09-09T21:39:49+0800  uid 0
>>>>          xlated 88B  jited 56B  memlock 4096B  map_ids 3
>>>>          btf_id 55
>>>>      57: tracepoint  name oncpu  tag 7aa55dfbdcb78941  gpl
>>>>          loaded_at 2022-09-09T21:41:32+0800  uid 0
>>>>          xlated 456B  jited 265B  memlock 4096B  map_ids 17,13,14,15
>>>>          btf_id 82
>>>>
>>>>      $ bpftool link
>>>>      1: tracing  prog 26
>>>>          prog_type tracing  attach_type trace_fentry
>>>>      3: perf_event  prog 28
>>>>      10: perf_event  prog 57
>>>>
>>>> The autoattach optional can support tracepoints, k(ret)probes,
>>>> u(ret)probes.
>>>>
>>>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>>>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>>>> ---
>>>> v6 -> v7: add info msg print and update doc for the skip program
>>>> v5 -> v6: skip the programs not supporting auto-attach,
>>>>        and change optional name from "auto_attach" to "autoattach"
>>>> v4 -> v5: some formatting nits of doc
>>>> v3 -> v4: rename functions, update doc, bash and do_help()
>>>> v2 -> v3: switch to extend prog load command instead of extend perf
>>>> v2:
>>>> https://patchwork.kernel.org/project/netdevbpf/patch/20220824033837.458197-1-weiyongjun1@huawei.com/
>>>> v1:
>>>> https://patchwork.kernel.org/project/netdevbpf/patch/20220816151725.153343-1-weiyongjun1@huawei.com/
>>>>    tools/bpf/bpftool/prog.c | 81
>>>> ++++++++++++++++++++++++++++++++++++++++++++++--
>>>>    1 file changed, 79 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
>>>> index c81362a..84eced8 100644
>>>> --- a/tools/bpf/bpftool/prog.c
>>>> +++ b/tools/bpf/bpftool/prog.c
>>>> @@ -1453,6 +1453,72 @@ static int do_run(int argc, char **argv)
>>>>        return ret;
>>>>    }
>>>>    +static int
>>>> +auto_attach_program(struct bpf_program *prog, const char *path)
>>>> +{
>>>> +    struct bpf_link *link;
>>>> +    int err;
>>>> +
>>>> +    link = bpf_program__attach(prog);
>>>> +    if (!link)
>>>> +        return -1;
>>>> +
>>>> +    err = bpf_link__pin(link, path);
>>>> +    if (err) {
>>>> +        bpf_link__destroy(link);
>>>> +        return err;
>>>> +    }
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int pathname_concat(const char *path, const char *name, char
>>>> *buf)
>>>> +{
>>>> +    int len;
>>>> +
>>>> +    len = snprintf(buf, PATH_MAX, "%s/%s", path, name);
>>>> +    if (len < 0)
>>>> +        return -EINVAL;
>>>> +    if (len >= PATH_MAX)
>>>> +        return -ENAMETOOLONG;
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int
>>>> +auto_attach_programs(struct bpf_object *obj, const char *path)
>>>> +{
>>>> +    struct bpf_program *prog;
>>>> +    char buf[PATH_MAX];
>>>> +    int err;
>>>> +
>>>> +    bpf_object__for_each_program(prog, obj) {
>>>> +        err = pathname_concat(path, bpf_program__name(prog), buf);
>>>> +        if (err)
>>>> +            goto err_unpin_programs;
>>>> +
>>>> +        err = auto_attach_program(prog, buf);
>>>> +        if (!err)
>>>> +            continue;
>>>> +        if (errno == EOPNOTSUPP)
>>>> +            p_info("Program %s does not support autoattach",
>>>> +                   bpf_program__name(prog));
>>>> +        else
>>>> +            goto err_unpin_programs
>>> With this code, if auto-attach fails, then we skip this program and move
>>> on to the next. That's an improvement, but in that case the program
>>> won't remain loaded in the kernel after bpftool exits. My suggestion in
>>> my previous message (sorry if it was not clear) was to fall back to
>>> regular pinning in that case (bpf_obj_pin()), along with the p_info()
>>> message, so we can have the program pinned but not attached and let the
>>> user know. If regular pinning fails as well, then we should unpin all
>>> and error out, for consistency with bpf_object__pin_programs().
>>>
>>> And in that case, the (errno == EOPNOTSUPP) with fallback to regular
>>> pinning could maybe be moved into auto_attach_program(), so that
>>> auto-attaching single programs can use the fallback too?
>>>
>>> Thanks,
>>> Quentin
>> If I understand correctly, can we just check link?  as following:
> Yes, this is exactly what I meant
>
>> --- a/tools/bpf/bpftool/prog.c
>> +++ b/tools/bpf/bpftool/prog.c
>> @@ -1460,9 +1460,10 @@ static int do_run(int argc, char **argv)
>>          int err;
>>   
>>          link = bpf_program__attach(prog);
>> -       if (!link)
>> -               return -1;
>> -
>> +       if (!link) {
>> +               p_info("Program %s attach failed",
>> bpf_program__name(prog));
>> +               return bpf_obj_pin(bpf_program__fd(prog), path);
>> +       }
>>          err = bpf_link__pin(link, path);
>>          if (err) {
>>                  bpf_link__destroy(link);
>> @@ -1499,9 +1500,6 @@ static int pathname_concat(const char *path, const
>> char *name, char *buf)
>>                  err = auto_attach_program(prog, buf);
>>                  if (!err)
>>                          continue;
>> -               if (errno == EOPNOTSUPP)
>> -                       p_info("Program %s does not support autoattach",
> p_info("Program %s does not support autoattach, falling back to pinning"
>
>> -                              bpf_program__name(prog));
>>                  else
>>                          goto err_unpin_programs;
>>          }
>>
>>
>> and the doc is modified as follows:
>>
>> If the program does not support autoattach, will do regular pin along
>> with an
>> info message such as "Program %s attach failed". If the *OBJ* contains
>> multiple
>> programs and **loadall** is used, if the program A in these programs
>> does not
>> support autoattach, the program A will do regular pin along with an info
>> message,
>> and continue to autoattach the next program.
> Not sure the "program A" designation helps too much, I'd simply write this:
>
> "If a program does not support autoattach, bpftool falls back to regular
> pinning for that program instead."
>
> Which should be enough for both the "load" and "loadall" behaviours? I
> wouldn't mention the help message in the docs (the p_info() won't show
> up in the JSON output for example).

I got it. Thanks!

>
> Looks good otherwise, thanks!
