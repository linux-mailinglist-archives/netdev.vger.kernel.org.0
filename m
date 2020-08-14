Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749F3244AE7
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgHNNqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgHNNqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 09:46:39 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA18C061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 06:46:38 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id y17so2656721uaq.6
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 06:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=30BzHOMWkpYticntxIn5D2wVFVe2pdTakVPv+YwkfO0=;
        b=E+OXNP3C2gPG31JY2im+qLw5HH7P030ku1k6hC3PnAFxodip+0/dMY6H0lUxWYVr67
         7AxFd5vkVIvEUWjrRpdHZzKB1uf8BtTuLLwAtPxo8SqCHfnP/MCqq6rLKqAXCTMiamEv
         Nvc2pWMcEDO42QVoILw6sn3pn6X8FGJiZwEiQKCnegW7d5/PNJu6JxEcGH18tODSuJgA
         ZHhQV7uUOh6i3IGmOb+Qw3lvubwOvAiOs391nsfsFQ7tPlqaViy2+XKuiBWqeAkPcHEY
         N/KXgI9PAyBADrdQUnLDrZsdiLkDk1NA4knHWJyf4safdh2FEmQTEk4VXYy04+zLGllu
         WavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=30BzHOMWkpYticntxIn5D2wVFVe2pdTakVPv+YwkfO0=;
        b=ekrA5tv7Wpbhms3KLQLJKguF2PUCvH2sVLKLwqXugsmsx1M0tles6ni1BwtYtVUaKj
         Wi8R1Uew+ub4kqCuVZwYYxJS6cmJA8trLyLEoTBI0bennerZC+ErvC0l1CoDw/o3TbN2
         HHQaPNL9TwQGADNszB0y1T3J93G7aRbcXDiATRxfaV+9l61u76enpyBpWICWwO5oMGzN
         fZJt0yprWKHcFbFj4S7F+AOHd2HLb/NnK0rN77JGzGnJJX+gr2psh8gYjPPbIYHi3ACq
         024uJRrgLzRxyskWA+g05mLSOiHzkzORCrLVKa2FMkrpD/dXxEFRc9oBNIUwWwSVzfDF
         KvQA==
X-Gm-Message-State: AOAM531C3c1aXtJAnQo/wK3h9oyBvRwO6EIMSl1O+3hVxxriNEkP+xg2
        LyC+RiKq2ypmhCIIRztsvH8T9y6xFLpUAA==
X-Google-Smtp-Source: ABdhPJwRbYGuAQc0h5zpRAt4DPuooAiUYE/u3VNewDru++radJe52cKwJw+MV+34EqQSNdA6fRCmNw==
X-Received: by 2002:a9f:24ac:: with SMTP id 41mr1384511uar.137.1597412796828;
        Fri, 14 Aug 2020 06:46:36 -0700 (PDT)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id 62sm1007503uas.18.2020.08.14.06.46.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2020 06:46:34 -0700 (PDT)
Received: by mail-ua1-f51.google.com with SMTP id v20so2660793ual.4
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 06:46:34 -0700 (PDT)
X-Received: by 2002:ab0:1892:: with SMTP id t18mr1348930uag.108.1597412793876;
 Fri, 14 Aug 2020 06:46:33 -0700 (PDT)
MIME-Version: 1.0
References: <e9b280b79ba444a68f5279cea77a84bf@huawei.com>
In-Reply-To: <e9b280b79ba444a68f5279cea77a84bf@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 14 Aug 2020 15:45:58 +0200
X-Gmail-Original-Message-ID: <CA+FuTSczcJPgTzi5+UP8NnXX0PAH_PAiEuyzS69A5_YA3y81Gg@mail.gmail.com>
Message-ID: <CA+FuTSczcJPgTzi5+UP8NnXX0PAH_PAiEuyzS69A5_YA3y81Gg@mail.gmail.com>
Subject: Re: [PATCH] net: add missing skb_uarg refcount increment in pskb_carve_inside_header()
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "martin.varghese@nokia.com" <martin.varghese@nokia.com>,
        "pshelar@ovn.org" <pshelar@ovn.org>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        "sowmini.varadhan@oracle.com" <sowmini.varadhan@oracle.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 9:20 AM linmiaohe <linmiaohe@huawei.com> wrote:
>
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> >On Thu, Aug 13, 2020 at 2:16 PM Miaohe Lin <linmiaohe@huawei.com> wrote:
> >>
> >> If the skb is zcopied, we should increase the skb_uarg refcount before
> >> we involve skb_release_data(). See pskb_expand_head() as a reference.
> >
> >Did you manage to observe a bug through this datapath in practice?
> >
> >pskb_carve_inside_header is called
> >  from pskb_carve
> >    from pskb_extract
> >      from rds_tcp_data_recv
> >
> >That receive path should not see any packets with zerocopy state associated.
> >
>
> This works fine yet as its caller is limited. But we should take care of the skb_uarg refcount for future use.

If a new application of this interface is proposed, the author will
have to make sure that it is exercised correctly.

> On the other hand, because this codepath should not see any packets with zerocopy state associated, then we
> should not call skb_orphan_frags here.

I'm also not convinced that the skb_orphan_frags here are needed,
given the only path is from tcp_read_sock.
