Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B8A105F65
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfKVFNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:13:08 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38273 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfKVFNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 00:13:08 -0500
Received: by mail-pl1-f196.google.com with SMTP id q18so2615301pls.5
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 21:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yX4Tq5Ym6iWctAI7V88V0aDBnuGKothzeuzTQLcKi/w=;
        b=U6vfXuoE7ElzqlBcEE3ljYNw88qm22NUwoZY2Rw8wnTX3MSRK/4ODtdtdktC5XE1YU
         ULlysOcX3SvS86+++A4N/nmyAVBW5fNUNGmnAlNXWumraiuOsnk1Voia7R8/z0J3uOxb
         19tqRtjJC0Y22PCjDcu0mNvRkx2fQMFahlBG17JIHfDB7dBAk5wBKFlnrYb82/FbBZCL
         +OMOgCIicMNtH0sygqunGvZRsvSiACfBSqRfhr0rsLrGOjaO4lat1IiFwGbTcYg5calV
         Psl+0kyPX+7NJDLJ8Wc8kqEY5uK3KtChafmlxhSN4WVt0VeqIlWMJ1OjJOK5yVOlrG1I
         2Lqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yX4Tq5Ym6iWctAI7V88V0aDBnuGKothzeuzTQLcKi/w=;
        b=Io2N1OjM8NX5aVfLeDESllD0b5PIrn1S8txDxXjCxJaSjeEoFz83770NsWc+pzO7T4
         tN5OL2y8rLiY/+uvb83Rkk1eWkKlCp8a/7vog5WoFc0kVzYzA6EJWrhnGgn5IOs1tS9i
         5OmGUSAHTs3kI/34LlwGujyClgifXf8v3lztJd3oM7RidH3JBiFE0H1SnkWWNW61l+St
         7SIdptYh+1qSeqRODicARwhMWITKq1xMlLRzsDXEC6vWuEbcvwwshT/qU5Wj83/6TAeE
         kfWe83KuucpCVmgOxdozyylmoVm/BaH2zUTTE+GTUOtnvF3CilyKQ5kxhyuYvJR0fTRJ
         NG6Q==
X-Gm-Message-State: APjAAAXhMuVwmv+c6zi8L+jVO2iiOFLptqjZhjWXv/OAVBrjrx/Kiiby
        rAJM9O+LI8n4KEzKaXSaRnU=
X-Google-Smtp-Source: APXvYqw+P+l73VcOr6faW9LFfrdxRHMNRs2drbo/upviEoyKYMGCmJiL81wkrYC1SJX43wina5Bq2w==
X-Received: by 2002:a17:90a:ca0e:: with SMTP id x14mr16414595pjt.95.1574399585432;
        Thu, 21 Nov 2019 21:13:05 -0800 (PST)
Received: from martin-VirtualBox ([1.39.175.39])
        by smtp.gmail.com with ESMTPSA id v16sm1264214pje.1.2019.11.21.21.13.04
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 21 Nov 2019 21:13:04 -0800 (PST)
Date:   Fri, 22 Nov 2019 10:42:53 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next] Enhanced skb_mpls_pop to update ethertype of
 the packet in all the cases when an ethernet header is present is the
 packet.
Message-ID: <20191122051253.GA19664@martin-VirtualBox>
References: <1574338995-14657-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_De_A=jY-fBqJjXDQKemEOOfJtpvqGR_bi3_-x8+od2eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_De_A=jY-fBqJjXDQKemEOOfJtpvqGR_bi3_-x8+od2eg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 06:22:29PM -0800, Pravin Shelar wrote:
> On Thu, Nov 21, 2019 at 4:23 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin Varghese <martin.varghese@nokia.com>
> >
> > The skb_mpls_pop was not updating ethertype of an ethernet packet if the
> > packet was originally received from a non ARPHRD_ETHER device.
> >
> > In the below OVS data path flow, since the device corresponding to port 7
> > is an l3 device (ARPHRD_NONE) the skb_mpls_pop function does not update
> > the ethertype of the packet even though the previous push_eth action had
> > added an ethernet header to the packet.
> >
> > recirc_id(0),in_port(7),eth_type(0x8847),
> > mpls(label=12/0xfffff,tc=0/0,ttl=0/0x0,bos=1/1),
> > actions:push_eth(src=00:00:00:00:00:00,dst=00:00:00:00:00:00),
> > pop_mpls(eth_type=0x800),4
> >
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > ---
> >  include/linux/skbuff.h    | 3 ++-
> >  net/core/skbuff.c         | 8 +++++---
> >  net/openvswitch/actions.c | 2 +-
> >  net/sched/act_mpls.c      | 2 +-
> >  4 files changed, 9 insertions(+), 6 deletions(-)
> >
> ...
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 867e61d..8ac377d 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -5529,12 +5529,14 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
> >   * @skb: buffer
> >   * @next_proto: ethertype of header after popped MPLS header
> >   * @mac_len: length of the MAC header
> > - *
> > + * @ethernet: flag to indicate if ethernet header is present in packet
> > + *           ignored for device type ARPHRD_ETHER
> >   * Expects skb->data at mac header.
> >   *
> >   * Returns 0 on success, -errno otherwise.
> >   */
> > -int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
> > +int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
> > +                bool ethernet)
> >  {
> >         int err;
> >
> > @@ -5553,7 +5555,7 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
> >         skb_reset_mac_header(skb);
> >         skb_set_network_header(skb, mac_len);
> >
> > -       if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
> > +       if ((skb->dev && skb->dev->type == ARPHRD_ETHER) || ethernet) {
> >                 struct ethhdr *hdr;
> Lets move the dev-type check to caller. That would also avoid one more
> argument to this function.


To have only the ethernet flag check in the function like below ?
 If (ethernet) {
     /*pseudo*/   Update ethertype
 }
And pass the flag to the function considering the device type
Fo example in case of tc.

if (skb_mpls_pop(skb, p->tcfm_proto, mac_len,
                                 (skb->dev && skb->dev->type == ARPHRD_ETHER))).


But how do we avoid an argument here ? I am missing anything ?
> 
> >
> >                 /* use mpls_hdr() to get ethertype to account for VLANs. */
> > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > index 12936c1..9e5d274 100644
> > --- a/net/openvswitch/actions.c
> > +++ b/net/openvswitch/actions.c
> > @@ -179,7 +179,7 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> >  {
> >         int err;
> >
> > -       err = skb_mpls_pop(skb, ethertype, skb->mac_len);
> > +       err = skb_mpls_pop(skb, ethertype, skb->mac_len, true);
> >         if (err)
> OVS supports L3 packets, you need to check flow key for type of packet
> (ovs_key_mac_proto()) under process.


Yes I missed that.
        err = skb_mpls_pop(skb, ethertype, skb->mac_len, ovs_key_mac_proto())); ?
       or 
	err = skb_mpls_pop(skb, ethertype, skb->mac_len, key->mac_proto = MAC_PROTO_ETHERNET)

I assume both acheives the same 


Thanks for reviewing

Martin
