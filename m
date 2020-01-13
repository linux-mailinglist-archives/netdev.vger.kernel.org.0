Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7C139BC1
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 22:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgAMVjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 16:39:32 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43275 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728872AbgAMVjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 16:39:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578951570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=TmF8Hv16sY6iJmWP2Q5PWZP+/c4UXh4RIugFKiSyM4M=;
        b=Y4gYVmyQFbevgkTZXeToDI/RiStr1pv4g8TidyNmnaKwwA2zqf029eDiQOPBYZ5f9kjBHH
        f9VPAoeJRiMs9UEG6wF42DFHTx4L33EJlkNP6AL/EB7i6dCd1IwsjgVpAp26BqPk2F7aiW
        VL2OfJ/ILa7LHZC6UUXn8QIawwc5eB8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-pdoqTWUHN_a35CWO6il_sw-1; Mon, 13 Jan 2020 16:39:29 -0500
X-MC-Unique: pdoqTWUHN_a35CWO6il_sw-1
Received: by mail-wm1-f69.google.com with SMTP id 7so1587500wmf.9
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 13:39:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=TmF8Hv16sY6iJmWP2Q5PWZP+/c4UXh4RIugFKiSyM4M=;
        b=lGbentTuHww8oY7a2bxx1qn7D2swIIKE5yrj/aCelv7sf1tkJkROzseaNeiJWS3Dd5
         lnWrXPVle6BY0bjm93hPxTLNvAbJhD4GptxiHXvRwuA5xhaI4aG0+CGtlNe2rYrZ70IB
         NpFwtRUcYy/xpVm8tgokNqVXgEJgXEmoKHFxeAKrdfHU2RIpN821CUfnutKtQuKgQD8q
         8kN6p69Z6WMxNdA94GeashLQOSQAseQALKEKNZidD3uA3IdOTgEDD6fkiPRDzFdcuiNH
         csW5W3pSyuQrqlQdMkPnnYJ1WAhylVs0FWiuptX8ifuJKk7LRl6ycfBMNTQ8Ap3XKhUy
         8hFQ==
X-Gm-Message-State: APjAAAUi5BjPSHL6aIBaeVFmc9iec1gI67BlIXrNovHFsdnl2Tkd7Vd0
        25uuwRql5ygFCVFSyjBPKpRL9M4+lbl9vV/yHyKhqgrFd3XL8bL31DvFADYGsolsP3BH5ycYkTI
        AlFWvhIsQK1awgVPH
X-Received: by 2002:a1c:2187:: with SMTP id h129mr23339869wmh.44.1578951562186;
        Mon, 13 Jan 2020 13:39:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqwQVnfO9XsQDl1igCpWaIkCzLDDwnyC/rvtEPCuLgtj0dI9m+7clOdMkyIAd+CJxQhQFBbGjQ==
X-Received: by 2002:a1c:2187:: with SMTP id h129mr23339848wmh.44.1578951561929;
        Mon, 13 Jan 2020 13:39:21 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id e18sm16934631wrr.95.2020.01.13.13.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 13:39:21 -0800 (PST)
Date:   Mon, 13 Jan 2020 22:39:19 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 0/3] netns: Optimise netns ID lookups
Message-ID: <cover.1578950227.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netns ID lookups can be easily protected by RCU, rather than by holding
a spinlock.

Patch 1 prepares the code, patch 2 does the RCU conversion, and finally
patch 3 stops disabling BHs on updates (patch 2 makes that unnecessary).

Guillaume Nault (3):
  netns: Remove __peernet2id_alloc()
  netns: protect netns ID lookups with RCU
  netns: don't disable BHs when locking "nsid_lock"

 net/core/net_namespace.c | 93 ++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 55 deletions(-)

-- 
2.21.1

