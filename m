Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73300470B27
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhLJUAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:00:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232829AbhLJUAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 15:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639166198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=iT4a/a+puJjwmTwALEZ6pR49YWg0bUbVd7YOylSBkFk=;
        b=WpRh5ofD7HuRGDG3kWB0Nm7+axI31uIhxVGvhfGqS8c150PN049WIN7bcUtFEUcWQpQ8wP
        SfLO2lRiwwEYwnRtkOS+ex+CYG5MXiR9nAvS9mMcqC0/3DydNLlP77EB1NU325t/7cggm7
        su0SJh8HK4P2sMHHq8sJMRdWvEL4mU4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-BsRUOEQoOKScNALyzPrt4w-1; Fri, 10 Dec 2021 14:56:37 -0500
X-MC-Unique: BsRUOEQoOKScNALyzPrt4w-1
Received: by mail-wr1-f69.google.com with SMTP id h13-20020adfa4cd000000b001883fd029e8so2706630wrb.11
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 11:56:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=iT4a/a+puJjwmTwALEZ6pR49YWg0bUbVd7YOylSBkFk=;
        b=jovb2gOQg/ULKyDa93m96QAiS5sdsnZeYU3xRpNq465BtV5oL8VdT47JtLIQgH10sj
         5GXibSMdu6vA4sUtpdX7trC0UIxBVRBwGkhaecPN8NAmoXkVbfqIu4MfWhEA2uP1gdSP
         CBZQCwqsfiGAAthlOQDbxb11BIlhZQyCkLVfonsfLqt6dIRxz+hoC3k0gr1SR2J9nGKn
         9Gs+N6F6Q0v/qiLAuj/R7328XUBKbv1P8syv8vsv4sYUksJYNL/zXv8bHOdrg7oULR2p
         QPsdV0JmdIaHVE9DLD5lVU9mSd7lkqBYAS9h9LD+iGp0tqnhccol55AuArmXzGIscrzK
         QZqg==
X-Gm-Message-State: AOAM533lpP0JVE1LZa5FrkCdhZZWg+MEoFUN/wiM9CcnxkXtCL/B9O8D
        /QB+6UuGh7/XDjq1JpDcOZxd5Sly+jIf2jhuvS0TGVOH9CVJjFzVlEE5bTeBHKoq5+91C/9pjaN
        SAerjfgcINpbhi9aV
X-Received: by 2002:a05:6000:2c8:: with SMTP id o8mr16214951wry.266.1639166195775;
        Fri, 10 Dec 2021 11:56:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwxfhJe4HoM11dLbL6kNG7wU2JefFKsn5auyYsEbzk9GS+wHM43619UQEY1GQW5t3OwSM21yA==
X-Received: by 2002:a05:6000:2c8:: with SMTP id o8mr16214935wry.266.1639166195623;
        Fri, 10 Dec 2021 11:56:35 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id l26sm3740029wms.15.2021.12.10.11.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 11:56:35 -0800 (PST)
Date:   Fri, 10 Dec 2021 20:56:33 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next 0/2] bareudp: Remove unused code from header file
Message-ID: <cover.1639166064.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop exporting unused functions and structures in bareudp.h. The only
piece of bareudp.h that is actually used is netif_is_bareudp(). The
rest can be moved to bareudp.c or even dropped entirely.


Guillaume Nault (2):
  bareudp: Remove bareudp_dev_create()
  bareudp: Move definition of struct bareudp_conf to bareudp.c

 drivers/net/bareudp.c | 41 +++++++----------------------------------
 include/net/bareudp.h | 13 +------------
 2 files changed, 8 insertions(+), 46 deletions(-)

-- 
2.21.3

