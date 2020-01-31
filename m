Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E3214EFF3
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgAaPmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:42:54 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:47465 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbgAaPmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 10:42:54 -0500
X-Originating-IP: 176.54.15.204
Received: from [10.3.243.48] (unknown [176.54.15.204])
        (Authenticated sender: cengiz@kernel.wtf)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 57E891C0019;
        Fri, 31 Jan 2020 15:42:49 +0000 (UTC)
From:   Cengiz Can <cengiz@kernel.wtf>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Date:   Fri, 31 Jan 2020 18:42:39 +0300
Message-ID: <16ffc41db20.2bfa.85c738e3968116fc5c0dc2de74002084@kernel.wtf>
In-Reply-To: <20200131084343.GI3841@kernel.org>
References: <20200120141553.23934-1-cengiz@kernel.wtf>
 <20200131083858.GH3841@kernel.org>
 <20200131084343.GI3841@kernel.org>
User-Agent: AquaMail/1.23.0-1550-develop (build: 102300000)
Subject: Re: [PATCH] tools: perf: add missing unlock to maps__insert error case
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On January 31, 2020 11:43:46 Arnaldo Carvalho de Melo 
<arnaldo.melo@gmail.com> wrote:

> Em Fri, Jan 31, 2020 at 09:38:58AM +0100, Arnaldo Carvalho de Melo escreveu:
>> Em Mon, Jan 20, 2020 at 05:15:54PM +0300, Cengiz Can escreveu:
>>> Please tell me if the `__maps__free_maps_by_name` frees the
>>> `rw_semaphore`. If that's the case, should we change the order to unlock 
>>> and free?
>>
>> No it doesn't free the rw_semaphore, that is in 'struct maps', what is
>> being freed is just something protected by rw_semaphore,
>> maps->maps_by_name, so your patch is right and I'm applying it, thanks.
>
> BTW, you forgot to add:
>
> Fixes: a7c2b572e217 ("perf map_groups: Auto sort maps by name, if needed")
>
> Which I did, and next time please CC the perf tools reviewers, as noted
> in MAINTAINERS, the lines starting with R:.

Missed that. Thank you for reminding and correction.

Cheers
>
> - Arnaldo
>
> [acme@quaco perf]$ grep -A21 "PERFORMANCE EVENTS SUBSYSTEM$" MAINTAINERS
> PERFORMANCE EVENTS SUBSYSTEM
> M: Peter Zijlstra <peterz@infradead.org>
> M: Ingo Molnar <mingo@redhat.com>
> M: Arnaldo Carvalho de Melo <acme@kernel.org>
> R: Mark Rutland <mark.rutland@arm.com>
> R: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> R: Jiri Olsa <jolsa@redhat.com>
> R: Namhyung Kim <namhyung@kernel.org>
> L: linux-kernel@vger.kernel.org
> T: git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
> S: Supported
> F: kernel/events/*
> F: include/linux/perf_event.h
> F: include/uapi/linux/perf_event.h
> F: arch/*/kernel/perf_event*.c
> F: arch/*/kernel/*/perf_event*.c
> F: arch/*/kernel/*/*/perf_event*.c
> F: arch/*/include/asm/perf_event.h
> F: arch/*/kernel/perf_callchain.c
> F: arch/*/events/*
> F: arch/*/events/*/*
> F: tools/perf/
> [acme@quaco perf]$



