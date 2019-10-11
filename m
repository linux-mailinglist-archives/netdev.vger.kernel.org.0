Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79951D44CF
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 17:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfJKP6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 11:58:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56015 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfJKP6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 11:58:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id a6so10937359wma.5;
        Fri, 11 Oct 2019 08:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0f+AWbiCUqr+cF1B8DnOhTxug9gYQNFxCNQjY7BfECw=;
        b=AU+jLQEmOpaHOx4G5VFQ2wexmRSC0sNm5BqBKnVvXIvGw1IFHv7xlkDIq9nVqlEx7Q
         byUP0PlgpAa/eHEXr0vc3UdHar3diGUa3Hqwb1oq5IvlQur8CaLtFHivn97vS28I88/I
         Uzv5wf8OGpY9wJWqshcvHGv7tb+vrk+NQODAmSTx4LzPkjXcYTHMoEbpwthXPnB8rU1I
         Hc7/cZ/FShUFoAqIw4/kNzhKjrJO0roYo9+3qeUCzhF8LK/pfafR/TOQGZmCrGcFZNqD
         riUf5y1N6NjfJ6HUevw/TqeHpc8cz/1905yv3I/iLtiolpSxUmSFHh01MGiCN5a+t1EY
         1nCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0f+AWbiCUqr+cF1B8DnOhTxug9gYQNFxCNQjY7BfECw=;
        b=tqR7krLoZPfRjbl44KXS7bGJZE7TJPCT85LMX10Usy+yBzQQJgs01FIvzL8jkPWn7D
         d6POMSGF+W17QLO7cQpFZjZuQ2+RZdJ4dHDWQ113xZ0I1+ybc3IY8WYQSlUhD8GGSGWI
         e97Q7C7dxR14/P/Dq2Dp165Pb5suTCCnVz1KQ0x8hd87PZ2k4OGBjfgwQISinp5ody1+
         JokZW64/feX3Fxn5TxRA2f5FcR3d5DzfEttGKN706PaOb1c4m8xehxff6J3oyqhnBVgN
         TvgVtf2WkkgwJYFaHfRn31ucSm9q9e85TtR/emF9tsX+mNjeHIcUhOXA8wLk5Gwf3Fln
         x6KA==
X-Gm-Message-State: APjAAAVo3a+av46uS7Pk8e+PDe2PQ1/96OHG8rtnT8w2wKWSE0i+M49x
        VTvLruWT1tJFr/p869AnMkvmH9WhRYbDB4+4zok=
X-Google-Smtp-Source: APXvYqypw05LzaEHTLHoieF38lBZdqRb+qpQv++bgupDiQDq4JAR17sGuGjbrR7C7q5OaRaCA8HaE+x0MsJyfXHHUXg=
X-Received: by 2002:a7b:c3cf:: with SMTP id t15mr3690126wmj.85.1570809482473;
 Fri, 11 Oct 2019 08:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570533716.git.lucien.xin@gmail.com> <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com> <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
 <20191009161508.GB25555@hmswarspite.think-freely.org> <CADvbK_eJh0ghjrrqcx7mygEY94QsxxbV=om8BqWPEcXxUHFmHw@mail.gmail.com>
 <20191010124045.GA29895@hmswarspite.think-freely.org>
In-Reply-To: <20191010124045.GA29895@hmswarspite.think-freely.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 11 Oct 2019 23:57:58 +0800
Message-ID: <CADvbK_d-djw00DBTmu7XCpxrfNvCF-xksWT9gV_VP_-zLv=NkA@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
 sockopt
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     David Laight <David.Laight@aculab.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 8:40 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Thu, Oct 10, 2019 at 05:28:34PM +0800, Xin Long wrote:
> > On Thu, Oct 10, 2019 at 12:18 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > On Tue, Oct 08, 2019 at 11:28:32PM +0800, Xin Long wrote:
> > > > On Tue, Oct 8, 2019 at 9:02 PM David Laight <David.Laight@aculab.com> wrote:
> > > > >
> > > > > From: Xin Long
> > > > > > Sent: 08 October 2019 12:25
> > > > > >
> > > > > > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > > > > > the Potentially Failed Path State", by which users can change
> > > > > > pf_expose per sock and asoc.
> > > > >
> > > > > If I read these patches correctly the default for this sockopt in 'enabled'.
> > > > > Doesn't this mean that old application binaries will receive notifications
> > > > > that they aren't expecting?
> > > > >
> > > > > I'd have thought that applications would be required to enable it.
> > > > If we do that, sctp_getsockopt_peer_addr_info() in patch 2/5 breaks.
> > > >
> > > I don't think we can safely do either of these things.  Older
> > > applications still need to behave as they did prior to the introduction
> > > of this notification, and we shouldn't allow unexpected notifications to
> > > be sent.
> > >
> > > What if you added a check in get_peer_addr_info to only return -EACCESS
> > > if pf_expose is 0 and the application isn't subscribed to the PF event?
> > We can't subscribe to PF event only, but all the SCTP_PEER_ADDR_CHANGE
> > events.
> >
> > Now I'm thinking both PF event and "return -EACCES" in get_peer_addr_info
> > are new, we should give 'expose' a default value that would disable both.
> > How do think if we set 'pf_expose = -1' by default. We send the pf event
> > only if (asoc->pf_expose > 0) in sctp_assoc_control_transport().
> >
> And if pf_expose = 0, we send the event, and return -EACCESS if we call
> the socket option and find a PF assoc?  If so, yes, I think that makes
> sense.
pf_expose:
-1: compatible with old application (by default)
0: not expose PF to user
1: expose PF to user

So it should be:
if pf_expose == -1:  not send event, not return -EACCESS
if pf_expose == 0: not send event, return -EACCESS
if pf_expose > 0: sent event, not return -EACCESS

makes sense?

>
> Neil
>
> > >
> > > Neil
> > >
> > > > >
> > > > >         David
> > > > >
> > > > > -
> > > > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > > > Registration No: 1397386 (Wales)
> > > > >
> > > >
> >
