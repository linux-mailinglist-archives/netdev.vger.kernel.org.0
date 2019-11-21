Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E28105B65
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfKUUzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:55:20 -0500
Received: from mail-io1-f53.google.com ([209.85.166.53]:45499 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUUzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:55:20 -0500
Received: by mail-io1-f53.google.com with SMTP id v17so5096516iol.12;
        Thu, 21 Nov 2019 12:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=quE6d8wQY2Wf7Z8i+OMwLH69hqoHsvF2BVtMi54QAQo=;
        b=t91kEf080NLZaDeCTZQv3xN2gEsKR9HSCUuk7dwY+21wCaDCWBUQ5WozwXJN2DdesI
         yhBVhFKiLo96N2dKYmJmx1thCJMhH2rgwSTyM1YB2NY2izXeVBBgfIORDI4BkCAgjfus
         gHCRc87K7HApHNtZ9afgZi7phdeomUL5sEFAUpGingL5BPszYWTv7XbmP7uJXPkFVIIV
         YrzawkpIjN8G098MPc+CPS5glU88i7rj6KgA/MLzhoGYp/JmO5tksPd8TN5hSYLOAerh
         mLUdF/L+lvg2T8mtJT/Af+kjNWgAH7J+Ki5zxdQp487xxY3PaZDAy9s03WiN2oLpw35I
         2qzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=quE6d8wQY2Wf7Z8i+OMwLH69hqoHsvF2BVtMi54QAQo=;
        b=ijnJMr+oQ6V/PGkrfrQGGnJkmDyelQJYz0TnJKKUFRSK3jYSNbYFwRGgyTvRWtgoZk
         PILywxnIRpeJyMlFCRlnoexJH+/7CC1mEsnKf22oZctwNkStfIgggm3SIqhQ4iF5qX8b
         IQDcVv45QlrZ4WVKeWZbS5oBkyY592ZmlKqVcUZ2aM1t834mOoZgpIniz64f1SpUgdmd
         wMiRgGYsViwrjuoNT0mgzxlnaC+7S3R3IFZI/Cy72VfiXJfJEbezRNUSGDgh6D+mwx2F
         7sJW9YMbeUeRJfL6hzt7uNlHrL+gsCr+/LfJjbZfy2gHK+mCjt4mZGTYCCOOVYQojsHr
         OF2A==
X-Gm-Message-State: APjAAAXGCbasG/JkePaPxscpnz6C8DmT9R3vdiBDM5bqJaPNws+XH2WS
        RUlf1EI2doPS0JW1vzt0HaY=
X-Google-Smtp-Source: APXvYqxT1L8UwWTfF6//0ez18eRp19X35O6xT62BYsVx1AU8hwTLebVlgODDYkUbUvP9t7F0s/0cJQ==
X-Received: by 2002:a5d:9349:: with SMTP id i9mr9605470ioo.163.1574369719617;
        Thu, 21 Nov 2019 12:55:19 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l205sm1718699ill.50.2019.11.21.12.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 12:55:19 -0800 (PST)
Date:   Thu, 21 Nov 2019 12:55:12 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5dd6f9b076bb3_30202ae8b398a5b4ad@john-XPS-13-9370.notmuch>
In-Reply-To: <20191121175900.3486133-1-andriin@fb.com>
References: <20191121175900.3486133-1-andriin@fb.com>
Subject: RE: [PATCH bpf-next] selftests/bpf: ensure core_reloc_kernel is
 reading test_progs's data only
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> test_core_reloc_kernel.c selftest is the only CO-RE test that reads and
> returns for validation calling thread's information (pid, tgid, comm). Thus it
> has to make sure that only test_prog's invocations are honored.
> 
> Fixes: df36e621418b ("selftests/bpf: add CO-RE relocs testing setup")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../selftests/bpf/prog_tests/core_reloc.c        | 16 +++++++++++-----
>  .../selftests/bpf/progs/test_core_reloc_kernel.c |  4 ++++
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 

Looks good.

Acked-by: John Fastabend <john.fastabend@gmail.com>
