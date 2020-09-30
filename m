Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0E827DD35
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgI3ADd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgI3ADc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 20:03:32 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71F9C061755;
        Tue, 29 Sep 2020 17:03:32 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ml18so64740pjb.2;
        Tue, 29 Sep 2020 17:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6VV4XvvcQY9QI0uDJbto5ZuOCrNjEiRaNyBUS/1iof4=;
        b=bWLArrpRVoAGRUEKVOmGOLElbbUAjgGfaYetVburVkj4El5RPw6JcrLWK/tQP0QkMz
         vRHa9LEg6QaGofOFHX4IK5CwNsIRuyeXNB/Y7jahMCsEEFJvBMy8XccQdiD4uZDzA0vp
         AdYJ0mdJ0PHYrX6i9ZP/CTS4y6Kl96ss6h9V9I3RM4clRBZM2rWnylzWX+3wTDP4PCyg
         F4cfUoqKzh4rp72WkQPv7AKjkhZjYeAp9iJTV/B9hSwwiNowc3y5R9FEjHGajbO06IUV
         M2zCDIuQoQ7uzfDsT2A/z24i8yD0AWyFOjW51torvWJnfCK5ummsm8vSV6l35M3Q+eLk
         qlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6VV4XvvcQY9QI0uDJbto5ZuOCrNjEiRaNyBUS/1iof4=;
        b=pvoUOO2Lcwkn9384B5aUsitPN3Z8/v1zgJU23SFv347LMNAXIydPEbWYxQHjbKavIl
         WUxxgD0hPLzaY+JCD2D5ragiQCvSems22kpdrLYFVNLIb1Me4G72Wavg5oARDjBBJFVz
         TwKUBgJ6D06/YLFLOtj0T4kKUlB25zKJEb7Tyu88NXoJq9JSSrU58D84+8l3cliQ4GgP
         DSTWzlMQa+KUG0XmyGOWZBAhrtitOutZ/y9yRjMqLMTLg2uwBVen5OjZKtjgCTm1bOqV
         4678B7ddpoakcxoYGJBH2LzuvlsDTRGu/2PCS4LChMMroBKhnS6u9wxgRjgwBVbjIX9K
         S0WQ==
X-Gm-Message-State: AOAM5303Ru/76M1upgONb9NhZYCqM9FK/AoSHZsXJRo4eWYwfWkBwS8l
        nhHRH2OjFJGg7/MLSakgQHo=
X-Google-Smtp-Source: ABdhPJxcewihY+nv/4o6xqAt7k/p4+r0lbDU5Crgg4MHr+T2QhqosL9ZBP+CowQjTe/MmuW4J9gpSw==
X-Received: by 2002:a17:90b:164e:: with SMTP id il14mr40420pjb.5.1601424212122;
        Tue, 29 Sep 2020 17:03:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:d27])
        by smtp.gmail.com with ESMTPSA id z28sm6653893pfq.81.2020.09.29.17.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 17:03:31 -0700 (PDT)
Date:   Tue, 29 Sep 2020 17:03:29 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/4] libbpf: add raw BTF type dumping
Message-ID: <20200930000329.bfcrg6qqvmbmlawk@ast-mbp.dhcp.thefacebook.com>
References: <20200929232843.1249318-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929232843.1249318-1-andriin@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 04:28:39PM -0700, Andrii Nakryiko wrote:
> Add btf_dump__dump_type_raw() API that emits human-readable low-level BTF type
> information, same as bpftool output. bpftool is not switched to this API
> because bpftool still needs to perform all the same BTF type processing logic
> to do JSON output, so benefits are pretty much zero.

If the only existing user cannot actually use such api it speaks heavily
against adding such api to libbpf. Comparing strings in tests is nice, but
could be done with C output just as well.
