Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CBE18C548
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCTCcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:32:02 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:36246 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCTCcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:32:02 -0400
Received: by mail-pf1-f176.google.com with SMTP id i13so2471031pfe.3
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=UgV6/tipCOm7icKBf8SI7VRbhvucdzaoJDs/tLlGgf0=;
        b=aJcDhbh40oGd9viPhsHdMFdoumDVm1bz9jDmrgvvcoh6JPUJazNTlpMlOkSIWcdRyf
         BpctHGMbx7iofJL4qbl71NrLBBT5RQ7VG/PLEhhBUn06Wb5ps5PwUsxyn0LC0LXbfBJA
         cUK8y7EYH/6O6QWqnip1/jP0XvLWD0EYkZ7vlM1Zesb5GT3OhFbhnH5pXRG+P8nmEpLq
         tS+p5xgqc7Mwcv2fKBnaGrCIejgy5PMF4hK/6twkqzIZqey0ua3E5RX/XBzwMOvAWfmz
         cGPZS8ayS+DWX5idpaodxMTckb7aP9BlKjbavZRHuSpM3PuMAH9bLi7A0EzeYfG/Q8Vb
         RLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UgV6/tipCOm7icKBf8SI7VRbhvucdzaoJDs/tLlGgf0=;
        b=NiDAeVgOrkLOMSxMynwLnrbQ6EoXQy3YEF6hZ7JiJHUflKKdEJkatR/xP2c37M3l+H
         VSx0ddU7WkHcz1is4e8iu1kL5NxOeO6y02+9F/EocZ720O/4dyinVS2iWyXEh1y3YrCn
         /57OiCloJeGJgxLKzZOuLC49VU8rECTZEBo4EzynNlGYeINTlhywTmUuUBeKO7EWbMrQ
         xDZMRvq4fkNoe80L1xC2iDDNKTUr1TrOyJyyxMGEf9icm/Idsnm1nv1p74Ibaqmu/ovL
         Ufy6DHPQnOVuE1CkOZnlvXQRHSXy1mcWXk0144q6hBqg8Q/V/H0rVvHRXO1e+lApXy16
         UOtw==
X-Gm-Message-State: ANhLgQ2Q4LQfZ3/9U9dDE3x6xYWpGuXK/jde1AgXvw2KUyIbsgClPPp4
        KaKr0dAVFIrajL1nE0KQh5ZzlkxRts4=
X-Google-Smtp-Source: ADFU+vua71AKth5lzagRuRhgOWq5m1PNQdV8eN0OuWPFOZZVO0U4cpcHbnf/3BUAsZ0nHzWXrl7lHA==
X-Received: by 2002:a63:2447:: with SMTP id k68mr6264988pgk.368.1584671520720;
        Thu, 19 Mar 2020 19:32:00 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i124sm3606485pfg.14.2020.03.19.19.31.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2020 19:32:00 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/6] ionic error recovery fixes
Date:   Thu, 19 Mar 2020 19:31:47 -0700
Message-Id: <20200320023153.48655-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few little patches to make error recovery a little
more safe and successful.

Shannon Nelson (6):
  ionic: add timeout error checking for queue disable
  ionic: leave dev cmd request contents alone on FW timeout
  ionic: only save good lif dentry
  ionic: ignore eexist on rx filter add
  ionic: clean irq affinity on queue deinit
  ionic: check for NULL structs on teardown

 .../ethernet/pensando/ionic/ionic_debugfs.c   |  8 ++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 52 ++++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_main.c  | 12 ++++-
 3 files changed, 50 insertions(+), 22 deletions(-)

-- 
2.17.1

