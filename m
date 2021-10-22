Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAE54379F4
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbhJVPdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 11:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbhJVPdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 11:33:36 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DED0C061764;
        Fri, 22 Oct 2021 08:31:19 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id j6so4441025ila.1;
        Fri, 22 Oct 2021 08:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=+Ego1ZrG/Lm7+Pvcc9hjkB+81oiSDXMAJi4vz0qrb0c=;
        b=nVr/tUjK9tm2H9KcK/tPnGrfR7naUAf65YcUkEYf25XOwwQnJufPcN9cKMba4tSAQY
         19mw63sYOt9m/Gmy+XMwoU4wjqxKDSe8H3yVz8mxjMv0FuGQ+Qwwy68nk3K9JFDgpSNO
         /QV1xvST3koD8wjWrbNKSlYxmb94cOSpoNXnAS2kZ23mKG2EJ0PsT8U7y3IyXvyyFr/T
         Pg5bmxRMFvnUAQJdim6dwdYnf4QPunJeQPD750dlOZEimZfsZyImHp9CY7QIJ4QXdLG7
         B0mM+qUHScKtJSuM2PILdBcR141M7utTAYUOZV5YF9TTVYaoZFuvghyA1YyDlwPBHoBU
         IBow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=+Ego1ZrG/Lm7+Pvcc9hjkB+81oiSDXMAJi4vz0qrb0c=;
        b=3uoryBejlOWAIMnYv7cx8xK7VIjBaIwjMJY5H/tVxBRkiDKuyek2uFbfxAv3dyaO4s
         SpCYWBfesDh6wFtOSYz7di0cRlxhi3KUso3PQ9rogO6hvdVdGY5rDBc3Ze0WgVu5sH5p
         9cfu8t4HKp5K6UuKJPJ0Jg2VnWrUGFefITo6AO4krKzMtDV3X/6IXJc8S9bjPWMDTXi9
         wxsugcoesXfqj/99RMsPm/MzLl2HqlGGta7lDw1aRXy6I0THCimkQG4q4aZDuNKIIxVK
         awbTjuKrjq2mMiaC2trQTAh2UvuAZDKLeNOqAklk13ASzSnYFKJweMjIhTKOPA2a1gxB
         hPeg==
X-Gm-Message-State: AOAM532iknvDu67liqvSa2s4ZEfC1EaDnM4tJTksr/vK1mVpy0zNUJ0E
        Ni8OdPCXBD+4A7N/KpBCNlo=
X-Google-Smtp-Source: ABdhPJw0Ay4k7KXUPfIZFm0OnzfvobmrKd7GvT/ti3wApXtJJOBit9UZUPVxSJBt85q+o6Oh0RcyTg==
X-Received: by 2002:a92:cd89:: with SMTP id r9mr430524ilb.261.1634916678482;
        Fri, 22 Oct 2021 08:31:18 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id i15sm4214561ilb.30.2021.10.22.08.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 08:31:18 -0700 (PDT)
Date:   Fri, 22 Oct 2021 08:31:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        xiyou.wangcong@gmail.com
Cc:     liujian56@huawei.com
Message-ID: <6172d93e2a470_82a7f2083@john-XPS-13-9370.notmuch>
In-Reply-To: <20211012065705.224643-3-liujian56@huawei.com>
References: <20211012065705.224643-1-liujian56@huawei.com>
 <20211012065705.224643-3-liujian56@huawei.com>
Subject: RE: [PATHC bpf v5 3/3] selftests, bpf: Add one test for sockmap with
 strparser
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Jian wrote:
> Add the test to check sockmap with strparser is working well.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>  tools/testing/selftests/bpf/test_sockmap.c | 33 ++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 3 deletions(-)

Hi Liu,

This is a good test, but we should also add one with a parser returning
a value that is not skb->len. This doesn't cover the case fixed in
patch 1/3 correct? For that we would need to modify the BPF prog
itself as well sockmap_parse_prog.c.

For this patch though,

Acked-by: John Fastabend <john.fastabend@gmail.com>

Then one more patch is all we need something to break up the skb from
the parser. We really need the test because its not something we
can easily test otherwise and I don't have any use cases that do this
so wouldn't catch it.

Thanks!
John
