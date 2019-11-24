Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E145108244
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 06:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKXF50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 00:57:26 -0500
Received: from mail-io1-f44.google.com ([209.85.166.44]:46921 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfKXF5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 00:57:25 -0500
Received: by mail-io1-f44.google.com with SMTP id i11so12502248iol.13;
        Sat, 23 Nov 2019 21:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=3+vlty8/08uaWS4FhoPCgushhQu6Kd3MCZ+ZkHoFt5M=;
        b=SpL2zl18TJhwhgZGnw/IIrcDSfSLTVi7ASMPgNbFcB+N9yx1FvQMA9VS/Z+jSCw3J6
         Ki/312shRgbk5qq3ed3Vrymh1pikUIFFtU0AiuxI8clp/PU7cq1a02BGdRPOZRerz0q2
         +ODWaf6IVo6gAi8LTS8lniuXEreLz9/oBtjK5iHJf/n0aRS0lhqcGBuaIryFX/U80A88
         2qCk3dNvJP+uSSWeyFJvTVi0/nDX7siMALZviC7ASpE1KzOsjj9NvgrBC7HmcxP37v6H
         XeokbgKokmj0pqL4jIG9uHXh30Osz894IuITl3rkCqO6BRUWb4Qba9qtk4ll7t+GY29V
         XE3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=3+vlty8/08uaWS4FhoPCgushhQu6Kd3MCZ+ZkHoFt5M=;
        b=Awglw6mml2rTmrKJzI/uHdcHr5moz45eTtKBgKU+EQkHuxcJWZ6BcGWET8f52GxQUR
         PlgaJRz7YTJ+asddgGIpNnqCRkQ+O6bQc9k3i+9+gmuxq8oAvGbPN5E2Jliw0phF9mej
         ksWCUm1MBJGGFSHJGqcKHIRaSlbs3pCWT45fMGZ21N5bcqfuEYJUcvs/VtGmDHVHKu6A
         dUuAx5GX1vA50zz4l0MoNuDpzFTwYtOicvh3tChTOTF647xqCgBUk8R1Lhg0nM1E3Kz3
         YIt5H0u/sBfsCe8wjv6XeOzvTC27a1VF5D4NjlTLDzTnwTEMyGldIu2kuQ+dexoKMmFy
         geJA==
X-Gm-Message-State: APjAAAW1v1Xi/Y8x6BMLm089K+4RitP8nzEiU/G5Drk3l4OrphCIOQS0
        aESeACJ2p6j4TE4vkK407YQ=
X-Google-Smtp-Source: APXvYqy5QXgatZKGY3U3bURjpPEvO8OxWNIVoaR2Uy31u2aW7kumWP66oIwwotT1+l5aMEXfjmup4g==
X-Received: by 2002:a6b:ed0e:: with SMTP id n14mr20279497iog.127.1574575045103;
        Sat, 23 Nov 2019 21:57:25 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x8sm787092iol.15.2019.11.23.21.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 21:57:24 -0800 (PST)
Date:   Sat, 23 Nov 2019 21:57:17 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5dda1bbd8b624_62c72ad877f985c4d7@john-XPS-13-9370.notmuch>
In-Reply-To: <20191123110751.6729-6-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-6-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 5/8] bpf: Allow selecting reuseport socket from a
 SOCKMAP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> SOCKMAP now supports storing references to listening sockets. Nothing keeps
> us from using it as an array of sockets to select from in SK_REUSEPORT
> programs.
> 
> Whitelist the map type with the BPF helper for selecting socket. However,
> impose a restriction that the selected socket needs to be a listening TCP
> socket or a bound UDP socket (connected or not).
> 
> The only other map type that works with the BPF reuseport helper,
> REUSEPORT_SOCKARRAY, has a corresponding check in its update operation
> handler.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
