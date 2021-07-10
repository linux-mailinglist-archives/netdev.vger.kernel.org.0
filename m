Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D9F3C3364
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 09:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhGJHF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 03:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhGJHF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 03:05:56 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBF3C0613DD;
        Sat, 10 Jul 2021 00:03:11 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id t30so11988692ljo.5;
        Sat, 10 Jul 2021 00:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9n6Nw9X4f0+06wXfdQA+e6xY6av5OO97df8Pa/9JS1s=;
        b=cBqFvWOzYcfH+3/HuPugzTxBqcFH6EZ1T353zs2FGxUqiJg2AdywB3bzhQKD7KfEBD
         OTosqH1VNcLTBgOgpgAcJbZhJxRN7bJ/EtnJ4j5QeWAY3eeY9CuK472VC3q+2q3/dLJx
         IblsF1oGdqJbgJBPTRWZh2IJllCGcoCk6iDiWCRPoEoavOfM2VOpcKuJZTdv823C9Ag1
         oONcwVZaEche8jm+ziyr0jKFx7XLUOkmd1C0WqW8oNngCfcVomUXhJawS8yVPiDzn2eH
         XinbOD6w3IkZur10uCFA4WJMbvAzYnvxUvg56F0sS0D+N80vUq476uZ94TKcXXUa8BoS
         Kv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9n6Nw9X4f0+06wXfdQA+e6xY6av5OO97df8Pa/9JS1s=;
        b=CUcx9yc7qiCTh0F2zm/XYhGWSuHmTXcAKy6oN5uuyOOQ+LxyNwM48OyY6QquV18LCG
         H52f3kQdakYJDlZbJaYs2YpXD043IsUGbEUATsZQ8eo89hSkFnQjyTCkRhJNugUOo//O
         fjUWD9TKR7h7rS0JDw53XPyiPduVc1XCDWHLLsXLxAkBCJAscmkmyh1kQ0z3Jlc1Jhv/
         CzJYAkjBzO4widQicwxp+vf4VKhAazMm5ZovFdA7cCnrTRmQuzqkRXotzz5DA/eSH5fI
         PUjxlKynacsHdF7VPrvTbKvP9zvfmueyx+33uxlyl+/JuynqcAJDGOcY26OlMv/QVHei
         dsLA==
X-Gm-Message-State: AOAM5300/GMWItSZv3GekRRQYzcmw1ogliPTkxd6UYpdEmhNK1ZPlgqm
        zLt2UuKF/G5oHO/ul0QxU04=
X-Google-Smtp-Source: ABdhPJysk4zRSmTOGqBuXkW4kOOEsv29VlQ0ws0NMW7QrmbIASbYGqzBnYA7GP721CGfDkt3yCZ2SQ==
X-Received: by 2002:a2e:95cc:: with SMTP id y12mr25064394ljh.360.1625900589849;
        Sat, 10 Jul 2021 00:03:09 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id l7sm638891lfg.203.2021.07.10.00.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 00:03:09 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     paul@paul-moore.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 0/2] net: cipso: bug fixes
Date:   Sat, 10 Jul 2021 10:03:06 +0300
Message-Id: <cover.1625900431.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small patch series fixes 2 bugs in cipso code. The first one was
found by syzbot and the second was found while testing fix for the
fisrt one. All 2 bugs can be triggered by reproducer provided by syzbot:

https://syzkaller.appspot.com/bug?id=d4bc7d67efe79c6ead3cb6bd94b84dbd287f1069

Pavel Skripkin (2):
  net: cipso: fix warnings in netlbl_cipsov4_add_std
  net: cipso: fix memory leak in cipso_v4_doi_free

 net/ipv4/cipso_ipv4.c            | 1 +
 net/netlabel/netlabel_cipso_v4.c | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.32.0

