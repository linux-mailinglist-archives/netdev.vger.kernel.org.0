Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C363053756A
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiE3HbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 03:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiE3HbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 03:31:12 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E798C712F4;
        Mon, 30 May 2022 00:31:10 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id y13so19124925eje.2;
        Mon, 30 May 2022 00:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3pLlM4nZRwPGSNDDtlA2OaqAYKbM+n8ZLJpr5f+E5kk=;
        b=R50tngTFMkq4TTfzThEoZTQWOAbQrBw+O92IxiSlHNTHTE/JeHjgnOow4B1d+JedFt
         bNk1Ouc9Oj9xSsX1ZCbtZ++/aePRd2A9/VZq/vCOR3ZHV+5IwH5gujbspu8YuCBFoj+3
         6dY9CvN0GlJRlebTfM5ohAPcWyx+cQ5JadSjgH5mOTVpzF9pae4Azja3zNBEG4cByIPS
         N+PMR4z43uuGH42XS+eayBjxbSnXIfKerLXM0FI9l7KD9m0N0/t1FOxPOxu3+RkL6jv8
         2nq65xIKoS3JVNK0Qa4T6tZOXypdZSX7L4zBKdLaiQU2rfCn4SIhsdBAmoc+gdAqRQ5W
         X1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3pLlM4nZRwPGSNDDtlA2OaqAYKbM+n8ZLJpr5f+E5kk=;
        b=4fPS505qHLSBuMwXhLq3Jnt6Nk/L6OaafXmEiqdPIXaAud4lLN/dUgwA3feljHSZQb
         /JZspotovh9iETLcSj53ZIskU+w/VoVpi72Y5cAJ/X4kAn4YU0mkmkD3zPehL+ulilHb
         un8gtTOovQiYFTIIKSY+L+QwCOkCD0BMEJeyzxg68X/YfH2k6JxV1dI32dta3xVBN515
         xKponX3esgdmrd+030VuBOzRBkxTflGSlM6DTW2OeqI5xkXPCHgrXTgz99nROA9NT/Tv
         3yEbeWkVUxL0DNziK4NBPBPPT7HCLWc86X2dgPL+M1mC1vJTGTIf2p8OooraiVci8dAb
         KmVw==
X-Gm-Message-State: AOAM530lpYTa6zZTRb7VYJwfS2xY4ebyyyf6n0IllmgR2oHdMyhZLqM+
        BBEg2ksf6CM6zv+wpOqAopY=
X-Google-Smtp-Source: ABdhPJzMu27m6f08Z4wzem+y8cF358ZUzA1L3vwDMa1NXQTrFkXkj7rhdBQnpilKWSKp8yjL0HV3Vw==
X-Received: by 2002:a17:906:5d08:b0:6ff:8ed:db63 with SMTP id g8-20020a1709065d0800b006ff08eddb63mr24269552ejt.408.1653895869424;
        Mon, 30 May 2022 00:31:09 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id p7-20020a170907910700b006fec27575f1sm3713020ejq.123.2022.05.30.00.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 00:31:08 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 30 May 2022 09:31:06 +0200
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH bpf-next 2/3] ftrace: Keep address offset in
 ftrace_lookup_symbols
Message-ID: <YpRyul/1ZIbwkIYw@krava>
References: <20220527205611.655282-1-jolsa@kernel.org>
 <20220527205611.655282-3-jolsa@kernel.org>
 <6D832064-C22F-46F6-8663-A516E1D02C63@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6D832064-C22F-46F6-8663-A516E1D02C63@fb.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 05:37:49AM +0000, Song Liu wrote:
> 
> 
> > On May 27, 2022, at 1:56 PM, Jiri Olsa <jolsa@kernel.org> wrote:
> > 
> > We want to store the resolved address on the same index as
> > the symbol string, because that's the user (bpf kprobe link)
> > code assumption.
> > 
> > Also making sure we don't store duplicates that might be
> > present in kallsyms.
> > 
> > Fixes: bed0d9a50dac ("ftrace: Add ftrace_lookup_symbols function")
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> BTW, I guess this set should apply to bpf tree? 
> 

ah right, I checked and it still applies on bpf/master,
please let me know if I need to resend without 'bpf-next'

thanks,
jirka
