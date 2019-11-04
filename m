Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3393EE788
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 19:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfKDSmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 13:42:21 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34945 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDSmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 13:42:20 -0500
Received: by mail-wm1-f67.google.com with SMTP id 8so10188326wmo.0
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 10:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3fpItiYdSut7Fp5PiEZEXxKxxZh9i29NiAxMkBEDN2I=;
        b=UgJJ5fsH5LaE0c/8torf5Y/yEu8F0Tu8LVy2TUlMtvN4+xfKGTpmzQqfL/mCthcHIU
         qkM+90aEA0fq6/LOjWqYj9YMKn4BENGN+J9f3YWk5nJ+Bbqg2+ZEcEOopwTzg/mhVqmE
         B1uAlo3EmHUtOb59uhuUoogBIS2N0c2hGDFpH47kQSay8oQ8sbxuwae5kKboonJLEG17
         yVg69iQVbY9uN5loE3jZbX/dWdYAB6oJ9Rwqa2KxdCceXQp5XW35ANLX0GktDIo0/3H3
         G6HJYCY+l6u5v/ApqsVcY+cIatm0QI/t2NPBi9F3iTKf0Y948uiPLMHjmuE4cQZrqjNF
         drpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3fpItiYdSut7Fp5PiEZEXxKxxZh9i29NiAxMkBEDN2I=;
        b=dqGXDecFgKeFUajx6IO4vWpRxsj1jfaf72wdDfI/yqnojjIG/e/e38Z+pKuFTBVJ8X
         E4nZMZF1MfBMLIu4oNqy1/SOiGLXKupNhA7FFPi/QU8DkVwOABxsxLZWipjP+dOeKxM5
         tFpBEiVStIWfuWXHdCHgcfW8SuVMACbOSlml1/U0rWVyAo4Hlv2eSpw1+NT7XkSgXW+m
         jcXPYQcCMyYtoG85KV19MFhgPNhbayij6xMjqtV4uwRDfQaE5hpxCr64FlnNZE4jQcsW
         FPZ1f/NhPhZopIs312xzm/VaFKZ4PFTSfv/58c0d85NHK9VrbSi8xg7k70vUpHHqwZiw
         FodQ==
X-Gm-Message-State: APjAAAVtrdDypZJU0NXrB0Qqxn1D8mLZrkoyZ4TUjPLVvyiQ9yHhnvOe
        OU3XKBzgnXNflsscuYWAWojKjFD0
X-Google-Smtp-Source: APXvYqxtxYgOwGRKlJspcdM34GggryyWmDjINgjwS8Ejggk8Sz7eRQV58EG+IajqlzWqDlcSHXlTGw==
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr502387wmh.96.1572892938229;
        Mon, 04 Nov 2019 10:42:18 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l2sm16586993wrt.15.2019.11.04.10.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 10:42:17 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/2] net: dsa: bcm_sf2: Add support for optional reset controller line
Date:   Mon,  4 Nov 2019 10:42:01 -0800
Message-Id: <20191104184203.2106-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

This patch series definest the optional reset controller line for the
BCM7445/BCM7278 integrated Ethernet switches and updates the driver to
drive that reset line in lieu of the internal watchdog based reset since
it does not work on BCM7278.

Thanks!

Florian Fainelli (2):
  dt-bindings: net: Describe BCM7445 switch reset property
  net: dsa: bcm_sf2: Add support for optional reset controller line

 .../bindings/net/brcm,bcm7445-switch-v4.0.txt |  6 ++++++
 drivers/net/dsa/bcm_sf2.c                     | 19 +++++++++++++++++++
 drivers/net/dsa/bcm_sf2.h                     |  3 +++
 3 files changed, 28 insertions(+)

-- 
2.17.1

