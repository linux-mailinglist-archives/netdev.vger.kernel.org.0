Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA0F17FDEE
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 14:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgCJNbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 09:31:19 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:35146 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgCJMuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 08:50:03 -0400
Received: by mail-yw1-f67.google.com with SMTP id d79so12405898ywd.2
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 05:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lneMI4/memVWIRrQHffx6BbrjwoYtiBD02PIh1IZOlg=;
        b=JAvESyQxMSmfC1VGFcxQey6J1iNvq7HkazvyK9PPQg2KQixdfa2o9s5nTxJ4eN5pDH
         uKqkjRCVSpbPTpDlOigF4MsBpbLNLmQrTUqgUshSZeQoh40TUiqWYgKJ30XgikEcmdYN
         Bs9o3b8PVJ2SuK4gluXIgafoM7SpE/3AujP0DFBhxPJyFp5DIAixvZY6XuhYOK6N2iRh
         86clcX345I7NXOnKNArC+azZa7sIlBqaXtFnTAebU6eQTnuXvZDdcRhK13gb3Qgl0Ru3
         BVQBW91sJJyy1nwetOKGubyNEwycOgGM+g8MqlpLQCV+PYTahVszHmOb9fHs3qe9KlEV
         xXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lneMI4/memVWIRrQHffx6BbrjwoYtiBD02PIh1IZOlg=;
        b=FFHfJqvliRH7/N0IAcKXvycKxaEMsOOsVZ9e+Nili+fcEs9RQgVL1FPIAFcDT4PXBh
         vXwNlHwLZ4AkD0Qb4ihK1NjM88CPy8RmqMQQ7FoZcFe6NjwK2jnfbB1FQ7XyssX2Y20q
         Usfuo2HjfE1VVcpaVQJaNTlr1/RIyrpJjlJlpanzP4UtKkK2gSjjTgiL3nvGCCONb9i/
         L148rgUYehihlfPuuIFCK9UCqypaNHsAq4yEzWL502f6/U9wDw5QRr0x9fbRKsHuScp7
         ejTQz5B6W//xLp6ASYV/Intum44G+E2YDCDMCVfUgT8VUf1WTLD/rwVIhg1b7uHNIv3O
         subg==
X-Gm-Message-State: ANhLgQ05Vhv5oDBzpXRUYEGU+UVBoezJGYtXlIQ4u54/4jT7rMyEh6Bt
        EYbUidY88oXQJdQoL47Xilblr/Kv
X-Google-Smtp-Source: ADFU+vvtpjeWCntmTSElA4axT9THVK92pW8UNPGbj/6qoctpJWLpuOZjmH9TRx3bxbOLYQ0jZrku3g==
X-Received: by 2002:a25:820a:: with SMTP id q10mr21531845ybk.53.1583844602072;
        Tue, 10 Mar 2020 05:50:02 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id r192sm351056ywg.48.2020.03.10.05.50.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 05:50:01 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id d79so12405791ywd.2
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 05:50:00 -0700 (PDT)
X-Received: by 2002:a81:844f:: with SMTP id u76mr21041826ywf.322.1583844600061;
 Tue, 10 Mar 2020 05:50:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com> <20200310023528-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200310023528-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 10 Mar 2020 08:49:23 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
Message-ID: <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 2:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Mar 09, 2020 at 11:34:35AM -0400, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > In one error case, tpacket_rcv drops packets after incrementing the
> > ring producer index.
> >
> > If this happens, it does not update tp_status to TP_STATUS_USER and
> > thus the reader is stalled for an iteration of the ring, causing out
> > of order arrival.
> >
> > The only such error path is when virtio_net_hdr_from_skb fails due
> > to encountering an unknown GSO type.
> >
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> >
> > ---
> >
> > I wonder whether it should drop packets with unknown GSO types at all.
> > This consistently blinds the reader to certain packets, including
> > recent UDP and SCTP GSO types.
>
> Ugh it looks like you have found a bug.  Consider a legacy userspace -
> it was actually broken by adding USD and SCTP GSO.  I suspect the right
> thing to do here is actually to split these packets up, not drop them.

In the main virtio users, virtio_net/tun/tap, the packets will always
arrive segmented, due to these devices not advertising hardware
segmentation for these protocols.

So the issue is limited to users of tpacket_rcv, which is relatively
new. There too it is limited on egress to devices that do advertise
h/w offload. And on r/x to GRO.

The UDP GSO issue precedes the fraglist GRO patch, by the way, and
goes back to my (argh!) introduction of the feature on the egress
path.

>
> > The peer function virtio_net_hdr_to_skb already drops any packets with
> > unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
> > let the peer at least be aware of failure.
> >
> > And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.
>
> This last one is possible for sure, but for virtio_net_hdr_from_skb
> we'll need more flags to know whether it's safe to pass
> these types to userspace.

Can you elaborate? Since virtio_net_hdr_to_skb users already returns
-EINVAL on unknown GSO types and its callers just drop these packets,
it looks to me that the infra is future proof wrt adding new GSO
types.
