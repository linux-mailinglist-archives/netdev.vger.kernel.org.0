Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E52E23FD86
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 11:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgHIJNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 05:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgHIJNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 05:13:13 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D812C061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 02:13:13 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id b26so2812376vsa.13
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 02:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r+74zSb8Mdp9nDMJHIbR9g9Xvn68Ir31r0eIPx9VKJQ=;
        b=uCfT5JrYlSPG0FEa68vEPgOHLYMvfbUL6H6bDMPguXZp/Qlh6YGNBBSj7uXfYtckc3
         cCO8ZypmSwK+tFs6jZQZ8bV5QoFG6dMLcGwBbYmTjQcJwhzbAZy1FuTLz8rCe1U3HJeC
         zKvA5bxJpLgNBw3IKo6tBM7xvaAiyNa4gqbUktEbvi/BpJLo4OBC3d6nFRRMLvo0jYFV
         mPIozp32zeE+OPwRs8ihRtN221ms6sh5PQG6jmDjxMWrjY1xXxJxA5cEv4MHobpF6mWm
         6+gT3Jq0cUI/PRGxlQM9zzh+6uviWzHh/PFTNjQmhz9Z6vZaU+wg6EVnCUNC5JBQVOpM
         bM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r+74zSb8Mdp9nDMJHIbR9g9Xvn68Ir31r0eIPx9VKJQ=;
        b=ZLo7DSF/qxkSyJgMvJgD/zFU/93GI+IUxyr9z/ofiRUj+Bb3K6a0J2gAa/WqkV4vPz
         c40uF4JPlH1sgP9+lCCtNVohG6k87oBb0ZDUhygO4BZcULgccrG/PlAAydAq5QWxO/aw
         iepun6JL9FXeqYcCvxIe+XWlJzt6ncHwCEcTRo8fnIvOawRrezjwLtwK819gFd/dTFec
         7YzBWlHcQPWCzkIaW3sEzDLKKTUrEf94CwKAkmXaS/5Mv4Xb2TcQbpSqvpLSmlCSbCpR
         jR30QpaHlESQDdYb2OmQeqxOofHhnghoPg+Ys4ZHfNBFMPEmG7u+eTjEOoULcOc4SLZs
         SCbw==
X-Gm-Message-State: AOAM533CWIKw/nG/Rfx80AXb+3IqBS0BmLlkrMz3QetqqD+wrRvXXnRA
        K9f03gN5Ix7FMQE3jKTqEGyu/aYhM+A=
X-Google-Smtp-Source: ABdhPJxZDh06dlBG5fhrv7XFkwamznOC++892jn4vEsu/Y4D+zV9btMz4uBsr4Ali9Gl1dfeutrHVw==
X-Received: by 2002:a67:3349:: with SMTP id z70mr254820vsz.93.1596964391468;
        Sun, 09 Aug 2020 02:13:11 -0700 (PDT)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id e127sm3338003vkg.5.2020.08.09.02.13.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 02:13:10 -0700 (PDT)
Received: by mail-vs1-f44.google.com with SMTP id p8so2817930vsm.12
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 02:13:10 -0700 (PDT)
X-Received: by 2002:a05:6102:517:: with SMTP id l23mr15265082vsa.114.1596964389659;
 Sun, 09 Aug 2020 02:13:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200809023548.684217-1-xie.he.0141@gmail.com>
In-Reply-To: <20200809023548.684217-1-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 9 Aug 2020 11:12:33 +0200
X-Gmail-Original-Message-ID: <CA+FuTSe-FaQFn4WNvVPJ1v+jVZAghgd1AZc-cWn2+GjPR4GzVQ@mail.gmail.com>
Message-ID: <CA+FuTSe-FaQFn4WNvVPJ1v+jVZAghgd1AZc-cWn2+GjPR4GzVQ@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/x25_asy: Added needed_headroom and a
 skb->len check
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 9, 2020 at 4:36 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> 1. Added a skb->len check
>
> This driver expects upper layers to include a pseudo header of 1 byte
> when passing down a skb for transmission. This driver will read this
> 1-byte header. This patch added a skb->len check before reading the
> header to make sure the header exists.
>
> 2. Added needed_headroom
>
> When this driver transmits data,
>   first this driver will remove a pseudo header of 1 byte,
>   then the lapb module will prepend the LAPB header of 2 or 3 bytes.
> So the value of needed_headroom in this driver should be 3 - 1.
>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

The patch is analogous to commit c7ca03c216ac
("drivers/net/wan/lapbether: Added needed_headroom and a skb->len
check").

Seems to make sense based on call stack

  x25_asy_xmit               // skb_pull(skb, 1)
  lapb_data_request
  lapb_kick
  lapb_send_iframe        // skb_push(skb, 2)
  lapb_transmit_buffer    // skb_push(skb, 1)
  lapb_data_transmit
  x25_asy_data_transmit
  x25_asy_encaps

But I frankly don't know this code and would not modify logic that no
one has complained about for many years without evidence of a real
bug.

Were you able to actually exercise this path, similar to lapb_ether:
configure the device, send data from a packet socket? If so, can you
share the configuration steps?
