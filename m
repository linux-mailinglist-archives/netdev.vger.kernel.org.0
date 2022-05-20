Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E331752E638
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346415AbiETHYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242746AbiETHYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:24:49 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F63214ACBE;
        Fri, 20 May 2022 00:24:48 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id z3so5553239pgn.4;
        Fri, 20 May 2022 00:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XeafRqcB/dUPhMnvYlhk8N3gK6kHX7tikPF48apxqmw=;
        b=cJ9CJuPHHTubONmMlTRk8f+pyXocuBGlxy7/QoVBvkeelp7nLsvi/2E3QAn80sU9fj
         4+NsAa9yCw5EJsUcLaGnbkELNj4M/LDEaF0eh9sNdGdaFnrl9yUV/qRnf+xr/JHuL66X
         a7S//c7Gqwn7LYFue2cBGcUPCnQNj+nqYBYPA13AGB0JJCnF+ZhmhOr+vA1Gc3m9FJfv
         oOppPDMGp9IXsXgwpZmbopLq6bc/3wyEzAbGJoe8O0NJ2x8dYrfNnCmE/w/dO+aqQLRN
         04faEAXLVzkjgi7ZzoH2hzx9SmLt3TJZGDaGdojTLZUI7pKIuwka6ZaoiQzpOvdNURRZ
         4sAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=XeafRqcB/dUPhMnvYlhk8N3gK6kHX7tikPF48apxqmw=;
        b=TD3iaCnScsw2nm+F2Z7l5ByCV1w8LJE115n5kJ44NwAYx/WCTF83ITbxL72Dftsi90
         TgP/6YrOW85cVSK3xlAONbd2BN4Xa6HsvgMcTLdyQY/9uNAf7FxdQae6Ege6c76eZ3Wa
         H6apXhPxgoKgntSBdFAGNemCLUq++4+iqsFbLj35fqgjsHfTHhDWsxco9DpkQqnJB+jP
         ISZUjI2FPWwbn1QW8sUHeAz/1WhYYfFDVWSH87LjZs15804FMxV1xJiqAuqVrNiEOAqj
         mxeV6hyUrilAOeXPZpBgLD1DCtcluIY8gYTeC6RL9Us9dWo/+stlblXtQFAqxPHVlyWm
         Yl+Q==
X-Gm-Message-State: AOAM531ogXiavwo1FOukdUFAabXCTyHsGzt7IfgGXgmLB9Z98qVmEoMy
        QGUDbIBsjDCZ6eAv91eoifk=
X-Google-Smtp-Source: ABdhPJwkMr+sTWJc8WLzm0jCGLrX1wqE6gCvsUk6ga6zRArMtZVx1hEhLi+KOd5tHcN5g4pNsJtGNQ==
X-Received: by 2002:a63:7d4a:0:b0:398:dad:6963 with SMTP id m10-20020a637d4a000000b003980dad6963mr7342754pgn.329.1653031487396;
        Fri, 20 May 2022 00:24:47 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:1761])
        by smtp.gmail.com with ESMTPSA id nk10-20020a17090b194a00b001df6ccdf3f6sm1062191pjb.47.2022.05.20.00.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 00:24:46 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 19 May 2022 21:24:45 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Message-ID: <YodCPWqZodr7Shnj@slm.duckdns.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520012133.1217211-3-yosryahmed@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 01:21:30AM +0000, Yosry Ahmed wrote:
> Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
> tracing programs. bpf programs that make use of rstat can use these
> functions to inform rstat when they update stats for a cgroup, and when
> they need to flush the stats.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Do patch 1 and 2 need to be separate? Also, can you explain and comment why
it's __weak?

Thanks.

-- 
tejun
