Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD37DF0477
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390467AbfKERyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:54:53 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40219 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389356AbfKERyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 12:54:52 -0500
Received: by mail-pg1-f194.google.com with SMTP id 15so14781398pgt.7
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 09:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lJFn0W7aQzff51fXVegzzXaDys8Faw88hbHiKu0VRd4=;
        b=JHRtJuOS818Uw6jM32aVRzKS+gEouZrwK5eHHRaINEwLoFd1m4m4qfaHejLDpUFoEz
         grY9PFXilwBNdbHsj0BGxOgguJLULMQm7Dq8dGweIrdg7sVwFWHVoGtvWqFTrDj8OqTV
         JWi04qOs+nBBdRsqQaalMqkrignYrjQlxf3uoL61sDiM5LHSlG6BuhXiqaf/CyG2c2Fj
         e8ZOOJ+Nj/NJXMNnmn/8xlcAtip6U7BWX7JU0+8uIaeZff4e0YclZkZoRpFeDQd+5G+w
         CMHzabeoV0tCoFX0Q/3/5zzczw/PHPg0J4KdYlMJmr69kAutPIhSi/WYmB35ZI6cYsgp
         sHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lJFn0W7aQzff51fXVegzzXaDys8Faw88hbHiKu0VRd4=;
        b=jLd2/QgDHoHSPG0c5GG7T58kQu5UC2Ys65e0xQ4uLBmPUiKlsfq+g2dAmQ9PjkKdjX
         rlaCSXG2NwqGxYzSHPp/1SBLwbPfGKo9rNf67xlFBQQ8yKnyvGDtFYXvyoOrtLrxwJaY
         pBorivMCUsvOpf21zPiiKEjn55GIZHgA8QkEg5baxtEhmCdRVBLyOtU53QQoaYy2iNLI
         NO61nanPlmlALRQ35HyY5nEdV215/Qms4AKThAmT+Pn312egN5U70JOqvhaTApI/EvPD
         6Sd2fQn5+3FF1xSBN/Cii359zVSYNedVVCtmh6SoixS2M6iB+ZT6t7NNLd3SkCixRx+J
         /T/Q==
X-Gm-Message-State: APjAAAXXmRWZeEmbFwvvF433CsOhAMibLmOnFqDiuzw5zg5ptUDlCoF4
        44NiiO/XQuQaUnxZnhQxev0CFQ==
X-Google-Smtp-Source: APXvYqz+LbrHjW2/OgAjCkM7jG+ruUv19uMdvgC4tpKF7bDWwGGKh6FEaYEzmVjqFbqcj7HeQ9ajjw==
X-Received: by 2002:a17:90a:f48f:: with SMTP id bx15mr300191pjb.115.1572976492078;
        Tue, 05 Nov 2019 09:54:52 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::4])
        by smtp.gmail.com with ESMTPSA id y1sm22370779pfq.138.2019.11.05.09.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 09:54:51 -0800 (PST)
Date:   Tue, 5 Nov 2019 09:54:48 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191105095448.1fbc25a5@cakuba.netronome.com>
In-Reply-To: <20191105074650.GA14631@splinter>
References: <20191103083554.6317-1-idosch@idosch.org>
        <20191104123954.538d4574@cakuba.netronome.com>
        <20191104210450.GA10713@splinter>
        <20191104144419.46e304a9@cakuba.netronome.com>
        <20191104232036.GA12725@splinter>
        <20191104153342.36891db7@cakuba.netronome.com>
        <20191105074650.GA14631@splinter>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 09:46:50 +0200, Ido Schimmel wrote:
> On Mon, Nov 04, 2019 at 03:33:42PM -0800, Jakub Kicinski wrote:
> > On Tue, 5 Nov 2019 01:20:36 +0200, Ido Schimmel wrote:  
> > > On Mon, Nov 04, 2019 at 02:44:19PM -0800, Jakub Kicinski wrote:  
> > > > On Mon, 4 Nov 2019 23:04:50 +0200, Ido Schimmel wrote:    
> > > > > I don't understand the problem. If we get an error from firmware today,
> > > > > we have no clue what the actual problem is. With this we can actually
> > > > > understand what went wrong. How is it different from kernel passing a
> > > > > string ("unstructured data") to user space in response to an erroneous
> > > > > netlink request? Obviously it's much better than an "-EINVAL".    
> > > > 
> > > > The difference is obviously that I can look at the code in the kernel
> > > > and understand it. FW code is a black box. Kernel should abstract its
> > > > black boxiness away.    
> > > 
> > > But FW code is still code and it needs to be able to report errors in a
> > > way that will aid us in debugging when problems occur. I want meaningful
> > > errors from applications regardless if I can read their code or not.  
> > 
> > And the usual way accessing FW logs is through ethtool dumps.  
> 
> I assume you're referring to set_dump() / get_dump_flag() /
> get_dump_data() callbacks?
> 
> In our case it's not really a dump. These are errors that are reported
> inline to the driver for a specific erroneous operation. We currently
> can't retrieve them from firmware later on. Using ethtool means that we
> need to store these errors in the driver and then push them to user
> space upon get operation. Seems like a stretch to me. Especially when
> we're already reporting the error code today and this set merely
> augments it with more data to make the error more specific.

Hm, the firmware has no log that it keeps? Surely FW runs a lot of
periodic jobs etc which may encounter some error conditions, how do 
you deal with those?

Bottom line is I don't like when data from FW is just blindly passed
to user space. Printing to the logs is perhaps the smallest of this
sort of infractions but nonetheless if there is no precedent for doing
this today I'd consider not opening this box.
