Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CC64AA78B
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 09:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358704AbiBEIKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 03:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiBEIKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 03:10:23 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB10FC061347
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 00:10:21 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id c9so7069903plg.11
        for <netdev@vger.kernel.org>; Sat, 05 Feb 2022 00:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mRwDG3dHdSCt9JBk2JbCS8GWF1RzkAIy/xnl8iR8W7Y=;
        b=Efq/YfxkqG5CBZkRIDisd5gefe9br7yxLyzgSlJN58z1Z1XQqxfejULxQmW8IMxsK6
         pbUElT+8PCYsg8YA/RUK6wr+//t3jug9t+qemcQ5s5H06POYAojLHHsWPMPCAQ7L4XFZ
         M80w3rSQrn1K0SQBHRJdaEV/7J0Ps+vnOlZ/zk6uarHFQXTDi0zNN99DAZJuOwHkAofb
         35vVxceWkkJxUCysdnD88PUHrKqu5TdxmfL4iy+ZMTgQHFNE4zlMPmsrmK44dyRJCU/0
         zK8JAJ5CzTqIgFiLlHyG5eKoi4YgIFtaxoh37za2slQitkcVCkmGhPDYMNielJbbCtha
         RHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mRwDG3dHdSCt9JBk2JbCS8GWF1RzkAIy/xnl8iR8W7Y=;
        b=Hfa7VrG43m8AiZ4FJp8IkjgJtb03kSH762F2VvhEKNUorqIOEc11XqFmKFQwFpF/3S
         Yb+lDqoN0wHArgi26n2FOjQAmJGMsm7DyEWdW6D0Hn/IXMY+/qEyUMzRpHS5t6/rlTBK
         7Smsx9IQHt//M090JyA+mEUDzjCe7SetctS3hW9N8a2JkMrubtCqwZOwD3IZXGqm1etz
         ymnHYD5nqqQ26OT+mnDPDxeAwclST1m0HtIxtnSutZPqtXN8nyIE/b5VDdhbZ+c8L87e
         ePan0MA40JNmtrSbiXSjHzkiWYJ4sBIA60EVDQdnluhMcE8gbCABxZuk2l6psUHIN8jg
         Wv7Q==
X-Gm-Message-State: AOAM533/x4kLlnekMOnBlp7YcL5RPSCiwk+XbpLq4sW4AmRxeVuYDk0I
        Nz7qOJtdwdekhlFbDhrPJOZflg==
X-Google-Smtp-Source: ABdhPJyzVREfDn/ZPdBiHrLF3VHliNAMRn8haobaKdARf0TzcgZ2O8oD1Q04EkQAa1rtwqfOjRdutw==
X-Received: by 2002:a17:902:8483:: with SMTP id c3mr7095691plo.19.1644048620689;
        Sat, 05 Feb 2022 00:10:20 -0800 (PST)
Received: from leoy-ThinkPad-X240s ([134.195.101.46])
        by smtp.gmail.com with ESMTPSA id k16sm5118928pfu.140.2022.02.05.00.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 00:10:19 -0800 (PST)
Date:   Sat, 5 Feb 2022 16:10:13 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     German Gomez <german.gomez@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] perf test: Add perf_event_attr tests for the arm_spe
 event
Message-ID: <20220205081013.GA391033@leoy-ThinkPad-X240s>
References: <20220126160710.32983-1-german.gomez@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126160710.32983-1-german.gomez@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi German,

On Wed, Jan 26, 2022 at 04:07:09PM +0000, German Gomez wrote:
> Adds a couple of perf_event_attr tests for the fix introduced in [1].
> The tests check that the correct sample_period value is set in the
> struct perf_event_attr of the arm_spe events.
> 
> [1]: https://lore.kernel.org/all/20220118144054.2541-1-german.gomez@arm.com/
> 
> Signed-off-by: German Gomez <german.gomez@arm.com>

I tested this patch with two commands:

# PERF_TEST_ATTR=/tmp /usr/bin/python2 ./tests/attr.py -d ./tests/attr/ \
        -p ./perf -vvvvv -t test-record-spe-period
# PERF_TEST_ATTR=/tmp /usr/bin/python2 ./tests/attr.py -d ./tests/attr/ \
        -p ./perf -vvvvv -t test-record-spe-period-term

Both testing can pass on Hisilicon D06 board.

