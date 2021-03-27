Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CC134B3FE
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 04:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhC0DUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 23:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhC0DTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 23:19:46 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1104C0613AA;
        Fri, 26 Mar 2021 20:19:46 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id w10so1525152pgh.5;
        Fri, 26 Mar 2021 20:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=phYyD2kbNy4Z00klgX9xZbzhEqyMK+s+XM5+auF5Y0o=;
        b=T0IDrPHXwj0MW5ePgzYIZymJW8Yi3gr3oCH/kjVpdNyTzShNcXW/Vh1jUDNUpD6z2a
         YoCrg2WrRwI2u8FTPiAeixdhjLGEzY597p6eq6Ahg90ZWYMWXbmOrMjsKf3HtXu3CoS4
         Hg+dG+oLKJor/HndCZ8vfAioFrJvXsWPs7s2A3ncCJdXd6Vw/DckI1+xPf/CAFcFA9zc
         sXPPqtfHVbO1V1sUwUcnj4tobUjbfG++4edpnCfvwriavR/vViEJPVLafzJ4rRziXXQZ
         ZlzLil8kHrrGOBGlMI1uBlaSGmFx2g4yc9Ka52LdNwmI4gMgYe6VEg7BR+ZTFYQD3YHX
         EoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=phYyD2kbNy4Z00klgX9xZbzhEqyMK+s+XM5+auF5Y0o=;
        b=MV2GYjkKKnGzv9feqTpiA4ZTz1J30gQ0V9cuFG37rvzqxq7g3svHjQvx8/uCpXlAxM
         8dKr01I8w9aTg42iSIDSN80o1zWkPmWFM1XeAvnoDVl1if3vpzNTb5JLaYzhFYFIEy74
         9OxYT6BloYaBySjag4LtL4SCxJzPUTICz9c6PQDrI3JXCnF18PVSwpGe+4CZNRSfeU9N
         /kQrPraLPAU+DNUG3eplQfCc8uqjsAckLryndX4Qszr2xCZtD6XJIVAhWr985f+iU9lP
         J20EXXdf3w9SEO+vDlpjKbvp3HorVwqefbpTEvPKVeEAyjG6SLySd9hYxpXPYCAVCPNV
         y+/Q==
X-Gm-Message-State: AOAM5306/BgZ8vxM63lfdXkqq25oFpVJW9r8wfWbdk60s+WjnQUjyXOm
        o7y/PvLIy8ZLyl/YpvFGSPc=
X-Google-Smtp-Source: ABdhPJy2kLXUaSiYuOJy5WTLzIGc2ZFeONo1QjwiC8Mk6drTpulFJS0P1ioqx0wHlbGLrXugQoa31g==
X-Received: by 2002:aa7:9096:0:b029:1f7:c442:fe37 with SMTP id i22-20020aa790960000b02901f7c442fe37mr15868133pfa.11.1616815185262;
        Fri, 26 Mar 2021 20:19:45 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:15b8])
        by smtp.gmail.com with ESMTPSA id s76sm10674036pfc.110.2021.03.26.20.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 20:19:44 -0700 (PDT)
Date:   Fri, 26 Mar 2021 20:19:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv3 bpf] bpf: Take module reference for trampoline in module
Message-ID: <20210327031942.nieqezfod6p2fcfl@ast-mbp>
References: <20210326105900.151466-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326105900.151466-1-jolsa@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 11:59:00AM +0100, Jiri Olsa wrote:
> Currently module can be unloaded even if there's a trampoline
> register in it. It's easily reproduced by running in parallel:
> 
>   # while :; do ./test_progs -t module_attach; done
>   # while :; do rmmod bpf_testmod; sleep 0.5; done
> 
> Taking the module reference in case the trampoline's ip is
> within the module code. Releasing it when the trampoline's
> ip is unregistered.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  v3 changes:
>    - store module pointer under bpf_trampoline struct

Applied.
