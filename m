Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F443332FBD
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 21:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCIURv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 15:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbhCIUR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 15:17:26 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD47C06174A;
        Tue,  9 Mar 2021 12:17:26 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id t83so6394982oih.12;
        Tue, 09 Mar 2021 12:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nDkAQCanWh6x4Rfg/VlqS3Z7N14cNMWqlLERB0C8xnc=;
        b=pGCuEA8nE0iytzx5MKNhtJGtsSmywE/Ztdblr8LrqrN8i6QjWKy7fr0RXwYColbaPi
         HpC2aRBhbO/U5No2KPSErmkuxeri+n42kMzc3gMc9iNH31xcoRjGyKPWV0P0GoWM5oE5
         Xf97imy4/3GjZ32zXiXVEa0pDKCGm1pM206xUliP3qaP04J21+XUxR9xFdLCHG2KhnB8
         CTbdkQpGrxEcjDTQu6iCE0nWogYGGcTtbhheJAieoD4t/VtVjWyQ8ouU5D90grm1b/4X
         cJC9uTRpuGRhuKyxqUk4OAfpAf/oEpCn67j4qHON+/7qiB70cJBuNkrfz1AM5+S5VMd2
         LKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nDkAQCanWh6x4Rfg/VlqS3Z7N14cNMWqlLERB0C8xnc=;
        b=uFuibO7NOFBQGlGUgdPjgBttY1T+iZYsNiVwlavHfjZZIzpYkCAqwjP6lQaGC7vZDh
         AOkhm1RqsOcw3DmHRfgZeWJ9LwcBZaQ+FSArRa2vkODXyWl5SeCz1Q2SPYU5LFHSjFRX
         pjWd4Z/WBwN8Io8EVHncwfcnq5xA/mFnUOxAZudMcvolYTDFJ6BssW25OW0Z/Pt2Mn1b
         rhGdGs1IqxPp6RBP8XNaKZX+ZjaQel6vfloNJ309g8N4G01t3InLR3rKsFw7Ias2GukD
         IsKMdb3I5zrABzIqOq0hP9OqTV/21tuiF9WCXB4o6sQNqU1inFXjgQraLLEb/ewLYBQV
         iqVQ==
X-Gm-Message-State: AOAM530s41YEvbqblhRdAIMekpbR+wSWPNR42zHnn7QaQ9GLR6gdaGtA
        RZfyW4q2lyoB9NEanKxiZjJFSLrc/po=
X-Google-Smtp-Source: ABdhPJwjHOfm4kJCV2Ke3bmwzYU9kSY/uHijkSbflc5vfH/zNRNNv6sT3PM1UnfTLmYyOYXc2/1RbQ==
X-Received: by 2002:a54:468f:: with SMTP id k15mr4146146oic.58.1615321045615;
        Tue, 09 Mar 2021 12:17:25 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id i3sm3178525oov.2.2021.03.09.12.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 12:17:25 -0800 (PST)
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        mingo@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
 <20210309124011.709c6cd3@gandalf.local.home>
 <5fda3ef7-d760-df4f-e076-23b635f6c758@gmail.com>
 <20210309150227.48281a18@gandalf.local.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fffda629-0028-2824-2344-3507b75d9188@gmail.com>
Date:   Tue, 9 Mar 2021 13:17:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210309150227.48281a18@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/21 1:02 PM, Steven Rostedt wrote:
> On Tue, 9 Mar 2021 12:53:37 -0700
> David Ahern <dsahern@gmail.com> wrote:
> 
>> Changing the order of the fields will impact any bpf programs expecting
>> the existing format
> 
> I thought bpf programs were not API. And why are they not parsing this
> information? They have these offsets hard coded???? Why would they do that!
> The information to extract the data where ever it is has been there from
> day 1! Way before BPF ever had access to trace events.

BPF programs attached to a tracepoint are passed a context - a structure
based on the format for the tracepoint. To take an in-tree example, look
at samples/bpf/offwaketime_kern.c:

...

/* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
struct sched_switch_args {
        unsigned long long pad;
        char prev_comm[16];
        int prev_pid;
        int prev_prio;
        long long prev_state;
        char next_comm[16];
        int next_pid;
        int next_prio;
};
SEC("tracepoint/sched/sched_switch")
int oncpu(struct sched_switch_args *ctx)
{

...

Production systems do not typically have toolchains installed, so
dynamic generation of the program based on the 'format' file on the
running system is not realistic. That means creating the programs on a
development machine and installing on the production box. Further, there
is an expectation that a bpf program compiled against version X works on
version Y. Changing the order of the fields will break such programs in
non-obvious ways.
