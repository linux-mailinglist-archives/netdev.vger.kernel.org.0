Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7073F0D31
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 23:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhHRVQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 17:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhHRVQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 17:16:23 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B517C061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 14:15:48 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so5983159pje.0
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 14:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=90MMNM2r4CjphxAeo54pw6vnPLieplOCTTcZNyLDLgA=;
        b=wkJ4uKbMiApqLxs5CcE6b5KdZ5deT4fk/HrZaukSvuH3oZMUbQPzOsaVdpjBr3c0uZ
         h+Iom++16pEJ+AjUD2KhMWwPqDRC8gzkEsMFi82mvr9zyHViv9PmP7yc3fTtXJ1lyD3a
         hNDLX6KPX/iDxMvDrWJd+j0o8W2xTai5gCQ31PNG1YxEdMwNJu3MjVbaHychgXiYw7/n
         ZxzMTLUyoBiTWqjFqwQIm6UJb1B77a70r6xnRZtLQqy11FF/bCF2woMaeRNA5ZKHseI9
         K0/xNND3kzWxGpscwBB6w7beGsGQiTz796gfgmfvMNFdf7mD+6lEpl3bQk2b5pXzBi7T
         PSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=90MMNM2r4CjphxAeo54pw6vnPLieplOCTTcZNyLDLgA=;
        b=nNBjKE9UiAdiCYA/oGXnGjiNvTutk6T7j9879P1E1ayLd9x+0T6ToooATg5mcLscIW
         nVqyfRNCiWpW3ighmXapFY5wt0Ksleho1SETpD/4wx86FRd13XeLS1VxIhlfYdxHPGkR
         rivUaKmLAQ76mGoTe7GjLLooaX0ez2h5NhxoW549l65EDM0kgkjpuM7gSVUsv1R/erFI
         u6DCAmGM1N/YGUq55JCAMjH9bAa4/JFauUmPm7hsGiFzRS5H0R9/V9nmocFuiqBLJ4wM
         3aiajiJ4Emb5Qqyp3hJILLOOUW461/YCYtlgYJM8jPxivAJH2wze3/pfPlmURiQ0b6mE
         CEsA==
X-Gm-Message-State: AOAM532d/V1gQFRKC7TCR+ktW0C/5WdM50Ru21CAP+HaR27/Vrr2mx0Y
        J591eB3xStuMz7fDAPPBgW6EkQ==
X-Google-Smtp-Source: ABdhPJyxhrVMBek40ffKErWj1RpAdhPvF2cpni8b6snTj9JGzKbMpw0eFeS0B+saf4JJaqQ7boEwMw==
X-Received: by 2002:a17:90a:404a:: with SMTP id k10mr11443555pjg.145.1629321347950;
        Wed, 18 Aug 2021 14:15:47 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id n22sm721730pff.57.2021.08.18.14.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 14:15:47 -0700 (PDT)
Date:   Wed, 18 Aug 2021 14:15:44 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Thorsten Glaser <t.glaser@tarent.de>, Oleg <lego12239@yandex.ru>,
        netdev@vger.kernel.org
Subject: Re: ipv6 ::1 and lo dev
Message-ID: <20210818141544.75b15e93@hermes.local>
In-Reply-To: <20210818201755.GA4899@1wt.eu>
References: <20210818165919.GA24787@legohost>
        <fb3e3ad3-7bc3-9420-d3f6-e9bae91f4cd@tarent.de>
        <20210818201755.GA4899@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Aug 2021 22:17:55 +0200
Willy Tarreau <w@1wt.eu> wrote:

> On Wed, Aug 18, 2021 at 07:47:37PM +0200, Thorsten Glaser wrote:
> > On Wed, 18 Aug 2021, Oleg wrote:
> >   
> > > I try to replace ::1/128 ipv6 address on lo dev with ::1/112 to
> > > access more than 1 address(like with ipv4 127.0.0.1/8). But i get  
> > 
> > AIUI this is not possible in IPv6, only :: and ::1 are reserved,
> > the rest of ::/96 is IPv4-compatible IPv6 addresses.
> > 
> > I never understood why you'd want more than one address for loopback
> > anyway (in my experience, the more addresses a host has, the more
> > confused it'll get about which ones to use for what).  
> 
> It's because you've probably never dealt with massive hosting :-)
> Sometimes binding a full /24 (or smaller) on the loopback, be it
> for listening addresses or to be used as sources to connect to
> next hops, is extremely useful.
> 
> Willy

In the large scale routing world addresses are assigned to loopback
interface because it keeps routing protocols happy. If interface goes
down loopback stays around.
