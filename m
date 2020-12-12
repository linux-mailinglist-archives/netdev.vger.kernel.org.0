Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CF52D85BE
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438641AbgLLKKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 05:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389306AbgLLJyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 04:54:03 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345D4C0611CD
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:15:41 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id q18so3872700wrn.1
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t8LXUgVkBQyTFVEvPP3uy3XwBGMsnk7CgQ8ObaFkCHw=;
        b=2QgE5b16f31Hh2hOEN/njH56S3pbSDo5sMoDGOMfzewrv9bPA37H+GRMVXxxjERHM3
         GNfwkYdLadCVxGgbKJjwXhhaxDz16M+woRm4MFTGi9gGD/6j7A/3pOZS2WYMH2DgCJsF
         ylak4VG9wTUVNdgzcdG8Yp8RZ9mFJIcZ5ciTSIWO1blnTfbp5ZNfkR8G8aGwJT8Ry6e7
         aPe2UtD+ea+WFfQLrKmUC5VUa0io4NoaMrRci1xdyNxm62ZYwjdF+xZlxMA8HDFPXAbk
         ZbbvYPPnqNSrRr7oYx2Bef8iH3elCOqXwXsqLOc5SLqMfCyID1YO4RLNuNU5hS9aUWlb
         pFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t8LXUgVkBQyTFVEvPP3uy3XwBGMsnk7CgQ8ObaFkCHw=;
        b=SciFCdI5gZvNmm0/QNJnwWeuO6FIgaqYQA0j3zRD1STEraL1YyqO1N0/mso1N97a21
         F+/u6lCZq2HDpkQBNGSH/U6vQiSbNqFpNs8NCfhctRR7SDUaUF64m+30r+HWqSdeepTO
         HboVM/u1aktNZU1ilklPURU1qqgS0ejmvdnSPIE4jmcTWhVHpXQ6A1vQZDgV+ud4mLiE
         pWCLEojnWU3a3uyDrLHqgJ2wAi2GmBOE0C0uyW5rUMuK+QNAroJrnqupJB4cU3PjyLms
         KXI0o2zbgvo0zWs/hodN+jdvgZlZIvQ/Hn1XoObM4PJRrUOvjeVjZs4ipRCSJCbU61/K
         YQNg==
X-Gm-Message-State: AOAM532ui26Q3WhT+jlPsGPC4EFRc819tqgzUTZWIPkTn4Rlk5T9OeTd
        Z1NWF995NR6YH9KV+LGk07ElUeXAftIjGg==
X-Google-Smtp-Source: ABdhPJytLiIG1XgYIjh/kSgokBbv6/H11Bss/4M1zIB5qvfdolOKwnQT4wLd56G2Z5p49vr7w3NkkQ==
X-Received: by 2002:a05:651c:204e:: with SMTP id t14mr6540593ljo.499.1607756742203;
        Fri, 11 Dec 2020 23:05:42 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id r8sm1295322ljd.140.2020.12.11.23.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 23:05:41 -0800 (PST)
Subject: Re: [PATCH net-next v2 10/12] gtp: add IPv6 support
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, laforge@gnumonks.org
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-11-jonas@norrbonn.se>
 <CAOrHB_B3oDcQz97409ZG8zmu+yX4yTWdhHRN8g+Kp6GD+Ov4cg@mail.gmail.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <a52c6960-cf72-9c7a-6c44-cf03711d65f6@norrbonn.se>
Date:   Sat, 12 Dec 2020 08:05:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAOrHB_B3oDcQz97409ZG8zmu+yX4yTWdhHRN8g+Kp6GD+Ov4cg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pravin,

