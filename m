Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD4B3083BE
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhA2CWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhA2CWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 21:22:34 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8789C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 18:21:53 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c6so8932462ede.0
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 18:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vSzjq/CjVtCyUWsaFtjYkbyAcvgDzrIG/wbQ7+LoU9E=;
        b=Oza5op4p5aPJKeMnu5fZOAZ3iYbLEEy+7Oa1nZMkQBcURVeccR+fIkQgU/F1RUM6us
         /2by9B2HRlVofqXdiSiUtQf6/kCWI/Xk/vImK55vAV32l0em6rTyJuEjoHFN3nQVo4RZ
         QBhDZG/Ksquxdeae6Yyaq7DPDdBE7lEAD5N87W1zSxCb00bnaoK1IqMP6/eq/oT+22QI
         OXDstK4ahst+4lbWnokl9rW3tAXtTjO2Wesjr+oPayZx/+49UXkU2PdZvGNVNfkPW4Kk
         U+n05QSY41uGHGr1dOfmbERaiyBI81uKRXs/KfhWxj8fZlSV0MPY8aOEhBS4I1583VcT
         S+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vSzjq/CjVtCyUWsaFtjYkbyAcvgDzrIG/wbQ7+LoU9E=;
        b=ZjLW9keb8IFTeuUL8hzVrjsc7ZtI4qBuaQGZU4lPEaPbrcgyRYPHo6i66dmByGboIJ
         LRgmqrXzbFVpcVh11w7G0mWygtOJrrizdjhUR2np34pE/j+AMczSM/UJ6VG3TGKUleqs
         PUiYE8SfDXRfuZuMwWcQB2zuY2q/RsEz/SVbqHZINuim0kHYVRUT3soS4rAw0WEFAXAM
         etGbiz/wkJ8erEkKPA/Faftyva7wUPRlSYjjXyFyhlz7j1lOgWKoh/20eSI0N2NNCVKm
         rBA4wgTTkB6SqSanxtKy8VVq0MHRX5vMn8QmxyoC6IRUJEivO5Q5MY6zb790ejEnfmyx
         CqEA==
X-Gm-Message-State: AOAM533b8CZjXWuU+wbaZZvFtS++oUzAirJil3PjGX0814JAkQJUW6I6
        WF0y+McfWDTBSuqRn5mGyklX6jyFgFcw1gpdlZU=
X-Google-Smtp-Source: ABdhPJy1Qy4hPpn4CgDWhVCxYPjzNi+U8vVaENVKyOYTMyrEFXzxfCbMhk20kIjX5YBzBK1kejGt1ADUfu7s+X1EKwo=
X-Received: by 2002:a50:eb81:: with SMTP id y1mr2761931edr.176.1611886912512;
 Thu, 28 Jan 2021 18:21:52 -0800 (PST)
MIME-Version: 1.0
References: <1611882159-17421-1-git-send-email-vfedorenko@novek.ru>
In-Reply-To: <1611882159-17421-1-git-send-email-vfedorenko@novek.ru>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 28 Jan 2021 21:21:16 -0500
Message-ID: <CAF=yD-Lmk+nuUWKK+HcoALyPY_xr9rMU_+AsfgAAB0+vCOijRw@mail.gmail.com>
Subject: Re: [net v2] net: ip_tunnel: fix mtu calculation
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Willem de Bruijn <willemdebruijn.kernel@gmail.com>--to=Slava Bacherikov" 
        <mail@slava.cc>, Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 8:02 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> dev->hard_header_len for tunnel interface is set only when header_ops
> are set too and already contains full overhead of any tunnel encapsulation.
> That's why there is not need to use this overhead twice in mtu calc.
>
> Fixes: fdafed459998 ("ip_gre: set dev->hard_header_len and dev->needed_headroom properly")
> Reported-by: Slava Bacherikov <mail@slava.cc>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>

Acked-by: Willem de Bruijn <willemb@google.com>

It is easy to verify that if hard_header_len is zero the calculation
does not change. And as discussed, ip_gre is the only ip_tunnel
user that sometimes has it non-zero (for legacy reasons that
we cannot revert now). In that case it is equivalent to tun->hlen +
sizeof(struct iphdr). LGTM. Thanks!

Btw, ip6_gre might need the same after commit 832ba596494b
("net: ip6_gre: set dev->hard_header_len when using header_ops")
