Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17719443A60
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 01:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhKCA3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 20:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhKCA3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 20:29:32 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F11DC061714;
        Tue,  2 Nov 2021 17:26:57 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 38B81C020; Wed,  3 Nov 2021 01:26:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635899215; bh=ssJfJT9GribpXdyR0WzQoSNTB2yUqvYv2yimhfDwlDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W2dC00XlLTfuAWa0lRdasTP1OxGKUH+08+81VvsrbDYRelVJG79n8ebJNzsKu2plp
         DLbVcw4RdkdRgrjrLAqoFhYRmpmw93WCu57Pi15M0EPIMMpvSKNs3mPUynybXOUaXl
         Srj3RFbJW/eo+d+z//Gz1B48VvhcLtrUnsJKcbBwlw4WW/kiDM09ZhyTs0wIqHZBqj
         L1jZ9XY+Ir4McgBXZaYkvE17Js3+85jM82TqE18Au+M05pIO9WehwTeOVMJq6ITnYH
         g9fxDhFvKoMrMZ84EcqEfPnFc+uj/EFUmpSRPhIatdaH7ir09zprJR+yTpP9kBb3Hs
         XVm8JBIEogaOg==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id B5645C009;
        Wed,  3 Nov 2021 01:26:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635899214; bh=ssJfJT9GribpXdyR0WzQoSNTB2yUqvYv2yimhfDwlDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CUQDILRq4/78gsIY/HM/+Ign1Oz9zCxZVq5Q5UcSAchC2CRFzPHaeCY0pw09hKXOm
         yheggZ3gQkIO2w/Vov5qxz3rMRHoIra3IT25XdmpQ8hanRslZWDLtS5E+NwG1f8dyq
         QXOkbdx7ecmWPUapkM4aQ/oi17/ND1wpM68SGqprBtGJliSGAfi4faCl2fOubH6riu
         K68LyVpvKFp+XHLsGjXrBGel9DaCmg4Lo/W4IqkeJUxqxNPao+tXsdFW+HT45OC/nF
         8SpqKLg2tcEv6QXdFJQSRDU4lT/TzBBo5XfTfqgjAfAlBpLS0WSSj4R8Ap5/HOyeOX
         xuDfSyFstuyug==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 1be5e57c;
        Wed, 3 Nov 2021 00:26:47 +0000 (UTC)
Date:   Wed, 3 Nov 2021 09:26:32 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
Cc:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: autoload transport modules
Message-ID: <YYHXOOwkmJW8bhHW@codewreck.org>
References: <20211017134611.4330-1-linux@weissschuh.net>
 <YYEYMt543Hg+Hxzy@codewreck.org>
 <922a4843-c7b0-4cdc-b2a6-33bf089766e4@t-8ch.de>
 <YYEmOcEf5fjDyM67@codewreck.org>
 <ddf6b6c9-1d9b-4378-b2ee-b7ac4a622010@t-8ch.de>
 <YYFSBKXNPyIIFo7J@codewreck.org>
 <3e8fcaff-6a2e-4546-87c9-a58146e02e88@t-8ch.de>
 <YYHHHy0qJGlpGEaQ@codewreck.org>
 <778dfd93-ace5-4cab-9a08-21d279f18c1f@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <778dfd93-ace5-4cab-9a08-21d279f18c1f@t-8ch.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas Weißschuh  wrote on Tue, Nov 02, 2021 at 11:33:25PM +0000:
> > aha, these two were indeed different from where my modprobe is so it is
> > a setup problem -- I might have been a little rash with this initrd
> > setup and modprobe ended up in /bin with path here in /sbin...
> >
> > Thanks for the pointer, I saw the code setup an environment with a
> > full-blown PATH so didn't think of checking if this kind of setting
> > existed!
> > All looks in order then :)
> 
> Does it also work for the split out FD transports?
> If so, I'll resend that patch in a proper form tomorrow.

Sorry haven't tested yet, I need to fiddle a bit to get a tcp server
setup right now and got a fscache bug I'd like fixed for this merge
window...

I've confirmed the module gets loaded but that's as far as I can get
right now... it calls p9_fd_create_tcp so it's probably quite ok :)

I'd also be tempted to add a new transport config option that defaults
to true/NET_9P value -- in my opinion the main advantage of splitting
this is not installing tcp/fd transport which can more easily be abused
than virtio for VMs who wouldn't need it (most of them), so having a
toggle would be handy.


Feel free to resend in a proper form though, I could make up a commit
message but it might as well be your words!

-- 
Dominique