On 12/12/2020 06:51, Pravin Shelar wrote:
> On Fri, Dec 11, 2020 at 4:29 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>>
>> This patch adds support for handling IPv6.  Both the GTP tunnel and the
>> tunneled packets may be IPv6; as they constitute independent streams,
>> both v4-over-v6 and v6-over-v4 are supported, as well.
>>
>> This patch includes only the driver functionality for IPv6 support.  A
>> follow-on patch will add support for configuring the tunnels with IPv6
>> addresses.
>>
>> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
>> ---
>>   drivers/net/gtp.c | 330 +++++++++++++++++++++++++++++++++++++---------
>>   1 file changed, 269 insertions(+), 61 deletions(-)
>>


>> +       /* Get IP version of _inner_ packet */
>> +       ipver = inner_ip_hdr(skb)->version;
>> +
>> +       switch (ipver) {
>> +       case 4:
>> +               skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IP));
>> +               r = gtp_check_ms_ipv4(skb, pctx, hdrlen, role);
> I don't see a need to set inner header on receive path, we are any
> ways removing outer header from this packet in same function.
> 
>> +               break;
>> +       case 6:
>> +               skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IPV6));
>> +               r = gtp_check_ms_ipv6(skb, pctx, hdrlen, role);
>> +               break;
>> +       }
>> +
>> +       if (!r) {
>>                  netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
>>                  return 1;
>>          }
>> @@ -193,6 +256,8 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
>>                                   !net_eq(sock_net(pctx->sk), dev_net(pctx->dev))))
>>                  return -1;
>>
>> +       skb->protocol = skb->inner_protocol;
>> +
> iptunnel_pull_header() can set the protocol, so it would be better to
> pass the correct inner protocol.
> 

Yes, your comments above are correct.  I'll fix that.



>>          netdev_dbg(pctx->dev, "forwarding packet from GGSN to uplink\n");
>>
>>          /* Now that the UDP and the GTP header have been removed, set up the
>> @@ -201,7 +266,7 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
>>           */
>>          skb_reset_network_header(skb);
>>
>> -       skb->dev = pctx->dev;
>> +       __skb_tunnel_rx(skb, pctx->dev, sock_net(pctx->sk));
>>
> No need to call skb_tunnel_rx() given iptunnel_pull_header() function
> is already called and it does take care of clearing the context.

Right.  The only difference seems to be that __skb_tunnel_rx also does:

skb->dev = dev;

iptunnel_pull_header excludes that.  I can't see that setting the 
skb->dev will actually change anything for this driver, but it was there 
previously.  Thoughts?

>>
>> +static struct dst_entry *gtp_get_v6_dst(struct sk_buff *skb,
>> +                                       struct net_device *dev,
>> +                                       struct pdp_ctx *pctx,
>> +                                       struct in6_addr *saddr)
>> +{
>> +       const struct sock *sk = pctx->sk;
>> +       struct dst_entry *dst = NULL;
>> +       struct flowi6 fl6;
>> +
>> +       memset(&fl6, 0, sizeof(fl6));
>> +       fl6.flowi6_mark = skb->mark;
>> +       fl6.flowi6_proto = IPPROTO_UDP;
>> +       fl6.daddr = pctx->peer_addr;
>> +
>> +       dst = ipv6_stub->ipv6_dst_lookup_flow(sock_net(sk), sk, &fl6, NULL);
>> +       if (IS_ERR(dst)) {
>> +               netdev_dbg(pctx->dev, "no route to %pI6\n", &fl6.daddr);
>> +               return ERR_PTR(-ENETUNREACH);
>> +       }
>> +       if (dst->dev == pctx->dev) {
>> +               netdev_dbg(pctx->dev, "circular route to %pI6\n", &fl6.daddr);
>> +               dst_release(dst);
>> +               return ERR_PTR(-ELOOP);
>> +       }
>> +
>> +       *saddr = fl6.saddr;
>> +
>> +       return dst;
>> +}
>> +
> IPv6 related functionality needs to be protected by IS_ENABLED(CONFIG_IPV6).

Yes, you're probably right.  Given that IPv6 isn't really optional in 
contexts where this driver is relevant, however, I'm almost inclined to 
switch this around and make the driver depend on the availability of IPv6...

/Jonas
