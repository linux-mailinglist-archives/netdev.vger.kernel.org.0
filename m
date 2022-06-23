Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA94557D4E
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiFWNvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiFWNvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:51:44 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5678438189
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:51:43 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id w187so6024579vsb.1
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=4kWyom1rXZxNFX/agEk2HUaxBW0yFlj3DKvkBHSTR5M=;
        b=LNAJrYncsynRrqYdQ6yLvQFp1eO/TUA42bdUdg6/7Nb+hI3OZAjZ/ziJdURKRj40QM
         sdUfpC2X9n4cQhqxbarbg8BUlOJE1ybBUxi4HuAeymMSzMv7AgYWRHYHzsU1OyuSNqak
         qcY15dXqd5c8rKvejDE1aGlooQXW2pn2AtKeMX4sOQeFKWY4tOR6kjb3ElyBDMj3bgUn
         a5dBHXCIxZTUd8XFTD2H5YMoxL7vIvavgfiRDvIW812ZOPUwRVqP+4cMEwtydfn4vd8d
         /nxxu7c+XN+elxqL6aOudpgSt2tNH84zsHWSq7Sq3RHBmNbrYyR5tlXyu0Q8cqubY0eX
         eHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=4kWyom1rXZxNFX/agEk2HUaxBW0yFlj3DKvkBHSTR5M=;
        b=0lcJbmGL+YcF56x1LNHrTDauiFDTCsxEoAV0cU99fVUft8NT328kF+fE6P83JacZhu
         +I+uPwOZ6XXslHbaill0VjAb3B6Aa41nAfIZfP1maTeCLC4ykU1Tl21hCzOb4e9G2qaN
         Rzd7PkBwDL5pisyxQmRFmUDbgI/9kmd6q3Zb8yQsmSQgnNdhWPZ39t5mQ/c8asB2R73+
         XEmofcEM+4LvpwXPUidhIc1pBJWqLDW4V3iUmQGCYEbzXqfx2gfpp6RSk18vnO8V++pL
         K//P2Gs1Kakw4pJjO43hXTLUXBzLcL3e6kzloE0DQG/Y7p5ZP6Bof9e8PMgAu1GdWMc3
         AJdA==
X-Gm-Message-State: AJIora9rJPc4+kR6mILXU+HZbE+5Q5nxp9niQW6ZQJ4+wxJbKkcX326y
        w39iglub6QcHHYWTUBb84xmPNzCorbwSzBzJKnwR83fD420=
X-Google-Smtp-Source: AGRyM1tgsFDIWN4pwzr9R3EVkpVTMnQKvKwNVQ2/Ska2rh4pbr5+Oz3lG0N/lAHjAdRHISpUip+xI8fXtlLoRK1mUZY=
X-Received: by 2002:a05:6102:5090:b0:34b:c270:436e with SMTP id
 bl16-20020a056102509000b0034bc270436emr16846873vsb.61.1655992302410; Thu, 23
 Jun 2022 06:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
 <20220622171929.77078c4d@kernel.org>
In-Reply-To: <20220622171929.77078c4d@kernel.org>
From:   Aleksey Shumnik <ashumnik9@gmail.com>
Date:   Thu, 23 Jun 2022 16:51:31 +0300
Message-ID: <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 3:19 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 21 Jun 2022 16:48:09 +0300 Aleksey Shumnik wrote:
> > Subject: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header are  recorded twice
> > Date: Tue, 21 Jun 2022 16:48:09 +0300
> >
> > Dear Maintainers,
> >
> > I tried to ping IPv6 hub address on the mGRE interface from the spok
> > and found some problem:
> > I caught packets and saw that there are 2 identical IP and GRE headers
> > (when use IPv4 there is no duplication)
> > Below is the package structure:
> > +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> > | eth | iph (1) | greh (1) | iph (1) | greh (1) | iph (2) | greh (2) |  icmp  |
> > +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> What socket type is the ping you have using?

I use SOCK_DGRAM

