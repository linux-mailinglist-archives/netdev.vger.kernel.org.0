Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FBB277C3C
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgIXXOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:14:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbgIXXOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 19:14:03 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600989242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kNz47kMuHB/f0bjf1dI2WxhSa4rym2TxHMpu7tr6TsE=;
        b=Z0DnrRdbyzuxnGR/uNH44lSWwlkvinticK5xWNhi/9735sGfX9FvV84UR3ZR5iBUOMa06k
        rhsYFZS2rw6f0RhTv/ymOCzns+qby0UY9IgZkUbWL2otfKby4ZYuqBQaWuntGmshuaXJcf
        aahhT/84F5WNaELdOs53Ta2aCYbDaq8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-A7mZTqGeNsu2CuJJWd5xog-1; Thu, 24 Sep 2020 19:14:00 -0400
X-MC-Unique: A7mZTqGeNsu2CuJJWd5xog-1
Received: by mail-pj1-f72.google.com with SMTP id q95so446554pja.0
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 16:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kNz47kMuHB/f0bjf1dI2WxhSa4rym2TxHMpu7tr6TsE=;
        b=NVHOFYSUYZA+Cxs1zrYFRweZPFwpOzTus4NYRIzwr8X/BdvOhfYAiuaoBl57fuuv1T
         HQWI5ba6jgU9xvWPt79MiOwRNnMszCZPoZyPKBeCtbtGcnPjSOAP3kniK9WPXwZtXuKA
         PTxrYPyxk8LIDcGcl0is244RFVlSbI0LHdsgCjNlt6JAZxN8kbU1OPRB0UWhGVNzKkp7
         REe/DyQtK9JOG510wJBHLy4tokJMO3Sxosp7lbed01QPB9KLjwwSEUErOnrBHP11RY4p
         TxkyIZl6WX7v0WzFZ5CJwtR8CcNwFEhgrgR2v7WDMQbKNBg3Tg+YQmVe7HiIhOcEXHqL
         3h7g==
X-Gm-Message-State: AOAM532C8t7uNYzyZDH3TMssz7DjCKVnlUJKr2lgJJTDkyMtvlSKNl65
        3nd9PYPFdbAO81hIX2OsxhGUllBjnHS4MDBvBxqSPcUidPeRzgKed+7cJaShMqLd3b30RD1d6fd
        K+Yw4de50R8+5KUhS
X-Received: by 2002:aa7:9518:0:b029:142:2501:35e3 with SMTP id b24-20020aa795180000b0290142250135e3mr1268761pfp.67.1600989239484;
        Thu, 24 Sep 2020 16:13:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwME2/K/IbUTfmnrx9/16A3flZygkg6nD1UFOjlNqLTKnT2jwbq9mPHga9jDWqvftMUzrfhSA==
X-Received: by 2002:aa7:9518:0:b029:142:2501:35e3 with SMTP id b24-20020aa795180000b0290142250135e3mr1268733pfp.67.1600989239212;
        Thu, 24 Sep 2020 16:13:59 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x20sm492190pfr.190.2020.09.24.16.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 16:13:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 842F4183A90; Fri, 25 Sep 2020 01:13:53 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v8 04/11] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
In-Reply-To: <CAEf4Bza38tR1GvyLzzzzv6zT8B-_gM_jhTqK_c7+e1ciU3ZA1w@mail.gmail.com>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991808.8301.6462172487971110332.stgit@toke.dk>
 <20200924001439.qitbu5tmzz55ck4z@ast-mbp.dhcp.thefacebook.com>
 <874knn1bw4.fsf@toke.dk>
 <CAEf4BzaBvvZdgekg13T3e4uj5Q9Rf1RTFP__ZPsU-NMp2fVXxw@mail.gmail.com>
 <87zh5ec1gs.fsf@toke.dk>
 <CAEf4BzZxfzQabDCdmby1XMQV7qQ_C=rATWOb=cN-Q1rfxR+nVA@mail.gmail.com>
 <87r1qqbywe.fsf@toke.dk>
 <CAEf4Bza38tR1GvyLzzzzv6zT8B-_gM_jhTqK_c7+e1ciU3ZA1w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 25 Sep 2020 01:13:53 +0200
Message-ID: <87mu1ebwem.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

>> [root@(none) bpf]# ./test_progs -t map_in_map
>> test_lookup_update:PASS:skel_open 0 nsec
>> test_lookup_update:PASS:skel_attach 0 nsec
>> test_lookup_update:PASS:inner1 0 nsec
>> test_lookup_update:PASS:inner2 0 nsec
>> test_lookup_update:PASS:inner1 0 nsec
>> test_lookup_update:PASS:inner2 0 nsec
>> test_lookup_update:PASS:map1_id 0 nsec
>> test_lookup_update:PASS:map2_id 0 nsec
>> kern_sync_rcu:PASS:inner_map_create 0 nsec
>> kern_sync_rcu:PASS:outer_map_create 0 nsec
>> kern_sync_rcu:PASS:outer_map_update 0 nsec
>> test_lookup_update:PASS:sync_rcu 0 nsec
>> kern_sync_rcu:PASS:inner_map_create 0 nsec
>> kern_sync_rcu:PASS:outer_map_create 0 nsec
>> kern_sync_rcu:PASS:outer_map_update 0 nsec
>> test_lookup_update:PASS:sync_rcu 0 nsec
>
> try adding sleep(few seconds, enough for RCU grace period to pass)
> here and see if that helps
>
> if not, please printk() around to see why the inner_map1 wasn't freed

Aha, found it! It happened because my kernel was built with
PREEMPT_VOLUNTARY. Changing that to PREEMPT fixed the test, and got me
to:

Summary: 116/853 PASSED, 14 SKIPPED, 0 FAILED

So yay! Thanks for your help with debugging :)

-Toke

