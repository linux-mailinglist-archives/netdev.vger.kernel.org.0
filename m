Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66212131E14
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 04:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbgAGDoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 22:44:01 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:55206 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbgAGDoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 22:44:01 -0500
Received: by mail-pj1-f53.google.com with SMTP id kx11so8406974pjb.4
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 19:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=FmjYeRI0lKL/hr/vPWtCjy/u84LzYIfzKBPqIZD0sYk=;
        b=mHCyd8J77RoLX11u/5Wh8KjQI34kvXvCJfh5mO0FIRO1Sufn3TdXT9Pvmdf9klJGLg
         Qg2RjJfRnNNr4akgjGo7vVlp56NgiFqQIj8yzi6OmeprFlEe3GrS9wUsEg9gr06NeS72
         n5anCxYVGtDWPyMIxOJPeQRWAjsyJUxzthnZZUfIRw3SQF8T8e11OHZ/Orlg9salpuNv
         gzmTINqqCT7T7vUQXTDFlef/T2RK6hC1cDroffRnFFBoxMgxobag0K2Uj7EKjXxM941Z
         SF9TQnUzS+RbLMAaTfLvk8xAv2yNmuZwvRxIAQ+PBJy/hHUjzeH3WKQAQtVGKnreNOfw
         6QEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FmjYeRI0lKL/hr/vPWtCjy/u84LzYIfzKBPqIZD0sYk=;
        b=RenQ2XB1zZ8H7MMPfxls/Xj53STnJK/Nm5LrawkorKrseSg+caPXNG9R/9efUbEfOv
         5vRWaLKA3Df4AhkjOHrgecCdzso2jTshCVHCPuI+KZmz9UuMeJ5A8FqYjL1pl7cP+wW7
         rgJpKnWTOcMxS1iqpMTKWI741By5l1q8CSRtkgUlmHs7gR9HYSiMYvREwIjneTKhLP8o
         J3l7b0wUhyRs6i/EJaXH7UWU5QOgU/u45bucwwrCG2VoEZkeVJKWhAxJ6kNPGm6Lf0tG
         wCFlMtfKieemPhNtmXK9IbEksiSzbRaWGKJgaJr5C7wHaY88bHWTxNAT0jXPGU1WveSv
         Nk5w==
X-Gm-Message-State: APjAAAVI6CYxk1DTZHacINHp7DZ7Saw4BLLaml3yhP79wAUGvG1L3Qdy
        GHsbeA8wKy8bKUsIz2Kz/ONxGbpz+24=
X-Google-Smtp-Source: APXvYqy09aAP3m3K+vdl3RlSrjq427ICP+64D4o8RG/spyMFuou58rktnCIebbpmlTC0AI2PEhV9QA==
X-Received: by 2002:a17:90a:8545:: with SMTP id a5mr46914733pjw.43.1578368640514;
        Mon, 06 Jan 2020 19:44:00 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a22sm85262959pfk.108.2020.01.06.19.43.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 19:43:59 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/4] ionic: driver updates
Date:   Mon,  6 Jan 2020 19:43:45 -0800
Message-Id: <20200107034349.59268-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few little updates for the ionic network driver.

v2: dropped IBM msi patch
    added fix for a compiler warning

Shannon Nelson (4):
  ionic: drop use of subdevice tags
  ionic: add Rx dropped packet counter
  ionic: restrict received packets to mtu size
  ionic: clear compiler warning on hb use before set

 drivers/net/ethernet/pensando/ionic/ionic.h   |  4 ----
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |  2 +-
 .../net/ethernet/pensando/ionic/ionic_stats.c |  1 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 23 +++++++++++++++----
 5 files changed, 21 insertions(+), 10 deletions(-)

-- 
2.17.1

