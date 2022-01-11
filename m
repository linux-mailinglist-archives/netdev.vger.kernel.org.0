Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F036148A691
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 04:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244508AbiAKDnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 22:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbiAKDnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 22:43:07 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A22C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 19:43:06 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id k15so61666333edk.13
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 19:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TdvrBmP0mPwKb4JWkekj6mSFKKSyk8//kkI9lvd2Cu8=;
        b=NszoFqoF81m1sZRZHjugOzR1aCLA5CWi62KmxDm340AjUvZ1aFYiTySVSXVJLy6Z4i
         suBPg6ue2xbHsThfyWZ5DsSGU9Fq1IaUsIV+5zYIULmhvPq6JJX0qXMQU8EIGhMKIldI
         ZybpvkgNZDMgrEtmNL0QNYIHHXs+pS7x8Gp+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TdvrBmP0mPwKb4JWkekj6mSFKKSyk8//kkI9lvd2Cu8=;
        b=M6EYTdfTmUVGlYTsfp0CANKN6fUiMCdPn5CyQ8Hq2gGQccYtHsB2BkrP8qDeXjDHtU
         Ps+WbX2m7Krofv9sS4GaoLegeZ8nxJAjqW0/p1S5S2YUBqZDB+yghNJ58hvmdacERCYH
         szKxfKv/sdRXbAt+Gx/5D74l21vuwbUlSfBrF9k+5OPO1RMh7NC68F5QbU3u+hXC/x5I
         GwbyE8cbFvbaL4yTuGt/Md1ehiJ8er/rpPILghGTtPUdfuJIq+LXdqYWmIgeV5MgLzHc
         6j1RHmM9jwQSi7Z6dWwyHnIa6J7x5REPqPVH1m2TqSVxf3UeAcm45aSORaMg2Fok8Gc2
         JX2g==
X-Gm-Message-State: AOAM530ASccLq8qOxiKvkwfu5MYRQsARF/QnAAmVDAqiZVItoYOwnWLd
        0T2lW0jV/ajWhHFieqaHInGwFExcWtZFceSrHEE=
X-Google-Smtp-Source: ABdhPJwZ7eVHyinzgw1ON3W0uNSDayzHzZ7RjYK2qxhQgLSz3Hl591ewwYza74hvRCsNo7/aK5iE7w==
X-Received: by 2002:a17:907:7b8e:: with SMTP id ne14mr2071902ejc.259.1641872585317;
        Mon, 10 Jan 2022 19:43:05 -0800 (PST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id 5sm3068827eji.104.2022.01.10.19.43.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 19:43:04 -0800 (PST)
Received: by mail-wr1-f45.google.com with SMTP id l25so19613716wrb.13
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 19:43:04 -0800 (PST)
X-Received: by 2002:adf:f54e:: with SMTP id j14mr2004530wrp.442.1641872584012;
 Mon, 10 Jan 2022 19:43:04 -0800 (PST)
MIME-Version: 1.0
References: <20220110025203.2545903-1-kuba@kernel.org> <CAHk-=wg-pW=bRuRUvhGmm0DgqZ45A0KaH85V5KkVoxGKX170Xg@mail.gmail.com>
In-Reply-To: <CAHk-=wg-pW=bRuRUvhGmm0DgqZ45A0KaH85V5KkVoxGKX170Xg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Jan 2022 19:42:47 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiTN_hOyQ1_3DPgYJ_oBhwN+e29jrsj8qjqKsodRZ6r1Q@mail.gmail.com>
Message-ID: <CAHk-=wiTN_hOyQ1_3DPgYJ_oBhwN+e29jrsj8qjqKsodRZ6r1Q@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.17
To:     Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 7:31 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Merged. But I now note that this actually triggers an error when
> building with clang:
>
>   net/netfilter/nf_tables_api.c:8278:4: error: variable 'data_size' is
> uninitialized when used here [-Werror,-Wuninitialized]
>                           data_size += sizeof(*prule) + rule->dlen;
>                           ^~~~~~~~~
>
> and I think clang is entirely right.

I pushed out my trivial one-liner fix for this as commit 63045bfd3c8d
("netfilter: nf_tables: don't use 'data_size' uninitialized"). The
build error kept my clang builds from working, so waiting for any
alternate fix wasn't going to happen.

              Linus
