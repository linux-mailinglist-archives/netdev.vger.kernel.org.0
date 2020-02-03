Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560E51500F3
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 05:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgBCEbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 23:31:19 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37124 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbgBCEbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 23:31:19 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so6873789pfn.4;
        Sun, 02 Feb 2020 20:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B/pqc5tLbveP95ALTWC5rTGc/WIRdIa57BSU9tmG+gI=;
        b=VT6JWtD74yFe5niajdq4lSju87soOwnqRdDeJFW3Gq53IwYsip7tBhPHq8Two1NQeT
         0HhlRP9FIbjT9Db5co0lDrX5DbAphuffzXr9ByAwNS7LiECF2xFX4wLOnrrQrKmA+niM
         stysnytFz+mPyA/+lpRCFi0uQLioh9C3pTvl7xUoOmxBZLbnJdP/VyQyH6T2Lc7MWgyA
         QFKtu8o7NPIz5APevyMYFzlaTtiWT+zrG28C9VVm5w89RVRvCYv/DCPOfiuFglJAytYN
         U484YHtq3H9SiI4k/fUN1MFbI0866kAnLwbhkBaC9oKQ+ZH1HXNdUvwOIhszXuTNhQFg
         /H4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B/pqc5tLbveP95ALTWC5rTGc/WIRdIa57BSU9tmG+gI=;
        b=tZlBiT8VQ+g10MfZHBf7LDKHJaow14zuNvn6m27iwnuyOlQHSyPfcALrQ4D5KbnZge
         uNze8pd96cfkXvvi4wFjZO3bgZu3h4X+Qc8ILQmu7lqDVjwMID99j9eOSsUchlBfrAKM
         NjH3XggVQzkJftSopABnkaWcmNKimx0hGo061sbqwvTHe7Fpr84ViPjdXcm7+XOR/8nm
         MXwlJBEBMqtakkDKHyDwzJjPbaaWNw13kvm6Lwe6MRHivEyjuW3PVijHqYvekNYg30/e
         5bKObBXZ88Z838r9R4lD1ju2QkCglVZ/DLBf9tORQx+R63Ealg5jatkPZQfIbzNK3l0z
         pYfw==
X-Gm-Message-State: APjAAAVRpLcFYbKa9dpItD6/q63FOgNcMX1+0wYg85kz/upXU5BObMEc
        dq5VhF85pxBAStm6DTGjWheEeXRy/V8=
X-Google-Smtp-Source: APXvYqyS7IDaujP1qN9la85QZ8laOB1qTeMXO8k9GljFAYm44rjo0mZdgxadYyE1RWu7ThNejIRXoQ==
X-Received: by 2002:aa7:9a01:: with SMTP id w1mr22335004pfj.231.1580704278148;
        Sun, 02 Feb 2020 20:31:18 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id z29sm17823374pgc.21.2020.02.02.20.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 20:31:17 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch nf v2 0/3] netfilter: xt_hashlimit: a few improvements
Date:   Sun,  2 Feb 2020 20:30:50 -0800
Message-Id: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset improves vmalloc allocation handling and
hashlimit_mutex usage for xt_hashlimit.

---
v2: address review comments

Cong Wang (3):
  xt_hashlimit: avoid OOM for user-controlled vmalloc
  xt_hashlimit: reduce hashlimit_mutex scope for htable_put()
  xt_hashlimit: limit the max size of hashtable

 net/netfilter/xt_hashlimit.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

-- 
2.21.1

