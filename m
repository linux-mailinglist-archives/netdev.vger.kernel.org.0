Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE273D3DE7
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhGWQM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGWQMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:12:25 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE865C061575;
        Fri, 23 Jul 2021 09:52:57 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id x7so2436630ljn.10;
        Fri, 23 Jul 2021 09:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OPlaSAvlxrH5r/4vsP4GC5AfQNIAc4uD8F9wRUdmtTI=;
        b=X/M7s4HdrD7gwq02WnwLzWSEs4bTqmO/JzE71w8S00WoZuxxpCcbTDAuJpod9Ve20r
         v2HMzYnEAQWcdi1T3hh5iGkDN6YdHaw4u4hG/Z9eeFHzraJj99my81c6/wRI3PA0CiUC
         uzfmbeMTCXdvnozD1Wkja4w42SHBheCTnsEJhHYFLDa3P4nlwYKoRIwfCg2ppdwXXZYB
         Ya44hIFma13OzbxNTEcTZmFMIfTDmTOtrN2eCdE4cYHEbTiMcZf5xzV2UZc5uN+L5S+6
         hZfG59xUbctapynLkuwB/vFVBR12aucdSwfar2vn4Vfq6M0MeO4m/+jSBrLy99g1z3uT
         XHTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OPlaSAvlxrH5r/4vsP4GC5AfQNIAc4uD8F9wRUdmtTI=;
        b=UJIqT7RG0ozeY4AG35NZbnn3zSe8oa3RLHZ+wGsJzgH8/xJ5u0fpvt9Jh+tEaDegkY
         ZZAfmLf+zmX/jE/FdbooiYXygzg+v8gWrMq8iz7FHuf3pTq9VTIjL/TDNmafougaja+u
         IhhImgFabUHK1egaOc4C8+ULhuKpD05JdEAPgXogtssNYv8N5B+7FIgM+1yPwxxPiLxj
         Jiiwjo3YE/tsh5oyylJqwrOmm1TXgwlqJy+Y/oekyKQVESma/9jn4OncNEftawel75XQ
         96Eqv3yo5VyxB2wtpyOhURz7oo7D8NmETEIuEsrcPlNG19no7oeA6YbLkMPioaEjxLdK
         89hA==
X-Gm-Message-State: AOAM531t3pAeI9+ZRRyFGRvZLszORBjSD8TaLvt3VdmalsGxv6bct0yF
        oOPVQfJ5Ioceu6ZDDg9oyvs=
X-Google-Smtp-Source: ABdhPJxeQb9WNOXcCIDbRjD8X2bhDP/MP9/DCefc7pRxFZn1psCwqCgX9+a9A4aLkIA0rmD+vsPGow==
X-Received: by 2002:a2e:9a53:: with SMTP id k19mr3917780ljj.482.1627059176006;
        Fri, 23 Jul 2021 09:52:56 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id g5sm95659ljj.27.2021.07.23.09.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 09:52:55 -0700 (PDT)
Date:   Fri, 23 Jul 2021 19:52:53 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     syzbot <syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com>,
        davem <davem@davemloft.net>, devicetree@vger.kernel.org,
        frowand.list@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>, rafael@kernel.org,
        robh+dt@kernel.org, robh@kernel.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net,
        Ying Xue <ying.xue@windriver.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in tipc_recvmsg
Message-ID: <20210723195253.56ef4ee3@gmail.com>
In-Reply-To: <CADvbK_dkv-DDt_VSSn1NQnzrUuxPm0T2Mki46T0jdwfUxENW-Q@mail.gmail.com>
References: <00000000000017e9a105c768f7a0@google.com>
        <20210723193611.746e7071@gmail.com>
        <CADvbK_dkv-DDt_VSSn1NQnzrUuxPm0T2Mki46T0jdwfUxENW-Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Jul 2021 12:41:46 -0400
Xin Long <lucien.xin@gmail.com> wrote:

> a fix already posted in tipc-discussion:
> 
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index 9b0b311c7ec1..b0dd183a4dbc 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -1973,10 +1973,12 @@ static int tipc_recvmsg(struct socket *sock,
> struct msghdr *m,
>                 tipc_node_distr_xmit(sock_net(sk), &xmitq);
>         }
> 
> -       if (!skb_cb->bytes_read)
> -               tsk_advance_rx_queue(sk);
> +       if (skb_cb->bytes_read)
> +               goto exit;
> +
> +       tsk_advance_rx_queue(sk);
> 
> -       if (likely(!connected) || skb_cb->bytes_read)
> +       if (likely(!connected))
>                 goto exit;
> 

Ok, thank you for informing


With regards,
Pavel Skripkin


