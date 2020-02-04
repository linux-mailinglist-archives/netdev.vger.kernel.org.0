Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179BE151407
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 02:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgBDBqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 20:46:30 -0500
Received: from mail-qk1-f180.google.com ([209.85.222.180]:40285 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgBDBqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 20:46:30 -0500
Received: by mail-qk1-f180.google.com with SMTP id b7so1169811qkl.7;
        Mon, 03 Feb 2020 17:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VTqZftv6pi0oImAkeD0X+bfB0JINBLe0J4+VrZ2FAF8=;
        b=W7io1ZM6lzEtEgAlBeoSJs1xyAnjNyLQqjoIVkC664waVqL0pbNOgO+QsCeQ74cHjb
         NMFyAAiDDrB42UvJPiPk+aQKK4N+yquofXdDp4JIT6vCoBKnN5jUQRhYMhkSp47iancW
         68eAVV5Qtv6OHJFyH67i+CT4RETG1cgbZlQZNPRbAfLVakKIF+DUPhHxgo/ix45q4ZWM
         d/fKKPBXpFW3QeCzClpoqbf75ncVN1VXw180VM3CL7qyvjiVGMPSy9sbza1FzjnURqdb
         VQBOq4eDutBG+9ktvc6pijy/zF3/MB+CD5MujZdPWZMwBVzfskNjz6TR1QEnTTq1Y4e9
         AKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VTqZftv6pi0oImAkeD0X+bfB0JINBLe0J4+VrZ2FAF8=;
        b=IIBeETW6d5a3eL+QB7/mhx1mvuIaG/Neq3Y5tpOfRRwKiVHjj9hg2u4XBAtV9G/02m
         F4cnbJZr6MZMManuE7cXIP4g+s8ANvsQYzciDmwP79XnUfqHSn0s3eGWlo5fFPT8sMYE
         Y3J40V0erFlFYZ3ZDeF7X9BJp2Ce4T7D2CZdDTZkMW7ylgnIpsgcKBa9sHp4qwn8sdcO
         vjY2Dqqz65OoHwqmq8xCl6kOScAvqiwdbvYVBjoX1AASuJyT1gGVUm8+JgJyUwCguwUC
         TbM6lODH5vlFL56NOEPFEf6+U8jHJ3wpLfU8FWFs9Ke/YEpWXK09d46n23cbb1rq1x2U
         fxEw==
X-Gm-Message-State: APjAAAWkEvIIs+xcDgOZLKdZppgcpMdfzYPO25GAqLVd/0MESaGdGn4J
        DUPk1eEqJzKnIWPvYpnRKMfYNSC3dDo=
X-Google-Smtp-Source: APXvYqyu+UwD1M8OJ1qslU45Gmufh2wSROcFAghEH6OTJXNUD//ukfXwB9O7P7KZA277I+RPM5tScw==
X-Received: by 2002:a37:8e45:: with SMTP id q66mr26720374qkd.129.1580780789178;
        Mon, 03 Feb 2020 17:46:29 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:3d10:e33:29a2:f093? ([2601:282:803:7700:3d10:e33:29a2:f093])
        by smtp.googlemail.com with ESMTPSA id m68sm10153702qke.17.2020.02.03.17.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 17:46:28 -0800 (PST)
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20190820114706.18546-1-toke@redhat.com>
 <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk>
 <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net>
 <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk>
 <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
 <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com>
 <87blqfcvnf.fsf@toke.dk>
 <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com>
Date:   Mon, 3 Feb 2020 18:46:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/20 5:56 PM, Andrii Nakryiko wrote:
> Great! Just to disambiguate and make sure we are in agreement, my hope
> here is that iproute2 can completely delegate to libbpf all the ELF
>

iproute2 needs to compile and continue working as is when libbpf is not
available. e.g., add check in configure to define HAVE_LIBBPF and move
the existing code and move under else branch.
