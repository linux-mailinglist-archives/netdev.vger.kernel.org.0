Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09022EA255
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 18:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfJ3ROI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 13:14:08 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:39252 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfJ3ROI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 13:14:08 -0400
Received: by mail-ot1-f52.google.com with SMTP id t8so2806717otl.6
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 10:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Q8aOVGo60GCyxaRp4dgxZqVmVKNU+VWV0b5HUn2o8U=;
        b=TP6Qap2vHccC2+5/qLKHGl1Ho/K05MAMOGuWuZy2r0YrvhUguc0bNYitBFPLZ1w07D
         nrzMmKtar5QRIGVJmPXVFwxVAK3UIjfBm1CfO6r7oofrC+/Ot6sOOF0+MxqwWjFNzzqn
         8Y6U+SXQxX9LZGEPmXVnxr1erE59OhcAMfUe7qwOpsOMg1ejtnUnpkf0P+ww5lfuJ4JA
         cJNjMfSPItqffgZ0UMqEliEJWVdCfuHzwCjmo+C4tnSYM7glyzLiiklch2OCx0kFxrU4
         VdHzvBA0FaIW0KGMf3S1vhUdD4R4c3L7kw23baW58zXX9tnzCKPa2OQJgThG6azRgn/C
         UiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Q8aOVGo60GCyxaRp4dgxZqVmVKNU+VWV0b5HUn2o8U=;
        b=VQe0tINxqp32htdlIzfrUK/IuNmi+30dKAyPQ62f5/ZBv/eR4UVwQphB92iRefosBj
         nIyWdQ2lpAEFshDKNU4GTIOLGKQk+O1oeKrrplEJtvwkM/3t2eeZ+tw4xctiNGGCKf/m
         31iQ4C6vBWJ1uthrYxtAu4sHu1YN6lwxKP7xS4wSO/3UFYb8YDV/lXrCxBl3Uw4mnmd3
         386YTaMU/z7qGqpjdmwjpady9xdwWU3L9hT6TV1shuZBb2NIQ6pmEBvdsQPEJPat21Vb
         Pwy1C8xqe+67uez8iBAZmQ8ez8XaahyNtPzeX+nJccZz/zWScz1qPpND9so9IhB/fzld
         AQNg==
X-Gm-Message-State: APjAAAUK2PllyFTbKKbxiKNchHTeVvPSmuF8Toz/x/lMkzS8j0hFidaC
        Ahrpqt4I+dWLUB7GPOubi0EZqp7JHxdVY8XxK73B8A==
X-Google-Smtp-Source: APXvYqzGws6FWyhUYPrENsgVlRJxNj1UID7qEIBTl1FXvqUN7ptPIuhX4aDc0pBRU8tOygZ58fmtkQo7ZS3GYMyfCks=
X-Received: by 2002:a9d:66d:: with SMTP id 100mr798621otn.302.1572455646510;
 Wed, 30 Oct 2019 10:14:06 -0700 (PDT)
MIME-Version: 1.0
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org> <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
 <2279a8988c3f37771dda5593b350d014@codeaurora.org> <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
 <f9ae970c12616f61c6152ebe34019e2b@codeaurora.org> <CADVnQymqKpMh3iRfrdiAYjb+2ejKswk8vaZCY6EW4-3ppDnv_w@mail.gmail.com>
 <81ace6052228e12629f73724236ade63@codeaurora.org>
In-Reply-To: <81ace6052228e12629f73724236ade63@codeaurora.org>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 30 Oct 2019 13:13:49 -0400
Message-ID: <CADVnQymDSZb=K8R1Gv=RYDLawW9Ju1tuskkk8LZG4fm3yxyq3w@mail.gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 9:36 PM Subash Abhinov Kasiviswanathan
<subashab@codeaurora.org> wrote:
>
> >> I've queued up a build which logs calls to tcp_write_queue_purge and
> >> clears tp->highest_sack and tp->sacked_out. I will let you know how
> >> it fares by end of week.
> >
> > OK, thanks. That should be a useful data point.
>
> I haven't seen the crash in the testing so far.
> Looks like clearing these values seems to help.

Thanks. Do you mind sharing what your patch looked like, so we can
understand precisely what was changed?

Also, are you able to share what the workload looked like that tickled
this issue? (web client? file server?...)

thanks,
neal
