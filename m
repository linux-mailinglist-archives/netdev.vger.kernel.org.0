Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C1B393C30
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 06:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhE1EEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 00:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhE1EEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 00:04:00 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E64C061574;
        Thu, 27 May 2021 21:02:18 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id e17so2804725iol.7;
        Thu, 27 May 2021 21:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9pwhly6q5ZumRNpL3GxnmH4TutYYMNAzY7m8N5WWejA=;
        b=ZaOt5+ok0g90boHGMn6mH1YmavKOJwsgHuwxLRizyv75Ix40KL+hOVYnKec36nK7Te
         aKLbtw5RLxs+Sd21bQUxK8sffdNGG/k/eNr+mg+0ejbRv+QOZKwXwyQaJdGL0QEXJ+42
         Z6zY4YB/IfK/Y+eLp3HMewl1D7hHvFdS1P5bmGlk/Io/oqIP2gTmbJbvDxiMxbg4EGbm
         S3an9AE0rup9PJ2tHrpmD0HoG0vYOmzYjNW+sMKjJpqjVM7pIaG3Ban/pW4j4raMGL8H
         2U46WBKwrZWWWYCt9+JXNYodzNHYtYiaRREZ/wJ+cCUvOPF15zvv3eXurEDh/deLNmh3
         nIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9pwhly6q5ZumRNpL3GxnmH4TutYYMNAzY7m8N5WWejA=;
        b=eZXtNxCrUkJ3PIxSZWeNacmv3/wsX2uIzj3zKyJphTRfGZXyxZU8kCS7vakrH4Ia5s
         1Jda8eL6hILJJtjrrKOunpHwZhbMNIVLAa4VXiTk8BI1rex/cS9zfaUU23sb/zkgQ8Dr
         x5vvJdBJ5gjSXfS6OEKXOKdAoVwYq1EMl0gPoPms6DckOkV/HXClJ82W5qag7egSWh4Q
         XI6aKbpgAL4wWXJhj3LI7VX2y+K7zz4GDX5GRLhF3HAgNPDKP7Kam6YkycLZKu20opHD
         g3Lv4ryM663JGbWHEehWPkkaYT3Qv+N3bPNz4Z1CPaLWAL+rIdYYoOzpyHyYgD8r0cKt
         yzvw==
X-Gm-Message-State: AOAM53324qQUAktqGgNVLdBRYfuJzzUoIJoZaWdY+wJf+ZfLEdblFMJV
        fW9zNDmukTB09TfeAXZeP7k=
X-Google-Smtp-Source: ABdhPJyxhCni0eONjL6jIZBvMHqVS0nNNua+Y/o3Uju3rEA/TfTiLthm+/+T6kHCDy6p+TVyv61faQ==
X-Received: by 2002:a6b:ec0b:: with SMTP id c11mr5338053ioh.99.1622174537982;
        Thu, 27 May 2021 21:02:17 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id u7sm2102714iof.41.2021.05.27.21.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 21:02:17 -0700 (PDT)
Date:   Thu, 27 May 2021 21:02:07 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <60b06b3f6176_1cf820868@john-XPS-13-9370.notmuch>
In-Reply-To: <20210528024356.24333-1-liuhangbin@gmail.com>
References: <20210528024356.24333-1-liuhangbin@gmail.com>
Subject: RE: [PATCH bpf-next] bpf/devmap: remove drops variable from
 bq_xmit_all()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> As Colin pointed out, the first drops assignment after declaration will
> be overwritten by the second drops assignment before using, which makes
> it useless.
> 
> Since the drops variable will be used only once. Just remove it and
> use "cnt - sent" in trace_xdp_devmap_xmit()
> 
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Fixes: cb261b594b41 ("bpf: Run devmap xdp_prog on flush instead of bulk enqueue")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  kernel/bpf/devmap.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 

Thanks

Acked-by: John Fastabend <john.fastabend@gmail.com>
