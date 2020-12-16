Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A582C2DC6F2
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387694AbgLPTPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387691AbgLPTPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 14:15:37 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CD6C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:14:57 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ce23so34362078ejb.8
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+KtXo56tjYJwT0EnDTA/0LbVhjoMJwAav4l7UCX10CA=;
        b=aIZPe0yrnhaRalYyLe7GRLU5gbhpG1ihftPj4PkKbqDiDU8LVe7K+GgaM4jP/pnboe
         UY7z2ryxikaO/JK8TWQqMuxhWXfLlDnNi7/qgqIh1CZ3xQIUKj0J/baykPhVzlNDjqSx
         Q+ERvDm+Hqzy0QlKQxsYvUuFcQitA48R7fo9+uIH168SiPArH6YNLSxsqHr+Nxva4wLy
         OO27639j3ku+h0G4zkGJT2dyniemIoJpLNYDnzzN5RlsY9lkxVyn6o8SOTSYUxJFHr2j
         +0dObLabUYxLF8sSHPC0abRVxmO0yvoXkxvBSzR7TITCTa60/c8cgMZCzvmHLbj0Dii7
         mX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+KtXo56tjYJwT0EnDTA/0LbVhjoMJwAav4l7UCX10CA=;
        b=SoADrMGpQFiD+QeWpUHpfHk4w0VvaxkRILmriof4bimwgYRFQdp/YiR/yi4qFZHSMF
         xfIyJ7MzwNly6k7kI46WSOtn3cokaFg5BfML85HBe0VqSb6V1g28Ip5twUWFAsfo5Mvn
         nUqoFuQL3P0y/WKgnfe6J64phfpQ6eM/NQT8E77BtoEzvXW0LtAB9RsBcIXYyp/0+D6x
         fE4Jf5f82r3HLeDLMO4mvA59iWJ4bisPyvFn1JR0VFEHlneaLFYDYtUQHTjVdT9/IQ0J
         hqXM3TYBDSDI0ovCxSCX7hQIuP1Ho3GMiB8nd1HWgAmvsxDIcUkjDxHne/XAr6e/jhaA
         c1TQ==
X-Gm-Message-State: AOAM533eF6/Cn+wlBHqEVzpncbqMjACIn1nAoPMyPlZcEmukBpV5em/q
        fd7xlfv8hr4tGT+rj4NsUeQ=
X-Google-Smtp-Source: ABdhPJxFyw5g6CcWA1P9gbjVpg9b7wlEqop5mn/BlvA56l+GRLH5MIpyDmMRU+uRNt0XPTNqvEdyOg==
X-Received: by 2002:a17:907:2070:: with SMTP id qp16mr31718580ejb.503.1608146095922;
        Wed, 16 Dec 2020 11:14:55 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id k16sm1980115ejd.78.2020.12.16.11.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 11:14:55 -0800 (PST)
Date:   Wed, 16 Dec 2020 21:14:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 5/5] net: dsa: tag_dsa: Support reception of
 packets from LAG devices
Message-ID: <20201216191454.u7boqxlmytjfruh2@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com>
 <20201216160056.27526-6-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216160056.27526-6-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 05:00:56PM +0100, Tobias Waldekranz wrote:
> Packets ingressing on a LAG that egress on the CPU port, which are not
> classified as management, will have a FORWARD tag that does not
> contain the normal source device/port tuple. Instead the trunk bit
> will be set, and the port field holds the LAG id.
> 
> Since the exact source port information is not available in the tag,
> frames are injected directly on the LAG interface and thus do never
> pass through any DSA port interface on ingress.
> 
> Management frames (TO_CPU) are not affected and will pass through the
> DSA port interface as usual.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
