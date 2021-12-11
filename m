Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45684471486
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 16:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhLKPja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 10:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhLKPja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 10:39:30 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFABAC061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 07:39:29 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id n8so8213522plf.4
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 07:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c/YJ4BIBls82IId9xwLDu/VF19iNv+EErlUQBErY+2k=;
        b=f+OA8J4bDWE0fbzSDfWGO/g5AjnnTKaMT9OLF21XFbQ7+S4y3dL3fu69WJpieLwInd
         V43r1xuH6KeMelXO9yBC3gvDkEzIyVkkTOMvcZhpwQ6T4HOM/Y2hiXm8BrXcFBy97XI5
         4n0rFK+3ry3++8zAwjTS1krecKOUx12tOxm0g2wCK41rIGR3/XbW/NNeqSOzEo7GodZq
         9ltdwWlYijpHXsU7b7evA29lgbz6PM8Ckso6cNePwMd+2ioUsYsmzTPwB6xDQbBlfEtE
         ucf5tud4o6t9jiRj11h5Jt3fKBHKpYSQv5Ws1YG+6Z+QwYOZZql+du+LIQc6XYI4SWYH
         JMRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c/YJ4BIBls82IId9xwLDu/VF19iNv+EErlUQBErY+2k=;
        b=XowSAwiIic9eSragK8hPuHnnyv612mjVo5cJkPVtwmaslDkFwM+Zjoyypb/eRcbZ/q
         6DQRBjHrM3XXhx3TBGppdTFSZS1ubKjeON7NYlirBYKMvOU0wyk7FXGHj+3mdP0HJD4e
         4VWlTJDRufPFXTf88ZnQ8ZzkgyKY5IynECCbJHKBf7uKSZHybFV0zVb1BHNdnQ/NE4Gg
         Dp8lCecGEOeBclOsHa+CeqUu9Exf4ShcrbzuK/boqsr/hAyuWVhmYjl08o8zJUvg8yNp
         6IwXJo4uFUCU979L/H392LcUon4B73I3gNfrDlbQ/9tvpC+7TqpXHOi9d1tBU9gZIaiu
         c2YQ==
X-Gm-Message-State: AOAM532q8yChYi83tMH7m6V3h5F4syyLj8hfcNbZTLo+5I4hxLXvC1NL
        ZmvUAnoiIcngqAigD8DkbH935CIzG1U=
X-Google-Smtp-Source: ABdhPJwB2QKIPMUSXdZ8ISWn8PwOgY2UWClxY4HUknmRrri0V1aJ+UexrGNzdAu0tbnrtukXld/p5w==
X-Received: by 2002:a17:90a:f184:: with SMTP id bv4mr32303432pjb.80.1639237169549;
        Sat, 11 Dec 2021 07:39:29 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id fw21sm2224181pjb.25.2021.12.11.07.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 07:39:29 -0800 (PST)
Date:   Sat, 11 Dec 2021 07:39:26 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
Message-ID: <20211211153926.GA3357@hoboy.vegasvil.org>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com>
 <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 09:14:10PM -0800, Jakub Kicinski wrote:
> On Fri, 10 Dec 2021 01:07:59 +0100 Tobias Waldekranz wrote:
> > Do we know how PTP is supposed to work in relation to things like STP?
> > I.e should you be able to run PTP over a link that is currently in
> > blocking?
> 
> Not sure if I'm missing the real question but IIRC the standard
> calls out that PTP clock distribution tree can be different that
> the STP tree, ergo PTP ignores STP forwarding state.

That is correct.  The PTP will form its own spanning tree, and that
might be different than the STP.  In fact, the Layer2 PTP messages
have special MAC addresses that are supposed to be sent
unconditionally, even over blocked ports.

Thanks,
Richard
