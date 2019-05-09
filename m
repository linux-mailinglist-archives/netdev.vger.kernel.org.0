Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9309718DC4
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfEIQNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:13:01 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33080 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbfEIQNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:13:00 -0400
Received: by mail-pl1-f195.google.com with SMTP id y3so1387504plp.0
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 09:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zvb1vzfjPyWKpcO6JJQuvbkJPTWrXzIHHsQRRvvsQsA=;
        b=PHMd8rwnCIhmR086CKxaOrNwg6vg/Ysxu2sGKpS0t/ca+k+jpvMlag1jq0ZsgHG1r5
         pj2T9TZEZfyUYTeTn+j/pbU6EUKBg4Mpbq2j3ogs1PHdWJpgCNoCABtM3dsqpGlr67Rj
         nr6oj2kzHjH0U0Zgijiv9jsMJZ2Fw+4A+lKH6/6PUK9oJIduDJtNOabCjFLlPpZw2BcV
         Qlo03hw39I5VcboHCPWarPAGVmymzxB4pzst+Sg3cNDG5XR5my1++pzyoROnO8+zayzJ
         0pctdYvHb6BP0xzNHJx5nTc+2/dYiXjJblcUmzZzKKJaPMK/Wu8yFo0jfAfXvFjoOwR1
         pp/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zvb1vzfjPyWKpcO6JJQuvbkJPTWrXzIHHsQRRvvsQsA=;
        b=poAo9IRUj0a7cxLMmHXBjeLcwzZHE1F+56fCoXQOhGhS6naI+C/ltYVItkegip5pWR
         5UpBCVTC+DIAypDlorNVEKISlfb93oqUBb6fhHIIQQHp2VQzeJkPDmmKAkSTBg6+pOdB
         xCF7FPb7qdcQ4dfGL8BSESh7NLX+Z5dwUWRH45YoZPVE2N9SJdBT6R2huZ+skVocdoyM
         XHq0Zo805wUI5zMuwnaqQPOlJd/eMHmhh9sOi1SJTCzIrJLkLzPDBVdnz7pgMzYzHgjz
         qztHFQ1LXpzOl1aFdjvE+BdI8j9XNehVlofZ8id8hpW8L6tCnvcpy6wlcdKR+w37H6Dt
         vI7A==
X-Gm-Message-State: APjAAAVZKCxiirzrxGyZ1AefRsALNuHGfUxQiPNHUVKFh7dlqacF/VW0
        c/kJmnC1E7uRn9SJBCMhPXI=
X-Google-Smtp-Source: APXvYqzAj7XNdfDHOW7lN/XDWT+BW4JS6d5t5ZMPE6HKivRfeX9SGldCfGsHSA6d3CPdB9sURQ5YXg==
X-Received: by 2002:a17:902:4a:: with SMTP id 68mr6304970pla.235.1557418380291;
        Thu, 09 May 2019 09:13:00 -0700 (PDT)
Received: from [172.20.54.81] ([2620:10d:c090:200::1:931a])
        by smtp.gmail.com with ESMTPSA id e6sm7712542pfl.115.2019.05.09.09.12.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 09:12:59 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Alexei Starovoitov" <ast@kernel.org>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
Date:   Thu, 09 May 2019 09:12:58 -0700
X-Mailer: MailMate (1.12.4r5594)
Message-ID: <7974B49C-CC4F-475D-992A-3E5B6480B039@gmail.com>
In-Reply-To: <CAJ+HfNj4NgGQkJOEivuxuohA_+Fa98yD8EmY4acHQqymdUBA4g@mail.gmail.com>
References: <20190508225016.2375828-1-jonathan.lemon@gmail.com>
 <CAJ+HfNj4NgGQkJOEivuxuohA_+Fa98yD8EmY4acHQqymdUBA4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9 May 2019, at 4:48, Björn Töpel wrote:

