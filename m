Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CEA529556
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 01:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346671AbiEPXfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 19:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346236AbiEPXfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 19:35:09 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608743FD83
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 16:35:08 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q4so15866210plr.11
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 16:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=SW/UVWzWsdpJtnPhkcqrIpoiIUSTo1h+7uoKjNI2+sQ=;
        b=EvEOYmoNSLO0F/CcduL33KGkB1dDXrs0mafz3naiC3Dca5nTLoBgRdodtmP1lB7IPT
         qheWKdsw9O7nI9FVnktp0GhXxiTwqOcSPSxamYPQyroUlLiT2NEDcDMcMxIk0OTkNEFK
         /+0KcO/3FdiAxEF+vMSkP6pxPzWQ7DCgbAAIkHNXhanU2Ao8T9HlBRdhVKYW+3FeKPQ2
         drS9RMj6vOH4cHprgKeR5oJvUU7v5fZeH2EvdjmG34hm9465T9vpHBSLZZJcDuOKRSvh
         ATJZRzaXCigEJr3VtTPmbOf5v9njTq4uM1nOx6DpISa/YbJVb0hD9t1hokEVX5HA7QRN
         lj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=SW/UVWzWsdpJtnPhkcqrIpoiIUSTo1h+7uoKjNI2+sQ=;
        b=x4BhKzuRlcOZSFDa/kTnAr+AZdCs7gSA+wbJEo3x3jcSFW44L70dnvNNVVF/p7nato
         TuVgSjkSDNwAmufbOhdoXISRG/DqTZQ3jUeZnEZfhal/7UEQmMVVm7z2aOYFFEONZeDM
         aqN8/YtukssswkCw35ay7lrroJmQEGnA/zzkHo/sKtKXy/IeltSbq+xEVxDbKbBpF2gJ
         sj3BILBxnn/cHbWaLZTPYD6SSmmar61cGe2rqTWmS55YmNrRZxZp2DWOf9aOgnlQMsDD
         MgbiKWLEw1DyagbMtseBXJaziASjxEG6j+3fk1rMU7+HqSoIF9VXa6CI7LQGkXSfbsGj
         7/8w==
X-Gm-Message-State: AOAM5324NnwSVE9JEWIrmt5LDrYVRqBBLU8DgNZpKwfXBSupCamSSb+n
        zkXgtWkRKuuP1f1AdcGxZUUg4g==
X-Google-Smtp-Source: ABdhPJyNjNJettvNBuBgmW/vaef9bry0PDcDa2E6bPktWOuBgPoYjqvHActZgPFjBtpIdhY6VXtTKg==
X-Received: by 2002:a17:90a:528f:b0:1dc:9a7c:4a3 with SMTP id w15-20020a17090a528f00b001dc9a7c04a3mr21607865pjh.112.1652744107892;
        Mon, 16 May 2022 16:35:07 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id j6-20020a17090adc8600b001df3a251cc2sm259493pjv.4.2022.05.16.16.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 16:35:07 -0700 (PDT)
Message-ID: <2fcdbecf-5352-ea81-ee42-ee10fbe2f72e@linaro.org>
Date:   Mon, 16 May 2022 16:35:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
References: <CAEf4Bzah9K7dEa_7sXE4TnkuMTRHypMU9DxiLezgRvLjcqE_YA@mail.gmail.com>
 <20220513190821.431762-1-tadeusz.struk@linaro.org>
 <CAEf4BzY-p13huoqo6N7LJRVVj8rcjPeP3Cp=KDX4N2x9BkC9Zw@mail.gmail.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH v3] bpf: Fix KASAN use-after-free Read in
 compute_effective_progs
