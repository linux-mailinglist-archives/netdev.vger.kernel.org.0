Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AE1BEA0E
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 03:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388586AbfIZBXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 21:23:53 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40503 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbfIZBXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 21:23:52 -0400
Received: by mail-pl1-f193.google.com with SMTP id d22so514821pll.7
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 18:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=22PGlG1vlAQyFCiQebzwvuuzTz1/kfVMRIZpfQyyRLo=;
        b=zgig/tf5Sz63yHXZf5ykSXhEvaJExJ8pTMIiFFPmAJSIeFQGcrAt4VlvMXucQ0d+Y2
         ISX1JfSdCrX9xp9kGJg9HeL7lEP1qZMzc0o0xVd/Fc18a1p5Ei2FkN2mdV615Wv+MlzQ
         dDJ/0b2kTmM+581Ld3pvAhGYzggVaLsuV19R3M6mwju9byc5+Der28Y5XEnd6TWCJ83M
         x0IcLhy4OSf9S8AMiTS8ZVW4ZfSiqC2B74p54qyvTAef4D6L3enZi+iOwj82niZ7IhFc
         fVen3QoId07DeV4lfNeiuf4t+68kb+cStWH/wc0bkgGI7n58v3vfQ6TU4Xh+eM9yecI0
         JOaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=22PGlG1vlAQyFCiQebzwvuuzTz1/kfVMRIZpfQyyRLo=;
        b=siZEfwYeya9UJLSJnPBme2odBVmfgnyhSxf8dFb+advim8MIDlKGaSITFPK8mCFGZl
         MQ+UIBPhP6IQvqOCoKLAYHqGoxGwEMiPlHWzpURyRx/uGBY16dO9a1D1u+CZi4gRKT80
         4BLHLF1Q4Z44R3EOa0ybx//r9HEr0dyIQMXrpcqAUgxIULSuip43JoGzpuFDCWvCujG7
         K1Ve8jC9iB9IeLWR7xy9VJnqX0n7T0sFImyvsLl64deW2iu+qcqz02VpKNvD8ipt4fEd
         0CGhQoYQf7IcBpCLHJ1spk6KaX4ymFgzlkl4ZFYBbiQz4qOPLPbelmVQwmhcyqHdABjp
         i85Q==
X-Gm-Message-State: APjAAAVyC677S3LuStkNzEHu+WSy/Jmfl3qKLsM375tZtOL2sgrb24hJ
        cU6bYtSQCYA05iJRPwEb6HFVgg==
X-Google-Smtp-Source: APXvYqya/AneO2Xl0WxjU095xtUeWcGemRWOch75ciyEJ/c2Oz7gBUbQVVPb8WHw1/sCgztUiTVHzw==
X-Received: by 2002:a17:902:8d8e:: with SMTP id v14mr1077815plo.287.1569461030065;
        Wed, 25 Sep 2019 18:23:50 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id t3sm308272pje.7.2019.09.25.18.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 18:23:49 -0700 (PDT)
Date:   Wed, 25 Sep 2019 18:23:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Fred Lotter <frederik.lotter@netronome.com>,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: flower: prevent memory leak in
 nfp_flower_spawn_phy_reprs
Message-ID: <20190925182347.5a509f47@cakuba.netronome.com>
In-Reply-To: <20190925182405.31287-1-navid.emamdoost@gmail.com>
References: <20190925182405.31287-1-navid.emamdoost@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Sep 2019 13:24:02 -0500, Navid Emamdoost wrote:
> In nfp_flower_spawn_phy_reprs, in the for loop over eth_tbl if any of
> intermediate allocations or initializations fail memory is leaked.
> requiered releases are added.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Fixes: b94524529741 ("nfp: flower: add per repr private data for LAG offload")

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
