Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC93754EFE8
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 05:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379824AbiFQD7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 23:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379395AbiFQD7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 23:59:13 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E8D66688;
        Thu, 16 Jun 2022 20:59:12 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 184so2996666pga.12;
        Thu, 16 Jun 2022 20:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0W/HagJonywK7ZJ69fI6hX0gZNSYy1J0766XYUBnWpk=;
        b=Nvg1C8j395PzqVMZnx7Pj7fKKRISIC9UVVzrpnpRJTkWrg/GeiXEoHYLleP8PgtdO3
         ue0ZDjtp9W4ASVbp+E2+uL8kpw9jDv6oT5cqQDt1HQfKY8QUNNC1pA3xeCMjGRQKJv/a
         xMgxd7N9YDtp65T23zwrOpasD8RV3eunaCc5Iunf7nFnnnuCZjivH01djAnKKCyM3Mmm
         mZbSZ2BqtLWnSIApdds3cMEMtK+pXGWVM3uZyOQmVoOlRJ9x84nYFC1GrkSd2fB+DaUg
         6Z0cpc8VJete8mRvSkx4IQH+xf7V15Ec1TI2DQ5mUpb8MKF5OP3nl2BIaT+CK7MLAtCU
         RHLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0W/HagJonywK7ZJ69fI6hX0gZNSYy1J0766XYUBnWpk=;
        b=oteqYV5z5Bx7N1fMbLiYDGcN6Ltm3yl2rBocursT6I7ixBS6YrHqISJ6++Gefv3GS6
         47NyvQKYX58IIVn93NzXFbkKsShXxnqHG4R54GNvQa2KnHnxbl0QmiFZwQdqY4J0jJmy
         P/g2cN07kTgI7BTiFjAEw7DtYUGCckFm6GEXnjmCeCdOas7MVjJwIKjPl4DeXT/2xlSu
         i0gRFcoFR1Ay/l0wWzkObG07I1kshDKlENvNJj72q4rYVhMN+SXcnrsY11fCrM6k0bXN
         n/WVHkw9wbUlbRVHw/Kz0K3YMEldOfGCOAZXtCBSTeFBteqydtBViVImLCz2biabGFZx
         Lgfg==
X-Gm-Message-State: AJIora8f5wOP0DWwIbL1GiAQDfm3Tq1iW34K7s/qLJPDEsy6IUatJ+vX
        99vEGB7U7z4PGzWhgup4+H8=
X-Google-Smtp-Source: AGRyM1vVl/dKUvpt/f8eeQsaxDmxmSSgcVkCHsMH8j6ipARrJnfgTrUyJ/gnAnfCrqd0Dt9fJRq5nw==
X-Received: by 2002:a63:3e0b:0:b0:40c:42db:6601 with SMTP id l11-20020a633e0b000000b0040c42db6601mr3050057pga.586.1655438351515;
        Thu, 16 Jun 2022 20:59:11 -0700 (PDT)
Received: from MacBook-Pro-3.local ([2620:10d:c090:400::5:29cb])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b0016a0858b25dsm39168plg.152.2022.06.16.20.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 20:59:11 -0700 (PDT)
Date:   Thu, 16 Jun 2022 20:59:08 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kpsingh@kernel.org, john.fastabend@gmail.com,
        songliubraving@fb.com, kafai@fb.com, yhs@fb.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH v4 4/4] selftests/bpf: Add test for
 bpf_verify_pkcs7_signature() helper
Message-ID: <20220617035908.iw4426f3h4ecpvvp@MacBook-Pro-3.local>
References: <20220614130621.1976089-1-roberto.sassu@huawei.com>
 <20220614130621.1976089-5-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614130621.1976089-5-roberto.sassu@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 03:06:21PM +0200, Roberto Sassu wrote:
> +
> +	if (child_pid == 0) {
> +		snprintf(path, sizeof(path), "%s/signing_key.pem", tmp_dir);
> +
> +		return execlp("./sign-file", "./sign-file", "sha256",
> +			      path, path, signed_file_template, NULL);

Please use sign_only option,
so it saves the signature and doesn't do 'struct module_signature' append.
Parsing of that is unnecessary for the purpose of the helper.
Checking MODULE_SIG_STRING is unnecessary, etc, etc.
Long term we won't be following mod sig approach anyway.
bpf maps and progs will have a different format.

> +	}
> +
> +	waitpid(child_pid, &child_status, 0);
> +
> +	ret = WEXITSTATUS(child_status);
> +	if (ret)
> +		goto out;
> +
> +	ret = stat(signed_file_template, &st);
> +	if (ret == -1) {
> +		ret = -errno;
> +		goto out;
> +	}
> +
> +	if (st.st_size > sizeof(data_item->payload) - sizeof(u32)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	*(u32 *)data_item->payload = __cpu_to_be32(st.st_size);
> +
> +	fd = open(signed_file_template, O_RDONLY);
> +	if (fd == -1) {
> +		ret = -errno;
> +		goto out;
> +	}
> +
> +	ret = read(fd, data_item->payload + sizeof(u32), st.st_size);
> +
> +	close(fd);
> +
> +	if (ret != st.st_size) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	ret = 0;
> +out:
> +	unlink(signed_file_template);
> +	return ret;
> +}
> +
> +void test_verify_pkcs7_sig(void)
> +{
> +	char tmp_dir_template[] = "/tmp/verify_sigXXXXXX";
> +	char *tmp_dir;
> +	char *buf = NULL;
> +	struct test_verify_pkcs7_sig *skel = NULL;
> +	struct bpf_map *map;
> +	struct data data;
> +	u32 saved_len;
> +	int ret, zero = 0;
> +
> +	LIBBPF_OPTS(bpf_object_open_opts, opts);
> +
> +	/* Trigger creation of session keyring. */
> +	syscall(__NR_request_key, "keyring", "_uid.0", NULL,
> +		KEY_SPEC_SESSION_KEYRING);

My understanding that user space can receive a specific id here.
It should pass it to bpf prog via global variable and prog
should use that id instead of max_ulong hack.

