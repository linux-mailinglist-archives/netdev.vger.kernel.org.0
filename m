Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149294C5F2
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 05:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbfFTDwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 23:52:00 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39924 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfFTDv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 23:51:59 -0400
Received: by mail-ot1-f67.google.com with SMTP id r21so1336617otq.6
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 20:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o7v/MxKerkj9lXOy7XckOwr/I7Upmu6TOve4Yqn6x4Q=;
        b=VMhEP5fif4wABtZ6fnhcX8LomnG6o9Ke1/iYLehVNCBc8CTXCY6eAYQs95V+lPrYD4
         q817yFJ4ckKp6fqb88youV+TDnjPo7BiqKfPBeqzsSvtKdbPb+d8Fj1fht8vuavCWuzA
         hw8uhFcFrQIKaMrVz2BbaWH3SiA86F+RQIoh/vJzKbvs9vQdB8teIqKMKwRhJIj6ZbxR
         nLuR86Ld4v3e0QHOvVX+iMQi06lQFl0ye7NEFsUrORYgDA30i6jfRXstlUWpJpqCwbHa
         SKqQkqUpuftwbTzQG+NW2ctVxgdCNqPvVlcsTVMj5Ab7fFqX5VooKynidrx4++vY6YvO
         l6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o7v/MxKerkj9lXOy7XckOwr/I7Upmu6TOve4Yqn6x4Q=;
        b=LnNo+QBAGWYcymwcigQHfAxpaIGhMr0ehBaBSaU3i5b3c+SqsjykiAMRP7oSZJkxP5
         1GkMa+JZV+t7/xo5iZytAhKmcnymDNulwKwzQhGoY2q1B5bQ74CSqyxlVBlFMSJBgYoA
         RAaERQTaYBMbr3MA2RQfpyXZ+gAd25a/dQy/kzvoF9K0OMVr8OvI37fogjeRC+Cw0Ao+
         zpWFC3Qz847fnNTO0liCJTZKyYDe4MEHmj/HumbmSij1fVknP3wuWy2zAalI3fBQi+TO
         YGg7SHTdEIhNU6NBhQV0IyWR4IeZHfcrw1DMW5UWqj05JH6QoG8vu2oL262NkyeMH6rq
         luQA==
X-Gm-Message-State: APjAAAVLRuQ9j8B8iU1TFAeN/lUdyGZHyumvZmsbK8SCvhhGHMriI0dV
        thprgKF7oZoE/gA3xWBQqZkZQQ==
X-Google-Smtp-Source: APXvYqxbhOjgKvZ+zTXeEhCcFuDPnHqhfI7aTfjCaGnyc0GFuzYuIMQXsgTdJueXRifB7EQPe7awPQ==
X-Received: by 2002:a9d:62d2:: with SMTP id z18mr5979346otk.7.1561002718547;
        Wed, 19 Jun 2019 20:51:58 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li964-79.members.linode.com. [45.33.10.79])
        by smtp.gmail.com with ESMTPSA id g10sm8033999otg.81.2019.06.19.20.51.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Jun 2019 20:51:57 -0700 (PDT)
Date:   Thu, 20 Jun 2019 11:51:46 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>, coresight@lists.linaro.org
Subject: Re: [PATCH v2] perf cs-etm: Improve completeness for kernel address
 space
Message-ID: <20190620035146.GJ24549@leoy-ThinkPad-X240s>
References: <20190620005428.20883-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620005428.20883-1-leo.yan@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Thu, Jun 20, 2019 at 08:54:28AM +0800, Leo Yan wrote:

[...]

> diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> index 51dd00f65709..cf5906d667aa 100644
> --- a/tools/perf/Makefile.config
> +++ b/tools/perf/Makefile.config
> @@ -418,6 +418,26 @@ ifdef CORESIGHT
>      endif
>      LDFLAGS += $(LIBOPENCSD_LDFLAGS)
>      EXTLIBS += $(OPENCSDLIBS)
> +    ARM_PRE_START_SIZE := 0
> +    ifeq ($(SRCARCH),arm64)
> +      # Extract info from lds:
> +      #  . = ((((((((0xffffffffffffffff)) - (((1)) << (48)) + 1) + (0)) + (0x08000000))) + (0x08000000))) + 0x00080000;
> +      # ARM_PRE_START_SIZE := (0x08000000 + 0x08000000 + 0x00080000)
> +      ARM_PRE_START_SIZE := $(shell egrep ' \. \= \({8}0x[0-9a-fA-F]+\){2}' \
> +        $(srctree)/arch/arm64/kernel/vmlinux.lds | \
> +        sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
> +        awk -F' ' '{print "("$$6 "+"  $$7 "+" $$8")"}' 2>/dev/null)
> +    endif
> +    ifeq ($(SRCARCH),arm)
> +      # Extract info from lds:
> +      #   . = ((0xC0000000)) + 0x00208000;
> +      # ARM_PRE_START_SIZE := 0x00208000
> +      ARM_PRE_START_SIZE := $(shell egrep ' \. \= \({2}0x[0-9a-fA-F]+\){2}' \
> +        $(srctree)/arch/arm/kernel/vmlinux.lds | \
> +        sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
> +        awk -F' ' '{print "("$$2")"}' 2>/dev/null)
> +    endif
> +    CFLAGS += -DARM_PRE_START_SIZE="$(ARM_PRE_START_SIZE)"

I did testing for building perf with this patch, this patch is fragile
and easily introduce the building warning:

  <command-line>: error: "ARM_PRE_START_SIZE" redefined [-Werror]
  <command-line>: note: this is the location of the previous definition

To dismiss this error, I need to change the macro define as below:

  +    CFLAGS += -DARM_PRE_START_SIZE=$(ARM_PRE_START_SIZE)

So I sent patch v3 to address this issue and please directly reivew
patch v3.  Sorry for spamming.

Thanks,
Leo Yan


>      $(call detected,CONFIG_LIBOPENCSD)
>      ifdef CSTRACE_RAW
>        CFLAGS += -DCS_DEBUG_RAW
> diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
> index 0c7776b51045..5fa0be3a3904 100644
> --- a/tools/perf/util/cs-etm.c
> +++ b/tools/perf/util/cs-etm.c
> @@ -613,10 +613,27 @@ static void cs_etm__free(struct perf_session *session)
>  static u8 cs_etm__cpu_mode(struct cs_etm_queue *etmq, u64 address)
>  {
>  	struct machine *machine;
> +	u64 fixup_kernel_start = 0;
>  
>  	machine = etmq->etm->machine;
>  
> -	if (address >= etmq->etm->kernel_start) {
> +	/*
> +	 * Since arm and arm64 specify some memory regions prior to
> +	 * 'kernel_start', kernel addresses can be less than 'kernel_start'.
> +	 *
> +	 * For arm architecture, the 16MB virtual memory space prior to
> +	 * 'kernel_start' is allocated to device modules, a PMD table if
> +	 * CONFIG_HIGHMEM is enabled and a PGD table.
> +	 *
> +	 * For arm64 architecture, the root PGD table, device module memory
> +	 * region and BPF jit region are prior to 'kernel_start'.
> +	 *
> +	 * To reflect the complete kernel address space, compensate these
> +	 * pre-defined regions for kernel start address.
> +	 */
> +	fixup_kernel_start = etmq->etm->kernel_start - ARM_PRE_START_SIZE;
> +
> +	if (address >= fixup_kernel_start) {
>  		if (machine__is_host(machine))
>  			return PERF_RECORD_MISC_KERNEL;
>  		else
> -- 
> 2.17.1
> 
