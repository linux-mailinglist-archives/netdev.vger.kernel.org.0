Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD44A4B271
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731014AbfFSGz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:55:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54835 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbfFSGz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:55:27 -0400
Received: by mail-wm1-f67.google.com with SMTP id g135so460389wme.4
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 23:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=BVAV57yKdyl3uXiy/TFe67/Ux5W67/VouR2/3yqg4f0=;
        b=cim1tzEIjr4xu3xJOK3Yxs3w9ZphLTpYWGczYI1C0OuVg9bsd66m4OFC+VdTr7uPv3
         ObMJW+pWMffk1Ns/m7VhMOMVybZzhnVx6OC2/QjNgkZcQQPl5Xy3KYTqgey8Ks2YIOE1
         vNTc20vN5C7ldeumABZR8TiDhSuXJAeTO1ngnSTX+xLWWVpzz6U9zVTWPgAb7wvjIRxv
         j1uv6sGFkHRxpbbxrc7z7vqumF6UNWApF4EJnm1j/sTFUEmDpRapf0aSy62MQkn32/Qk
         QaWXAeT4UfRtJQh7yMWtNbV/0jBNK56eWyNN3w2ejHMfJdChCYyxFhSn9Q4DbzDIjpfD
         dxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BVAV57yKdyl3uXiy/TFe67/Ux5W67/VouR2/3yqg4f0=;
        b=QCtrpR3RLKjRwN0erRVptfTC+9+qJIPX3HQe0WSW2GZPzz6af5AIgOIiIJX51krJgu
         5jUlyWfcvIYTfEObPkiu3bEAFIz+Ro0zwUuY6buCAf+KLFtMXovj066LSyyFjj4rMd7w
         eAcGJ5NFOp9JYLBDMevkSHGlS5KgZDZRL5N7RWgT/zpivZRx/bbCFQGvwhVUJiHbbTjW
         IANVirO4hCTro0afLnukrdVEKElRgFtVd4TRqtNfHXO30baSAQcNug4FeqmIrBVDABvT
         3vprjrQTnKawRsG+VrVaKBKuD9WLJhAG/22k/4sw6kgosYgk38XnRIqIuQFeKn8364Xu
         GCxg==
X-Gm-Message-State: APjAAAW3BPJFYmYopsvDj3CIvwTj7TNOelXUQkOBUeh2Pj5JAeD75Maa
        o9N9GJtj121tnIab6SIhcC2JYVZuHxrdKP8U
X-Google-Smtp-Source: APXvYqwb4UrxA8hgLGxJ1cFXww4eNO89DlMf3aZpY0zRHJnVw9fO0iXncOfQgqbLS5ZJFx47/NkQ5g==
X-Received: by 2002:a7b:c842:: with SMTP id c2mr6679686wml.28.1560927325157;
        Tue, 18 Jun 2019 23:55:25 -0700 (PDT)
Received: from e111045-lin.arm.com (lfbn-nic-1-216-10.w2-15.abo.wanadoo.fr. [2.15.62.10])
        by smtp.gmail.com with ESMTPSA id a2sm583462wmj.9.2019.06.18.23.55.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 23:55:24 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jbaron@akamai.com, cpaasch@apple.com,
        David.Laight@aculab.com, ycheng@google.com
Subject: [PATCH net-next v2 0/1] net: fastopen: follow-up tweaks for SipHash switch
Date:   Wed, 19 Jun 2019 08:55:09 +0200
Message-Id: <20190619065510.23514-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some fixes for the fastopen code after switching to SipHash, which were
spotted in review after the change had already been queued.

cc: Eric Biggers <ebiggers@kernel.org>
cc: linux-crypto@vger.kernel.org
cc: herbert@gondor.apana.org.au
cc: edumazet@google.com
cc: davem@davemloft.net
cc: kuznet@ms2.inr.ac.ru
cc: yoshfuji@linux-ipv6.org
cc: jbaron@akamai.com
cc: cpaasch@apple.com
cc: David.Laight@aculab.com
cc: ycheng@google.com

Ard Biesheuvel (1):
  net: fastopen: robustness and endianness fixes for SipHash

 include/linux/tcp.h        |  2 +-
 include/net/tcp.h          |  8 ++--
 net/ipv4/sysctl_net_ipv4.c |  3 +-
 net/ipv4/tcp.c             |  3 +-
 net/ipv4/tcp_fastopen.c    | 39 +++++++++++---------
 5 files changed, 28 insertions(+), 27 deletions(-)

-- 
2.17.1

