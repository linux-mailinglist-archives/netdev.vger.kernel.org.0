Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A9562712B
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 18:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbiKMRLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 12:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiKMRK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 12:10:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6748C74F
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 09:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=O5LpGkI3GZa2hsxSRoBhMD47eMLuDh+pX4loelW/Huw=; b=xOPvhEV7D104Niy6hRuuxSafTV
        ASz1LsHb8ruNtankm0S47fEJrrfPerM7zdN6GuiZFA7Ql4qZZeGp2dRDOVEB42znUCYxXZX4gIqFq
        8Wsxll35feSJEkca7R/owFN4W/2ii5zzRaWpYHkfAN+15CBdgTJUqHrnH64+7w6mH/hE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouGVD-002Fic-C0; Sun, 13 Nov 2022 18:10:39 +0100
Date:   Sun, 13 Nov 2022 18:10:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     John Ousterhout <ouster@cs.stanford.edu>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: Upstream Homa?
Message-ID: <Y3ElDxZi6Hswga2D@lunn.ch>
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
 <20221110132540.44c9463c@hermes.local>
 <Y22IDLhefwvjRnGX@lunn.ch>
 <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
 <Y26huGkf50zPPCmf@lunn.ch>
 <Y29RBxW69CtiML6I@nanopsycho>
 <CAGXJAmzdr1dBZb4=TYscXtN66weRvsO6p74K-K3aa_7UJ=sEuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXJAmzdr1dBZb4=TYscXtN66weRvsO6p74K-K3aa_7UJ=sEuQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Homa implements RPCs rather than streams like TCP or messages like
> UDP. An RPC consists of a request message sent from client to server,
> followed by a response message from server back to client. This requires
> additional information in the API beyond what is provided in the arguments to
> sendto and recvfrom. For example, when sending a request message, the
> kernel returns an RPC identifier back to the application; when waiting for
> a response, the application can specify that it wants to receive the reply for
> a specific RPC identifier (or, it can specify that it will accept any
> reply, or any
> request, or both).

This sounds like the ancillary data you can pass to sendmsg(). I've
not checked the code, it might be the current plumbing is only into to
the kernel, but i don't see why you cannot extend it to also allow
data to be passed back to user space. If this is new functionality,
maybe add a new flags argument to control it.

recvmsg() also has ancillary data.

	  Andrew
