Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690AF6DE9DE
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 05:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDLDUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 23:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDLDT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 23:19:57 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B62269F
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 20:19:55 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id bl15so8728414qtb.10
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 20:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681269594; x=1683861594;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wn4BZNosCyu2A+3Atg5lY/5MhpEv4BVDGQ9a7urHu/0=;
        b=cWVgGGbNEkgELkNuqZN+vyGcC//MVgL3ijb5tLKTPW71+31Hp2vd79JHwrNznlHJU5
         81BcplWNj9egGslR56PVhePXgtwj1TSTDbNdFy+r8jAchveBC89pBXy/wZvtMuwL0rgM
         DMTyHGvynk+isNEoMs4i9DL7Fukwu8pkVG7rwVpw2Vo5ZEacU8VacU0onufHeOC2hWDv
         6aTdcKmOrtBr4JeQG0FtGRAwthNWpkAJrd0AK6LzxFrz1H2W/yYfrrEEqoeL0AVqXFDy
         lomzSfw71dj+Ttqp55Cij5t7ysJtX+2YbcHnhqwEkbN2ymfEUW6xecoRH0mwJSPCdkxl
         KSnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681269594; x=1683861594;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Wn4BZNosCyu2A+3Atg5lY/5MhpEv4BVDGQ9a7urHu/0=;
        b=1O2ksd4ePyCAH7LqYz3Bgg8EBTmxECJFtZucg9oc+izHbtnsiuPWz2Xb4sszQk2uWz
         mmuwOnPWRku9QUIlSVUowe+gkWdW179f+q13vcFsSzq+EVcKhgR0iMlauXClE4wkPivN
         my4JarvGJEOxGA2TZXAeMDRtWe/5cXHqTbUDK/xT1Og8fWRw9nUKEt/K202ohsbdLGQG
         Q2eW4OmPQhG6KuBBhLhEVeb51m2lOj5vYT6phwnBSQDxEHcm2opcRidJzgyvTYhJobVM
         zZNDnGX1Ng6BmakZHVkXY12emmKq3tkVmfJMadalE4M+puvkDsZOmCRHhGV4HPjTKoG9
         tWMQ==
X-Gm-Message-State: AAQBX9dVPJ063wSs4I8sKZUMWqVtEq9oJAsN97xjfwBo8yXSMdc/H1ku
        pmGK4bao+6e8OLBH6gU060g=
X-Google-Smtp-Source: AKy350ZdID2J/c3XdfoxCiwQzHHxpR7JvzrkY/ZSO8XTtr3+FpGwWVnG7rE3W1LJSTO2Ed9QtdSpxQ==
X-Received: by 2002:ac8:5850:0:b0:3c0:6cf:3226 with SMTP id h16-20020ac85850000000b003c006cf3226mr26358381qth.8.1681269594142;
        Tue, 11 Apr 2023 20:19:54 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id o20-20020ac85554000000b003e4dab0776esm456538qtr.40.2023.04.11.20.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 20:19:53 -0700 (PDT)
Date:   Tue, 11 Apr 2023 23:19:53 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Aleksey Shumnik <ashumnik9@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, waltje@uwalt.nl.mugnet.org,
        gw4pts@gw4pts.ampr.org, xeb@mail.ru, kuznet@ms2.inr.ac.ru,
        rzsfl@rz.uni-sb.de, gnault@redhat.com
Message-ID: <64362359316d5_1b9cfb29415@willemb.c.googlers.com.notmuch>
In-Reply-To: <CAJGXZLgcH6bjmj7YR-hAWpEQW1CPjEcOdMN01hqsVk18E4ScZQ@mail.gmail.com>
References: <CAJGXZLgcH6bjmj7YR-hAWpEQW1CPjEcOdMN01hqsVk18E4ScZQ@mail.gmail.com>
Subject: RE: [BUG] In af_packet.c::dev_parse_header() skb.network_header does
 not point to the network header
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aleksey Shumnik wrote:
> Dear maintainers,
> 
> I wrote the ip6gre_header_parser() function in ip6_gre.c, the
> implementation is similar to ipgre_header_parser() in ip_gre.c. (By
> the way, it is strange that this function is not implemented in
> ip6_gre.c)
> The implementation of the function is presented below.
> It should parse the ip6 header and take the source address and its
> length from there. To get a pointer to the ip header, it is logical to
> use skb_network_header(), but it does not work correctly and returns a
> pointer to payload (skb.data).
> Also in ip_gre.c::ipgre_header_parser() skb_mac_header() returns a
> pointer to the ip header and everything works correctly (although it
> seems that this is also an error, because the pointer to the mac
> header should have been returned, and logically the
> skb_network_header() function should be applied), 

For a device of type ARPHRD_IPGRE or ARPHRD_IP6GRE there is no other
MAC header. This is not ARPHRD_ETHER.

The link layer header can be seen by looking for header_ops.create
if it exists. This creates the header for packet sockets of type
SOCK_DGRAM.

> but in ip6_gre.c all
> skb_mac_header(), skb_network_header(), skb_tranport_header() returns
> a pointer to payload (skb.data).
> This function is called when receiving a packet and parsing it in
> af_packet.c::packet_rcv() in dev_parse_header().
> The problem is that there is no way to accurately determine the
> beginning of the ip header.

The issue happens when comparing packet_rcv on an ip_gre tunnel vs an
ip6_gre tunnel.

The packet_rcv call does the same in both cases, e.g., setting
skb->data at mac or network header depending on SOCK_DGRAM or
SOCK_RAW.

The issue then is likely with a difference in tunnel implementations.
Both implement header_ops and header_ops.create (which is used on
receive by dev_has_header, but on transmit by dev_hard_header). They
return different lengths: one with and one without the IP header.

We've seen inconsistency in this before between tunnels. See also
commit aab1e898c26c. ipgre_xmit has special logic to optionally pull
the headers, but only if header_ops is set, which it isn't for all
variants of GRE tunnels.

Probably particularly relevant is this section in __ipgre_rcv:

                /* Special case for ipgre_header_parse(), which expects the
                 * mac_header to point to the outer IP header.
                 */
                if (tunnel->dev->header_ops == &ipgre_header_ops)
                        skb_pop_mac_header(skb);
                else
                        skb_reset_mac_header(skb);

and see this comment in the mentioned commit:

    ipgre_header_parse() seems to be the only case that requires mac_header
    to point to the outer header. We can detect this case accurately by
    checking ->header_ops. For all other cases, we can reset mac_header.

> diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> index 90565b8..0d0c37b 100644
> --- a/net/ipv6/ip6_gre.c
> +++ b/net/ipv6/ip6_gre.c
> @@ -1404,8 +1404,16 @@ static int ip6gre_header(struct sk_buff *skb,
> struct net_device *dev,
>   return -t->hlen;
>  }
> 
> +static int ip6gre_header_parse(const struct sk_buff *skb, unsigned char *haddr)
> +{
> + const struct ipv6hdr *ipv6h = (const struct ipv6hdr *) skb_mac_header(skb);
> + memcpy(haddr, &ipv6h->saddr, 16);
> + return 16;
> +}
> +
>  static const struct header_ops ip6gre_header_ops = {
>   .create = ip6gre_header,
> + .parse = ip6gre_header_parse,
>  };
> 
>  static const struct net_device_ops ip6gre_netdev_ops = {
> 
> Would you answer whether this behavior is an error and why the
> behavior in ip_gre.c and ip6_gre.c differs?
> 
> Regards,
> Aleksey


