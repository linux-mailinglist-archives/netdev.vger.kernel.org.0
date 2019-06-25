Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3247B52361
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 08:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbfFYGPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 02:15:19 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:46681 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfFYGPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 02:15:19 -0400
Received: by mail-pg1-f173.google.com with SMTP id v9so8366453pgr.13;
        Mon, 24 Jun 2019 23:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0xtd1/J4ViydtGXP9MMxtmN/QFbXkpk0xAkv4gjrpSw=;
        b=hppAvMj3kv1StYKHt5d4uIPx4ZNyPOSORyxE0PVWuOx5jxxOvyodbgL4ih17F7KCYz
         BEQprTJ+gWhcJ+9I0fgVpprZpXBAk+5tmYkEIdw1ULJk2F3DTdjX1rhNDzy9zltuU149
         hMDCYG5FjxqXQypcZG793bOr4eIi2NvpKRO6N125zSyI4yi878qlId85N1E/SyGTUMBN
         ry++0cnoqfSPLdVxv8jhjjfms5aMbUCapnnwzkw+LHXW43FQxD93ORCDH0KbvyGQltdU
         8D5SaqEFFDB0a+9lhYoWizYp2NAA9jTc1/OKQv1liwAQvADs/rqpq4tNqGIgsTofgKoA
         7IkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0xtd1/J4ViydtGXP9MMxtmN/QFbXkpk0xAkv4gjrpSw=;
        b=J8SjA2EORZb9uvICQK3dMcPwdfHHn9AyiLMAPJVX/ElXC8qmXVCwiPLRapPab9ovTo
         FKR90qv0AKnB/kzGcy69EeGQZz/Rda/5CE6nsassZWXs1x7XLzT5amijS/RZqy07pCw+
         b/cn/PdmOewfPbVTmWAOxR0PM+psm5rL79tpAlfvwkulhvcBO5muw11CrjACtvHnTQXb
         YV37SZ6OEQ7LXLm/UoP2RAiSHkf5seHQ4B4cfHPZbGdrpgxCFIStcKM6ALbI6Yx8Fo2V
         PogVbBayA45vMiXRajr09s97nqkOxoG1U62vXeN1SALxPzVNHK+P8F8ClfHC7omCuejH
         KxtA==
X-Gm-Message-State: APjAAAXa4YlpcaRd1K0/w1SjboNhN+CK2fmiIV47QC0iz7LFo8xHVH88
        5CJJYx2HaZJmL3v7vqhigzg=
X-Google-Smtp-Source: APXvYqzd7ouVVY0Lo26vi94Hhx95/EHDQ4fKuRjCmCZ7QYgHh1MGEj0FPg7SnLBSZwCEPcV+k6cgDA==
X-Received: by 2002:a63:f146:: with SMTP id o6mr36213081pgk.179.1561443318452;
        Mon, 24 Jun 2019 23:15:18 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x23sm18217562pfo.112.2019.06.24.23.15.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 23:15:17 -0700 (PDT)
Date:   Tue, 25 Jun 2019 14:15:07 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     sukumarg1973@gmail.com, karn@ka9q.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: hard-coded limit on unresolved multicast route cache in
 ipv4/ipmr.c causes slow, unreliable creation of multicast routes on busy
 networks
Message-ID: <20190625061507.GG18865@dhcp-12-139.nay.redhat.com>
References: <CADiZnkSy=rFq5xLs6RcgJDihQ1Vwo2WBBY9Fi_5jOHr8XupukQ@mail.gmail.com>
 <20181204065100.GT24677@leo.usersys.redhat.com>
 <CADiZnkTm3UMdZ+ivPXFeTJS+_2ZaiQh7D8wWnsw0BNGfxa0C4w@mail.gmail.com>
 <20181218.215545.1657190540227341803.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218.215545.1657190540227341803.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 18, 2018 at 09:55:45PM -0800, David Miller wrote:
> From: Sukumar Gopalakrishnan <sukumarg1973@gmail.com>
> Date: Wed, 19 Dec 2018 10:57:02 +0530
> 
> > Hi David,
> > 
> >   There are two patch for this issue:
> >    1) Your changes which removes cache_resolve_queue_len
> >     2) Hangbin's changes which make cache_resolve_queue_len configurable.
> > 
> > Which one will be chosen for this issue ?
> 
> I do plan to look into this, sorry for taking so long.
> 
> Right now I am overwhelmed preparing for the next merge window and
> synchronizing with other developers for that.
> 
> Please be patient.

Hi David,

Any progress for this issue?

Thanks
Hangbin
