Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2B0179A3A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387905AbgCDUif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:38:35 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24854 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728642AbgCDUif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 15:38:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583354314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TXehQk5BC1JPWLk1F3kamN0LZh08bGn+YqIvNCPT8v8=;
        b=LGnPMM8fsA+a6ZrJR5EkzgVTD+03Q37Z6w40HeRrd9XoqP48sD+K8tyl9z1qkcxnjXdP6Q
        wH07N92kHIKnfRLcltUL12VzNGjInRBDoYF46UB2FZmMKFhXu9yMrgcBzqg1Z67TIDvUvO
        BLOD2/KMXT/KIHtW1S4l1Jt3wWK0jMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-itE91iRUPX-tQ23vYp71Hw-1; Wed, 04 Mar 2020 15:38:32 -0500
X-MC-Unique: itE91iRUPX-tQ23vYp71Hw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C43EE107ACC9;
        Wed,  4 Mar 2020 20:38:30 +0000 (UTC)
Received: from krava (ovpn-205-10.brq.redhat.com [10.40.205.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 77D9991D84;
        Wed,  4 Mar 2020 20:38:28 +0000 (UTC)
Date:   Wed, 4 Mar 2020 21:38:25 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, quentin@isovalent.com,
        kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        arnaldo.melo@gmail.com, jolsa@kernel.org
Subject: Re: [PATCH v4 bpf-next 1/4] bpftool: introduce "prog profile" command
Message-ID: <20200304203825.GC168640@krava>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304180710.2677695-2-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304180710.2677695-2-songliubraving@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 10:07:07AM -0800, Song Liu wrote:

SNIP

> +
> +#include "profiler.skel.h"
> +
> +#define SAMPLE_PERIOD  0x7fffffffffffffffULL
> +struct profile_metric {
> +	const char *name;
> +	struct bpf_perf_event_value val;
> +	struct perf_event_attr attr;
> +	bool selected;
> +
> +	/* calculate ratios like instructions per cycle */
> +	const int ratio_metric; /* 0 for N/A, 1 for index 0 (cycles) */
> +	const char *ratio_desc;
> +	const float ratio_mul;
> +} metrics[] = {
> +	{
> +		.name = "cycles",
> +		.attr = {
> +			.sample_period = SAMPLE_PERIOD,

I don't think you need to set sample_period for counting.. why?

> +			.type = PERF_TYPE_HARDWARE,
> +			.config = PERF_COUNT_HW_CPU_CYCLES,

you could also add .exclude_user = 1

jirka

