Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576E025FDCE
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgIGP6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730012AbgIGOuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:50:40 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2F7C061575
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 07:50:39 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a65so14598266wme.5
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 07:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DinUSQlSNAtBZl1poOuoTi8r63ZyczWh89UGQokdimg=;
        b=zVxkI05+Lzjv1QKQLFyDIqCe+3maw5Wwz4fbaRSokoA4LeQLM+HrfTXeMCEVGPV1Q3
         b6WdkBjOuZB2lq9VcrB/xew5mV14f62DAzDrWsXhhWGinorDyzuOPLb92zMNg0+XJnBe
         Ob0dAcm2uNIVZwL3xPDW3c9MWpHz7wnODe96tw0izmRZJX83vEEz1v1bfPp4LNtCHDUB
         qzIaBTZXD4rVKnDk/iDjiqkVdfRVKSh2OItjPO+dFuxUIWZzJ66LGDDryObpAY7pnDDR
         kIfzRXNG2J3MH4wmd6cwNH9fmm1129pFCwaSz8eUZWy2C98r+7uhwGNHCz6pF9D8tMZ3
         dniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DinUSQlSNAtBZl1poOuoTi8r63ZyczWh89UGQokdimg=;
        b=QEOgGTqxeA7/1m/G4vt4F1eeyQSM+KFeND5zALOMx8N3htf3WrHyB/aGdh1hLslgXG
         PayF1us63il2abnJ1boPB1EIraZzs0r2oV51+bHgE5wj+yft2ZAq8NQ0+QBIDanTgIVp
         WNKo8CFuznaj5+XRzPs+jhbWIlMV3nGj0yor6UXM+e6mPGl96j/5wu4nByuBe2gvu2dL
         /gPMn1NXvUHMMyeNBEEt5mW8wJ8HWv/Ai1Kku+s0KG5fOLifbhBS23d//DoskBHwnVo0
         xxESY4P4678Tpsvw8c1hsEnoXVPsQFbYijxGH74Q9h403OFAphA4wqTC9QUCyGbmTadV
         ew+A==
X-Gm-Message-State: AOAM531WvPjbmQQ4oPLb4jex4na0DXzYY8IBxzOnLnzQ5fGgaxEx2Rf7
        P+bJJkLMuB32PC5a7QpmDKpXx6+hSUsavojo
X-Google-Smtp-Source: ABdhPJxmuPA2M4lnE9NsRAz2mPX4QG5I05M4IYHHAfAH5+Xqn3PLwXdtfryUfO6kViHxXLdydjC8tA==
X-Received: by 2002:a1c:28c1:: with SMTP id o184mr22014621wmo.91.1599490237107;
        Mon, 07 Sep 2020 07:50:37 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.119.8])
        by smtp.gmail.com with ESMTPSA id o9sm28010621wrw.58.2020.09.07.07.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 07:50:36 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/3] tools: bpftool: print optional built-in
 features along with version
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
References: <20200904205657.27922-1-quentin@isovalent.com>
 <20200904205657.27922-2-quentin@isovalent.com>
 <CAEf4Bzbf_igYVP+NfrVV86AZGQT7+2NF1JR6GzcEOymV9_vgNA@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <05b0ff4c-cf69-a452-6c0e-187ec2961063@isovalent.com>
