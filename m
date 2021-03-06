Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A5732F746
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 01:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhCFA11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 19:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhCFA1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 19:27:02 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1F2C06175F
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 16:26:51 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id r23so5306068ljh.1
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 16:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=fBAuWnKniFkhy3VYJUfLAuUbpw2xIBuq2Ztnnz1BjMc=;
        b=wVIil/VLisf22gx22nWanlGS0OTCyrd638yZPJyycsRZ0Oo/mAluhCoPOJfxmthSlD
         6h7dEnERif6glcOZ/Z0t/tyyyLuYnIQxIpI7SSl4kp4rRvcAxGgqp6Mz5FvTJ03grF4b
         RfSlsKK2wvjBOG/TnrTd/loBmmjF2P+JeqAXdpNiwOwhQpNBSXxAqZLfGcC4s0L/lYEF
         Q/Rq557x+PQH/1S9Q+82j/jSSYjNjUD3VIZvY8kWreg2LFUlLDok5ZriEzcM/YBY/wze
         4z0yY9s4gtnt0qhQF31i4bsUFAF4inl72hfMxZnGl4hU8WsleD002q6z0RDAbteCtcpG
         b1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=fBAuWnKniFkhy3VYJUfLAuUbpw2xIBuq2Ztnnz1BjMc=;
        b=mRmOFr59ycnHvxWHSRMLTux20pTtZ5V3FU7miuYMcjMkL0BCfMakiGPMjQJIkkIcAa
         ZUt3SvllEp4cTxZDlusDAQ31Ns1lIZ+oz/ADmFgI+DoNjVj3/B7uHhMmsoMpIDCLsv0O
         LuAkS3CT++xC0DdNLVP+bN7eDjRiJIND+yocNGJA+xX9JfsnNYnGWmtAojuzg7A3xIkU
         s27bB7hcSxO4gzWynO7QrLlI9M3FpCBnyHfI36VCRK0JBo5wV3Fh3BVcYz+qjIzQOO9I
         NDwuQu2xsVRHGLypMLY34X36jZ463aHzJI5JV3J+X6f6AnfsREK2Z01+5HN9peB4oxgK
         w3Nw==
X-Gm-Message-State: AOAM532KhobRY5X3lEGSM0ASgUk2BIbE7b69peCksFIfwq5irT4eU4TR
        +negsU42x+PE4ksgPWKwgG5GJQ==
X-Google-Smtp-Source: ABdhPJzDLwW+vJU6+vaiUIEH5lsr/WS9530rZBb68oJMqp50z0d4YrFqcnH3xoAEAhUeMPdPsZJQMA==
X-Received: by 2002:a2e:94cc:: with SMTP id r12mr6163900ljh.373.1614990409739;
        Fri, 05 Mar 2021 16:26:49 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id r5sm488678lfc.235.2021.03.05.16.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 16:26:49 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net 0/2] net: dsa: Avoid VLAN config corruption
Date:   Sat,  6 Mar 2021 01:24:53 +0100
Message-Id: <20210306002455.1582593-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The story here is basically:

1. Bridge port attributes should not be offloaded if an intermediate
   stacked device (a LAG) is not offloaded. (5696c8aedfcc)

2. (1) broke VLAN filtering events from being processed by DSA, we
   must accept that orig_dev can be the bridge itself. (99b8202b179f)

3. (2) broke regular old VLAN configuration, as events generated to
   notify the ports that a new VLAN was created in the bridge were now
   interpreted as that VLAN being added to the port.

Which brings us to this series, which tries to put an end to this saga
by reverting (2) and then provides a new fix for that issue which
accepts that orig_dev may be the bridge master, but only for
applicable attributes, and never for switchdev objects.

I am not really sure about the process here. Is it fine to revert even
if that re-introduces a bug that is then fixed in a followup commit,
or should this be squashed to a single commit?

Tobias Waldekranz (2):
  Revert "net: dsa: fix SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting
    ignored"
  net: dsa: Always react to global bridge attribute changes

 net/dsa/dsa_priv.h | 10 +---------
 net/dsa/slave.c    | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 11 deletions(-)

-- 
2.25.1

