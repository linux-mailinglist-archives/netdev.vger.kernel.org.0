Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F241C4B6C20
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 13:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237655AbiBOMiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 07:38:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiBOMiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 07:38:17 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F7E69CF8;
        Tue, 15 Feb 2022 04:38:07 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id l125so22431923ybl.4;
        Tue, 15 Feb 2022 04:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=R9vhyJh6Jc7bd+DxxGEFFu5LM3pzvH0HiXPe/xtg9ak=;
        b=j7aOCyl69mieXDVfXhDqtYhyCXIEcbhSttf4Qv8UGwG3QaMnaE5Pv4fRrhD3gOiJSR
         U6XNbfgEzWVqeZAi8HzM7WViDjr68tjGJqbYGT8V8YIfVopSI8JjTaLhAfSZ6PIvEUM0
         k07U4CZNEAThrzGJow8AQ+b1L5Pn7W+oqmuQmXrglTX0ovIciXtmSlBbeCO8b/Oq91P+
         OgZsTkCpV1nSJLf3RlrZlOTRc1/AjZ+G5tHN84fktjd5WxRkdvXI8Y253Ez8KGyKcohh
         zyynOyyfESOYI/AaOl1xZBhNSwANoK+JgEbENXAc0LHnQVUjUTuufBGo9wIN+X/9v7ai
         g4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=R9vhyJh6Jc7bd+DxxGEFFu5LM3pzvH0HiXPe/xtg9ak=;
        b=fnXXl6pcw7xxmEXTjBc1J7qA868TiZtQzcUT4GCzjLHC1UEoX0x+MJSjULgjV8n80s
         Pnj5kqdwiAe3JzmXFyHaP7QGdAHOIdv6frlcRNGBrRAhTJR9pIU8bqIoCkNQzHBahqWt
         p/QwevD1x4iQf1qSmks3U4u5Wzcvvi3Aa3HuX5GD4Idk87N5QOc0UqoR3d1zJgawtk7B
         nNCBB+1GBdevDAY0zRaV5iJ0PFDccqyxINaGjhD+zSywhYWccH8e9c5F+xg1x2zob3k4
         frKQJLthV1z0XVcJum/e9TzAZNRTRPtZA1cPp0fTvRojUqImBKdnGo/1P46C1Wce6lDY
         aj/Q==
X-Gm-Message-State: AOAM5305ehF6I1BjN7nu8PvK/v/aTMWyICQ+ZmorUhRifblG5VxbljV4
        72LmJoBGaP20bNwqGByH+SGjhMeYDstdATklmg==
X-Google-Smtp-Source: ABdhPJyaCOLCaS0Gw4oOy7lrmZuktaQxSNwc8VkOnhPjWU6IHYX7dmQ1uZ3ZcqLis7y9A7RBfwbc3Qa2PtelQZATmDM=
X-Received: by 2002:a25:610f:: with SMTP id v15mr1768318ybb.236.1644928686895;
 Tue, 15 Feb 2022 04:38:06 -0800 (PST)
MIME-Version: 1.0
From:   Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Date:   Tue, 15 Feb 2022 20:37:56 +0800
Message-ID: <CAA-qYXiUFi5atN8tGRdORbiGqWnbdquuAeKuwdpWSVFVO2FveA@mail.gmail.com>
Subject: 4 missing check bugs
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        shenwenbosmile@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

Hi, our tool finds several missing check bugs on
Linux kernel v4.18.5 using static analysis.
We are looking forward to having more experts' eyes on this. Thank you!

Before calling sk_alloc() with SOCK_RAW type,
there should be a permission check, ns_capable(ns,CAP_NET_RAW).
For example,

static int xsk_create(struct net *net, struct socket *sock, int protocol,
      int kern)
{
struct xdp_sock *xs;
struct sock *sk;

if (!ns_capable(net->user_ns, CAP_NET_RAW))
return -EPERM;
if (sock->type != SOCK_RAW)
return -ESOCKTNOSUPPORT;
...
sk = sk_alloc(net, PF_XDP, GFP_KERNEL, &xsk_proto, kern);
if (!sk)
return -ENOBUFS;
...
}



We find 4 missing check bugs.
The functions that miss permission checks in v4.18.5:

net/bluetooth/hidp/sock.c
static int hidp_sock_create(struct net *net, struct socket *sock, int protocol,
    int kern)
{
struct sock *sk;

BT_DBG("sock %p", sock);

if (sock->type != SOCK_RAW)
return -ESOCKTNOSUPPORT;

sk = sk_alloc(net, PF_BLUETOOTH, GFP_ATOMIC, &hidp_proto, kern);
if (!sk)
return -ENOMEM;
...
}


net/bluetooth/cmtp/sock.c
static int cmtp_sock_create(struct net *net, struct socket *sock, int protocol,
    int kern)
{
struct sock *sk;

BT_DBG("sock %p", sock);

if (sock->type != SOCK_RAW)
return -ESOCKTNOSUPPORT;

sk = sk_alloc(net, PF_BLUETOOTH, GFP_ATOMIC, &cmtp_proto, kern);
if (!sk)
return -ENOMEM;
...
}


net/bluetooth/hci_sock.c
static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
   int kern)
{
struct sock *sk;

BT_DBG("sock %p", sock);

if (sock->type != SOCK_RAW)
return -ESOCKTNOSUPPORT;

sock->ops = &hci_sock_ops;

sk = sk_alloc(net, PF_BLUETOOTH, GFP_ATOMIC, &hci_sk_proto, kern);
if (!sk)
return -ENOMEM;
...
}


/net/bluetooth/bnep/sock.c
static int bnep_sock_create(struct net *net, struct socket *sock, int protocol,
    int kern)
{
struct sock *sk;

BT_DBG("sock %p", sock);

if (sock->type != SOCK_RAW)
return -ESOCKTNOSUPPORT;

sk = sk_alloc(net, PF_BLUETOOTH, GFP_ATOMIC, &bnep_proto, kern);
if (!sk)
return -ENOMEM;
...
}


Thanks again!


Best regards,
Jinmeng Zhou
