Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7032BFAA80
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 07:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbfKMG5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 01:57:06 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36817 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfKMG5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 01:57:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id r10so995833wrx.3
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 22:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4DsUGnKqjy0+txZT/fzFV5OBdOrHS8RfuCy5beGf3m8=;
        b=XkYn73SmZx1XM56MaLKx411vKh7Ufy9yYQS/T96JXUgx6wzXEvz9qOXG/LsrdPRoSz
         1C2tTaQEE9VGrS1/Pc4A/hAp4rAT7DgJT63LiGY2FyxMCyn9VSMcENvzJHhTcoZ0opm1
         d67IG4Y/aUXhYWJnJh+tERBtbVugGxYuxM/ZWP3ujr86yJcNPMc4JGHVNhZ66EoV9w53
         8/SzpiK/3F313nP9rajTAX8DDg/tveCFsdhgxrEOAqW1Kkx9700GSKBGhe+dvMsxCEVE
         cJ8hXR+4V/EMY3nQI2x+5uW3rhlNWYU0qFCosbapn6sPY1D1j9JauMjOZ6g7s0x2zrZm
         5jnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4DsUGnKqjy0+txZT/fzFV5OBdOrHS8RfuCy5beGf3m8=;
        b=A8DI1B3yf6JFaskfkbH/idIGY0Tzthu6VkkQ/vDVJO2F1fj8JNOL0oFiSAhYUunw7c
         Wy0gvqqr0KOQCBHlV0SzRKNnnXhqJVq1iq396AaqxzeNORGlOG/nZApJtL/xhySUQq25
         zkj4GiJJKmpVUTAuF76TvRki4BRq8RjsR/EA0TT6prANVWVg3uMjF0gvVR6XNco153YO
         yWqf/R0hRezt1+OUcBJt97YIdcmQu0swP2ggPOojpj26zZk0UWdpC0oflbsRMLIJKstd
         IqbjelLpSDwNuC+PfI7YVnXmIVubkOnMBqmvoxbEd2cjZWu860+UD95+RfkWNlwy97pk
         GWDw==
X-Gm-Message-State: APjAAAVHWOhV8sWds4sQpkfDAOOTOEBVJ/xFEKMZTLVuJ43m08jsFAtX
        KobcMg5kUg16WnbrbHsmHM3tVA==
X-Google-Smtp-Source: APXvYqz8VtXUxmk7Onq0TJZLhvVt2ZgcX49euIYDvk/prhyE54NbeVjYGoJ9Zn2HAdMOz2CUMidKIg==
X-Received: by 2002:adf:e80d:: with SMTP id o13mr143146wrm.73.1573628223450;
        Tue, 12 Nov 2019 22:57:03 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id a186sm603876wmc.48.2019.11.12.22.57.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 22:57:02 -0800 (PST)
Date:   Wed, 13 Nov 2019 07:57:02 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, dev@openvswitch.org,
        LKML <linux-kernel@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>
Subject: Re: [PATCH net-next] openvswitch: add TTL decrement action
Message-ID: <20191113065701.f76pe4drfixdm6ci@netronome.com>
References: <20191112102518.4406-1-mcroce@redhat.com>
 <20191112150046.2aehmeoq7ri6duwo@netronome.com>
 <CAGnkfhyt7wV-qDODQL1DtDoW0anoehVX7zoVk8y_C4WB0tMuUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhyt7wV-qDODQL1DtDoW0anoehVX7zoVk8y_C4WB0tMuUw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 04:46:12PM +0100, Matteo Croce wrote:
> On Tue, Nov 12, 2019 at 4:00 PM Simon Horman <simon.horman@netronome.com> wrote:
> >
> > On Tue, Nov 12, 2019 at 11:25:18AM +0100, Matteo Croce wrote:
> > > New action to decrement TTL instead of setting it to a fixed value.
> > > This action will decrement the TTL and, in case of expired TTL, send the
> > > packet to userspace via output_userspace() to take care of it.
> > >
> > > Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.
> > >
> >
> > Usually OVS achieves this behaviour by matching on the TTL and
> > setting it to the desired value, pre-calculated as TTL -1.
> > With that in mind could you explain the motivation for this
> > change?
> >
> 
> Hi,
> 
> the problem is that OVS creates a flow for each ttl it see. I can let
> vswitchd create 255 flows with like this:
> 
> $ for i in {2..255}; do ping 192.168.0.2 -t $i -c1 -w1 &>/dev/null & done
> $ ovs-dpctl dump-flows |fgrep -c 'set(ipv4(ttl'
> 255

Hi,

so the motivation is to reduce the number of megaflows in the case
where flows otherwise match but the TTL differs. I think this makes sense
and the absence of this feature may date back to designs made before
megaflow support was added - just guessing.

I think this is a reasonable feature but I think it would be good
to explain the motivation in the changelog.

> > > @@ -1174,6 +1174,43 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
> > >                            nla_len(actions), last, clone_flow_key);
> > >  }
> > >
> > > +static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
> > > +{
> > > +     int err;
> > > +
> > > +     if (skb->protocol == htons(ETH_P_IPV6)) {
> > > +             struct ipv6hdr *nh = ipv6_hdr(skb);
> > > +
> > > +             err = skb_ensure_writable(skb, skb_network_offset(skb) +
> > > +                                       sizeof(*nh));
> > > +             if (unlikely(err))
> > > +                     return err;
> > > +
> > > +             if (nh->hop_limit <= 1)
> > > +                     return -EHOSTUNREACH;
> > > +
> > > +             key->ip.ttl = --nh->hop_limit;
> > > +     } else {
> > > +             struct iphdr *nh = ip_hdr(skb);
> > > +             u8 old_ttl;
> > > +
> > > +             err = skb_ensure_writable(skb, skb_network_offset(skb) +
> > > +                                       sizeof(*nh));
> > > +             if (unlikely(err))
> > > +                     return err;
> > > +
> > > +             if (nh->ttl <= 1)
> > > +                     return -EHOSTUNREACH;
> > > +
> > > +             old_ttl = nh->ttl--;
> > > +             csum_replace2(&nh->check, htons(old_ttl << 8),
> > > +                           htons(nh->ttl << 8));
> > > +             key->ip.ttl = nh->ttl;
> > > +     }
> >
> > The above may send packets with TTL = 0, is that desired?
> >
> 
> If TTL is 1 or 0, execute_dec_ttl() returns -EHOSTUNREACH, and the
> caller will just send the packet to userspace and then free it.
> I think this is enough, am I missing something?

No, you are not. I was missing something.
I now think this logic is fine.
