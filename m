Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EAA220122
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 01:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGNXrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 19:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgGNXrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 19:47:52 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6CAC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 16:47:52 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t6so169738plo.3
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 16:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5MaH7fkyF1ehVI4ny6mxHpSBye4GxtrgN9Yk/nUq7rQ=;
        b=Vx9pGTClq+E3ZQv7coPrZAC0oLGJqzXqtMtU+LWvlnG9ChgS0znBzsVPl/3B4hxjDx
         frNJCMcKWg+3ws1nCjDyiU5igrn3qezInWIWodzpRy9/hXWyKyWC1w6yXDPPweU1HoBi
         Tdow9mQO7GFiUhbGyKyx7sxrFhiuWJqfb5lFIbIM7K0uhHBYWdO7meUmRm/rY63p1TFH
         NRZDnQZQmZTPr8YRe8RrO+8ZINBLUfWyb85NTyAsrKkaw+WnDv8sS2rnK402mPTB5MDL
         UYELeKp9/2bN1S77WE6mNbRw4os8x5KLfhsRTDIPN9JbPZhy1J2u052n+5OQhX/0jshb
         GmTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5MaH7fkyF1ehVI4ny6mxHpSBye4GxtrgN9Yk/nUq7rQ=;
        b=MUfvFkGtk++RvpV84P1Ps5aHAMfUd+nhUQvtp8RvpBzJUprViGCiblf817sXS5j3AO
         Kyby82/NycgJDK1tD4Aq/tXwc784hUF8GwJewfrcVTPFQcaDsj4PIjxkm2XpUSZBqnAi
         sDb5ZEgRjXVI3yhYhlo5o9GPHkEPUm12jlWwbnYPcwc4eldO0BJyfIhB/MJb63Ld2RwA
         8xypXLmof0rUWg16sn02ImJEZeefYLd/DXZGIFehdOaZiwaYdNC/N84ndtdYVXHfKMQ4
         ggVVnfHPWpp/nLoj3iiGmCSMSy/PlsJTx3U/GnwFwBkCn/w3U8ULufaYKYNq+HVpXPN+
         0Vxw==
X-Gm-Message-State: AOAM531XeI0OUEemH0zuX8Jyw7hTXkEO11HfDo6AY88vQ32srEckLpTU
        th22K3SURwpGxN5knd0IFbfS7BtZqKkxpw==
X-Google-Smtp-Source: ABdhPJx9zDNlz4CSN/KXCvzdcj9YV2LrS+6lgI3g2PDRes9dX0zq3l8j1ptxenZOh7zO4vmU5XMEfQ==
X-Received: by 2002:a17:902:9009:: with SMTP id a9mr5401549plp.252.1594770471965;
        Tue, 14 Jul 2020 16:47:51 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a11sm164230pjw.35.2020.07.14.16.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 16:47:51 -0700 (PDT)
Date:   Tue, 14 Jul 2020 16:47:42 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Julien Fortin <julien@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next master] bridge: fdb show: fix fdb entry
 state output for json context
Message-ID: <20200714164742.17aac7ac@hermes.lan>
In-Reply-To: <CAM_1_KxU909QZ1H=yDy1wpQXVQ+s1BndLuroVAqisJQzZ7MT1A@mail.gmail.com>
References: <20200710005055.8439-1-julien@cumulusnetworks.com>
        <20200713075445.33aca679@hermes.lan>
        <CAM_1_KxU909QZ1H=yDy1wpQXVQ+s1BndLuroVAqisJQzZ7MT1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 01:35:33 +0200
Julien Fortin <julien@cumulusnetworks.com> wrote:

> On Mon, Jul 13, 2020 at 4:54 PM Stephen Hemminger <
> stephen@networkplumber.org> wrote:  
> 
> > On Fri, 10 Jul 2020 02:50:55 +0200
> > Julien Fortin <julien@cumulusnetworks.com> wrote:
> >  
> > > From: Julien Fortin <julien@cumulusnetworks.com>
> > >
> > > bridge json fdb show is printing an incorrect / non-machine readable
> > > value, when using -j (json output) we are expecting machine readable
> > > data that shouldn't require special handling/parsing.
> > >
> > > $ bridge -j fdb show | \
> > > python -c \
> > > 'import  
> > sys,json;print(json.dumps(json.loads(sys.stdin.read()),indent=4))'  
> > > [
> > >     {
> > >         "master": "br0",
> > >         "mac": "56:23:28:4f:4f:e5",
> > >         "flags": [],
> > >         "ifname": "vx0",
> > >         "state": "state=0x80"  <<<<<<<<< with the patch: "state": "0x80"
> > >     }
> > > ]
> > >
> > > Fixes: c7c1a1ef51aea7c ("bridge: colorize output and use JSON print  
> > library")  
> > > Signed-off-by: Julien Fortin <julien@cumulusnetworks.com>
> > > ---
> > >  bridge/fdb.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/bridge/fdb.c b/bridge/fdb.c
> > > index d2247e80..198c51d1 100644
> > > --- a/bridge/fdb.c
> > > +++ b/bridge/fdb.c
> > > @@ -62,7 +62,10 @@ static const char *state_n2a(unsigned int s)
> > >       if (s & NUD_REACHABLE)
> > >               return "";
> > >
> > > -     sprintf(buf, "state=%#x", s);
> > > +     if (is_json_context())
> > > +             sprintf(buf, "%#x", s);
> > > +     else
> > > +             sprintf(buf, "state=%#x", s);
> > >       return buf;
> > >  }
> > >  
> >
> > Printing in non JSON case was also wrong.
> > i.e.
> >               ...  state state=0x80
> > should be:
> >               ... state 0x80
> >
> > Let's do that.
> >
> >
> > The state=xxx value only shows up if the FDB entry has a value bridge
> > command
> > doesn't understand. The bridge command needs to be able to display the new
> > flag values.  
> 
> 
> > Please fixup the two patches and resubmit to iproute2
> >  
> 
> I'll resubmit a patch for this specific issue, to handle both json and
> non-json case correctly
> but i don't think it's necessary to resubmit "bridge: fdb get: add missing
> json init (new_json_obj)"
> as it's a different issue.

Normally, if you submit a patch series, then you need to resubmit
the whole series. If you submit two separate patches then each one can
be reviewed and accepted alone.
