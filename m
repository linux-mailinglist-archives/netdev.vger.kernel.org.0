Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C523116DC
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 00:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhBEXRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 18:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbhBEK5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 05:57:32 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C72EC061797
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 02:53:19 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id v15so7145529ljk.13
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 02:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=2AY0VjV9ml5fXmjzc4EJ9Mkfak5UWnHEv1BMDM5PloI=;
        b=j1WP0ltfvS/xSuWwfvXeQ60+vJwsiwFmjtG688V86gkAzE/WG2WnFBDfLJcOj9NBw8
         exKwNKQ7ov13TMqiebfAvGffNUZrF9FmvRsngSrrcI2ZFD+8sCQ22mUmQIUfcZko9sHP
         DlgypH6SXX5HSBy7yHl43w1fA7eQAfLkdHqms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=2AY0VjV9ml5fXmjzc4EJ9Mkfak5UWnHEv1BMDM5PloI=;
        b=dKWhaprgU9ymLBz9vE0JtV7VskrhNMNGNy6BTFqUQvkTGv425YjP31uYu8eHIfyKXU
         ndZuiVOydVpMurZGAu2y+9pzG/7opx2kbHJhOZ8i0dDqjKb9E5Z/smAnlPZwY4YDc02e
         TJCwg/ARQb9r7XNtTXyp6HScEBehLLuXvxnpOLE+SJRSZzDrg5xofrA2FjP60pxj5/ej
         Js1EFqy9Y/bRkRl8Tc5twafuftjg2kxNbay5bt45HNxxRt8vPjxxfkfPI8gYBW6QAGkW
         8KWNpDZU79qAhGGRDjEvFC2EP0E5cqEMIxCjdrImasvXYBzotSbMKlx8b7SlLDH/FOf2
         KaaA==
X-Gm-Message-State: AOAM531uDDkVZafghSTwxVsvuOX6bKd7e3Bf/qnbqZIj8mBw+Hh7Laus
        07Q9nYcMJmYQjl8XvIf9kWSdWoVHV+KWY9Fy
X-Google-Smtp-Source: ABdhPJyf7a3IprDYHXjBYYUxVMvuM+D+eNwsHexaOuZh94UBQkdwXP7c1t2Zh3ILDZy9mfYucCiU3g==
X-Received: by 2002:a2e:9ed1:: with SMTP id h17mr2248180ljk.160.1612522397629;
        Fri, 05 Feb 2021 02:53:17 -0800 (PST)
Received: from cloudflare.com (83.24.202.200.ipv4.supernova.orange.pl. [83.24.202.200])
        by smtp.gmail.com with ESMTPSA id j5sm950077lfr.173.2021.02.05.02.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 02:53:16 -0800 (PST)
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-19-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next 18/19] selftests/bpf: add test cases for unix
 and udp sockmap
In-reply-to: <20210203041636.38555-19-xiyou.wangcong@gmail.com>
Date:   Fri, 05 Feb 2021 11:53:15 +0100
Message-ID: <87h7mq4wh0.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 05:16 AM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> Add two test cases to ensure redirection between two
> AF_UNIX sockets or two UDP sockets work.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

If you extract a helper for creating a pair of connected sockets that:

 1) delegates to socketpair() for AF_UNIX,
 2) emulates socketpair() for INET/DGRAM,

then tests for INET and UNIX datagram sockets could share code.

[...]
