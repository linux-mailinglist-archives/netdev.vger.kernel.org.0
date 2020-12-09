Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233D22D4EA6
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388565AbgLIXSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728541AbgLIXSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 18:18:11 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0E2C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 15:17:30 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id v22so3469384edt.9
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 15:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o0XSUcoiFGlbsZeboFfJcSc9E3RKTyUwFCZCpFoZerI=;
        b=ph7PpMLiVpTxiV8oJo0TdajrrWR6x5F+YyFqKDa7c+80VYB94Ppj/EF7vqr/1d5tzL
         tJw7YLBG0ULHVfRSX6ebMcUgjQjEVNs9prSxRtUcVbuzgRAPaWOPcrsqTHkUds+Qu0to
         CUgcRUrc6nKFrndErIDEwgYhRIL1IooBlKJyiR6ERHKSP1F2ImDQbDLBC0X9G5JYpojU
         SG99Mz50Bl2EbI2Jphy0ewpZGw0g6BoXzbSuFXF2YTNdu0AEMsv6O5Mz3IKFFk3dTGeQ
         xeiuAD3SmvlNBCbVgLWbdBkRC+7NVw7NKJLfUsEAupzvsza0Vx535Yop0kH+go8TsZZ5
         Pupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o0XSUcoiFGlbsZeboFfJcSc9E3RKTyUwFCZCpFoZerI=;
        b=DBlVTUsHrx8ZzRmdoOiIyPVnKdU9i2LtOI02xmZLvECwWg5nXtb2vblDGhO7NXxXn4
         w9PngrbmUo+OTlZPqF3yCZw1K66Or9bs+D6nm1kyIHpGWy0h26L9ngzZQWC2q88zP9bP
         xWLhTCM415WPfZumCMrStnav69/35Z3zWyXYUzLrxU/HGcdR8xOLnF4cm7qhGSQbI3MU
         fVUikCQNKMq/nyPoW1NOnQ1KnR1SoFbWl3mltPlhp/oxEMhX0dI3vLUKuB9p7mZC1lSq
         5mAuGo9a7+Ea5bEYOBnDk+CH7lRf454wNyMMNIHZecMLIQG1+7OrSgjz6hvCZb7GNTsh
         CtEA==
X-Gm-Message-State: AOAM531BxV9zq2hwwS5i499wMWZX1lxJqrfVIjZf6IIa4eq3WpfaBfLF
        VG+wYZu9Aqu6Qknb5IdpdQU=
X-Google-Smtp-Source: ABdhPJwfuqW1FIeVfTbtR25SeB94MxQrw09gKt3uPZeujX1J/WrD6K+gIu2QtSbUycMlBtXla9zVQA==
X-Received: by 2002:a05:6402:143a:: with SMTP id c26mr3994368edx.131.1607555849597;
        Wed, 09 Dec 2020 15:17:29 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id bo20sm3105938edb.1.2020.12.09.15.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 15:17:29 -0800 (PST)
Date:   Thu, 10 Dec 2020 01:17:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201209231727.rtx56oslwaondyer@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
 <87mtyo5n40.fsf@waldekranz.com>
 <20201208163751.4c73gkdmy4byv3rp@skbuf>
 <87k0tr5q98.fsf@waldekranz.com>
 <20201209105326.boulnhj5hoaooppz@skbuf>
 <20201209142340.GE2611606@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209142340.GE2611606@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 03:23:40PM +0100, Andrew Lunn wrote:
> On Wed, Dec 09, 2020 at 12:53:26PM +0200, Vladimir Oltean wrote:
> > On Wed, Dec 09, 2020 at 09:37:39AM +0100, Tobias Waldekranz wrote:
> > > I will remove `struct dsa_lag` in v4.
> >
> > Ok, thanks.
> > It would be nice if you could also make .port_lag_leave return an int code.
>
> I've not looked at the code, but how can it fail, other than something
> probably fatal with communication with the hardware. And what should
> the rest of the stack do? Recreate what is just destroyed? And does
> that really work?

What can fail is memory allocation, which other drivers might need to do
when they rebalance the remaining ports in the LAG.
