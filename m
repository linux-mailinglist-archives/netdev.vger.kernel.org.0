Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830F1DF035
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfJUOpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:45:39 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41605 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbfJUOpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:45:38 -0400
Received: by mail-pf1-f196.google.com with SMTP id q7so8565137pfh.8
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 07:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yTPxXfaDi/cyr4JY0Jgze0DAKcyw3G+EJ8T7To77x0c=;
        b=E/SlSvAkGWL8pGfVnOrx5+GTnF6CvSrWmR+zkwKOSkkzfwcdpu65kTGYr8fiTIgmTb
         /MDHOSXlb+rVJq0m8ODzgBgQNzhPe5snw/63q3NW2jxh3bIjMmPPoHfMdNcqEjFu2lb+
         HumNyf3lPhRJ+nZ3otIGsjmfY8uPQQfSP8ks+6W2RDchYKLh/XZ3zALOUlwItL3A9JYN
         cug3R8Dor9BHokXb+24HyBdDBrqK8YqTgzzb7oFXQ3Ntr6SpH4TpJFaeAI/MPl+QVvnd
         /Wx9r1UMh6hDjKQF0/f2FEXTJFwUTWxWNK2wuUajZn2v7djIAqlDwleTaP9XiJlRpqRO
         PvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yTPxXfaDi/cyr4JY0Jgze0DAKcyw3G+EJ8T7To77x0c=;
        b=LVe1ZlbWQn4hK1bYRG3rn4nbkEr6X8G4CFZAUDTxfe/GzB/C9us9d82wfFfwaArUSe
         g1JzpRdbomJINxG02vYyo1rSsRI+PlRb1DN9wiqUKse1ZjfSon+o+B02UdhQXfLis8NQ
         Ro/YldqsVfsqBGdqBq5rtIGd7rDCTd9homxJh9f1IVuZ7+jrzh035sKdY8lPoapqGJH7
         Fpovb+m9/oxjd0yBszZoCoOJtYKO7+Hau2v5eO4YeHcZirA/kbNOauk9g1pr0jtxHYQC
         fiEj0YzLL6h8cTL/kFbu88uDz9WE8yHMG1gClXX2uuo+gdQns09rUZerJ/SX5rbEfX1e
         YyNw==
X-Gm-Message-State: APjAAAV1IDnS+h8nC8D6eK67FBByIfLazjsEeoTBfP9iQaKleRuXQSSA
        qog6ktRfLAvC6w8+nWoK9b/nCw==
X-Google-Smtp-Source: APXvYqzrYlQXe7Wl+Pdo7pLekzBcv2vcqfOuYQs+fs6gn9SlfFOZLCyLa+RYqx/pnpy4I4e9QMaEgw==
X-Received: by 2002:a17:90a:a605:: with SMTP id c5mr30180069pjq.28.1571669136286;
        Mon, 21 Oct 2019 07:45:36 -0700 (PDT)
Received: from [192.168.1.182] ([192.40.64.15])
        by smtp.gmail.com with ESMTPSA id y80sm16549698pfc.30.2019.10.21.07.45.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 07:45:35 -0700 (PDT)
Subject: Re: [RFC PATCH 1/2] block: add support for redirecting IO completion
 through eBPF
To:     Bart Van Assche <bvanassche@acm.org>, Hou Tao <houtao1@huawei.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     linux-block@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, hare@suse.com,
        osandov@fb.com, ming.lei@redhat.com, damien.lemoal@wdc.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <20191014122833.64908-1-houtao1@huawei.com>
 <20191014122833.64908-2-houtao1@huawei.com>
 <CAADnVQ+UJK41VL-epYGxrRzqL_UsC+X=J8EXEn2i8P+TPGA_jg@mail.gmail.com>
 <84032c64-8e5e-6ad1-63ea-57adee7a2875@huawei.com>
 <737d9d3f-e72c-ac31-6b2a-997202a302bd@acm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b09f97a5-4097-6ac4-00fd-27a77c5d15dd@kernel.dk>
Date:   Mon, 21 Oct 2019 08:45:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <737d9d3f-e72c-ac31-6b2a-997202a302bd@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/19 7:48 AM, Bart Van Assche wrote:
> On 10/21/19 6:42 AM, Hou Tao wrote:
>> Your suggestion is much simpler, so there will be no need for adding a new
>> program type, and all things need to be done are adding a raw tracepoint,
>> moving bpf_ccpu into struct request, and letting a BPF program to modify it.
> 
> blk-mq already supports processing completions on the CPU that submitted
> a request so it's not clear to me why any changes in the block layer are
> being proposed for redirecting I/O completions?

That's where I'm getting confused as well. I'm not against adding BPF
functionality to the block layer, but this one seems a bit contrived.

-- 
Jens Axboe

