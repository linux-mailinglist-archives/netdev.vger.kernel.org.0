Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D033F220FD0
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 16:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgGOOsR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Jul 2020 10:48:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49727 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729693AbgGOOsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 10:48:13 -0400
Received: from mail-pl1-f199.google.com ([209.85.214.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jvihf-0001zc-7D
        for netdev@vger.kernel.org; Wed, 15 Jul 2020 14:48:11 +0000
Received: by mail-pl1-f199.google.com with SMTP id f2so2512720plt.2
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 07:48:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=LCvS2Mg+NMZP1rAlw+7qixFYYr8UXQD9EiMJwb616iQ=;
        b=sYlDtdQklu6DtG3+LNdemPMBQS4ChdgRztG6bejulZgvKHDVj3bCSkpkYruDGXJc54
         xijYr5yjyUgXjMJ1t0h8P6dtAHP3re44ORXHvr06EJ/dDMncifRgvDG4IUPnhzcxT03R
         RXGL1ZNS/UnUPpSmowY0rVJXnMQeLphq+/BCBwvNiAthW8wJIcXA6X84Op+s9HM8jRrM
         VluJiahjKCWMn7NiIIyWR5EmIDSKQPWIubGmp2nO6qbcc1ruKTx6O8j0BAj4ROOTl1K0
         oKCBoY7HWrY3xX7EkTcXTI5Uw/I3yxgy3mrZ5GZBV/C6TTM43UIgFIDxhl7NxsseXg40
         wVhg==
X-Gm-Message-State: AOAM531y8nFo6kGUy/Rg0kVhDBYmtXW+Is5fjSjNifuYmFSDyGmwqjGy
        QJrvffxRoe8uhByXp79FQT8iNQny4FfNHd9G/nWz/sWdcs1bhBFBEKABxYq5l/kGiGtNFKORJ/x
        VkYUZm/eZAiiLwdtsSL1M7RFUfpgbVoaulw==
X-Received: by 2002:a17:90a:c68e:: with SMTP id n14mr10261827pjt.182.1594824489582;
        Wed, 15 Jul 2020 07:48:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKrlh1HvbeAaJgRiC//V1igGnVxmU5HjSc1N2Q+BfJgRLVgPaPWhuIYiLFaQfZuLdvy30qlg==
X-Received: by 2002:a17:90a:c68e:: with SMTP id n14mr10261800pjt.182.1594824489274;
        Wed, 15 Jul 2020 07:48:09 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id f72sm2391275pfa.66.2020.07.15.07.48.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2020 07:48:08 -0700 (PDT)
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()" breaks
 NFS Kerberos on upstream stable 5.4.y
Message-Id: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
Date:   Wed, 15 Jul 2020 22:48:06 +0800
Cc:     matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>, linux-nfs@vger.kernel.org,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
To:     chuck.lever@oracle.com
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Multiple users reported NFS causes NULL pointer dereference [1] on Ubuntu, due to commit "SUNRPC: Add "@len" parameter to gss_unwrap()" and commit "SUNRPC: Fix GSS privacy computation of auth->au_ralign".

The same issue happens on upstream stable 5.4.y branch.
The mainline kernel doesn't have this issue though.

Should we revert them? Or is there any missing commits need to be backported to v5.4?

[1] https://bugs.launchpad.net/bugs/1886277

Kai-Heng
