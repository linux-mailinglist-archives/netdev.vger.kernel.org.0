Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBF54905E7
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 11:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbiAQK1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 05:27:24 -0500
Received: from foss.arm.com ([217.140.110.172]:56264 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233639AbiAQK1X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 05:27:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0227A6D;
        Mon, 17 Jan 2022 02:27:23 -0800 (PST)
Received: from [10.57.36.133] (unknown [10.57.36.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 613943F73D;
        Mon, 17 Jan 2022 02:27:20 -0800 (PST)
Subject: Re: [PATCH] perf record/arm-spe: Override attr->sample_period for
 non-libpfm4 events
To:     James Clark <james.clark@arm.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Cc:     Chase Conklin <chase.conklin@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "acme@kernel.org" <acme@kernel.org>
References: <20220114212102.179209-1-german.gomez@arm.com>
 <c2b960eb-a25e-7ce7-ee4b-2be557d8a213@arm.com>
From:   German Gomez <german.gomez@arm.com>
Message-ID: <35a4f70f-d7ef-6e3c-dc79-aa09d87f0271@arm.com>
Date:   Mon, 17 Jan 2022 10:27:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c2b960eb-a25e-7ce7-ee4b-2be557d8a213@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi James,

On 17/01/2022 09:59, James Clark wrote:
>
> On 14/01/2022 21:21, German Gomez wrote:
>> A previous commit preventing attr->sample_period values from being
>> overridden in pfm events changed a related behaviour in arm_spe.
>>
>> Before this patch:
>> perf record -c 10000 -e arm_spe_0// -- sleep 1
>>
>> Would not yield an SPE event with period=10000, because the arm-spe code
> Just to clarify, this seems like it should say "Would yield", not "Would not yield",
> as in it was previously working?

"this patch" refers to the patch I'm sending, not the one it's fixing.
I might have to rewrite this to make it more clear. How about:

===
A previous patch preventing "attr->sample_period" values from being
overridden in pfm events changed a related behaviour in arm-spe.

Before said patch:
perf record -c 10000 -e arm_spe_0// -- sleep 1

Would yield an SPE event with period=10000. After the patch, the period
in "-c 10000" was being ignored because the arm-spe code initializes
sample_period to a non-zero value.

This patch restores the previous behaviour for non-libpfm4 events.
===

Thanks for the review,
German
