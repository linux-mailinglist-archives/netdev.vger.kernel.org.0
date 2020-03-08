Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D9417D0C7
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 02:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgCHBSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 20:18:02 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46726 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgCHBSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 20:18:02 -0500
Received: by mail-lj1-f194.google.com with SMTP id h18so6257527ljl.13
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 17:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=7uOiCL4ANWWX06g1URmXNQLbBgiN4b27Ac4cNkVqWDQ=;
        b=FnCGpsCgGHFb9dzyXzY0wGoml0JdOWxKEDgF+JNprtbHSFEVyQdDGsffV5lQ3/97Ni
         pn7e3rswfTKkHdyoMrNOJeWpspVU4sg9lyJybfJUNTQPcu/381Ii+AS5CjmeuUJmeApp
         iZUzrMtXYzrrDHN7H7dhrJIWE4uPI95Q6IsUaiPvHVMXpCgy3ZEH9bdqvDnGyqwVbFy2
         YWwls6JEVkQtFUJ8zC7CMZJUUcPiE6IK688xGwc6FLShHme97j1sd8MxWzyrdPUGpnUv
         52o2+LPtPcCi3Y0wezQfxjYA1AVnL9hg0RVja25XiH8vF72fAxy3+7BarOrvTFKixjPh
         6ZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=7uOiCL4ANWWX06g1URmXNQLbBgiN4b27Ac4cNkVqWDQ=;
        b=dZaUz2OS/saEZO/hPrvYpNqniVVuSBj48VE3F50ffB+VoI3bud4hEtqJZPkfH128GL
         38VEeQdKAZ8b0qvQLThKb9O7vL0g+zKbrRIvXMJuCnd2yFvYAL5w95WylnNlsk12LIgm
         QGncyIJSG6UBpSSO53b/ODK1Xa8hO0aXrw/y9t6Nl3uV/nridMB71msDl90Xhr36il/T
         zLUT4HiSwJC9b7yldK53FZdd9rFt9KGhLCpDiy9KlQkyTDDUhjH1L9xYZ1v0DFCFHWSd
         MnapZ49RwFJytGeiBPpeZexjwuNjNqRB1wvdE32SYbLe2kPtnlsddb0ag9vwefivfz8W
         Df5w==
X-Gm-Message-State: ANhLgQ2/8PM3ZxI8gRNKva0wIT6oC1C9MdSm4qS6TJhxQmw9kDf3+WN7
        AtkxuoscT2w4SBBq3sipp+ocIwD+4W/CSUmdzC0=
X-Google-Smtp-Source: ADFU+vt6oTYWTw7lpqbIn/P18Rv3CxILpMnUKKHhDXo6YyQGlcHb02gLWhjPeb+ciBG5wxub5XfWjCtj9UobaTsSutE=
X-Received: by 2002:a2e:9252:: with SMTP id v18mr6086957ljg.114.1583630280482;
 Sat, 07 Mar 2020 17:18:00 -0800 (PST)
MIME-Version: 1.0
References: <20200308011510.6129-1-ap420073@gmail.com>
In-Reply-To: <20200308011510.6129-1-ap420073@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 8 Mar 2020 10:17:49 +0900
Message-ID: <CAMArcTVBoBbc4ioQxHN4AkhoC0vi=X41dxt+tSVZfqfUWxPEWw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] bareudp: several code cleanup for rmnet module
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        martinvarghesenokia@gmail.com, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 8 Mar 2020 at 10:15, Taehee Yoo <ap420073@gmail.com> wrote:
>
> This patchset is to cleanup bareudp module code.
>
> 1. The first patch is to add module alias
> In the current bareudp code, there is no module alias.
> So, RTNL couldn't load bareudp module automatically.
>
> 2. The second patch is to add extack message.
> The extack error message is useful for noticing specific errors
> when command is failed.
>
> 3. The third patch is to remove unnecessary udp_encap_enable().
> In the bareudp_socket_create(), udp_encap_enable() is called.
> But, the it's already called in the setup_udp_tunnel_sock().
> So, it could be removed.
>
> Taehee Yoo (3):
>   bareudp: add module alias
>   bareudp: print error message when command fails
>   bareudp: remove unnecessary udp_encap_enable() in
>     bareudp_socket_create()
>
>  drivers/net/bareudp.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> --
> 2.17.1
>

I'm sorry,
This headline is wrong.
I will send again

Thank you
Taehee Yoo
