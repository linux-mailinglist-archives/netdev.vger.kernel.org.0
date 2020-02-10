Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 103B6157D79
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 15:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgBJOeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 09:34:03 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52547 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727484AbgBJOeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 09:34:03 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4C55921857;
        Mon, 10 Feb 2020 09:34:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 10 Feb 2020 09:34:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=d6RHHT
        j8qlLQZgHBmp4zlV2V4aYHLE9xNfyWoswZnuc=; b=Z9H51bHfQaM468ClRiEUvY
        e/YJoxrLtAILr0Z13yzBPws+3qF/7k9Xm5xdKmKGtBOclPrAONTp4PfRLkXq0jLl
        tjONXjmK2RrRYfLWgSqdRsKAaS7YLSI9wia/Ze0STqX0WhoG1U7YhazVrZ4DaEWb
        i8DbXfMaQ/OG0BRs1721UkSx9JFjC8DOPYlti2dUa3Ewa4YJtihySbiGRBpoErf2
        pUp6vYGxml30elq0dTP87088m764VppsGbagaR6dtf59aZH37r3zBJCdrZOB2KIK
        2CFeg0zxExEOrcxRI5FxHE9Wclpm6cEtAvXwOTN07NW4ITz6ykkVCCLDELLFj8kw
        ==
X-ME-Sender: <xms:2mlBXvtVYw8Yl3w9AXohTLJH5gIJCtYugf93KsEvcjK_s91lEXzQ7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedriedugdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeduleefrd
    egjedrudeihedrvdehudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2mlBXswKmnuilSvBLjEUMHKr084PXoPv4nIXz0cN-Ppvol4BfJfuOw>
    <xmx:2mlBXljqWPHmiceAeEQt3ixt8l8cwFtQwwtdI3YQo-ZFHcUnvwsMvw>
    <xmx:2mlBXgB3GtfH_yJW5QLUFlpPwfbHyX75_86YcIcWQzFogjNM8toTKQ>
    <xmx:2mlBXp71awAONn-BOOHq36Mus7xSy4qvEPtDb1LCZ0kqdr_aY6CBeg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C7DF730606E9;
        Mon, 10 Feb 2020 09:34:01 -0500 (EST)
Date:   Mon, 10 Feb 2020 16:34:00 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: VLAN retagging for packets switched between 2 certain ports
Message-ID: <20200210143400.GA185791@splinter>
References: <CA+h21hr4KsDCzEeLD5CtcdXMtY5pOoHGi7-Oig0-gmRKThG30A@mail.gmail.com>
 <CA+h21hpWknrGjyK0eRVFmx7a1WWRyCZJtFRgGzr3YyeL3y2gYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpWknrGjyK0eRVFmx7a1WWRyCZJtFRgGzr3YyeL3y2gYw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 06, 2020 at 11:32:52AM +0200, Vladimir Oltean wrote:
> On Thu, 6 Feb 2020 at 11:02, Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Hi netdev,
> >
> > I am interested in modeling the following classifier/action with tc filters:
> > - Match packets with VID N received on port A and going towards port B
> > - Replace VID with M
> >
> > Some hardware (DSA switch) I am working on supports this, so it would
> > be good if I could model this with tc in a way that can be offloaded.
> > In man tc-flower I found the following matches:
> >        indev ifname
> >               Match on incoming interface name. Obviously this makes
> > sense only for forwarded flows.  ifname is the name of an interface
> > which must exist at the time of tc invocation.
> >        vlan_id VID
> >               Match on vlan tag id.  VID is an unsigned 12bit value in
> > decimal format.
> >
> > And there is a generic "vlan" action (man tc-vlan) that supports the
> > "modify" command.
> >
> > Judging from this syntax, I would need to add a tc-flower rule on the
> > egress qdisc of swpB, with indev swpA and vlan_id N.
> > But what should I do if I need to do VLAN retagging towards the CPU
> > (where DSA does not give me a hook for attaching tc filters)?
> >
> > Thanks,
> > -Vladimir
> 
> While I don't want to influence the advice that I get, I tried to see
> this from the perspective of "what would a non-DSA device do?".
> So what I think would work for me is:
> - For VLAN retagging of autonomously forwarded flows (between 2
> front-panel ports) I can do the egress filter with indev that I
> mentioned above.
> - For VLAN retagging towards the CPU, I can just attach the filter to
> the ingress qdisc and not specify an indev at all. The idea being that
> this filter will match on locally terminated packets and not on all
> packets received on this port.
> Would this be confusing?

Why don't you just use "skip_hw" flag? The filter will not be installed
in hardware and will only match locally received packets. Isn't this
what you want?
