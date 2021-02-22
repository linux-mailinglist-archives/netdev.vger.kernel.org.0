Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124A8321D6A
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhBVQuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhBVQuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 11:50:19 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8C4C06174A;
        Mon, 22 Feb 2021 08:49:38 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id q186so14558637oig.12;
        Mon, 22 Feb 2021 08:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RGFcvVJ1lj+6uQWliW0Ld/r3pfPfn4RVhCz5UuK1Pc8=;
        b=p/KcXmHQHllQeiug8VVKMusPsQkCDxJlAYVIcoWFWFlj2uV+USyO8SVvdtxxcB4kVk
         gwnaEMBEg3uiEeA9RfFYkMbkYKxJ3jBol8k3wEyXv7Me0MyjDh7HyCbICZJX1IHxE6HH
         d35duhFbfBCcmvAL/4wYaxUf6uhZiUvtAC/o/eWBluUOChu3no3MWddbAyEb+d0Pnf05
         wA3BYw0NvQYw9eoa/ylXkmjN4M5erWoPCGbnZ2CY1ipZsoaHsYiy61fMB3FJDyg6f315
         vuO/Dc0yY3xesCDwih25v4BgpiM4aJvx72nTE0GhGV8f6rR/3plKlNOnpCWnd8eStM7s
         I50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RGFcvVJ1lj+6uQWliW0Ld/r3pfPfn4RVhCz5UuK1Pc8=;
        b=RvqeOwrhJIpU/h7Pfmobxpa1OaMf8ofQePwjMp7FXSUmVEQYN21KSIVKqb7wYGXe2X
         hAqwaaV91oxGJ7Ma/7M0rDipFxQhRlrpOYNi3ranAjBCgdxCIynEyI7AsQT2PigVLVZM
         +5cLImvnAc519IpGElLQfAGLySzGAmqLuSYqa8YM2Uvbp9nFamj2w2K154t8r94Jvrx4
         /jrxt/C7XyAd/wLtBWknY7mJNzZ3ovv3yHa9RdKsZqS2Ess50rkQwcEmUKEPPPaKEoQk
         3Bw+1j7+BjitrezFb3I+Z5gJ60l30lf0hIy9sR2PXxnwLHVU8WOMLakegDIw/HUigBoM
         x3lQ==
X-Gm-Message-State: AOAM53234x/czYuBiMArB2hZYiuV2rsKFjRlEZLAmgOYsWB/rwrXpXTt
        C+Vb56xhx3QhlTCmr7e+HZGT/HOHwSurufbky6//NG/dZWRb
X-Google-Smtp-Source: ABdhPJwqdey7eXWwnY0zVLdcFlvjDc5rD2VhaDRQdLn08BPQSJb4fHoE+S/lCd2ZXfs4eIlorgiz19uysylbx7JmiSE=
X-Received: by 2002:a05:6808:5ca:: with SMTP id d10mr15601120oij.122.1614012578036;
 Mon, 22 Feb 2021 08:49:38 -0800 (PST)
MIME-Version: 1.0
References: <d79b32d366ca49aca7821cb0b0edf52b@EXCH-SVR2013.eberle.local>
In-Reply-To: <d79b32d366ca49aca7821cb0b0edf52b@EXCH-SVR2013.eberle.local>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 22 Feb 2021 10:49:26 -0600
Message-ID: <CAFSKS=PnV-aLnGeNqjqrsT4nfFby18uYQpScCCurz6dZ39AynQ@mail.gmail.com>
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

