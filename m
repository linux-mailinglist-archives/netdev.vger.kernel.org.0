Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35678322009
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhBVTWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhBVTTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:19:52 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBAFC061786
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 11:19:02 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id l2so772691pgb.1
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 11:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u1Yz+6yxFUR2YFaIiitfuzmwB6FuPozy4hIi547hR20=;
        b=ohvTM7J9u8GjvBzjWDTkgx90AWiCQ/i//M+PotdIS7G0+MqhnzGaUUUMNBC+NvE/Zu
         eVpvgcq5khGzLC7dP0bWBHm3fvq/Fys9dlqF0cmzzg7sKQaxN9q8ockyrUbHg3EEOzhR
         68uVaEgp9ZSOe5yWD3Ks4hRXCTdJ1lSriwsCVB6608ZESLnEdePWuFsbyeSgPDrNOKxu
         NlNRIMeFc5J9m91KD6wyBKqR2bRMYXKCpG85/DRw+jzqKjQsMwC/lTIKHbPnQCQnO/b+
         JTcQVmxbx3EcGF/R4dyDAKU9NTJXS1KAmQjBjx9W4QNlK9/t598OQ0M3zMOMycNhlg4k
         Ytwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u1Yz+6yxFUR2YFaIiitfuzmwB6FuPozy4hIi547hR20=;
        b=iMLxNpAGvW1w7LbCcrWC9fof8ljc3ewi9J+c8b40fVHa7mZkQDkP/0mynqhBWhAi7r
         Cl64BNGAAZtX9/9SRID9wBppHJkkiMow9gh8sfUwQRsGaB4R3tKVZKioDD6wThCojT0Y
         mbz7fo8hfZnjo9fU9Jxhxhjz2VsqC3wsWfhql/cSwCTwKsyKRuP4Ah+I1MEomkrFol5U
         mtGrWYjjItd5FnXGbUjXpYOk5z45W9XcQXyNscTmTKHkMIWrVSGTD5vwpevfjz8nwTm/
         IE2yeYIXwjD3FkzhqpUsh09+TqF9pQiUg8amXiXNUlNXeFTGVkpBkXxi95pPWbfpwCwZ
         elzQ==
X-Gm-Message-State: AOAM533pSA0LMrac08/p1ttRa9i740a3YQLtnSaDmtMao+nao4TybXGK
        FhC5VGI9oVOFF/trroTXPHrpvQ==
X-Google-Smtp-Source: ABdhPJyCaizPJhkS52nsxtmIXWIxjJTGO4Yo5nmBm/qoQvXb0M6U8GD8RBVENzk398QnZKHls4WuQg==
X-Received: by 2002:a63:1343:: with SMTP id 3mr21043379pgt.166.1614021540237;
        Mon, 22 Feb 2021 11:19:00 -0800 (PST)
Received: from hermes.local (mobile-166-176-184-131.mycingular.net. [166.176.184.131])
        by smtp.gmail.com with ESMTPSA id w187sm19944000pgb.52.2021.02.22.11.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 11:18:59 -0800 (PST)
Date:   Mon, 22 Feb 2021 11:18:51 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, Ido Kalir <idok@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc] rdma: Fix statistics bind/unbing argument
 handling
Message-ID: <20210222111851.710aa045@hermes.local>
In-Reply-To: <YC4o4L93lGYFQ1ku@unreal>
References: <20210214083335.19558-1-leon@kernel.org>
        <5e9a8752-24a1-7461-e113-004b014dcde9@gmail.com>
        <YCoJULID1x2kulQe@unreal>
        <04d7cd07-c3eb-c39c-bce1-3e9d4d1e4a27@gmail.com>
        <YCtjO1Q2OnCOlEcu@unreal>
        <9217385b-6002-83c2-b386-85650ce101bc@gmail.com>
        <YC4o4L93lGYFQ1ku@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Feb 2021 10:44:16 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> On Tue, Feb 16, 2021 at 08:48:24AM -0700, David Ahern wrote:
> > On 2/15/21 11:16 PM, Leon Romanovsky wrote:  
> > > On Mon, Feb 15, 2021 at 06:56:26PM -0700, David Ahern wrote:  
> > >> On 2/14/21 10:40 PM, Leon Romanovsky wrote:  
> > >>> On Sun, Feb 14, 2021 at 08:26:16PM -0700, David Ahern wrote:  
> > >>>> what does iproute2-rc mean?  
> > >>>
> > >>> Patch target is iproute2.git:
> > >>> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/  
> > >>
> > >> so you are asking them to be committed for the 5.11 release?  
> > >
> > > This is a Fix to an existing issue (not theoretical one), so I was under
> > > impression that it should go to -rc repo and not to -next.  
> >
> > It is assigned to Stephen for iproute2.
> >  
> > >
> > > Personally, I don't care to which repo will this fix be applied as long
> > > as it is applied to one of the two iproute2 official repos.
> > >
> > > Do you have clear guidance when should I send patches to iproute2-rc/iproute2-next?
> > >  
> >
> > It's the rc label that needs to be dropped: iproute2 or iproute2-next.  
> 
> Sure, no problem.
> 
> Thanks

Applied, and fixed a minor whitespace issue reported by checkpatch
