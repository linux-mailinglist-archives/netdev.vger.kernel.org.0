Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647DE144433
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 19:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgAUS0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 13:26:42 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41268 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUS0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 13:26:42 -0500
Received: by mail-yw1-f67.google.com with SMTP id l22so1895676ywc.8
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 10:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=saSIu8sQwnd3Wuv6FWGZUWJ+4LWuNfIuPazaF7KOw6g=;
        b=RJyNSGr71SwQw0PlCP014oATyQr0WwvD3D4QicXxu3PUZWCCQI4plTgJ0+ix3O+/Ek
         JlrpyF6aTncTwqoySOBY8fqNOZaLJKcvBPiKBBqz9Dus6AUGfzgLBQ3Bu0ZmvxQDv6pP
         2oWebSz2dG5sztyMoKl5nuO7Hg39DQnh3rnud+aC1CeQm7zkUfxsdq3lZNClIGR/XHBr
         BW8EeOuGs4hZnt+J7xxtLUvDUOF4YwUp4Bu16BvGFd5uDJT6yxE7ensQQtLB2KgdK/X7
         C97M8DVnZyfKk1CcFfU0HDJsNbB6+qNV6LU3x01CxySXDLcxi/uxyB7wdQZPC/LuKJGX
         Y/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=saSIu8sQwnd3Wuv6FWGZUWJ+4LWuNfIuPazaF7KOw6g=;
        b=c3OWI0XUdEGTCha8j3TWFF6WGw9RBrCL4DQjqvhJXBiSQ8Mr9G8WxD1/72JVjJ2XOa
         gvZ4hTlHPWBvX7VJdl0dBZn+um8NsrxrV6df0J2UtZKsVX1JYoy+iMyltywfxk1zgMpX
         8jENW/wdSinwAFNGUPbK4B/p4wujxXs4IuHPbUaPaJ5xg4HDKhrVpTvwsY9Zk61BaJ2y
         iha0ydLVC7ZQdNgWvSLNh0hYG5XrjTDeTBj7+Xm5Wumh1KHk0UfJrD5aZuOW+n5haXSh
         dgW0wP/qQExTrVpe3P0XbA5qbQgRYuBIKU3SzTbiFajGiilKUhj0onwK/DzCyeTgr4lo
         6CjQ==
X-Gm-Message-State: APjAAAVhIgHmg+zQclQe4nJmGwpxnL141n8j7r/PScIOmSBpfizEvYpr
        5tMyY9W61pOB7V3Kh6OmkMTyLmLy
X-Google-Smtp-Source: APXvYqwR3fYgoRhZ6DvSbqGnuzmFgn8JlIgxsnb163DVximikyNiHQoUcMGu5K5J/NtIXRxZ1JmWdw==
X-Received: by 2002:a81:4f4c:: with SMTP id d73mr4421348ywb.279.1579631201027;
        Tue, 21 Jan 2020 10:26:41 -0800 (PST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id q124sm17977150ywb.93.2020.01.21.10.26.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 10:26:39 -0800 (PST)
Received: by mail-yb1-f180.google.com with SMTP id f136so1794127ybg.11
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 10:26:39 -0800 (PST)
X-Received: by 2002:a25:ced4:: with SMTP id x203mr4555273ybe.419.1579631199086;
 Tue, 21 Jan 2020 10:26:39 -0800 (PST)
MIME-Version: 1.0
References: <ec4444596ced8bd90da812538198d97703186626.1579615523.git.pabeni@redhat.com>
In-Reply-To: <ec4444596ced8bd90da812538198d97703186626.1579615523.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 21 Jan 2020 13:26:02 -0500
X-Gmail-Original-Message-ID: <CA+FuTScNcdaP4dDmoXesfY1HwE7r1VSiG_SbhbwBNugbv9hAxg@mail.gmail.com>
Message-ID: <CA+FuTScNcdaP4dDmoXesfY1HwE7r1VSiG_SbhbwBNugbv9hAxg@mail.gmail.com>
Subject: Re: [PATCH net] Revert "udp: do rmem bulk free even if the rx sk
 queue is empty"
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 10:51 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> This reverts commit 0d4a6608f68c7532dcbfec2ea1150c9761767d03.
>
> Williem reported that after commit 0d4a6608f68c ("udp: do rmem bulk
> free even if the rx sk queue is empty") the memory allocated by
> an almost idle system with many UDP sockets can grow a lot.
>
> For stable kernel keep the solution as simple as possible and revert
> the offending commit.
>
> Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Diagnosed-by: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: 0d4a6608f68c ("udp: do rmem bulk free even if the rx sk queue is empty")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks Paolo
