Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77435571551
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 11:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiGLJGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 05:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiGLJGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 05:06:43 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4127172E
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 02:06:41 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y4so9266783edc.4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 02:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qYA+CXnEl7sfS6k4g6zHHThVZs8dy55zsI6lMrLacaY=;
        b=aYBI2z7PA36pGhgjlUbNBRX+vHc3wQvJievLrFZtAfUCjO1g/8yqhR8RaFRKn8X8JR
         vB26NAW2t5IxIMu3mCn+G+6tYXSrp0Dk6xSos5W5kFJWjaHG/BDmxOAjsB8Rm0l6bx2A
         3QmwccZ2fQR6FlBK7mpYNwp1mEQZ6miNuodkTcpCN6Yawuq8b3PHw3FGbbhY1IrogwKd
         BMXNMAMuDXuQV8+8aRV61tnvw4owfyLc1SAEqS2hsAyxgM05XFvYBPI9FMo5B68Mcjra
         6tOW0XHjlxVHBrlW1RCiOd3VrF23+0JxGJ0j8EQwYNBHaGBNZwoVE9Up8J+PDy3Ma2xT
         ifhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qYA+CXnEl7sfS6k4g6zHHThVZs8dy55zsI6lMrLacaY=;
        b=rEve3lzxQbQHYhdV2QVDUeHq9rggYBwfV4nKvrMEYH+z/MDNmbhXz651BKXuguEzLt
         W1YbbUlWYdnJuBDWbKsBkPxtjL2uIOEcRJcZwHVKfu5EnE+2TXJ790Uv6T3Dzo1Bq0ip
         mb/TDo+nuPgTFMWO+g0GEkmhOE7/9/WdYDLzKJbVUi5qRG2ybVLbxzV2Ibszm3YvxBSb
         3Hcm8kwqo6Zkf8sBjWwJA8/wwjp3J/NHI2JuiNAR3MjL48dRmMOSKHFCPn2JAe2mQWnp
         BRp0b60qfL+eMrlgS4a4sJQFNoE5nsZ1vgE/aoYoDdZ1EL/FoCiCFqg7/DXiSIzSifqr
         LyxQ==
X-Gm-Message-State: AJIora/m7fXKHVH+Qeg4JQKl5IZmMAhB4k8Cd82jND7/EpBiZXcYC71e
        9NNyyog4ccSYCdVXgnhUos6GIw==
X-Google-Smtp-Source: AGRyM1uhar7ip0dqkB0ceBmPEnItulW4wUgu8zUqEkAtY3ZqOdlRnk83HfpQf+FiI7s9q4Cm6flCuQ==
X-Received: by 2002:aa7:ce8a:0:b0:43a:7b0e:9950 with SMTP id y10-20020aa7ce8a000000b0043a7b0e9950mr30451101edv.58.1657616799959;
        Tue, 12 Jul 2022 02:06:39 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:dee3:acc:246:d17a? ([2a02:578:8593:1200:dee3:acc:246:d17a])
        by smtp.gmail.com with ESMTPSA id i8-20020a170906a28800b0072b13fa5e4csm3617403ejz.58.2022.07.12.02.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 02:06:39 -0700 (PDT)
Message-ID: <5710e8f7-6c09-538f-a636-2ea1863ab208@tessares.net>
Date:   Tue, 12 Jul 2022 11:06:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next] mptcp: Add struct mptcp_sock definition when
 CONFIG_MPTCP is disabled
Content-Language: en-GB
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Geliang Tang <geliang.tang@suse.com>, mptcp@lists.linux.dev
References: <20220711130731.3231188-1-jolsa@kernel.org>
 <6d3b3bf-2e29-d695-87d7-c23497acc81@linux.intel.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <6d3b3bf-2e29-d695-87d7-c23497acc81@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri, Mat,

On 11/07/2022 23:21, Mat Martineau wrote:
> On Mon, 11 Jul 2022, Jiri Olsa wrote:
> 
>> The btf_sock_ids array needs struct mptcp_sock BTF ID for
>> the bpf_skc_to_mptcp_sock helper.
>>
>> When CONFIG_MPTCP is disabled, the 'struct mptcp_sock' is not
>> defined and resolve_btfids will complain with:
>>
>>  BTFIDS  vmlinux
>> WARN: resolve_btfids: unresolved symbol mptcp_sock
>>
>> Adding empty difinition for struct mptcp_sock when CONFIG_MPTCP
>> is disabled.
>>
>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>> ---
>> include/net/mptcp.h | 4 ++++
>> 1 file changed, 4 insertions(+)
>>
>> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
>> index ac9cf7271d46..25741a52c666 100644
>> --- a/include/net/mptcp.h
>> +++ b/include/net/mptcp.h
>> @@ -59,6 +59,10 @@ struct mptcp_addr_info {
>>     };
>> };
>>
>> +#if !IS_ENABLED(CONFIG_MPTCP)
>> +struct mptcp_sock { };
>> +#endif
> 
> The only use of struct mptcp_sock I see with !CONFIG_MPTCP is from this
> stub at the end of mptcp.h:
> 
> static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock
> *sk) { return NULL; }
> 
> It's normally defined in net/mptcp/protocol.h for the MPTCP subsystem code.
> 
> The conditional could be added on the line before the stub to make it
> clear that the empty struct is associated with that inline stub.

If this is required only for this specific BPF function, why not
modifying this stub (or add a define) to return "void *" instead of
"struct mptcp_sock *"?

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
