Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1F823D7AF
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 09:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgHFHtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 03:49:23 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:48151 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728829AbgHFHtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 03:49:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id A746F1029;
        Thu,  6 Aug 2020 03:49:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 06 Aug 2020 03:49:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=q7DxaO
        PJVaS8LWtXNtIORn1WxTk8Oijh/Ce2HabIUXc=; b=SF0bxCFnNaM/7Jt5VxZ09r
        8URVNapfCPI52RE9SzuHaAtEgWpHaBhwb+eu6R+KX6VniUMCLo4uuENLfIj1Lj54
        In7DSiZ6Gqzj/35LaCxk2qDcRnLckbAeVyF3ATZHkX1om6lSkd4YjT6GkTk0/J7V
        4bMzKLoEoYuBEYtOuvYqQ3gHMtzCeBJhLQToUHrcCc8BP8RblgH7wqS34W9zbhzy
        8kMHy5lFinfULI2HTTb4Fs8ytEyG2V3TtRr8lXL0jteZZjEjXPC/o4CCf+h5g/Us
        lZDdihwY4i2QOvxOdZm+rsP08IxQonaXbUIxbcyfeqYFeCA5iXf2n4LrN4RuxgcA
        ==
X-ME-Sender: <xms:-LUrX_9dbwqkPJX6H2xwvZKP4myOnaseYq4W4eIqkbW9RuBTZoGW0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeelgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecukfhppeejledrudekuddriedrvdduleen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-LUrX7s76JCy8LO70WyXMgD8fYFYLUy34se266KoDnRtUHQdVzP8Jw>
    <xmx:-LUrX9DIT4qzlco1TMWtFE_x8hY6_bgNm3hx2ONoyNVzTdB4o9QD6A>
    <xmx:-LUrX7fMBlchmtXJutgvXQBv3AOJ-fh_QNps5hbLMzPz09qxNPk1YA>
    <xmx:-bUrX-srDJmt6jk4zxXaz54isYxRDyDkXIE1jskr6Hq_Mq0SYspYtA>
Received: from localhost (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6962930600B4;
        Thu,  6 Aug 2020 03:49:12 -0400 (EDT)
Date:   Thu, 6 Aug 2020 10:49:09 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Swarm NameRedacted <thesw4rm@pm.me>
Cc:     netdev@vger.kernel.org
Subject: Re: Packet not rerouting via different bridge interface after
 modifying destination IP in TC ingress hook
Message-ID: <20200806074909.GA2624653@shredder>
References: <20200805081951.4iznjdgudulitamc@chillin-at-nou.localdomain>
 <20200805133922.GB1960434@lunn.ch>
 <20200805201204.vsnav57fmgqkkpxf@chillin-at-nou.localdomain>
 <20200806063336.GA2621096@shredder>
 <20200806070011.fmqvd4hekpehx425@chillin-at-nou.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806070011.fmqvd4hekpehx425@chillin-at-nou.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 07:00:15AM +0000, Swarm NameRedacted wrote:
> Not sure this applies. There's no NAT since everything is on the same
> subnet. 

IIUC, packet is received on eth0, you then change the DMAC to SMAC on
ingress (among other things) and then packet continues to the bridge.
The bridge checks the DMAC and sees that the packet is supposed to be
forwarded out of eth0. Since it's also the ingress interface the packet
is dropped. To overcome this you need to enable hairpin.
