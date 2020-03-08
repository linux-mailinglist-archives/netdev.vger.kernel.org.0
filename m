Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B721E17D0C8
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 02:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgCHBS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 20:18:59 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37203 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgCHBS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 20:18:59 -0500
Received: by mail-pf1-f193.google.com with SMTP id p14so3127611pfn.4
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 17:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O3vxefhTmXOP9j1Qu3cFiTCJtsUPwf3j5ArMZf7EzZ0=;
        b=hcKlFn+O0dQVmgkH2fkp4/muH7yYwK1wotHgvaXVxW54M3k6GlIBoof2ldcwhU0tkd
         wXD3ZWyXbUgpieWWJrZMltBsQApA6NO11kDIcUOyLoQclIcMvq7BgehJJ4it2zS19ef/
         GKXafWU3j8743mtbaysbp0qmlly2FeTQcnB+la6MclAaIq7rm8BmedpMowlK0u4VuPWK
         AunDbMHSglpfKYmEWv0mFkEL8JvYDAH6oinqdPulIIggF+w5MeqKHLaNNcbQ1hzOBWRz
         FE3HhlNIlaWYEJs/1a9h+q2YyI2VbD1mpV6CCqMJrudOtPMvhbk5xLShGtSgpRhExFw+
         TicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O3vxefhTmXOP9j1Qu3cFiTCJtsUPwf3j5ArMZf7EzZ0=;
        b=hTqWwqWO4yj9OI2AceIquS0a+kA0PoC5pk8MQdGa2F+aqphTT8dgjnYrtMkq6Ojhoy
         +eLe0nxb1UR+GerJZ9hl6RpgMKHCf97qWs+uwZnGm4AttfvFdMQo4XJjZB1+3vdiAzzK
         cdsi13nGfLLB9zMlvakCFDqMRRmY3NAoFp4zIjBHU95oXpY3+hHkoPK4h0DWLu44+A1m
         jakg9HZu7MyIh2YNjaYL4JUjHvLWm8Mfdo9yrhBLGE9K4ZkunlVbZGgNrcrO2OvaQusv
         Iyszy7mhXm9AxFOgx/l02CK4rp/l2BLvc6GSbbxQqPtPZODhL8ytwmc/9DVSqNLX6fUP
         NApA==
X-Gm-Message-State: ANhLgQ1CkVMlacPEKg4SCa24v0xLIg8k2xgfR4TivbvoEloxVzQE6KTW
        9fslhwesCGR6nArjSZZBJBo=
X-Google-Smtp-Source: ADFU+vsW0CEMjMk1NaYhUXiDU1GZ7X1CBdVJtlu6E7PspdWOHhJG+/aC45Fc6rgi53zTn+eV7VVnOA==
X-Received: by 2002:aa7:96a6:: with SMTP id g6mr1303677pfk.88.1583630338203;
        Sat, 07 Mar 2020 17:18:58 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id s18sm13529524pjp.24.2020.03.07.17.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 17:18:57 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        martinvarghesenokia@gmail.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 0/3] bareudp: several code cleanup for bareudp module
Date:   Sun,  8 Mar 2020 01:18:49 +0000
Message-Id: <20200308011849.6672-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to cleanup bareudp module code.

1. The first patch is to add module alias
In the current bareudp code, there is no module alias.
So, RTNL couldn't load bareudp module automatically.

2. The second patch is to add extack message.
The extack error message is useful for noticing specific errors
when command is failed.

3. The third patch is to remove unnecessary udp_encap_enable().
In the bareudp_socket_create(), udp_encap_enable() is called.
But, the it's already called in the setup_udp_tunnel_sock().
So, it could be removed.

Taehee Yoo (3):
  bareudp: add module alias
  bareudp: print error message when command fails
  bareudp: remove unnecessary udp_encap_enable() in
    bareudp_socket_create()

 drivers/net/bareudp.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

-- 
2.17.1

