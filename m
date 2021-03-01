Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867CE329090
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 21:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbhCAUJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 15:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242400AbhCAUHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 15:07:09 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CF1C06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 12:06:15 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id s23so313070pji.1
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 12:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9K7jUgE2LmNGDoZDwBfA1B86gHJCehExJZSP0d0xq6Q=;
        b=LfZC7e1Abwp4SFyTkNDTrMGwigimuUz+CkvxeONBp6YcvvYKk5IafZZapAjzhjHXy4
         Daru8urkNWAzXTMszOXYN7pVJ4s5C5wUFPHsqYjzDxpxaODlYrOk2IHTzqORnjAZsJze
         juDHxwCbLQ0PwF/nso4Ctzc2zOdm2f5Z5Qgfw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9K7jUgE2LmNGDoZDwBfA1B86gHJCehExJZSP0d0xq6Q=;
        b=OWf+d4+RFnKZXlVyg5+7jQuU7uMjLHSyMH4Bhm9AH74ne6g2/oi+IhcAAJtObnpUQK
         7MtXJG80r8clxvedpqdsUiADHMar9LnUi9ZqSDDl9etbVymkDPKuG3fGJs4SnAAEkYmb
         3q8VIupqNevFH/emOU6Yh05lj0JpNmYQiTm8h946IsuJOoOi0YK+atWQlRsa7Putcq9C
         IhDlcG+yFEx5TbHiblVfJgMk3cHMBecE7gYrSimP96m8BNYIk1hkzR4EWtXWN8pWFdN5
         GDzQjMJ8VIKjOug5c+bIhsMwLcPfdtR0OGl+n0g3voptTrh6Wh6RDPYmgecoSyUXf7ND
         +cew==
X-Gm-Message-State: AOAM531pVty4h8wosEYC7IduQKmRX2YBp6RYmKjyU/pGPuyY59agYIYa
        E3tseP4VbCTod9IihvhOkhPMtA==
X-Google-Smtp-Source: ABdhPJyOUFWHpB2eBwfNpAVcdon+IACxVbRZiRQFJuCOcZG4gMOgaxKCxuY+GU5MYhsnxmXQZgkU2Q==
X-Received: by 2002:a17:902:f1c2:b029:e4:6c23:489f with SMTP id e2-20020a170902f1c2b02900e46c23489fmr369260plc.62.1614629174679;
        Mon, 01 Mar 2021 12:06:14 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:d800:e660:6ed:356a])
        by smtp.gmail.com with ESMTPSA id t4sm238256pjs.12.2021.03.01.12.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 12:06:14 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Hans de Goede <hdegoede@redhat.com>,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Subject: [PATCH 0/2] Bluetooth: Suspend improvements
Date:   Mon,  1 Mar 2021 12:06:03 -0800
Message-Id: <20210301200605.106607-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Marcel (and linux bluetooth),

Here are a few suspend improvements based on user reports we saw on
ChromeOS and feedback from Hans de Goede on the mailing list.

I have tested this using our ChromeOS suspend/resume automated tests
(full SRHealth test coverage and some suspend resume stress tests).

Thanks
Abhishek



Abhishek Pandit-Subedi (2):
  Bluetooth: Notify suspend on le conn failed
  Bluetooth: Remove unneeded commands for suspend

 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_conn.c    | 10 +++++++++
 net/bluetooth/hci_event.c   | 31 ++++++++++++++++++++++++++
 net/bluetooth/hci_request.c | 44 +++++++++++++++++++++++--------------
 4 files changed, 69 insertions(+), 17 deletions(-)

-- 
2.30.1.766.gb4fecdf3b7-goog

