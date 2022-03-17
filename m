Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067564DC77B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 14:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiCQN0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 09:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiCQN0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 09:26:01 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BAD13E161;
        Thu, 17 Mar 2022 06:24:44 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r23so6617308edb.0;
        Thu, 17 Mar 2022 06:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gaSGd9eQoWOscF2Q/20m+EaorPy8WzeCdtk04inJ3rA=;
        b=W9a24MTpsg0zXMaA29JyOHEyt2xO6sMlOpaklqzDXUPgJjvSzlG5XHf9tFfuUvdrTi
         w2frTI2BQ1JhooP+uYZheFys/6pPLPwbMd8hI+3EBigLDf+sIm52MNg1jn6QAmTL2K5h
         ALoheM3Rf9tZrjNPnbHPCQeiFJxqHKgi/7DG19QW6DWIRb9Apyyp+Z+nM6hUDK17u3Np
         DGDq1ojDi/nL6m0FReAsT+hE/HQV/oOGSldhFo9oY9cptlQCP9LOyB1hStecs5/VSBrZ
         iG+hn6s2nE6G8M6jLjBzktf5hapgy0XfnvjENtyt3ZDDVc4Mr8YXJHJWDjb82c1Wa3fP
         Du5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gaSGd9eQoWOscF2Q/20m+EaorPy8WzeCdtk04inJ3rA=;
        b=gre5pvgiJjxlhugdxZD2eheI2ec63+nqGF6KJl1+xMfT3BQXhZf3qkVqOBJs5yZ/Wy
         nOQMB1MFS1w4mTy4Fq/8fmqD9RyJX1ovTNSZEQnIR4sU2F5UOycKxV4byEySYjoOsY1L
         y0gYTCGPm1ckar9aYxEpuK5FMcWTF3TSTC2zHY3jdpG4JP3QxD7vZDOtHNO4wcuvwvbW
         wvPCSc26wCo3izB3LiXyE7eTiYjjXIJLZ6+1JZMiafkprA1AFDa+Hc3rz/GgYgPYP6ro
         2kDuuo03CIMpCJPUMuh5mhPqdiVSQ4fWyIF/R1MaAXIULfkp4ntbqVIBfPNDQhyGkH6o
         /5nQ==
X-Gm-Message-State: AOAM533sczpZbFC4ku0xAnWCyT6h8cZ9HnHMJxRaJs7nUMYpn4JE19qk
        pg7ZCPBchJjG6bKeSgdIFs8tK9eLFJ2xuA==
X-Google-Smtp-Source: ABdhPJxQejhP41pxkiGNvrPu1KOyNIHONF70acHrNjRWHT/PcTxEtQOUqQmDntg/ONGha38VRE+Vmw==
X-Received: by 2002:a05:6402:458:b0:418:78a4:ac3f with SMTP id p24-20020a056402045800b0041878a4ac3fmr4454451edw.196.1647523483330;
        Thu, 17 Mar 2022 06:24:43 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id s14-20020aa7cb0e000000b00410bf015567sm2586544edt.92.2022.03.17.06.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 06:24:43 -0700 (PDT)
Date:   Thu, 17 Mar 2022 14:24:40 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <YjM2mCCSTGWJG1K6@krava>
References: <20220316122419.933957-1-jolsa@kernel.org>
 <20220316122419.933957-4-jolsa@kernel.org>
 <20220316185333.ytyh5irdftjcklk6@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316185333.ytyh5irdftjcklk6@ast-mbp.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 11:53:33AM -0700, Alexei Starovoitov wrote:
> On Wed, Mar 16, 2022 at 01:24:09PM +0100, Jiri Olsa wrote:
> > +static int
> > +kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
> > +			   struct pt_regs *regs)
> > +{
> > +	int err;
> > +
> > +	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
> > +		err = 0;
> > +		goto out;
> > +	}
> 
> That's a heavy hammer.
> It's ok-ish for now, but would be good to switch to
> __this_cpu_inc_return(*(prog->active)) at some point.
> The way fentry/fexit progs do.

ok, will check

thanks,
jirka
