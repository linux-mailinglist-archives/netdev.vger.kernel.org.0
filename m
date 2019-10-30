Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5876EA373
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 19:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfJ3SfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 14:35:07 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39393 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbfJ3SfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 14:35:06 -0400
Received: by mail-qt1-f196.google.com with SMTP id t8so4613920qtc.6;
        Wed, 30 Oct 2019 11:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JYycG46Owic+1nSINe2frGAFp05tmpnx09Umb+WfpyI=;
        b=Ki2qz+RL5Lw2ZXCLeh5Umol0vBFU6HkirckbR6RgiAwUjmFfMHESMoF2hrMuXQWIIi
         q0+8CRjlW4tFiK0DPnyDvE5mRrQ8WS8rFVkwT+qbSNDmi7sf/8B0jKUYRxBDvUsa+f7P
         7vS0edaOyLek4QrMJrAKDdl04gF3JL1qQi8I0TKl7Eq6m8fjbTDcpYEN0HMUVsQkmqOJ
         jDdzw0trnxbIWyLcnDkWR6rCTtIjw56dePIB/HUlHj8bs7Z2cQ/zfJkSxa0vzasbiJ9q
         Gb5Ok1yeCXVug1s0uKDGIsx9LZqdfIEH0g0GD44uH+OuyFPiECiMKkokWJ2ZMVoDqGgz
         jgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JYycG46Owic+1nSINe2frGAFp05tmpnx09Umb+WfpyI=;
        b=XFEPj1g8dN62JBLLrUZLxlRm/oYcgw3jm13paW9Dh80xI18MyfvQSFq6NcgpRflfMH
         RbJ1BOKPd3xrhQ+TmcPUFfUlV8KOSQsuCO0mPPzTGwy43EvnQW7tW5LLy505ruq3CBSO
         aHQ+yE5UMReYG6jxtmJtJhFSGzuN7uSQ/MEmFjNufEbYa1OZpcE2Q7R4DzKNgB9oDH6M
         SFGPA08D034rzqYPRZJSGFV/Sg9W7QvKM0VapBNd2zb59nf1e8Fd1Jsdfz2o7mDx9/Nq
         jA12UG03tbn1e0kJmNz7eJavltGwP6CXat+Xzmp+SU5t83dsCWQLYRJbf227wkm0nBH4
         ZMOw==
X-Gm-Message-State: APjAAAUjX45+JN412iQWCSwCVx8flhCzsa47wRmxSPMynet6Rq2mJPKj
        EzmPIku9AwmY/3N2r106bKYjFe+eRLs=
X-Google-Smtp-Source: APXvYqxBgQN8qv2O88BSFeTnE9GFfH28S81Q4e9QR0BCcVc8h0IKy/CI0dCnXZE9br0fIJrb5XGeUA==
X-Received: by 2002:ac8:5350:: with SMTP id d16mr1300872qto.319.1572460504419;
        Wed, 30 Oct 2019 11:35:04 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:326e:3cb7:46e:7f5e:cff5])
        by smtp.gmail.com with ESMTPSA id o3sm531523qkf.97.2019.10.30.11.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 11:35:03 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7B68DC0AD9; Wed, 30 Oct 2019 15:35:00 -0300 (-03)
Date:   Wed, 30 Oct 2019 15:35:00 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Wei Zhao <wallyzhao@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wally.zhao@nokia-sbell.com
Subject: Re: [PATCH] sctp: set ooo_okay properly for Transmit Packet Steering
Message-ID: <20191030183500.GH4250@localhost.localdomain>
References: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com>
 <20191030132420.GG4326@localhost.localdomain>
 <CAFRmqq42HqX5KctcNjwyZJ4jdknLSZ1EyBqHnJQQJx211mWopw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRmqq42HqX5KctcNjwyZJ4jdknLSZ1EyBqHnJQQJx211mWopw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 11:54:45PM +0800, Wei Zhao wrote:
> On 10/30/19, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > On Wed, Oct 30, 2019 at 12:07:17PM -0400, Wally Zhao wrote:
> >> Unlike tcp_transmit_skb,
> >> sctp_packet_transmit does not set ooo_okay explicitly,
> >> causing unwanted Tx queue switching when multiqueue is in use;
> >
> > It is initialized to 0 by __alloc_skb() via:
> >         memset(skb, 0, offsetof(struct sk_buff, tail));
> > and never set to 1 by anyone for SCTP.
> >
> > The patch description seems off. I don't see how the unwanted Tx queue
> > switching can happen. IOW, it's not fixing it OOO packets, but
> > improving it by allowing switching on the first packet. Am I missing
> > something?
> 
> Thanks for pointing this out. You are right. This ooo_okay is default to false.
> 
> I was observing some Tx queue switching before when testing with
> iperf3 (modified to be able to set window size, for higher throughput
> with long RTT), so I thought ooo_okay was set to true somewhere else
> after allocation. Just now I did the test again, it turns out that
> iperf3 made a re-connect silently which caused the Tx queue change.

Ah, okay.

> 
> As for the improving purpose of this patch, that is not that critical
> from my side, and the patch description is not correct for this
> purpose. So I will give up this patch attempt. Thank you again for
> your time on this.

As you wish. If you don't have the time for it, ok, but the
improvement is welcomed. With a more accurate description and using
tp->flight_size instead, it should be good.

Thanks,
  Marcelo

> 
> >
> >> Tx queue switching may cause out-of-order packets.
> >> Change sctp_packet_transmit to allow Tx queue switching only for
> >> the first in flight packet, to avoid unwanted Tx queue switching.
> >>
> >> Signed-off-by: Wally Zhao <wallyzhao@gmail.com>
> >> ---
> >>  net/sctp/output.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/net/sctp/output.c b/net/sctp/output.c
> >> index dbda7e7..5ff75cc 100644
> >> --- a/net/sctp/output.c
> >> +++ b/net/sctp/output.c
> >> @@ -626,6 +626,10 @@ int sctp_packet_transmit(struct sctp_packet *packet,
> >> gfp_t gfp)
> >>  	/* neighbour should be confirmed on successful transmission or
> >>  	 * positive error
> >>  	 */
> >> +
> >> +	/* allow switch tx queue only for the first in flight pkt */
> >> +	head->ooo_okay = asoc->outqueue.outstanding_bytes == 0;
> >
> > Considering we are talking about NIC queues here, we would have a
> > better result with tp->flight_size instead. As in, we can switch
> > queues if, for this transport, the queue is empty.
> >
> >> +
> >>  	if (tp->af_specific->sctp_xmit(head, tp) >= 0 &&
> >>  	    tp->dst_pending_confirm)
> >>  		tp->dst_pending_confirm = 0;
> >> --
> >> 1.8.3.1
> >>
> >
