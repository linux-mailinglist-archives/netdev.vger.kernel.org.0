Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E7E234EA0
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgGaXfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgGaXfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:35:37 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754D7C06174A;
        Fri, 31 Jul 2020 16:35:37 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id r12so26689442ilh.4;
        Fri, 31 Jul 2020 16:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=zWEs+JePKRLzUDDzdElyULSFvi/NmgpVr01uNx767mI=;
        b=Rb54TDQLur52tc2GoC5Flon7M+/elox4mroFWy5LQXSzNT9JYN2dbpWXIc2U2y65T9
         nW9DsiCh/g0RwvzFjPDH7H+4KHQO2p9yWf7LHPZnICKlUzXHQVCcTCASYOoU3Xnx6FAW
         /aoAtw+76aiMD1ssKDsDN7vy0lfTiQDKP/Q7h15TYmJBC+lgWbEjGcW6ULLyN9weiNc9
         8Fyy2S9GvRolrkEFgz1Q7MdOk3JyPbxoqkh7hecnivn8/SnzBJ4bg1jpNeY5RXN6aSS9
         sphfHwaedTzVt77nlrczLQINicgF4A/MP0RTK9cB96dWpCIO7EwPyb8e7ZzKwrVHg79S
         OPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=zWEs+JePKRLzUDDzdElyULSFvi/NmgpVr01uNx767mI=;
        b=IjdvIZ9IFer+DLHquIqdu+9GVIjybPqZ9ERF6EjW0rM3p8+fW4TUqHikg8gKSYvRiG
         AEXEzr0to8YN71/4Cj46rM8B1e6DKAGr6F8AqAmh7QCvoiXaPYNs382O6iSPya9l9Vci
         1Tw7oTUA87m6EVSFWMcLhEZvfG0/lOkNJYZyN9YeszJ38ErqHcbqC/gtu40yDLvct/Px
         bx7SdpYRF+QvPufS66A/VWneBUuiDXoMvg3E/HqqznzcTPyGj+tZU2/s7KVe7KMeX0+0
         Wom6qUjmTB7Dml9vllJXIJxlIzI48RpQaHVHYda+l2WwMx/Fbm39kcG2RNN7BN9EnyBM
         tVMQ==
X-Gm-Message-State: AOAM532KMs6DmkSB8uRLt8dV46cRMLTHPxwbjDaMQ9uVCG7mKVWDETcK
        zq2MU6a77vxzNs+hz/dnL6NU6OglPJE=
X-Google-Smtp-Source: ABdhPJzV0T9XTjJzY/IODtHGN7KV1LNa/cQxU8FN6lVYhQtn8oM/k534swYYCZNyNqQkN5ZBcL8aug==
X-Received: by 2002:a92:5e9c:: with SMTP id f28mr6465274ilg.167.1596238536970;
        Fri, 31 Jul 2020 16:35:36 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w7sm5800586iov.1.2020.07.31.16.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 16:35:36 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:35:28 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Message-ID: <5f24aac0aa084_54fa2b1d9fe285b483@john-XPS-13-9370.notmuch>
In-Reply-To: <20200731182830.286260-6-andriin@fb.com>
References: <20200731182830.286260-1-andriin@fb.com>
 <20200731182830.286260-6-andriin@fb.com>
Subject: RE: [PATCH v2 bpf-next 5/5] tools/bpftool: add documentation and
 bash-completion for `link detach`
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add info on link detach sub-command to man page. Add detach to bash-completion
> as well.
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com.
