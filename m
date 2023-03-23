Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF616C6E65
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCWRHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjCWRHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:07:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD4B13D77;
        Thu, 23 Mar 2023 10:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r/Kemcrwa5sxfGwwJvKyvHrjf3CpCTAqFgWDXvk5hxI=; b=sF6tv6FWmXFWcELUVqtSaWlkCQ
        GkpAo65LsIt3IinGbmAgjQ9qL1QAIXuxO5FHAo6SlpQV9+f1s2/VXu/KJJSQETw03gM0Pm48L7QBi
        VMRipDgEk2N/flLlEO4oaAmiXdkaKZf//6+E3Rq8vErNan/0ksVJw56bJW3EgM/o+mx2vUzxXlYXQ
        wpn2C4TQExOJqeSV+tRwikCCNilB58TMtvDWuEQdQe6tUoRksgqcY9nsyt/hZjAAYw/H5bGp651dq
        jltWxSocsztHXHK++qoLyKtWRSEoN9vbCX2oyj06xk+PixxE9yOTOQhu60mZVpThA/dLhQIQTvcse
        q4w601Uw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39602)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfOOp-0005Vl-SN; Thu, 23 Mar 2023 17:06:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfOOn-0001Y9-8s; Thu, 23 Mar 2023 17:06:49 +0000
Date:   Thu, 23 Mar 2023 17:06:49 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 3/7] net: dsa: use fwnode_get_phy_mode() to
 get phy interface mode
Message-ID: <ZByHKXgIuNI683kN@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
 <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
 <ZBxiqJo470A7bkig@shell.armlinux.org.uk>
 <ZBxkZYXrfugz0gYw@smile.fi.intel.com>
 <ZBxm3XrQAfnmbHoF@shell.armlinux.org.uk>
 <ZBxpeLOmTMzqVTRV@smile.fi.intel.com>
 <ZBxu4FvyO2JDwmMq@shell.armlinux.org.uk>
 <ZBx7xxs0NQV25cFn@shell.armlinux.org.uk>
 <ZBx/mO/z3t3dQCAx@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBx/mO/z3t3dQCAx@smile.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 06:34:32PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 23, 2023 at 04:18:15PM +0000, Russell King (Oracle) wrote:
> > On Thu, Mar 23, 2023 at 03:23:12PM +0000, Russell King (Oracle) wrote:
> > > On Thu, Mar 23, 2023 at 05:00:08PM +0200, Andy Shevchenko wrote:
> > > > On Thu, Mar 23, 2023 at 02:49:01PM +0000, Russell King (Oracle) wrote:
> > > > > On Thu, Mar 23, 2023 at 04:38:29PM +0200, Andy Shevchenko wrote:
> > > > > > Do you modify its content on the fly?
> > > > > 
> > > > > Do you want to litter code with casts to get rid of the const?
> > > > > 
> > > > > > For fwnode as a basic object type we want to reduce the scope of the possible
> > > > > > modifications. If you don't modify and APIs you call do not require non-const
> > > > > > object, use const for fwnode.
> > > > > 
> > > > > Let's start here. We pass this fwnode to fwnode_get_phy_mode():
> > > > > 
> > > > > include/linux/property.h:int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
> > > > > 
> > > > > Does fwnode_get_phy_mode() alter the contents of the fwnode? Probably
> > > > > not, but it doesn't take a const pointer. Therefore, to declare my
> > > > > fwnode as const, I'd need to cast the const-ness away before calling
> > > > > this.
> > > > 
> > > > So, fix the fwnode_get_phy_mode(). Is it a problem?
> > > 
> > > No, I refuse. That's for a different patch set.
> > > 
> > > > > Then there's phylink_create(). Same problem.
> > > > 
> > > > So, fix that. Is it a problem?
> > > 
> > > No for the same reason.
> > > 
> > > > > So NAK to this const - until such time that we have a concerted effort
> > > > > to making functions we call which do not modify the "fwnode" argument
> > > > > constify that argument. Otherwise it's just rediculously crazy to
> > > > > declare a variable const only to then litter the code with casts to get
> > > > > rid of it at every call site.
> > > > > 
> > > > > Please do a bit of research before making suggestions. Thanks.
> > > > 
> > > > So, MAK to your patch. You can fix that, and you know that.
> > > 
> > > Sorry, I don't accept your NAK. While you have a valid point about
> > > these things being const, that is not the fault of this patch series,
> > > and is something that should be addressed separately.
> > > 
> > > The lack of const-ness that has been there for quite some time is no
> > > reason to NAK a patch that has nothing to do with this.
> > 
> > To illustrate how rediculous this is:
> 
> It's not. But does it make difference?
> 
> > $ git grep 'struct fwnode_handle \*.*='
> > 
> > gives 134 instances. Of those, only five are const, which means 129
> > aren't. So I question - why are you singling mine out for what appears
> > to be special treatment.

