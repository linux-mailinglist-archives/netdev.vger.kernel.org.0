Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB44B2C7746
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 03:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgK2CAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 21:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgK2CAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 21:00:17 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B2CC0613D1;
        Sat, 28 Nov 2020 17:59:37 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id x4so2819829pln.8;
        Sat, 28 Nov 2020 17:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8c+fsvrCwlFBUWgSVAmwkVHV4vrrSBlLSmzxZa41+ak=;
        b=E1phdNbqgAbUpST6mS741TU/ksC7BK/2XDEzhT+nTaV/PG+BDOiGivBpzuIezuIZ4B
         GV9Ex+PcGmKhaPq/bQainK0bSooWB7PjIzryh4qOUCN8BAZKBmi3IrGBPSBrfDef/YN6
         95LMkKqSo0wvi9Qr2jG28S+L3Xkdk8iT9jiEJ2FZKFL6ehbMq2m8XOZf87x5zUnG+hSW
         A+Lj+JxA83aoGk8PAa4Zi7p7IF/p2O8VyrXL24yd9a8dZkDSF2llB20+N1YhkDJcV+OX
         DwXQMTn9NDpc3k87Nr27CuXtKtTCL0FH/p0VT2176bU2v4y6z2jaAfh0iY9mojA3fMd7
         kDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8c+fsvrCwlFBUWgSVAmwkVHV4vrrSBlLSmzxZa41+ak=;
        b=QrRoONQLBsp3RQa3AdHKfpuOqz8w7DKZqUVtHbpl6/wRlwg5U/zVXGK0MVsk+LpBet
         tX6SJTSB+uJIoC2D3uiUVcoiPX9yYeS1iDdShLd3gUuPItIPRlCJueHVvSYwF+EMkDTU
         U3CcgKLY0CTs2HOQ43KYw7mR3obGSxi6dG/ppl25PuII33VqhhNr+JvmRXhKLJ+HNFPd
         EoD3LLHqTp3FXpd8lKkFUtNXCcJlipDLc1bsgJ5/F46W9gDOa9CJM/k9eZDiFsJLIl9Y
         lrX6/YNv7PW7HJyvhNVVRHPDQ1GSc9l8rN2RdNYPoaXwf3hLUTILNrr8VjBRxebmWiya
         ySbg==
X-Gm-Message-State: AOAM5304wNQlEoJXZX27wH41X4V2UxQN/dHNyhX6lvrqFi+2eJIrQMV6
        N9oAqsTARm6298Sr5FxR414=
X-Google-Smtp-Source: ABdhPJzXlJOjiJSBvleIWWe2R1eoOuuiXg1IfkFmJxZsQDsHAaohmZc1/LZOCJfa7JhbWelIVz2o+g==
X-Received: by 2002:a17:902:6949:b029:da:17d0:d10f with SMTP id k9-20020a1709026949b02900da17d0d10fmr12760066plt.71.1606615177001;
        Sat, 28 Nov 2020 17:59:37 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:5925])
        by smtp.gmail.com with ESMTPSA id c20sm2878385pgc.25.2020.11.28.17.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 17:59:36 -0800 (PST)
Date:   Sat, 28 Nov 2020 17:59:34 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 5/7] selftests/bpf: add tp_btf CO-RE reloc test
 for modules
Message-ID: <20201129015934.qlikfg7czp4cc7sf@ast-mbp>
References: <20201121024616.1588175-1-andrii@kernel.org>
 <20201121024616.1588175-6-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121024616.1588175-6-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 06:46:14PM -0800, Andrii Nakryiko wrote:
>  
>  SEC("raw_tp/bpf_sidecar_test_read")
> -int BPF_PROG(test_core_module,
> +int BPF_PROG(test_core_module_probed,
>  	     struct task_struct *task,
>  	     struct bpf_sidecar_test_read_ctx *read_ctx)
>  {
> @@ -64,3 +64,33 @@ int BPF_PROG(test_core_module,
>  
>  	return 0;
>  }
> +
> +SEC("tp_btf/bpf_sidecar_test_read")
> +int BPF_PROG(test_core_module_direct,
> +	     struct task_struct *task,
> +	     struct bpf_sidecar_test_read_ctx *read_ctx)

"sidecar" is such an overused name.
I didn't like it earlier, but seeing that it here again and again I couldn't help it.
Could you please pick a different name for kernel module?
It's just a kernel module for testing. Just call it so. No need for fancy name.
