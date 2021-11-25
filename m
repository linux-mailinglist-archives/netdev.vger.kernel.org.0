Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C044545E2BA
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 22:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhKYVw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 16:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357266AbhKYVuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 16:50:22 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DC3C061A27;
        Thu, 25 Nov 2021 13:34:23 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id p37so14845075uae.8;
        Thu, 25 Nov 2021 13:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wHLy0cFWatt1hLYWo5NA91W8cirlwvzw9jVwHa5mqsQ=;
        b=oi/lVM887SvIxBA/OX+uL0qfVpqvv5kRGdpzBNVNZ72l0E4PYPpSyQ/fPSoM+pKj19
         pIzUoHgstCtkMobnZq+GlyAieJl/z7ABLHPIP9wBQ0DgmwMaT0xE6cYGIeTzoqEdUPZC
         YyGJhWAgolCsu54fL/3jzgEnwrUMRSBzNJBmOpOB/zKRXObkAevWu4vJ8i3TmTEZ8x9g
         +Wk3eZcxkODrT4xPfnoKgtkJ43+BqncmVJ/oq7m3arUZoh/n/YD7ize7HdrnYlEKIN2E
         hBdv1lHG0k0rM/bIiQF4OC0vmWL5XajXMj3rwQdw17cQ5ByQNNBOZ8JKabogqi4qAXww
         t4Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wHLy0cFWatt1hLYWo5NA91W8cirlwvzw9jVwHa5mqsQ=;
        b=F8ya684gc9qwsLDZBUy1+PoQHGXtV3HNSuS+MjvSrcboKquCFFvhjuu/lJv3vtcFZd
         yYcMUw7s0/nI+iOfdL2TJ9dylRWJdFHYp0EVTv9Du39EVudzTzg0N15E3K8FRx3yYDUl
         hHWyot5rl+uVASUs21tqFBZYRDirvI/NBFzj4wH89II2+RXjepIxUA7NwzJl9+GQNl2r
         6Npk6B6NrE3/pz05aIr1IGfcKrFfHL8+0m2CMUZMCjXo9ksqBcN3kLEV95iFF82wlLl0
         WA9Ka2qV4q1YDruFTcYouuR78Be5IUf/WMNol5cHvKrJXDjOVNx478+ZmMmTUX8xJTH1
         tg8w==
X-Gm-Message-State: AOAM531sRJtMGQvOYpiHJDEaiXlkKAFyubi3tXoXoYqSIdJSZrOgmBf4
        A1LL+tkJBWFlqBGciOm1t0WpRw9M6Gk=
X-Google-Smtp-Source: ABdhPJy9p1ct0uRl/0Vv6FSJdHvwql+MOeUOInKJyTsTpcsosS5YeJK2HRI0A0SkmD5ksKMTo4YpDw==
X-Received: by 2002:ab0:66c7:: with SMTP id d7mr31104646uaq.94.1637876062472;
        Thu, 25 Nov 2021 13:34:22 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:34a4:2da3:1d08:94fa:ac11])
        by smtp.gmail.com with ESMTPSA id h10sm2389351vsl.34.2021.11.25.13.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 13:34:22 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id AD354E346D; Thu, 25 Nov 2021 18:34:20 -0300 (-03)
Date:   Thu, 25 Nov 2021 18:34:20 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] sctp: make the raise timer more simple and
 accurate
Message-ID: <YaABXM/RBXaB8fzN@t14s.localdomain>
References: <edb0e48988ea85997488478b705b11ddc1ba724a.1637781974.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edb0e48988ea85997488478b705b11ddc1ba724a.1637781974.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 02:26:14PM -0500, Xin Long wrote:
> Currently, the probe timer is reused as the raise timer when PLPMTUD is in
> the Search Complete state. raise_count was introduced to count how many
> times the probe timer has timed out. When raise_count reaches to 30, the
> raise timer handler will be triggered.
> 
> During the whole processing above, the timer keeps timing out every probe_
> interval. It is a waste for the Search Complete state, as the raise timer
> only needs to time out after 30 * probe_interval.
> 
> Since the raise timer and probe timer are never used at the same time, it
> is no need to keep probe timer 'alive' in the Search Complete state. This
> patch to introduce sctp_transport_reset_raise_timer() to start the timer
> as the raise timer when entering the Search Complete state. When entering
> the other states, sctp_transport_reset_probe_timer() will still be called
> to reset the timer to the probe timer.
> 
> raise_count can be removed from sctp_transport as no need to count probe
> timer timeout for raise timer timeout. last_rtx_chunks can be removed as
> sctp_transport_reset_probe_timer() can be called in the place where asoc
> rtx_data_chunks is changed.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
