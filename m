Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67EF460B2B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbfGERuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:50:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41565 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfGERuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 13:50:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so10696460wrm.8
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 10:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fYSiUZQ46tzuVJG06HbeoKh26AHcQ4NUNe/J9kwHZgI=;
        b=ftf3uKha77HVxtn5FHJNMp9K+1gcVMaClZlJkP5aklBIXh6OHdcuINGUkdZzU1snoj
         bUY78oQMJ1JPQXtntNsvSbi2xw4yIc/4hLZaH6RZwtL1lM/UBONbgwCVe5a4ga+7gk9Y
         dxU1GKo7ehREKZ/u07X+/qbVUqT3xYO/YLL7+/QKXZSlbCVVkBWtBVia4udpMrsqBl48
         hP+6Sy1FDqTm6ZTGhkW/WwF1JrDBWBUJ9D17TIOsTgDZ6MjP/6HKADfH2YzMWFX4l3mZ
         kug3MRvQVMsVDtlyg9on58Du7BaxqppoQk1Ywb9oMu5SWaS7yDDqinCHJ6uu8p9eDDlP
         twpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fYSiUZQ46tzuVJG06HbeoKh26AHcQ4NUNe/J9kwHZgI=;
        b=crnYQlm+oVXduKm7XWnPnYlhSXyTAYOl/DLiylpTKRtgM6mvrErDOviIjbtqY5u5Ce
         eW6soCadRqXTJTy7QTTWqMGaO5LkFBNzsf1aVoIG1H+mHkpCNQjinFVG7f+uaAg5c/oB
         H9UpO0he8Dl041JjGIu38ydP7prfkipYqEjxaRNxOHFcA6AuQYxqAmA0/0FoCYVrY5JI
         uWjk60sZ7h5bhBqF0Jtv8a5o7rhNFnZqqpVQS/WZrNqNO3bxhqokFFH0dHlQaSweeWQG
         LTtlxl6ZRjqS8uc2faK3b27U4EjLxrwVzOUPq3U1KB/WGFRtTi2v8WQCJyzbDNpbuu+b
         vdiA==
X-Gm-Message-State: APjAAAXdOpp2gleTTav/HfEKvr1DqtzUIMuXWdEVOEgvE5hETQRWfs6v
        qT4xEUnzuZimaFNwFef9NWcRPwVt+Rk=
X-Google-Smtp-Source: APXvYqxNwuT5Yj5jDbx5KyDxsQV9abHyxhLW9K8EqC451um3BgFwOG0TfNr6vYdGViZBkHbIcaNZAg==
X-Received: by 2002:a5d:4284:: with SMTP id k4mr4799977wrq.194.1562349020535;
        Fri, 05 Jul 2019 10:50:20 -0700 (PDT)
Received: from [172.20.1.254] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y16sm10120107wru.28.2019.07.05.10.50.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 10:50:19 -0700 (PDT)
To:     Y Song <ys114321@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
References: <20190704085646.12406-1-quentin.monnet@netronome.com>
 <CAH3MdRXuDmXobkXESZg0+VV=FrBLsiAYPC61xQsjx2smKQKUtQ@mail.gmail.com>
 <b4bbb342-1f77-8669-ec51-8d5542f7e7b4@netronome.com>
 <CAH3MdRWcU9=YCO6WuLY2e2-kixE7E8yLBS+fJH4ASh94oHcK-A@mail.gmail.com>
 <4e7a66b8-8c4b-58cc-61a8-9ec6568d4df7@netronome.com>
 <CAH3MdRX3LLjcwi72tW_5TEj9sHvVqVE88xqX5Ud6MOZf83jUmw@mail.gmail.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH bpf-next] tools: bpftool: add "prog run" subcommand to
 test-run programs
