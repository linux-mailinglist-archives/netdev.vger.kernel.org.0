Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196102EF178
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 12:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbhAHLjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 06:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHLjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 06:39:49 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A48C0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 03:39:08 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id t6so5536043plq.1
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 03:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TqDB0kWwsYrkxKHRtp+r0Dv3H510nXZweVWj1D0wF2g=;
        b=vT9RBq11k1/U1c4mFnIEPK3jM2Jd3FNcqR/CrnVnPDo5AqXh/IKDAV7rvelxSs1G7K
         UVl3vm2LpbkCkg7l5eQrq7J8GE8r1XlnBuBOlsw/5sPhcmTOg8G3vJu/gjAPI89mZvha
         TWkYw4mmr2D0nw1eHP1rCWL3dsDIKA+lWDE3DpywFr5dzN9zqB9zD8rP3S9ZvT8C0tbP
         tbOXIOjLRahGcMypfyDn4APx29/EhnAX+UhWnc28twN8+9HBIECkCTU54BzgHfy9Doye
         VvURAjqOg/RzW95oW1Q/yQgOXy14tB4bQ0qAdqx/29CRpQ9KtqMiaXYUORSPuyDT9PCL
         el8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TqDB0kWwsYrkxKHRtp+r0Dv3H510nXZweVWj1D0wF2g=;
        b=WRm4ZTvq5S/wmIV8rHLYSV/m/PQlhQ6hr58HEj2u4tVDX+hCGBildja63wljEW7vHL
         RvaYZjOGobxkSm4rsVw3vkqXPmEQi0BXS9AULMP9L7HAX68+eGavGGeT+8nah79fsvim
         wyJ+9m6XZ0s+Fjsaex2fCOQOM0i8zEU6MVYa0O8Buweh3M4sZDpo6KLdJ33944yPYcfY
         AwckKSWaRYPDchUIcp44ZZk7ebroTPIX/OrBndBUEAgiRwfe79/3aEjKuuZU5mYLcHaD
         dBhQXcE+P44hZYvVTkA8qtlyZ21WgQS8QBJBfCv10PDmsKenKH4SxT2Cv6eDRBb1dhyd
         iJBw==
X-Gm-Message-State: AOAM533KizQ+l+NzZYWSydSFjY1HczLfCwvnccQcnSfLR7G7EOgl4zSU
        mf2nz2Phm2ou3yH/ArCt+JXSndgEZVE=
X-Google-Smtp-Source: ABdhPJxW/72l0gKvXzcoAgzkX9Je1Oy8kN8ObAe8y9Y9YO0TeraeSw0fHGaBK8HXCWThfsCtJL4qnQ==
X-Received: by 2002:a17:90b:34f:: with SMTP id fh15mr3274692pjb.80.1610105948448;
        Fri, 08 Jan 2021 03:39:08 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id r20sm9939971pgb.3.2021.01.08.03.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 03:39:07 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next 0/2] net-gro: GRO_DROP deprecation
Date:   Fri,  8 Jan 2021 03:39:01 -0800
Message-Id: <20210108113903.3779510-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

GRO_DROP has no practical use and can be removed,
once ice driver is cleaned up.

This removes one useless conditionel test in napi_gro_frags()

Eric Dumazet (2):
  ice: drop dead code in ice_receive_skb()
  net-gro: remove GRO_DROP

 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  7 +------
 include/linux/netdevice.h                     |  1 -
 net/core/dev.c                                | 11 -----------
 3 files changed, 1 insertion(+), 18 deletions(-)

-- 
2.29.2.729.g45daf8777d-goog

