Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BFC227648
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgGUCzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUCzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:55:21 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879D6C061794;
        Mon, 20 Jul 2020 19:55:21 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id e7so2179361qti.1;
        Mon, 20 Jul 2020 19:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nYOJ4tS8cw/WA98jvC/US7uJ55A2B0FngHBRHIK7lIk=;
        b=urR6IkBLDrmE3O5fp4E7C1kkQUG6odVJZO6V/R9wWCysrzG71uPflXUqXBWrE7Bbtb
         PZerbtt0OpmGTN9XDxO1pnY0oYbi93KdUR5HKozUDiFloY/z7Um3M4f6tTTGNbcPQPpA
         RxPW3HgTcSAdLZkQakZuXDt6ASnUQxQVWGJnkSh5Du61I0QJOlwA4NBXrnsqvViygc5k
         HE0BYrX5pHK1ykkjKu16YWrWtZcaCKvsBKry5coKZ4D9Z0yjHPlPEs3yPNrD4i0Yks85
         SlxrFH7cC2INutFRrDcjIE8KdSvPdSmystryRC6HIw1MhCOlVrL1PgtrKjWXwWj30JpJ
         MRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nYOJ4tS8cw/WA98jvC/US7uJ55A2B0FngHBRHIK7lIk=;
        b=U4yXMrW44oiXqdIGM7UlhluyrKzRMNBR78el4WtHPhvJv2ATk70Xf5uSDuZH8iE+wH
         24ZsH0ZNa9JiBNFh/8ndav2FX8m+3NTVNs5DiDTkfMf9feIdq3BvV00oKYzL3A+jU0Rv
         Je2jHY8a3xlhB4Rgp6/qCgokP6SFq1uMbIDppb5YF5UWxwB63Hc5rlYOpwxNT8a4Ji66
         WWlDTB6YayoTsJaiWpUikQ/262kCEUXTfIe8EYmEAdiKDzObZ38XhLW5zGp2Jdis8Ldz
         pgOHQAdgw9SsMStoDmxxkBF3B4UMSahijP3rPNzQtHxYEjP3C4eZtBxG8pjPLBwOoJDM
         nOEw==
X-Gm-Message-State: AOAM530dm7+rrQvNS0Nqj/WENeIQaXPj4jafU3XeWRwWwMSDMixS03oK
        1MDdqTKqYxOCApFM13+xfntZLXxe
X-Google-Smtp-Source: ABdhPJzrhWLyx2V9SINZhlKDG40IficjzJ9C/E69PuzueVIZEWFHrDie488G+wZS6zF0iyF3TWXJvA==
X-Received: by 2002:ac8:748b:: with SMTP id v11mr26974940qtq.293.1595300120642;
        Mon, 20 Jul 2020 19:55:20 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.248])
        by smtp.gmail.com with ESMTPSA id 6sm1198516qkj.134.2020.07.20.19.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:55:19 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7A1E6C163B; Mon, 20 Jul 2020 23:55:17 -0300 (-03)
Date:   Mon, 20 Jul 2020 23:55:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Misaligned IPv6 addresses is SCTP socket options.
Message-ID: <20200721025517.GA3399@localhost.localdomain>
References: <f380b70f54854d98a9c801c7ae6bc370@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f380b70f54854d98a9c801c7ae6bc370@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 03:50:16PM +0000, David Laight wrote:
> Several of the structures in linux/uapi/linux/sctp.h are
> marked __attribute__((packed, aligned(4))).

I don't think we can change that by now. It's bad, yes, but it's
exposed and, well, for a long time (since 2005).

> 
> I believe this was done so that the UAPI structure was the
> same on both 32 and 64bit systems.
> The 'natural' alignment is that of 'u64' - so would differ
> between 32 and 64 bit x86 cpus.
> 
> There are two horrible issues here:
> 
> 1) I believe the natural alignment of u64 is actually 8
>    bytes on some 32bit architectures.

Not sure which?

>    So the change would have broken binary compatibility
>    for 32bit applications compiled before the alignment
>    was added.

If nobody complained in 15 years, that's probably not a problem. ;-)

> 
> 2) Inside the kernel the address of the structure member
>    is 'blindly' passed through as if it were an aligned
>    pointer.
>    For instance I'm pretty sure is can get passed to
>    inet_addr_is_any() (in net/core/utils.).
>    Here it gets passed to memcmp().
>    gcc will inline the memcmp() and almost certainly use 64bit
>    accesses.
>    These will fault on architectures (like sparc64).

For 2) here we should fix it by copying the data into a different
buffer, or something like that.
That is happening on structs sctp_setpeerprim sctp_prim
sctp_paddrparams sctp_paddrinfo, right?
As they all use the pattern of having a sockaddr_storage after a s32.

> 
> No amount of casting can make gcc 'forget' the alignment
> of a structure.
> Passing to an external function as 'void *' will - but
> even the LTO could track the alignment through.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
