Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41DF38D747
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 21:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhEVToF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 15:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhEVToA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 15:44:00 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09028C0613ED;
        Sat, 22 May 2021 12:42:26 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c17so17522443pfn.6;
        Sat, 22 May 2021 12:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w2LkGXw1co1uLC2e7opfK/LAoCn1kUKAliH5vlwy4Ck=;
        b=RRkxrcjr4PIDq5GFjgvVpv5LdWrp0PU6jzKd82xY2y1shGFHBpR3Q2MQxq392Yde6I
         ICg+m8r21Uo+cLr2eECC6D9vPfuRgtu/o1wtfmNmjMNUo4LF/3nWyn/VrysTroCKMDeC
         M7V/vf8S+Kb0aIRU5664ryPVAVnxwO1NXCo9/wL//rUXEJvcC8anui5oliLTgs4arEHZ
         +jKN/bH3GpcH6T1EKOTGbqqGjMssp4BUrrn6Y/lOtGj9k027KBS0kzMEbAolCqCnZQc6
         le+WTDdskIlGXX124Csy/crHyRq/vllw1ecRZkHmyfewvznFLnDmbJk4RxmiDnEw2F1V
         WxXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w2LkGXw1co1uLC2e7opfK/LAoCn1kUKAliH5vlwy4Ck=;
        b=UPtq6p6q8cTH42/vYP3F1X2kS3oNGqBrdZqJuG19ul/H9StF6sa2HIruHVoHVNbtj3
         dYBfTBaAjLkj45DY8h1jAvQ4ITmas3Cf7QdjOV6DwTgKm8GN7bxbXSBK98rSL3sP/eRx
         e+VXJTWtOODkO7WWybjMP5Qd9VD1k800jXGA/pK7cvblUDCN4mDKKBx1uFUX+UOaKpjy
         aWXEU8abNXsFN5q8ZjkF7VPk9mAS3EjVY7jUhjl4u6f2pMLefT7wSd7h9gHqb0FsoY+C
         enQs7l5gEFwzJyXCYnxp1OrkyIL3TJ/LsQQ6HIjf4x9XPZ732HgY7lBbFOLjp3uZJDL4
         r8tg==
X-Gm-Message-State: AOAM533GtkLVyLV6ukYNX8kRaLNYuG4ciMtb/O0biBXchjtUmk/YWZAy
        ZyvXl0Vs3N+vc/3O50hcl24=
X-Google-Smtp-Source: ABdhPJyKAj8Hcx+DP4nKVV1/FfWaVGT++MZzcpUUfKcx7wZZFX8CScbpGJsfsW1r7jyndTYcfEvJ5w==
X-Received: by 2002:a63:5c01:: with SMTP id q1mr5527630pgb.447.1621712545430;
        Sat, 22 May 2021 12:42:25 -0700 (PDT)
Received: from Journey.localdomain ([223.226.180.251])
        by smtp.gmail.com with ESMTPSA id 21sm6939398pfh.103.2021.05.22.12.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 12:42:25 -0700 (PDT)
Date:   Sun, 23 May 2021 01:12:18 +0530
From:   Hritik Vijay <hritikxx8@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: BPF: failed module verification on linux-next
Message-ID: <YKlemjCagqtru8i0@Journey.localdomain>
References: <20210519141936.GV8544@kitsune.suse.cz>
 <CAEf4BzZuU2TYMapSy7s3=D8iYtVw_N+=hh2ZMGG9w6N0G1HvbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZuU2TYMapSy7s3=D8iYtVw_N+=hh2ZMGG9w6N0G1HvbA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:31:18PM -0700, Andrii Nakryiko wrote:
> It took me a while to reliably bisect this, but it clearly points to
> this commit:
> 
> e481fac7d80b ("mm/page_alloc: convert per-cpu list protection to local_lock")
> 
> One commit before it, 676535512684 ("mm/page_alloc: split per cpu page
> lists and zone stats -fix"), works just fine.

Thank you for pointing this out. I'm facing the same issue.
I've posted my logs in the following thread
https://lore.kernel.org/linux-next/52f77a79-5042-eca7-f80e-657ac1c515de@infradead.org/T/#t

Hrtk
