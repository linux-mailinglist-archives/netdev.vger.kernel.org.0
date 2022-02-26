Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE764C56BC
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 17:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiBZQBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 11:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiBZQBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 11:01:33 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB8B179259;
        Sat, 26 Feb 2022 08:00:59 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id hw13so16537919ejc.9;
        Sat, 26 Feb 2022 08:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y+Us+84YJbXsy1zIplUSCiEcPWyNLvsDi6jitmhUwvE=;
        b=qXxeJK//ibcQsJDMTZPMSXPJzTyYeMA7wvNp4gsl96nqdVf4EK48nvZz+h4WwuuZh8
         N4YG6GH/v77X0rXQyEKPiAs6GE1s4WqpF4KuoBxEPV6wsM6otmTHStPl51RJh8Zy5DgN
         SHa8DN4Y0myRcJSqxDNVYQew0vJw38yUvM9t3DV4SohAKcuzr+2g5nu0w5ALZDbil3pV
         6UcU9dCRru1RYuO9Svfinr8JS9HLHxpBhpy5Sec0+y9U6K8QU1eDSDty+zqRaDSiRP0w
         8lQuN7Hqa4zjE5aWvymLULmQFyAZGc6Qa87b7UGHAR233PObNdm0wbgVi2ffDNpVxBDx
         VUxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y+Us+84YJbXsy1zIplUSCiEcPWyNLvsDi6jitmhUwvE=;
        b=4JBvYhbS0L11byfskv09A71WRjLt0TGXSUlqwOXV3YF+O/ZZcoCz5f+uN0z4Pows2K
         QhI4znB01WZb5lNy2oiCbSKBMQeKwke/V7yF6hvz9olF4DKBWd32LkDIEXFGPThZ4hFs
         CsPsIvms7jPcO1oUXZKJVGg0c0oJBCY//oZyar56gOIpZ4PzkpBe06SS4fO9Wl3BMbBH
         /Q9szY9/NnJ2O2thSRdJBW1RmW7mMVQYS1XcKuqEGDaPUU6k7eu0wPMQ3e/Ts02JOQML
         h93mLOv17xq6V5uBnZvoIZFJR+QMIwK1qCLmscFLpGPY/uKFWJbgpBr+sImQlkomhCns
         z5cQ==
X-Gm-Message-State: AOAM533xHyKLvXIn7cKCBrvP4KDjDvuyNRfMJbwtu59WNKyX5vBMYYHJ
        6kbxwzV4a4e9VfU2i9a7S7A=
X-Google-Smtp-Source: ABdhPJy2VRO2oC+bWr2xZvbxgCqrgWglVmah7oQnqwwKhIXTF2nfJQlUIilzf4DcT5jdCInOvQJK1w==
X-Received: by 2002:a17:906:f250:b0:6b5:83df:237d with SMTP id gy16-20020a170906f25000b006b583df237dmr10009053ejb.157.1645891257693;
        Sat, 26 Feb 2022 08:00:57 -0800 (PST)
Received: from krava ([2a00:102a:4012:7bee:99f7:73f9:d8ed:b1a])
        by smtp.gmail.com with ESMTPSA id c4-20020a170906340400b006d077e850b5sm2364125ejb.23.2022.02.26.08.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 08:00:57 -0800 (PST)
Date:   Sat, 26 Feb 2022 17:00:52 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 4/4] selftests/bpf: add tests for u[ret]probe
 attach by name
Message-ID: <YhpOI1Yk7JlmIgLQ@krava>
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
 <1643645554-28723-5-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1643645554-28723-5-git-send-email-alan.maguire@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 04:12:34PM +0000, Alan Maguire wrote:

SNIP

> +	/* verify auto-attach fails for old-style uprobe definition */
> +	uprobe_err_link = bpf_program__attach(skel->progs.handle_uprobe_byname);
> +	if (!ASSERT_EQ(libbpf_get_error(uprobe_err_link), -ESRCH,
> +		       "auto-attach should fail for old-style name"))
> +		goto cleanup;
> +
> +	uprobe_opts.func_name = "trigger_func2";
> +	uprobe_opts.retprobe = false;
> +	uprobe_opts.ref_ctr_offset = 0;
> +	skel->links.handle_uprobe_byname =
> +			bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname,
> +							0 /* this pid */,
> +							"/proc/self/exe",
> +							0, &uprobe_opts);
> +	if (!ASSERT_OK_PTR(skel->links.handle_uprobe_byname, "attach_uprobe_byname"))
> +		goto cleanup;
> +
> +	/* verify auto-attach works */
> +	skel->links.handle_uretprobe_byname =
> +			bpf_program__attach(skel->progs.handle_uretprobe_byname);
> +	if (!ASSERT_OK_PTR(skel->links.handle_uretprobe_byname, "attach_uretprobe_byname"))
> +		goto cleanup;
> +
> +	/* test attach by name for a library function, using the library
> +	 * as the binary argument.  To do this, find path to libc used
> +	 * by test_progs via /proc/self/maps.
> +	 */
> +	libc_path = get_lib_path("libc-");

hi,
I'm getting crash in here because the libc line in maps for me
looks like: /usr/lib64/libc.so.6

plus the check below will let through null pointer

> +	if (!ASSERT_OK_PTR(libc_path, "get path to libc"))
> +		goto cleanup;
> +	if (!ASSERT_NEQ(strstr(libc_path, "libc-"), NULL, "find libc path in /proc/self/maps"))
> +		goto cleanup;

and when I tried to use 'libc' in here, it does not crash but
libc_path holds the whole maps line:

  7fdbef31d000-7fdbef349000 r--p 00000000 fd:01 201656665                  /usr/lib64/libc.so.6

so it fails, I guess there's some issue in get_lib_path

jirka
