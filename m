Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD1742B2D4
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 04:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbhJMCsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 22:48:35 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:38729 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229980AbhJMCse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 22:48:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A236E5805DD;
        Tue, 12 Oct 2021 22:46:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 12 Oct 2021 22:46:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        mendozajonas.com; h=message-id:subject:from:to:cc:date
        :in-reply-to:references:content-type:mime-version
        :content-transfer-encoding; s=fm1; bh=+E7F0YWmqRY7h6makWzK8RcDUH
        P7dmZaJRlPDdMf1ug=; b=IwqhZ2PQASvkp6GZ1X4nmPUo2+mgkl6BejxqX/F+bN
        FUDb0Z0QqWeATGLZqE/Ed2bXP8J4MntmkoapyNnSNvxJwrqxKwAMgwxAwKwz8VRc
        HdlbPBUOBE8IkStBpPkAhIeMaKkzpoMJvWA4Ru0Z3NX4ZwNYTzJbkmiy+EgTSgpX
        BuaBOG+oEeOQKMc7FDeMkow6w4HP9eafWVhxZzYrUxEzpN3fD6ImPRUs6Z2Vh5oH
        5DhGOWQ/rg+DqC8oEI5XGsrRilBfHqgRjSQ0msUMm/BwHbNcULWHBU+Bu/P2mRA0
        u11ojxYQuaJPj7CNirV6gD9dbR/n2sY4mL4rznoEbshA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=+E7F0YWmqRY7h6makWzK8RcDUHP7dmZaJRlPDdMf1
        ug=; b=EFBfADF6uEgUiRhavisj/MQdWunqxQrllDiFzwV5zC+2lnccdpB/+/FH1
        K3zQ4Jip6oF+Jyj2tPLiP9oAuKbOzcQ8Xj40R/9rjJUfwF6DWZhZUMpRc7Ug1an8
        16YiO4ot8YZguN4hMTN5ZJNgrwe3mkNkERqJ5oqQ/Oc4IX9UPEWn95o0ZQtL5W8j
        u+XWtK7nYaIEIHVHtlDmjGQ3ByB8GJRl7WS4he+09kTCGad8XKcmOH8fOhSskBvU
        9HmpBEc64LMjTMKd6H9AGAczsOVIW1D5HFU9fICDwhl9CwNqHu21bcXV1HSBdYm2
        0BWPFwogRvghsm4Yw7REozZAITu3A==
X-ME-Sender: <xms:hkhmYYsydRgnmIG_2Kx-2WvQ6Xl6BWUluO_JfQsBQzyWywnHRB9caQ>
    <xme:hkhmYVeDaR935O---C-qQ4h4QZ49_Mq3eiMMWuOITkvKZ594Vu9k_uv8hGT9npaWI
    BIT8KqZXLscu3b1eA>
X-ME-Received: <xmr:hkhmYTxugakxtqRCivgo_FfAYKDaLUMxyHNzYH7pxWCpdSt6MzxZZ5B2k-WBsoCdRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtledgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthekredttderjeenucfhrhhomhepufgrmhhu
    vghlucfovghnughoiigrqdflohhnrghsuceoshgrmhesmhgvnhguohiirghjohhnrghsrd
    gtohhmqeenucggtffrrghtthgvrhhnpefgvedvvdffhfeihedukeegheeludduhfehuddt
    gefftddugeffjeetjeduteduvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehsrghmsehmvghnughoiigrjhhonhgrshdrtghomh
X-ME-Proxy: <xmx:hkhmYbNDWWG5jqtR5vjtSMbPmiaOo5H1abbtGAAHKs9Wtd6bsf567g>
    <xmx:hkhmYY9pHIUzImTwu-fhBpxdNl_um-5ungduh24-F-2BcfQuyLk5NA>
    <xmx:hkhmYTUIqgZiEGXWqHmjBVbHuxLdpd4qkdH3_C0fC2eYaW3LmqwzHg>
    <xmx:h0hmYTa3YlRUS_owCFVD2HGmT2hqDU2zIRae-pRVzYzEbkKkJt8H-A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 22:46:29 -0400 (EDT)
