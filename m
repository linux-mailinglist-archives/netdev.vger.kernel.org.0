Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6942627D4E5
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgI2Rtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbgI2Rtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 13:49:42 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D340C061755;
        Tue, 29 Sep 2020 10:49:42 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e17so5503065wme.0;
        Tue, 29 Sep 2020 10:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ceR6IUEQV0hzCj0eJ/QgTQZ9V0xrxAWWeSh8GIv+wXA=;
        b=C62nYQFpvHQ/bEUzUOTXwQnppPlJxBikUOwf0TlUGniK3QhrMyvGkpqdXG69oJPrLl
         FExtHhc20sJUBrhWn//yQf+kkcCH9dZoEXilj8YvEjhuNXF+KstlT+2oshTyG0xaPb04
         tITlCBXzZz8JLgISMvgU2O2LkQP5Lw/4f6JL2zcMTM/RktM8aglhF2hKjECrxn2zaZ9e
         n4RB1ua4Z6423bm2iJ/VBqrsukTO8buxapBUlNgNqgFKbwtveTCmK3ROFogjfy4Bm8TT
         5Phb42Y4o9R/61PWuESn0TbkPIiAkihdRi8ZBCtgNAkdk/GxaVhQAT8BM9wC+Zffz3Pg
         gyvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ceR6IUEQV0hzCj0eJ/QgTQZ9V0xrxAWWeSh8GIv+wXA=;
        b=AvytfXayRxRsQpj9ye0G+bCZUmeE+5L6ACU8v0/ii8L8lYakgYI1iGCK2WLchD17VP
         YevNTZzFcXDUNLzK6m5zQ2uJENfz3/qcqykd/ZGk7l0+PoseL7jY72IOm4PL6GzsCt6b
         mx/ULyeduTZ5NSlBjZcjYHIe1itzrJIiLYnzt92Yt1UNW/el6K7s55TsEVguZg0rLGPi
         li6/gYTlIr7AMmpPDNByVtpLoGaEpPAgbDXNdXf3U1vESqao+7wM6ruAlvT0Jxd4qQq+
         NNzuO1hj44zxchTu+2mG3l+juXV6DKl4rJo3IIYO+7yovjsSbIzNQkcUPXaxOZsHZHhA
         TlOQ==
X-Gm-Message-State: AOAM530UhaioO/FjPberAXFnaEWi3Sxa6LYu5RWqOq+OQS9B47De8LvX
        f/cxKannXC6ccjVh3V872K/oHv9eP/ZDNYOiki5ePz+FaNE=
X-Google-Smtp-Source: ABdhPJyTi4l7VkpdNJ0CyyiD5exbQZNbvlpRl9Xd+8rAdXtMNI/KaIrHA9yCcQ3hMeDicq2au8jtSCwQvFEBbPPrJQQ=
X-Received: by 2002:a05:600c:283:: with SMTP id 3mr5955239wmk.110.1601401780882;
 Tue, 29 Sep 2020 10:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1601387231.git.lucien.xin@gmail.com> <F02013B3-C485-4998-B68A-26118D8ACF9C@fh-muenster.de>
In-Reply-To: <F02013B3-C485-4998-B68A-26118D8ACF9C@fh-muenster.de>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 30 Sep 2020 02:04:51 +0800
Message-ID: <CADvbK_eWR8yw-kV_cVg93caRpEVziCwN_V6gnB7TLM9xxKWpeg@mail.gmail.com>
Subject: Re: [PATCH net-next 00/15] sctp: Implement RFC6951: UDP Encapsulation
 of SCTP
To:     Michael Tuexen <tuexen@fh-muenster.de>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Tom Herbert <therbert@google.com>, davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 12:40 AM Michael Tuexen <tuexen@fh-muenster.de> wrote:
>
> > On 29. Sep 2020, at 15:48, Xin Long <lucien.xin@gmail.com> wrote:
> >
> > Description From the RFC:
> >
> >   The Main Reasons:
> >
> >   o  To allow SCTP traffic to pass through legacy NATs, which do not
> >      provide native SCTP support as specified in [BEHAVE] and
> >      [NATSUPP].
> >
> >   o  To allow SCTP to be implemented on hosts that do not provide
> >      direct access to the IP layer.  In particular, applications can
> >      use their own SCTP implementation if the operating system does not
> >      provide one.
> >
> >   Implementation Notes:
> >
> >   UDP-encapsulated SCTP is normally communicated between SCTP stacks
> >   using the IANA-assigned UDP port number 9899 (sctp-tunneling) on both
> >   ends.  There are circumstances where other ports may be used on
> >   either end, and it might be required to use ports other than the
> >   registered port.
> >
> >   Each SCTP stack uses a single local UDP encapsulation port number as
> >   the destination port for all its incoming SCTP packets, this greatly
> >   simplifies implementation design.
> >
> >   An SCTP implementation supporting UDP encapsulation MUST maintain a
> >   remote UDP encapsulation port number per destination address for each
> >   SCTP association.  Again, because the remote stack may be using ports
> >   other than the well-known port, each port may be different from each
> >   stack.  However, because of remapping of ports by NATs, the remote
> >   ports associated with different remote IP addresses may not be
> >   identical, even if they are associated with the same stack.
> >
> >   Because the well-known port might not be used, implementations need
> >   to allow other port numbers to be specified as a local or remote UDP
> >   encapsulation port number through APIs.
> Hi Xin Long,
>
> I really appreciate that UDP encapsulation gets implemented in Linux.
>
> The FreeBSD implementation initially had a bug due to missing text in
> RFC6951. Please make sure the implementation also follows
> https://www.ietf.org/id/draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.html
Hi, Michael

Thanks for sharing this doc.

3. Handling of Out of the Blue Packets:
This patchset can handle it well.

4. Handling of SCTP Packets Containing an INIT Chunk Matching an
Existing Associations:
These cases responding with ABORT, I will need to add.

>
> The plan is to revise RFC6951 and let RFC6951bis include the contents of
> the above Internet Draft. But this most likely will happen after the
> NAT document is ready and RFC4960bis finished...
understand.

>
> If you want to do some interop testing, a web server supporting SCTP/UDP
> is running at interop.fh-muenster.de. You can find a client (phttpget) at
> https://github.com/NEAT-project/HTTPOverSCTP.
got it.
