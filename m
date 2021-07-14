Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DE13C7A93
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 02:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbhGNAbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 20:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbhGNAbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 20:31:40 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7666FC0613DD;
        Tue, 13 Jul 2021 17:28:49 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e13so25072358ilc.1;
        Tue, 13 Jul 2021 17:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=QWbZes5QbFd0MwfWv9N6qIvmhMsKWpBoX63AfMSiYPs=;
        b=K4EW5ZFmrq+THr266sv9kfxWEt4BBOfHSbvrb2M3DjrWIi8K8Xg2ObamL6EqEJPFu6
         3q/XUIQqA2Uc/D5GYN/WDeC1Y1ZYDu9yBJ5GzO3OCvKR2vhlH8zAjawBkqtNo1D7lP2I
         veBH58H/vjUFCAW2zvXBwzcgzmS+hIhYUjveU8EWKD+Uoel1G0VABZhf8zm5EaK6mdLX
         ZKuEeWuFzhLSEOnz01DWU0OOWf3EaLspDW+3I0MizqzLI5bjIB/nEgodOpYpvQU13Acq
         Qt4llpp581yHfMeQ9XuSrN0YFjWcpJbhua1Ohj1nuluPkH48GIry9bqru8mAhiM0mT9h
         7r1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=QWbZes5QbFd0MwfWv9N6qIvmhMsKWpBoX63AfMSiYPs=;
        b=N8lVJh8jkRJeIs2MiIpAfMMgxkBlZvfCn0pjcFQFa1pbOwscdlvYzqP3HfB9zZPy4T
         bUZGCSdehDbOCTnomaJSiNOEy85pNxr26tzJM9LGl1XodDl9CGLvVs4vOOQEdz3s7VBZ
         oJTLuH4fM/Klg186TPQeKawHc14Wca1orhtutRr88wZR02Du423WGKeF5eSRp/CjgxEt
         xVElqW2hy1NynF5QCnIq869avGITabJgTmUQDZ2kewkDfFLsNWf2dqWNTRYLTudzLeRL
         nm0/QpWCrcuc8E3X7D34mkUcZPO4f70ID2sGfmbQXQ7YIqJSY0Tn1frJIfOT8agWIXB9
         vohQ==
X-Gm-Message-State: AOAM532+J40gFGuWd3yoNQq5n2xQKO1ETtysIQyWt87JbBIkTdgPj8Vk
        LMw+L2FzAKH0w8dCX7BJQ7w=
X-Google-Smtp-Source: ABdhPJyXU4CJal/owQcRW57+aurpX5bIbC0upZFs+kQULAlTPE3ARtssi3wWfD5mX1r9MRiFMRxcGQ==
X-Received: by 2002:a92:8e03:: with SMTP id c3mr5024475ild.167.1626222528967;
        Tue, 13 Jul 2021 17:28:48 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id l11sm253079ios.8.2021.07.13.17.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 17:28:47 -0700 (PDT)
Date:   Tue, 13 Jul 2021 17:28:42 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <60ee2fba31b05_196e22082a@john-XPS-13-9370.notmuch>
In-Reply-To: <20210713074401.475209-1-jakub@cloudflare.com>
References: <20210713074401.475209-1-jakub@cloudflare.com>
Subject: RE: [PATCH bpf] bpf, sockmap, udp: sk_prot needs inuse_idx set for
 proc stats
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
> We currently do not set this correctly from sockmap side. The result is
> reading sock stats '/proc/net/sockstat' gives incorrect values. The
> socket counter is incremented correctly, but because we don't set the
> counter correctly when we replace sk_prot we may omit the decrement.
> 
> To get the correct inuse_idx value move the core_initcall that initializes
> the udp proto handlers to late_initcall. This way it is initialized after
> UDP has the chance to assign the inuse_idx value from the register protocol
> handler.
> 
> Fixes: 5e21bb4e8125 ("bpf, test: fix NULL pointer dereference on invalid expected_attach_type")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
> 
> Missing bit from John's fix [1].
> 
> [1] https://lore.kernel.org/bpf/20210712195546.423990-1-john.fastabend@gmail.com/T/#mba9e0b6aa8dd0c01d7421a084c62ec93c9eea764
> 

Yep. Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
