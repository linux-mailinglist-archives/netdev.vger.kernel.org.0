Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADD828AE0B
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 08:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgJLGEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 02:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgJLGEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 02:04:10 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A80C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 23:04:06 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u24so13278708pgi.1
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 23:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QmNLyMQ0LtT31cF2Zk5ewjnptaqyHigRfY4+vGVup+I=;
        b=zpaGJsSMZ5YqpwzIyDb0cMMMXARMuglQir3HKg3wlyQVgJ7wTQ54zQMLv/YISqeHFX
         Z6IV7DwrEY0loB4Qm7L9tsRUI6h2G3tSYcz+M9N02cREPE9KduUQ+5skV23inFgK5PY9
         OcHKEY+jCvC32+8pNnvp8buRlVaM/YaxAptna7DWyMCPvVceHE1+3p/l8FGrhww/EbYz
         3td18JFCfeRIpqhZk5JzhNKaCFpaEEholcldPejzZzNlsKip0jspqy35cWojFxSBdAq6
         N5peoX2B0dFjZwmj1GDWVw3JClS3cLeBM62krU+6IN/H7bgnFUQM0yNsCiMMvTBJfbPe
         66PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QmNLyMQ0LtT31cF2Zk5ewjnptaqyHigRfY4+vGVup+I=;
        b=RHU/wze4dUJTHDG2tynV1OfEvJ241sJv1CfK6s6obf1NNTToOm2Zmk8cNP2p59zFNF
         lSKgv47hPi3swkMWYQtJSmRYN/ErclbMaV41SYjK26rQltOc+J8cu9bETVooeG3udFY6
         g+sZDVZed6hVe2iGjIns4vBDl1DhdMjYRDrBBN5YQhZKdS1iL8plCjDh1+Wt2vIeWjfs
         h4ZJJDSkckQl1h40xYkQ5OntqHUmUATk4Ibct+5fQcSC0x8vmTlQavLrTjvkLm6bFyBP
         uVwJSzv+Zfs/OxWAp2kEtqv5JW/aBwNOOK6awRPRohlGPwtHBsY8LoZbUe0msbc71Pfe
         wZ/Q==
X-Gm-Message-State: AOAM531SlaPiQXrjDtbAFEIjXOt0u80dJjv6TV5znlqyVZNW5dhdqgVR
        V/k37iG+dJjNl0Mm7mofFR84fg==
X-Google-Smtp-Source: ABdhPJzoxP2ZpJnIbQBzBFmCD2ZdacHdAPW2fSu2LNnyNgbgTUKx0F2bg36PcdxTchq8sfmYziuyEg==
X-Received: by 2002:a05:6a00:15d2:b029:152:9990:e003 with SMTP id o18-20020a056a0015d2b02901529990e003mr21626259pfu.27.1602482645601;
        Sun, 11 Oct 2020 23:04:05 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s13sm17822420pgo.56.2020.10.11.23.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 23:04:05 -0700 (PDT)
Date:   Sun, 11 Oct 2020 23:03:57 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     sharpd@nvidia.com, dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] lib: ignore invalid mounts in cg_init_map
Message-ID: <20201011230357.198aaa5e@hermes.local>
In-Reply-To: <20201008175927.47130-1-zeil@yandex-team.ru>
References: <20201008175927.47130-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 20:59:27 +0300
Dmitry Yakunin <zeil@yandex-team.ru> wrote:

> In case of bad entries in /proc/mounts just skip cgroup cache initialization.
> Cgroups in output will be shown as "unreachable:cgroup_id".
> 
> Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Reported-by: Donald Sharp <sharpd@nvidia.com>

Applied with one suggestion.
This code has no comments so it is not obvious exactly what it is doing.
Some explanations would help the next person.
