Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032FB28C6E3
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 03:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgJMBq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 21:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbgJMBq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 21:46:58 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD21FC0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 18:46:58 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a200so15557758pfa.10
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 18:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Hj2CS00hXkxQ4mehrUgfvmB19jo4/tzD+aGD6uLzcA=;
        b=G+5gBYBOFOn5r1xr9usT53zbIJ3AKcT6aTtLl4jcsbDRJast/sKHWb2HA/t6b2LxDb
         C3B8/5Sn3ZZ3tKo5E3xHu3HjPSWELie/Nb+3V7tf85QIU4gAiNTeER6i1MNVQal9bHex
         vGp/uGZLKk7R5ISM/SB0C93hckkSlzyhg9Jb7i/D2HddFSbjNDtTTw0y1CES1G//PrLc
         gbfvIEVEf7inyk2K5ZaQEEScHYYzo39tMUVCPaY6Lk07WZ6BvWlX9289yhqQuyvq0XT4
         5yEQinFYGqGzBhfon+L8PauOArAKDL1g8vNxELlqIlxtK/9lEwp52gCFVBB6+os73F66
         V9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Hj2CS00hXkxQ4mehrUgfvmB19jo4/tzD+aGD6uLzcA=;
        b=ZCji/3KSqAxSglfyPLVbQu8egon1xm56BnYYfKR/63yOax7jYLU5w++qReX9Fg9z9s
         sonGarEWP0MIZcILqrD2uSN8aXhEtSgUob05tK1qlCQ0Ttb3avbIvF0pzvNhmfq9Tnna
         DmkC6R3oR/75g+TFdzCvs5kn4ijLPPrE1bvn9Y5qQLuYUZOMsVj8IhQk/a1CdknV/Wgp
         3hK9Ao8uItqbC7R9VBzOmvb/EaibEk4nVCiBLGfc76K7ZzfEGUdux4c75sNyj+9z8yrQ
         wcZpjv25EE0WKnIv6DDA3aW1TBGPpj7RuXjS5+eQdrgw7CAlrrvHTS07EKddBJc9xw7k
         OhxA==
X-Gm-Message-State: AOAM530TOsXFzRQlN8pDyWxHRFegTdDOaO451RxtGNRiyFQSFJPRBXW0
        ePnw1cd9TIf8l3HJIy/O9PVYpuVNmbB77Zuyre4=
X-Google-Smtp-Source: ABdhPJzYMSLzLMR7TRRVQCUjw1fWBsrIZYoeMF3hFif6oVxRCulTO2vDfEQ89bXgWigweG5V8kQexRk8vKPY+HPfbpM=
X-Received: by 2002:aa7:83c2:0:b029:156:5ece:98b6 with SMTP id
 j2-20020aa783c20000b02901565ece98b6mr2982181pfn.4.1602553618061; Mon, 12 Oct
 2020 18:46:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201012231721.20374-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20201012231721.20374-1-xiyou.wangcong@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 12 Oct 2020 18:46:47 -0700
Message-ID: <CAJht_ENiKS6KKQUCvE1ScLsyTawwaDjioPDC8jXE0CHZKnzHrg@mail.gmail.com>
Subject: Re: [Patch net v3] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 4:17 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Note, there are some other suspicious use of dev->hard_header_len in
> the same file, but let's leave them to a separate patch if really
> needed.

I looked at the file (before this patch). There are 4 occurrences of
hard_header_len, but they are all for ERSPAN devices (TAP devices
which tunnel Ethernet frames). So I think they are used for the
Ethernet header length and we don't need to worry about them.
