Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FAF3E9296
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhHKN0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:26:14 -0400
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:44116 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231405AbhHKNYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 09:24:11 -0400
Received: from omf08.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id DB3C91807F217;
        Wed, 11 Aug 2021 13:23:44 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id 593651A29FE;
        Wed, 11 Aug 2021 13:23:43 +0000 (UTC)
Message-ID: <c296dd2f66e97ad38d5456c0fab4e0ff99b14634.camel@perches.com>
Subject: Re: [PATCH net-next v2 2/2] bonding: combine netlink and console
 error messages
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        leon@kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Date:   Wed, 11 Aug 2021 06:23:41 -0700
In-Reply-To: <20210811054917.722bd988@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1628650079.git.jtoppins@redhat.com>
         <e6b78ce8f5904a5411a809cf4205d745f8af98cb.1628650079.git.jtoppins@redhat.com>
         <d5e1aada694465fd62f57695e264259815e60746.camel@perches.com>
         <20210811054917.722bd988@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 593651A29FE
X-Spam-Status: No, score=1.56
X-Stat-Signature: 4djjjcjq8kkr7c1aewnaurrx6cw1hctk
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/EeNUAF09QPTMPt+4vmd/b8cehfzKAmU8=
X-HE-Tag: 1628688223-324698
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-08-11 at 05:49 -0700, Jakub Kicinski wrote:
> On Tue, 10 Aug 2021 20:27:01 -0700 Joe Perches wrote:
> > > +#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
> > > +	if (extack)						\
> > > +		NL_SET_ERR_MSG(extack, errmsg);			\
> > > +	else							\
> > > +		netdev_err(bond_dev, "Error: %s\n", errmsg);	\
> > > +} while (0)
> > > +
> > > +#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {		\
> > > +	if (extack)							\
> > > +		NL_SET_ERR_MSG(extack, errmsg);				\
> > > +	else								\
> > > +		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
> > > +} while (0)  
> > 
> > Ideally both of these would be static functions and not macros.
> 
> That may break our ability for NL_SET_ERR_MSG to place strings 
> back in a static buffer, no?

Not really.

The most common way to place things in a particular section is to
use __section("whatever")

It's pretty trivial to mark these errmsg strings as above.



