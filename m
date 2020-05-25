Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B5C1E08C1
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388182AbgEYIZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388093AbgEYIZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:25:27 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEF9C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 01:25:26 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u22so7219889plq.12
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 01:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=13+JqBV7jtPNEvoSDi+XNPQNljVYlYe9Z8vbyEZUo6g=;
        b=FpH8WyVxihV6Uku8Ltay5mXNNuo2WdoZcpuTBQsLD0RbBp16Mj/O0JiWUv1XGk19Sb
         XpMBTXS+XxEo8k4/n6ll7crxKYzCX0Y1OHJUbbpDhfu+amlFbDYz2CuoNNqCcGMyBAYL
         NHFWTNKTIZMf7/uhbWXdLZyC8yp7Q4GQWarCU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=13+JqBV7jtPNEvoSDi+XNPQNljVYlYe9Z8vbyEZUo6g=;
        b=ioFs9dtGb5K/6rP5p5mYR0sBLHfe7ERGHnbba/lsNPu19LUDNbwrj+uwbOavK1EcmE
         2vxWgh9+CYS+tzX2oF4sA2PH6Da6PZ7GaijIldNNEU8rsX9NtbxKaEzvB0WYRcNFbA0h
         mzCnDmZfpyEPPf0zlS4pALOorkTKvRY3MDQP0vbC4gq7TN2IwxcIftD1ju5iTOckbjdb
         LJtbeshnUdUqtcTIy+F17g9t4qQnSWAx78j0767/WXKrrNcs7Jb5DxaSqAsi/8LneMDL
         j/rjT1KueH37fraJ85yYCI6B59FdLJkll5fVo7v5zNTK3Dt7cezc4D7EpDGMQkZy9dUe
         n8CA==
X-Gm-Message-State: AOAM531OYs/OSQkYGB5wkGEQoU0pVn+Qxyxdl69QEqAYf/WD1LDpinnZ
        4WHoJn2e8rkEIXLCE2cogOou5Q==
X-Google-Smtp-Source: ABdhPJyXy4mevldmnnFO8nUwP424Pw1giVP8nexyPhbbsr8Xf279gkVeiyi6XX97Yv18VCgIyBRJ7A==
X-Received: by 2002:a17:902:9895:: with SMTP id s21mr7224407plp.335.1590395126454;
        Mon, 25 May 2020 01:25:26 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id b20sm12718290pfb.193.2020.05.25.01.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 01:25:25 -0700 (PDT)
Date:   Mon, 25 May 2020 17:25:21 +0900
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next] net: Avoid spurious rx_dropped increases with
 tap and rx_handler
Message-ID: <20200525082521.GA414144@f3>
References: <20200525050137.412072-1-bpoirier@cumulusnetworks.com>
 <CANn89iLdfOzRuhC--MALZuTDSoU6ncX7Xu_0iJnjZs1-9_gwmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLdfOzRuhC--MALZuTDSoU6ncX7Xu_0iJnjZs1-9_gwmQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-24 22:41 -0700, Eric Dumazet wrote:
> On Sun, May 24, 2020 at 10:02 PM Benjamin Poirier
> <bpoirier@cumulusnetworks.com> wrote:
> >
> > Consider an skb which doesn't match a ptype_base/ptype_specific handler. If
> > this skb is delivered to a ptype_all handler, it does not count as a drop.
> > However, if the skb is also processed by an rx_handler which returns
> > RX_HANDLER_PASS, the frame is now counted as a drop because pt_prev was
> > reset. An example of this situation is an LLDP frame received on a bridge
> > port while lldpd is listening on a packet socket with ETH_P_ALL (ex. by
> > specifying `lldpd -c`).
> >
> > Fix by adding an extra condition variable to record if the skb was
> > delivered to a packet tap before running an rx_handler.
> >
> > The situation is similar for RX_HANDLER_EXACT frames so their accounting is
> > also changed. OTOH, the behavior is unchanged for RX_HANDLER_ANOTHER frames
> > - they are accounted according to what happens with the new skb->dev.
> >
> > Fixes: caf586e5f23c ("net: add a core netdev->rx_dropped counter")
> 
> I disagree.
> 
> > Message-Id: <20200522011420.263574-1-bpoirier@cumulusnetworks.com>
[...]
> > +               if (!rx_tapped) {
> >  drop:
> > -               if (!deliver_exact)
> > -                       atomic_long_inc(&skb->dev->rx_dropped);
> > -               else
> > -                       atomic_long_inc(&skb->dev->rx_nohandler);
> > +                       if (!deliver_exact)
> > +                               atomic_long_inc(&skb->dev->rx_dropped);
> > +                       else
> > +                               atomic_long_inc(&skb->dev->rx_nohandler);
> > +               }
> 
> This does not make sense to me.
> 
> Here we call kfree_skb() meaning this packet is _dropped_.
> I understand it does not please some people, because they do not
> always understand the meaning of this counter, but it is a mere fact.

IMO, the core of the issue is calling deliver_skb() before running the
rx_handler function. The rx_handler may not even attempt to deliver the
skb anywhere (RX_HANDLER_PASS). Because of that deliver_skb() call, the
packet_type handler (packet_rcv()) makes a spurious skb_clone(). Once a
useless copy has been made, it has to be freed somewhere. That's why
with my patch there may be kfree_skb() without an increase of the
dropped counter.

> 
> Fact that a packet capture made a clone of this packet should not
> matter, tcpdump should not hide that a packet is _dropped_.

What this patch intends to fix is that the behavior is inconsistent
depending on whether the interface has an rx_handler or not:
	eth0 nomaster -> tapped frames don't count as dropped
	eth0 master br0 -> tapped frames count as dropped
That has been the case since the counter was introduced.

This patch makes tapped frames uniformly not count as drops. If we
should move in the other direction (always count frames that were only
delivered to ptype_all handlers as dropped), I'll work on a different
patch.
