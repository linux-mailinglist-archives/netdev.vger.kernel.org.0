Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6203A8026
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhFONgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:36:39 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:18906 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhFONgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:36:19 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623764032; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=UqZj6ncVwqbNWU1TATskOVce7fe8wck3w5h3gR2puRTbXZ+nWfxrQKjeZaqUUvl5kX
    D1ZPSkn3qQznNuMk4POCY//MNRZ2stERRwuORs3X9lueUb2nmHpQJc+IUO+Z+iZTo7nz
    66FtkKPVk6MYpm3mYxx4eKMhH99ZOxzJ5Rv9HJhrWK2sW/X54nQ1xGU2uiorw4g93SDa
    HIBSM85rWyVBd3kHySpS3eV3kSK/mEgAQXpkaFxSUthQ7V9fonB7ZQaJAoRMM6Z7BcxG
    Gwm+rAQiHiF/vxPzKUIYutzvu1PTV2wtXQJu8Zcn4IYvA8mUkqNHAyHFtXkFUYbXR4iN
    D4bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623764032;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=mQRhCw99t46xvu5Um+luLEXQFeXQ4w3N+7RCHyZz/KU=;
    b=m5eH9bt3+q6eDbQ8EcSxeNBIP+/hILKfT4cpG2uRzFs+xwaBrqjOoGdEklhTvd/RO9
    OTZ8lxJUfxND7B+nKjkEKVof10w5iMIZxi7hBl+tcorbiQR3kB5/uppXfSaftkOFIDdw
    5EqP6/AKKOPT3FhvLMG72Z1alSwNi4qxIEWTCtD6/3RVf8aLXCZvQmQr6dv8JAYCm2RA
    6awcxa8WcnDuecSaay/AMYTfdB9CnlCKav6hgEO6y/RDGOccbUVzLmDaGtLSmVVnIqmd
    dQnKngo9IVoggOiU3JitXwkE7M9gDXJviMGapO5TDPS9TKaQ+pTw+xvAuJjGuM710i9U
    uY0A==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623764032;
    s=strato-dkim-0002; d=gerhold.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=mQRhCw99t46xvu5Um+luLEXQFeXQ4w3N+7RCHyZz/KU=;
    b=q+QVM9xC4W/uQmucYyxt3nVC54G3iImd89NhNwnkQ2viz+NjmpOqCMsqF4q9yF95xT
    n5p/kWOptl6JtIPEjTYGFVKeyuruMVbHTNMfzbjIKIsSOTcyUGw7SDubWnqJ28+p+dm3
    E/8QHwvA1gmivoq5EOYuEobTWak2xlqBBNNvidtyGTl3QLcJZcku6PlJTBvt50g8JaCY
    tiUMIdunkjGal9qKy+Oe2F5ivno/2hJCad9ekE0SFt8MyU1neYFUfZ49hXE0cwflbOiG
    n1qo00WMQ1Zjz67TfdN/4f8dtctCmeJ7wzEPyn1FQwBX8nJLTc1sNtFAAhCV3jlzp3jd
    NXiA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxA6m6NutzT"
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id y01375x5FDXpOsl
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 15 Jun 2021 15:33:51 +0200 (CEST)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, phone-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next 0/3] net: wwan: Add RPMSG WWAN CTRL driver
Date:   Tue, 15 Jun 2021 15:32:26 +0200
Message-Id: <20210615133229.213064-1-stephan@gerhold.net>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds a WWAN "control" driver for the remote processor
messaging (rpmsg) subsystem. This subsystem allows communicating with
an integrated modem DSP on many Qualcomm SoCs, e.g. MSM8916 or MSM8974.

The driver is a fairly simple glue layer between WWAN and RPMSG
and is mostly based on the existing mhi_wwan_ctrl.c and rpmsg_char.c.

For more information, see commit message in PATCH 2/3.

I already posted a RFC for this a while ago:
https://lore.kernel.org/linux-arm-msm/YLfL9Q+4860uqS8f@gerhold.net/
and now I'm looking for some feedback for the actual changes. :)

Especially patch 3/3 is still up for discussion, perhaps there is a cleaner
way to implement the blocking/non-blocking writes for rpmsg_wwan_ctrl?

Stephan Gerhold (3):
  rpmsg: core: Add driver_data for rpmsg_device_id
  net: wwan: Add RPMSG WWAN CTRL driver
  net: wwan: Allow WWAN drivers to provide blocking tx and poll function

 MAINTAINERS                           |   7 ++
 drivers/net/wwan/Kconfig              |  18 +++
 drivers/net/wwan/Makefile             |   1 +
 drivers/net/wwan/iosm/iosm_ipc_port.c |   3 +-
 drivers/net/wwan/mhi_wwan_ctrl.c      |   3 +-
 drivers/net/wwan/rpmsg_wwan_ctrl.c    | 156 ++++++++++++++++++++++++++
 drivers/net/wwan/wwan_core.c          |   9 +-
 drivers/net/wwan/wwan_hwsim.c         |   3 +-
 drivers/rpmsg/rpmsg_core.c            |   4 +-
 include/linux/mod_devicetable.h       |   1 +
 include/linux/wwan.h                  |  13 ++-
 11 files changed, 207 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/wwan/rpmsg_wwan_ctrl.c

-- 
2.32.0

