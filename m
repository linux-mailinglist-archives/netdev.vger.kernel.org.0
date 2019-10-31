Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A5EEB62B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfJaRbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:31:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbfJaRbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 13:31:05 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D6EE083F4C
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 17:31:04 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id y17so1093873ljm.16
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 10:31:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=A98ZbpLN02ShHsjGWgvbK5h5LF9r2lohJMdJTRe83QQ=;
        b=TNvk+2PxvjzpyFRgps3Nr/4fS6ZTrr2uRgu6yZf/iWamJR8DoMY8B8TnIaecQQryhy
         49V6yUYtEEmZahh1fZPpVV9OoxqwEyIu/jQ0rwoVxPBQqVMuQxtUGrL4cZP3OXbuosp+
         0z5llndEn/XqLMQG4SKSzNhhtuZuYsn0WzOYSvv/QOOUPn2S3CAfihIutc0jHFRFLqSL
         u5lh0ZbMG38h+AWY9Pusi+fo3JEhJTEoPqVXfNQwmdiIr+rtwaMJ2FfKl4QCwWAvtKNu
         MeHFuQKRy/flRDJdutLtgluZXTabbLP/ePqqYmctInC4cKDBSYY0zjrtyD0sLVmkwVmv
         IJXw==
X-Gm-Message-State: APjAAAXXgteDW9ZdiuOw6pKUbfTNHY0V/9JD3OSNMKuJJLWFr+lPZotK
        tsTi753aeLP8M2vCarIzWEVbjtvC65oRVxePtSTxUAGDmrlAXzmZ2QUx860vZwRJ99oz+wCOjOA
        q/nNycwrk8WpLgUzw
X-Received: by 2002:a19:ec02:: with SMTP id b2mr1416137lfa.121.1572543063423;
        Thu, 31 Oct 2019 10:31:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzuZ0u8TDe2F08iwASeJ9Xwym2M/KWxW+rywOa70uTTQU7n4oioBxCGIFSuTPr5r+A9CZdy8g==
X-Received: by 2002:a19:ec02:: with SMTP id b2mr1416122lfa.121.1572543063280;
        Thu, 31 Oct 2019 10:31:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id y6sm1386921ljm.95.2019.10.31.10.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 10:31:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 002561818B5; Thu, 31 Oct 2019 18:31:01 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 2/5] libbpf: Store map pin path and status in struct bpf_map
In-Reply-To: <CAEf4BzZ4pRLhwX+5Hh1jKsEhBAkrZbC14rBgAVgUt1gf3qJ+KQ@mail.gmail.com>
References: <157237796219.169521.2129132883251452764.stgit@toke.dk> <157237796448.169521.1399805620810530569.stgit@toke.dk> <CAEf4BzZ4pRLhwX+5Hh1jKsEhBAkrZbC14rBgAVgUt1gf3qJ+KQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 31 Oct 2019 18:31:01 +0100
Message-ID: <8736f8om96.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> [...]
>
>>
>>         return err;
>> @@ -4131,17 +4205,24 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
>>                 return -ENOENT;
>>
>>         bpf_object__for_each_map(map, obj) {
>> +               char *pin_path = NULL;
>>                 char buf[PATH_MAX];
>
> you can call buf as pin_path and get rid of extra pointer?

The idea here is to end up with bpf_map__unpin(map, NULL) if path is
unset. GCC complains if I reassign a static array pointer, so don't
think I can actually get rid of this?

-Toke
