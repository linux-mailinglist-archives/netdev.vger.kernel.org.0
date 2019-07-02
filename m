Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61BE55D602
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfGBSSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:18:42 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34377 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfGBSSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 14:18:42 -0400
Received: by mail-ed1-f68.google.com with SMTP id s49so28253985edb.1;
        Tue, 02 Jul 2019 11:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=6FDA9K8Eg0DrYoV6H18cZ4zmwn9YbWUb9dW3L/lchDM=;
        b=XmvpP4bpmD2ftx2G8tJmGIqF+j0wqzhUqr4xYm3CvOdKAzC95mR4abl5+vdbXvut0c
         9+gC7S4NoEq/C9Vbpnxryq8emDlq60+IKRu0UUKwcIOlVJSvK3+Idq9uiGg8/xaEgB8X
         nN1x+ExDkRHvT78ZMpnVV/lzAGTufx40ZD9izY1oL1wDJnMJPR5hgOnSjVk7TM1AVyr2
         7KNrvOCvVUDuLC+fUkPvTLPWC3Ciia6vUmrTFZIO5MPUWzNWelxklms441wCDObHlUhd
         cJpaBsCONU79OqZL2ga+x6C+YqYPbl/6EkO2o7+3aJQX9Voxl3bbe2zkcndU+Kj+eufT
         CA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=6FDA9K8Eg0DrYoV6H18cZ4zmwn9YbWUb9dW3L/lchDM=;
        b=MFp2WfrlrXFx2cLdB1EGYkxhFpeWGn/xTDb+/O+XPE7JB9mLzsA5y/RJaDEWhAQWD0
         7/62vPH1qanEInbykvczPZujaC2DtEhOpr3Ip+OJQoIBpKUdR075z6wX7KAdl2fOxE9a
         FmsJWgNAYL4c5hQjWyCw3ZXBfWTa1LAKO9ybOM94ox6viUhJpCSC9HSahGzq9GGz25ag
         86GeiIQu2gqakcMKmPOkHOWPAoAVFDBrbDVhJVx83ykTGpIF2Aw7EoDF9CYmlWDQmGPN
         pNM2QT30IZlX8nhz2GMTEEIQSjAlAgCV+KhaMfDa4yW1TMc5P9h3s+oyKrsD/6cIEsPV
         0rdQ==
X-Gm-Message-State: APjAAAUvPv24VefnRdSmyikhSeEM0ljF7Tc0+8buc6dkxLPeBgROm/aC
        CKEGMxsXWNl/uqn6UmVb7ag=
X-Google-Smtp-Source: APXvYqxTB811HcYtVYVeo5x+nXbAJILikgNeh0Gur9Y7ztJZkIvOOszbI7RHmnanShh3mT1l8E6xyQ==
X-Received: by 2002:a50:f599:: with SMTP id u25mr38225155edm.195.1562091519834;
        Tue, 02 Jul 2019 11:18:39 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id q16sm2890782ejj.85.2019.07.02.11.18.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 11:18:39 -0700 (PDT)
Date:   Tue, 2 Jul 2019 11:18:37 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: -Wsometimes-uninitialized warning after
 8b97b055dc9db09b48d5a9a37d847900dd00d3cc
Message-ID: <20190702181837.GA118849@archlinux-epyc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

After commit 8b97b055dc9d ("ath10k: fix failure to set multiple fixed
rate") in -next, clang warns:

../drivers/net/wireless/ath/ath10k/mac.c:7528:7: warning: variable 'vht_pfr' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
                if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/wireless/ath/ath10k/mac.c:7551:20: note: uninitialized use occurs here
                arvif->vht_pfr = vht_pfr;
                                 ^~~~~~~
../drivers/net/wireless/ath/ath10k/mac.c:7528:3: note: remove the 'if' if its condition is always true
                if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/wireless/ath/ath10k/mac.c:7483:12: note: initialize the variable 'vht_pfr' to silence this warning
        u8 vht_pfr;
                  ^
                   = '\0'
1 warning generated.

This definitely seems legitimate as the call to
ath10k_mac_can_set_bitrate_mask might fail and vht_pfr
won't be initialized. I would fix this myself but I assume
there is a sane default value for vht_pfr other than just
0 that should be used?

Please look into this when you get a chance. Thanks,
Nathan
