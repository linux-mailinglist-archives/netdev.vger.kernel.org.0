Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A6E2CA3E3
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 14:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391135AbgLANaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 08:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387677AbgLANaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 08:30:17 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C5FC0613D4
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 05:29:37 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id f23so4072300ejt.8
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 05:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jvsd2dZu7N5hadr8PL2isg2S0lQjRswgu8EieZqQVy8=;
        b=s8TXRdEiYOEpECZ8PLv0n/k4IeNYk0m9DCodlmuvRfE+W4tzwkGfRltKIuktvDNPFX
         fC1RBh80ItqGw0RG3v/nKSKzSwlP+rLq9r5+g9Ye9bmxYLWPSY7HRlwjG2cLUQyfRAyD
         KVwuuidOgHNDhG2tjIa65qboySSxK0h8/12bLe2QDMdAoFCONYYOsLQScyIiTVsm7Df6
         ocYPy566XQpyG9D8Ql1d3LJQBBja7zHrLQAAoX9lmZFEwl702ycWjkbSU6g0gMlcugyW
         OSfHlt0gdhQoUJkO9M6mveUCAhQ4hPk/ZJYPwUvriJvHXLgQCPEE1/oCDmd5fjX111Ws
         KU7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jvsd2dZu7N5hadr8PL2isg2S0lQjRswgu8EieZqQVy8=;
        b=lhDp1TSw70ikdHjZRf2lbczFvD2c06eaKf2Iw+fgnd9yUMsEAl+/aBqT49OIg34ksc
         S5yV8/IgEP8JI55xKLSrwZd2SlMXXhkO02h7fTWh2HWArvy7MYTUNrr9BILjpIZIRQla
         +cGVWPHIkIWUCPtVtWmoiWHb5jDqZQLcq9y0A/I/4cmo1SRJLUmUu4RT3X/ob8wgQD6o
         2+H96Km+c2JuEjWfEm76HqGeaZdSSgVxo+lngjXPYwC6jXK4hFKmRnyYvM6ZOoyhEszx
         FIc4WAl6PiwaDvhzO6Y0hWl3mwy9E7c0sr1EoPzaUlhoQiZd45bvw0134a15PorExjPH
         ucOQ==
X-Gm-Message-State: AOAM530L/mjLNuVkOel/ZEem7cb1ay3v9kthXLYvl6ce0LqL7il/mJqy
        NWPS4faJeirzhL6UDv2pSTE=
X-Google-Smtp-Source: ABdhPJz6Ew2rs8tVpfeW5pR9TTU5DbJVM9t8lQ0tKl1FSNa1YMx8KGTCkfDzn/vyBQRVjgyxCww0sw==
X-Received: by 2002:a17:906:68c4:: with SMTP id y4mr3113109ejr.332.1606829375776;
        Tue, 01 Dec 2020 05:29:35 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id d14sm855541edu.63.2020.12.01.05.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 05:29:35 -0800 (PST)
Date:   Tue, 1 Dec 2020 15:29:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201201132933.paof42x5del3yc2f@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com>
 <20201130140610.4018-3-tobias@waldekranz.com>
 <20201201013706.6clgrx2tnapywgxf@skbuf>
 <87czzu7xkq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czzu7xkq.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 09:13:57AM +0100, Tobias Waldekranz wrote:
> I completely agree with your analysis. I will remove all the RCU
> primitives in v3. Thank you.

I expect that this also gives us a simple refcount_t instead of the
struct kref?