On Mon, Feb 22, 2021 at 7:38 AM Wenzel, Marco <Marco.Wenzel@a-eberle.de> wrote:
>
> On Fri, Feb 19, 2021 at 2:14 PM : George McCollister <george.mccollister@gmail.com> wrote:
> >
> > On Fri, Feb 19, 2021 at 2:27 AM Wenzel, Marco <Marco.Wenzel@a-
> > eberle.de> wrote:
> > >
> > > On Thu, Feb 18, 2021 at 6:06 PM : George McCollister
> > <george.mccollister@gmail.com> wrote:
> > > >
> > > > On Thu, Feb 18, 2021 at 9:01 AM Marco Wenzel <marco.wenzel@a-
> > > > eberle.de> wrote:
> > > > >
> > > > > In IEC 62439-3 EntryForgetTime is defined with a value of 400 ms.
> > > > > When a node does not send any frame within this time, the sequence
> > > > > number check for can be ignored. This solves communication issues
> > > > > with Cisco IE 2000 in Redbox mode.
> > > > >
> > > > > Fixes: f421436a591d ("net/hsr: Add support for the
> > > > > High-availability Seamless Redundancy protocol (HSRv0)")
> > > > > Signed-off-by: Marco Wenzel <marco.wenzel@a-eberle.de>
> > > > > ---
> > > > >  net/hsr/hsr_framereg.c | 9 +++++++--  net/hsr/hsr_framereg.h | 1
> > > > > +
> > > > >  net/hsr/hsr_main.h     | 1 +
> > > > >  3 files changed, 9 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c index
> > > > > 5c97de459905..805f974923b9 100644
> > > > > --- a/net/hsr/hsr_framereg.c
> > > > > +++ b/net/hsr/hsr_framereg.c
> > > > > @@ -164,8 +164,10 @@ static struct hsr_node *hsr_add_node(struct
> > > > hsr_priv *hsr,
> > > > >          * as initialization. (0 could trigger an spurious ring error warning).
> > > > >          */
> > > > >         now = jiffies;
> > > > > -       for (i = 0; i < HSR_PT_PORTS; i++)
> > > > > +       for (i = 0; i < HSR_PT_PORTS; i++) {
> > > > >                 new_node->time_in[i] = now;
> > > > > +               new_node->time_out[i] = now;
> > > > > +       }
> > > > >         for (i = 0; i < HSR_PT_PORTS; i++)
> > > > >                 new_node->seq_out[i] = seq_out;
> > > > >
> > > > > @@ -411,9 +413,12 @@ void hsr_register_frame_in(struct hsr_node
> > > > *node,
> > > > > struct hsr_port *port,  int hsr_register_frame_out(struct hsr_port
> > > > > *port,
> > > > struct hsr_node *node,
> > > > >                            u16 sequence_nr)  {
> > > > > -       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port-
> > >type]))
> > > > > +       if (seq_nr_before_or_eq(sequence_nr,
> > > > > + node->seq_out[port->type])
> > > > &&
> > > > > +           time_is_after_jiffies(node->time_out[port->type] +
> > > > > +           msecs_to_jiffies(HSR_ENTRY_FORGET_TIME)))
> > > > >                 return 1;
> > > > >
> > > > > +       node->time_out[port->type] = jiffies;
> > > > >         node->seq_out[port->type] = sequence_nr;
> > > > >         return 0;
> > > > >  }
> > > > > diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h index
> > > > > 86b43f539f2c..d9628e7a5f05 100644
> > > > > --- a/net/hsr/hsr_framereg.h
> > > > > +++ b/net/hsr/hsr_framereg.h
> > > > > @@ -75,6 +75,7 @@ struct hsr_node {
> > > > >         enum hsr_port_type      addr_B_port;
> > > > >         unsigned long           time_in[HSR_PT_PORTS];
> > > > >         bool                    time_in_stale[HSR_PT_PORTS];
> > > > > +       unsigned long           time_out[HSR_PT_PORTS];
> > > > >         /* if the node is a SAN */
> > > > >         bool                    san_a;
> > > > >         bool                    san_b;
> > > > > diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h index
> > > > > 7dc92ce5a134..f79ca55d6986 100644
> > > > > --- a/net/hsr/hsr_main.h
> > > > > +++ b/net/hsr/hsr_main.h
> > > > > @@ -21,6 +21,7 @@
> > > > >  #define HSR_LIFE_CHECK_INTERVAL                 2000 /* ms */
> > > > >  #define HSR_NODE_FORGET_TIME           60000 /* ms */
> > > > >  #define HSR_ANNOUNCE_INTERVAL            100 /* ms */
> > > > > +#define HSR_ENTRY_FORGET_TIME            400 /* ms */
> > > > >
> > > > >  /* By how much may slave1 and slave2 timestamps of latest
> > > > > received
> > > > frame from
> > > > >   * each node differ before we notify of communication problem?
> > > > > --
> > > > > 2.30.0
> > > > >
> > > >
> > > > scripts/checkpatch.pl gives errors about DOS line endings but once
> > > > that is resolved this looks good. I tested it on an HSR network with
> > > > the software implementation and the xrs700x which uses offloading
> > > > and everything still works. I don't have a way to force anything on
> > > > the HSR network to reuse sequence numbers after 400ms.
> > > >
> > > > Reviewed-by: George McCollister <george.mccollister@gmail.com
> > > > Tested-by: George McCollister <george.mccollister@gmail.com
> > >
> > > Thank you very much for reviewing, testing and supporting!
> > >
> > > Where do you see the incorrect line endings? I just ran scripts/checkpath.pl
> > as git commit hook and it did not report any errors. When I run it again
> > manually, it also does not report any errors:
> > >
> > > # ./scripts/checkpatch.pl --strict
> > > /tmp/0001-net-hsr-add-support-for-EntryForgetTime.patch
> > > total: 0 errors, 0 warnings, 0 checks, 38 lines checked
> > >
> > > /tmp/0001-net-hsr-add-support-for-EntryForgetTime.patch has no obvious
> > style problems and is ready for submission.
> >
> > Sorry about this. It seems when I downloaded the patch with Chromium
> > from gmail in Linux it added DOS new lines (this is unexpected). When I
> > downloaded it from lore.kernel.org it's fine.
> >
> > Reviewed-by: George McCollister <george.mccollister@gmail.com>
> > Tested-by: George McCollister <george.mccollister@gmail.com>
> >
>
> Thank you for reviewing again! Is there any operation needed from my side in order to officially apply this patch?

Looks like the patch is showing as deferred in patchwork because it's
not targeting either net or net-next.

From https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
  There are always two trees (git repositories) in play. Both are driven
   by David Miller, the main network maintainer.  There is the "net" tree,
   and the "net-next" tree.  As you can probably guess from the names, the
   net tree is for fixes to existing code already in the mainline tree from
   Linus, and net-next is where the new code goes for the future release.
   You can find the trees here:

        https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
        https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git

You must decide if you want to send it for net or net-next. If you
want to send it for net-next you must wait Linus has closed the merge
window and this shows open:
http://vger.kernel.org/~davem/net-next.html

To send for net use the subject prefix "[PATCH net]".
To send for net-next use the subject prefix "[PATCH net-next]".

If you're using git format-patch you can use the following:
git format-patch --subject-prefix='PATCH net-next'

If you're just using git send-email you can use the --annotate option
to edit the patch subject manually.

Thanks and sorry for not mentioning this before,
George McCollister

>
> > >
> > > Regards,
> > > Marco Wenzel
