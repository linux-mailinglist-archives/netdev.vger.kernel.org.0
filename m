Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845A93ABD17
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhFQTtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:49:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60931 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbhFQTtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 15:49:19 -0400
Received: from mail-oo1-f70.google.com ([209.85.161.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <seth.forshee@canonical.com>)
        id 1ltxxw-0008TO-2W
        for netdev@vger.kernel.org; Thu, 17 Jun 2021 19:47:08 +0000
Received: by mail-oo1-f70.google.com with SMTP id n62-20020a4a53410000b0290246a4799849so4546038oob.8
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 12:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=bs/gsnaGt8DZvKt+QmmiZ2Y19wSylDXIdnNyHPHUNxU=;
        b=QBMdNoV9m7fZC08z7OavQwZ0nwM/wzXbcPjoS63EH2zAl4+xg6U2bx/ZOTOI1JEJb/
         2eqdS+QOzu/fQy/Z2PDh2uUSa0gxedlRU/nIQhwy3U8fDkuGQ3E3J2kYTw4OLf/stW/q
         SAPzHRoZwDw/VugQMRp8/Jz6vWtGuEA/PGEOvX8sF1RDvqRbC/ZEHi3her0cdn6xvuup
         i/5MYr3o1ZYEy9eaPD18Ntt2YQvSe/zHQOcYtA1WJWpzMqS42bGjdBST0w2SL2jI1ilP
         oOwPe2eU24wSYa6xRQ9ZFC+bFS6Mlo8mmtcqktWfbDNZQs5NmuG//DuQlqug3OFH2342
         DCcQ==
X-Gm-Message-State: AOAM5330fMO1RYZDaYuEIvxVTZ42mrRiW0wDoa31y0sQZjxqbXOnKF36
        hRGYuFYDBu0mw1bii59+dkrGZqvewX8c3BJtqB1pUlmzOe8FIatxQ3XX10nmu4mn3tjsRtO0CIo
        a4G1vHgBDBLJc4IDnP7NpUdpr9KTu5Gi9Kw==
X-Received: by 2002:a05:6808:605:: with SMTP id y5mr8933276oih.74.1623959175075;
        Thu, 17 Jun 2021 12:46:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiP21iWn4El3hnU5S9Mst1ROIZ+laQzMC834FbKNoOdkpYiJ4mIeEMESS702mUxAG9SAtLDA==
X-Received: by 2002:a05:6808:605:: with SMTP id y5mr8933259oih.74.1623959174737;
        Thu, 17 Jun 2021 12:46:14 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:1522:24c0:88d7:e850])
        by smtp.gmail.com with ESMTPSA id v1sm1530726ota.22.2021.06.17.12.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 12:46:12 -0700 (PDT)
Date:   Thu, 17 Jun 2021 14:46:11 -0500
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Pooja Trivedi <pooja.trivedi@stackpath.com>,
        Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>,
        Josh Tway <josh.tway@stackpath.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Hangs during tls multi_chunk_sendfile selftest
Message-ID: <YMumgy19CXCk5rZD@ubuntu-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've observed that the tls multi_chunk_sendfile selftest hangs during
recv() and ultimately times out, and it seems to have done so even when
the test was first introduced. Reading through the commit message when
it was added (0e6fbe39bdf7 "net/tls(TLS_SW): Add selftest for 'chunked'
sendfile test") I get the impression that the test is meant to
demonstrate a problem with ktls, but there's no indication that the
problem has been fixed.

Am I right that the expectation is that this test will fail? If that's
the case, shouldn't this test be removed until the problem is fixed?

Thanks,
Seth
