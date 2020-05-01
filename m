Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198291C1D3F
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 20:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730162AbgEASdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 14:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729721AbgEASdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 14:33:17 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D43C061A0C;
        Fri,  1 May 2020 11:33:15 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x2so5232866ilp.13;
        Fri, 01 May 2020 11:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=P+eY4pIsN0XU4I/R8qcJHEKy6dUT/7CH7jPQNb6aQ6U=;
        b=oltjcl7EmCyoseXDpiG+jduR63O2CdyMC/umZvfAczDoLfQossyGdejBQ3ojNyISmd
         PCI7je6u1CLviqn7a9ObGxUZdSFWZGwyZ9fY9aTB5w3pLU8j0S//Tw0Y0GPAecPx2/7U
         vEnmse3I9hEngR071ZaMWKdn5NLz3xNKacHsDkBvEcLwxSWRS9DRpNKvgigOk7cSY7KY
         A8w4LFkoYOCMLla/VGohVyFE6f12XS9B/fBaeq80/PGZ5DnvK2AMYYluqbWLvLJjJU37
         cgQ9+VNSaLrHjvFxc6w2JaOFRpqOTPf06TAU7hh1cCK/szdLlfavSRgF7ECe6ZOJImdg
         LbZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=P+eY4pIsN0XU4I/R8qcJHEKy6dUT/7CH7jPQNb6aQ6U=;
        b=N7fCYqYz3jQcCrknm6eoqLkf/PoaIf1lb3saZQ71y2vszIVsu70Gu5yMt5tilSWbku
         x3S7bn4ciDduMr5Tg4iYhTUDPLKwq6bpRN0NTQSEETt3QRTLYs2Ry7pYOaI+i/+IFm2N
         p54sEcsiJDYMY9ltUb048B6YDtJ4XpU4VqxhiTui5L0MSzN9bFYWDcWPSYb1mmQSGSbR
         s3s0CWXRFWA/gGc2jlr6JS4Bk6cnmk/dVzsJAOPDeLTO3chsyCrXeN1TM5Ej99ez6KtW
         Kqk0vqZ4HX6BeV8ase+leNt/mw/ZMNP1jwHFv5eml3fgjY7bPxRLXjSBrQoyzj2wrezL
         JsnA==
X-Gm-Message-State: AGi0PubkTQI+PL9Wc5xeVxNkPS36HtzDkyxCEqAPqPwjWgXqXBzp8nJJ
        IrAEkGwMPsjoct+ef6fqQBGtfstiwLA=
X-Google-Smtp-Source: APiQypLr68FOy7qy73XZctc5vtf8owOGWRFDy/liaLGNdnUJdQ7sziBa0seTO/Cw3Jan6NfqTEFWiQ==
X-Received: by 2002:a92:405:: with SMTP id 5mr1756353ile.279.1588357995400;
        Fri, 01 May 2020 11:33:15 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n26sm1155134ioa.44.2020.05.01.11.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 11:33:14 -0700 (PDT)
Date:   Fri, 01 May 2020 11:33:06 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5eac6b6252755_2dd52ac42ee805b8c9@john-XPS-13-9370.notmuch>
In-Reply-To: <20200430233152.199403-1-sdf@google.com>
References: <20200430233152.199403-1-sdf@google.com>
Subject: RE: [PATCH bpf-next v3] bpf: bpf_{g,s}etsockopt for struct
 bpf_sock_addr
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev wrote:
> Currently, bpf_getsockopt and bpf_setsockopt helpers operate on the
> 'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
> Let's generalize them and make them available for 'struct bpf_sock_addr'.
> That way, in the future, we can allow those helpers in more places.
> 
> As an example, let's expose those 'struct bpf_sock_addr' based helpers to
> BPF_CGROUP_INET{4,6}_CONNECT hooks. That way we can override CC before the
> connection is made.
> 
> v3:
> * Expose custom helpers for bpf_sock_addr context instead of doing
>   generic bpf_sock argument (as suggested by Daniel). Even with
>   try_socket_lock that doesn't sleep we have a problem where context sk
>   is already locked and socket lock is non-nestable.
> 
> v2:
> * s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

To bad we had to fall back to ctx here.

Acked-by: John Fastabend <john.fastabend@gmail.com>
