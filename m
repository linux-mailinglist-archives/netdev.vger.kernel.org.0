Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1AD2EB404
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbhAEURc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729621AbhAEURc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 15:17:32 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F71C061574;
        Tue,  5 Jan 2021 12:16:51 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id b26so1369599lff.9;
        Tue, 05 Jan 2021 12:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kv7FRyLpxDsePZtMhWTC8aZgVd2dSF51s0I3oh8t9/Y=;
        b=UHxPVwGDu9Ur4uFAgEkxbDuwKk3z0F/XUBrGzykI3s3/WyEVAo91eTrnKqFiU/AFP+
         rNKVUeLpW+Jnt5eMQbBpzFeSJ0FSsPfWwUm+wZwszZKN4SgHWGMEAEPm7/AH3XVyNQHT
         LX2R620bQp/xqZp3r8/f9eYLe14gzP8zLOKGdEVDJ7KGhC8Ews8mkuy2FIcU7G2DF0BQ
         R/ONADrVyabJaS0JHfbKowdGq9izj6foBkEHYT7Xczc9p5YRkUcNW+wy6xFkeEfZgenB
         sJuymMk9m4kbUAzFrNfsnS+I0216f8U8Q9w0/jJ4TWEpEClmnMpcolidrJUwzIybKOSU
         tsHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kv7FRyLpxDsePZtMhWTC8aZgVd2dSF51s0I3oh8t9/Y=;
        b=N0QkAEy7HXPDFq1DRrJ5wzQ9edoI4Y3TqJyqXVSZ5j6wt7uHC8aMsg+01gedXwBpi/
         hTfMqeTd4tthqgJ2gyQep4syqEjd73srk3NcC5ZQz1uENSW1JeDrjTOEryTz0MbRGTVg
         g70zqw6VdeV6T7IO6R7ow/kGIqwFCfcvw2uzd1QDZkr2CPb7Ass1fVt5UjCxCMIU8q9+
         QROD+kYuyj6Pz8TdDsudwFmImt4tZ2lk/4rRo0jh4XCAysUWoUTJJgWWFa3CpjCOcV/G
         FluOFG6Oaqm4hmpdFQhS8nXh9ua0gBqHpkbI8iMbb/5LKFd1/iKR4j8wJKERU8idlv4S
         Gemg==
X-Gm-Message-State: AOAM530I0czxtGjYBhKAILCt6fYWK/vFedPBFzGC3xM2SpxoLmnUoDEm
        H3RCQb8IFA3+95yQb1yJjdLPLGLuYx9FURAGjPU=
X-Google-Smtp-Source: ABdhPJypI7RuJrGSPiHcEpDlzI9cUoY5s6jJufq+Xe1vSHq1hJC71Kq94OqP0/SXLdgge3nRFb+h68QTw4lGWcwb4lk=
X-Received: by 2002:a2e:9792:: with SMTP id y18mr614730lji.204.1609877810058;
 Tue, 05 Jan 2021 12:16:50 -0800 (PST)
MIME-Version: 1.0
References: <20210105080027.36692-1-linxichen.01@bytedance.com>
In-Reply-To: <20210105080027.36692-1-linxichen.01@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 5 Jan 2021 12:16:38 -0800
Message-ID: <CAADnVQ+i6YaUxy7KcBwKWycQ8dK2Z3vBeFSuJdaa90aphCSkfg@mail.gmail.com>
Subject: Re: [PATCH] bpf: Add signature checking for BPF programs
To:     Xichen Lin <linxichen.01@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 12:00 AM Xichen Lin <linxichen.01@bytedance.com> wrote:
>
> From: Xichen Lin <linxichen.01@bytedance.com>
>
> Check the signature of a BPF program against the same set of keys for
> module signature checking.
>
> Currently the format of a signed BPF program is similar to that of
> a signed kernel module, composed of BPF bytecode, signature,
> module_signature structure and a magic string, in order, aligned to
> struct sock_filter.

Commit log talks about 'what' and gives no insight into 'why' the
patch was sent.
Please take time to clearly explain the motivation for the changes.
Also please see earlier discussions on the subject and Arnaldo's preso
from plumbers.
