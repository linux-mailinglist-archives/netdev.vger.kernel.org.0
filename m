Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B00724025D
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 09:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHJHVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 03:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgHJHVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 03:21:40 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD88C061786
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 00:21:39 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id j188so3311175vsd.2
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 00:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EZuLaH0X1DjxkMIYvUZjBNQpk5tuEvtJPSM7s3zpgVA=;
        b=Vqsl98sYIlry7YsaqgssuM5FYIzcM1D1osf7noHDmEMsN0q9nuXfpONaiOGWw4ZjNC
         GxhEAINLCMhMJDXOQSwp0eT1EuzFIPK7K9sBVCA7MqB9w8S9as0fdMVPzkQztlI+7WOt
         /rNLveVzyktnS6wtY82qfRfX2+vhRGoSTiY3sFsqzzrUVCALKkg6UEDeAAEwvLaSoBsr
         XI4q4keaf/eP45qsUCtETI3Z8DZP3nBImstSbgruJmYJ4/vZGz2l0dj4nlPSEblvxSRT
         6WN9Zy9y9GA/sLzBO/UHTY4UZ6sLECmSe7Fky3fjpNkkWQyi3isxhpzHbDgcYc+Njtee
         WPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EZuLaH0X1DjxkMIYvUZjBNQpk5tuEvtJPSM7s3zpgVA=;
        b=iHuFF0BCGkZjBDYNmLHUxKSmkiWcIexKo6wux0IKJSSSDON84xr9gec8Wuf6ieY7x7
         CIfwkQNmp95g2N8zE+Jhc+D3nQi72xubu+LnTi8LiNVoZcvB4JE8n3DYX19JwtnYvqTC
         HoOJ6OE4s8XoU8o8w3vkfK2uLeOc7N0b+yXipB7ok+AyenyXLuoAovO39vIo+u73088U
         fBCeHqKTU0LASe4cZ+joSBOJAhBjBCqYYHyqGb/gLqOF9rTrQKYB3ZNbAmJUAYCbfamD
         0VSTX6fJaqcXgYWW1+NZwLx/SSMNkvY247WEYEnB9c55004viqVbmYYLl/mP2nqLxjZy
         MVIQ==
X-Gm-Message-State: AOAM531lSYmUYnLH5CKksKp7jLdfbHKom1ak9weJsnIhx8KLaoHm5b6m
        4MMSX2sdRkGY6Tl3llqPLIAINInmMIw=
X-Google-Smtp-Source: ABdhPJxDsI7uMgecfllTF4Gz0w8siq77tS4lZMcPCMTZwXCZm13/xTRjWj0sMZaTIz47ViNdbCzpaQ==
X-Received: by 2002:a67:ce12:: with SMTP id s18mr18683254vsl.116.1597044096601;
        Mon, 10 Aug 2020 00:21:36 -0700 (PDT)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id p5sm4722167vkp.44.2020.08.10.00.21.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 00:21:35 -0700 (PDT)
Received: by mail-vs1-f51.google.com with SMTP id b26so3711274vsa.13
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 00:21:35 -0700 (PDT)
X-Received: by 2002:a67:bb06:: with SMTP id m6mr19237225vsn.54.1597044094565;
 Mon, 10 Aug 2020 00:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200809023548.684217-1-xie.he.0141@gmail.com>
 <CA+FuTSe-FaQFn4WNvVPJ1v+jVZAghgd1AZc-cWn2+GjPR4GzVQ@mail.gmail.com> <CAJht_EOao3-kA-W-SdJqKRiFMAFUxw7OARFGY5DL8pXvKd4TLw@mail.gmail.com>
In-Reply-To: <CAJht_EOao3-kA-W-SdJqKRiFMAFUxw7OARFGY5DL8pXvKd4TLw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 10 Aug 2020 09:20:56 +0200
X-Gmail-Original-Message-ID: <CA+FuTSc7c+XTDU10Bh1ZviQomHgiTjiUvOO0iR1X95rq61Snrg@mail.gmail.com>
Message-ID: <CA+FuTSc7c+XTDU10Bh1ZviQomHgiTjiUvOO0iR1X95rq61Snrg@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/x25_asy: Added needed_headroom and a
 skb->len check
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 9, 2020 at 8:08 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Sun, Aug 9, 2020 at 2:13 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > The patch is analogous to commit c7ca03c216ac
> > ("drivers/net/wan/lapbether: Added needed_headroom and a skb->len
> > check").

Acked-by: Willem de Bruijn <willemb@google.com>

> >
> > Seems to make sense based on call stack
> >
> >   x25_asy_xmit               // skb_pull(skb, 1)
> >   lapb_data_request
> >   lapb_kick
> >   lapb_send_iframe        // skb_push(skb, 2)
> >   lapb_transmit_buffer    // skb_push(skb, 1)
> >   lapb_data_transmit
> >   x25_asy_data_transmit
> >   x25_asy_encaps
>
> Thank you!
>
> > But I frankly don't know this code and would not modify logic that no
> > one has complained about for many years without evidence of a real
> > bug.
>
> Maybe it's better to submit this patch to "net-next"?

That depends on whether this solves a bug. If it is possible to send a
0 byte packet and make ndo_start_xmit read garbage, then net is the
right target.

> I want to do this change because:
>
> 1) I hope to set needed_headroom properly for all three X.25 drivers
> (lapbether, x25_asy, hdlc_x25) in the kernel. So that the upper layer
> (net/x25) can be changed to use needed_headroom to allocate skb,
> instead of the current way of using a constant to estimate the needed
> headroom.

