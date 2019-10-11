Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50BF9D4994
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfJKVA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:00:59 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:40306 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfJKVA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:00:59 -0400
Received: by mail-pf1-f172.google.com with SMTP id x127so6775730pfb.7;
        Fri, 11 Oct 2019 14:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=E/mfuCU/sztKqVVhqazwtOeLB6w8gIt2Pgbu9jl6q2E=;
        b=GIegpNx2FWxEFq/A+IqaZm3Dt+N9Ej1CHnLBgzt58lORWcwfYuvQpJXWGHJ8VOOG0g
         4I3dYPL4EC8TCwIxEH7EJBnwTInDyd489y6eaxv6A22yyRvj+8s5KpWbl1bbksGOhx8O
         kuNU2nzHvCiQjGkfJuOlWfE6qSQeq0JV1dMp03/N3Pl93rb+v5CByeWqqarPcBFjYjpR
         fFhIpiXHm3PYEUkujMNbzcVr0eJcs8ft25OgqlG73Y7SwnJwiJLRHVkULTQaNJ2l3CWY
         xrY0UNsXj7n1EfO0v+6lFLAG+TXpRKT3kwwoMjdskRz/jHn7VYBK6eSj7C9tLLMcfAaw
         vgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=E/mfuCU/sztKqVVhqazwtOeLB6w8gIt2Pgbu9jl6q2E=;
        b=bPJWtg7oQERs4abzT+stfPDMT7b5EEKZ9x6doIzFLFe4zLGqlm2dJ74eT0oqg/PSuG
         nT5TkIjueoAxzZenWRsgwwklyTGvC4zf8xKSDgWZwItR2v5Nd02r/u9nCuWoDeyWNOcq
         uEYWqFtWNvgUG1lAof/R4FCdbIQUUdAjij+a0q2PWmevde/9fTtMP0zhvIrgeu8+cFOk
         CC073qRX4P+3sj5xkW+YzmPl1u8T++E7N17bzPGuj2nEFyPosqOcFyyYKgBew3orfgoN
         y/wFB+3owlxEyfiXfByWHtFlfC0iCIsAdF8coUyqStmMqYhIkyTiGJeydE1QOW4oODrT
         mQ7A==
X-Gm-Message-State: APjAAAUznWJBuvOrM0WFf6BMjoiaSksloKuKcJh9Ia0VkaKdMt9YGXzl
        TbbeqHxaL7kQ1yoD/XEl2Eo=
X-Google-Smtp-Source: APXvYqyzeNOgtWZGLWuH6j9vg3mYHQa+38VG6qMpFK124iv2AXkH/djCsJQ1qoOlub7EIabxXMe7LA==
X-Received: by 2002:aa7:99c7:: with SMTP id v7mr18644154pfi.165.1570827658530;
        Fri, 11 Oct 2019 14:00:58 -0700 (PDT)
Received: from localhost ([131.252.143.44])
        by smtp.gmail.com with ESMTPSA id i1sm11723026pfg.2.2019.10.11.14.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 14:00:58 -0700 (PDT)
Date:   Fri, 11 Oct 2019 14:00:57 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        john.fastabend@gmail.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5da0ed897584a_70f72aad5dc6a5b834@john-XPS-13-9370.notmuch>
In-Reply-To: <20191011032901.452042-1-andriin@fb.com>
References: <20191011032901.452042-1-andriin@fb.com>
Subject: RE: [PATCH bpf-next] libbpf: handle invalid typedef emitted by old
 GCC
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Old GCC versions are producing invalid typedef for __gnuc_va_list
> pointing to void. Special-case this and emit valid:
> 
> typedef __builtin_va_list __gnuc_va_list;
> 
> Reported-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
