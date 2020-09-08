Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9BE26113B
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 14:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbgIHMAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 08:00:43 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44855 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729990AbgIHL5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:57:07 -0400
Received: by mail-lj1-f194.google.com with SMTP id b19so19610267lji.11;
        Tue, 08 Sep 2020 04:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jh4hHYFwlWS3q3v7W7IbFtTJL9RsdkyeEh+zHqxq1Uw=;
        b=T8pzrMZlpp9SE834d/QKZQqb8dMOjebIVAumtKzNOx5PxSc0V1DyjnQ5tLPEWfEBcH
         GvcsskHYtHIzA0ln0yXJO+6ZlT/VgUeoIsHvQQJF1N1X2TqhCku5m4VHwsTOtxcpjgeB
         MyuH7q1rglNhtL30hlAjWhM7L2FWrcKVz7mjRDiXLG6h7wUeEYHtTE0fPSjKmPzpVz2E
         zr4SFmXmnNJ9AOop7uEz1Oz0WZ/QBnHwU9aa4JjG+v8MMlCKIwvXzEB2DudBXHZrRcce
         r8Nmk3vGqVCizSnDJq0KziK56yV4iJw+sAfNxXNQaNTlCwl11q+HeZGRCZnT40xFpghW
         YJGQ==
X-Gm-Message-State: AOAM532eM6Zmj06ZfhXnF/7tlZlz+8LeqgBY2PQs75WhMKXbBWWIcFOv
        +pOwzwR7NheRA0GRu3gbPSc78MwcjLrHi+1w
X-Google-Smtp-Source: ABdhPJwI3OvIT5CfblyxYhJ3tEQjzEDqyOD9zIlFrqzHreOBujh2qCgXf15+KSJVaRVh7r82xtR2aA==
X-Received: by 2002:a05:6000:ce:: with SMTP id q14mr26028965wrx.112.1599565602686;
        Tue, 08 Sep 2020 04:46:42 -0700 (PDT)
Received: from [10.239.43.214] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id e18sm33251192wrx.50.2020.09.08.04.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 04:46:42 -0700 (PDT)
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
From:   Arturo Borrero Gonzalez <arturo@debian.org>
Autocrypt: addr=arturo@debian.org; keydata=
 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
 EXgmBmyUKrJkh/zvupp9t9Y2ioPbcMObRIEXio4=
Message-ID: <0b7ca97e-9548-b0a8-cdd1-5200cb3b997d@debian.org>
Date:   Tue, 8 Sep 2020 13:46:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-04 23:14, Daniel Borkmann wrote:
> root@x:~/x# clang -target bpf -Wall -O2 -c foo.c -o foo.o

In my honest opinion (debian hat), the simplification of the stack is a key
point for end users/developers. A gain in usability might justify a small
performance penalty.

I can think on both sysadmins and network apps developers, or even casual
advanced users. For many people, dealing with the network stack is already
challenging enough.

Also, ideally, servers would be clean of the GCC or CLANG suites.
