Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6B72B8B0D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 06:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgKSFdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 00:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgKSFdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 00:33:03 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B462C0613D4;
        Wed, 18 Nov 2020 21:33:03 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c9so5943004wml.5;
        Wed, 18 Nov 2020 21:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QWd9qbPGRigsWy3o/O9HDYWfcL9Yf7NlDEvwoZ5Gqio=;
        b=iZ/miRPtGmtAiQMCiilQdC9dvNttBPwyU0D/8CrKq+P1hcpmdBLCBk0H2k2ticoAkG
         wfdn9KTO5LIce1pcSr2zccX6kKwEnrpKYGdaBzed+sKfwfWt5B4DBI29aUYTzgDHP/MH
         duGrkjiY1SGLbGrj6cvXFPB/9ROIXbnIOFl727LIzxEtXDsb/YMvQqc/ckFM8KIqiib3
         WKV7/VHHE3sCWRfSAx3bXCkQEasxrLSdIrLXrYHKPaSReuuFcoVwGd+VsKZsqZnOfhZ7
         EDhwGeVWyL+j+GVk2rJBLyDUU45bvbbi9EzSJ5ktqOG37kRaMaco2GwV954tfEaajs6N
         vs+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QWd9qbPGRigsWy3o/O9HDYWfcL9Yf7NlDEvwoZ5Gqio=;
        b=YWmHqNklPRNqSBXt3wZC5FQLgFOFK2aThvuNfsBijWQgNVE8ZxF2+4eeO/5LsgBl4U
         TeuiQBrAn8tkSAILPT+Zu6SpsD2gzDXU8PJ5+NEyop6mi1uCM43vJuk2xCvH62iqfOk8
         h/8hC2D8Y9Qn5b87iF4q2trq/u05ada2Y2gszpHv4wSbPG+5CWCP+gsGZZ0QWFvrexkY
         ZgBFOZ5IV5qhkZMkud+f5NXhAjPbDPpynR/Sd4o/8UWSix5oXyvEp5O7exizbHZSnXPn
         PD3WUivEbW6M7LUaCMLug43FqC+Flmh6H+LDk6DM9xygZn/5H5wnDtuhcH3bnz38P3xF
         NzYQ==
X-Gm-Message-State: AOAM532ZXOsioH34bLmztSsHWsRo1DPkOIPtQl9TnPJymMj6ABS86syo
        VJ7pnxgaIJOSqqkX/B3PCr9aJD3QRCkxH309oys=
X-Google-Smtp-Source: ABdhPJxk2JcCiIzdiqowkFHyNpA/VxMgNuKW1E3KIvcDyOURZo6HeKYeNpQUA3zuahRFfEllnj555DF+FoIGXpHkYqw=
X-Received: by 2002:a1c:ed06:: with SMTP id l6mr2451043wmh.67.1605763982200;
 Wed, 18 Nov 2020 21:33:02 -0800 (PST)
MIME-Version: 1.0
References: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
 <20201117162952.29c1a699@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CADvbK_eP4ap74vbZ64S8isYr5nz33ZdLB7qsyqd5zqqGV-rvWA@mail.gmail.com> <20201118084455.10f903ec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118084455.10f903ec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 19 Nov 2020 13:32:49 +0800
Message-ID: <CADvbK_eOgye3T8FWb8UuuDfiDeoF7p-RzP7Hb5UOECsR8dZuLQ@mail.gmail.com>
Subject: Re: [PATCH net-next] ip_gre: remove CRC flag from dev features in gre_gso_segment
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, lorenzo@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 12:44 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 18 Nov 2020 14:14:49 +0800 Xin Long wrote:
> > On Wed, Nov 18, 2020 at 8:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Mon, 16 Nov 2020 17:15:47 +0800 Xin Long wrote:
> > > > This patch is to let it always do CRC checksum in sctp_gso_segment()
> > > > by removing CRC flag from the dev features in gre_gso_segment() for
> > > > SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
> > > > sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.
> > > >
> > > > It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
> > > > after that commit, so it would do checksum with gso_make_checksum()
> > > > in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
> > > > gre csum for sctp over gre tunnels") can be reverted now.
> > > >
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > >
> > > Makes sense, but does GRE tunnels don't always have a csum.
> > Do you mean the GRE csum can be offloaded? If so, it seems for GRE tunnel
> > we need the similar one as:
> >
> > commit 4bcb877d257c87298aedead1ffeaba0d5df1991d
> > Author: Tom Herbert <therbert@google.com>
> > Date:   Tue Nov 4 09:06:52 2014 -0800
> >
> >     udp: Offload outer UDP tunnel csum if available
> >
> > I will confirm and implement it in another patch.
> >
> > >
> > > Is the current hardware not capable of generating CRC csums over
> > > encapsulated patches at all?
> > There is, but very rare. The thing is after doing CRC csum, the outer
> > GRE/UDP checksum will have to be recomputed, as it's NOT zero after
> > all fields for CRC scum are summed, which is different from the
> > common checksum. So if it's a GRE/UDP tunnel, the inner CRC csum
> > has to be done there even if the HW supports its offload.
>
> Ack, my point is that for UDP tunnels (at least with IPv4) the UDP
> checksum is optional (should be ignored if the header field is 0),
> and for GRE checksum is optional and it's presence is indicated by
> a bit in the header IIRC.
Yes, it's tunnel->parms.o_flags & TUNNEL_CSUM. When it's not set,
gso_type is set to SKB_GSO_GRE instead of SKB_GSO_GRE_CSUM
by gre_handle_offloads().


>
> So if the HW can compute the CRC csum based on offsets, without parsing
> the packet, it should be able to do the CRC on tunneled packets w/o
> checksum in the outer header.
Right, we can only force it to do CRC csum there when SKB_GSO_GRE_CSUM was set:

        need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
        skb->encap_hdr_csum = need_csum;

        features &= skb->dev->hw_enc_features;
+       if (need_csum)
+               features &= ~NETIF_F_SCTP_CRC;

I will give it a try.

BTW, __skb_udp_tunnel_segment() doesn't need this, as For UDP encaped SCTP,
the UDP csum is always set.

>
> IDK how realistic this is, whether it'd work today, and whether we care
> about it...
