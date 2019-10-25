Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C688CE4F77
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394795AbfJYOpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:45:55 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37901 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390195AbfJYOpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 10:45:54 -0400
Received: by mail-qt1-f196.google.com with SMTP id o25so3593036qtr.5;
        Fri, 25 Oct 2019 07:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9BRM8iwifp5rc3DOXo9jMjEw2J8GEyh4mI6AGYoEA0w=;
        b=Os+IxUORuv4Mc4G8QTjhUY7FsHkZ45PeRc4c9H07jIH2Uzmrrb5mRsAlIWkpSFUPA2
         B2mQ7GFGeIzhHBzKffuYor0vHyjM6M5p3HDmv3RO2VnrruS+GExAzqnXYsUFwjZmjNJ2
         8qlwTAxwxhg9wUoO5rSsecs8ecrpJcHLLeyPSkp6G/qISnLfHroxjZOqupnRcWx9ilIt
         7WZybsxlG4E32iTFJVeyveSyOya7pyPo+vuMnvJI0TMM4H/dJieAYcDoGA7kEr70Irsq
         No601ExAcKRg/xccmuoubNV7c7dzpRNpHppFFoYG1R7aQlr/E9AlLecqOoCFEARnZ3c+
         DrXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9BRM8iwifp5rc3DOXo9jMjEw2J8GEyh4mI6AGYoEA0w=;
        b=S6PysZv81sg45wbZ61Ul4N2qmw1JeSZOuImvduhmYR3pnT4BKWQQk3O592kJ/+4te4
         PgqfPgYmWgMxPULloYgjDIHnPNwUchVBXnMDlV57VhTLadYdE5hsQ3nFPgukwQErMjxj
         MaHVOwsNCn+6qXFwPBa+EIMi530+dW1m3teTItRCMnd95T8JdDGBIZ1mqRqFgphonfC0
         33UjHTbQTuSJ/QYuOndIj/ilw9cRbQR9fgvRsrxYdsc1sK69IY67+qZ+v0A3CPJhY6ZK
         E/OYNiYS9APPKAPmjoQMcCanO700I8/Q7mWTE4FIQlsLfpIuc02nq/jBxXxAFB3J+JZ9
         5C+w==
X-Gm-Message-State: APjAAAV0rucfjjUz5p0ba6i3NgLQjhY05ciAoWQbPpuU/pHKjIt3TI7G
        ruDy6R1klXf9LBko8uYXsv2Keb0I0WA=
X-Google-Smtp-Source: APXvYqzvi98NyWa7+i+1Bk+cLwCdOLQxCQpuATgCHJcIuE+LM0P147ybUskvBqU1LH+5DoieA/KJ5Q==
X-Received: by 2002:ac8:2ce5:: with SMTP id 34mr3395600qtx.308.1572014751725;
        Fri, 25 Oct 2019 07:45:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:4432:ec84:3b11:57ab:7f98])
        by smtp.gmail.com with ESMTPSA id l3sm1560594qtc.33.2019.10.25.07.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 07:45:50 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7F658C0AD9; Fri, 25 Oct 2019 11:45:48 -0300 (-03)
Date:   Fri, 25 Oct 2019 11:45:48 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv3 net-next 2/5] sctp: add pf_expose per netns and sock
 and asoc
Message-ID: <20191025144548.GC4250@localhost.localdomain>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
 <20191025032337.GC4326@localhost.localdomain>
 <995e44322af74c41bbff2c77338f83bf@AcuMS.aculab.com>
 <20191025132151.GF4326@localhost.localdomain>
 <715b91a4a86547eb874874eda125c2ba@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <715b91a4a86547eb874874eda125c2ba@AcuMS.aculab.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 02:26:57PM +0000, David Laight wrote:
> From: 'Marcelo Ricardo Leitner'
> > Sent: 25 October 2019 14:22
> > On Fri, Oct 25, 2019 at 09:00:45AM +0000, David Laight wrote:
> > > From: Marcelo Ricardo Leitner
> > > > Sent: 25 October 2019 04:24
> > > ...
> > > > > @@ -5521,8 +5522,16 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
> > > > >
> > > > >  	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
> > > > >  					   pinfo.spinfo_assoc_id);
> > > > > -	if (!transport)
> > > > > -		return -EINVAL;
> > > > > +	if (!transport) {
> > > > > +		retval = -EINVAL;
> > > > > +		goto out;
> > > > > +	}
> > > > > +
> > > > > +	if (transport->state == SCTP_PF &&
> > > > > +	    transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE) {
> > > > > +		retval = -EACCES;
> > > > > +		goto out;
> > > > > +	}
> > > >
> > > > As is on v3, this is NOT an UAPI violation. The user has to explicitly
> > > > set the system or the socket into the disabled state in order to
> > > > trigger this new check.
> > >
> > > Only because the default isn't to be backwards compatible with the
> >                            ^^^^^
> > 
> > You meant "is", right? Then we're agreeing.
> 
> No, I meant isn't.

Then you missed this detail in the patch. The default here IS to be
backwards compatible.

> The application must see a backwards compatible interface unless
> the application itself requests something different.
> The sysadmin can't be allowed to change the API seen by old applications.

Disagree. Sysadmins should be able to harden their systems as much as
they want/need. Yet, if that causes issues with old applications,
that's on them.

> 
> AFAICT if the protocol part of PF is enabled (which handles primary path
> failure better than the older version) and ' transport->state == SCTP_PF'
> is true then an old application binary will  get a completely unexpected -EACCESS
> rather than a valid state (out of the old valid states) if it requests 'peer addr_info'.
> 
> You cannot assume that just because some sysctl is set (because someone
> building a distribution suddenly decided it was a 'good idea') that an
> application binary will not fall in a big heap due to an error condition
> that couldn't ever happen before.

Agree, but that assumption doesn't have a room here. If the
distribution decided to harden the system, that's on them. Ditto for
many many other decisions, like having SELinux policies to block sshd
to bind only on port 22 and so, or for building the kernel without
SCTP_COOKIE_HMAC_MD5 because they think it's weak, etc.

  Marcelo
