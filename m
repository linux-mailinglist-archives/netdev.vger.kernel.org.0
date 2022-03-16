Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BD14DB841
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240237AbiCPSyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357795AbiCPSyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:54:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB276192B7;
        Wed, 16 Mar 2022 11:53:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d18so2546492plr.6;
        Wed, 16 Mar 2022 11:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A7w55O8G0c2nEPrllsuJvvxVEkxf0Le9RP1UeeVl+XQ=;
        b=D+3g3q5fR8JNApiFIYnoruG58vvF4dE2pCXQfNIUgc3xfr15jDxIegFk+NBgiYsd/L
         kpDv0kEVebU3uyMU7NWYdsYWxAYBionfZWCk4hORaLdzXv4N/1rpEtv5SVLrFtL/w04l
         un2CmPSTeJ9N17eJjvMI9/6YlX+4eBvHFn4a9blavqKpNbdAxZU/4u5YSa/yPEtx7u0o
         kiuXsSht7g3cc5adinW3TAiAQ0uLE3EUzscVAcO8vF02iO/3lcacv26EN+VrTl7NjDEm
         H6LQB3Gj9U/S5LI0y7f0Ifa6sLATU2lJTzRb4ko606WbAIJcr5u8CuygZpZIY4DvTOyX
         LPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A7w55O8G0c2nEPrllsuJvvxVEkxf0Le9RP1UeeVl+XQ=;
        b=qGJkpG/K85KnC/uMmcBix4LfVvJ8tVm8lptvwsZsWfnnQr9cnF44Kn+WcWV79BUBnH
         8EtjPNrw35HIzCrmh2nQNEkdUTnK/jgBpkprBKXjNhprKNKtS/YSuDA2XUn2bCQmiDj3
         UcmjZmJQ+T/hTzfI2c7cr0FPfT9Bzn3RkMJSFQ+kaLpOFATDhE2XEBuneAlD4b/ko7i5
         sgyfbiqpX/0hkwyO5S+ZyQw67n8JFMahgDWY0w2m9BsQj66kfQcKU5u+p4QWPN4i1A3v
         HWQaV+o8Fg2ToouzxCjgXL9Q2gBrSTicAePwZXuqmQgX4u2ldGn1NDvDp1iajzJGIw/d
         BXIA==
X-Gm-Message-State: AOAM5330a3NxXDFYdYCRyGR8pOzA1a8lQqV3b+kFQFDX7eoJ/R7RxIqw
        2aYo6T4EdXpgLKJx0S6Fttw=
X-Google-Smtp-Source: ABdhPJwyQFdsPgh2Od8lbRneNddogCSAAv8JbVJ2fXf0Z4QusEW9fUmZpa/Gn+19PaksjDkUJlDmWA==
X-Received: by 2002:a17:902:e791:b0:151:dbbd:aeae with SMTP id cp17-20020a170902e79100b00151dbbdaeaemr1262586plb.171.1647456816980;
        Wed, 16 Mar 2022 11:53:36 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:500::1:57b3])
        by smtp.gmail.com with ESMTPSA id u126-20020a637984000000b0038147b4f53esm3052558pgc.93.2022.03.16.11.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 11:53:36 -0700 (PDT)
Date:   Wed, 16 Mar 2022 11:53:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv3 bpf-next 03/13] bpf: Add multi kprobe link
Message-ID: <20220316185333.ytyh5irdftjcklk6@ast-mbp.dhcp.thefacebook.com>
References: <20220316122419.933957-1-jolsa@kernel.org>
 <20220316122419.933957-4-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316122419.933957-4-jolsa@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 01:24:09PM +0100, Jiri Olsa wrote:
> +static int
> +kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
> +			   struct pt_regs *regs)
> +{
> +	int err;
> +
> +	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
> +		err = 0;
> +		goto out;
> +	}

That's a heavy hammer.
It's ok-ish for now, but would be good to switch to
__this_cpu_inc_return(*(prog->active)) at some point.
The way fentry/fexit progs do.