You failed to answer this. I can only assume you don't have an answer
for why you are singling out my use compared to all the 129 other
uses in the kernel that follow this pattern. Given the number of them,
that is no basis to NAK this patch.

> > Let's look at other parts of the fwnode API.
> > 
> > void __iomem *fwnode_iomap(struct fwnode_handle *fwnode, int index);
> > 
> > Does that modify the fwnode it was passed? It calls:
> > 
> >         void __iomem *(*iomap)(struct fwnode_handle *fwnode, int index);
> > 
> > in struct fwnode_operations, so that would need to be made const as well.
> > The only implementation of that which I can find is of_fwnode_iomap()
> > which uses to_of_node() on that, which casts away the const-ness. So
> > this would be a candidate to making const.
> 
> Correct.
> 
> > bool fwnode_is_ancestor_of(struct fwnode_handle *ancestor, struct fwnode_handle *child);
> > 
> > I'd be surprised if that modifies either of those fwnodes.
> 
> It does. Now your time to be surprised.

I believe you are mistaken.

> > It seems
> > to use fwnode_for_each_parent_node() from the child, which passes
> > "child" to fwnode_get_parent(), which itself is const. Therefore, it
> > seems there's no reason not to make "child" const. "ancestor" can
> > also be made const since it's only being used for pointer-compares.
> 
> All getters return _different_ fwnode which is not const due to modification
> of the _returned_ fwnode.
> 
> Do a bit of investigation, please. Thanks.

I did exactly that, and I included the research in my email. How is
fwnode_is_ancestor_of() a "getter" when it returns a _boolean_?

Did you read my fully researched explanation? "child" is *not* modified,
it is merely passed to another function that accepts a *const* pointer.

Here's teaching you to suck eggs, because that's clearly what it's
going to take to make you see sense:

bool fwnode_is_ancestor_of(struct fwnode_handle *ancestor, struct fwnode_handle *child)
{
        struct fwnode_handle *parent;

        if (IS_ERR_OR_NULL(ancestor))
                return false;

        if (child == ancestor)
                return true;

        fwnode_for_each_parent_node(child, parent) {
                if (parent == ancestor) {
                        fwnode_handle_put(parent);
                        return true;
                }
        }
        return false;
}

"child" is only used by the if() "child == ancestor" and
fwnode_for_each_parent_node(). fwnode_for_each_parent_node() is:

#define fwnode_for_each_parent_node(fwnode, parent)             \
        for (parent = fwnode_get_parent(fwnode); parent;        \
             parent = fwnode_get_next_parent(parent))

so child is passed in as fwnode there, and gets passed to
fwnode_get_parent(). fwnode_get_parent() is declared as:

struct fwnode_handle *fwnode_get_parent(const struct fwnode_handle *fwnode);

So "child" ends up passed into this function, which takes a const
pointer. At no point is "child" assigned to in fwnode_is_ancestor_of().
It is only used in situations where it can be a const pointer.

Now, if we look at "ancestor" then there are three locations it is used:

        if (IS_ERR_OR_NULL(ancestor))

        if (child == ancestor)

                if (parent == ancestor) {

All of these can cope with ancestor being const.

I will grant you that "parent" can't be const, but then I *never* said
it would be as I was only taking about the functions arguments.

So, I think you need to revise your comment on this, because clearly it
was incorrect.

> > unsigned int fwnode_graph_get_endpoint_count(struct fwnode_handle *fwnode,
> >                                              unsigned long flags);
> > 
> > Similar story with this, although it uses
> > fwnode_graph_for_each_endpoint(), which seems to mean that "fwnode"
> > can also be const.
> 
> Correct.
> 
> > My point is that there are several things in the fwnode API that
> > should be made const but that aren't, but which should likely be
> > fixed before requiring const-ness of those fwnode_handle
> > declarations in people's code.
> 
> OK.
> 
> I started doing something about this as you may easily check with `git log`.
> Now, instead of playing a good citizen of the community you are trying to
> diminish the others' asks.

No, I'm finding your requests to be rather inconsistent, lacking
in useful value, and lacking an appreciation of how other parts of
the kernel's development process works.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
