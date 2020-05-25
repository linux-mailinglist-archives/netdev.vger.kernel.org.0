Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B241E17F6
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387745AbgEYW6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEYW6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 18:58:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A525C061A0E;
        Mon, 25 May 2020 15:58:11 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q9so421652pjm.2;
        Mon, 25 May 2020 15:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=IniJC2Di+vQAsbW2GoTt2IMpLewAzkRSmpn+NzU1Xjo=;
        b=NPAqgZPGhEsrg/Dn7N0vV300FwqcfONiL4U06a7Itu5PgPogaEZd1MiN8TT6uytPKp
         1x/cfeo2UWZLM/xofblVsSdsdqOBnhb0z3FXJgtX09oPEHJHsgP+G24YET8xgctAJ4aF
         Dyfjkd1N08K3bFlURxtj+me2ADj5xKvmmfoY7eeF0VOUPmAH1zA1AE3akREG+JKMrykb
         L9zfVxI+DR3VMDZe5mZ+4Fh12qIc0sy0KeLXBWElpOPBPOEKsLlmO5QoCbA/5ASH/C8U
         msaf6FjAGHMgIs/h4UXAkBP3CDcNGZ8M8BtuGmcnO3VD0rp80wXLT1LcRYfVPeXI3F8X
         aPPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=IniJC2Di+vQAsbW2GoTt2IMpLewAzkRSmpn+NzU1Xjo=;
        b=nS0CNj9jKZMM6G41gs96IvWsQ3n+ctcjW3AxrmLNt9P+uVgmA1oq0OFihBsJu3fvt4
         tavoYi+i3RU/ppd60TPIIRsRZs7R6W721EBkn1esEYGsTg4FZmLb7oAPQVutF69jjoQd
         KLL0hDJMRvZTNFgHy9CQjlu+pj3zZyE8BcTjFM0KP6f6feM1L65NLjK+k7ufNK34Efge
         /dL65b77bA3gSinZRUxTcoRKjz3rf1ixv31I5xHyrL8wskOx6RCgdJ8ZOVnrnvVrB1WC
         8M3Blkw3wP//7/eKodwa72IV2yN/GLGbO5pNIR0cXXBAw6ddvreXUldkq0Duuo7EEpRv
         L92A==
X-Gm-Message-State: AOAM531twaPuP0jDQ2O/+dAM6xiN/4WVcahZbhp1CodRmjqIzvbXSbGF
        tEkzaI2zurKWy1A24mzPsAo=
X-Google-Smtp-Source: ABdhPJxpKzwImK8whMMSPSc1uq/tj40+g3iAvUDO1l1EE7JPJ0Eb1X6pm5tP/d8nhQmUZabIJYywog==
X-Received: by 2002:a17:90a:3ad1:: with SMTP id b75mr23493690pjc.216.1590447490633;
        Mon, 25 May 2020 15:58:10 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q201sm13681895pfq.40.2020.05.25.15.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 15:58:10 -0700 (PDT)
Date:   Mon, 25 May 2020 15:58:01 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, yhs@fb.com,
        andrii.nakryiko@gmail.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5ecc4d799cc25_718d2b15b962e5b8b1@john-XPS-13-9370.notmuch>
In-Reply-To: <3503d44d-799f-5440-781a-3c4cd2d89282@iogearbox.net>
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
 <159033905529.12355.4368381069655254932.stgit@john-Precision-5820-Tower>
 <3503d44d-799f-5440-781a-3c4cd2d89282@iogearbox.net>
Subject: Re: [bpf-next PATCH v5 2/5] bpf: extend bpf_base_func_proto helpers
 with probe_* and *current_task*
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 5/24/20 6:50 PM, John Fastabend wrote:
> > Often it is useful when applying policy to know something about the
> > task. If the administrator has CAP_SYS_ADMIN rights then they can
> > use kprobe + networking hook and link the two programs together to
> > accomplish this. However, this is a bit clunky and also means we have
> > to call both the network program and kprobe program when we could just
> > use a single program and avoid passing metadata through sk_msg/skb->cb,
> > socket, maps, etc.
> > 
> > To accomplish this add probe_* helpers to bpf_base_func_proto programs
> > guarded by a perfmon_capable() check. New supported helpers are the
> > following,
> > 
> >   BPF_FUNC_get_current_task
> >   BPF_FUNC_current_task_under_cgroup
> 
> Nit: Stale commit message?
> 

Correct, stale commit.

> >   BPF_FUNC_probe_read_user
> >   BPF_FUNC_probe_read_kernel
> >   BPF_FUNC_probe_read_user_str
> >   BPF_FUNC_probe_read_kernel_str
> > 
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > Acked-by: Yonghong Song <yhs@fb.com>
> > ---

[...]
