Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0360310802A
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 20:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKWTti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 14:49:38 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53605 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKWTti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 14:49:38 -0500
Received: by mail-wm1-f65.google.com with SMTP id u18so11088145wmc.3
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 11:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=h0sm7JZuVgTsLw2Ecm2NeJateQQMvo9HHMgHFrFgVR8=;
        b=qBXmJsbcs2/kEIl1slwY5x+K9n3Saom5LAXPKfm+J5pjlrxoIaQ4dvMrQYmMLwtC/a
         uzK+cbjvoYPAi+4Rk/PNf32qBE8DIwyQYjt5zpvYjqCysLuN+bygvOrxyhZUCHls4vmv
         DE/bO2QSkHI+mSpCwvqMf+dATSusS6dZNBEzd1am+dx9o3JPQ30TkyHyGdC5V2uj0zfX
         +a9fZDheakCS/dI1vciYG9t2pybOVTGpKCoEqYDhrGq+Glm97FfZ1iM/SXwPvSXnwBfi
         K7Hj9Y+XN52jZSzycFCcHIdF22Vi0AlKp96ZyEP53/Y0uuxjfbhW9q4Fs7Fbf57OSi4t
         rbgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=h0sm7JZuVgTsLw2Ecm2NeJateQQMvo9HHMgHFrFgVR8=;
        b=B79Ti7PJWaCG7H5TVyi+q+rMRj4VrZCWuKkZGV0Vrc+pMsFtKTbfZSdgKR+BKeJoeN
         U1zQNRlA1lDRWk2MjM+yTKrZ+0++PhKRYvAYk2DEt9bSgLvFZMwHk7lxC4tHbYRFPrOH
         KUoTIqp6AUnF3vKxUqvH3RSTVbNRzIVRMzmNhWXW6wI+tbJpy8egUYdmLSoWWOJfVaTe
         qvgZXFqFDo+gI17pVnty6xQ6fsTxCmn+UHBOyDaVsJjb4K3N6McXCVv9lKM46OvOVTqY
         ogLWo25KAp1F316puPBZquTI+tn1EYenwHz3U8sYRpFoKrp7vxIX569/h+LViu9LPh7L
         SZow==
X-Gm-Message-State: APjAAAXpvb0duya7MZEbq5cNZ0+R2unyK83YNKvWfxoxq/fnfYRRFP7u
        tdDmUnaSBSapazhIP9RDvoE=
X-Google-Smtp-Source: APXvYqzPodiSQqsXYih54Np6ScBVdl0hT1K+oRMmlUvqAmjvG9R9I/ZZq+XwtQE1QC8HINii5JTnVw==
X-Received: by 2002:a1c:808d:: with SMTP id b135mr21474059wmd.175.1574538576214;
        Sat, 23 Nov 2019 11:49:36 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id j10sm3300569wrx.30.2019.11.23.11.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 11:49:35 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/3] Configure the MTU on DSA switches
Date:   Sat, 23 Nov 2019 21:48:41 +0200
Message-Id: <20191123194844.9508-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series adds support for configuring the MTU on front-panel
switch ports, while seamlessly adapting the CPU port and the DSA master
to the largest value plus the tagger overhead.

Support added for the sja1105 and vsc73xx drivers at the moment. Will
add for felix as well if the series is well-received.

Vladimir Oltean (3):
  net: dsa: Configure the MTU for switch ports
  net: dsa: sja1105: Implement the port MTU callbacks
  net: dsa: vsc73xx: Make the MTU configurable

 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 48 +++++++++++++++++--
 drivers/net/dsa/vitesse-vsc73xx-core.c | 30 ++++++++----
 include/net/dsa.h                      |  2 +
 net/dsa/dsa_priv.h                     |  2 +
 net/dsa/master.c                       | 13 +++---
 net/dsa/slave.c                        | 64 +++++++++++++++++++++++++-
 7 files changed, 138 insertions(+), 22 deletions(-)

-- 
2.17.1

