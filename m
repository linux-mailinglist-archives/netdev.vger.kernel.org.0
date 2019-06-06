Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F58937F85
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbfFFV1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:27:41 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43150 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfFFV1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:27:41 -0400
Received: by mail-yw1-f66.google.com with SMTP id t2so1403346ywe.10
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 14:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t72S9N9n6EBonbXvSsP/tLIJUSRi6ufK2l0EoTcdmOE=;
        b=LOc79FKWbFJl9uBZBrEbyNtK2g0zeLg0DP2MT5txJ6I1hTSFflV+QNskfD5ktpDv9g
         SnVEN8cVfPoZ+GBh4kLS+wLG9UEnk7rig+hdmUbiAoA3C+0EY6/abANbGAGcdS0CJV3S
         3t+RlxtInrlCHeh7+ZxLywnfo7XSxJoou9981uMqjswDkrasgZvgISuBslLQWcbvSmth
         SZcgfBji6GRqnqTzxXvybNfS14iizA/wfNpZsswiBkoOqIf6udRtjz0CuP+3XoR8DvTq
         TIrNhDB3p+i3ulr2g4V8Cbtu/0K1HIWDGRVOd6B2Okoq1KMQY+hYe9whiFPPgqfT/bdq
         idUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t72S9N9n6EBonbXvSsP/tLIJUSRi6ufK2l0EoTcdmOE=;
        b=PL/HozHJCxIPw/rl5G5S76LebuColsr7wnWJtpDaWop0owriR+S07HlOV+YDfnYsNy
         zbDDjF+nV9+z8W5117ayQu1qYXbd+EmaDGZ5M7Bs5ECy/aP1HkvK6YtoapxfYIc6wp27
         qyF6YrjGtYkano53xudREORZzUvpXEJycNBxd8FQY4T5ahcQkqT3WXttmVlrXTRl2nWB
         emrHtMq2ICcedYHH+8+43KEr8Pyvt0Zs/UxhxDJNb44J3Iljby9wIzDqxVLnUdibB9Ey
         xgPuVgrSBy0qbmQDfR018OFzJNpR8SuaHV1AsxR2qf42gyUOUir8c7fw1mhZltGpQJWT
         TGSA==
X-Gm-Message-State: APjAAAVgsL7ZTaEZ18DOwPcLfpVPI2BiMnxOfApCXMiPitz/cUhPIaJo
        93w0I25j6w1tLDsW0t9oXpmPxsYAb3yHkdpmS4FDbg==
X-Google-Smtp-Source: APXvYqzVl8vTgyXZmidOFy3Gg50AnLIYOqxclk3BftZ9ygNGgjlvqwRQjIr2VD8Mk7BAlMJjfzGcWFhLU+XC4CHS7hY=
X-Received: by 2002:a81:7893:: with SMTP id t141mr15021134ywc.424.1559856460173;
 Thu, 06 Jun 2019 14:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190606212253.144131-1-edumazet@google.com>
In-Reply-To: <20190606212253.144131-1-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 Jun 2019 14:27:29 -0700
Message-ID: <CANn89iLsGJK=J-hk7s7z6gE46bqBdp-NzNzFj+3MsxnQvhzB5A@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 2:22 PM Eric Dumazet <edumazet@google.com> wrote:
>
> RCU 101 : Before taking a refcount, make sure the object is not already
>           scheduled for deletion.
>

I will send a V2, there is a second atomic_inc() which needs to be
changed in ipv6_flowlabel_opt()
