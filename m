Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665AB242151
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 22:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgHKUaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 16:30:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:38264 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgHKUaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 16:30:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 50565ACB8;
        Tue, 11 Aug 2020 20:30:35 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id E5E217F447; Tue, 11 Aug 2020 22:30:13 +0200 (CEST)
Date:   Tue, 11 Aug 2020 22:30:13 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 1/7] netlink: get rid of signed/unsigned
 comparison warnings
Message-ID: <20200811203013.bchsqf5syvefpope@carpenter>
References: <cover.1597007532.git.mkubecek@suse.cz>
 <90fd688121efaea8acce2a9547585416433493f3.1597007533.git.mkubecek@suse.cz>
 <20200810141122.GD2123435@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810141122.GD2123435@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 04:11:22PM +0200, Andrew Lunn wrote:
> On Sun, Aug 09, 2020 at 11:24:19PM +0200, Michal Kubecek wrote:
> > Get rid of compiler warnings about comparison between signed and
> > unsigned integer values in netlink code.
> > 
> > Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> > ---
> >  netlink/features.c | 4 ++--
> >  netlink/netlink.c  | 4 ++--
> >  netlink/netlink.h  | 2 +-
> >  netlink/nlsock.c   | 2 +-
> >  netlink/parser.c   | 2 +-
> >  netlink/settings.c | 6 +++---
> >  6 files changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/netlink/features.c b/netlink/features.c
> > index 8b5b8588ca23..f5862e97a265 100644
> > --- a/netlink/features.c
> > +++ b/netlink/features.c
> > @@ -149,7 +149,7 @@ int dump_features(const struct nlattr *const *tb,
> >  			continue;
> >  
> >  		for (j = 0; j < results.count; j++) {
> > -			if (feature_flags[j] == i) {
> > +			if (feature_flags[j] == (int)i) {
> >  				n_match++;
> >  				flag_value = flag_value ||
> >  					feature_on(results.active, j);
> > @@ -163,7 +163,7 @@ int dump_features(const struct nlattr *const *tb,
> >  		for (j = 0; j < results.count; j++) {
> >  			const char *name = get_string(feature_names, j);
> >  
> > -			if (feature_flags[j] != i)
> > +			if (feature_flags[j] != (int)i)
> 
> Hi Michal
> 
> Would it be better to make feature_flags an unsigned int * ? And
> change the -1 to MAX_UNIT?

It certainly would. I was actually thinking about this solution for
a moment but then I managed to mistake feature_flags with off_flag_def
and convinced myself that it's shared with ioctl code so that changing
its type would require changes there as well. Thank you for pointing
this out.

Michal
