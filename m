Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C5230E3D
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfEaMms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:42:48 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46188 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfEaMmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 08:42:47 -0400
Received: by mail-qt1-f194.google.com with SMTP id z19so566673qtz.13;
        Fri, 31 May 2019 05:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=geKl/13b2BVq2WZuH+jtOS2GrdFzU8dWzNHM7JMs9Fs=;
        b=KJJG6JstMzDKdPrLJ9ax5XAiPXVeC9mUtrk0dl5dqUITIboQr66+88OY0XE+H4xwTc
         sIGfGlFbb458vliPv/yttt8TCJ128hOWeAvCcY58Bnnxe5pxG+2qfkXNNCx1BWquvGtl
         uz+zy8p7Vyz/kGo7nKGZkfH+Uops7DNy1tF43V57wpeLN6EPltCmfxH89ImXFz1ne0Qo
         v/q+IdhOwKpD/Vg0ouG5+0CB8sZHvJ13Bb9WjVCw/Fs3BDRLHoEyj7RatP1bBw3e40Gx
         xePs4/FueO6YsqdbLl4+jHpDJ7/om+dnuSiJoXH/LFXbSYwFaQ5uGsSL4FnvS2SaCI/x
         vkPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=geKl/13b2BVq2WZuH+jtOS2GrdFzU8dWzNHM7JMs9Fs=;
        b=QJZUPk5ZTTztXTlZQRTHTvWIKsMsWD5JjieNRCNHMy5vdxVr4o6UNQxMUPwPNy3dLa
         QzQvv2pUHBFzsv2Irxvh0oqjeeFF9BI697EahFS7Wqa0JdAb6VRbVx/acoJqqbKTYmGV
         VG9+n6z7TsTvVGKMeZtymDPsbCKav8odg/8wPYhvP2GNiGpqexi8i7i7CmY22sqGKOTJ
         hDZNVaHLPLz6UTMtEP6fCWtfqpNEJ1O3DICM/41X3BeuOMWqwcy4Y3yYfkH44aX9+IIw
         VJ538WmJLZE1XxwPIPFILSqDiRrJF4S0Z+3b5JwdZG6OKrMvDVKq2U0fh2Pr6EXn6Wm+
         AkSg==
X-Gm-Message-State: APjAAAUhGiHIqbgV6rc+fqeokDe8HOT+ahscuGLawYRD9ORw7vnR/wTe
        JIY32a/tGIA9xVJx4hfq6CM8XC14dtk=
X-Google-Smtp-Source: APXvYqxqBl45Ss9D1ff4GpE8LtsRAB09vITnennPVNYNDky66pmdjU0thOlIUFl8fkwkLhnd6BTarA==
X-Received: by 2002:ac8:3fb3:: with SMTP id d48mr8986621qtk.290.1559306566509;
        Fri, 31 May 2019 05:42:46 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:d534:113c:6e5f:4426:2d54])
        by smtp.gmail.com with ESMTPSA id c9sm4414125qtc.39.2019.05.31.05.42.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 31 May 2019 05:42:45 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 54983C085E; Fri, 31 May 2019 09:42:42 -0300 (-03)
Date:   Fri, 31 May 2019 09:42:42 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: memory leak in sctp_process_init
Message-ID: <20190531124242.GE3713@localhost.localdomain>
References: <00000000000097abb90589e804fd@google.com>
 <20190528013600.GM5506@localhost.localdomain>
 <20190528111550.GA4658@hmswarspite.think-freely.org>
 <20190529190709.GE31099@hmswarspite.think-freely.org>
 <20190529233757.GC3713@localhost.localdomain>
 <20190530142011.GC1966@hmswarspite.think-freely.org>
 <20190530151705.GD3713@localhost.localdomain>
 <20190530195634.GD1966@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530195634.GD1966@hmswarspite.think-freely.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 03:56:34PM -0400, Neil Horman wrote:
> On Thu, May 30, 2019 at 12:17:05PM -0300, Marcelo Ricardo Leitner wrote:
...
> > --- a/net/sctp/sm_sideeffect.c
> > +++ b/net/sctp/sm_sideeffect.c
> > @@ -898,6 +898,11 @@ static void sctp_cmd_new_state(struct sctp_cmd_seq *cmds,
> >  						asoc->rto_initial;
> >  	}
> >  
> > +	if (sctp_state(asoc, ESTABLISHED)) {
> > +		kfree(asoc->peer.cookie);
> > +		asoc->peer.cookie = NULL;
> > +	}
> > +
> Not sure I follow why this is needed.  It doesn't hurt anything of course, but
> if we're freeing in sctp_association_free, we don't need to duplicate the
> operation here, do we?

This one would be to avoid storing the cookie throughout the entire
association lifetime, as the cookie is only needed during the
handshake.
While the free in sctp_association_free will handle the freeing in
case the association never enters established state.

> >  	if (sctp_state(asoc, ESTABLISHED) ||
> >  	    sctp_state(asoc, CLOSED) ||
> >  	    sctp_state(asoc, SHUTDOWN_RECEIVED)) {
> > 
> > Also untested, just sharing the idea.
> > 
> >   Marcelo
> > 
