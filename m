Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1694F459141
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbhKVP10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbhKVP1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:27:25 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC28C061714;
        Mon, 22 Nov 2021 07:24:18 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x15so78308720edv.1;
        Mon, 22 Nov 2021 07:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kOM0qPXgMgtTGgHrYy+KDZ8my8mEMs+38I4Uwfqs2QM=;
        b=i9SMmJQaT6Gu1toQl2rzJTjqE002TqMJ2xCj5SBDqWLfJg23yhNIe0anwPXOxFXYj6
         f5MUy80s5kA2Yu7Az8eKFJAljYr9ySKIbyQHPMTM7z3qx8dOjLBH50GACrHSxWIFA3RT
         8TcHCMdR8Cm9p3d1uxko8mBZHa9DptVSRFypPhE/Sid/D2xE9cU4uG2ONbQCpQwXfCYO
         R0HFS9zswylKaDtlj38fkZJW3fTQvrdrqHK6BwyeLAfX1QSwdnoLxTqfvnYpyqn9NFc/
         0xpV+2MicmEsQvQxmF6L3iGHRWFwvuwO0djjx7CiSWFBNIPW24e+o6mT405/CM53XVAM
         HrHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kOM0qPXgMgtTGgHrYy+KDZ8my8mEMs+38I4Uwfqs2QM=;
        b=yrkftSRZAQs0qW86xxHBtv35EupoY53hNUZYHM32pxFHZix+6lgEB+EmA+lYrdigIL
         uX19IZ3nG0GtTsSu0jqL2Ggmhw7lKkG9+B8P9PWS2PfdKAKYG81EFmOz/PdpC9T7yf1D
         WyLU0ocsWuU3KtjE6cexv4xcA2UaHd/6dpckDfmUkAtrwbR5py3TizIpWk0LHgTCvMqd
         /TSewNPHRuJ7wBu7sQJ7sDEWFtgezgBgMdA42sSpKWp0MfxVnw1LEI6ELG+u9JMF+gnF
         xwYrvLRB+gxoDOPeWqocuK0Flg+jRZbt4x+qr3rdPESO4mNtjvb2OhY/4EU21knnjDP7
         SnFQ==
X-Gm-Message-State: AOAM5326nYsTygoqDB/752GBxitffCH/EnWq+/LWQdCc92WVP9jfO/9Z
        94IBEaeQddGB3O7ZkRR52yY=
X-Google-Smtp-Source: ABdhPJyi5iqolrXkrxpdOf+ifDsUatfDboLgetu1YISz385bXT8VsgGafGpdRb9P1eLqZE/Eg+F1+w==
X-Received: by 2002:a17:906:3b18:: with SMTP id g24mr42615732ejf.27.1637594651814;
        Mon, 22 Nov 2021 07:24:11 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id sb19sm3995307ejc.120.2021.11.22.07.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:24:11 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 0/9] Multiple cleanup and feature for qca8k
Date:   Mon, 22 Nov 2021 16:23:39 +0100
Message-Id: <20211122152348.6634-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a reduced version of the old massive series.
Refer to the changelog to know what is removed from this.

We clean and convert the driver to GENMASK FIELD_PREP to clean multiple
use of various naming scheme. (example we have a mix of _MASK, _S _M,
and various name) The idea is to ""simplify"" and remove some shift and
data handling by using FIELD API. 
The patch contains various checkpatch warning and are ignored to not
create more mess in the header file. (fixing the too long line warning
would results in regs definition less readable)

We conver the driver to regmap API as ipq40xx SoC is based on the same
reg structure and we need to generilize the read/write access to split
the driver to commond and specific code.

The conversion to regmap is NOT done for the read/write/rmw operation,
the function are reworked to use the regmap helper instead.
This is done to keep the patch delta low but will come sooner or later
when the code will be split.
Any new feature will directly use the regmap helper and the reg
set/clear and the busy wait function are migrated to regmap helper as
the use of these function is low.

We also add a minor patch for MIB counter as qca8337 is missing 2 extra
counter, support for mdb and ageing settings.

v3:
- Try to reduce regmap conversion patch
v2:
- Move regmap init to sw_probe instead of moving switch id check.
- Removed LAGs, mirror extra features will come later in another
  smaller series.
- Squash 2 ageing patch
- Add more description about the regmap patch
- Rework mdb patch to do operation under the same lock

Ansuel Smith (9):
  net: dsa: qca8k: remove redundant check in parse_port_config
  net: dsa: qca8k: convert to GENMASK/FIELD_PREP/FIELD_GET
  net: dsa: qca8k: remove extra mutex_init in qca8k_setup
  net: dsa: qca8k: move regmap init in probe and set it mandatory
  net: dsa: qca8k: initial conversion to regmap helper
  net: dsa: qca8k: add additional MIB counter and make it dynamic
  net: dsa: qca8k: add support for port fast aging
  net: dsa: qca8k: add set_ageing_time support
  net: dsa: qca8k: add support for mdb_add/del

 drivers/net/dsa/qca8k.c | 381 +++++++++++++++++++++++++++-------------
 drivers/net/dsa/qca8k.h | 161 +++++++++--------
 2 files changed, 349 insertions(+), 193 deletions(-)

-- 
2.32.0

