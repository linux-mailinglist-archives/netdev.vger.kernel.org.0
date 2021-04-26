Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F6636B43C
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 15:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhDZNry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 09:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhDZNrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 09:47:53 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FCDC061574;
        Mon, 26 Apr 2021 06:47:12 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 966213723; Mon, 26 Apr 2021 09:47:11 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 966213723
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1619444831;
        bh=o1uV8mMXke6YWci50VHqZhlaQRReuOaqTAAYtR+elE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qTPyU0qm8YYRWeSjDPQeY0Bdm37EJnecOt71xY/pT/e03dK0uipO2rk+Xu/IAsYhk
         CTtheiYvyfbzjjf7L6A+8KGZo5dbWd1GqkfBAkeN5GYAuyEJaIeQDsb1o359SmOPOY
         M+CIqqYl5mV/6uL/wKRw+HM5O2GYRXkXvxqhfQe4=
Date:   Mon, 26 Apr 2021 09:47:11 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Leon Romanovsky <leon@kernel.org>,
        "Shelat, Abhi" <a.shelat@northeastern.edu>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <20210426134711.GE21222@fieldses.org>
References: <20210422193950.GA25415@fieldses.org>
 <YIMDCNx4q6esHTYt@unreal>
 <20210423180727.GD10457@fieldses.org>
 <YIMgMHwYkVBdrICs@unreal>
 <20210423214850.GI10457@fieldses.org>
 <YIRkxQCVr6lFM3r3@zeniv-ca.linux.org.uk>
 <20210424213454.GA4239@fieldses.org>
 <YIS6t+X1DOKlB+Z/@mit.edu>
 <YIUMYYcf/VW4a28k@kroah.com>
 <20210426133605.GD21222@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426133605.GD21222@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 09:36:05AM -0400, J. Bruce Fields wrote:
> On Sun, Apr 25, 2021 at 08:29:53AM +0200, Greg KH wrote:
> > On Sat, Apr 24, 2021 at 08:41:27PM -0400, Theodore Ts'o wrote:
> > > On Sat, Apr 24, 2021 at 05:34:54PM -0400, J. Bruce Fields wrote:
> > > > In Greg's revert thread, Kangjie Lu's messages are also missing from the
> > > > archives:
> > > > 
> > > > 	https://lore.kernel.org/lkml/20210421130105.1226686-1-gregkh@linuxfoundation.org/
> > > >
> > > 
> > > I'm going to guess it's one of two things.  The first is that they are
> > > sending mail messages with HTML which is getting bounced; the other
> > > possibility is that some of the messages were sent only to Greg, and
> > > he added the mailing list back to the cc.
> > > 
> > > So for exampple, message-id
> > > CA+EnHHSw4X+ubOUNYP2zXNpu70G74NN1Sct2Zin6pRgq--TqhA@mail.gmail.com
> > > isn't in lore, but Greg's reply:
> > > 
> > > https://lore.kernel.org/linux-nfs/YH%2FfM%2FTsbmcZzwnX@kroah.com/
> > > 
> > > can be found in lore.kernel.org was presumably because the message
> > > where Aditya accused "wild accusations bordering on slander" and his
> > > claim that his patches were the fault of a "new static code analyzer"
> > > was sent only to Greg?  Either that, or it was bounced because he sent
> > > it from gmail without suppressing HTML.
> > 
> > I did not "add back" the mailing list, it looks like they sent email in
> > html format which prevented it from hitting the public lists.  I have
> > the originals sent to me that shows the author intended it to be public.
> 
> Yes, the list cc's are all on there.
> 
> It's multipart/alternative with equivalent plain text and html parts,
> which appears to be gmail's default behavior.  Is that really rejected
> by default?

Hah, when I sent that mail I quoted parts of the message including the
Content-Type headers delineating the parts and got an immediate bounce
saying "The message contains HTML subpart, therefore we consider it SPAM
or Outlook Virus.  TEXT/PLAIN is accepted".

Which seems perfectly clear.  OK, sorry for the noise!

--b.