Date:   Mon, 7 Sep 2020 15:50:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzbf_igYVP+NfrVV86AZGQT7+2NF1JR6GzcEOymV9_vgNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/09/2020 22:45, Andrii Nakryiko wrote:
> On Fri, Sep 4, 2020 at 1:57 PM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> Bpftool has a number of features that can be included or left aside
>> during compilation. This includes:
>>
>> - Support for libbfd, providing the disassembler for JIT-compiled
>>   programs.
>> - Support for BPF skeletons, used for profiling programs or iterating on
>>   the PIDs of processes associated with BPF objects.
>>
>> In order to make it easy for users to understand what features were
>> compiled for a given bpftool binary, print the status of the two
>> features above when showing the version number for bpftool ("bpftool -V"
>> or "bpftool version"). Document this in the main manual page. Example
>> invocation:
>>
>>     $ bpftool -p version
>>     {
>>         "version": "5.9.0-rc1",
>>         "features": [
>>             "libbfd": true,
>>             "skeletons": true
>>         ]
> 
> Is this a valid JSON? array of key/value pairs?

No it's not, silly me :'(. I'll fix that, thanks for spotting it.

>>     }
>>
>> Some other parameters are optional at compilation
>> ("DISASM_FOUR_ARGS_SIGNATURE", LIBCAP support) but they do not impact
>> significantly bpftool's behaviour from a user's point of view, so their
>> status is not reported.
>>
>> Available commands and supported program types depend on the version
>> number, and are therefore not reported either. Note that they are
>> already available, albeit without JSON, via bpftool's help messages.
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>  tools/bpf/bpftool/Documentation/bpftool.rst |  8 +++++++-
>>  tools/bpf/bpftool/main.c                    | 22 +++++++++++++++++++++
>>  2 files changed, 29 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
>> index 420d4d5df8b6..a3629a3f1175 100644
>> --- a/tools/bpf/bpftool/Documentation/bpftool.rst
>> +++ b/tools/bpf/bpftool/Documentation/bpftool.rst
>> @@ -50,7 +50,13 @@ OPTIONS
>>                   Print short help message (similar to **bpftool help**).
>>
>>         -V, --version
>> -                 Print version number (similar to **bpftool version**).
>> +                 Print version number (similar to **bpftool version**), and
>> +                 optional features that were included when bpftool was
>> +                 compiled. Optional features include linking against libbfd to
>> +                 provide the disassembler for JIT-ted programs (**bpftool prog
>> +                 dump jited**) and usage of BPF skeletons (some features like
>> +                 **bpftool prog profile** or showing pids associated to BPF
>> +                 objects may rely on it).
> 
> nit: I'd emit it as a list, easier to see list of features visually
> 
>>
>>         -j, --json
>>                   Generate JSON output. For commands that cannot produce JSON, this
>> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
>> index 4a191fcbeb82..2ae8c0d82030 100644
>> --- a/tools/bpf/bpftool/main.c
>> +++ b/tools/bpf/bpftool/main.c
>> @@ -70,13 +70,35 @@ static int do_help(int argc, char **argv)
>>
>>  static int do_version(int argc, char **argv)
>>  {
>> +#ifdef HAVE_LIBBFD_SUPPORT
>> +       const bool has_libbfd = true;
>> +#else
>> +       const bool has_libbfd = false;
>> +#endif
>> +#ifdef BPFTOOL_WITHOUT_SKELETONS
>> +       const bool has_skeletons = false;
>> +#else
>> +       const bool has_skeletons = true;
>> +#endif
>> +
>>         if (json_output) {
>>                 jsonw_start_object(json_wtr);
>> +
>>                 jsonw_name(json_wtr, "version");
>>                 jsonw_printf(json_wtr, "\"%s\"", BPFTOOL_VERSION);
>> +
>> +               jsonw_name(json_wtr, "features");
>> +               jsonw_start_array(json_wtr);
>> +               jsonw_bool_field(json_wtr, "libbfd", has_libbfd);
>> +               jsonw_bool_field(json_wtr, "skeletons", has_skeletons);
>> +               jsonw_end_array(json_wtr);
>> +
>>                 jsonw_end_object(json_wtr);
>>         } else {
>>                 printf("%s v%s\n", bin_name, BPFTOOL_VERSION);
>> +               printf("features: libbfd=%s, skeletons=%s\n",
>> +                      has_libbfd ? "true" : "false",
>> +                      has_skeletons ? "true" : "false");
> 
> now imagine parsing this with CLI text tools, you'll have to find
> "skeletons=(false|true)" and then parse "true" to know skeletons are
> supported. Why not just print out features that are supported?

You could just grep for "skeletons=true" (not too hard) (And generally
speaking I'd recommend against parsing bpftool's plain output, JSON is
more stable - Once you're parsing the JSON, checking the feature is
present or checking whether it's at "true" does not make a great
difference).

Anyway, the reason I have those booleans is that if you just list the
features and run "bpftool version | grep libbpfd" and get no result, you
cannot tell if the binary has been compiled without the disassembler or
if you are running an older version of bpftool that does not list
built-in features. You could then parse the version number and double
check, but you need to find in what version the change has been added.
Besides libbfd and skeletons, this could happen again for future
optional features if we add them to bpftool but forget to immediately
add the related check for "bpftool version".

So I would be inclined to keep the booleans. Or do you still believe a
list is preferable?

Quentin
