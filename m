Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25911BB34B
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgD1BQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726303AbgD1BQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 21:16:12 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A199C03C1A8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 18:16:11 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id h11so7664744plr.11
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 18:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qHKeou0d5xfGeND/PcZMaKO3taoOhcSJ0l/N17Anv+U=;
        b=zHVSDiqEIN76GpjkPjjvqud7YuFB3KSh1sGWd3TB8CjF5Wjy0pJIpZ7/Q2AwTTNEfj
         Y12auqxejiCy6S5RzPbXtGJmCS5kt7ec4J/ZQ0rjjDqST4bP4YIdR4HqxUfsLf16ldEc
         Bvx2LnOLxUjQyGD0v4xZu1FifbTdbsciF/+5/pnZ1bzbrFU9g740oksy6R7mS9HltB9q
         CuOrFO+47FmUhIKwgtJRpTU2wkkk/Yuo9d1PZ7RSuNRRstTk5OhKOSNBT6EE1hpcsi/5
         n6GjS/uW+Tu+COIa39l43vzsBGD01SAd/Aa00xcEJttF75R2ps3xODWGfZsMNkrGjwBB
         Hv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qHKeou0d5xfGeND/PcZMaKO3taoOhcSJ0l/N17Anv+U=;
        b=Xjf2vXx8fwwx7jtTCajlED6deAQnKdaRDZe4CMjqCQGggVlNH6J/PIrrAb/XsMHDh+
         TR8WsPoqumCHfJNkAIrWC4PO8U272uZ5Sp9n6zpRk114tx3/gLAJfi7CEogHK1njI5Nn
         z7Nxu66s4skZKtEYyjqz1+AjQjLUzkz6U9DYMowifzLaON9jnSyEgUO+tEM4hPhs9G/q
         Z9bwwTiuzSY3LU61syVHLHQBhB7ZtzY/+Oc1yP+Gqj9Hw81z+88K+8MchG4Dee5vZPSl
         YSMOp71moJWuKX4/s4EqiUoI8nyUxTCHuuYAUYAC5h+GRc+ozceUseJlubl1Mj5pdg/B
         FIEg==
X-Gm-Message-State: AGi0Puaccx1GjHATqdQOf4k1+B8QQdNuCMP+eAPzDh4DeU8O1S4/v9jz
        XadmnLDlRojOPONG46pEl+O9nQ==
X-Google-Smtp-Source: APiQypKu33DikS4E0uQ4N3oJ9uCLiF5WcZM3ZMWGldL5xJoPaCcdCc9bXxDSBvpKx5wRbquAUFSiaQ==
X-Received: by 2002:a17:902:b708:: with SMTP id d8mr15387300pls.69.1588036570728;
        Mon, 27 Apr 2020 18:16:10 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id l1sm8868065pgn.66.2020.04.27.18.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 18:16:10 -0700 (PDT)
Date:   Mon, 27 Apr 2020 18:16:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH iproute2] tc: fq_codel: add drop_batch parameter
Message-ID: <20200427181607.7ca71c9b@hermes.lan>
In-Reply-To: <20200427175155.227178-1-edumazet@google.com>
References: <20200427175155.227178-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 10:51:55 -0700
Eric Dumazet <edumazet@google.com> wrote:

> Commit 9d18562a2278 ("fq_codel: add batch ability to fq_codel_drop()")
> added the new TCA_FQ_CODEL_DROP_BATCH_SIZE parameter, set by default to 64.
> 
> Add to tc command the ability to get/set the drop_batch
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Both patches applied.
