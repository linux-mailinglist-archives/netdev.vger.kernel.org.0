Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DF023FFA6
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 20:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgHISIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 14:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgHISIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 14:08:30 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E288BC061756;
        Sun,  9 Aug 2020 11:08:29 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t11so3644529plr.5;
        Sun, 09 Aug 2020 11:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JnI5Zda2G6GYzjf6JkoUbCC57qTcJy2fyAg+UqYB/Gc=;
        b=KrPOsivd52k3uRBpvnaL6ipW32/RWHfoKtJrXmeYT46EeIG0bGjYBSP0tl41cVDLLp
         frmxxiHIYxmdccRYz8HqEOrGbU9T9GQB1vhCN3iDAoxsOaBWX+4XPf6FbQg2jjG8dKDa
         sD6zfDsHO1hvkuGUwZ6TZs2AWSF5g2VeJ8FoZp6jARgRqS2T88joPDghqisWRktZ5Ds4
         VNJFaTPYe8vKVsQDSskcG1sHTSDw0MGbZDmm09PI50r18uqXhXgY9xjmo2CMqdow/na2
         XQ/WW/qEn+4tMxrzLDjzDFloHwmNtQaJ1EpKRsGNWxgZMw2H2T+YFkje8lEzw2Et2I1t
         in/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JnI5Zda2G6GYzjf6JkoUbCC57qTcJy2fyAg+UqYB/Gc=;
        b=HZ2VOeHfMsfR0TTrI/nBJUfMLolw+Pz12WYEeaI6uaN2zYu8ZquOIyWB7EpSZr1vnD
         gVJDGgpv+ziYvda7FmeTagYceXSIP5uD8IGsm3RP2ocqCopEwR3FNmShcxy/k/6dK1me
         Veq5qCh5HEmVm0/vPJdhhpGiIsVH0T+/F6uWdlODKxznEDKVyG5Nt6OllwgZU2m7g2dS
         mptRXNP/I22E5AgR2eaGoNvFbVsXlBzoa0C3HrnvkkwyXKS41DXX7rm+/HoxrNtl+3AY
         dlTVWzetMUpR6LK2aiKVWXII7chVl1NpcLP0pANeOKC5VS9v2byrgKAUDcp2K9p8VVfO
         zm2g==
X-Gm-Message-State: AOAM532eY6uy8UdDwG4ORG557WFV6w2vPQajJ0p5LZ2z9qgMl0bAhxqJ
        vMnXVRtaL3hO6NzvZimVEChwDdYXpX1jjYrAMBE=
X-Google-Smtp-Source: ABdhPJzED3XmzqhRh4kzg2qkgCOwR+LnbWeo4Pfv/BBRYx9zI08It7pN0avUmV1KLJnHPrnrDKLI9cEf13r+bbSoH/A=
X-Received: by 2002:a17:90b:11c4:: with SMTP id gv4mr23059546pjb.198.1596996509272;
 Sun, 09 Aug 2020 11:08:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200809023548.684217-1-xie.he.0141@gmail.com> <CA+FuTSe-FaQFn4WNvVPJ1v+jVZAghgd1AZc-cWn2+GjPR4GzVQ@mail.gmail.com>
In-Reply-To: <CA+FuTSe-FaQFn4WNvVPJ1v+jVZAghgd1AZc-cWn2+GjPR4GzVQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 9 Aug 2020 11:08:18 -0700
Message-ID: <CAJht_EOao3-kA-W-SdJqKRiFMAFUxw7OARFGY5DL8pXvKd4TLw@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/x25_asy: Added needed_headroom and a
 skb->len check
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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

On Sun, Aug 9, 2020 at 2:13 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> The patch is analogous to commit c7ca03c216ac
> ("drivers/net/wan/lapbether: Added needed_headroom and a skb->len
> check").
>
> Seems to make sense based on call stack
>
>   x25_asy_xmit               // skb_pull(skb, 1)
>   lapb_data_request
>   lapb_kick
>   lapb_send_iframe        // skb_push(skb, 2)
>   lapb_transmit_buffer    // skb_push(skb, 1)
>   lapb_data_transmit
>   x25_asy_data_transmit
>   x25_asy_encaps

Thank you!

> But I frankly don't know this code and would not modify logic that no
> one has complained about for many years without evidence of a real
> bug.

Maybe it's better to submit this patch to "net-next"? I want to do
this change because:

1) I hope to set needed_headroom properly for all three X.25 drivers
(lapbether, x25_asy, hdlc_x25) in the kernel. So that the upper layer
(net/x25) can be changed to use needed_headroom to allocate skb,
instead of the current way of using a constant to estimate the needed
headroom.