One question: I'm a bit concern this case will fail on some Arm64
platforms which doesn't contain Arm SPE modules.  E.g. below commands
will always fail on Arm64 platforms if SPE module is absent.  So I am
wandering if we can add extra checking ARM SPE event is existed or not?

  # ./perf test list
   17: Setup struct perf_event_attr
  # ./perf test 17

Thanks,
Leo

> ---
>  tools/perf/tests/attr/README                  |  2 +
>  tools/perf/tests/attr/base-record-spe         | 40 +++++++++++++++++++
>  tools/perf/tests/attr/test-record-spe-period  | 12 ++++++
>  .../tests/attr/test-record-spe-period-term    | 12 ++++++
>  4 files changed, 66 insertions(+)
>  create mode 100644 tools/perf/tests/attr/base-record-spe
>  create mode 100644 tools/perf/tests/attr/test-record-spe-period
>  create mode 100644 tools/perf/tests/attr/test-record-spe-period-term
> 
> diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
> index 1116fc6bf2ac..454505d343fa 100644
> --- a/tools/perf/tests/attr/README
> +++ b/tools/perf/tests/attr/README
> @@ -58,6 +58,8 @@ Following tests are defined (with perf commands):
>    perf record -c 100 -P kill                    (test-record-period)
>    perf record -c 1 --pfm-events=cycles:period=2 (test-record-pfm-period)
>    perf record -R kill                           (test-record-raw)
> +  perf record -c 2 -e arm_spe_0// -- kill       (test-record-spe-period)
> +  perf record -e arm_spe_0/period=3/ -- kill    (test-record-spe-period-term)
>    perf stat -e cycles kill                      (test-stat-basic)
>    perf stat kill                                (test-stat-default)
>    perf stat -d kill                             (test-stat-detailed-1)
> diff --git a/tools/perf/tests/attr/base-record-spe b/tools/perf/tests/attr/base-record-spe
> new file mode 100644
> index 000000000000..08fa96b59240
> --- /dev/null
> +++ b/tools/perf/tests/attr/base-record-spe
> @@ -0,0 +1,40 @@
> +[event]
> +fd=*
> +group_fd=-1
> +flags=*
> +cpu=*
> +type=*
> +size=*
> +config=*
> +sample_period=*
> +sample_type=*
> +read_format=*
> +disabled=*
> +inherit=*
> +pinned=*
> +exclusive=*
> +exclude_user=*
> +exclude_kernel=*
> +exclude_hv=*
> +exclude_idle=*
> +mmap=*
> +comm=*
> +freq=*
> +inherit_stat=*
> +enable_on_exec=*
> +task=*
> +watermark=*
> +precise_ip=*
> +mmap_data=*
> +sample_id_all=*
> +exclude_host=*
> +exclude_guest=*
> +exclude_callchain_kernel=*
> +exclude_callchain_user=*
> +wakeup_events=*
> +bp_type=*
> +config1=*
> +config2=*
> +branch_sample_type=*
> +sample_regs_user=*
> +sample_stack_user=*
> diff --git a/tools/perf/tests/attr/test-record-spe-period b/tools/perf/tests/attr/test-record-spe-period
> new file mode 100644
> index 000000000000..75f8c9cd8e3f
> --- /dev/null
> +++ b/tools/perf/tests/attr/test-record-spe-period
> @@ -0,0 +1,12 @@
> +[config]
> +command = record
> +args    = --no-bpf-event -c 2 -e arm_spe_0// -- kill >/dev/null 2>&1
> +ret     = 1
> +arch    = aarch64
> +
> +[event-10:base-record-spe]
> +sample_period=2
> +freq=0
> +
> +# dummy event
> +[event-1:base-record-spe]
> diff --git a/tools/perf/tests/attr/test-record-spe-period-term b/tools/perf/tests/attr/test-record-spe-period-term
> new file mode 100644
> index 000000000000..8f60a4fec657
> --- /dev/null
> +++ b/tools/perf/tests/attr/test-record-spe-period-term
> @@ -0,0 +1,12 @@
> +[config]
> +command = record
> +args    = --no-bpf-event -e arm_spe_0/period=3/ -- kill >/dev/null 2>&1
> +ret     = 1
> +arch    = aarch64
> +
> +[event-10:base-record-spe]
> +sample_period=3
> +freq=0
> +
> +# dummy event
> +[event-1:base-record-spe]
> -- 
> 2.25.1
> 
