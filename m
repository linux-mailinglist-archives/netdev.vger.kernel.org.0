Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF65DEB54
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 13:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfJULre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 07:47:34 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:38888 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbfJULre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 07:47:34 -0400
Received: by mail-oi1-f179.google.com with SMTP id d140so6439547oib.5
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 04:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y2Y8DtMTYJdmKTT/tqpNay3sKCQwBBbB1tzl7gaTgTA=;
        b=icCmB5/hqapmEUrP3y4CPrw4SPzEcZ6H5Zd6FQ10ry6SM1gzBrFfKglm+6OvHKhR6l
         4/c838TVPnifMk4nE07E2GvEiG5QHpb5UXFVhxNOjeoM10kUKxzoxX9Uic/rvOAzXU9/
         PchXtoZh5Ql6J1hDmalNZpGZXajpruphM++rxaiFubGPmpfiDYilWrC+1H64L0MLpdtH
         3QmhSnIphO2VnQfb6ruArq0MT1BGndvZFgwO182+bfzfD7iOcsXgkVANqYerK1sIzLLm
         S2vVQ1VvH7xfAk7r7JkiboJ3dASRP9dmzy9vgZNxzpiXOlf8o8BFgg5AAFWwwmv+OdK8
         kQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y2Y8DtMTYJdmKTT/tqpNay3sKCQwBBbB1tzl7gaTgTA=;
        b=lTa7l9+5frRrGpWuhwxKxmZQRyj2ExegZnQoB76V3TkdpjG4ejB4RcOAk3iNMZlcMh
         IoaV9yFLfg0biQ7mG0uYDP9HtRkBc1djOMA/r8zmpa/gEiaV4Ruq3KfFTBBnwb6fyP4P
         iSQD06iF7QQ7LS1PAmWELwOxhVMYtDVuEVEpXljsEDCtaDwyQOL0ynMEdxLjY7YXQR7P
         lVlyMe11CMIYu90FQuVknNS6WPAS1qjLqmdItlMug++HqIKtM1+LWs3IKEYp/qFWCW0j
         M6OQjDPcjRaJP7QVJQ/DXs5oN+j5F8zsWiO3Vo1PhYA2Ycs8KraZ+m98f7C/oKZBn3cH
         Ahjg==
X-Gm-Message-State: APjAAAWp8gcDcEpnxkSBT1HkOyyyfbFR5NpXgn1qcvC8c44om9hg10hc
        xWMtzoLb7honmRrkRsEO2pXAWSfxAAO71bVhlBIptQ==
X-Google-Smtp-Source: APXvYqyDL02n2xT1mIqWSuKGtRPs7R4tr6QsZ/aPW5Um9qOpUse8jWn5UXeOkHBj66nhbO+p3sACO+l/SL9J0a+LOo8=
X-Received: by 2002:a54:4e8a:: with SMTP id c10mr18666231oiy.14.1571658452980;
 Mon, 21 Oct 2019 04:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org> <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
 <2279a8988c3f37771dda5593b350d014@codeaurora.org>
In-Reply-To: <2279a8988c3f37771dda5593b350d014@codeaurora.org>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 21 Oct 2019 07:47:16 -0400
Message-ID: <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 10:45 PM Subash Abhinov Kasiviswanathan
<subashab@codeaurora.org> wrote:
>
> > FIN-WAIT1 just means the local application has called close() or
> > shutdown() to shut down the sending direction of the socket, and the
> > local TCP stack has sent a FIN, and is waiting to receive a FIN and an
> > ACK from the other side (in either order, or simultaneously). The
> > ASCII art state transition diagram on page 22 of RFC 793 (e.g.
> > https://tools.ietf.org/html/rfc793#section-3.2 ) is one source for
> > this, though the W. Richard Stevens books have a much more readable
> > diagram.
> >
> > There may still be unacked and SACKed data in the retransmit queue at
> > this point.
> >
>
> Thanks for the clarification.
>
> > Thanks, that is a useful data point. Do you know what particular value
> >  tp->sacked_out has? Would you be able to capture/log the value of
> > tp->packets_out, tp->lost_out, and tp->retrans_out as well?
> >
>
> tp->sacket_out varies per crash instance - 55, 180 etc.
> However the other values are always the same - tp->packets_out is 0,
> tp->lost_out is 1 and tp->retrans_out is 1.

Interesting! As tcp_input.c summarizes, "packets_out is
SND.NXT-SND.UNA counted in packets". In the normal operation of a
socket, tp->packets_out should not be 0 if any of those other fields
are non-zero.

The tcp_write_queue_purge() function sets packets_out to 0:

  https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/net/ipv4/tcp.c?h=v4.19#n2526

So the execution of tcp_write_queue_purge()  before this point is one
way for the socket to end up in this weird state.

> > Yes, one guess would be that somehow the skbs in the retransmit queue
> > have been freed, but tp->sacked_out is still non-zero and
> > tp->highest_sack is still a dangling pointer into one of those freed
> > skbs. The tcp_write_queue_purge() function is one function that fees
> > the skbs in the retransmit queue and leaves tp->sacked_out as non-zero
> > and  tp->highest_sack as a dangling pointer to a freed skb, AFAICT, so
> > that's why I'm wondering about that function. I can't think of a
> > specific sequence of events that would involve tcp_write_queue_purge()
> > and then a socket that's still in FIN-WAIT1. Maybe I'm not being
> > creative enough, or maybe that guess is on the wrong track. Would you
> > be able to set a new bit in the tcp_sock in tcp_write_queue_purge()
> > and log it in your instrumentation point, to see if
> > tcp_write_queue_purge()  was called for these connections that cause
> > this crash?
>
> Sure, I can try this out.

Great! Thanks!

neal
