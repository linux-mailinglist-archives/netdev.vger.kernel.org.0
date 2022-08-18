Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6E2599096
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345556AbiHRWdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238901AbiHRWdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:33:05 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05D4D7D06;
        Thu, 18 Aug 2022 15:33:04 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id jl18so2675911plb.1;
        Thu, 18 Aug 2022 15:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=YHQ4Wh5SK0V1LEg6WvbUjjafnUpUy0D2IL3Ade8VZXw=;
        b=Xa18u0tB7HMzsnmKGxkVoZCzL7kLgnVNbrEM/pnut+g3QuGlZU8T82rRYMT+uH7JX8
         mJ2vZoVMfZ7DeQ3N/hRq0QVoE0dHnDCC6jHkB69qMIcAnfLOTXLgyZGlTOdJ4eKUvXXw
         4flHnx5l6ko15DdAn6q2TkKoxgnP4dUxXLL/EG6Sv5XUar7vSGs83fHEjEds6EMZiGtz
         OUBPUoY96/cACPNVbxTxEcH679zbytL6ggf+FUTfKgSAuhsuxedQglqb7+rqBqR9FhJ4
         LY0s3HpL/nWX/J45KMRDwAi5O0M0gueWwTXP3KDbK6EUtSzFPD5Sdz9+niAgDzYC3gNx
         7x8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=YHQ4Wh5SK0V1LEg6WvbUjjafnUpUy0D2IL3Ade8VZXw=;
        b=QNE35aSTaAusExkMU5Jp/rb7ol+yNF4vIjFvaU1b54dkfnJVWTyGvGhgMOtCTMgmJQ
         XWdYYMc/UIMzUssrPcF/2J2gEYq25YgWCTmjfiPfI+LkLRtueuRIh+WHWYRqSFZ+qAdx
         7Bcjue3RNtMlIKTQb3jmTCfa1KF8Onfj5YA+3eamool8OAAHGT2v0F/tGlv0jkIhiqKa
         BHUdp9qIyCR8+c+MuLObjTyiTlDaO5tBA3600G8yFzCk4gN1hs03/V3cziOQhmzLLfBd
         TOI8jk63V/2Lc6ivgDWHbcNSzNT5jRPp9fCT+CYOjd5HvkBuYN89MYlz6Lwb+cXYD9U8
         l2vA==
X-Gm-Message-State: ACgBeo1xf6rl/MqDcMvPZsHv4GBuyFBN6/PP4/7pQ15J2SzHi6WmttYj
        Kod+4UpnEUy7yverYQld9ok=
X-Google-Smtp-Source: AA6agR6Xhtkg1508+cxIa3H0yo59iUpgPdxMF1/w3fj7YurA36mIAWVBDXjz/rRfFCZPgfR9CMv5Pw==
X-Received: by 2002:a17:903:2310:b0:16e:e0c0:463d with SMTP id d16-20020a170903231000b0016ee0c0463dmr4345769plh.18.1660861984065;
        Thu, 18 Aug 2022 15:33:04 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:3b7])
        by smtp.gmail.com with ESMTPSA id x7-20020aa79a47000000b0052d3a442760sm2094200pfj.161.2022.08.18.15.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 15:33:03 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 18 Aug 2022 12:33:02 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        lizefan.x@bytedance.com, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for
 bpf map
Message-ID: <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
 <Yv67MRQLPreR9GU5@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv67MRQLPreR9GU5@slm.duckdns.org>
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

On Thu, Aug 18, 2022 at 12:20:33PM -1000, Tejun Heo wrote:
> We have the exact same problem for any resources which span multiple
> instances of a service including page cache, tmpfs instances and any other
> thing which can persist longer than procss life time. My current opinion is

To expand a bit more on this point, once we start including page cache and
tmpfs, we now get entangled with memory reclaim which then brings in IO and
not-yet-but-eventually CPU usage. Once you start splitting the tree like
you're suggesting here, all those will break down and now we have to worry
about how to split resource accounting and control for the same entities
across two split branches of the tree, which doesn't really make any sense.

So, we *really* don't wanna paint ourselves into that kind of a corner. This
is a dead-end. Please ditch it.

Thanks.

-- 
tejun
