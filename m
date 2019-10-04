Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D75CC488
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbfJDVEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:04:41 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33350 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729276AbfJDVEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:04:41 -0400
Received: by mail-qt1-f193.google.com with SMTP id r5so10506355qtd.0
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 14:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rj2svHAXFdfOchRelwBBK0h1arFyU57LbDMlb1pUtJo=;
        b=OL1bb9l5QfYzUzJMX4my5fKK3axGjmvZYxZ6he+GVtTka90O5kjpd19cS3Q0nMKnwO
         VN1EhyJoVe+r5oqZub7LFG1+ZZFc3Fkv5kFh6QgkTfIba5M0lz5zK0FF5XFy1qhX4rvE
         UNClxROPA1aXZ3YWxGRPKK4s0i4oZIz3vWIwGB92v4zOGUDuWsOcLRUgtB2p7+TQ9j1z
         6r98af8WS2uCsSyEje0AjzFgQJy0dVflgdEiNzK5D1rPjk5g1ZHMSiFhFska5fSpimfy
         /ZK/vNsPw01JyWCreqKEawihiIlXmib3A9x+Hdj45TXnAAKbJtIMTmb3f30merM8Dwj3
         QdhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rj2svHAXFdfOchRelwBBK0h1arFyU57LbDMlb1pUtJo=;
        b=kRrS5MamWXgAP12KIoWoTMTRz9xR8XV2C/7BQ7jQA3X3Gc0n4yflqjjhSUddT1d8rj
         3DoBIuv6RRB045AWEXIdOH0rnm9N73A9jc8bkMZYutDgqJqkBcJ9+oIXYfkj6eLKxdLG
         vRWxmWooXtCAUNurYP+WvA3EC35AhQwf3Yt5+dC6GeAb9kKQcRhCGt0vZ9yApFezkIYR
         6ELBHmyHJNcwGmEKGm9b577lt6V359w5KC/RNXXIuU6CO/hH/lxM5aoLMUVBKEwvbyFM
         jmxn1EaQEfdzNR45uFR+3wkoBouGySlWZGqALcuQYdppsm/DGpuv5HSyz9OzFLm7RKNs
         dFUQ==
X-Gm-Message-State: APjAAAWmkSgmcqz64Mn7OnMZ5t86Q1DaSxxNwUzEaCWUFFjs0nCB+n3o
        21ni2BEZjReGfuKvIL9/dp4SkA==
X-Google-Smtp-Source: APXvYqyHNvBOwJUDC+cvgufhu9nqgfWJMtAAJDSwnLKAwb1V578LzrkWdyosGePFZxAgF58UPyNRpg==
X-Received: by 2002:a0c:82a2:: with SMTP id i31mr16216058qva.160.1570223080454;
        Fri, 04 Oct 2019 14:04:40 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h9sm4231952qke.12.2019.10.04.14.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 14:04:40 -0700 (PDT)
Date:   Fri, 4 Oct 2019 14:04:35 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move
 bpf_{helpers,endian,tracing}.h into libbpf
Message-ID: <20191004140435.1b84fc68@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <62b1bc6b-8c8a-b766-6bfc-2fb16017d591@fb.com>
References: <20191003212856.1222735-1-andriin@fb.com>
        <20191003212856.1222735-6-andriin@fb.com>
        <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com>
        <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
        <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com>
        <CAEf4BzZr9cxt=JrGYPUhDTRfbBocM18tFFaP+LiJSCF-g4hs2w@mail.gmail.com>
        <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net>
        <62b1bc6b-8c8a-b766-6bfc-2fb16017d591@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Oct 2019 18:37:44 +0000, Yonghong Song wrote:
> > Having a header which works today, but may not work tomorrow is going
> > to be pretty bad user experience :( No matter how many warnings you put
> > in the source people will get caught off guard by this :(
> > 
> > If you define the current state as "users can use all features of
> > libbpf and nothing should break on libbpf update" (which is in my
> > understanding a goal of the project, we bent over backwards trying
> > to not break things) then adding this header will in fact make things
> > worse. The statement in quotes would no longer be true, no?  
> 
> distro can package bpf/btf uapi headers into libbpf package.
> Users linking with libbpf.a/libbpf.so can use bpf/btf.h with include
> path pointing to libbpf dev package include directory.
> Could this work?

IMHO that'd be the first thing to try.

Andrii, your option (c) also seems to me like a pretty natural fit,
although it'd be a little strange to have code depending on the kernel
version in tree :S
