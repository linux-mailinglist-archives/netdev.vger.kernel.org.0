Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE8A222DAD
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgGPVVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgGPVVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 17:21:45 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572E7C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 14:21:45 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id br7so8193572ejb.5
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 14:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zop9Hp8Zw0NC93XWCLOR/4a5/bJDrZdHy4raj7E22/E=;
        b=c9141k5ScgdAlu9H/mOUwTd+6jOjHhKCL+HyW/EqY6ODbmh2pqAFqbWs3YAGN40XKn
         QUzXhSnvb8KU+z+8utq58lgcioCsFYWNnGv0dJfQIawGjgjnIK0nBnAV13WtcVpx/975
         Wr0m4XiiPRcB1NrAb1ByNzZjpBkNBUp8ApKzM78KH7AcICsL6jWkACjIZkaGti6tTXKv
         lntl+Qxzl+9BAP6tTVvVlPRUO0Q8dsTuGP5hoJUoBUK7IdKMMbACn/BkzSyqxqVPOFIx
         d+XAAn4kshSdtVvlvigE8coCjJDote/iP3BxxQJ7L9xVJkx1T89JtQOJmEBgtRdXdoTz
         plog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zop9Hp8Zw0NC93XWCLOR/4a5/bJDrZdHy4raj7E22/E=;
        b=Knzfu5tYPEiHqk1M8uVjc48n/7+gqZ7bzsve1cTu40j0MInBmFhSKyaiK7WydJwNur
         k6tNNhKJN/qX0FZKHb2GC0GX8STT86MN//tUpTtFWCtyffO/3WR5Pa2VtDvMoQVJOwls
         iULepxk8bYFBkpTxyA74Y7zvfLH8RdipUiH2PB05RlzRtuXUeQLVUr0SIgyaSkghZowi
         ajZuVfaM65D0x7E0L2y3SVm97lmoYaT3xrb70iwHxi8Uj0VW/cGB1l/7qjaU4KjkcDo4
         8mANcKSLdbicsxUssLUymvKh9EeefNs/1PyFSvqSnQj0z17gApi02kmtTFwm8GwBGhPr
         0ZoQ==
X-Gm-Message-State: AOAM531LsKbWOGuaGEuxO3iazvg0/xzukVlYFTYKPUB2yVD7QC0rJncF
        eFnEWJnv8katU2KMwPJApdc=
X-Google-Smtp-Source: ABdhPJxlz+3T0ORwHaSA7TJqlLW3xbLyDRVs13AniltGHpe9lisKDO0VRgqKA0bLLDbbPt2ItYZpog==
X-Received: by 2002:a17:906:7fc8:: with SMTP id r8mr5861870ejs.412.1594934504082;
        Thu, 16 Jul 2020 14:21:44 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bq8sm6182596ejb.103.2020.07.16.14.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 14:21:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/3] Fully describe the waveform for PTP periodic output
Date:   Fri, 17 Jul 2020 00:20:29 +0300
Message-Id: <20200716212032.1024188-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While using the ancillary pin functionality of PTP hardware clocks to
synchronize multiple DSA switches on a board, a need arised to be able
to configure the duty cycle of the master of this PPS hierarchy.

Also, the PPS master is not able to emit PPS starting from arbitrary
absolute times, so a new flag is introduced to support such hardware
without making guesses.

With these patches, struct ptp_perout_request now basically describes a
general-purpose square wave.

Vladimir Oltean (3):
  ptp: add ability to configure duty cycle for periodic output
  ptp: introduce a phase offset in the periodic output request
  net: mscc: ocelot: add support for PTP waveform configuration

 drivers/net/ethernet/mscc/ocelot_ptp.c | 74 +++++++++++++++++---------
 drivers/ptp/ptp_chardev.c              | 33 +++++++++---
 include/uapi/linux/ptp_clock.h         | 34 ++++++++++--
 3 files changed, 107 insertions(+), 34 deletions(-)

-- 
2.25.1

