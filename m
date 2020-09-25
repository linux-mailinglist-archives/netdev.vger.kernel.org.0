Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712B62789B5
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgIYNgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbgIYNgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:36:41 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D5FC0613CE;
        Fri, 25 Sep 2020 06:36:41 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id c2so2287701otp.7;
        Fri, 25 Sep 2020 06:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9sSnx/FI/X81F6OrV7I/7UTJtfmSwle78q00CsHhTYg=;
        b=XX7FyifFomzFFi/WDtoovS9GYqxM8gW6q3NJG1xM3gyVkhcrik/QJlEpCvWqHajKul
         CeHPMCxR3FExBTZpI280PFZLFLoivUmS2UWz/qh/ie/AmDFqJ+9AZhZiUhF6OMiW4VHz
         /DgFJzbYzoPjcNKNJt2RAIZgZ6uBoGYChVwk66DBGTmZDchAA7m59m2Vr5y/Yk9dywpX
         k6G8lRfQS3/9eFV31VNu2VwphLvAK84rWTGpRt2arjWEdK6IZVtKJJOL+ERrnPDXVe+d
         3qXG8P4xvC54KECzkeTk6K3zaSNFpT83aVcZWLtZrmowslKmYtSPjEngdHRjw5H+TNiP
         d0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9sSnx/FI/X81F6OrV7I/7UTJtfmSwle78q00CsHhTYg=;
        b=LG2/BZc+vwM72JcoGfWX4LFvhO7I4LXoYpb7dVKaCQ/nt88QgVLb0B9gJqcqgQVi0Q
         7TJwYM3T+QWf9T85IUT8f/0nF+raMLeOsxxyRmnJAIx/xw58LTsXU6xBeUX7BOXku/ma
         G1Ij4qsbXCvrYrWhTR8eBg+W7VWzxAA8/otjbEZLCs+cQ4afzqScRwo4IgvmqYAJqErs
         CGJxL6gJiV31awUBmbN2yjpS9Se4gvhxq63nAyGfutGUCWw+GBVYvmc654x6etH9jmT9
         slPxXPuOT2268M/zfiTG5aISGkoYLEZMIOX8JjoJGTLsOgvfY4ghKu8Vwl6tWdYKyO4x
         XJ/Q==
X-Gm-Message-State: AOAM531JziEsmmveNb7+d1hRHi1fHB8hJ+3Svjc4kxKWfF8e+5WKib5R
        Zl20GItGhofum9irWJH0lFiqTyEor6oNWQ==
X-Google-Smtp-Source: ABdhPJwi541n38M8tyYs4ji9upHYRiA5IkdPEsX6a75LMOuMNgrwwNSeiHDbrmEFeUdViBDL5H9sQQ==
X-Received: by 2002:a9d:be4:: with SMTP id 91mr330785oth.248.1601041001009;
        Fri, 25 Sep 2020 06:36:41 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k51sm631926otc.46.2020.09.25.06.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 06:36:39 -0700 (PDT)
Date:   Fri, 25 Sep 2020 06:36:31 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org
Message-ID: <5f6df25f4265_835ea20842@john-XPS-13-9370.notmuch>
In-Reply-To: <20200925000344.3854828-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
 <20200925000344.3854828-1-kafai@fb.com>
Subject: RE: [PATCH v4 bpf-next 01/13] bpf: Move the PTR_TO_BTF_ID check to
 check_reg_type()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> check_reg_type() checks whether a reg can be used as an arg of a
> func_proto.  For PTR_TO_BTF_ID, the check is actually not
> completely done until the reg->btf_id is pointing to a
> kernel struct that is acceptable by the func_proto.
> 
> Thus, this patch moves the btf_id check into check_reg_type().
> "arg_type" and "arg_btf_id" are passed to check_reg_type() instead of
> "compatible".  The compatible_reg_types[] usage is localized in
> check_reg_type() now.
> 
> The "if (!btf_id) verbose(...); " is also removed since it won't happen.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
