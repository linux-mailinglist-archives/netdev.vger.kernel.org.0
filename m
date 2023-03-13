Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEBE6B7C52
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjCMPqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 11:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjCMPqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:46:33 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF795D45D;
        Mon, 13 Mar 2023 08:46:32 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so2575068pjz.1;
        Mon, 13 Mar 2023 08:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678722392;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zDyOkoFnhZROPctgeWISqNuHE+Oq1ns/S8cynzzVLLQ=;
        b=SZy093BBwASY2LmXz6fWeD2QN3KkuTZE8AZRG6U9RCkjysmUWW2hLKo1dQuwQb/uzU
         /chwQhlAtbMZVSrj/1loXOvr6mUH1EA4co9ZSwSuEuwbSDrN870b3UhbuSMBmbWTkx7t
         MKb0Em2KyOKa/sb39onVU/5BXDKbiU+/eqyBB+QERd+vQbRI1vOzofvr33u5KcuqhABd
         P7HwsHv3oW2enBtVBzvTB6qpoxFLqAllo69JEkbz+IpKTnD1xKBgUuLUKK5ahZ1+yznh
         HOmFLgDRWZlDzHZY6fgzrTdT6emIv/T7a7AS27u+X+1qENm0PF+5k9Udir3lTLzg6iex
         3D9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678722392;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zDyOkoFnhZROPctgeWISqNuHE+Oq1ns/S8cynzzVLLQ=;
        b=I/xbP93TzIrMumtw+TeoOJi+6CjY5O4veukCHLEicb3TEFYq1iUIt1HPg+spxlK8Pv
         cmPEO/UFwqoIW1EETT03PnBTlpB6YrKajmd8D/TClmvA6vuyMFjgOP06e3IT4VK4jD5x
         GDZd8HCoz4iesh89qgQslZzP2vSppaXOqu7/PhZhSgafSOhbxXIj9IMvAlYgihf0Fz1S
         TGcdhWhEZnviCWSang7uEZ+g4PPUL4MwXZrCSTB+PxqCScEARw2WgSohibcM0oUVNo+7
         CUg4JWEUFyAW8xRn/dmGy0/SYvUIrXZ4ftq61Nh5fIQYIhuyYK6FHo8wJB2l/MIz/oo0
         /2kg==
X-Gm-Message-State: AO0yUKUNao6UpzO9AwDWT32PMWOGhDBcF8iOPQiiSyNmtpGo9jKtL0Nt
        whg7aOQC+Z+WL1S75/wkHI8=
X-Google-Smtp-Source: AK7set/PzQK6v+D13DwO2XP5KhnGB9fm2o4OFc6rwAKhDceSoLF6j9djA69o4q7HHFFtl6GFJS6kYw==
X-Received: by 2002:a17:902:b20d:b0:1a0:4046:23f2 with SMTP id t13-20020a170902b20d00b001a0404623f2mr3760708plr.56.1678722392278;
        Mon, 13 Mar 2023 08:46:32 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21c8::1441? ([2620:10d:c090:400::5:37cf])
        by smtp.gmail.com with ESMTPSA id kc7-20020a17090333c700b0019cbe436b87sm59388plb.81.2023.03.13.08.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 08:46:31 -0700 (PDT)
Message-ID: <ec19df13-0f0a-d05b-f2a2-6e8cfe072fa5@gmail.com>
Date:   Mon, 13 Mar 2023 08:46:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v6 2/8] net: Update an existing TCP congestion
 control algorithm.
Content-Language: en-US, en-ZW
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Kui-Feng Lee <kuifeng@meta.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, martin.lau@linux.dev,
        song@kernel.org, kernel-team@meta.com, andrii@kernel.org,
        sdf@google.com, netdev@vger.kernel.org
References: <20230310043812.3087672-1-kuifeng@meta.com>
 <20230310043812.3087672-3-kuifeng@meta.com>
 <20230310084750.482e633e@hermes.local>
From:   Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <20230310084750.482e633e@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/23 08:47, Stephen Hemminger wrote:
> On Thu, 9 Mar 2023 20:38:07 -0800
> Kui-Feng Lee <kuifeng@meta.com> wrote:
> 
>> This feature lets you immediately transition to another congestion
>> control algorithm or implementation with the same name.  Once a name
>> is updated, new connections will apply this new algorithm.
>>
>> Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
> 
> What is the use case and userspace API for this?
> The congestion control algorithm normally doesn't allow this because
> algorithm specific variables (current state of connection) may not
> work with another algorithm.

Only new connections will apply the new algorithm, while
existing connections keep using the algorithm applied. It shouldn't
have the per-connection state/variable issue you mentioned.

It will be used to upgrade an existing algorithm to a new version.
The userspace API is used in the 8th patch of this patchset.
One of examples in the testcase is

   link = bpf_map__attach_struct_ops(skel->maps.ca_update_1);
   .......
   err = bpf_link__update_map(link, skel->maps.ca_update_2);

Calling bpf_link__update_map(...) will register ca_pupdate_2 and
unregister ca_update_1 with the same name
in one call.  However, the existing connections that has applied
ca_update_1 keep using the algorithm except someone call
setsockopt(TCP_CONGESTION, ...) on them.



> 
> Seems like you are opening Pandora's box here.