Message-ID: <cbd2b293-3eb7-960b-84a0-26d59b065253@netronome.com>
Date:   Fri, 5 Jul 2019 18:50:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAH3MdRX3LLjcwi72tW_5TEj9sHvVqVE88xqX5Ud6MOZf83jUmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-07-05 10:08 UTC-0700 ~ Y Song <ys114321@gmail.com>
> On Fri, Jul 5, 2019 at 9:03 AM Quentin Monnet
> <quentin.monnet@netronome.com> wrote:
>>
>> 2019-07-05 08:42 UTC-0700 ~ Y Song <ys114321@gmail.com>
>>> On Fri, Jul 5, 2019 at 1:21 AM Quentin Monnet
>>> <quentin.monnet@netronome.com> wrote:
>>>>
>>>> 2019-07-04 22:49 UTC-0700 ~ Y Song <ys114321@gmail.com>
>>>>> On Thu, Jul 4, 2019 at 1:58 AM Quentin Monnet
>>>>> <quentin.monnet@netronome.com> wrote:
>>>>>>
>>>>>> Add a new "bpftool prog run" subcommand to run a loaded program on input
>>>>>> data (and possibly with input context) passed by the user.
>>>>>>
>>>>>> Print output data (and output context if relevant) into a file or into
>>>>>> the console. Print return value and duration for the test run into the
>>>>>> console.
>>>>>>
>>>>>> A "repeat" argument can be passed to run the program several times in a
>>>>>> row.
>>>>>>
>>>>>> The command does not perform any kind of verification based on program
>>>>>> type (Is this program type allowed to use an input context?) or on data
>>>>>> consistency (Can I work with empty input data?), this is left to the
>>>>>> kernel.
>>>>>>
>>>>>> Example invocation:
>>>>>>
>>>>>>     # perl -e 'print "\x0" x 14' | ./bpftool prog run \
>>>>>>             pinned /sys/fs/bpf/sample_ret0 \
>>>>>>             data_in - data_out - repeat 5
>>>>>>     0000000 0000 0000 0000 0000 0000 0000 0000      | ........ ......
>>>>>>     Return value: 0, duration (average): 260ns
>>>>>>
>>>>>> When one of data_in or ctx_in is "-", bpftool reads from standard input,
>>>>>> in binary format. Other formats (JSON, hexdump) might be supported (via
>>>>>> an optional command line keyword like "data_fmt_in") in the future if
>>>>>> relevant, but this would require doing more parsing in bpftool.
>>>>>>
>>>>>> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
>>>>>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>>>>>> ---
>>>>
>>>> [...]
>>>>
>>>>>> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
>>>>>> index 9b0db5d14e31..8dcbaa0a8ab1 100644
>>>>>> --- a/tools/bpf/bpftool/prog.c
>>>>>> +++ b/tools/bpf/bpftool/prog.c
>>>>>> @@ -15,6 +15,7 @@
>>>>>>  #include <sys/stat.h>
>>>>>>
>>>>>>  #include <linux/err.h>
>>>>>> +#include <linux/sizes.h>
>>>>>>
>>>>>>  #include <bpf.h>
>>>>>>  #include <btf.h>
>>>>>> @@ -748,6 +749,344 @@ static int do_detach(int argc, char **argv)
>>>>>>         return 0;
>>>>>>  }
>>>>>>
>>>>>> +static int check_single_stdin(char *file_in, char *other_file_in)
>>>>>> +{
>>>>>> +       if (file_in && other_file_in &&
>>>>>> +           !strcmp(file_in, "-") && !strcmp(other_file_in, "-")) {
>>>>>> +               p_err("cannot use standard input for both data_in and ctx_in");
>>>>>
>>>>> The error message says data_in and ctx_in.
>>>>> Maybe the input parameter should be file_data_in and file_ctx_in?
>>>>
>>>>
>>>> Hi Yonghong,
>>>>
>>>> It's true those parameters should be file names. But having
>>>> "file_data_in", "file_data_out", "file_ctx_in" and "file_ctx_out" on a
>>>> command line seems a bit heavy to me? (And relying on keyword prefixing
>>>> for typing the command won't help much.)
>>>>
>>>> My opinion is that it should be clear from the man page or the "help"
>>>> command that the parameters are file names. What do you think? I can
>>>> prefix all four arguments with "file_" if you believe this is better.
>>>
>>> I think you misunderstood my question above.
>>
>> Totally did, sorry :/.
>>
>>> The command line parameters are fine.
>>> I am talking about the function parameter names. Since in the error message,
>>> the input parameters are referred for data_in and ctx_in
>>>    p_err("cannot use standard input for both data_in and ctx_in")
>>> maybe the function signature should be
>>>   static int check_single_stdin(char *file_data_in, char *file_ctx_in)
>>>
>>> If you are worried that later on the same function can be used in different
>>> contexts, then alternatively, you can have signature like
>>>   static int check_single_stdin(char *file_in, char *other_file_in,
>>> const char *file_in_arg, const char *other_file_in_arg)
>>> where file_in_arg will be passed in as "data_in" and other_file_in_arg
>>> as "ctx_in".
>>> I think we could delay this until it is really needed.
>>
>> As a matter of fact, the opposite thing happened. I first used the
>> function for data_in/ctx_in, and also for data_out/ctx_out. But I
>> changed my mind eventually because there is no real reason not to print
>> both data_out and ctx_out to stdout if we want to do so. So I updated
>> the name of the parameters in the error messages, but forgot to change
>> the arguments for the function. Silly me.
>>
>> So I totally agree, I'll respin and change the argument names for the
>> function. And yes, we could also pass the names to print in the error
>> message, but I agree that this is not needed, and not helpful at the moment.
>>
>> Thanks for catching this!
>>
>>>>
>>>> [...]
>>>>
>>>>>> +static int do_run(int argc, char **argv)
>>>>>> +{
>>>>>> +       char *data_fname_in = NULL, *data_fname_out = NULL;
>>>>>> +       char *ctx_fname_in = NULL, *ctx_fname_out = NULL;
>>>>>> +       struct bpf_prog_test_run_attr test_attr = {0};
>>>>>> +       const unsigned int default_size = SZ_32K;
>>>>>> +       void *data_in = NULL, *data_out = NULL;
>>>>>> +       void *ctx_in = NULL, *ctx_out = NULL;
>>>>>> +       unsigned int repeat = 1;
>>>>>> +       int fd, err;
>>>>>> +
>>>>>> +       if (!REQ_ARGS(4))
>>>>>> +               return -1;
>>>>>> +
>>>>>> +       fd = prog_parse_fd(&argc, &argv);
>>>>>> +       if (fd < 0)
>>>>>> +               return -1;
>>>>>> +
>>>>>> +       while (argc) {
>>>>>> +               if (detect_common_prefix(*argv, "data_in", "data_out",
>>>>>> +                                        "data_size_out", NULL))
>>>>>> +                       return -1;
>>>>>> +               if (detect_common_prefix(*argv, "ctx_in", "ctx_out",
>>>>>> +                                        "ctx_size_out", NULL))
>>>>>> +                       return -1;
>>>>>> +
>>>>>> +               if (is_prefix(*argv, "data_in")) {
>>>>>> +                       NEXT_ARG();
>>>>>> +                       if (!REQ_ARGS(1))
>>>>>> +                               return -1;
>>>>>> +
>>>>>> +                       data_fname_in = GET_ARG();
>>>>>> +                       if (check_single_stdin(data_fname_in, ctx_fname_in))
>>>>>> +                               return -1;
>>>>>> +               } else if (is_prefix(*argv, "data_out")) {
>>>>>
>>>>> Here, we all use is_prefix() to match "data_in", "data_out",
>>>>> "data_size_out" etc.
>>>>> That means users can use "data_i" instead of "data_in" as below
>>>>>    ... | ./bpftool prog run id 283 data_i - data_out - repeat 5
>>>>> is this expected?
>>>> Yes, this is expected. We use prefix matching as we do pretty much
>>>> everywhere else in bpftool. It's not as useful here because most of the
>>>> strings for the names are similar. I agree that typing "data_i" instead
>>>> of "data_in" brings little advantage, but I see no reason why we should
>>>> reject prefixing for those keywords. And we accept "data_s" instead of
>>>> "data_size_out", which is still shorter to type than the complete keyword.
>>>
>>> This makes sense. Thanks for explanation.
>>>
>>> Another question. Currently, you are proposing "./bpftool prog run ...",
>>> but actually it is just a test_run. Do you think we should rename it
>>> to "./bpftool prog test_run ..." to make it clear for its intention?
>>
>> Good question. Hmm. It would make it more explicit that we use the
>> BPF_PROG_TEST_RUN command, but at the same time, from the point of view
>> of the user, there is nothing in particular that makes it a test run, is
>> it? I mean, you provide input data, you get output data and return
>> value, that makes it a real BPF run somehow, except that it's not on a
>> packet or anything. Do you think it is ambiguous and people may confuse
>> it with something like "attach"?
> 
> I am more thinking about whether we could have a real "bpftool prog run ..."
> in the future which could really run the program in some kind of production
> environment...
> 
> But I could be wrong since after "bpf prog attach" it may already just start
> to run in production, so "bpf prog run ..." not really needed for it.
> 
> So "bpf prog run ..." is probably fine.

Ok, I'll stick to "prog run" unless someone else comments, then. I
suppose we can find something else, like "bpftool prog start", if we
need something like the feature you describe someday.

I'll send a v2 with the fix for the arguments in check_single_stdin().

Thanks,
Quentin
