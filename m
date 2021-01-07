Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2F32EE9B6
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 00:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbhAGXYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 18:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbhAGXYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 18:24:54 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7758EC0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 15:24:14 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id 75so8413121ilv.13
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 15:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiSijOtmq7Fn1TZJUAOjXBB0Hw0GXfQ+cgnoCKjq1LI=;
        b=EVd2r52hGp36SqOuUDdBV4FO6Fjg+dtxluJlEI9Zyzcg39XWa7749O9yPYADNxcHor
         vReQeO1oEzet73egsboWRoB+dpdMDxorigEjdLaE2sJkfW2HQ0G9Rh+9P5avdvHx/4ll
         UZO396Jh9swzNV/gXziBifV0+Y3htqHNy68FT6JLjB8ZzXyJomib2I822VOlNIOYDSb8
         g/f6DG3DzpOPGcRm9aauKU/UDEif8YMsPwKx4LaLkuZYG8OmUX8THewaLaLSUhn4TMwV
         BWy796j4gTsgEHNsOQ6fafHfSPth7ujs+eCWmfd7QXWinjBbqvtionlULWWLNTYFQJs+
         THsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiSijOtmq7Fn1TZJUAOjXBB0Hw0GXfQ+cgnoCKjq1LI=;
        b=Mb8k4yh6uP9Xor/MLyPBen4a9Zxj06lIcOHA9AKzEnC2cQAt8Nss6ND2MX15FaT+Wk
         ihYNf9samHc0q4mzKmfoHhX4n8EkcXJLwARGhtk63R1wT6hSDKgb8WQmWtlBhx1UjYBR
         t9xsnm25CBPXviqVZtYBf57bLIAqFMSO9T9j4sD3nn+BYtIYAGiIClcJdiKzGaH+2g++
         Oz3y6p2em2H0uXdudWd+DRwC1xtzYtk9CIQF5k2AJL3JTa24jHy82fi49X4TLG6qfgds
         mqh9W3mRyHhzKKurH8AYzszgODPXS88GkzpqhGmCHhthjEPNd/75ZI9tlBRPSVNDj9TI
         JAhg==
X-Gm-Message-State: AOAM5338UoGaa3bnIS81MwnE6/FhrLGHkp4aSP63uvm+W8kTJpTuV5Ip
        GsPPEzPVF+YCL3QByi1P4pASXlEdVqZa0g9mqDs=
X-Google-Smtp-Source: ABdhPJyk1hxRvG/gEbmayDsa/ARYwqMTbX1TFS0pUVcmEauoIlOZScofKAK9nR7u6MZ5chw5qA0xtOwv5W3Z3NElYM0=
X-Received: by 2002:a05:6e02:154c:: with SMTP id j12mr1213101ilu.33.1610061853870;
 Thu, 07 Jan 2021 15:24:13 -0800 (PST)
MIME-Version: 1.0
References: <20210107051434.12395-1-baptiste.lepers@gmail.com> <773322.1610017548@warthog.procyon.org.uk>
In-Reply-To: <773322.1610017548@warthog.procyon.org.uk>
From:   Baptiste Lepers <baptiste.lepers@gmail.com>
Date:   Fri, 8 Jan 2021 10:23:41 +1100
Message-ID: <CABdVr8TTtj+sK8EuhNc6FS+mthmx5jZyDAnqh9AMa68=rEywoQ@mail.gmail.com>
Subject: Re: [PATCH] rxrpc: Call state should be read with READ_ONCE() under
 some circumstances
To:     David Howells <dhowells@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-afs@lists.infradead.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, that's fine with me. Thanks for the clarification of the commit message.
(Sorry for the double send, I forgot to enable plain text on my
previous answer.)

Baptiste.

On Thu, Jan 7, 2021 at 10:05 PM David Howells <dhowells@redhat.com> wrote:
>
> Baptiste Lepers <baptiste.lepers@gmail.com> wrote:
>
> > The call state may be changed at any time by the data-ready routine in
> > response to received packets, so if the call state is to be read and acted
> > upon several times in a function, READ_ONCE() must be used unless the call
> > state lock is held.
>
> I'm going to add:
>
>     As it happens, we used READ_ONCE() to read the state a few lines above the
>     unmarked read in rxrpc_input_data(), so use that value rather than
>     re-reading it.
>
> to the commit message, if that's okay by you.
>
> David
>
