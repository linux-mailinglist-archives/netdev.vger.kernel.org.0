Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAF62CCDF4
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgLCEhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgLCEhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:37:11 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5A8C061A4D;
        Wed,  2 Dec 2020 20:36:31 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id h3so887923oie.8;
        Wed, 02 Dec 2020 20:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=IjZ0M5xmOsM2BICruObOoDRJLz28Zom2iKuoFoNJ0XI=;
        b=pVIksf5Ywcn9mqrX/jt2f6RpzOIhf5MHrle30HFejE++rRqq4suRLCwCZrMtubYIWU
         IO9b6eEB+xl5uxePTbEEEw6qvTQh4OBR2WF2kKEnCaxrBJ3v0lh1F0obTwTzKmRpLQB7
         9iMNILyUeHTQgvDT8BcgzZtZj4iho99Dv15EZDnt8BoxB9BEJbuLRhTbnlyPVehSUQOb
         0HDo3PhECWLWz3zQBCxq7a4xrMT/Dm9QDP19JHbRUuhwBtInKUgE2XNm8+6XYsaPbXrp
         5t1eZdHyA3AuCxYObaOcTLoYj4vicXOR/+GAvFE+k52drwqEUdRQMiVP/gDHqhU+Qm6s
         MkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=IjZ0M5xmOsM2BICruObOoDRJLz28Zom2iKuoFoNJ0XI=;
        b=Pfovbaf+NbFUiKeejhodGbzN86o1O8lgzCZ9u65ucuylbNQTnVaOX1Vtm+h5snF2un
         1grgv+sxrMEB8uNRqwBu4UfVR6VjyIcz0qQPq1VYCvOpYbMOthJJaZzkbqoZN7JRAbiS
         c31L09GsmPCEpBfpjrAUoh3GT0VWoSK76NN915L0QVroyUsUZbRgoShA7EY0Jrww7rEQ
         7Ryj9d9LHhyOzuql8DDFqdoSY7+Ry5oSTQCXlCD7bc2E7u5Hhhltd8a9IHjATOr6ilbt
         TELLqEWUFV58WMtQ/sB/BIDMjrPRVJZ/vB20GWoWGC1puDpTQZFXjLPCVWY1fVpQeNKg
         my/g==
X-Gm-Message-State: AOAM531wjt5x+sfl/rHQAP+b12NTJTE5AfaUV6aEAe1fv9YSzHUhs93r
        DlHYP3SbSQ+5j3BwDU7H+gg4uCz+UMU=
X-Google-Smtp-Source: ABdhPJzNb+lIrgzYvn81meZhYoiFlr4qxd0aZA8gWfNbSQZqFD7XSPz4wUkbicEb0YfbI934yGWJgQ==
X-Received: by 2002:aca:d586:: with SMTP id m128mr766421oig.73.1606970190629;
        Wed, 02 Dec 2020 20:36:30 -0800 (PST)
Received: from localhost ([184.21.204.5])
        by smtp.gmail.com with ESMTPSA id j126sm68920oib.13.2020.12.02.20.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 20:36:29 -0800 (PST)
Date:   Wed, 02 Dec 2020 20:36:19 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii@kernel.org, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5fc86b43b2006_1123e2084c@john-XPS-13-9370.notmuch>
In-Reply-To: <20201203035204.1411380-2-andrii@kernel.org>
References: <20201203035204.1411380-1-andrii@kernel.org>
 <20201203035204.1411380-2-andrii@kernel.org>
Subject: RE: [PATCH v5 bpf-next 01/14] bpf: fix bpf_put_raw_tracepoint()'s use
 of __module_address()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> __module_address() needs to be called with preemption disabled or with
> module_mutex taken. preempt_disable() is enough for read-only uses, which is
> what this fix does. Also, module_put() does internal check for NULL, so drop
> it as well.
> 
> Fixes: a38d1107f937 ("bpf: support raw tracepoints in modules")
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
