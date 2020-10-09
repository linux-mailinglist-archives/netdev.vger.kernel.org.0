Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44122289035
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbgJIRoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387763AbgJIRn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:43:59 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BC3C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 10:43:58 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id l16so9841911ilt.13
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 10:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z4UrjiMrfdMdrpdp4tb/6uQtpZju9u5fpvNjl2Tkkrw=;
        b=ZYG0KTBZuw55E2J3YofR64IAvP+Qv90L8mfpRBz+u0sL/n7PGDvQzQPDVIfa8i1PMq
         E2fng5W64eGjY8gw6zvqD8RqMxiv4wiZi+kWWAJXK3tyV6S16tziT7Aq6swRKu7e6eNc
         o01NxuEWAU9/80xYIZHstYYaxrA7r/AwwL9f642//o7HU+TWLGSfY0jBdGFyKJS/yp9Y
         DZsevrQEjZ4iqrAwQv4LnNU0qYd+SONMqYUlWnL8sOukjrjWZdBZ80VYPMrHAf7a9kZu
         J8j9S65Pi53SaRYc4teAXdsiJGIFlW8kbHDE8jFQCnWFb+NWBHNURzl6M6jSekby4RLV
         C3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z4UrjiMrfdMdrpdp4tb/6uQtpZju9u5fpvNjl2Tkkrw=;
        b=MQWJHi6+4vZpxW3LHA7MsY9j5rUrGVMOYp7tYFPUbFWraUZMbpEj/TAr06hsULHmn6
         2gpSB0ca7IsFsoIpvqxwKX9lfrYS45id9J5dSluBogljt/w8b9r8QsSVAXtDXCbxQqbZ
         E0EoK9cP5iK/XSs9HqrY350we72Xo1dmxb2zwhBdUFuPAZkM3yD3Hf8Uzi60hFDv0uDW
         7XvPPQ23MfjgkmD0cGgdXBRDu/QzsN7VF87PqiwygoFcr3SFaxpG6bU1MZc4TqSRX8mB
         MJEJd5n/4FozbFvyKBSClzVvI8YiiUXDSZRyc9fr9hlvDkv0kbIowNgX5MVqC62bNqAq
         jUDA==
X-Gm-Message-State: AOAM533ZxsSyRyx8w9wMDFeLIA5UGBmSrOv4lG7OXSiT5Y6D2C+21VVM
        ks1X5lq6oPSkFcriXpFdW1pWic1f4fNhWXtpswU=
X-Google-Smtp-Source: ABdhPJyxPrxTpNM35Qwj7n2HbzMrwZehQdRInFSjAWtmvcFGuwBf6cl7khgjsjwNPfr0lCK9XRrT3JMZSigu6oal3O4=
X-Received: by 2002:a92:d28a:: with SMTP id p10mr11421938ilp.22.1602265438286;
 Fri, 09 Oct 2020 10:43:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
 <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
 <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
 <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com>
 <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com>
 <CAJht_ENmrPbhfPaD5kkiDVWQsvA_LRndPiCMrS9zdje6sVPk=g@mail.gmail.com>
 <CA+FuTSfhDgn-Qej4HOY-kYWSy8pUsnafMk=ozwtYGfS4W2DNuA@mail.gmail.com>
 <CAJht_ENxoAyUOoiHSbFXEZ6Jf2xqfOmYfQ6Sh-hfmTUk-kTrfQ@mail.gmail.com> <CAJht_EOMQRKWfwhfqwXB3RYA1h463q43ycNjJmaGZm6RS65QGA@mail.gmail.com>
In-Reply-To: <CAJht_EOMQRKWfwhfqwXB3RYA1h463q43ycNjJmaGZm6RS65QGA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 9 Oct 2020 10:43:47 -0700
Message-ID: <CAM_iQpWRftQkOfgfMACNR_5YZxvzLJH1aMtmZNj7nJH_Wu-NRw@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 4:40 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> I found another possible issue. Shouldn't we update hard_header_len
> every time t->tun_hlen and t->hlen are updated in ipgre_link_update?

Good catch. It should be updated there like ->needed_headroom.
I will update my patch.

Thanks.
