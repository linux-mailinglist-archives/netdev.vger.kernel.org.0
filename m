Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BE629DC82
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbgJ1WdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388348AbgJ1Wcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:32:53 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37B7C0613CF;
        Wed, 28 Oct 2020 15:32:53 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id g21so480750vsp.0;
        Wed, 28 Oct 2020 15:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dzmFu1wXCXtNHysWLv1cdt1YiWFdK19uGwaHHiwDGp0=;
        b=DYTyzKHbzP1xLIGuWeU4m+XJ/NzTPV4+oICdd9uy3aRlbUYbZ4WUFa3Vlvxum8TUMp
         /SvJJORfHgcdgvcIQsbtCxPzDVoqgiQnTrA6IjLjMn44yjTz8MuJFzKZLP2cqiEgcI/7
         Mi6fXEVjFo3TFXOB9McRdx/yHy8T/zdRtlZgAas1VVk6nwBWQTkWdGYo43Mb1J1VGjnH
         NV6O9j/ZSEc18fNcF9jxnqYoZaer4B21Al6f4gKe/7L+KHZp9nmTM9G4EHsCjxgmVU3M
         zFkLuKy6zQQERyHVVRfuaVk7IMv3AM2tv3nMiPbF5QGeXqCV+F8hMDE7C2fSatI5CpRq
         808Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dzmFu1wXCXtNHysWLv1cdt1YiWFdK19uGwaHHiwDGp0=;
        b=kdSz9dEbLSnlB/eQRry2RCCZCExFNNOrK0tPu1/mzaXGjqO+DvLVm8AwF3BsaTIbMM
         qAkZ0NAvNNPpALk7OYoefoi7kYj/V4Y9uYLoiegzMaL2bskvi8bo3uNRg0iPO/pVAJRh
         ALO7z1yNizdMIkKD/qlZRDmeyKQ9egKiT8IXFaNg1iAvFAYr+aOHB1PYOGLnyRfGIIJP
         x/K6xpEGyauqx7MbH+RXu9SFEWltQ3qE3+/5g//gOYW48LCXYOye1mJns8tZrYNaKAJC
         H+81PCIl0mMwJVERBgzIcchxcwDcn5F2JQGqSfQ7B5cKJLI/ihbhW5zNF4tc95fN0xgN
         O+JQ==
X-Gm-Message-State: AOAM533Grw7iPvXRGecgtNvt3fdcl+/jxY2x6b1HrSJvQ63nFWJZwkSR
        BBuKltfUQ7n3c77P2z1lR8pFR3gLlMc=
X-Google-Smtp-Source: ABdhPJw6j6kXCP8WeJLDd7HQFOexljFPUo9l/qsONHi+x2NLKNm10tCzjcEHMj25FV1wPvf32gKcUw==
X-Received: by 2002:a17:902:ab89:b029:d5:b297:2cc1 with SMTP id f9-20020a170902ab89b02900d5b2972cc1mr648759plr.7.1603910598149;
        Wed, 28 Oct 2020 11:43:18 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6d80:dec8:7340:3009])
        by smtp.gmail.com with ESMTPSA id y27sm309785pfr.122.2020.10.28.11.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:43:17 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v3 0/4] net: hdlc_fr: Add support for any Ethertype
Date:   Wed, 28 Oct 2020 11:43:06 -0700
Message-Id: <20201028184310.7017-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of this series is the last patch. The previous 3 patches
are just code clean-ups so that the last patch will not make the code too
messy. The patches must be applied in sequence.

The receiving code of this driver doesn't support arbitrary Ethertype
values. It only recognizes a few known Ethertypes when receiving and drops
skbs with other Ethertypes.

However, the standard document RFC 2427 allows Frame Relay to support any
Ethertype values. This series adds support for this.

Change from v2:
Small fix to the commit message of the 2nd and 3rd patch

Change from v1:
Small fix to the commit message of the 2nd patch

Xie He (4):
  net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
  net: hdlc_fr: Change the use of "dev" in fr_rx to make the code
    cleaner
  net: hdlc_fr: Improve the initial checks when we receive an skb
  net: hdlc_fr: Add support for any Ethertype

 drivers/net/wan/hdlc_fr.c | 119 +++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 46 deletions(-)

-- 
2.25.1

