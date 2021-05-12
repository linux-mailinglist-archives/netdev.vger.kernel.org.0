Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F5537D0A6
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 19:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242292AbhELRed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 13:34:33 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56203 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344846AbhELRCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 13:02:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3ABC35C009D;
        Wed, 12 May 2021 13:01:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 12 May 2021 13:01:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=animalcreek.com;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=ehLJt91Cv1IJwJ6IYAYh3aRLUhG
        2EWZLs3iv2swzrNI=; b=KKfGp9ZnxPCUof9nSRlhWO43OD/zAXMJzBREOk1G+XW
        r0ZmzlRsZc5IS+kH7lzjrRBANuag/bVz3cqUZuIkEi5ldtlNcnzR5piMZBO1PbSN
        tysY1y68zSPXr6fOYGzssLFT4T6nJgGGWlkcl0Y7nhy0w1kJiutNdPHjC80Lgy5c
        EtMWGbrjKkW1ZiTFGcWUp5CfR7qvrTfk0WLzyRGg7VCaiQcHDmI6ZIKUv7bfbCYN
        ZxPeaXrRFyDxNQSf85RvkMAg0JSbOJr+NmTV93ROdVoCZLMJlxA/+FFGCkmfJaaP
        ShHZEo7k52AGBtzRLYqP+1dNM5teMt/FzI1dHUyUk9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ehLJt9
        1Cv1IJwJ6IYAYh3aRLUhG2EWZLs3iv2swzrNI=; b=N39Tksa1cGZiVqbx8y/Zss
        fEXlnUuLSWOkDWab6PaGj2doagfDjnMSk7ViroyfGN6tq1zMAqQzAUmDzNsF0tX8
        TvuE8+x9CeInDqVXIGw6q2gsYr70g+BuSP6QWphXQm0P7brfPB4sJSgek/IO+w8B
        Ds3gHLhKOt7C5Omd5TD6neREnAvJvWA+TjdRo9P02phpg+icSGbgJhg2TvaVxVVL
        21iEYNVfIor4JR8pxpRqlw+314ZesR2DXrhR3N/zPtNNcAsaYB1QYzUpHGmvaWh0
        to9wFV7HcZ8/m+UR+o3AwgrGRub8UIgR49vgYhExcyg3tHHCp3UVCIJ4kdFfbUCQ
        ==
X-ME-Sender: <xms:8AmcYHrd_tDp0je2TBQSKifWTfgENxKOJkLix_uDFzAPSTUBJfcMiw>
    <xme:8AmcYBoF7jc6U_sPlaakHBfujyOa_aZ2M-EaDkl9nin-r8_VsF3STxBHl8MK06O7L
    JAkzGm1ymfCoeRf_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujghosehttdertddttddvnecuhfhrohhmpeforghr
    khcuifhrvggvrhcuoehmghhrvggvrhesrghnihhmrghltghrvggvkhdrtghomheqnecugg
    ftrfgrthhtvghrnhepkedvieegledtvdeuveejueetteevtdetueekgedvkedtgeeftdel
    leekkeduteefnecuffhomhgrihhnpedtuddrohhrghdpqhhtrdhiohdpkhgvrhhnvghlrd
    horhhgnecukfhppeejtddrudejvddrfedvrddvudeknecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepmhhgrhgvvghrsegrnhhimhgrlhgtrhgvvg
    hkrdgtohhm
X-ME-Proxy: <xmx:8QmcYEPgReCzZXmWP0Tfwqn78XZtoyaoOTnEn-Hc1HcDZt2aSfGCyw>
    <xmx:8QmcYK4a5GFu3Jrxzn-ZLeu8nbigWmcEHtjoYKwpo2NTh6nCfK5orA>
    <xmx:8QmcYG50w1YHNG7caBPLfcVHDhY9hSCLxoG55PAclK8XBt7zrivexg>
    <xmx:8gmcYDuVJtVFFGGAM28KephTStB0LDfjx64dJQdC4cnhMXZwWte18A>
Received: from blue.animalcreek.com (ip70-172-32-218.ph.ph.cox.net [70.172.32.218])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 13:01:36 -0400 (EDT)
Received: by blue.animalcreek.com (Postfix, from userid 1000)
        id 87ACB136008B; Wed, 12 May 2021 10:01:35 -0700 (MST)
Date:   Wed, 12 May 2021 10:01:35 -0700
From:   Mark Greer <mgreer@animalcreek.com>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Alex Blasche <alexander.blasche@qt.io>,
        Mark Greer <mgreer@animalcreek.com>
Subject: Re: [linux-nfc] [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof
 Kozlowski as maintainer
Message-ID: <20210512170135.GB222094@animalcreek.com>
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
 <14e78a9a-ed1a-9d7d-b854-db6d811f4622@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14e78a9a-ed1a-9d7d-b854-db6d811f4622@kontron.de>
Organization: Animal Creek Technologies, Inc.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 05:32:35PM +0200, Frieder Schrempf wrote:
> On 12.05.21 16:43, Krzysztof Kozlowski wrote:
> > The NFC subsystem is orphaned.  I am happy to spend some cycles to
> > review the patches, send pull requests and in general keep the NFC
> > subsystem running.
> 
> That's great, thanks!
> 
> Maybe you also want to have a look at the userspace side and talk to Mark Greer (on cc). He recently said, that he is supposed to be taking over maintenance for the neard daemon (see this thread: [1]) which currently looks like it's close to being dead (no release for several years, etc.).
> 
> I don't know much about the NFC stack and if/how people use it, but without reliable and maintained userspace tooling, the whole thing seems of little use in the long run. Qt has already dropped their neard support for Qt 6 [2], which basically means the mainline NFC stack won't be supported anymore in one of the most common application frameworks for IoT/embedded.
> 
> [1] https://lists.01.org/hyperkitty/list/linux-nfc@lists.01.org/thread/OHD5IQHYPFUPUFYWDMNSVCBNO24M45VK/
> [2] https://bugreports.qt.io/browse/QTBUG-81824

Re: QT - I've already talked to Alex Blasche from QT (CC'd).  With some
work we can get Linux NFC/neard back into their good graces.  I/we need
to find time to put in the work, though.

An example of the issues they have seen is:

	https://bugreports.qt.io/browse/QTBUG-43802

Another issue I have--and I suspect you, Krzysztof, have as well--is
lack of hardware.  If anyone reading this wants to volunteer to be a
tester, please speak up.

To help get everyone on the same page, this is a response I made to
Krzysztof in another email:

    "Krzysztof, the NFC portion of the kernel has a counterpart in userspace
     called neard.  I'm supposed to be maintaining it but I have next to no
     time to do so.  If you have spare cycles, any help would be appreciated.

     Anyway, in neard, there are some simple test scripts (python2 - I/we need
     to update to python3).  The current home of neard is:

     git://git.kernel.org/pub/scm/network/nfc/neard.git"

Thanks,

Mark
--
