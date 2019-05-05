Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60AEA13EDD
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfEEKch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:32:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45371 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfEEKch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:32:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id s15so13399646wra.12
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wcU0cVNrtBxjhSNRthVA6Oi4ykYknYSXa/91dV7OLsQ=;
        b=HyY9T7jxiXdBhoUZRRRwmACRT0yKupXaSk2MuANtNMvxT9IHv0CZC1B6crd0fTtBXM
         C+KotiF6pSgdFR8WgwSMx8ayFtGSNFPTHE9EzYI//jShgUNT1u7da7lCvWza08qi99u1
         FPmBWXO4u12UNvRp0i1i01z1WZMsNII3vZXFMi3iobbQO9cTu32GjPLGzcCbvKZl0wKb
         L+avpcvSyPK4w+M2jief5xYl7zleIPPrfPwpV1o0DDRBPYZw5CRN1mD5fwU4WsG1WPiF
         nYx8tLOgcTPuiw18eJtEmxTgUfN4RPLmCNg4rkLGYwj7lGZMABdc7xTnK2fszR0C6v50
         zWjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wcU0cVNrtBxjhSNRthVA6Oi4ykYknYSXa/91dV7OLsQ=;
        b=CoZyzl1bZHrQwkQokBRI22K9HJ2JD5uyZpeM/ACCI6Gwvu0dJfWVC160qQEQUFXro1
         dLrt1FDZjAuGhvG81dVng7e2SUn/LXFjG3arzV+HwrnFCRPL0P7ciBqF/kOPc7djpj+w
         s/TKWR7jB9vntqSHkBjGM54w+cFHHpxWyMBlakus/LusTEdWT8KMAHUAwUx7TrOUdSCn
         E8WbT4CgC0nv6g8DRjlu/SUs52Bs9knBq7xEkRM8LZtpvfDhvXbp2omJYe1Wx1lXoM+F
         qucOUuqI8dM7fXMHp2y+UDQ0PR3MOob7Wth7acHkPPPS6XP4CEd5kNYbw6tqqEF7cVeP
         ROMA==
X-Gm-Message-State: APjAAAWk+BcyzcYhOH3VXHv6CQJiSx4m7f2s/HzSolpiXhbWSNcpBgfV
        rR48HB9rv/GJxJaDvDSZBqjhkXaTELM=
X-Google-Smtp-Source: APXvYqw+ef2rlnEx+W6+quFxO03JTFyxNbD74bQfulh+YyVWAXAJwpB8QXkYteMl/FOvki1VeJdtMA==
X-Received: by 2002:a05:6000:1d0:: with SMTP id t16mr1029579wrx.239.1557052355709;
        Sun, 05 May 2019 03:32:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:d9a7:917c:8564:c504? (p200300EA8BD45700D9A7917C8564C504.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:d9a7:917c:8564:c504])
        by smtp.googlemail.com with ESMTPSA id v12sm6172183wrw.23.2019.05.05.03.32.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:32:35 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] r8169: replace some magic with more speaking
 functions
Message-ID: <68744103-d101-6c47-b5bd-a3ed383d5798@gmail.com>
Date:   Sun, 5 May 2019 12:32:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on info from Realtek replace some magic with speaking functions
even though the exact meaning of certain values isn't known.

Heiner Kallweit (2):
  r8169: add rtl_set_fifo_size
  r8169: add rtl8168g_set_pause_thresholds

 drivers/net/ethernet/realtek/r8169.c | 45 +++++++++++++++++-----------
 1 file changed, 27 insertions(+), 18 deletions(-)

-- 
2.21.0

