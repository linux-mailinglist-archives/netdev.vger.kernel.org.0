Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FFC102D59
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 21:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfKSUQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 15:16:10 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38099 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfKSUQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 15:16:10 -0500
Received: by mail-lj1-f193.google.com with SMTP id v8so24858181ljh.5
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 12:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6EQ3mNDqFqGwuxFfFzmlRAC3yRdIzuq00H1ppbqq+1Q=;
        b=MU2RlJs+L+ojROmMqQDMU0dh22oqHn9t0Mw6Y+/7hL9eJWq3nWv/Uh1lO0yc6n5YLf
         YNgsrc8/B5fcHRhIZjgUsxfDtZYw20E7ivqb7SUvR+0a6Bw7i4mXpxBIffP9k0DKrJ5r
         EV8WaTg6IT+V+PYpJ/hrb90WKO0/ucna1UVvZPs1UXXmTEBN5v6Is7c/HyXT86zDjvke
         GvCM3GwwU26MmBAvJuia7UVWQcRT9Gbrb0Bzj0wNpmUBWkZw7N0JYI4V+n8VglG5bgWi
         /f4wnMaL9PZRJoANRqPvj5fz0fZOWUHLOzJtH1MsnZT7CyxwC2OvuR24TuULkNLh9S3K
         NfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6EQ3mNDqFqGwuxFfFzmlRAC3yRdIzuq00H1ppbqq+1Q=;
        b=IGdwV+nFs/QRIiYpwPZDdTQkIJzUMYF0ztxJ++tHgxU3ZoO8PQHV7Xn6jHETDoqV9k
         b/QFKjPJKlmuNnx4QL8d0s9JstzuK5SVkYtSuevde4lsyyxlGVZkwtjf3e/kLRCzje9C
         NhB1PxFvp1a9hZEwpPbBgtaethcLkEeSP0ddm7tYI+Pdlq74i3xs/QWihF1uq0doorEz
         1uBiIfXliOFpsrND17GGOQxDab5sZNyUIaMEVVRU2I18cTy2baXzkjW5OS6TPmAoU0QZ
         xK9k9rSd6kNJuMzwALqc7udould7yRhZvLnaBk8+6jEMyydMrPGEP7dzgkSBLi1YVmcH
         09CQ==
X-Gm-Message-State: APjAAAWatNmKPTD6M86UwjUwV397JrGrd2KR/j+wNGU5EoVALlyhuShj
        ZBraShSHAjhucVQ5VPpJjUzCGw==
X-Google-Smtp-Source: APXvYqyLOB2LQjXv20f52Y/eWBaMaqpBsQp2MBgZf8ykebdisqkdsB4tYmVvTVJGNQX+ekOv9ejuMA==
X-Received: by 2002:a2e:6c0c:: with SMTP id h12mr5701201ljc.24.1574194567167;
        Tue, 19 Nov 2019 12:16:07 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u6sm3692377lfu.49.2019.11.19.12.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 12:16:06 -0800 (PST)
Date:   Tue, 19 Nov 2019 12:15:52 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v4 2/3] cxgb4: check rule prio conflicts before
 offload
Message-ID: <20191119121552.6175d48a@cakuba.netronome.com>
In-Reply-To: <20191119042754.GA21175@chelsio.com>
References: <cover.1574089391.git.rahul.lakkireddy@chelsio.com>
        <f93ecd0a1607d3eebdbf3f9738abef7d8166eba0.1574089391.git.rahul.lakkireddy@chelsio.com>
        <20191118153606.27aa9863@cakuba.netronome.com>
        <20191119042754.GA21175@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 09:57:56 +0530, Rahul Lakkireddy wrote:
> > On Mon, 18 Nov 2019 22:30:18 +0530, Rahul Lakkireddy wrote:  
> > > Only offload rule if it satisfies following conditions:
> > > 1. The immediate previous rule has priority < current rule's priority.
> > > 2. The immediate next rule has priority > current rule's priority.  
> > 
> > Hm, the strict comparison here looks suspicious.
> > 
> > The most common use case for flower is to insert many non-conflicting
> > rules (different keys) at the same priority. From looking at this
> > description and the code:
> >   
> 
> Yes, I had seen this regression in one of my tests and updated the
> check below to consider equal priority in the equation. But, looks
> like I missed to update the commit and comment. It should be <=
> and >=, respectively. Will fix in v5.

Sounds good, indeed looking at the code it will only trigger if the
prio is strictly greater or smaller, IOW pass the equality.
