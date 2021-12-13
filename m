Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0F14732A4
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 18:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhLMRE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 12:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbhLMRE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 12:04:29 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5EFC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 09:04:29 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 133so15081235pgc.12
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 09:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=glnFxro+HtMg2RT0ENCrcEiTTNxarBUgWHnM1XJpftI=;
        b=hQyelgxkLnEIlc7Ev/p9RbS1HnG2w6L1QYkU69x0NNrFT+jn+/88blZfGdgbY3b4b0
         PGntHLJeBAIYYcMmLqL9KcD21GstKLcgOo8FpR/GzH7fMsA+PEP+IsVGoLlA+0i35A2o
         JHTdoO8s34KCT/kMJYBUko7nX7aPWXmLloPkiVWWrDy/OKxxY/yELsiRZgI12k57VVJI
         doxzi7FCbonV4p4gH6dKMf5vRf+ayPc5oLgsGNNg7rg/DhDdCurmKsJa/hOhH36u09wL
         BujdSUF4giYjTExNnAsRsPGpJN3J+7//48aoZLUr2TeRabXRRZUuDnbzzaO73Xu9IpfP
         FGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=glnFxro+HtMg2RT0ENCrcEiTTNxarBUgWHnM1XJpftI=;
        b=ZhHVwfTfwaI9R96lkcQOIVNGbKmDv+3U3z8ZAsRMg/m5yHFLFd76TKdnrmuvz6E+bz
         S9wAfHTNLt+7GjVhwrn4TzHsZbq6pfDDlqg6j+iLLBDxvILTTNyaE8vzGlS49YTxR8S9
         ODkp8JeR3G/wgXuB/tnZrWqJPVLbBACS/ZV3d9n8geZWnuHWX004QjaF9Ger7vV8BKTd
         ea7kgnaPzz2abEJY4C6tmxkdemCToQUxuvbCwXF/PiAUPsOBQJ5XimKUgcalOzc0cxsD
         gN8jBgDdT9NkOxrsnWsmuGieKu/DuOiOXWDzJcS86yQ9bhlo+HMTZsmHl3GTjDUfCaFf
         c10A==
X-Gm-Message-State: AOAM533BnsnzEU7b3CA4baAs3VljLNY4xXNV/bZxbwbpOJ9tqftuY6kF
        F+8KXnxjpIN5TIRSPxDp8KE=
X-Google-Smtp-Source: ABdhPJys8LJmf5uJgDeSP/UhDPzQJ1KtrSU+sJXEBIoaO9mzRatBd4qv3bpYNvUJkIOeRx++jxjgrg==
X-Received: by 2002:a65:5808:: with SMTP id g8mr2341870pgr.91.1639415068874;
        Mon, 13 Dec 2021 09:04:28 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s8sm12397076pfe.196.2021.12.13.09.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 09:04:28 -0800 (PST)
Date:   Mon, 13 Dec 2021 09:04:25 -0800
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
Message-ID: <20211213170425.GA14706@hoboy.vegasvil.org>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com>
 <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211211153926.GA3357@hoboy.vegasvil.org>
 <20211213121045.GA14042@hoboy.vegasvil.org>
 <20211213084425.65951354@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213084425.65951354@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 08:44:25AM -0800, Jakub Kicinski wrote:
> Indeed, looks like a v1 vs v2 change :S

FWIW, the peer delay mechanism was new in 1588v2.

Thanks,
Richard
