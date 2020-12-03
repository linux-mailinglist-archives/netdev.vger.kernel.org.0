Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03442CD117
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 09:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388270AbgLCIQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 03:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbgLCIQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 03:16:52 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779A0C061A4D
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 00:16:06 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id u18so1426653lfd.9
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 00:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=fDjNv73jm1eQxmunh1Z221n3g9DQVnaTy9ei7bjoXzA=;
        b=jm0dQPkLJqqDGpX8YxtlOw5qFLJaqCjS6wyYeCvnpWvdIoddM7GH+WQZ70SLtwGzw+
         oUKKieqoKKRtTTM7hRS3Nsr3rbn3/YykAov4IwVdfVo+NCvSAKxxWG+tFO27dP6roHBr
         TS/apkDePSQRPW/MjBR7vggU3nexbstSSfVEn+kMOv2astcUPH4kXRf8fELhpG39HDE/
         p91QENJLQeYW1yxorGljwNVmmouaHfxtOsz/g+3toVSatZHeZmJ8dvUQ5cpkLjQ3j/8K
         3R3SGH8SAD8I0JUcaDuqssnwNciG6WdXdL8mOwQsZlfWFxl39kpc4mkEYFljIEGunhuv
         xXvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fDjNv73jm1eQxmunh1Z221n3g9DQVnaTy9ei7bjoXzA=;
        b=FkrfYfP/YlAjf7YQfuMYQXp6fgP0swElsxz10cZP39UZbHF6JvA/I1MTpnS2aUCB/X
         BZP4P3zpF9XctNALxn7RgG4rP7X9H+ECE9YkmK5u/PSfQj4syBeGcNa8I5Rv7IGCQkQZ
         /WcL4i6pd0/vvMBB532OY7jPl4X8/T0UWIx0n5MJSAA3fx+b7lfaHemrEX/7aLc/evrn
         p2X/KKcYh+kz1hA60RL58y9Llp8n2Quf9CKQtlJGgbPAK0Ka7A7eGw+JGzKL2RkUECgi
         2aAoBJHia6kIWvctVXtdKLu679wKsIx7X2m+8+zbvSQaPLS1ICUrW/C9/WYObPlFLAcI
         M9xw==
X-Gm-Message-State: AOAM533PvTiBCOjVsi+dl17eohv0n1YntWyyStafqRJeohUjlr/LI+Sq
        b18+HD+tQCD52Sn90MkA5f15sSYsjaXwYSpk
X-Google-Smtp-Source: ABdhPJxoyzrjbKRTmWApcWx7/rtFcj3Pn4uKMXamACpJ9Bsd+SS1CsCCfgxkiayz0EM+vMrcAx3odQ==
X-Received: by 2002:a05:6512:1102:: with SMTP id l2mr859501lfg.500.1606983364573;
        Thu, 03 Dec 2020 00:16:04 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u24sm244152lfo.194.2020.12.03.00.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 00:16:03 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 1/4] net: bonding: Notify ports about their initial state
In-Reply-To: <459.1606955954@famine>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-2-tobias@waldekranz.com> <17902.1606936179@famine> <87h7p37u4t.fsf@waldekranz.com> <459.1606955954@famine>
Date:   Thu, 03 Dec 2020 09:16:03 +0100
Message-ID: <87czzr71a4.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 16:39, Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
> Tobias Waldekranz <tobias@waldekranz.com> wrote:
>>I could look at hoisting up the linking op before the first
>>notification. My main concern is that this is a new subsystem to me, so
>>I am not sure how to determine the adequate test coverage for a change
>>like this.
>>
>>Another option would be to drop this change from this series and do it
>>separately. It would be nice to have both team and bond working though.
>>
>>Not sure why I am the first to run into this. Presumably the mlxsw LAG
>>offloading would be affected in the same way. Maybe their main use-case
>>is LACP.
>
> 	I'm not sure about mlxsw specifically, but in the configurations
> I see, LACP is by far the most commonly used mode, with active-backup a
> distant second.  I can't recall the last time I saw a production
> environment using balance-xor.

Makes sense. We (Westermo) have a few customers using static LAGs, so it
does happen. That said, LACP is way more common for us as well.

> 	I think that in the perfect world there should be exactly one
> such notification, and occurring in the proper sequence.  A quick look
> at the kernel consumers of the NETDEV_CHANGELOWERSTATE event (mlx5,
> mlxsw, and nfp, looks like) suggests that those shouldn't have an issue.
>
> 	In user space, however, there are daemons that watch the events,
> and may rely on the current ordering.  Some poking around reveals odd
> bugs in user space when events are rearranged, so I think the prudent
> thing is to not mess with what's there now, and just add the one event
> here (i.e., apply your patch as-is).

This is exactly the sort of thing I was worried about. Thank you so much
for testing it!
