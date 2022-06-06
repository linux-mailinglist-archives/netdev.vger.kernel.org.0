Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360F353ED53
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiFFR41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 13:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiFFR4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 13:56:25 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDB92F9AD9;
        Mon,  6 Jun 2022 10:56:24 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k16so20871600wrg.7;
        Mon, 06 Jun 2022 10:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nmpgefx9CrakDYJ0DI/wt/hXfm3ZGhdmY3ih8CZrWIs=;
        b=XQK9xgPnFBRkFvPm8WZ/2MFf8ePoWbUOi7CbGEKLVRDk8ve0qbjt2lfKV3BrYD+5H8
         leOTldL8EjsQfB9waT1Wpoo5Q9yDeOQtFPaYXggg5C96CrxU0OngXZ1iksJwIxbLmYi/
         EAjVIdBVBZsEGOzlkanc8/qfItpcJI74+LiMwm5lK+W/HaJf3MOy8MlzyhkQfVQaMiY+
         EWkS9VXD/3Kj8pWZ++Gpf2EDk3J79694oWvwntLeJRrhcM6aisMQny1MKvnGtn4Rj6ug
         AdI5W0FaQ7dl2uZtFg7q8CUQE2x29DQiX9g10LreUoGJpWX/0NXJwaIrkmhv71cIdG3C
         c9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nmpgefx9CrakDYJ0DI/wt/hXfm3ZGhdmY3ih8CZrWIs=;
        b=CESYZ54oVZIqJOJZdVRl5cUwXGKFmMGcOphF1reISSFdZjDCRb49t/pbVFF/G7c+YD
         EwpzRQmAuof+G27aqCSOeXa/6Pp/FGQ6tklMWDu8XZdrTYgMOUGeR0fSKj+5YiMTnreQ
         R7W8ZWr+Ka7vQVAntZ760pgRSFS8XioCfJlbmgE5tbY6deKLrapBfXUccDw+i5VFDDis
         rig4L8jgMJi9lPpmbPmsy/OEHNooikyXTQz/V9KZ77WFerxxxr+C9o1DXseuuAYP6z4x
         UGUE8vrXD2/QFUcKdStb3W1jfKLGGxouP04q1xKIscQHSntp1ufz+ZaCRFTrUnI58Wnh
         YxuQ==
X-Gm-Message-State: AOAM533k9f//c8DFgg2cTFsIe8R/BEp347oXEDIVDzU7KuVztL8W3MhO
        C8RmOuS2FJ12DP7+NdSxTsI=
X-Google-Smtp-Source: ABdhPJxxdo11AcSvuyyFjM/sjmy+u7KO2UPnf3fIQSmp/nkSrpQVkDAaTqtSQ14WaU28wECHWTLPvw==
X-Received: by 2002:adf:a3d3:0:b0:213:baff:7654 with SMTP id m19-20020adfa3d3000000b00213baff7654mr18123442wrb.158.1654538183170;
        Mon, 06 Jun 2022 10:56:23 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id e40-20020a5d5968000000b00213ba0cab3asm11120694wri.44.2022.06.06.10.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 10:56:22 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 6 Jun 2022 19:56:20 +0200
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH bpf-next 2/3] ftrace: Keep address offset in
 ftrace_lookup_symbols
Message-ID: <Yp4/xPVDN8IrbxG8@krava>
References: <20220527205611.655282-1-jolsa@kernel.org>
 <20220527205611.655282-3-jolsa@kernel.org>
 <20220605125122.7b0e5b52@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605125122.7b0e5b52@rorschach.local.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 05, 2022 at 12:51:22PM -0400, Steven Rostedt wrote:
> On Fri, 27 May 2022 22:56:10 +0200
> Jiri Olsa <jolsa@kernel.org> wrote:
> 
> > @@ -8017,6 +8025,7 @@ int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *a
> >  	struct kallsyms_data args;
> >  	int err;
> >  
> > +	memset(addrs, 0x0, sizeof(*addrs) * cnt);
> 
> Nit, but you don't need the "0x".

ok, will remove

thanks,
jirka

> 
> -- Steve
> 
> >  	args.addrs = addrs;
> >  	args.syms = sorted_syms;
> >  	args.cnt = cnt;
> > -- 
