Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8EC4CFF3D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242585AbiCGM4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbiCGM43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:56:29 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EE186E0A;
        Mon,  7 Mar 2022 04:55:35 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y11so19236339eda.12;
        Mon, 07 Mar 2022 04:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RNAJ42MP/kuUASS9DTVpDef+Mp6TeqXkkan7wzM2/V8=;
        b=GMVHRlPOdSr9rXt8WO5oD/NaHrl7z295Z2jA6jkgm4aZIOoj9SzvTh/8A0K8EYeHRd
         py48/FimDI7RNUvpjXGSfVb3XIVECt2oym3OI06vyRfZ3q79BAcnN99CKhBWcEfMDYKD
         gEUhhID1ysso0QA1cOq/Dnhycxd3IGYFocdBsjyHtAf1bcQn3Yy5m3cvqC90dwti3Blh
         W8+0zQCCyAOvhUFZy3MfSsSKP62bMLSGA5q7Eg3WZVGcxB8di/eAiEk0Cxzr7EaBScPP
         QRu6fdIMsWCo/9y8QvhDrrVyfoJjw3hh1mW0zG55x2506M01Qt7STvF4PYrqf2r6K5TY
         1K/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RNAJ42MP/kuUASS9DTVpDef+Mp6TeqXkkan7wzM2/V8=;
        b=CFVALOFZBCv7IOC4gFLS+hNA3tgHPhNnoSANssKHCxVmiELe0tg60UYOzbZmFYrUsw
         jwpjEV0obJNBC3K+6uBV3byjLKr0PSoRutVn5aQEATzVut0X/3e+SxKkcaoA323t/Pu8
         gbaA91pKMgjJEjohANDzDoae38sFmU1vFAnd3Tb8xJzUgTBR/QkUa2K/SQpQOTZ+JbgC
         bjxAmzDFEwV3bZjJJIrWf5yytPHfhACgho5BQMPjOFygvRqYgLWpsNd8r8/h1mJorEbH
         w0FltUL5d41f34a3WFClpspyhVU5DaWTD5LPIgGWY9O+EVepKnCT1VJu7KwjRdy7ruvN
         mqbg==
X-Gm-Message-State: AOAM531N1j70ehSQ3mwSm2tKwEdPulKu9+4ykH8gGPtonvySQqI+GD8o
        XDFpwX6VOh0BO3C8ilE4EBzTicf+ISPOcw==
X-Google-Smtp-Source: ABdhPJySFGcAM1QZs6QQC0HBKv98F+RFLUr1GoUiEx10Ub4Zz6OhQYdnxlcQFOew1mGxPHqJWxTXwA==
X-Received: by 2002:a50:d592:0:b0:415:e599:4166 with SMTP id v18-20020a50d592000000b00415e5994166mr10832749edi.195.1646657734040;
        Mon, 07 Mar 2022 04:55:34 -0800 (PST)
Received: from krava ([83.240.62.150])
        by smtp.gmail.com with ESMTPSA id n27-20020a1709062bdb00b006da975173bfsm4430491ejg.170.2022.03.07.04.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 04:55:33 -0800 (PST)
Date:   Mon, 7 Mar 2022 13:55:31 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v9 02/11] fprobe: Add ftrace based probe APIs
Message-ID: <YiYAw64nDTWB/V0t@krava>
References: <164655933970.1674510.3809060481512713846.stgit@devnote2>
 <164655936328.1674510.15506582463881824113.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164655936328.1674510.15506582463881824113.stgit@devnote2>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 06:36:03PM +0900, Masami Hiramatsu wrote:

SNIP

> +}
> +NOKPROBE_SYMBOL(fprobe_handler);
> +
> +/* Convert ftrace location address from symbols */
> +static unsigned long *get_ftrace_locations(const char **syms, int num)
> +{
> +	unsigned long addr, size;
> +	unsigned long *addrs;
> +	int i;
> +
> +	/* Convert symbols to symbol address */
> +	addrs = kcalloc(num, sizeof(*addrs), GFP_KERNEL);
> +	if (!addrs)
> +		return ERR_PTR(-ENOMEM);
> +
> +	for (i = 0; i < num; i++) {
> +		addrs[i] = kallsyms_lookup_name(syms[i]);
> +		if (!addrs[i])	/* Maybe wrong symbol */
> +			goto error;
> +	}
> +
> +	/* Convert symbol address to ftrace location. */
> +	for (i = 0; i < num; i++) {
> +		if (!kallsyms_lookup_size_offset(addrs[i], &size, NULL) || !size)
> +			goto error;
> +		addr = ftrace_location_range(addrs[i], addrs[i] + size - 1);
> +		if (!addr) /* No dynamic ftrace there. */
> +			goto error;
> +		addrs[i] = addr;
> +	}

why not one just single loop ?

jirka


> +
> +	return addrs;
> +
> +error:
> +	kfree(addrs);
> +
> +	return ERR_PTR(-ENOENT);
> +}
> +
> +static void fprobe_init(struct fprobe *fp)
> +{
> +	fp->nmissed = 0;
> +	fp->ops.func = fprobe_handler;
> +	fp->ops.flags |= FTRACE_OPS_FL_SAVE_REGS;
> +}

SNIP
