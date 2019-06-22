Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE9B74F757
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 19:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfFVRHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 13:07:39 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46899 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfFVRHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 13:07:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id v9so4829098pgr.13
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 10:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=krW1z4ezHd7Q4EharDLx3i9jENTIqbB80cUTHdBgtsw=;
        b=sUYPVcE7XJLyOQPvFDJVrye3CyFG0CGwnrpiJhUOXBIzYqbsRA5e5nDNN/Bk3R4rGf
         Gdprv6LT73SZZoiyrkAFX3ghi+gdH96V6msAp09YD9V3BVNbzc14In/sffBkKuhVonDF
         43VeLfPY8aI5CEQRRGiTxpnlVt4zgFCYdXaBxsddgRLRs1lDLJRhbh2KJJ4J18e8Mp3D
         zKzQ7LPSI9rRhwlSYAdaN0RPrGWSvpw6mcStw3GQweMrR+wr70WrrersezHyf+DsAo8k
         31fVKJ7akvi9xpLpn7RAd640Il5eupdo4yYM8hPSIeTRHhLtolvjuPp7EbGATrtt0GgG
         MALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=krW1z4ezHd7Q4EharDLx3i9jENTIqbB80cUTHdBgtsw=;
        b=FjhWicHo+gVJel2ZiIkcFXeJ5g8UWPNUIHq+kBbtaN0iUiWHaNKktLUe3Ctg1OHmTR
         7JBpSljjI7KwARf8EA5MaJHiv43Lf3SLEq69AUq+DtPZ+/BjaaTBWogO+CH2xTjxryaj
         dkIBOWGdcfld9uKaXz1xTMFbUCRmyyADVBMedK06dwiwRRdEpsz2qNgumgWSMQ9+jCc8
         2RfO29BnyGKf/AXJrQKq0/AdfKeCNeu9NqBYv6tW7SvB36xXkB6OB7su/aBaRVx06K/l
         0bx3nPDHvNRMOtvwUpDDYzauHQ3mKiGkUIR/nOGTcs8P1Dux8ZSMOUK4VYcCgDr5cPuy
         s3xg==
X-Gm-Message-State: APjAAAWXSidoi8mXu9Y+VY5K0KP+zIPX3GsUh+Nlvlx7iN/Cl91+/Tdg
        rd3CR7e9WTCNSo1N+xScUDym9gOIiZ4=
X-Google-Smtp-Source: APXvYqxL6M53VvJME7rya6bHQynxKTjNnuExrufiZdb6uEGY0vygeM9uNJeVlbSFBuLTG9pm/H9cSA==
X-Received: by 2002:a17:90a:aa0d:: with SMTP id k13mr13324831pjq.53.1561223258156;
        Sat, 22 Jun 2019 10:07:38 -0700 (PDT)
Received: from dancer.lab.teklibre.com ([2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        by smtp.gmail.com with ESMTPSA id e66sm6121632pfe.50.2019.06.22.10.07.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Jun 2019 10:07:37 -0700 (PDT)
From:   Dave Taht <dave.taht@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>
Subject: [net-next 0/1] Allow 0.0.0.0/8 as a valid address range
Date:   Sat, 22 Jun 2019 10:07:33 -0700
Message-Id: <1561223254-13589-1-git-send-email-dave.taht@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My talk's slides and video at netdev 0x13 about

"Potential IPv4 Unicast expansions" is up, here: 

https://netdevconf.org/0x13/session.html?talk-ipv4-unicast-expansions

There are roughly 419 million IPv4 addresses that are unallocated and
unused in the 0, localhost, reserved future multicast, and 240/4
spaces.

Linux already supports 240/4 fully. SDN's such as AWS already support
the entire IPv4 address space as a unicast playground.

This first patch for 0/8 was intended primarily as a conversation
starter - arguably we should rename the function across 22 fairly
"hot" files - but:

Should Linux treat these ranges as policy, and no longer enforce via
mechanism?

A full patchset for adding 225-232, and 127 address spaces is on github:
https://github.com/dtaht/unicast-extensions

with the very few needed patches for routing daemons and BSD also
available there.

Dave Taht (1):
  Allow 0.0.0.0/8 as a valid address range

 include/linux/in.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.17.1

