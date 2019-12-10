Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C4C1191EB
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfLJU3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:29:23 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53582 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJU3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:29:23 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iem89-0020Fc-TP; Tue, 10 Dec 2019 21:29:14 +0100
Message-ID: <1172ea9c3f70ec0ea527926b2daa6e94c80ee807.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 1/5] rtnetlink: provide permanent hardware
 address in RTM_NEWLINK
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Dec 2019 21:29:11 +0100
In-Reply-To: <513ce8a1-f3ee-bd5f-a27c-86729e0536fd@gmail.com> (sfid-20191210_212718_256450_DC91B1DA)
References: <cover.1575982069.git.mkubecek@suse.cz>
         <7c28b1aa87436515de39e04206db36f6f374dc2f.1575982069.git.mkubecek@suse.cz>
         <20191210095105.1f0008f5@cakuba.netronome.com>
         <acd3947857e5be5340239cd49c8e2a51c283b884.camel@sipsolutions.net>
         <0c9148be76615b3b77a3e730df75f311b1001b9f.camel@sipsolutions.net>
         <513ce8a1-f3ee-bd5f-a27c-86729e0536fd@gmail.com>
         (sfid-20191210_212718_256450_DC91B1DA)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-12-10 at 13:27 -0700, David Ahern wrote:
> On 12/10/19 1:23 PM, Johannes Berg wrote:
> > On Tue, 2019-12-10 at 21:22 +0100, Johannes Berg wrote:
> > > On Tue, 2019-12-10 at 09:51 -0800, Jakub Kicinski wrote:
> > > > On Tue, 10 Dec 2019 14:07:53 +0100 (CET), Michal Kubecek wrote:
> > > > > @@ -1822,6 +1826,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
> > > > >  	[IFLA_PROP_LIST]	= { .type = NLA_NESTED },
> > > > >  	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
> > > > >  				    .len = ALTIFNAMSIZ - 1 },
> > > > > +	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
> > > > >  };
> > > > >  
> > > > >  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> > > > 
> > > > Jiri, I just noticed ifla_policy didn't get strict_start_type set when
> > > > ALT_IFNAME was added, should we add it in net? 🤔
> > > 
> > > Does it need one? It shouldn't be used with
> > > nla_parse_nested_deprecated(), and if it's used with nla_parse_nested()
> > > then it doesn't matter?
> > 
> > No, wait. I misread, you said "when ALT_IFNAME was added" but somehow I
> > managed to read "when it was added"...
> > 
> > So yeah, it should have one. Dunno about net, your call. I'd probably
> > not bother for an NLA_REJECT attribute, there's little use including it
> > anyway.
> > 
> 
> It's new in net, so it has to be there not net-next.

Oh, ok. Well, I was actually thinking to just add it on the next
attribute or so, but I guess now that we're discussing it there's a
higher chance of it actually happening :)

johannes

