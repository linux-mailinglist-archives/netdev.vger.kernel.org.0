Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4996B7DE3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjCMQnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjCMQnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:43:41 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D60B1C7C3;
        Mon, 13 Mar 2023 09:43:37 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id rj10so2101662pjb.4;
        Mon, 13 Mar 2023 09:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678725817;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LXQxwCKYToKzDwWzgJpEgfvWuL+0x5fhR/1cZ7cMLzY=;
        b=PWJGCcj245EXieHREgbhAyJiv1nsgCeE0OaiM4tGVR8fxKKZaBwxkqC5FtPqoy5SdA
         y/Y8vBFpe6sV3lv9ez8GDXVNCZTdCqKcCZx1KhMkzH7bhdRnwGYjw4rMBB91zGZ0++xA
         1WDbfwvNwUJnOTFKhLEeUYjs0QTSMdj7xmVyuB+FzRWRH9lluKfoNsTaUyqgMIL6AlSO
         CD+Tk/iK5uIib8ra/EJOicx8vkitJZGfPBegipHj8ui8O80B42/kk4HuUERg6PPkEhAo
         tk8xI/mQ1cHJbb+Hgbx6uVd546ZAtyrkke2rOYYTNjAeHTwigTiFSLNDMkxtgb7TX7+c
         XqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678725817;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LXQxwCKYToKzDwWzgJpEgfvWuL+0x5fhR/1cZ7cMLzY=;
        b=I1bEWoI6QuwFuBjlZAI4FIRanA/m3StpKSDqvyfzwEXJuIj5HOhYVo0rmxh9ON5vMH
         M8EeInsR04bD5S5N2c+/tIzDEpq/a/cS6uJVr/OV3wdB3BSHSnSZp7diALad/vJZP/c1
         UL78hQX7cB3RgRA9Bc17QWxt+no0/aYZZgj4aRqdyjGdILfIUh/sFBeSSJh920P8rhTD
         hb4i9mqGyU8VlK/wOFoU30aguR/BNJEZfh+/qNbBSnOg2Ljk2AQ5PRecIFk00aS923QB
         Z+wEd87W3+NqVB0y5eM+yRIGxNZcxLn1HveV261ME6l8wKM/Q2HmZ0Glx2yPtpOgRBrb
         nRjQ==
X-Gm-Message-State: AO0yUKWDNktB7US1MzwF2zstNysuF9lB5dtWAJSKLxBX10ElcQqxCspt
        mo5SjGaIhRpeoXTMNxNRDIs=
X-Google-Smtp-Source: AK7set/el5HFyISkApP4+02NfB0bv94VF9RseCQY4Viz9XBJowzP51tTH4VSo7/PQMbPooe57OYzcA==
X-Received: by 2002:a05:6a20:748c:b0:cd:1a05:f4ea with SMTP id p12-20020a056a20748c00b000cd1a05f4eamr36343714pzd.50.1678725816946;
        Mon, 13 Mar 2023 09:43:36 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21c1::15e2? ([2620:10d:c090:400::5:60fb])
        by smtp.gmail.com with ESMTPSA id 4-20020aa79144000000b005d61829db4fsm4608545pfi.168.2023.03.13.09.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 09:43:36 -0700 (PDT)
Message-ID: <49fa2455-f591-3062-9780-dadadbf388c8@gmail.com>
Date:   Mon, 13 Mar 2023 09:43:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v6 2/8] net: Update an existing TCP congestion
 control algorithm.
Content-Language: en-US, en-ZW
From:   Kui-Feng Lee <sinquersw@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Kui-Feng Lee <kuifeng@meta.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, martin.lau@linux.dev,
        song@kernel.org, kernel-team@meta.com, andrii@kernel.org,
        sdf@google.com, netdev@vger.kernel.org
References: <20230310043812.3087672-1-kuifeng@meta.com>
 <20230310043812.3087672-3-kuifeng@meta.com>
 <20230310084750.482e633e@hermes.local>
 <ec19df13-0f0a-d05b-f2a2-6e8cfe072fa5@gmail.com>
In-Reply-To: <ec19df13-0f0a-d05b-f2a2-6e8cfe072fa5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/13/23 08:46, Kui-Feng Lee wrote:
> 
> 
> On 3/10/23 08:47, Stephen Hemminger wrote:
>> On Thu, 9 Mar 2023 20:38:07 -0800
>> Kui-Feng Lee <kuifeng@meta.com> wrote:
>>
>>> This feature lets you immediately transition to another congestion
>>> control algorithm or implementation with the same name.  Once a name
>>> is updated, new connections will apply this new algorithm.
>>>
>>> Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
>>
>> What is the use case and userspace API for this?
>> The congestion control algorithm normally doesn't allow this because
>> algorithm specific variables (current state of connection) may not
>> work with another algorithm.
> 
> Only new connections will apply the new algorithm, while
> existing connections keep using the algorithm applied. It shouldn't
> have the per-connection state/variable issue you mentioned.
> 
> It will be used to upgrade an existing algorithm to a new version.
> The userspace API is used in the 8th patch of this patchset.
> One of examples in the testcase is
> 
>    link = bpf_map__attach_struct_ops(skel->maps.ca_update_1);
>    .......
>    err = bpf_link__update_map(link, skel->maps.ca_update_2);
> 
> Calling bpf_link__update_map(...) will register ca_pupdate_2 and
> unregister ca_update_1 with the same name
> in one call.  However, the existing connections that has applied
> ca_update_1 keep using the algorithm except someone call
> setsockopt(TCP_CONGESTION, ...) on them.

FYI!
The thread head of the patchset is
  https://lore.kernel.org/all/20230310043812.3087672-1-kuifeng@meta.com/


> 
> 
> 
>>
>> Seems like you are opening Pandora's box here.
> 
