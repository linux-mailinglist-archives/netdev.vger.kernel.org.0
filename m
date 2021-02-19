Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5ED31FA06
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 14:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBSNlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 08:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBSNlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 08:41:37 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2C2C061574;
        Fri, 19 Feb 2021 05:40:57 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id w1so5888457oic.0;
        Fri, 19 Feb 2021 05:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yoVL2D4+LT7sKASDLnQ/LSymbuFdWmRjWO8AU2rt+7A=;
        b=LhUmTuBcAD/VgVzTrhbFgzpOw+cDCcGx9fGim4njjQD4l+uqQ36DZV++8c5KCrVLGV
         NHfwG5pPyK0uWvihdSc05zco8vtk6+xxKF96K22qBQOM/xPrFAMddl4s9vaI5+FD2IgF
         U5IbH9m1ACEfxIPei/HrnXKOXQ0Blu91rASX739VcvLuh+WY0qsMntmO1ysLuX+5pdSg
         OQfT887DoXX+as24iTx0tUErMqCsGsCy4bIRHlxx17P1qIFnQxctGboZVevClnBuBIjt
         qrXktc2/uuDAkSVPz6KWsGzmCx7xr++zQeRInbk3KcYrg4dqp/TQKl9h145YTIsSrLRn
         HMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yoVL2D4+LT7sKASDLnQ/LSymbuFdWmRjWO8AU2rt+7A=;
        b=jFo262A1GIEFncq4dCZuWzAqG+fpa60zeGutB1DPLraCKryPr7t3gUzpkChxPBQbgg
         9wV+ON9E9k7Gh3HWCwORGkODn8eWubMzccYyLhY7DcAGD6is6GPlbu6n/X6AtUqDPi9w
         rIOHQoyLar9vPzKOz/9fgW790iyYU6ZFJ5jOOL0jOD8TVRr8ZLQ1t9nRM9ch9wmriIw7
         w54za12ChDhkobLdvn1Qz/hIv4B7m/R2XLkmcNVyEosQnPD3GM2VDF5DDEfgaMzcyMg2
         gFY7L8OGBNwi0kYQM6o/ewmWqhk6j6huciRi5nfEk+Otn8YjE7c1qvvWUosYNWCCivcj
         Z3fQ==
X-Gm-Message-State: AOAM533KuV9KR28Pmx0owq6iQJo2gG4UfZkXfbRn/1DTcWwcAPpqEAIb
        V0VUQBZSCTtDEnUtorunV1XeKtyXofNpvVq9BQ==
X-Google-Smtp-Source: ABdhPJweOAv3CWYZX7+TVkptEOU4MxReAhbRks5qrJflAN8wQXpU8KWAbI5tNuJUU4Fb3TElqZRIsJmz4Yl9r0gidaM=
X-Received: by 2002:aca:da83:: with SMTP id r125mr6745884oig.127.1613742056820;
 Fri, 19 Feb 2021 05:40:56 -0800 (PST)
MIME-Version: 1.0
References: <CAFSKS=Ncr-9s1Oi0GTqQ74sUaDjoHR-1P-yM+rNqjF-Hb+cPCA@mail.gmail.com>
 <20210218150116.1521-1-marco.wenzel@a-eberle.de> <CAFSKS=OpnDK83F6MWCpGDg2pdY-enJyusB5Th1RGvq8UC1WCNQ@mail.gmail.com>
 <65ce3da11b8b4a3197835c5a85c40ce5@EXCH-SVR2013.eberle.local>