In-Reply-To: <CAEf4BzY-p13huoqo6N7LJRVVj8rcjPeP3Cp=KDX4N2x9BkC9Zw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/16/22 16:16, Andrii Nakryiko wrote:
> On Fri, May 13, 2022 at 12:08 PM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>>   kernel/bpf/cgroup.c | 64 +++++++++++++++++++++++++++++++++++++++------
>>   1 file changed, 56 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
>> index 128028efda64..9d3af4d6c055 100644
>> --- a/kernel/bpf/cgroup.c
>> +++ b/kernel/bpf/cgroup.c
>> @@ -681,6 +681,57 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
>>          return ERR_PTR(-ENOENT);
>>   }
>>
>> +/**
>> + * purge_effective_progs() - After compute_effective_progs fails to alloc new
>> + *                           cgrp->bpf.inactive table we can recover by
>> + *                           recomputing the array in place.
>> + *
>> + * @cgrp: The cgroup which descendants to traverse
>> + * @link: A link to detach
>> + * @atype: Type of detach operation
>> + */
>> +static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
>> +                                 enum cgroup_bpf_attach_type atype)
>> +{
>> +       struct cgroup_subsys_state *css;
>> +       struct bpf_prog_array_item *item;
>> +       struct bpf_prog *tmp;
>> +       struct bpf_prog_array *array;
>> +       int index = 0, index_purge = -1;
>> +
>> +       if (!prog)
>> +               return;
>> +
>> +       /* recompute effective prog array in place */
>> +       css_for_each_descendant_pre(css, &cgrp->self) {
>> +               struct cgroup *desc = container_of(css, struct cgroup, self);
>> +
>> +               array = desc->bpf.effective[atype];
> 
> ../kernel/bpf/cgroup.c:748:23: warning: incorrect type in assignment
> (different address spaces)
> ../kernel/bpf/cgroup.c:748:23:    expected struct bpf_prog_array *array
> ../kernel/bpf/cgroup.c:748:23:    got struct bpf_prog_array [noderef] __rcu *
> 
> 
> you need rcu_dereference here? but also see suggestions below to avoid
> iterating effective directly (it's ambiguous to search by prog only)

I didn't check it with sparse so I didn't see this warning.
Will fix in the next version.

> 
>> +               item = &array->items[0];
>> +
>> +               /* Find the index of the prog to purge */
>> +               while ((tmp = READ_ONCE(item->prog))) {
>> +                       if (tmp == prog) {
> 
> I think comparing just prog isn't always correct, as the same program
> can be in effective array multiple times if attached through bpf_link.
> 
> Looking at replace_effective_prog() I think we can do a very similar
> (and tested) approach:
> 
> 1. restore original pl state in __cgroup_bpf_detach (so we can find it
> by comparing pl->prog == prog && pl->link == link)
> 2. use replace_effective_prog's approach to find position of pl in
> effective array (using this nested for loop over cgroup parents and
> list_for_each_entry inside)
> 3. then instead of replacing one prog with another do
> bpf_prog_array_delete_safe_at ?
> 
> I'd feel more comfortable using the same tested overall approach of
> replace_effective_prog.

Ok, I can try that.

> 
>> +                               index_purge = index;
>> +                               break;
>> +                       }
>> +                       item++;
>> +                       index++;
>> +               }
>> +
>> +               /* Check if we found what's needed for removing the prog */
>> +               if (index_purge == -1 || index_purge == index - 1)
>> +                       continue;
> 
> the search shouldn't fail, should it?

I wasn't if the prog will be present in all parents so I decided to add this
check to make sure it is found.

> 
>> +
>> +               /* Remove the program from the array */
>> +               WARN_ONCE(bpf_prog_array_delete_safe_at(array, index_purge),
>> +                         "Failed to purge a prog from array at index %d", index_purge);
>> +
>> +               index = 0;
>> +               index_purge = -1;
>> +       }
>> +}
>> +
>>   /**
>>    * __cgroup_bpf_detach() - Detach the program or link from a cgroup, and
>>    *                         propagate the change to descendants
>> @@ -723,8 +774,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>>          pl->link = NULL;
>>
>>          err = update_effective_progs(cgrp, atype);
>> -       if (err)
>> -               goto cleanup;
>> +       if (err) {
>> +               struct bpf_prog *prog_purge = prog ? prog : link->link.prog;
>> +
> 
> so here we shouldn't forget link, instead pass both link and prog (one
> of them will have to be NULL) into purge_effective_progs

ok, I will pass in both.

-- 
Thanks,
Tadeusz