2) The code quality of this driver is actually very low, and I also
hope to improve it gradually. Actually this driver had been completely
broken for many years and no one had noticed this until I fixed it in
commit 8fdcabeac398 (drivers/net/wan/x25_asy: Fix to make it work)
last month. This driver has a lot of other issues and I wish I can
gradually fix them, too.

> Were you able to actually exercise this path, similar to lapb_ether:
> configure the device, send data from a packet socket? If so, can you
> share the configuration steps?

Yes, I can run this driver. The driver is a software driver that runs
over TTY links. We can set up a x25_asy link over a virtual TTY link
using this method:

First:
  sudo modprobe lapb
  sudo modprobe x25_asy

Then set up a virtual TTY link:
  socat -d -d pty,cfmakeraw pty,cfmakeraw &
This will open a pair of PTY ports.
(The "socat" program can be installed from package managers.)

Then use a C program to set the line discipline for the two PTY ports:
Simplified version for reading:
  int ldisc = N_X25;
  int fd = open("path/to/pty", O_RDWR);
  ioctl(fd, TIOCSETD, &ldisc);
  close(fd);
Complete version for running:
  https://github.com/hyanggi/testing_linux/blob/master/network_x25/lapb/set_ldisc.c
Then we'll get two network interfaces named x25asy0 and x25asy1.

Then we do:
  sudo ip link set x25asyN up
to bring them up.

After we set up this x25_asy link, we can test it using AF_PACKET sockets:

In the connected-side C program:
Complete version for running:
  https://github.com/hyanggi/testing_linux/blob/master/network_x25/lapb/receiver.c
Simplified version for reading:
  int sockfd = socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_ALL));

  /* Get interface index */
  struct ifreq ifr;
  strcpy(ifr.ifr_name, "interface_name");
  ioctl(sockfd, SIOCGIFINDEX, &ifr);
  int ifindex = ifr.ifr_ifindex;

  struct sockaddr_ll sender_addr;
  socklen_t sender_addr_len = sizeof sender_addr;
  char buffer[1500];

  while (1) {
      ssize_t length = recvfrom(sockfd, buffer, sizeof buffer, 0,
                                (struct sockaddr *)&sender_addr,
                                &sender_addr_len);
      if (sender_addr.sll_ifindex != ifindex)
          continue;
      else if (buffer[0] == 0)
          printf("Data received.\n");
      else if (buffer[0] == 1)
          printf("Connected by the other side.\n");
      else if (buffer[0] == 2) {
          printf("Disconnected by the other side.\n");
          break;
      }
  }

  close(sockfd);

In the connecting-side C program:
Complete version for running:
  https://github.com/hyanggi/testing_linux/blob/master/network_x25/lapb/sender.c
Simplified version for reading:
  int sockfd = socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_ALL));

  /* Get interface index */
  struct ifreq ifr;
  strcpy(ifr.ifr_name, "interface_name");
  ioctl(sockfd, SIOCGIFINDEX, &ifr);
  int ifindex = ifr.ifr_ifindex;

  struct sockaddr_ll addr = {
      .sll_family = AF_PACKET,
      .sll_ifindex = ifindex,
  };

  /* Connect */
  sendto(sockfd, "\x01", 1, 0, (struct sockaddr *)&addr, sizeof addr);

  /* Send data */
  sendto(sockfd, "\x00" "data", 5, 0, (struct sockaddr *)&addr,
         sizeof addr);

  sleep(1); /* Wait a while before disconnecting */

  /* Disconnect */
  sendto(sockfd, "\x02", 1, 0, (struct sockaddr *)&addr, sizeof addr);

  close(sockfd);

I'm happy to answer any questions. Thank you so much!
