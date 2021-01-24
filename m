Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4CC301919
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 01:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbhAXA5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 19:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbhAXA51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 19:57:27 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E10C0613D6;
        Sat, 23 Jan 2021 16:56:46 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id e70so9138550ote.11;
        Sat, 23 Jan 2021 16:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ATDIY55l2JJ11zJUFF3j0PCD3Y+gkHpjt5XKQXHEqNI=;
        b=WLHd4BzDdm1eWNZN1sJAAGjFmG9ZpLkSBRtwazWnYjsJlM3MAW3BpvX8vdM1VCT2qQ
         /Nh3ZkFhyX+4UheCRBqXJoVW+XQGavwKPy2GMcXm0VMf6jsSd6wZW0jv9nbNIymiLSoF
         27BHEKI8t60d27iAeMGwGOraLw/1B/SZVdVSksMEI46xOoESev6/OXgWwkn5mm0OQfPo
         KgN3XblxiIjanAgDhysP8G225x9mcc5saq30ISgnoLNGFN2XcwL1vQcLeiExDwRRoBay
         Er+8VnFPJcncT7RyJpDz85/sJ48j6BqzCFrXEGRrx7tC9BPEWwsBXkrx2OlbCgldzXSu
         Ikxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ATDIY55l2JJ11zJUFF3j0PCD3Y+gkHpjt5XKQXHEqNI=;
        b=lBNeGJM2Gzo9nlPRDLeRttYzOPbryFYtzHS1rNwpoIw3GXO3FiChHig94ICgTs0hMg
         0oUTu1FHVJLBXVa/3dSqQOKytZmdUiCQJT9GwREucuei4SGN4kif38WwK0dLF11fJ5cs
         fdeeo041HgYuVFB1N2ubvJIVm6hCLuKk+vZwiLOtNPH8OM8VNnjWz1Vt6C4nB7IIZIX9
         yyqKBmbjlj1h81Q/b81/W4zogHJeRcnK2lnkULkdDyu1SVvPf1wOeMC9PVGqbPS6XbAK
         dExVDSJeBwC2DT80Ge2jtgZBnHyGEJlQade0cdA+6FEphQ4GGNqmyAXZTXpx6TDHYDIc
         fgNQ==
X-Gm-Message-State: AOAM531uwuVvVpq+YrPjXOft9IX85Z64CXcquSKeKsC3oPMtbn9ivouJ
        3fb4C4Tx5h7dYTQ1UtQBqtU=
X-Google-Smtp-Source: ABdhPJwuOU8UDUDHfzG1wCmlglu3xPAh3KStY39bJ1fZI7RNYugSFPicaXL8Y+CRBEb5wPf/lnlLrA==
X-Received: by 2002:a05:6830:355:: with SMTP id h21mr7927560ote.355.1611449806235;
        Sat, 23 Jan 2021 16:56:46 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id z20sm1616532oth.55.2021.01.23.16.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 16:56:45 -0800 (PST)
Date:   Sat, 23 Jan 2021 16:56:43 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, enkechen2020@gmail.com
Subject: Re: [PATCH net] tcp: make TCP_USER_TIMEOUT accurate for zero window
 probes
Message-ID: <20210124005643.GH129261@localhost.localdomain>
References: <20210122191306.GA99540@localhost.localdomain>
 <20210122174325.269ac329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210123022823.GA100578@localhost.localdomain>
 <20210122183424.59c716a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210123024534.GB100578@localhost.localdomain>
 <CADVnQy=zzrFf=sF+oMwjm+Pp-VJ-veC93poVp0XUPFKRoiGRUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVnQy=zzrFf=sF+oMwjm+Pp-VJ-veC93poVp0XUPFKRoiGRUQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Neal:

What you described is more accurate, and is correct.

Thanks.  -- Enke

On Sat, Jan 23, 2021 at 07:19:13PM -0500, Neal Cardwell wrote:
> On Fri, Jan 22, 2021 at 9:45 PM Enke Chen <enkechen2020@gmail.com> wrote:
> >
> > Hi, Jakub:
> >
> > On Fri, Jan 22, 2021 at 06:34:24PM -0800, Jakub Kicinski wrote:
> > > On Fri, 22 Jan 2021 18:28:23 -0800 Enke Chen wrote:
> > > > Hi, Jakub:
> > > >
> > > > In terms of backporting, this patch should go together with:
> > > >
> > > >     9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window
> > >
> > > As in it:
> > >
> > > Fixes: 9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window
> > >
> > > or does it further fix the same issue, so:
> > >
> > > Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
> > >
> > > ?
> >
> > Let me clarify:
> >
> > 1) 9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window
> >
> >    fixes the bug and makes it work.
> >
> > 2) The current patch makes the TCP_USER_TIMEOUT accurate for 0-window probes.
> >    It's independent.
> 
> Patch (2) ("tcp: make TCP_USER_TIMEOUT accurate for zero window
> probes") is indeed conceptually independent of (1) but its
> implementation depends on the icsk_probes_tstamp field defined in (1),
> so AFAICT (2) cannot be backported further back than (1).
> 
> Patch (1) fixes a bug in 5.1:
>     Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
> 
> So probably (1) and (2) should be backported as a pair, and only back
> as far as 5.1. (That covers 2 LTS kernels, 5.4 and 5.10, so hopefully
> that is good enough.)
> 
> neal
