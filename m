Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0700C14F6D2
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 07:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgBAGI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 01:08:58 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34081 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgBAGI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 01:08:58 -0500
Received: by mail-wm1-f65.google.com with SMTP id s144so10270994wme.1;
        Fri, 31 Jan 2020 22:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to;
        bh=ishe3wylxU5DdbmCiVhXoDPa+Jea4eY6AcXsmXmzIFM=;
        b=lDpqA8x8A/NCKTjaahbsIU0krLUS6y0Ky6ZEZ2VgZ0HEk/bFccMZBLbD07jgwPWgBv
         NCq8k5zTqQU3fmzETffHG+D3W/LIEUAumjlwx0+1GRTv1vApjO4U9RvDRSjc2x4MHSzd
         oqolgD7LfXS8e/amRdzyrI3tJ4kbNSTbY77GWlnRRZUEEMglF2TcSUjoyyYd83jexsJ8
         EiWnMqWYkeGEABjiACvFLgvqThV2SN5wec9y5AkJfvYUuFr0KYLPMdNsha+4d5kOizav
         MqcMttv1RTFhIyrHoHWpavdHSj5SKqWFIzVM8EuF8dvm5q/hrqegCSTcZQn2r2tTRpIe
         Selw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to;
        bh=ishe3wylxU5DdbmCiVhXoDPa+Jea4eY6AcXsmXmzIFM=;
        b=Snl7/E5NXoWdnHhxhwI1+2jcsqjEqGdfpWw5THZpmRORtSLRBMOGl9F+Wljn3P17gX
         aNkGNtOxmoLGmcCTEAVtZT6hjD1GBoeOn+ZB1b7vdPgaJvLtVmhMuJ2fo0EVOb/FwY1S
         hgI4faAxYdaDzGgmpjqia91nKui/JWKw/TnX+uWJ2NpwwpQjC3zMLHiLUEx4bBUdjkU4
         RnhTfzmzVUYnc8kX/GL0zb2NjMUM9GYVTyEDSQNSsUTZvRAuU09yD5j67few344mvAV+
         fOA7YZHqM74QzPulXFne9lMwpyT45k/Kvz/H6E56gliqtjEOJfJRNBvxD79QL+trFccz
         duAw==
X-Gm-Message-State: APjAAAU5fibQcpaQjhJwO27aNXKyUqiLq4o4GFTqtYbl6z87C7KsPdb4
        ypADNIxWO9k1vAP9md/uUCw=
X-Google-Smtp-Source: APXvYqxzUQRkgZgwqSu2maQusGbwl1Dh0Bz+Bn8Coh1ZaVif2TXk/PZnDh9dDWPNLyFTNDQaPUuutg==
X-Received: by 2002:a1c:7317:: with SMTP id d23mr16843328wmb.165.1580537336016;
        Fri, 31 Jan 2020 22:08:56 -0800 (PST)
Received: from localhost.localdomain ([2a02:2450:10d2:194d:bcd7:b36c:40fc:d163])
        by smtp.gmail.com with ESMTPSA id c15sm14815486wrt.1.2020.01.31.22.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 22:08:55 -0800 (PST)
From:   SeongJae Park <sj38.park@gmail.com>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     SeongJae Park <sj38.park@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, sjpark@amazon.com,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>, shuah@kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, aams@amazon.com,
        SeongJae Park <sjpark@amazon.de>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: Re: Re: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous ACK is received
Date:   Sat,  1 Feb 2020 07:08:43 +0100
Message-Id: <20200201060843.21626-1-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CADVnQy=oFmmG-Z9QMafWLcALOBgohADgwScn2r+7CGFNAw5jvw@mail.gmail.com> (raw)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 22:55:34 -0500 Neal Cardwell <ncardwell@google.com> wrote:

> On Fri, Jan 31, 2020 at 5:18 PM SeongJae Park <sj38.park@gmail.com> wrote:
> >
> > On Fri, 31 Jan 2020 17:11:35 -0500 Neal Cardwell <ncardwell@google.com> wrote:
> >
> > > On Fri, Jan 31, 2020 at 1:12 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > >
> > > >
> > > >
> > > > On 1/31/20 7:10 AM, Neal Cardwell wrote:
> > > > > On Fri, Jan 31, 2020 at 7:25 AM <sjpark@amazon.com> wrote:
> > > > >>
> > > > >> From: SeongJae Park <sjpark@amazon.de>
> > > > >>
> > > > >> When closing a connection, the two acks that required to change closing
> > > > >> socket's status to FIN_WAIT_2 and then TIME_WAIT could be processed in
> > > > >> reverse order.  This is possible in RSS disabled environments such as a
> > > > >> connection inside a host.
> > [...]
> > >
> > > I looked into fixing this, but my quick reading of the Linux
> > > tcp_rcv_state_process() code is that it should behave correctly and
> > > that a connection in FIN_WAIT_1 that receives a FIN/ACK should move to
> > > TIME_WAIT.
> > >
> > > SeongJae, do you happen to have a tcpdump trace of the problematic
> > > sequence where the "process A" ends up in FIN_WAIT_2 when it should be
> > > in TIME_WAIT?
> >
> > Hi Neal,
> >
> >
> > Yes, I have.  You can get it from the previous discussion for this patchset
> > (https://lore.kernel.org/bpf/20200129171403.3926-1-sjpark@amazon.com/).  As it
> > also has a reproducer program and how I got the tcpdump trace, I believe you
> > could get your own trace, too.  If you have any question or need help, feel
> > free to let me know. :)
> 
> Great. Thank you for the pointer.
> 
> I had one quick question: in the message:
>   https://lore.kernel.org/bpf/20200129171403.3926-1-sjpark@amazon.com/
> ... it showed a trace with the client sending a RST/ACK, but this
> email thread shows a FIN/ACK. I am curious about the motivation for
> the difference?

RST/ACK is traced if LINGER socket option is applied in the reproduce program,
and FIN/ACK is traced if it is not applied.  LINGER applied version shows the
spikes more frequently, but the main problem logic has no difference.  I
confirmed this by testing both of the two versions.

In the previous discussion, I showed the LINGER applied trace.  However, as
many other documents are using FIN/ACK, I changed the trace to FIN/ACK version
in this patchset for better understanding.  I will comment that it doesn't
matter whether it is FIN/ACK or RST/ACK in the next spin.


Thanks,
SeongJae Park

> 
> Anyway, thanks for the report, and thanks to Eric for further clarifying!
> 
> neal
> 