Which constant, X25_MAX_L2_LEN?

> 2) The code quality of this driver is actually very low, and I also
> hope to improve it gradually. Actually this driver had been completely
> broken for many years and no one had noticed this until I fixed it in
> commit 8fdcabeac398 (drivers/net/wan/x25_asy: Fix to make it work)
> last month.

Just curious: how come that netif_rx could be removed?

> This driver has a lot of other issues and I wish I can
> gradually fix them, too.
>
> > Were you able to actually exercise this path, similar to lapb_ether:
> > configure the device, send data from a packet socket? If so, can you
> > share the configuration steps?
>
> Yes, I can run this driver. The driver is a software driver that runs
> over TTY links. We can set up a x25_asy link over a virtual TTY link
> using this method:
>
> First:
>   sudo modprobe lapb
>   sudo modprobe x25_asy
>
> Then set up a virtual TTY link:
>   socat -d -d pty,cfmakeraw pty,cfmakeraw &
> This will open a pair of PTY ports.
> (The "socat" program can be installed from package managers.)
>
> Then use a C program to set the line discipline for the two PTY ports:
> Simplified version for reading:
>   int ldisc = N_X25;
>   int fd = open("path/to/pty", O_RDWR);
>   ioctl(fd, TIOCSETD, &ldisc);
>   close(fd);
> Complete version for running:
>   https://github.com/hyanggi/testing_linux/blob/master/network_x25/lapb/set_ldisc.c
> Then we'll get two network interfaces named x25asy0 and x25asy1.
>
> Then we do:
>   sudo ip link set x25asyN up
> to bring them up.
>
> After we set up this x25_asy link, we can test it using AF_PACKET sockets:
>
> In the connected-side C program:
> Complete version for running:
>   https://github.com/hyanggi/testing_linux/blob/master/network_x25/lapb/receiver.c
> Simplified version for reading:
>   int sockfd = socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_ALL));
>
>   /* Get interface index */
>   struct ifreq ifr;
>   strcpy(ifr.ifr_name, "interface_name");
>   ioctl(sockfd, SIOCGIFINDEX, &ifr);
>   int ifindex = ifr.ifr_ifindex;
>
>   struct sockaddr_ll sender_addr;
>   socklen_t sender_addr_len = sizeof sender_addr;
>   char buffer[1500];
>
>   while (1) {
>       ssize_t length = recvfrom(sockfd, buffer, sizeof buffer, 0,
>                                 (struct sockaddr *)&sender_addr,
>                                 &sender_addr_len);
>       if (sender_addr.sll_ifindex != ifindex)
>           continue;
>       else if (buffer[0] == 0)
>           printf("Data received.\n");
>       else if (buffer[0] == 1)
>           printf("Connected by the other side.\n");
>       else if (buffer[0] == 2) {
>           printf("Disconnected by the other side.\n");
>           break;
>       }
>   }
>
>   close(sockfd);
>
> In the connecting-side C program:
> Complete version for running:
>   https://github.com/hyanggi/testing_linux/blob/master/network_x25/lapb/sender.c
> Simplified version for reading:
>   int sockfd = socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_ALL));
>
>   /* Get interface index */
>   struct ifreq ifr;
>   strcpy(ifr.ifr_name, "interface_name");
>   ioctl(sockfd, SIOCGIFINDEX, &ifr);
>   int ifindex = ifr.ifr_ifindex;
>
>   struct sockaddr_ll addr = {
>       .sll_family = AF_PACKET,
>       .sll_ifindex = ifindex,
>   };
>
>   /* Connect */
>   sendto(sockfd, "\x01", 1, 0, (struct sockaddr *)&addr, sizeof addr);
>
>   /* Send data */
>   sendto(sockfd, "\x00" "data", 5, 0, (struct sockaddr *)&addr,
>          sizeof addr);
>
>   sleep(1); /* Wait a while before disconnecting */
>
>   /* Disconnect */
>   sendto(sockfd, "\x02", 1, 0, (struct sockaddr *)&addr, sizeof addr);
>
>   close(sockfd);
>
> I'm happy to answer any questions. Thank you so much!

Thanks very much for the detailed reproducer.

One thing to keep in mind is that AF_PACKET sockets are not the normal
datapath. AF_X25 sockets are. But you mention that you also exercise
the upper layer? That gives confidence that these changes are not
accidentally introducing regressions for the default path while fixing
oddly crafted packets with (root only for a reason) packet sockets.
