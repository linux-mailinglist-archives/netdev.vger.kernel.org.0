Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A041301831
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbhAWUGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbhAWUAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:12 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7B3C0613D6
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:31 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id i17so10581667ljn.1
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XtgbP7li4dVzH9zE6pO872tXRktKXn7z1UT7dldD108=;
        b=Meu02Xb4HQjnjuWhdRf25xVWvfjY5VyhTQMbzINLqqafoWZ8z9A4dyI9QMtijHssov
         1oaltChdXv9+M42etUePpkhbLnT5hcUn0jBGpHABxCV2KYmgLrXyiyQVR6Qr160117N+
         3nycqroudyxXq/C6bQ1GD4JxmrTQAVpocrkNKhjxny65nUr59mjb0T9Cf3nuD4K91ZMK
         G5nXsL3DR9QyC+Au/qO1E1+CCmIjAhxAWrNW4gAIM9kiw0eH9s7eyg9cJa6zrjMNX0CD
         s4PPSF0J5/RahzcCLf2lLMQ6Fsb289JWME8Iyh8s44wO0BvHMdvzS0Htg6EzspfxP5vy
         llYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XtgbP7li4dVzH9zE6pO872tXRktKXn7z1UT7dldD108=;
        b=fdcvYqldXlAQnAy2b1xFDkBcB99GNVvoUqxzhWqKMgrLKXsAllQ8AGHPDhSv+ZxSdZ
         kPF81V//P479y0tilAJV1neSn5aAs8Zin61XcixkqPVE61bI2P4cZrqwOSq4NWRz8uOx
         fQ4G/yEVGayU8ykw9Hl3Xq8gr7AxNN2aPEgOoUzcyr8rOetPuVLDnq4XAbEWW8WnTU+i
         lk/M1Kn3VgMwseBkNYQ6e7Ji5qWWc0PQHk/spVVe/ac0hpcP+joPTrWtqyPNetH+uH1W
         dJ+wprDjbhUSWcMCB5UGJGAASBlUXVeol2gLfAOor1ovQushTZ5caHdrTukcQmuJfvkQ
         og2A==
X-Gm-Message-State: AOAM533duE4/Kz58FFjw9HB1uNbB7DcHrhdXVb5/RNqDZHag4rMdn0Tv
        iBE869qtGoO/Ok4a50FUNKMgyL+zJydgVQ==
X-Google-Smtp-Source: ABdhPJzpN9BynHeMj2pX5u3yQfCtT/yFp4KrT0meS8NhWMGpSM6P6244WTNyAEYLLjLIk/kzCB6Mcw==
X-Received: by 2002:a2e:914d:: with SMTP id q13mr114248ljg.205.1611431970285;
        Sat, 23 Jan 2021 11:59:30 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:29 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 00/16] GTP: flow based 
Date:   Sat, 23 Jan 2021 20:59:00 +0100
Message-Id: <20210123195916.2765481-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series begins by reverting the recently added patch adding support
for GTP with lightweight tunnels.  That patch was added without getting
any ACK from the maintainers and has several issues, as discussed on the
mailing list.

In order to try to make this as painless as possible, I have reworked
Pravin's patch into a series that is, hopefully, a bit more reviewable.
That series is rebased onto a series of other changes that constitute
cleanup work necessary for on-going work to IPv6 support into the
driver.  The IPv6 work should be rebaseable onto top of this series
later on.

I did try to do this other way around:  rebasing the IPv6 series on top
of Pravin's patch.  Given that Pravin's patch contained about 200 lines
of superfluous changes that would have had to be reverted in the process
of realigning the patch series, things got ugly pretty quickly.  The end
result would not have been pretty.

So the result of this is that Pravin's patch is now mostly still in
place.  I've reworked some small bits in order to simplify things.  My
expectation is that Pravin will review and test his bits here.  In
particular, the patch adding GTP control headers needs a bit of
explanation.

This is still an RFC only because I'm not quite convinced that I'm done
with this.  I do want to get this onto the list quickly, though, since
this has implications for the next merge window.  So let's see if we can
sort this out to everyone's satisfaction.

/Jonas

Jonas Bonn (13):
  Revert "GTP: add support for flow based tunneling API"
  gtp: set initial MTU
  gtp: include role in link info
  gtp: really check namespaces before xmit
  gtp: drop unnecessary call to skb_dst_drop
  gtp: set device type
  gtp: rework IPv4 functionality
  gtp: set dev features to enable GSO
  gtp: support GRO
  gtp: refactor check_ms back into version specific handlers
  gtp: drop duplicated assignment
  gtp: update rx_length_errors for abnormally short packets
  gtp: set skb protocol after pulling headers

Pravin B Shelar (3):
  gtp: add support for flow based tunneling
  gtp: add ability to send GTP controls headers
  gtp: add netlink support for setting up flow based tunnels

 drivers/net/gtp.c | 609 +++++++++++++++++++++++++++++-----------------
 1 file changed, 380 insertions(+), 229 deletions(-)

-- 
2.27.0

