Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96738642897
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 13:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiLEMiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 07:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiLEMiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 07:38:06 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844C8FCC
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 04:38:05 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s7so10657562plk.5
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 04:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oULosjxtQWAOUnMS200zpvrZnlxjLmjJWBQnFFohIW8=;
        b=fNzcTBBoD8ASJGx8TWqJH/loORjDIHPk2VwxN8bBUudGF5oOPEkb16RufbHqPwDSDN
         zsfgBR0xedcL14j2d/YFoPMz/jFgvpLyyo96ODuvHoWqNnUeoU8JSpsEwQJKU9fFAuCc
         45U60Ad9N2xJfOaEPfkwmrYTT6El2JPZzPMF5dr33SlOsx6nvQ+num+C1ozjw/4HfCVU
         CJmmtp4A90aAdfN5Yo3fHpKt3PE9lA6jntuhUeHasa8fbtmqYRd7bWZ44aU9pD/urU4g
         78cHTUkyKuRsdwoIQM1TbfFyq/9Zr7sMexR2UEeNtqWvzkNizJKCIlpnwq7ItnbWI+Lv
         Jr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oULosjxtQWAOUnMS200zpvrZnlxjLmjJWBQnFFohIW8=;
        b=tF7DZjlM40DqSO2UH4P5iCfhKsfCTV2pBU/sJPWvsTBpqz8PFJ3KwNVbrr/7fpltjS
         yGoi9ZQoWugvV0aabV5EHz7RnXXJn4bSXlWZPPP47eEzwmK88cuPtWWQ+UtcMAwmFs7S
         JVCvfBUVd7A6RZ9oEQ6Q0jAEql2lZebLqsmNFid/EwuS4em6WMYaDgk2nopyl403RHyI
         onGRDWOcosJxf09IRikErIizIzDmbcNLm3CRCVYOgKoYRf2j6Ug1I7OflzlzeSy3ksZP
         36h4lEetpNAkP8/abj+xffzycTDzSu7fAQvDZlYSzMSvgJrO5AXk84M/g/+ZBtwPj3Gn
         9xig==
X-Gm-Message-State: ANoB5pmQmVr0TeB5XomCs6NOTXDkvv5Vrup2HOd9mRz19hZcmhYNv5kQ
        dyH/9AvkoarXsKKO5KO2MB4=
X-Google-Smtp-Source: AA0mqf5qgKDQd8UJ3dFv0rfCtsEYdNyiZ9OzDWbXsaxU6DIluRf0dou+WltJ4m4eshCLHwfo4luehw==
X-Received: by 2002:a17:90a:2f22:b0:219:8ee5:8dc0 with SMTP id s31-20020a17090a2f2200b002198ee58dc0mr16130428pjd.72.1670243884985;
        Mon, 05 Dec 2022 04:38:04 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mm8-20020a17090b358800b00200461cfa99sm11019311pjb.11.2022.12.05.04.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 04:38:03 -0800 (PST)
Date:   Mon, 5 Dec 2022 20:37:57 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Parkin <tparkin@katalix.com>,
        Haowei Yan <g1042620637@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with
 sk_callback_lock
Message-ID: <Y43mJUHWE5+9t2Ak@Laptop-X1>
References: <20221114191619.124659-1-jakub@cloudflare.com>
 <Y4nKX8IXjHLSVHnz@Laptop-X1>
 <87y1rmhyc2.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y1rmhyc2.fsf@cloudflare.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 11:24:39AM +0100, Jakub Sitnicki wrote:
> > Hi Jakub,
> >
> > I have a similar issue with vxlan driver. Similar with commit
> > ad6c9986bcb6 ("vxlan: Fix GRO cells race condition between receive and link
> > delete"). There is still a race condition on vxlan that when receive a packet
> > while deleting a VXLAN device. In vxlan_ecn_decapsulate(), the
> > vxlan_get_sk_family() call panic as sk is NULL.
> >
> > So I'm wondering if we should also have locks in udp_tunnel_sock_release().
> > Or should we add a checking in sk state before calling vxlan_get_sk_family()?
> 
> This is how like to think about it:
> 
> To know when it is safe to load vs->sock->sk->sk_family, we have to ask:
> 
> 1. What ensures that the objects remain alive/valid in our scope?
> 2. What protects the objects from being mutated?
> 
> In case of vxlan_sock object in the context of vxlan_ecn_decapsulate():
> 
> 1. We are in an RCU read side section (ip_local_deliver_finish).
> 2. RCU-protected objects are not to be mutated while readers exist.
> 
> The classic "What is RCU, Fundamentally?" article explains it much
> better than I ever could:
> 
> https://lwn.net/Articles/262464/
> 
> As to where the problem lies. I belive udp_tunnel_sock_release() is not
> keeping the (2) promise.
> 
> After unpublishing the sk_user_data, we should wait for any existing
> readers accessing the vxlan_sock to finish with synchronize_rcu(),
> before releaseing the socket.
> 
> That is:
> 
> --- a/net/ipv4/udp_tunnel_core.c
> +++ b/net/ipv4/udp_tunnel_core.c
> @@ -176,6 +176,7 @@ EXPORT_SYMBOL_GPL(udp_tunnel_xmit_skb);
>  void udp_tunnel_sock_release(struct socket *sock)
>  {
>         rcu_assign_sk_user_data(sock->sk, NULL);
> +       synchronize_rcu();
>         kernel_sock_shutdown(sock, SHUT_RDWR);
>         sock_release(sock);
>  }
> 
> 
> Otherwise accessing vxlan_sock state doesn't look safe to me.

Hi Jakub,

Thanks for your explain. As it's a little on my side, I will read your
comments and try your suggestion tomorrow. Currently, I use the following
draft patch to fix the vxlan issue.

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 2122747a0224..53259b0b07f3 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -4234,6 +4234,7 @@ static void vxlan_dellink(struct net_device *dev, struct list_head *head)
        struct vxlan_dev *vxlan = netdev_priv(dev);

        vxlan_flush(vxlan, true);
+       vxlan_sock_release(vxlan);

        list_del(&vxlan->next);
        unregister_netdevice_queue(dev, head);


Cheers
Hangbin
