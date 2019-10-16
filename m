Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB8CD881B
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 07:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732387AbfJPF0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 01:26:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44887 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfJPF0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 01:26:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id z9so26353584wrl.11;
        Tue, 15 Oct 2019 22:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N+byasZmM9B/FD9y0KRLeljpyazRUDjLgTSoqqsy+F4=;
        b=IubSdvTIESsiWVSkWNgBmBKVPztvHUiLVj/mdZVT1VWvDkREvp+BC6VvU8qCdOZx0X
         nO4BeTzrKKNjmfgELnMtM1FSFbeO+bUQ03fpK0BKg3i3xhBGG+zvqRQcnSsIgvEq2DqV
         Hr30ghTiZfvJwK1L+ItNYGQxk0mWPVawkQet8PEsmMV59wyYpo2bIqD9aK5aJ0lHJc0D
         y+zq1ytYtPJc6sjMfcYQFBRriOG+9gtBYeQJWVDSH6hG1EG62zWYd8SVk9YyqKz69hKM
         fcrvwSj7r05nrVSw4iNbvdVq2KCgH0cY05150fCUlfBi9DK98oGLenohgubD3nUop0v6
         0qWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N+byasZmM9B/FD9y0KRLeljpyazRUDjLgTSoqqsy+F4=;
        b=JicdxQtH4LP6mbHEH/pVNt4cG8OMVfWm0CxBOL1oh41B82MTbP8jdArSDOGfZymBbs
         ZPVmzp97Fs+5C0tEgyQa2X00xMBotVxjSV4v9AID1e6Wa4kdPeTTN3ooDNIVfrxlSMw5
         RkyjtGh50JD0hF/JlkD5S50vtm9mc7KKvLJSsijy2FVNGgpVwBkbz60gP74To/NtBwpy
         P6kxCTAqDem5VUfzI+3O8Qhzt8GJ+iUVuFjjz3vY6Gmaw1wLxDxmkRhNI8ROgNe8AVBF
         AXYOVbcBPbdjJ5cO35VfA8C8gyom3AkVfXg9K6Dj2ympt9F9WhrK2Ek7pnbo2TlQJrGB
         aiJQ==
X-Gm-Message-State: APjAAAV+eVgAvB7/LSJojIK/P8MdSnCj1qsF8wPpMu6/+bWxdhwYJ8XW
        e75Nz34H4aqwsiwXd+1dx+hg6BZU0GdJhavhsn8=
X-Google-Smtp-Source: APXvYqxs637YLkEr1A5KWUgdBdVLpSA/fZdEv+hL2LEf+c57aMtN4NAPRU5JG2wAKF4yC9LKRLNtzXf8OHjRfYPiaHE=
X-Received: by 2002:adf:c641:: with SMTP id u1mr878201wrg.361.1571203558007;
 Tue, 15 Oct 2019 22:25:58 -0700 (PDT)
MIME-Version: 1.0
References: <06beb8a9ceaec9224a507b58d3477da106c5f0cd.1571124278.git.lucien.xin@gmail.com>
 <20191015.203919.1387270193651224661.davem@davemloft.net>
In-Reply-To: <20191015.203919.1387270193651224661.davem@davemloft.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 16 Oct 2019 13:26:12 +0800
Message-ID: <CADvbK_cdOXdcMv5ptyKNVAq2Q55XWP=A7u9bZ5-aNjnKoNZnZg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: change sctp_prot .no_autobind with true
To:     David Miller <davem@davemloft.net>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 11:39 AM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Tue, 15 Oct 2019 15:24:38 +0800
>
> > syzbot reported a memory leak:
> >
> >   BUG: memory leak, unreferenced object 0xffff888120b3d380 (size 64):
> >   backtrace:
>  ...
> > It was caused by when sending msgs without binding a port, in the path:
> > inet_sendmsg() -> inet_send_prepare() -> inet_autobind() ->
> > .get_port/sctp_get_port(), sp->bind_hash will be set while bp->port is
> > not. Later when binding another port by sctp_setsockopt_bindx(), a new
> > bucket will be created as bp->port is not set.
> >
> > sctp's autobind is supposed to call sctp_autobind() where it does all
> > things including setting bp->port. Since sctp_autobind() is called in
> > sctp_sendmsg() if the sk is not yet bound, it should have skipped the
> > auto bind.
> >
> > THis patch is to avoid calling inet_autobind() in inet_send_prepare()
> > by changing sctp_prot .no_autobind with true, also remove the unused
> > .get_port.
> >
> > Reported-by: syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Applied and queued up for -stable.
>
> Xin, in the future please always provide a Fixes: even if it is the
> initial kernel repository commit.
Copy, thanks.
