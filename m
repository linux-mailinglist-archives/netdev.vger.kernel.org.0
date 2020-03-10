Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B547180B07
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgCJWAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:00:50 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35728 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCJWAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:00:50 -0400
Received: by mail-pl1-f194.google.com with SMTP id g6so79213plt.2;
        Tue, 10 Mar 2020 15:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Ajqcsyyjo9Nu5o9/ld/JF2Oi7jupD5+flWV0QzEfiQw=;
        b=cObZ80srtLkhcHp4rJar8SidBKfjS4nEh3obKVnOrXHfOw3/a99Ko6KzViUIi0RKWj
         +M+JC//Qnu0WKlg+b33KxBzHQaFcX0bi4ctHenyZ4Cem9k9LHIXG9LKqx5cAO5zsSjl6
         5jqaLYUBRY7G7xzred+udqDBUS2PSOEuV1+XAsMsxhzPejcE4SywqfYf+vxqea7oHL6m
         9Ui0crtd3gWeVc7pwyqEa0bok1P20cXd1He+dqvJdgv41pMLfTfaF92SYVRjxzIOZQgK
         DQoPDIryry/cM/g+CojuPwAMdg0m/3wIUrFWVDzJG132b7jwrmKQ5jt4SuePcf9H6FUy
         +cQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Ajqcsyyjo9Nu5o9/ld/JF2Oi7jupD5+flWV0QzEfiQw=;
        b=JhxKHXi00N3YoME/glwFk/JmED8WnHBYLmNXUtia2f2mB0dHTEmAeYuScU9YsqpXqA
         TK+D+mEFaflnTpHa1NPXs1EpsfeN6Vs2nrSf0sM56RF1G0CQs680YIW8W2rp2UKuyilY
         HbX1Y1U4usJBLd5foChIkgqjjK/kBHuvmTA6obSw9AoFnCj2Hi8X0lnbGCmlXieR1y1d
         XbYUZUcARNFt7YbI6c59yc+8Byvg3CTMFTvtj0Lihk1vppCEXTBlq9H9tYcrFKwsOqEK
         L+5YJ+o56I5XirJcyikfplRN/FTwPB/EV2i+kOj/N+FhvOv2rfsBkggcOq9NQzvOER9W
         5p5A==
X-Gm-Message-State: ANhLgQ33XMyr/zBMKiHq/HIK6/+NYsec+8ylsQL01oz78HyX3vTBAcRH
        VaRF9ZDuxJKU2n7/bj+ASSQ=
X-Google-Smtp-Source: ADFU+vvsfgNFKJx9vPTpUiP9R8YpQ01vzx8WuvcVDVSseRHrtqYBTIotuo4dXVKTXAtOaWxSV1uitA==
X-Received: by 2002:a17:902:8303:: with SMTP id bd3mr28189plb.171.1583877648097;
        Tue, 10 Mar 2020 15:00:48 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o19sm3763311pjr.2.2020.03.10.15.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 15:00:47 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:00:37 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     quentin@isovalent.com, kernel-team@fb.com, ast@kernel.org,
        daniel@iogearbox.net, arnaldo.melo@gmail.com, jolsa@kernel.org,
        Song Liu <songliubraving@fb.com>
Message-ID: <5e680e05a8667_74702b1610cf25b4b4@john-XPS-13-9370.notmuch>
In-Reply-To: <20200310183624.441788-1-songliubraving@fb.com>
References: <20200310183624.441788-1-songliubraving@fb.com>
Subject: RE: [PATCH bpf-next 0/2] Fixes for bpftool-prog-profile
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Liu wrote:
> 1. Fix build for older clang;
> 2. Fix skeleton's dependency on libbpf.
> 
> Song Liu (2):
>   bpftool: only build bpftool-prog-profile with clang >= v11
>   bpftool: skeleton should depend on libbpf
> 
>  tools/bpf/bpftool/Makefile | 15 ++++++++++++---
>  tools/bpf/bpftool/prog.c   |  2 ++
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> --
> 2.17.1

Maybe instead of "Please recompile" -> "Please build" sounds a bit better
to me but that is probably a matter of preference and doesn't matter much.

Anyways for the series,

Acked-by: John Fastabend <john.fastabend@gmail.com>
