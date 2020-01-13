Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3D3138BE2
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 07:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387640AbgAMGjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 01:39:11 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51272 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387629AbgAMGjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 01:39:11 -0500
Received: by mail-pj1-f65.google.com with SMTP id d15so2367213pjw.1
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 22:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9klpFywBzPqXOs8CMzpkKC/1tup7Z9SVMVHLBvtd4e0=;
        b=V1K/CY1q3ptqOOSS5kPwKdQcoEgjHk6RC6j5R34tNX+WeWvxPVLCD7g0pR4ujtxw7p
         XDS9emjMDTmEqKeF1re0vVkmx+azwWwpmcvCBALquP1ApTGa3mZVp2diY+jbVERkplhN
         KM7k57w7GjGM+c5zwEIU6fnGjnIY4y6oecUql1aU1eX/SqodO/aaTQsr2k7T8jI/zClh
         Kd2zmWrJomSISRFt9nQRDyQudgS4Xi+h1BX38RAIMc6ZgnbPMO9ozV0riMNuUVKJ0VxW
         Y6sSrR9OQ8dms6BHrzwEJo0PyMX2NnpwHJCHaDfKrETDs7BtL6fYyxTHq9/JPYWz8HnE
         PCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9klpFywBzPqXOs8CMzpkKC/1tup7Z9SVMVHLBvtd4e0=;
        b=H6YE2oaNpgIeXTEIIfZN0ZcPDgJj6U/wo6gO5Mpsbe/usou/qS1jlVkErwehngOleP
         KDaRdokP9hLXpN2tJf5+FrNRkOv5Acha6kZPnNEMVR2J922+1e9DJk2hNn7sjbN2EHWF
         TTPnD8Mi9JvlUzz0e1j1/hWsH1al1c+aSRzP5Fj+8Pao/E69KHG+7mlcNl8ahYwBBU8o
         zGby0wTNGuAHduPyoW0uG0IbW4eyph/0IcQtrBRVjYqkn6j/KkSnte1wv5QElmNo/hrR
         cthSuGNmM2ZcuHwJtOc76UArZdvnzVAIEZl4pGwiuetqWX2GoBJDpQioJbPpNF0EIjRC
         ln8w==
X-Gm-Message-State: APjAAAWUU6As3uLOPcycmC4Pp1aZLtZAWtFaAx5yxP5snbTSiHk4dgzb
        nvhfukQdfcTfmnyVVxSlJ2w=
X-Google-Smtp-Source: APXvYqw9isLhzNlDSXDfLZ8OM19U+n/4lYts+3JXA0u0u3M/nnFoqmRhZirFMP+g9WuZnT+1bBQ0og==
X-Received: by 2002:a17:902:5995:: with SMTP id p21mr12513051pli.33.1578897550610;
        Sun, 12 Jan 2020 22:39:10 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k1sm12082356pgk.90.2020.01.12.22.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 22:39:10 -0800 (PST)
Date:   Mon, 13 Jan 2020 14:39:00 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net/route: remove ip route rtm_src_len, rtm_dst_len
 valid check
Message-ID: <20200113063900.GI2159@dhcp-12-139.nay.redhat.com>
References: <20200110082456.7288-1-liuhangbin@gmail.com>
 <49a723db-1698-761d-7c20-49797ed87cd1@gmail.com>
 <20200111011835.GG2159@dhcp-12-139.nay.redhat.com>
 <c9369e95-4578-7d11-1dd4-ca8e45a70ef0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9369e95-4578-7d11-1dd4-ca8e45a70ef0@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 10:38:23AM -0700, David Ahern wrote:
> On 1/10/20 6:18 PM, Hangbin Liu wrote:
> > On Fri, Jan 10, 2020 at 02:48:03PM -0700, David Ahern wrote:
> >> On 1/10/20 1:24 AM, Hangbin Liu wrote:
> >>> In patch set e266afa9c7af ("Merge branch
> >>> 'net-use-strict-checks-in-doit-handlers'") we added a check for
> >>> rtm_src_len, rtm_dst_len, which will cause cmds like
> >>> "ip route get 192.0.2.0/24" failed.
> >>
> >> kernel does not handle route gets for a range. Any output is specific to
> >> the prefix (192.0.2.0 in your example) so it seems to me the /24 request
> >> should fail.
> >>
> > 
> > OK, so we should check all the range field if NETLINK_F_STRICT_CHK supplied,
> > like the following patch, right?
> 
> a dst_len / src_len of 32 (or 128 for v6) is ok. It still means only the
> prefix is used for the route get. That's why it was coded this way as
> part of the change for stricter checking.
> 

Ah, I see now. Thanks for the interpretation.

Regards
Hangbin
