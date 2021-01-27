Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C371E305FD5
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbhA0Pjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbhA0Pf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:35:29 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BFAC061788;
        Wed, 27 Jan 2021 07:34:49 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id q7so2329039wre.13;
        Wed, 27 Jan 2021 07:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rTRSEv0yvyo3PPUejUzJ5llScpDRGYrc5zOg/mjz0jE=;
        b=Kr+HnUanrSYI7TF8hWB9wEyvNO8zvTpwqMTv7HsijAhelbMwbdUZ9W1NjDtVXvQasT
         YOb+0aTVzN/id4ve7T2GZoxYgQu+Ztua8G36fl+1LSEkC3KLfDipROHq662K33CWOfwW
         D1L5JYMFj/zZRjASSy17Tt49k+4hoAQT7+QuIgs5Kzv2i3ML5xZjvo9IMO4PGmilx+op
         0ZLMfd13cZHMCgNN/70NS68zQ8dKf/Gi/Xhb0Dvi2wQqmxsX/pVe5nZHDbGr2KgvdFaG
         FuClP9aYmsb1NuS3tMI7RXlk2eTYMxu4JYW5tTaK7/Scwz7yi4jD6fZ79oymm1HmSB+h
         4pgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rTRSEv0yvyo3PPUejUzJ5llScpDRGYrc5zOg/mjz0jE=;
        b=NaBQu1N61HZAJilqXhb5feKxyMq7Mz8s/eui2M8qAFgMKUioNCKd+kp4M/NO7bDmBT
         Jw4uIbiTRMpOKVBuJQYdoCh74TZkWvT2AWzdANWPyeXQMfHCJD04MApWqn1jYvAkVdzH
         2Z/0DH8kav6Dw1fZMxg66ZNweXrRm5mRzNxraQR9kM/LHNHlbqIHvwEzlLHD+6A7vMGI
         TiCIcYYpzMxF8ue7L10Mg1ONbASQBA69NAs2u4u9uuwpu7+b6JJQeaYr/a9Hpapd6hXm
         jpCIIuwet+YHw5oJZSkPTmYoo99Kg5H0vt8dbeCLOWn35LFQ4uMQ7f5X9RL+Y6ROVDxB
         8/Hg==
X-Gm-Message-State: AOAM530D1c5iJVl/oJ79tUW0pMI09WCVvDEfEv7Af/VQw1EYCr6sUe38
        TlJW4N9iF1bZ5dC9q8kgGFE=
X-Google-Smtp-Source: ABdhPJxEbADSJmI2f+6JbkXwibkiYfDqfXOk/EwuRFc9Pdof6ImhiNR47a1spCUVPw5le7cm6KLA1w==
X-Received: by 2002:adf:83a6:: with SMTP id 35mr11676078wre.274.1611761687815;
        Wed, 27 Jan 2021 07:34:47 -0800 (PST)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id m8sm3386132wrv.37.2021.01.27.07.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 07:34:46 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 0/2] net: usb: qmi_wwan: new mux_id sysfs file
Date:   Wed, 27 Jan 2021 16:34:31 +0100
Message-Id: <20210127153433.12237-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this patch series add a sysfs file to let userspace know which mux
id has been used to create a qmimux network interface.

I'm aware that adding new sysfs files is not usually the right path,
but my understanding is that this piece of information can't be
retrieved in any other way and its absence restricts how
userspace application (e.g. like libqmi) can take advantage of the
qmimux implementation in qmi_wwan.

Thanks,
Daniele

v2: used sysfs_emit in mux_id_show

Daniele Palmas (2):
  net: usb: qmi_wwan: add qmap id sysfs file for qmimux interfaces
  net: qmi_wwan: document qmap/mux_id sysfs file

 Documentation/ABI/testing/sysfs-class-net-qmi | 10 +++++++
 drivers/net/usb/qmi_wwan.c                    | 27 +++++++++++++++++++
 2 files changed, 37 insertions(+)

-- 
2.17.1