In-Reply-To: <65ce3da11b8b4a3197835c5a85c40ce5@EXCH-SVR2013.eberle.local>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Fri, 19 Feb 2021 07:40:44 -0600
Message-ID: <CAFSKS=MeLybdssczVBAWdebJ+7_7EpMNLX2Hd9nTPL4fMTz0og@mail.gmail.com>
Subject: Re: [PATCH] net: hsr: add support for EntryForgetTime
To:     "Wenzel, Marco" <Marco.Wenzel@a-eberle.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Amol Grover <frextrite@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Arvid Brodin <Arvid.Brodin@xdin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 2:27 AM Wenzel, Marco <Marco.Wenzel@a-eberle.de> wrote:
>
> On Thu, Feb 18, 2021 at 6:06 PM : George McCollister <george.mccollister@gmail.com> wrote:
> >
> > On Thu, Feb 18, 2021 at 9:01 AM Marco Wenzel <marco.wenzel@a-
> > eberle.de> wrote:
> > >
> > > In IEC 62439-3 EntryForgetTime is defined with a value of 400 ms. When
> > > a node does not send any frame within this time, the sequence number
> > > check for can be ignored. This solves communication issues with Cisco
> > > IE 2000 in Redbox mode.
> > >
> > > Fixes: f421436a591d ("net/hsr: Add support for the High-availability
> > > Seamless Redundancy protocol (HSRv0)")
> > > Signed-off-by: Marco Wenzel <marco.wenzel@a-eberle.de>
> > > ---
> > >  net/hsr/hsr_framereg.c | 9 +++++++--
> > >  net/hsr/hsr_framereg.h | 1 +
> > >  net/hsr/hsr_main.h     | 1 +
> > >  3 files changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c index
> > > 5c97de459905..805f974923b9 100644
> > > --- a/net/hsr/hsr_framereg.c
> > > +++ b/net/hsr/hsr_framereg.c
> > > @@ -164,8 +164,10 @@ static struct hsr_node *hsr_add_node(struct
> > hsr_priv *hsr,
> > >          * as initialization. (0 could trigger an spurious ring error warning).
> > >          */
> > >         now = jiffies;
> > > -       for (i = 0; i < HSR_PT_PORTS; i++)
> > > +       for (i = 0; i < HSR_PT_PORTS; i++) {
> > >                 new_node->time_in[i] = now;
> > > +               new_node->time_out[i] = now;
> > > +       }
> > >         for (i = 0; i < HSR_PT_PORTS; i++)
> > >                 new_node->seq_out[i] = seq_out;
> > >
> > > @@ -411,9 +413,12 @@ void hsr_register_frame_in(struct hsr_node
> > *node,
> > > struct hsr_port *port,  int hsr_register_frame_out(struct hsr_port *port,
> > struct hsr_node *node,
> > >                            u16 sequence_nr)  {
> > > -       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]))
> > > +       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type])
> > &&
> > > +           time_is_after_jiffies(node->time_out[port->type] +
> > > +           msecs_to_jiffies(HSR_ENTRY_FORGET_TIME)))
> > >                 return 1;
> > >
> > > +       node->time_out[port->type] = jiffies;
> > >         node->seq_out[port->type] = sequence_nr;
> > >         return 0;
> > >  }
> > > diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h index
> > > 86b43f539f2c..d9628e7a5f05 100644
> > > --- a/net/hsr/hsr_framereg.h
> > > +++ b/net/hsr/hsr_framereg.h
> > > @@ -75,6 +75,7 @@ struct hsr_node {
> > >         enum hsr_port_type      addr_B_port;
> > >         unsigned long           time_in[HSR_PT_PORTS];
> > >         bool                    time_in_stale[HSR_PT_PORTS];
> > > +       unsigned long           time_out[HSR_PT_PORTS];
> > >         /* if the node is a SAN */
> > >         bool                    san_a;
> > >         bool                    san_b;
> > > diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h index
> > > 7dc92ce5a134..f79ca55d6986 100644
> > > --- a/net/hsr/hsr_main.h
> > > +++ b/net/hsr/hsr_main.h
> > > @@ -21,6 +21,7 @@
> > >  #define HSR_LIFE_CHECK_INTERVAL                 2000 /* ms */
> > >  #define HSR_NODE_FORGET_TIME           60000 /* ms */
> > >  #define HSR_ANNOUNCE_INTERVAL            100 /* ms */
> > > +#define HSR_ENTRY_FORGET_TIME            400 /* ms */
> > >
> > >  /* By how much may slave1 and slave2 timestamps of latest received
> > frame from
> > >   * each node differ before we notify of communication problem?
> > > --
> > > 2.30.0
> > >
> >
> > scripts/checkpatch.pl gives errors about DOS line endings but once that is
> > resolved this looks good. I tested it on an HSR network with the software
> > implementation and the xrs700x which uses offloading and everything still
> > works. I don't have a way to force anything on the HSR network to reuse
> > sequence numbers after 400ms.
> >
> > Reviewed-by: George McCollister <george.mccollister@gmail.com
> > Tested-by: George McCollister <george.mccollister@gmail.com
>
> Thank you very much for reviewing, testing and supporting!
>
> Where do you see the incorrect line endings? I just ran scripts/checkpath.pl as git commit hook and it did not report any errors. When I run it again manually, it also does not report any errors:
>
> # ./scripts/checkpatch.pl --strict /tmp/0001-net-hsr-add-support-for-EntryForgetTime.patch
> total: 0 errors, 0 warnings, 0 checks, 38 lines checked
>
> /tmp/0001-net-hsr-add-support-for-EntryForgetTime.patch has no obvious style problems and is ready for submission.

Sorry about this. It seems when I downloaded the patch with Chromium
from gmail in Linux it added DOS new lines (this is unexpected). When
I downloaded it from lore.kernel.org it's fine.

Reviewed-by: George McCollister <george.mccollister@gmail.com>
Tested-by: George McCollister <george.mccollister@gmail.com>

>
>
> Regards,
> Marco Wenzel
