Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498FA1B33F6
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 02:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgDVA3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 20:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgDVA3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 20:29:40 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7EBC0610D5;
        Tue, 21 Apr 2020 17:29:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id s9so508692eju.1;
        Tue, 21 Apr 2020 17:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=rO0w5gDPjA7Di4DEnXW21M0BN8vGySQ7BavhtWpb4aI=;
        b=Ar4qoLHsVjygj/AZzcdesVckef3gGyVpLWvpQjGGGhdEl4GxuX8/GqVgmx3+0y6Yle
         W93O9+1aDGws6MbB0PG8GvKNL5Vqjc/ReY79QToenRjQUcKLw7L6Cu63I1TI1WO43bbI
         OTzjV5kPdpqjtiUwrqoX8LT2vA/kox2aOF9ogkzLrb+qiEBZkMk61YZgvjn11EvM2wpw
         MJOyoFH73Sv7oyzniFoxWuphjOKV0ylSCcFLYR8SN+BQf+7VhEaBkJnIF8jFxPELFLvK
         FS2/ATNe1x6j42Ynei0xxbF+XMH8Ol9ayiZrkAyK0OPmwyRM7Bw3hr6YhLQi2FvD4u0a
         gFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=rO0w5gDPjA7Di4DEnXW21M0BN8vGySQ7BavhtWpb4aI=;
        b=X2ft7BQIc+hUG2ACmBUCMzc1XOc/Fj6UdPcFNSQsmifjUx496jCRTMDnvrHxVN922u
         Utu6GgQkpznM4Mnpp/wu8KE5rbtX70EXTJVS1BsEvxRTc2pwBcAgT7Zyw4C6G4N6tzJK
         keNozQ83gTtSd6NkMJK5zo+4a65BD+UvOaEyc+lSFGv+VPxYBbbK3M+Ku43H+fYd6ujn
         fMPC8Nw02Qh9JMbxEI/+WD+fPa/B+1RmkMbvBdFzruQCnSoax7aSMhJgInIbbSI166Vg
         ORi5Lql/dFtSp8bWsIvhG4B5bWt63JnTO0EwHralMk2MC0VVn2qx7YqFLoYBswrbL6z+
         pm7A==
X-Gm-Message-State: AGi0PuZ8NKocx45a9tjvAB4xcwqsNyNcDB9m/WRWrulSN/rNasQHB5ZE
        IhL7xzffKw4kIDBmTKuZhf/y+ZgYn/VH4ShAyUwYFkft
X-Google-Smtp-Source: APiQypKpFh0SuFktFFKa4v7aZo3TvtlKswa6pyWUf+0w5RB/snw0giBc5drN8AHPopivqyDXfK2TWSHKNE2pipMvEI4=
X-Received: by 2002:a17:906:6441:: with SMTP id l1mr10792113ejn.148.1587515376516;
 Tue, 21 Apr 2020 17:29:36 -0700 (PDT)
MIME-Version: 1.0
From:   Joshua Abraham <j.abraham1776@gmail.com>
Date:   Tue, 21 Apr 2020 20:29:25 -0400
Message-ID: <CAMmOe3Q2cc_uzpKezojkNWFSdg+Pt+K6BqcijV46QRj5ZXod7g@mail.gmail.com>
Subject: [RFC] unixmon virtual device for unix sockets
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is currently no way to capture a connected unix domain socket
without interrupting the connection. AF_UNIX socket transport is
implemented in-kernel and enabling packet captures would require
kernel support. This could be based on the design of the vsockmon and
nlmon virtual devices.

This would be very useful when debugging traffic traversing AF_UNIX
sockets, such as DBUS traffic without modifying the user-space
programs that are using the unix sockets.

Is this a worthwhile feature to implement?

-Josh
