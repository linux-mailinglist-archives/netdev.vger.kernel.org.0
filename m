Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84DDDC395F
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389634AbfJAPoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:44:37 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43739 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfJAPoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 11:44:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id v27so9900879pgk.10
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 08:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3RxnDGRr7B1XTJFunDM7ZNbXmbQskGnoRCYVHzPDhjY=;
        b=aaXHJnyItKtapP/eT7bgV/RWcyFHwp4VhYihtj48vumdyUhczhQsttZcV7NVVOnK/G
         bA0s4p9tepc1VmsRkQQ5CQML0vT+xCOsgbuaWoLtVVaFijXVrlx1DMR1wGOCjdFdgdrc
         ZgvEtbd23AuEK8wDpfL/qIoLrUUGbeMRcwenVT+WV8JqrWPao1UWc8J6T1QjmQof0Ue7
         pC2pPoOxrWe6FNsXNsRVMzR3O1osZ6JF9B98kOxXht0KlPseHc2BedqgSnEqmIK+Wfg0
         v6qkpF5ICEM8hJgvHXeS85jUZ1gtI97Ll1NkBXbp9Vjxs0FtyJ+wtWhnMuDTboj/IaSY
         KwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3RxnDGRr7B1XTJFunDM7ZNbXmbQskGnoRCYVHzPDhjY=;
        b=RDOsVWzt6stOlQ8aLtmtcAxr5a97wyQ66ILZE6AH5judyEvsurkRxcuvSrK1Rcw9LT
         hhaqUjkqB3vjkhUN16Ncn4ujGRnK9Dx7WMDJeRIrFiEyo8WbwYdQ2Jf1agz2IWo7r1KY
         dJXAcTup0xGbi8K/kor6m2A9X0gVQXOdRedj/KNEoNcaze0MFjERDN9J7J0knjjYmDHw
         mFbbIJbbgeNjfjXzqTFmSUiNuvn26QBcQdU+YqMHK4Q8DQTT2b1ShMkoAOTQluLacE3l
         38s8okZILJHgBw0OEoq/t6rH6mhc7PD3go95m0imTxfdNY48LWfOsd8/JxXX9OKFB/hN
         mJmQ==
X-Gm-Message-State: APjAAAVVNm8oqLF/WfNZ3/s/DvAW4uoXQZSOaWdMdXKlzcVmZ8C8LEu7
        cuwEzpqrP/uDnbyLrKAR6IgoUQ==
X-Google-Smtp-Source: APXvYqwVhM/EntPxs94ONszYZE1mKQBE9G5wS7fcs2w8cMG3BAuOlnjqb0PYFYz8fL7WJ+yQjl16nA==
X-Received: by 2002:a63:350f:: with SMTP id c15mr27311143pga.225.1569944674989;
        Tue, 01 Oct 2019 08:44:34 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p88sm5938164pjp.22.2019.10.01.08.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 08:44:34 -0700 (PDT)
Date:   Tue, 1 Oct 2019 08:44:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Sriram Krishnan <srirakr2@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] AF_PACKET doesnt strip VLAN information
Message-ID: <20191001084427.73f130c0@hermes.lan>
In-Reply-To: <CA+FuTSfN5=xkYUKiafM3uKF37kV6mg0Cn5WGv2QF887Pyw5A5g@mail.gmail.com>
References: <1569646705-10585-1-git-send-email-srirakr2@cisco.com>
        <CA+FuTSfN5=xkYUKiafM3uKF37kV6mg0Cn5WGv2QF887Pyw5A5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Sep 2019 11:16:14 -0400
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> On Mon, Sep 30, 2019 at 1:24 AM Sriram Krishnan <srirakr2@cisco.com> wrote:
> >
> > When an application sends with AF_PACKET and places a vlan header on
> > the raw packet; then the AF_PACKET needs to move the tag into the skb
> > so that it gets processed normally through the rest of the transmit
> > path.
> >
> > This is particularly a problem on Hyper-V where the host only allows
> > vlan in the offload info.  
> 
> This sounds like behavior that needs to be addressed in the driver, instead?

This was what we did first, but the problem was more general.
For example, many filtering functions assume that vlan tag is in
skb meta data, not the packet data itself. Therefore AF_PACKET would
get around any filter rules.

> 
> > Cc: xe-linux-external@cisco.com
> > ---
> >  net/packet/af_packet.c | 26 ++++++++++++++++++++++++--
> >  1 file changed, 24 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > index e2742b0..cfe0904 100644
> > --- a/net/packet/af_packet.c
> > +++ b/net/packet/af_packet.c
> > @@ -1849,15 +1849,35 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
> >         return 0;
> >  }
> >
> > -static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
> > +static int packet_parse_headers(struct sk_buff *skb, struct socket *sock)
> >  {
> >         if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
> >             sock->type == SOCK_RAW) {  
> 
> If inside this branch, may miss packets with skb->protocol set to one
> of the VLAN Ethertypes.
> 
> > +               __be16 ethertype;
> > +
> >                 skb_reset_mac_header(skb);
> > +
> > +               ethertype = eth_hdr(skb)->h_proto;
> > +               /*
> > +                * If Vlan tag is present in the packet
> > +                *  move it to skb
> > +               */
> > +               if (eth_type_vlan(ethertype)) {
> > +                       int err;
> > +                       __be16 vlan_tci;
> > +
> > +                       err = __skb_vlan_pop(skb, &vlan_tci);
> > +                       if (unlikely(err))
> > +                               return err;
> > +
> > +                       __vlan_hwaccel_put_tag(skb, ethertype, vlan_tci);  
> 
> What happens with multiple tags (QinQ)?

Same as multiple tags in a normal sent packet. The second tag is in
the packet itself.

> 
> > +               }
> > +
> >                 skb->protocol = dev_parse_header_protocol(skb);
> >         }
> >
> >         skb_probe_transport_header(skb);
> > +       return 0;
> >  }
> >
> >  /*
> > @@ -1979,7 +1999,9 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
> >         if (unlikely(extra_len == 4))
> >                 skb->no_fcs = 1;
> >
> > -       packet_parse_headers(skb, sock);
> > +       err = packet_parse_headers(skb, sock);
> > +       if (err)
> > +               goto out_unlock;  
> 
> This only tests the new return value in one of three callers of
> packet_sendmsg_spkt.

