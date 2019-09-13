Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53CDB2890
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 00:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404099AbfIMWm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 18:42:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38537 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404009AbfIMWm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 18:42:29 -0400
Received: by mail-wr1-f67.google.com with SMTP id l11so33460708wrx.5
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 15:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FNt9Rh/dOYBYpwsbADpnfbm/wnYdH/1oLefT4Sc0/8M=;
        b=cYzkkomIAzjS94pB+/o+NfVLRYaS7uJPZOoEDdqz7MnHt3gS0o+beGu7wLhNeTU/SO
         +SdcdIt18zNFazTWPdyRBBJ8b8pNpd/x0PF6sUayDJKVLGVGyv3fntmoXRsF3imBYEcQ
         e1K+4eOz3ugq9X93u0VW0O9WZYhXKmE+mNqOkLVBzVcNQ9u6GrhaRsDtz3qSv/bBqF6V
         IqU185cQz8BnqJgEl3oSYF6M7TZOycAImawo4w0+taMpV/61A+K3rLwUVapr/U02nwg/
         aASDy/jETTGJm6js9DlA/jaVzZ4lTrJmqIbbKg7dI/MMepkSMESzSwAaUBCqov9HMhIv
         TPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FNt9Rh/dOYBYpwsbADpnfbm/wnYdH/1oLefT4Sc0/8M=;
        b=f3NfklqoNIiFWdsnJHjK/6xXRN+ZOQRZ3NWa8QY9ZLuWsQl4lQAoSpnegzisj/C4ts
         p1lU2plXF4XLt/Lib6fvtjhIgkpdcB9D9E7DDoEz3FEmaLMOJ7Ax4//CGQKniO652dTL
         sT29bkGDIUA/cHsViFdPPew5XoITLMxEMYYnElZwIXt8mvRN3bdPV4tqeSEO0Swp910M
         Ys1S/Jp23Bw88B7W0Ykh9xJPJOOKB3743y3DbolPHGzbe7x3+355RKFffTb1z0zq3aUt
         bDru2uxhTUbjRQ6OYRO/e8pSTIGzrbtE9G6ZSC2oRUEgp90G0hV2R+6AKhGYLU/gRUBC
         qClg==
X-Gm-Message-State: APjAAAXuIxM/BMTR4w3sBoG7wLNon2z1mWpOLYEA8YmehFto1bYkTtmw
        SDkSLfmJRNpUabQcMMrg4eB7ywqqndSkqy9iRqXw4A==
X-Google-Smtp-Source: APXvYqxp8BsIbYddXPyQj4hLnvgPL7nF3HT08VJxI1CPp91X/BGH/jio/9E1+aWmNDHQas4cE788QS8zRYkbSyjh5h0=
X-Received: by 2002:adf:ee05:: with SMTP id y5mr5501452wrn.291.1568414547169;
 Fri, 13 Sep 2019 15:42:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190913193629.55201-1-tph@fb.com> <20190913193629.55201-2-tph@fb.com>
 <CADVnQymKS6-jztAbLu_QYWiPYMqoTf5ODzSg3UPJxH+vBt=bmw@mail.gmail.com>
 <CAK6E8=ddxo+yg2tTiZm5YEbfPkeVkeZOGwB33+Qfb4Qfj4yDJA@mail.gmail.com> <CADVnQy=aU=veBnZF=5OgwkT6EWA+hmmu8w9eq2d83eReSjAxEw@mail.gmail.com>
In-Reply-To: <CADVnQy=aU=veBnZF=5OgwkT6EWA+hmmu8w9eq2d83eReSjAxEw@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 13 Sep 2019 15:41:50 -0700
Message-ID: <CAK6E8=fjUYGUf7uu5ewTYt-kQAC2NdvUdSQs9DfrUQ+aW_QbCQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] tcp: Add snd_wnd to TCP_INFO
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Thomas Higdon <tph@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 2:53 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Fri, Sep 13, 2019 at 5:29 PM Yuchung Cheng <ycheng@google.com> wrote:
> > > What if the comment is shortened up to fit in 80 columns and the units
> > > (bytes) are added, something like:
> > >
> > >         __u32   tcpi_snd_wnd;        /* peer's advertised recv window (bytes) */
> > just a thought: will tcpi_peer_rcv_wnd be more self-explanatory?
>
> Good suggestion. I'm on the fence about that one. By itself, I agree
> tcpi_peer_rcv_wnd sounds much more clear. But tcpi_snd_wnd has the
> virtue of matching both the kernel code (tp->snd_wnd) and RFC 793
> (SND.WND). So they both have pros and cons. Maybe someone else feels
> more strongly one way or the other.
no strong preference -- snd_wnd is just fine too with proper comment
(for consistency).

also it might be good to comment whether it is scaled or not. it may
not be obvious if the actual value and scale are small.
>
> neal
