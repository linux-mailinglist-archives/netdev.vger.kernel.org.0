Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7696F10FBB4
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfLCKZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:25:46 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:43235 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCKZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:25:46 -0500
Received: by mail-pj1-f53.google.com with SMTP id g4so1338572pjs.10
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 02:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Mf3Sb607PKT/ZuH7m8VJHeLiBmK0FHllPmByNNn4bFQ=;
        b=RLFJbTqBCbRMeCsRQJS3jVx9w1KhlJ83GnB/KnrwcpgsWMMJSlOFRZNykdo1f7P219
         W4DfN4bVoqvmY1nIY8y0rUzEtz3nFVcdqegaJ2vCBZNhx6bI63knzLnBikwJhyj0Q8/j
         KbWQNWlXtAHryPOD6vHrRLaksd+v0Sv+7Q1WUZDvcFOZ+tByCV8DhoIQrbTtgtR4svl0
         es1pVOyI9X5WKr8F1ZJouB36fI05v3iMUHVhlPWcDsSqRAyZlH4+g6ECKAjST+4WSv1C
         SuR1cmzVZT0bbP4elpgdC6cUIj2r6URnkk7DVLwfnSAbgXGuIgPFE3vYSIu1dKfaYcRM
         sdGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Mf3Sb607PKT/ZuH7m8VJHeLiBmK0FHllPmByNNn4bFQ=;
        b=OJWVB8h7pdhcHfQ448aKiSqzQeFr8PIKvIizMosSjiv4rowqKJXvrO2rfBXEloSSiq
         iQ3VMIsYPePF2B0Urri2Ml8aKNvn81ZBBLhWpk6RdL2EalQbx07HdSfgAQc6zKDhRKYN
         U+Kq8D7PEHU6Aq77gPF4ik4pBIu8w7dYiOgGQQXECuYTERQwYzHYZq5GS6iEbc/4PDUa
         ea8sQk+aT32K0HFZQCGC2YGFtni9YeTvUV6QF/tM7KIP4ESBl7N+ANL1/lN1Xf39m0Hv
         qjYQsR38cGvWP0fez5h9J5ItdmwLmhBPqwN6AKmwOnOkSmJq5zDEhrcEnWQsuBaVXL+j
         bH9w==
X-Gm-Message-State: APjAAAXEV9GNKrtqMM7v9TZeB7QHJ8UoTAVRABGZAnJljKfDm5AOW3p8
        8xTzP1zsxJ0TDwowcnE/fzv8nReN12bIFw==
X-Google-Smtp-Source: APXvYqyztpesJ9b8ivfNEQ9d0OleKVHr8gQ297tbrvm7cmHtd1xsVoTvTUeNWmj6V3vUDnDyYTJXPA==
X-Received: by 2002:a17:902:b70e:: with SMTP id d14mr3956326pls.51.1575368745060;
        Tue, 03 Dec 2019 02:25:45 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t8sm3316885pfq.92.2019.12.03.02.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 02:25:44 -0800 (PST)
Date:   Tue, 3 Dec 2019 18:25:35 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, ja@ssi.bg, marcelo.leitner@gmail.com,
        dsahern@gmail.com, edumazet@google.com
Subject: Re: [PATCHv2 net] ipv6/route: should not update neigh confirm time
 during PMTU update
Message-ID: <20191203102534.GK18865@dhcp-12-139.nay.redhat.com>
References: <20191122061919.26157-1-liuhangbin@gmail.com>
 <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191202.184704.723174427717421022.davem@davemloft.net>
 <20191203101536.GJ18865@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203101536.GJ18865@dhcp-12-139.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi David,
On Tue, Dec 03, 2019 at 06:15:36PM +0800, Hangbin Liu wrote:
> On Mon, Dec 02, 2019 at 06:47:04PM -0800, David Miller wrote:
> > From: Hangbin Liu <liuhangbin@gmail.com>
> > Date: Tue,  3 Dec 2019 10:11:37 +0800
> > 
> > > Fix it by removing the dst_confirm_neigh() in __ip6_rt_update_pmtu() as
> > > there is no two-way communication during PMTU update.
> > > 
> > > v2: remove dst_confirm_neigh directly as David Miller pointed out.
> > 
> > That's not what I said.
> > 
> > I said that this interface is designed for situations where the neigh
> > update is appropriate, and that's what happens for most callers _except_
> > these tunnel cases.
> > 
> > The tunnel use is the exception and invoking the interface
> > inappropriately.
> > 
> > It is important to keep the neigh reachability fresh for TCP flows so
> > you cannot remove this dst_confirm_neigh() call.

I have one question here. Since we have the .confirm_neigh fuction in
struct dst_ops. How about do a dst->ops->confirm_neigh() separately after
dst->ops->update_pmtu()? Why should we mix the confirm_neigh() in
update_pmtu(), like ip6_rt_update_pmtu()?

Thanks
Hangbin
