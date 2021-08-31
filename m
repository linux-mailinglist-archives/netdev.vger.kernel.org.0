Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A923FCB62
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 18:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbhHaQU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 12:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239136AbhHaQU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 12:20:26 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6ABFC061575;
        Tue, 31 Aug 2021 09:19:31 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 17so17268860pgp.4;
        Tue, 31 Aug 2021 09:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wKtFFLPlbriGAMxk9vE8E7Hel3Bz+VZdqkGX4LaIKZo=;
        b=DJjxlImbK5bY/hBlQZOfAxHgMznwgb498a5fU4vuIGNEVAoV89x/jypVLZ0THwg8xL
         pkv4K2CNqqa9Nvudz3NR2M0gANhyx9+BHXuyoudKugzeXhojuMJHnFY/PIy4h5Rc4a35
         myjZxH+KP7c+QxhoO4xOlHFwz4HaIU9WxRi42AKeh0KD7QYZmEAtgLoihVYI6SKC2eIF
         qbA6iKbBKWfs65Q2juWBpB5nS6Dyw0hZeeGQkMs+e/8XeHK30WTu55oHkdXMf/0A4HK6
         99eGjSLcwzmVi+38oBqOHwxgAhc4tHsgGTZXNU8orRtAWnDT/N9u0UAS4aoPEhfswSH6
         68pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wKtFFLPlbriGAMxk9vE8E7Hel3Bz+VZdqkGX4LaIKZo=;
        b=hwsv7MK+VI3kMTkftFW4/JM0ofSTdBNVnPYDfa3VBmGuxka1/AKOaPJwxmIvI9AKGT
         RaqVyEWpWdjQb/vnggf7nCBzD18D2N/VlDB2k+FXVDNt8pbT1zbgM6mbKS4amCTkihi7
         E0juMOE/O/fpIQcey+YsvQ3Rd0MvXpouvoz3uKoK/EDcbn+qtHsXUDlPfSdNNOqyPkZp
         5t8eo1QmR3+pm4xYnqVexLAC2VnhRKX6Nk9sEytF5yP+wvuWfjymanfdq9c4NAmf0SEb
         F3xX8nBuJVT0KNmVH0oeBL+NYvmFubuxEhlfTKaaeh3JrgL9rhhdiAGFAR/5IEEsbNl4
         cdfA==
X-Gm-Message-State: AOAM5328k4tFujPqFaXnhA1Z2ZYtGB1qadp/3GnLwNHanG1Wa3lDkEI1
        6BpMvHzt6OaXpnOtvv2bdJM=
X-Google-Smtp-Source: ABdhPJzBpDuzBDRFHhJzk6xqE+MOP5/gu24LM6f1luLCTnLqOi9XIxRbrbuGV5N9lU4MCo7M1Pnu0A==
X-Received: by 2002:a62:8415:0:b0:407:8998:7c84 with SMTP id k21-20020a628415000000b0040789987c84mr673075pfd.71.1630426771124;
        Tue, 31 Aug 2021 09:19:31 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id n24sm20904404pgv.60.2021.08.31.09.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 09:19:30 -0700 (PDT)
Date:   Tue, 31 Aug 2021 09:19:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        bsd@fb.com
Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Message-ID: <20210831161927.GA10747@hoboy.vegasvil.org>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
 <20210829080512.3573627-2-maciej.machnikowski@intel.com>
 <20210829151017.GA6016@hoboy.vegasvil.org>
 <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210830205758.GA26230@hoboy.vegasvil.org>
 <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 04:29:09PM -0700, Jakub Kicinski wrote:
> Hmm, IDK if this really belongs in RTNL. The OCP time card that
> Jonathan works on also wants to report signal lock, and it locks
> to GNSS. It doesn't have any networking functionality whatsoever.
> 
> Can we add a genetlink family for clock info/configuration? From 
> what I understood discussing this with Jonathan it sounded like most
> clocks today have a vendor-specific character device for configuration
> and reading status.
> 
> I'm happy to write the plumbing if this seems like an okay idea 
> but too much work for anyone to commit.

This sounds nice.

As you said later on in this thread, any API we merge now will have to
last.  That is why I'm being so picky here.  We want new APIs to cover
current HW _and_ be reasonable for the future.

I don't see a DPLL as either a PTP Hardware Clock or a Network
Device.  It is a PLL.

The kernel can and should have a way to represent the relationship
between these three different kind of IP block.  We already have a
way to get from PHC to netdev interface.

I understand that Maciej and team want to get support for their card
ASAP.  However, proper kernel/user API takes time.  For example, the
PHC stuff took one year and fourteen revisions.  But it was worth the
wait, because the API has help up pretty well all these years since
the v3.0 kernel.

There is no need to quickly merge some poorly designed interfaces.

Thanks,
Richard

