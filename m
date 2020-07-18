Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66AE224832
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 05:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgGRDFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 23:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgGRDFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 23:05:44 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53146C0619D2;
        Fri, 17 Jul 2020 20:05:44 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p3so7565027pgh.3;
        Fri, 17 Jul 2020 20:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1wY0lal+lBgSmtXPjk/0h/AXiG5Km+JSOehkqiKj28I=;
        b=aL9xO1U5+1oyS5EnVLEdspMbDxMd+nLGaK6RVt2ZFIpZ5qGzllCK6p77x05aefD5Cp
         XHATfOVMIMjq6tuKT6aHzlMZPAo6bnu0lACoyO/Iinn7b1N+HiAsAcOe/TWFDPX6z0kE
         FwA3Q++xo87lUdOgKp8TPe6UsIQs83DxPTsRwpQerUtKS0O+bsG9B4gMYx6AGylYPJz1
         UgIfGajInIE5YL/ffByhi7ABWfZxrjYvyyD56iH2yXab5wR2vW15A6REX3kGwXW9nhqW
         QHk+lDEEutbo/lHTcd35FIuf8TwloVeCyvubnvS7K95TWYae8xX5sLnuWTrrAFNRQbg/
         RK7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1wY0lal+lBgSmtXPjk/0h/AXiG5Km+JSOehkqiKj28I=;
        b=Gt90d03RHiH1Isbq15uSuqaVjmc8O+qTdPZG+miMhkdqOSSYeXOQrwIljDNjOvw26+
         DJWZQPDOAcDiJSnOkzYBcSV8DBjuPGbrYqCTUWdtAt1QIQqh5gjzvRgeunMypmCnYT8M
         kV4qRjjnganeZYpthhrssEqHPYZHayWoIxIQ4GkGLqoEo/bjd10F3IuXNusZsLsoYiH2
         wfcUZ8ZQS0butpThxcSNr8VeHwVgL5MWAteABsTLZOJbk+ygXEHAWaNhRWc1y640CVBE
         IwD2MMStsrGrAfRtmGkKPJRDRXgEEul3wxfpxIK8kBHJHMTEQaLoa5O78LZN7jnOoRRr
         NJGQ==
X-Gm-Message-State: AOAM533oCbdenCBEf8sQLjPXtrwpnp02khO6dGowgQiaeFpirVa+tADP
        orliT7WYXQQEpOn2VCrt0LVsfKuu
X-Google-Smtp-Source: ABdhPJwD94kw0od1hhhoEN3xhoTw28B7cYDkEhzQRA34kmHvLYDu2rQaFLz5gE5NxSdQPhRWAR1m6w==
X-Received: by 2002:a62:dd91:: with SMTP id w139mr10616214pff.40.1595041543329;
        Fri, 17 Jul 2020 20:05:43 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c9sm617331pjr.35.2020.07.17.20.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 20:05:42 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/4] net: dsa: Setup dsa_netdev_ops
Date:   Fri, 17 Jul 2020 20:05:29 -0700
Message-Id: <20200718030533.171556-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

This patch series addresses the overloading of a DSA CPU/management
interface's netdev_ops for the purpose of providing useful information
from the switch side.

Up until now we had duplicated the existing netdev_ops structure and
added specific function pointers to return information of interest. Here
we have a more controlled way of doing this by involving the specific
netdev_ops function pointers that we want to be patched, which is easier
for auditing code in the future. As a byproduct we can now maintain
netdev_ops pointer comparisons which would be failing before (no known
in tree problems because of that though).

Let me know if this approach looks reasonable to you and we might do the
same with our ethtool_ops overloading as well.

Thanks!

Florian Fainelli (4):
  net: Wrap ndo_do_ioctl() to prepare for DSA stacked ops
  net: dsa: Add wrappers for overloaded ndo_ops
  net: Call into DSA netdevice_ops wrappers
  net: dsa: Setup dsa_netdev_ops

 include/net/dsa.h    | 42 ++++++++++++++++++++++++++++++++++-
 net/core/dev.c       |  5 +++++
 net/core/dev_ioctl.c | 29 ++++++++++++++++++------
 net/dsa/master.c     | 52 +++++++++++---------------------------------
 4 files changed, 81 insertions(+), 47 deletions(-)

-- 
2.25.1

