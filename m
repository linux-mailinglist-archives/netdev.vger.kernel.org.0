Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6D716B03E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgBXT2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:28:23 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:42963 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgBXT2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:28:23 -0500
Received: by mail-yb1-f193.google.com with SMTP id z125so5170513ybf.9
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 11:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pQ/Mv1lsK35PGwG/+EQQAX4t9NIVJij/qvcmgkXlig0=;
        b=cPXMnH/CWqMNUZqfPD0rS6L9xlDNK0R07aS//51rLjkkM+TpdkJlYWJFDr+CFjNkNE
         Bhljkrch4wHeufoFrhbeG4+ghD5xhgGHnrkss+hP85z2Xv3mm5Dnm/eVO2OqOz+GNadJ
         a5dzlBqwhy8XeQ79gY2dwlbbGtR2QegDex11kpJ28betp2YxH6vkx8haV3GYchOX0TuX
         fvqaX/aVqQii0jW2an9k0ZUBrLTi97/eQf0z30yjQKSISdJ9Fs5icr8Wwp2InVsTSjA+
         EvNAPijegjWiJ4tJ+Izxdep4iTJa9mwNqwcYEy56ZYqs3XtooY1J1Y0CTGe0vXqgavNZ
         5/fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pQ/Mv1lsK35PGwG/+EQQAX4t9NIVJij/qvcmgkXlig0=;
        b=ellpFUKL2A5OFYeuolwa2jbICYI+V6wwq0gtAf09pKCEyG8jkAA+lFoSZBGR29EhNn
         Nrf0npfLPOx8+q+bKjOM3CVwh8ctSatzJMLmRGc79e4Wg+wJUSQA067PXlPShepdiqBn
         pJjcNJvgOsGwcDYtftqqk6gYeeB6aXaIeRDywy8SxQjWLdf3yNSvqpjnFN4MXRSqTbDA
         HGaS18c729tffD+eDOw6ekw1gIYg/CW2UxNyNKMeRIyudyJWMlSUAXwOR7UIjkG55xKZ
         UeVm7ipRJhXkjt9LEw5fAFYl2uc6rkMK0dnEN4ujWrN+jtre3azI3AmeC2Kk91IkssTc
         WpNg==
X-Gm-Message-State: APjAAAVkL+y9pWBIiq1k/7k3mDi2x/nCN5Xy2C//ElfVZ476wtonJeRp
        FEuK5OYHzHrd/jL0LmI3ruYLYzd4
X-Google-Smtp-Source: APXvYqwxn5ClLluWWJfJmOca90XiKpAwiSzTGmAW3Xf1v3wnqzrIjvbNAmiC+RitQio2HMKonEAhfg==
X-Received: by 2002:a25:7810:: with SMTP id t16mr45100054ybc.453.1582572501520;
        Mon, 24 Feb 2020 11:28:21 -0800 (PST)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id p6sm5421228ywi.63.2020.02.24.11.28.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 11:28:20 -0800 (PST)
Received: by mail-yb1-f177.google.com with SMTP id g206so4229155ybg.11
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 11:28:20 -0800 (PST)
X-Received: by 2002:a25:cc8a:: with SMTP id l132mr8632212ybf.178.1582572499831;
 Mon, 24 Feb 2020 11:28:19 -0800 (PST)
MIME-Version: 1.0
References: <20200224132550.2083-1-anton.ivanov@cambridgegreys.com>
In-Reply-To: <20200224132550.2083-1-anton.ivanov@cambridgegreys.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 24 Feb 2020 14:27:42 -0500
X-Gmail-Original-Message-ID: <CA+FuTSd8P6uQnwisZEh7+nfowW9qKLBEvA4GPg+xUkjBa-6TDA@mail.gmail.com>
Message-ID: <CA+FuTSd8P6uQnwisZEh7+nfowW9qKLBEvA4GPg+xUkjBa-6TDA@mail.gmail.com>
Subject: Re: [PATCH v3] virtio: Work around frames incorrectly marked as gso
To:     anton.ivanov@cambridgegreys.com
Cc:     Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-um@lists.infradead.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 8:26 AM <anton.ivanov@cambridgegreys.com> wrote:
>
> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>
> Some of the locally generated frames marked as GSO which
> arrive at virtio_net_hdr_from_skb() have no GSO_TYPE, no
> fragments (data_len = 0) and length significantly shorter
> than the MTU (752 in my experiments).

Do we understand how these packets are generated? Else it seems this
might be papering over a deeper problem.

The stack should not create GSO packets less than or equal to
skb_shinfo(skb)->gso_size. See for instance the check in
tcp_gso_segment after pulling the tcp header:

        mss = skb_shinfo(skb)->gso_size;
        if (unlikely(skb->len <= mss))
                goto out;

What is the gso_type, and does it include SKB_GSO_DODGY?
