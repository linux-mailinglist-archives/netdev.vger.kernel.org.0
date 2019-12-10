Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D281191D1
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfLJUXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:23:33 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53396 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfLJUXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:23:33 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iem2Y-001zWG-EY; Tue, 10 Dec 2019 21:23:26 +0100
Message-ID: <0c9148be76615b3b77a3e730df75f311b1001b9f.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 1/5] rtnetlink: provide permanent hardware
 address in RTM_NEWLINK
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Dec 2019 21:23:24 +0100
In-Reply-To: <acd3947857e5be5340239cd49c8e2a51c283b884.camel@sipsolutions.net>
References: <cover.1575982069.git.mkubecek@suse.cz>
         <7c28b1aa87436515de39e04206db36f6f374dc2f.1575982069.git.mkubecek@suse.cz>
         <20191210095105.1f0008f5@cakuba.netronome.com>
         (sfid-20191210_185112_099545_A11C9C5D) <acd3947857e5be5340239cd49c8e2a51c283b884.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-12-10 at 21:22 +0100, Johannes Berg wrote:
> On Tue, 2019-12-10 at 09:51 -0800, Jakub Kicinski wrote:
> > On Tue, 10 Dec 2019 14:07:53 +0100 (CET), Michal Kubecek wrote:
> > > @@ -1822,6 +1826,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
> > >  	[IFLA_PROP_LIST]	= { .type = NLA_NESTED },
> > >  	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
> > >  				    .len = ALTIFNAMSIZ - 1 },
> > > +	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
> > >  };
> > >  
> > >  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> > 
> > Jiri, I just noticed ifla_policy didn't get strict_start_type set when
> > ALT_IFNAME was added, should we add it in net? 🤔
> 
> Does it need one? It shouldn't be used with
> nla_parse_nested_deprecated(), and if it's used with nla_parse_nested()
> then it doesn't matter?

No, wait. I misread, you said "when ALT_IFNAME was added" but somehow I
managed to read "when it was added"...

So yeah, it should have one. Dunno about net, your call. I'd probably
not bother for an NLA_REJECT attribute, there's little use including it
anyway.

johannes