> On Thu, 9 May 2019 at 01:07, Jonathan Lemon <jonathan.lemon@gmail.com> 
> wrote:
>>
>> Currently, the AF_XDP code uses a separate map in order to
>> determine if an xsk is bound to a queue.  Instead of doing this,
>> have bpf_map_lookup_elem() return a boolean indicating whether
>> there is a valid entry at the map index.
>>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> ---
>>  kernel/bpf/verifier.c                             |  6 +++++-
>>  kernel/bpf/xskmap.c                               |  2 +-
>>  .../selftests/bpf/verifier/prevent_map_lookup.c   | 15 
>> ---------------
>>  3 files changed, 6 insertions(+), 17 deletions(-)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 7b05e8938d5c..a8b8ff9ecd90 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -2761,10 +2761,14 @@ static int 
>> check_map_func_compatibility(struct bpf_verifier_env *env,
>>          * appear.
>>          */
>>         case BPF_MAP_TYPE_CPUMAP:
>> -       case BPF_MAP_TYPE_XSKMAP:
>>                 if (func_id != BPF_FUNC_redirect_map)
>>                         goto error;
>>                 break;
>> +       case BPF_MAP_TYPE_XSKMAP:
>> +               if (func_id != BPF_FUNC_redirect_map &&
>> +                   func_id != BPF_FUNC_map_lookup_elem)
>> +                       goto error;
>> +               break;
>>         case BPF_MAP_TYPE_ARRAY_OF_MAPS:
>>         case BPF_MAP_TYPE_HASH_OF_MAPS:
>>                 if (func_id != BPF_FUNC_map_lookup_elem)
>> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
>> index 686d244e798d..f6e49237979c 100644
>> --- a/kernel/bpf/xskmap.c
>> +++ b/kernel/bpf/xskmap.c
>> @@ -154,7 +154,7 @@ void __xsk_map_flush(struct bpf_map *map)
>>
>>  static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
>>  {
>> -       return ERR_PTR(-EOPNOTSUPP);
>> +       return !!__xsk_map_lookup_elem(map, *(u32 *)key);
>>  }
>>
>
> Hmm, enabling lookups has some concerns, so we took the easy path;
> simply disallowing it. Lookups (and returning a socket/fd) from
> userspace might be expensive; allocating a new fd, and such, and on
> the BPF side there's no XDP socket object (yet!).
>
> Your patch makes the lookup return something else than a fd or socket.
> The broader question is, inserting a socket fd and getting back a bool
> -- is that ok from a semantic perspective? It's a kind of weird map.
> Are there any other maps that behave in this way? It certainly makes
> the XDP code easier, and you get somewhat better introspection into
> the XSKMAP.

I simply want to query the map and ask "is there an entry present?",
but there isn't a separate API for that.  It seems really odd that I'm
required to duplicate the same logic by using a second map.  I agree 
that
there isn't any point in returning an fd or xdp socket object - hence
the boolean.

The comment inthe verifier does read:

         /* Restrict bpf side of cpumap and xskmap, open when use-cases
          * appear.

so I'd say this is a use-case.  :)

The cpumap cpu_map_lookup_elem() function returns the qsize for some
reason, but it doesn't seem reachable from the verifier.

>
> (bpf-next is closed, btw... :-))

Ah yes, thanks.
-- 
Jonathan



>
>
>
> Björn
>
>>  static int xsk_map_update_elem(struct bpf_map *map, void *key, void 
>> *value,
>> diff --git 
>> a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c 
>> b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
>> index bbdba990fefb..da7a4b37cb98 100644
>> --- a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
>> +++ b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
>> @@ -28,21 +28,6 @@
>>         .errstr = "cannot pass map_type 18 into func 
>> bpf_map_lookup_elem",
>>         .prog_type = BPF_PROG_TYPE_SOCK_OPS,
>>  },
>> -{
>> -       "prevent map lookup in xskmap",
>> -       .insns = {
>> -       BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
>> -       BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
>> -       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
>> -       BPF_LD_MAP_FD(BPF_REG_1, 0),
>> -       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, 
>> BPF_FUNC_map_lookup_elem),
>> -       BPF_EXIT_INSN(),
>> -       },
>> -       .fixup_map_xskmap = { 3 },
>> -       .result = REJECT,
>> -       .errstr = "cannot pass map_type 17 into func 
>> bpf_map_lookup_elem",
>> -       .prog_type = BPF_PROG_TYPE_XDP,
>> -},
>>  {
>>         "prevent map lookup in stack trace",
>>         .insns = {
>> --
>> 2.17.1
>>
