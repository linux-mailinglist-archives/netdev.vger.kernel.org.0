Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AEF1F9FB7
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 20:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgFOSzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 14:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgFOSzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 14:55:36 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC48C061A0E;
        Mon, 15 Jun 2020 11:55:36 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id fc4so8276062qvb.1;
        Mon, 15 Jun 2020 11:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DTBEE8O+flfnTDcID6fw3qIeYva77rci1DenkZlJUeE=;
        b=IOgvDhNZZ/Ra63kjHD80BCrrPdgVrPnQ2POdr5g3f9gXeDNXx0co9Bt3iHtQANhGNM
         jIDRxQrjAuy28PtpHq4Yy9R0DY0G5i98RuMJmes0LcZfnae+SJ22TVPlt68D6Tapq7LH
         QLKZfpyk1A/ovY4N5bBFmhGa74Dym20SOdnK8RpJtBqunCek1pN1LOlrAwKgJySWJIoA
         vOh5J36E8oMyMkek3/ukB6iCtAEnrfjUSgY2YxhY3dWB0XY8/vBChzBo1dQHLtfS7Vap
         IiN3FEWpE+00lFUNDjeyRoXMSP/3WeBMhDo8r4kJIBhs4Ew1ljUYZeCJFTe4MC/EGcBl
         jbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DTBEE8O+flfnTDcID6fw3qIeYva77rci1DenkZlJUeE=;
        b=TpnN+8c9Z1yz/syD8fAAgn/7vUj3q5XwlFdFvZ4bnjLHFnB5KDe70Hnjk/pL5SuZqs
         as2oQApnc/PVojd4rN27zzCrSPFBKb6S5mf2bnHRLpk2vueeyRay866HAoCHTNo9oLwi
         aW6SYQ1wIivqlj3vO4F0rw44jE2NejQZLQPiyTNhxJFz5/HLbIHNjnDdi7rdyjrDNX+O
         uodUiqKXY69cb+xXA5FnKcdk1W74FIJU6szAnXoW+juH/sagcWjNC5GKbhV8w2XOi+pP
         leg8dru024ScW7JlWiVmuQq8CvV5qlMsMYfTALfV5XyHtmjXVXv11rlXJ8DN8pdhlujk
         Y3kQ==
X-Gm-Message-State: AOAM531LdH00NNAoJM14N2WirnbQDeoO2M2YcCxlFkWhbOksmue8gbIL
        DySCBOx885VZuhISFflTugZ192jfhs4OlNGYmM4=
X-Google-Smtp-Source: ABdhPJzh9EwvKt4ruH7h5aplNvcYreWfmUZoQoLPG2HTPkgQ+e541yQdxQmiQttQCjQuuvZ8rs5Ayn+GCIkD8HmRYrs=
X-Received: by 2002:ad4:4baa:: with SMTP id i10mr27198653qvw.163.1592247335714;
 Mon, 15 Jun 2020 11:55:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200612223150.1177182-1-andriin@fb.com> <20200612223150.1177182-2-andriin@fb.com>
 <CA+khW7hAYVdoQX5-j0z1iGEVZeww4BBu4NXzy5eS5OwDRYqe2w@mail.gmail.com>
In-Reply-To: <CA+khW7hAYVdoQX5-j0z1iGEVZeww4BBu4NXzy5eS5OwDRYqe2w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Jun 2020 11:55:24 -0700
Message-ID: <CAEf4Bzbmw8VE9JcpgPNztS0W=MQBXC7Y9ewzUGF9-BgU+uO_zQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/8] libbpf: generalize libbpf externs support
To:     Hao Luo <haoluo@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 9:44 AM Hao Luo <haoluo@google.com> wrote:
>
> Andrii,
>
> Thanks for this patch, it looks very nice! Decoupling kconfig from generic externs is much needed.
>
> On Fri, Jun 12, 2020 at 3:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
>>
>> Switch existing Kconfig externs to be just one of few possible kinds of more
>> generic externs. This refactoring is in preparation for ksymbol extern
>> support, added in the follow up patch. There are no functional changes
>> intended.
>>
>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> ---
>>  tools/lib/bpf/libbpf.c | 332 ++++++++++++++++++++++++-----------------
>>  1 file changed, 199 insertions(+), 133 deletions(-)
>>

[...]

>> @@ -1443,12 +1454,12 @@ static int set_ext_value_tri(struct extern_desc *ext, void *ext_val,
>>                 else /* value == 'n' */
>>                         *(enum libbpf_tristate *)ext_val = TRI_NO;
>>                 break;
>> -       case EXT_CHAR:
>> +       case KCFG_CHAR:
>>                 *(char *)ext_val = value;
>>                 break;
>> -       case EXT_UNKNOWN:
>> -       case EXT_INT:
>> -       case EXT_CHAR_ARR:
>> +       case KCFG_UNKNOWN:
>> +       case KCFG_INT:
>> +       case KCFG_CHAR_ARR:
>>         default:
>>                 pr_warn("extern %s=%c should be bool, tristate, or char\n",
>>                         ext->name, value);
>
>
> Very minor: pr_warn("kconfig extern ..."); I noticed you have one similar message changed below.
>

yeah, good catch, I'll update

>>
>> @@ -1458,12 +1469,12 @@ static int set_ext_value_tri(struct extern_desc *ext, void *ext_val,
>>         return 0;
>>  }
>>

for the future, please cut irrelevant parts of the patch, makes it
easier to see where your replies are

[...]
