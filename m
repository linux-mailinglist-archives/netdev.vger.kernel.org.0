Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C31ED5A58D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfF1T7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:59:45 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40970 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbfF1T7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:59:45 -0400
Received: by mail-yb1-f195.google.com with SMTP id y67so4887173yba.8
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 12:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JnkachwQP0cyQ9JdMbTUnW5qndJ/fTXRxpRomw9WY6k=;
        b=vVLyvukrpuQtbZdzKfeFDmHdS8rq0f9WdO6YO1eZI6sLIUF996To1rdL8/7+axITIy
         85yp8tjhuqeC8aQG5v6WRyAA6OCt/OvXJzXuB3erg1B1/6I/VhC97S1snroCo/cGfDMP
         uVp7k4O91vtcWDPfd0EgxARsjrcpaEz0vxiRw/U3zJGyqOMaKnEbJrlYwP0YHPX11owd
         ydc6SDTxO8stFGHPET1XRyuFJtUOZ/g0botEElyakKaPs0TwZwUnhxua9Brg/C7XrXzK
         Tzz95CL2xg4AohWS6sDOA/H16jSdpmsb38czV9xkwcdD72qnaCznSjjlKboOu3AVh9Qv
         0LPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JnkachwQP0cyQ9JdMbTUnW5qndJ/fTXRxpRomw9WY6k=;
        b=Wy8exgPbtyptoS7wqGJ6wlx7W6BWwS3QF3AH8OmXO8v4AHlTTCbVLEneZEq+vyQIUT
         4pgbKNMCfT2+dlaocdtfHnkKHwznmEAWld3nXr4m0H861WVbapbwBb2R1GzcYSB1TU8E
         qQDy1Wgsef5VdtFAMAI1tFZFDVdaActI+2SA5f2xT58B2p54pH0mxr7MQDYqubUQlyYB
         N7l+fLqS8C6GzrbFigNbZXb7jxhc/aRENVptrQxjRGTw83p2ZKtExteVwLKVVn7TjqFD
         jlzoWRJCDIC/VnZwpVrJtxkie/Ol+e8zX69dT5wt8sAmV6ieaaeAMjSigz/hmO4kK2vI
         spuA==
X-Gm-Message-State: APjAAAU9gqvkkayTddJvCjl/lQo49dNcKMnbtvnSEM97nGLc1MJzztjf
        fY1xRSwTNRs/5xzuSceKu4rQo2FnsqU=
X-Google-Smtp-Source: APXvYqzDIBxLiUSb1NyHthsRxASathmY63QP+K+JK5rFeUq066nXX+B4Mcxm5Kfloh/5/D+f2n59iQ==
X-Received: by 2002:a25:3c83:: with SMTP id j125mr7797588yba.352.1561751983507;
        Fri, 28 Jun 2019 12:59:43 -0700 (PDT)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id a70sm671979ywa.79.2019.06.28.12.59.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 12:59:43 -0700 (PDT)
Received: by mail-yw1-f48.google.com with SMTP id m16so4640079ywh.12
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 12:59:43 -0700 (PDT)
X-Received: by 2002:a81:4807:: with SMTP id v7mr6063772ywa.494.1561751494211;
 Fri, 28 Jun 2019 12:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190628123819.2785504-1-arnd@arndb.de> <20190628123819.2785504-4-arnd@arndb.de>
In-Reply-To: <20190628123819.2785504-4-arnd@arndb.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 Jun 2019 15:50:57 -0400
X-Gmail-Original-Message-ID: <CA+FuTSexLuu8e1XHaY0ObGi46CgZnBpELecBr+kMgCU29Fa_gw@mail.gmail.com>
Message-ID: <CA+FuTSexLuu8e1XHaY0ObGi46CgZnBpELecBr+kMgCU29Fa_gw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ipvs: reduce kernel stack usage
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <jmorris@namei.org>, linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Network Development <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 8:40 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> With the new CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL option, the stack
> usage in the ipvs debug output grows because each instance of
> IP_VS_DBG_BUF() now has its own buffer of 160 bytes that add up
> rather than reusing the stack slots:
>
> net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_sched_persist':
> net/netfilter/ipvs/ip_vs_core.c:427:1: error: the frame size of 1052 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_new_conn_out':
> net/netfilter/ipvs/ip_vs_core.c:1231:1: error: the frame size of 1048 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> net/netfilter/ipvs/ip_vs_ftp.c: In function 'ip_vs_ftp_out':
> net/netfilter/ipvs/ip_vs_ftp.c:397:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> net/netfilter/ipvs/ip_vs_ftp.c: In function 'ip_vs_ftp_in':
> net/netfilter/ipvs/ip_vs_ftp.c:555:1: error: the frame size of 1200 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
>
> Since printk() already has a way to print IPv4/IPv6 addresses using
> the %pIS format string, use that instead,

since these are sockaddr_in and sockaddr_in6, should that have the 'n'
specifier to denote network byteorder?

> combined with a macro that
> creates a local sockaddr structure on the stack. These will still
> add up, but the stack frames are now under 200 bytes.

would it make sense to just define a helper function that takes const
char * level and msg strings and up to three struct nf_inet_addr* and
do the conversion in there? No need for macros and no state on the
stack outside error paths at all.

>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I'm not sure this actually does what I think it does. Someone
> needs to verify that we correctly print the addresses here.
> I've also only added three files that caused the warning messages
> to be reported. There are still a lot of other instances of
> IP_VS_DBG_BUF() that could be converted the same way after the
> basic idea is confirmed.
> ---
>  include/net/ip_vs.h             | 71 +++++++++++++++++++--------------
>  net/netfilter/ipvs/ip_vs_core.c | 44 ++++++++++----------
>  net/netfilter/ipvs/ip_vs_ftp.c  | 20 +++++-----
>  3 files changed, 72 insertions(+), 63 deletions(-)
>
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 3759167f91f5..3dfbeef67be6 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -227,6 +227,16 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
>                        sizeof(ip_vs_dbg_buf), addr,                     \
>                        &ip_vs_dbg_idx)
>
> +#define IP_VS_DBG_SOCKADDR4(fam, addr, port)                           \
> +       (struct sockaddr*)&(struct sockaddr_in)                         \
> +       { .sin_family = (fam), .sin_addr = (addr)->in, .sin_port = (port) }

might as well set .sin_family = AF_INET here and AF_INET6 below?

> +#define IP_VS_DBG_SOCKADDR6(fam, addr, port)                           \
> +       (struct sockaddr*)&(struct sockaddr_in6) \
> +       { .sin6_family = (fam), .sin6_addr = (addr)->in6, .sin6_port = (port) }
