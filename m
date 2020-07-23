Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C396722B48A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 19:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgGWROS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 13:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgGWROS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 13:14:18 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC66C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 10:14:17 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id s16so4934982qtn.7
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 10:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AcRBZCh4ZxTEj1824W5EyVGwXBIHLl8Sf1rmiTV9eZA=;
        b=uPmZAdnH4NEo83XzqZBAfEheTzgJu9CPY9OdESukNB81bnWg3iqi1QSuvgZF+ronS8
         EkDuVQhbD6yi2TlOH16EsRUEPp+ChSCZ4yqiMFWMb7ZLcyoD1tBdx4hLbmZz5FW7k26k
         p8LZZykcgi2ML5QaMZJy43J3ZDmeETs7bqlriX9Qb5fihZV9U3bHCLA9ZyFFIiMUPqjl
         ORT2TK+P16vgn17ZTXCiwNmZ7nldsFVsrwMAwee2wOFuKdD2JT9eNCuhaxmfjWMDRyqd
         CyR1mKyy27ml9+4eazGcN53UlyPAi0hcMlFyHb19PR7xvfc82O/QhkVWQdK3TDP6f1n/
         RpRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AcRBZCh4ZxTEj1824W5EyVGwXBIHLl8Sf1rmiTV9eZA=;
        b=V/PHf9oEXytJc4xRbCCdlPeNR7ivvLf4nppVbLz9vTziOCU+M6pQdecrLrK9QfZtn4
         jm52g1iRsdFCXJYhsu+CYyaX9jLq5sonORAAT55zwzrt4YZBeBgCebGqM0rIgfpmdp+Z
         jm/RB7Sj3x5iZlNlazhz96ssJGmQSM0TFn5qUfmlxVwt847LHkAbMj/ARCsH02SqN+9D
         YmoO4SThj8t7ZzmrgHrVd+gs3VW4NKUJWQHcIwA8U2whrVjZ+dksH70866MEx9hmYByv
         v8tRsZqyM6ldhuFACQ+gzn5qmzqzOAxS/9BWuQeu59PgaiIrMlHoZUTLeF4432bLZijB
         ZKgQ==
X-Gm-Message-State: AOAM533/JRemXJa/W7OfhAZXti+aSwPltTlMd9tamEtgTDm7TIgMuKpV
        NBTGhvWi6ZB7YQgnxawyCYbSLB2d
X-Google-Smtp-Source: ABdhPJzX+ddLt9JNzCIBDCR9a9PZGrDuWiQSf9uk5pB9pO5lD8kcNHt6pj2soGbcPQRcFE4nOabDsQ==
X-Received: by 2002:ac8:7a9a:: with SMTP id x26mr5226636qtr.161.1595524456634;
        Thu, 23 Jul 2020 10:14:16 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id c205sm3188057qkg.98.2020.07.23.10.14.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 10:14:15 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id x138so3210275ybg.9
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 10:14:15 -0700 (PDT)
X-Received: by 2002:a25:4886:: with SMTP id v128mr7909336yba.53.1595524455073;
 Thu, 23 Jul 2020 10:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200723143357.451069-1-willemdebruijn.kernel@gmail.com>
 <20200723143357.451069-4-willemdebruijn.kernel@gmail.com> <20200723094401.58e8fe0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200723094401.58e8fe0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 23 Jul 2020 13:13:38 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeURsBsdoo5mCHpP_VJzJuOGgb8FB4Rc0noJJGeB2T-2A@mail.gmail.com>
Message-ID: <CA+FuTSeURsBsdoo5mCHpP_VJzJuOGgb8FB4Rc0noJJGeB2T-2A@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] icmp6: support rfc 4884
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 12:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 23 Jul 2020 10:33:57 -0400 Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Extend the rfc 4884 read interface introduced for ipv4 in
> > commit eba75c587e81 ("icmp: support rfc 4884") to ipv6.
> >
> > Add socket option SOL_IPV6/IPV6_RECVERR_RFC4884.
> >
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
>
> net/ipv6/datagram.c:288:6: warning: symbol 'ipv6_icmp_error_rfc4884' was not declared. Should it be static?

Oops. Thanks Jakub.

I'll wait a day before respinning, in case of other feedback.
