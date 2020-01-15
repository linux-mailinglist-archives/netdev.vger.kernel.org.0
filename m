Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F8C13CD54
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 20:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgAOTn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 14:43:59 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46928 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgAOTn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 14:43:59 -0500
Received: by mail-lj1-f195.google.com with SMTP id m26so19854782ljc.13;
        Wed, 15 Jan 2020 11:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MDrV7iuXP/9imjsFFQQBvKDPO1bSSfiQthzUbX7LSkM=;
        b=Pf0ybzNn1vk3Trnb8jy6hr5/9avVY698ixEZRty81up4A/cxSEwCjhZ2qLY8f03XsV
         EmqZkIHNGQOFbapBtVQ5ZuytnlPUpw9wN4U5ZEvniqKq6NBp52FaiOLDDKZ7QhtkAM7b
         EcXAjEeqmsNR9V11sH2mAEVaHlV3rnFteV5icAvTntfNnoBTGFB7OZF/b7+VSwjz2CO/
         jq6lefn2FCO53SC7qqMN1rgFrJyiw5oUIGgEeztYbQGhxVsTZ5hIIfuLWgxK2lwiIJlb
         tuZFolqgF11SGn8W9/k88DN7jW3Ioivn7+PHftW0ekhWUMkSweULEh+kjrlYWXFMOshx
         HUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MDrV7iuXP/9imjsFFQQBvKDPO1bSSfiQthzUbX7LSkM=;
        b=k4qZz0v24KoKnmjr88oZDkmvLF/Qi0t5ZaKZWJbSn8tVhyb+X+wsewIl7pe1JcGlEH
         7HZAhBKvpUBn4exLORzSrIePl6EvRCfUg5JKKujMB3KxKtnmx6ZZpopr9Fa3YhnAmOec
         E7TdT6x6LlcF7EyfDqiKPlzrLcGgfgs4U7cMQUfS+tImGdkQaOjvc7eXmcKL8pxYUVla
         RcwnEuIpcg66LfXHtg5afyIYg6BUOQ1LsWV6L86DMVZHioxgQVUreomiNeNFtjASL97V
         2gFNUHS4/cZmk5Y4AUNKpyemWfUH4Sb97McYbRd2LBB1m0aKvmgM/tsVrouQwBawLD7i
         lHRg==
X-Gm-Message-State: APjAAAXP7VPWlWpqBBuWsscV7YmAn3cc9nfT02FbjfwFWfrzGXjdFIKU
        ECx2CMRf/uY2E441V49BGNPQ5JohRG93YhBvHxg=
X-Google-Smtp-Source: APXvYqzkWH9ruR4aPiD1iZa/OZ1CyXN7SKhLPTl98zjv68qZ958u+KP2D7PvFm28gYar5Gw28qovZQ+UOoLEVVkj/oI=
X-Received: by 2002:a2e:89d0:: with SMTP id c16mr30274ljk.228.1579117436601;
 Wed, 15 Jan 2020 11:43:56 -0800 (PST)
MIME-Version: 1.0
References: <1578995365-7050-1-git-send-email-magnus.karlsson@intel.com> <F5A36D1D-633C-4CDB-A49D-71DE73E26963@gmail.com>
In-Reply-To: <F5A36D1D-633C-4CDB-A49D-71DE73E26963@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 15 Jan 2020 11:43:45 -0800
Message-ID: <CAADnVQJOQ1mnxNLwQykYK5brY=_xvjeYJFJZcf_v-zyAni9qKA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: support allocations of large umems
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>, rgoodfel@isi.edu,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 11:10 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
>
>
> On 14 Jan 2020, at 1:49, Magnus Karlsson wrote:
>
> > When registering a umem area that is sufficiently large (>1G on an
> > x86), kmalloc cannot be used to allocate one of the internal data
> > structures, as the size requested gets too large. Use kvmalloc instead
> > that falls back on vmalloc if the allocation is too large for kmalloc.
> >
> > Also add accounting for this structure as it is triggered by a user
> > space action (the XDP_UMEM_REG setsockopt) and it is by far the
> > largest structure of kernel allocated memory in xsk.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Reported-by: Ryan Goodfellow <rgoodfel@isi.edu>
>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Applied. Thanks