> > I found cause of the problem, in ip_gre.c and ip6_gre.c IP and GRE
> > headers created twice, first time in ip gre_header() and
> > ip6gre_header() and second time in __gre_xmit(), so I deleted
> > unnecessary creation of headers and everything started working as it
> > should.
> > Below is a patch to eliminate the problem of duplicate headers:
> >
> > diff -c a/net/inv6/ip6_gre.c b/net/inv6/ip6_gre.c
>
> The patch looks strangely mangled, it's white space damaged and refers
> to a net/inv6 which does not exist.
>
> Could you regenerate your changes using git? git commit / format-patch
> / send-email ?

Thanks a lot for the answer!
I want to find out, the creation of gre and ip header twice, is it a
feature or a bug?

I did everything according to the instructions, hope everything is
correct this time.

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 3b9cd48..5e8907b 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -836,43 +836,6 @@ static int ipgre_tunnel_ctl(struct net_device
*dev, struct ip_tunnel_parm *p,
    ftp fec0:6666:6666::193.233.7.65
    ...
  */
-static int ipgre_header(struct sk_buff *skb, struct net_device *dev,
- unsigned short type,
- const void *daddr, const void *saddr, unsigned int len)
-{
- struct ip_tunnel *t = netdev_priv(dev);
- struct iphdr *iph;
- struct gre_base_hdr *greh;
-
- iph = skb_push(skb, t->hlen + sizeof(*iph));
- greh = (struct gre_base_hdr *)(iph+1);
- greh->flags = gre_tnl_flags_to_gre_flags(t->parms.o_flags);
- greh->protocol = htons(type);
-
- memcpy(iph, &t->parms.iph, sizeof(struct iphdr));
-
- /* Set the source hardware address. */
- if (saddr)
- memcpy(&iph->saddr, saddr, 4);
- if (daddr)
- memcpy(&iph->daddr, daddr, 4);
- if (iph->daddr)
- return t->hlen + sizeof(*iph);
-
- return -(t->hlen + sizeof(*iph));
-}
-
-static int ipgre_header_parse(const struct sk_buff *skb, unsigned char *haddr)
-{
- const struct iphdr *iph = (const struct iphdr *) skb_mac_header(skb);
- memcpy(haddr, &iph->saddr, 4);
- return 4;
-}
-
-static const struct header_ops ipgre_header_ops = {
- .create = ipgre_header,
- .parse = ipgre_header_parse,
-};

 #ifdef CONFIG_NET_IPGRE_BROADCAST
 static int ipgre_open(struct net_device *dev)
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 4e37f7c..add7c5c 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1358,45 +1358,6 @@ done:
  return err;
 }

-static int ip6gre_header(struct sk_buff *skb, struct net_device *dev,
- unsigned short type, const void *daddr,
- const void *saddr, unsigned int len)
-{
- struct ip6_tnl *t = netdev_priv(dev);
- struct ipv6hdr *ipv6h;
- __be16 *p;
-
- ipv6h = skb_push(skb, t->hlen + sizeof(*ipv6h));
- ip6_flow_hdr(ipv6h, 0, ip6_make_flowlabel(dev_net(dev), skb,
-   t->fl.u.ip6.flowlabel,
-   true, &t->fl.u.ip6));
- ipv6h->hop_limit = t->parms.hop_limit;
- ipv6h->nexthdr = NEXTHDR_GRE;
- ipv6h->saddr = t->parms.laddr;
- ipv6h->daddr = t->parms.raddr;
-
- p = (__be16 *)(ipv6h + 1);
- p[0] = t->parms.o_flags;
- p[1] = htons(type);
-
- /*
- * Set the source hardware address.
- */
-
- if (saddr)
- memcpy(&ipv6h->saddr, saddr, sizeof(struct in6_addr));
- if (daddr)
- memcpy(&ipv6h->daddr, daddr, sizeof(struct in6_addr));
- if (!ipv6_addr_any(&ipv6h->daddr))
- return t->hlen;
-
- return -t->hlen;
-}
-
-static const struct header_ops ip6gre_header_ops = {
- .create = ip6gre_header,
-};
-
 static const struct net_device_ops ip6gre_netdev_ops = {
  .ndo_init = ip6gre_tunnel_init,
  .ndo_uninit = ip6gre_tunnel_uninit,
