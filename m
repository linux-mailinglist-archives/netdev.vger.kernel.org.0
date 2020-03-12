Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEE71828F9
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387909AbgCLG2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:28:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34950 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387831AbgCLG2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:28:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583994486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pzps2FrGRoscMGdp2/H0JZquKXPmO9jZ6wVd33bka+Q=;
        b=QiWPqO6O7buaTLtrmSyRqrQs2Amw6SzNW5+C5CQCUgGgtkZ11aogO4M4FFaTZOSAAs+BnE
        E3WmYYYqh5+b4m1xwkY60Di6vodjSRqBKSMMjmb1bIu/KbhGH1plBxxBhOYZvteo7dEg/o
        RzXhpuGGIK137EhpYlm5HuXgEn0okbU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-eEYDyKWwOvChKN5Rw64DcQ-1; Thu, 12 Mar 2020 02:28:05 -0400
X-MC-Unique: eEYDyKWwOvChKN5Rw64DcQ-1
Received: by mail-qv1-f72.google.com with SMTP id r16so2898559qvp.13
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 23:28:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pzps2FrGRoscMGdp2/H0JZquKXPmO9jZ6wVd33bka+Q=;
        b=UwPpHxOPbi5NSyyZOSrqnNoNp14+kBNcEidQU7tqomMQWj1c1JbQ/km+a2WE52evdR
         GlYThG7yiAW/bIL9yyPf3dKvp1H5U4yiBTbb7bSzv/ySEsjtwDSSkIwUBJSZXt70BgeF
         osnwksEz1ikvnsvTbKtVc3vzo8GtRu7ZfigTrtnVIrX+BUV8q+2Oz9kD4oETjgxBESxb
         3Y30h403zFztJ+A5inDHuJvBTiIfyLQK75ai5ofRYJ3IZ7mstyi8zHkmPDKFSpbC9fr8
         FWqrG7QPLuc4i7eXBdlOh+gqmx2f81lXzyGw7dnJcUegoY9F0VPhqBHVaaeP6Hs9bZOa
         MhSA==
X-Gm-Message-State: ANhLgQ0twNU1PQjI6rd9f/rhImeHIsCe/ly5rsRMa/EV9VKOJ7drau4P
        zz2BjLZIP3JhvEJJZUgsuFpPjiP0YjicLBST976nnf6AnEhdw3SzVod9VGxhC+X2nn0C5l58Xo6
        Mjcf5z5S8+xhHNxIg
X-Received: by 2002:a37:6311:: with SMTP id x17mr6425019qkb.93.1583994484313;
        Wed, 11 Mar 2020 23:28:04 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsN/Nhxke6ox0IMMtmBDBDgnd3HlLv+FYDH3hYNTGLEPbFFJQY7Gy+1BP46nwLNQE+hJwNPEg==
X-Received: by 2002:a37:6311:: with SMTP id x17mr6425011qkb.93.1583994484100;
        Wed, 11 Mar 2020 23:28:04 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id n4sm26591776qti.55.2020.03.11.23.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 23:28:03 -0700 (PDT)
Date:   Thu, 12 Mar 2020 02:27:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        willemb@google.com
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
Message-ID: <20200312022748-mutt-send-email-mst@kernel.org>
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
 <20200311.231327.132987828940639157.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311.231327.132987828940639157.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 11:13:27PM -0700, David Miller wrote:
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Mon,  9 Mar 2020 11:34:35 -0400
> 
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
> 
> I'm applying this, as it fixes the ring state management in this case.
> 
> The question of what we should actually be doing for unknown GSO types
> is a separate discussion.
> 
> Thanks Willem.

Absolutely, I agree

Acked-by: Michael S. Tsirkin <mst@redhat.com>

