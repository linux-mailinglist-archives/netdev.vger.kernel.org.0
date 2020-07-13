Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA0B21DDE3
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgGMQwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMQwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:52:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0923BC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:52:37 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mn17so132864pjb.4
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wrAaHduBdQbUYalfKSif9bR5Rv1vZ68m8qdBneNhvGQ=;
        b=ksOoM5dEnWLXXCByc4J4/AARtKkL2mR2havTTN9wnyWw2dPolP/niwBJGnN6e0aYYE
         JXLdXIBZTSpZaWRcKSN/8xkKNYal6tdpL4BO4s8MEE/ufb7jPfk2trXSMq1NMCh8Ey0P
         q8LLm+V+wWvkqXELF3xY67JZv4lqklpVLx9vI6sSOGWogOKd/OONkhj1Z2CrOCUksbyi
         l8QWkF2kpRI6bc7nw0DKaq62EgJR9/i67FZaSHZ4Q4WUzObBXxzV57aISJmEK2i7harC
         Uwk2ss1LVJvMgj8XeM+K7Hg072RbLikSbsdVXJB7pJgjIX017LBeaQdu/UmeO4YWZfTC
         DCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wrAaHduBdQbUYalfKSif9bR5Rv1vZ68m8qdBneNhvGQ=;
        b=SM9GI0wDfqnQNoqlTM9D/8eAhOTXuAKP7quHi7Dnt6YYufLr3ZuHEC1zpszCCXgAga
         hKUfO+i/r5hTae3BRlGgbT2zXKbSvpXC6x/pDuvdpIh7EYa1J1jFlBYfD3q+t8wo8wwn
         +Awhp2Z8JAVo2O+xUXUXvZFWMhOrOZIAs7UTiwo55KLNE1txBMX6cEzh75qpfSg7hHW7
         cXXEb6Do3aH3khvm05dJSAQ4Rg7qwPx416G3fb2wTD7VWbBPmJ9jqXwwDZyjz052RFPs
         3Y3Nrm8V3jfQZiTZDO67dyICgqZZockrkNR9sY3fj5uvhi60oBwFgonhfkt5l8lHat5X
         cxEg==
X-Gm-Message-State: AOAM530HhjgFqSSOAOxiDvLwX+ScGBYHuJ+VQAjz44xSzPqo/Wa2cP60
        2d9aCdHI7zbhgXnmAmLmxVQiaD74mlDPoA==
X-Google-Smtp-Source: ABdhPJxd2f/g4tNjxsmTdBbVO/IsyTKAbOE9qZKTgzHmhKVSr36Iix1EjzRE49cL910/bCa5qVsjaQ==
X-Received: by 2002:a17:902:b78a:: with SMTP id e10mr510289pls.194.1594659156498;
        Mon, 13 Jul 2020 09:52:36 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id lx2sm150187pjb.16.2020.07.13.09.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:52:36 -0700 (PDT)
Date:   Mon, 13 Jul 2020 09:52:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Russell Strong <russell@strong.id.au>
Cc:     netdev@vger.kernel.org
Subject: Re: amplifying qdisc
Message-ID: <20200713095228.5867b7ec@hermes.lan>
In-Reply-To: <20200712114001.27b6399c@strong.id.au>
References: <20200709161034.71bf8e09@strong.id.au>
        <20200708232634.0fa0ca19@hermes.lan>
        <20200712114001.27b6399c@strong.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jul 2020 11:40:01 +1000
Russell Strong <russell@strong.id.au> wrote:

> On Wed, 8 Jul 2020 23:26:34 -0700
> Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> > On Thu, 9 Jul 2020 16:10:34 +1000
> > Russell Strong <russell@strong.id.au> wrote:
> >   
> > > Hi,
> > > 
> > > I'm attempting to fill a link with background traffic that is sent
> > > whenever the link is idle.  To do this I've creates a qdisc that
> > > will repeat the last packet in the queue for a defined number of
> > > times (possibly infinite in the future). I am able to control the
> > > contents of the fill traffic by sending the occasional packet
> > > through this qdisc.
> > > 
> > > This is works as the root qdisc and below a TBF.  When I try it as a
> > > leaf of HTB unexpected behaviour ensues.  I suspect my approach is
> > > violating some rules for qdiscs?  Any help/ideas/pointers would be
> > > appreciated.    
> > 
> > Netem can already do things like this. Why not add to that
> >   
> 
> Hi,
> 
> Tried doing this within netem as follows; but run into similar
> problems.  Works as the root qdisc (except for "Route cache is full:
> consider increasing sysctl net.ipv[4|6].route.max_size.") but not under
> htb.  I am attempting to duplicate at dequeue, rather than enqueue to
> get an infinite stream of packets rather than a fixed number of
> duplicates. Is this possible?
> 
> Thanks
> Russell

HTB expects any thing under it to be work conserving.
