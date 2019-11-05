Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8281EF08AA
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbfKEVtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:49:11 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43125 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfKEVtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:49:11 -0500
Received: by mail-lj1-f195.google.com with SMTP id y23so12732475ljh.10
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=1IAfemfWiRa0BbOMzZRVJ3MuU9naCSjZuwYiXS7p6Z8=;
        b=vDzUBVmuP7a07G9CgfbjSS5spRigB55ASI7ekF6utj4Sm2fixQmMPCY3V8tKUN+k06
         kZV3MW0Lcnkg1os0gho7LwNN1/zsiH6bj7RrwCZeAKm4f81v2KrS28S3xxeSKqdxgV89
         XINwpc7aVsOsSiBXn4r1nGvFJVE2KY0WcOiGsH2aZskKI/vYQmLJ9grLHZPsFNXi9131
         xfCdYPBYZrDbwB/Rj3nTBzmiAkl4bpvKeqHXRZj+9cRwV0HAdouBvQaSORiAdT8+mjeF
         fiX4fl9PSUc38bg6hLdOv7N/3AXtL0l7wuANf23zugytnt/15SSO6fcWgXCuQeV8+MTK
         0tIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1IAfemfWiRa0BbOMzZRVJ3MuU9naCSjZuwYiXS7p6Z8=;
        b=WH0VDQXB1UeNoGPoY4aDlHyYUKIZAq3FaXc5fsZ15zuZvvgrc7IGRQhrPUlOHIEH2d
         QdXljKX+MEvGEY6ooWNogvKB17BDOZsw6LhOVI/GyCK7D5wQ2UEyZRsUeGWS4ShgqV15
         oVilziVi6IgIE+SpQgpuHl9DkqKba7TcGxTTV9d6KzsK8D09eGVEYS9DRrUXGsOjoYaF
         XBV6ngHPi5u4jULdrWQMUDI2DwKx/9WINbT7tD+KEYb66CBEfxnAlmFAhWrCQgARFGZH
         PjtOzzfaqasPA8+wuakU+LINmW5DOXzvzV8GFONdKzX5/iauZjBIlFYZjTrZaZRBuyLF
         /9Sg==
X-Gm-Message-State: APjAAAUTEIAo0Sm2G7EjmvwDtJIWhvKp0xNOatUPNRNeaPq57ONskhIw
        husu2LGApfghGb+carV6a9uLMg==
X-Google-Smtp-Source: APXvYqzaPxbjzUhrzEXx1iU4CtPbYaJFLoWI8DUKvnFmHA9G3ViMeZ6+tB1dKYU7w2xHoRNI8qqQlw==
X-Received: by 2002:a2e:2e10:: with SMTP id u16mr361575lju.51.1572990547876;
        Tue, 05 Nov 2019 13:49:07 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 141sm9647178ljj.37.2019.11.05.13.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 13:49:07 -0800 (PST)
Date:   Tue, 5 Nov 2019 13:48:58 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191105134858.5d0ffc14@cakuba.netronome.com>
In-Reply-To: <20191105204826.GA15513@splinter>
References: <20191103083554.6317-1-idosch@idosch.org>
        <20191104123954.538d4574@cakuba.netronome.com>
        <20191104210450.GA10713@splinter>
        <20191104144419.46e304a9@cakuba.netronome.com>
        <20191104232036.GA12725@splinter>
        <20191104153342.36891db7@cakuba.netronome.com>
        <20191105074650.GA14631@splinter>
        <20191105095448.1fbc25a5@cakuba.netronome.com>
        <20191105204826.GA15513@splinter>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 22:48:26 +0200, Ido Schimmel wrote:
> On Tue, Nov 05, 2019 at 09:54:48AM -0800, Jakub Kicinski wrote:
> > Hm, the firmware has no log that it keeps? Surely FW runs a lot of
> > periodic jobs etc which may encounter some error conditions, how do 
> > you deal with those?  
> 
> There are intrusive out-of-tree modules that can get this information.
> It's currently not possible to retrieve this information from the
> driver. We try to move away from such methods, but it can't happen
> overnight. This set and the work done in the firmware team to add this
> new TLV is one step towards that goal.
> 
> > Bottom line is I don't like when data from FW is just blindly passed
> > to user space.  
> 
> The same information will be passed to user space regardless if you use
> ethtool / devlink / printk.

Sure, but the additional hoop to jump through makes it clear that this
is discouraged and it keeps clear separation between the Linux
interfaces and proprietary custom FW.. "stuff".
