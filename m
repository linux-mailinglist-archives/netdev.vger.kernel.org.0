Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A22224063
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGQQNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgGQQNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 12:13:21 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC14C0619D2;
        Fri, 17 Jul 2020 09:13:20 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e8so13367504ljb.0;
        Fri, 17 Jul 2020 09:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P29yGmEXzaza8awirO4RTJQUDlpuZwYlFSk6xd9V5Ic=;
        b=tAT+4YQi9I0TLTZlIuCxvMu5KbCTozINT3HUNF5ewWSBl7M8f8AIxxTdZBl5o/z6LH
         g/t7XaCvsBJhQoWkaWESKcYF0XYHbRSSaWsJDr44k9jjDf9vm46pAmY/umbm+7Wqd3t8
         +TOqlUCCIk993Bm+GpmQUHOefV3mdiQE7YO/Ew0Ohjb2zfRy5J69ZpORJy1O10A+hZED
         hpAIe58FTxTqd8VooLgKJxseqBYrRnkCouVYuWoBz601T9H8C01mvJjDdz79VXrZ1sNj
         Qivvoazd0CiqHMqTPI3EFf/idT7CdQlwlfFBvwFTPgcLHsYdjNzLFw4ji7K512GwbTie
         Y04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P29yGmEXzaza8awirO4RTJQUDlpuZwYlFSk6xd9V5Ic=;
        b=NVndQBfx8b3IGdy0ZGBbg6+WNgTIcaFq4unXni5KUPb7Y8r1VR0/RVgwIlwhMi3qHp
         r64PVimZMDgtARr2TgHwB8ZAfgZFDHVWbEcgX1FonEk2zLRK9USmzb/FhvtGb2edKQVw
         apyO3+Ii6naA/sgFqOuhFBqgRUASh9eExA+rKBGhcGsPBmlXvEoQjLE+M8jYb+aO2J5m
         RDoWOUhHE7WN8WOL/wBrTDO037kgYL+jxrxxCbk97m4srJRUIXRQ3wTrHvNAcNDGAxqV
         65ybqdzmAXVgalP+eLCQPvIJO/sI7sHOMrUs8pDVkrJVHi3cM8xICvVbim4exbyLMSqm
         QYkA==
X-Gm-Message-State: AOAM533P8w9Dttcb0XrS9mGAXHOSuBCZ+ZBxv7cDyuFnrssqRfx2VimM
        19qh2LCWubMwreww9lAMXnId6hLN/aGoBq52DGSeOpiU
X-Google-Smtp-Source: ABdhPJwy04lcMeKmDyk+Z+qqIoCPL/dJmkDAql4/gMh0aLSyK3i0tDuoYnMq4xcTsoSukM/BmOVcZ7yWS9y+gL/6C0M=
X-Received: by 2002:a2e:9bc3:: with SMTP id w3mr4980191ljj.121.1595002399275;
 Fri, 17 Jul 2020 09:13:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200717055245.GA9577@lst.de>
In-Reply-To: <20200717055245.GA9577@lst.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 17 Jul 2020 09:13:07 -0700
Message-ID: <CAADnVQ+rD+7fAsLZT4pG7AN4iO7-dQ+3adw0tBhrf8TGbtLjtA@mail.gmail.com>
Subject: Re: how is the bpfilter sockopt processing supposed to work
To:     Christoph Hellwig <hch@lst.de>, Stanislav Fomichev <sdf@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 10:52 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi Alexei,
>
> I've just been auditing the sockopt code, and bpfilter looks really
> odd.  Both getsockopts and setsockopt eventually end up
> in__bpfilter_process_sockopt, which then passes record to the
> userspace helper containing the address of the optval buffer.
> Which depending on bpf-cgroup might be in user or kernel space.
> But even if it is in userspace it would be in a different process
> than the bpfiler helper.  What makes all this work?

Hmm. Good point. bpfilter assumes user addresses. It will break
if bpf cgroup sockopt messes with it.
We had a different issue with bpf-cgroup-sockopt and iptables in the past.
Probably the easiest way forward is to special case this particular one.
With your new series is there a way to tell in bpfilter_ip_get_sockopt()
whether addr is kernel or user? And if it's the kernel just return with error.
