Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6736A274FCB
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 06:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgIWEX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 00:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIWEX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 00:23:58 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A30C061755;
        Tue, 22 Sep 2020 21:23:58 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id m12so17802534otr.0;
        Tue, 22 Sep 2020 21:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=k8skaUrOGLefAsWbRS/AU6hTtSMdnqInD2WqFhiO0aA=;
        b=H3BOGnvW7b1BjpKnsdp3Zwr4qK1DPbSBtume1ErE9fy3WSsRywfvLJ8rAm+LOKHYZU
         8SMWDH8jAlA7gel+8ntDl80KOykLHtVj0NTP0ekefWZwLWHvz4YfJB+9PqQp1Iq90kn1
         1tpMZoYRSYQrSXxz9wZMnHYrhf5I8kCN0fzJ6Ayqde2mtdaSVyBkFRpaq/kBKP0pdCDm
         WsB+/tESDsJf7fEg7OiQiKkJjT/Q5QM2xTDbyGNHCQp55nA4Msd3+7D2SCcmkVDXp+pO
         Fgkiw6vwkjl1ZinxdFHX606Qrc7+CEUnoiytsXxOwem4S8JquVzmMZFH44awNtpcXjHC
         RiIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=k8skaUrOGLefAsWbRS/AU6hTtSMdnqInD2WqFhiO0aA=;
        b=EM7bZLsogryRAY+dfdge6sQRo6HTrhB96EBouJZ7Cb5emHOKhyZqVPi8A0mwDRYf6z
         acnmQVyamPncL/CHqnItX0kn5GjPjHpRGhJQ2G9e6lddn3an8Kpt0rESPDtxgmdoNgH+
         niHvEwYvsiK0DlknaezGtbkZbuf8qzbX5Gdq25bvPkur/MQYgsA9gUFS/Ah6JPPfQmtD
         FBKWNeQc+Kh8CQ/YApHjPHW7JcgB4SVyTmRy+dI2BZ83S4HARP45jperzIIHssyivtWR
         +lPKPvpgw9C/qiuwmVD9h/0FqqCS0CFn+ZgM55lkF/lynBFDzMrPe0twlkowggmzhnYy
         zl8g==
X-Gm-Message-State: AOAM53041pC35vWDOmA7ofMhfkREH/ggEvssQWl1iRLcqNnTVnPiYC2r
        KkUAx45d6PN6tD2amU3eF/U=
X-Google-Smtp-Source: ABdhPJwnZ44NtOWZH2PN4yJzaqn2jU4JVfDS0gLQ/3syLrKkm9nS76qT/IKX3zSUb5EnpaWzd4ynIw==
X-Received: by 2002:a05:6830:1ac8:: with SMTP id r8mr4707982otc.70.1600835038248;
        Tue, 22 Sep 2020 21:23:58 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u15sm7447036otg.78.2020.09.22.21.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 21:23:57 -0700 (PDT)
Date:   Tue, 22 Sep 2020 21:23:48 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        Song Liu <songliubraving@fb.com>
Message-ID: <5f6acdd4ef8a2_3657820819@john-XPS-13-9370.notmuch>
In-Reply-To: <20200923012841.2701378-2-songliubraving@fb.com>
References: <20200923012841.2701378-1-songliubraving@fb.com>
 <20200923012841.2701378-2-songliubraving@fb.com>
Subject: RE: [PATCH bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for
 raw_tracepoint
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Liu wrote:
> Add .test_run for raw_tracepoint. Also, introduce a new feature that runs
> the target program on a specific CPU. This is achieved by a new flag in
> bpf_attr.test, cpu_plus. For compatibility, cpu_plus == 0 means run the
> program on current cpu, cpu_plus > 0 means run the program on cpu with id
> (cpu_plus - 1). This feature is needed for BPF programs that handle
> perf_event and other percpu resources, as the program can access these
> resource locally.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>

[...]

> +
> +int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
> +			     const union bpf_attr *kattr,
> +			     union bpf_attr __user *uattr)
> +{
> +	void __user *ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
> +	__u32 ctx_size_in = kattr->test.ctx_size_in;
> +	struct bpf_raw_tp_test_run_info info;
> +	int cpu, err = 0;
> +
> +	/* doesn't support data_in/out, ctx_out, duration, or repeat */
> +	if (kattr->test.data_in || kattr->test.data_out ||
> +	    kattr->test.ctx_out || kattr->test.duration ||
> +	    kattr->test.repeat)
> +		return -EINVAL;
> +
> +	if (ctx_size_in < prog->aux->max_ctx_offset)
> +		return -EINVAL;
> +
> +	if (ctx_size_in) {
> +		info.ctx = kzalloc(ctx_size_in, GFP_USER);
> +		if (!info.ctx)
> +			return -ENOMEM;
> +		if (copy_from_user(info.ctx, ctx_in, ctx_size_in)) {
> +			err = -EFAULT;
> +			goto out;
> +		}
> +	} else {
> +		info.ctx = NULL;
> +	}
> +
> +	info.prog = prog;
> +	cpu = kattr->test.cpu_plus - 1;
> +
> +	if (!kattr->test.cpu_plus || cpu == smp_processor_id()) {
> +		__bpf_prog_test_run_raw_tp(&info);
> +	} else {
> +		/* smp_call_function_single() also checks cpu_online()
> +		 * after csd_lock(). However, since cpu_plus is from user
> +		 * space, let's do an extra quick check to filter out
> +		 * invalid value before smp_call_function_single().
> +		 */
> +		if (!cpu_online(cpu)) {
> +			err = -ENXIO;
> +			goto out;
> +		}
> +
> +		err = smp_call_function_single(cpu, __bpf_prog_test_run_raw_tp,
> +					       &info, 1);
> +		if (err)
> +			goto out;
> +	}
> +
> +	if (copy_to_user(&uattr->test.retval, &info.retval, sizeof(u32))) {
> +		err = -EFAULT;
> +		goto out;
> +	}

This goto is not needed. I don't mind it though.

> +
> +out:
> +	kfree(info.ctx);
> +	return err;
> +}
> +
