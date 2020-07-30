Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2950123399C
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgG3UR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:17:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28689 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726495AbgG3UR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 16:17:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596140245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=qM3w6Ax2r4WxBSj5VUslAARuud0ZCrC8MlEwdcyfw+Y=;
        b=Z2MOQLXQG1m0k3ulcDgbrDtZB28m6NVdccQU+8pp537Lk1xFRAnjrNOTOHZTO760a50zYn
        pNqB8ctarTgIXWfmjHZSWTy9Jgsey7YmReCRXCRY5B2WKMA1BY3QPuZASgJ/olmZ7VYxdW
        W6s4ZgjKTQErBQcmPE1zkNnpIxQZOzg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-5OnVEdDdMLSCaX5eEoFN4w-1; Thu, 30 Jul 2020 16:16:23 -0400
X-MC-Unique: 5OnVEdDdMLSCaX5eEoFN4w-1
Received: by mail-wm1-f70.google.com with SMTP id s4so1584127wmh.1
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 13:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=qM3w6Ax2r4WxBSj5VUslAARuud0ZCrC8MlEwdcyfw+Y=;
        b=Pyil3U7ENM0CK8of0Opb7DYo7v1aGvtZzKStR14n8nPX5NmhdlAvV0D+Lm7N+N/N6i
         qpqvJkSiUVaghq83z9n/KkgDOQlO4VEc1j83XMmGBIv9kYl1CwN0oqPhyFVWY0IOxtB5
         t778OyLQvUBQkiZiF9nIskTgJwc7XCpXK5M6I3Lo6j8WCBY0h5fKcPoB+L5kdFecVYgn
         Hqmp1R+0AdGWtV6Sh+rUJ5bobi0RMnaL77R8OO14xe6k7QYolAKpy1ivTG1Qqht+vDNf
         mbi5xkUHSNvO/r8LqobepocM5JTic+g30h15VdsftQzL1LrtEXaprQTZuwMWbtKG+yNc
         8A2w==
X-Gm-Message-State: AOAM532CQiufXcvDkhaLvBrXnICaJT83YcPpGOoByCFXifbOTE7cDsqS
        H5Y3uQ7ooI4jdibXHsdu9Wj54JmIAl62/0sCguhAuVUGF6q3TOH1VqBFsMPiODpzuk3Yyfc/oht
        W3IOS78x8EBdLgpo0
X-Received: by 2002:a1c:7315:: with SMTP id d21mr757415wmb.108.1596140182502;
        Thu, 30 Jul 2020 13:16:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaW4Btw9dZUceS/cij1HeCm0SFI2rEAGOXLL4HOI+53Vk16dXahuaRQktZI/xj2QB69Rhweg==
X-Received: by 2002:a1c:7315:: with SMTP id d21mr757406wmb.108.1596140182316;
        Thu, 30 Jul 2020 13:16:22 -0700 (PDT)
Received: from redhat.com (bzq-79-179-105-63.red.bezeqint.net. [79.179.105.63])
        by smtp.gmail.com with ESMTPSA id g18sm11747978wru.27.2020.07.30.13.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 13:16:21 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:16:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Subject: rcu warnings in tun
Message-ID: <20200730161536-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Was building tun with sparse the other day, noticed this:

drivers/net/tun.c:3003:36: warning: incorrect type in argument 2 (different address spaces)
drivers/net/tun.c:3003:36:    expected struct tun_prog [noderef] __rcu **prog_p
drivers/net/tun.c:3003:36:    got struct tun_prog **prog_p
drivers/net/tun.c:3292:42: warning: incorrect type in argument 2 (different address spaces)
drivers/net/tun.c:3292:42:    expected struct tun_prog **prog_p
drivers/net/tun.c:3292:42:    got struct tun_prog [noderef] __rcu **
drivers/net/tun.c:3296:42: warning: incorrect type in argument 2 (different address spaces)
drivers/net/tun.c:3296:42:    expected struct tun_prog **prog_p
drivers/net/tun.c:3296:42:    got struct tun_prog [noderef] __rcu **

any idea when did these surface?
-- 
MST