Message-ID: <dd6df3ee84110649d901f041883c3d44c0798cda.camel@mendozajonas.com>
Subject: Re: [PATCH] net: ncsi: Adding padding bytes in the payload
From:   Samuel Mendoza-Jonas <sam@mendozajonas.com>
To:     Joel Stanley <joel@jms.id.au>,
        Kumar Thangavel <kumarthangavel.hcl@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Networking <netdev@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Amithash Prasad <amithash@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        velumanit@hcl.com, patrickw3@fb.com
Date:   Tue, 12 Oct 2021 19:46:28 -0700
In-Reply-To: <CACPK8XcJudWoKgXORvRzGAbtBwHm3a56RULriVABfERZgNgt9w@mail.gmail.com>
References: <20211012062240.GA5761@gmail.com>
         <CACPK8XcJudWoKgXORvRzGAbtBwHm3a56RULriVABfERZgNgt9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-10-12 at 22:44 +0000, Joel Stanley wrote:
> On Tue, 12 Oct 2021 at 06:23, Kumar Thangavel
> <kumarthangavel.hcl@gmail.com> wrote:
> > 
> > Update NC-SI command handler (both standard and OEM) to take into
> > account of payload paddings in allocating skb (in case of payload
> > size is not 32-bit aligned).
> > 
> > The checksum field follows payload field, without taking payload
> > padding into account can cause checksum being truncated, leading to
> > dropped packets.
> 
> Can you help us review this by pointing out where this is described in
> the NCSI spec?
> 
> We've been running this code for a number of years now and I wonder
> why this hasn't been a problem so far.

I'm assuming this is referencing section 8.2.2.2:
If the payload is present and does not end on a 32-bit boundary, one to
three padding bytes equal to 0x00 shall be present to align the
checksum field to a 32-bit boundary.

But I'm also surprised this hasn't caused issues so far if we've been
getting it wrong. Is there an example that reproduces the issue?

Cheers,
Sam

> 
> Cheers,
> 
> Joel
> 
> > 
> > Signed-off-by: Kumar Thangavel <thangavel.k@hcl.com>
> > 
> > ---
> >  net/ncsi/ncsi-cmd.c | 21 +++++++++++++++++----
> >  1 file changed, 17 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
> > index ba9ae482141b..4625fc935603 100644
> > --- a/net/ncsi/ncsi-cmd.c
> > +++ b/net/ncsi/ncsi-cmd.c
> > @@ -214,11 +214,19 @@ static int ncsi_cmd_handler_oem(struct sk_buff
> > *skb,
> >         struct ncsi_cmd_oem_pkt *cmd;
> >         unsigned int len;
> > 
> > +       /* NC-SI spec requires payload to be padded with 0
> > +        * to 32-bit boundary before the checksum field.
> > +        * Ensure the padding bytes are accounted for in
> > +        * skb allocation
> > +        */
> > +
> > +       unsigned short payload = ALIGN(nca->payload, 4);
> > +
> >         len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
> > -       if (nca->payload < 26)
> > +       if (payload < 26)
> >                 len += 26;
> >         else
> > -               len += nca->payload;
> > +               len += payload;
> > 
> >         cmd = skb_put_zero(skb, len);
> >         memcpy(&cmd->mfr_id, nca->data, nca->payload);
> > @@ -272,6 +280,7 @@ static struct ncsi_request
> > *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
> >         struct net_device *dev = nd->dev;
> >         int hlen = LL_RESERVED_SPACE(dev);
> >         int tlen = dev->needed_tailroom;
> > +       int payload;
> >         int len = hlen + tlen;
> >         struct sk_buff *skb;
> >         struct ncsi_request *nr;
> > @@ -281,14 +290,18 @@ static struct ncsi_request
> > *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
> >                 return NULL;
> > 
> >         /* NCSI command packet has 16-bytes header, payload, 4 bytes
> > checksum.
> > +        * Payload needs padding so that the checksum field follwoing
> > payload is
> > +        * aligned to 32bit boundary.
> >          * The packet needs padding if its payload is less than 26
> > bytes to
> >          * meet 64 bytes minimal ethernet frame length.
> >          */
> >         len += sizeof(struct ncsi_cmd_pkt_hdr) + 4;
> > -       if (nca->payload < 26)
> > +
> > +       payload = ALIGN(nca->payload, 4);
> > +       if (payload < 26)
> >                 len += 26;
> >         else
> > -               len += nca->payload;
> > +               len += payload;
> > 
> >         /* Allocate skb */
> >         skb = alloc_skb(len, GFP_ATOMIC);
> > --
> > 2.17.1
> > 


