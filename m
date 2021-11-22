Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5683E458796
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhKVBHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhKVBHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:07:06 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830A5C061574;
        Sun, 21 Nov 2021 17:04:00 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r11so69415125edd.9;
        Sun, 21 Nov 2021 17:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gxmB8dk1bz7zmKQVCzKKLpaiao8zgvDTsHhydlyERpE=;
        b=nSCP9hyjSAWR/wqh1k2oUfebhH5q4nashvrve0s5MJ8zKr121qJGAi+k80IwzGBMKs
         qMuf39c77zbrxVYrzHLj3Uo97cPcJdjJZhKkqNkPChQMobj7Gpuk7rEhdDh5XkrcPQcA
         e+M+/nFnNmf3uAUeYignzWVrAJeOMvKdXtHVh7jJuFCx+CH3RHm9AA4xte87s36ejfVz
         mxjxJlZGpYiwKARshIdnKVb3zyGjW4UK0OWs+dt9ZEnCGW1/hgd9ayfsvjVcR7T1abZD
         cnq0FmbEr0EVjNQ3aQFmaowBee7CfAsZ5yEsaYEWc4O1UWVsUMPg5TFqVruAFzoTcmim
         sa4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gxmB8dk1bz7zmKQVCzKKLpaiao8zgvDTsHhydlyERpE=;
        b=Zz3s4R3zyAU4H4bhST3UsJMEGcMlZIgFl8CKJ7MRsbYwkFJBtDCW60K2CRawWgdqVj
         J+uy2+7Ga50haOhk+YR740Yrr2nRCKS14UmoifiCBiWoSop8cLmVcrlwga7I5xWEI5Gl
         TONJbpUGujdHZwbFntev9kPLTP1cdMlNx1HBjQae/qcGxLT2VcgtRRzxZlUr9twHnThR
         KMBeGTgu3RswzNWfkEULNj039IjoGlYg7yDL2lGLOJ+SrY2B5JojCGr/mlPIE3JZhK8A
         nHy9vhb6cD0wEGkFvpnHjVSgeXgYBE4KZvLHr0xrln/i4u+34Ldb85uzWOg6TKFiw7kI
         KHFQ==
X-Gm-Message-State: AOAM531zRhGOeV9TybK3Oz/oRrU8YNSTnvNgRhSa2ppmyNWa+XERyon0
        FCQH0iosgwcTv4d/I/dYDro=
X-Google-Smtp-Source: ABdhPJyTMsqFB00XneZPk568dFfodH66aqA+1ZXG71pU5MW6vYZdcIFtk+xKxrdcosJ9OnGidTy5ag==
X-Received: by 2002:a17:906:58d3:: with SMTP id e19mr35121642ejs.350.1637543038933;
        Sun, 21 Nov 2021 17:03:58 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id c8sm3208684edu.60.2021.11.21.17.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:03:58 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 0/9] Multiple cleanup and feature for qca8k
Date:   Mon, 22 Nov 2021 02:03:04 +0100
Message-Id: <20211122010313.24944-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a reduced version of the old massive series.
Refer to the changelog to know what is removed from this.

THIS IS BASED ON net-next WITH THE 2 FIXES FROM net ALREADY REVIEWED
net: dsa: qca8k: fix MTU calculation
net: dsa: qca8k: fix internal delay applied to the wrong PAD config

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

We also add a minor patch for MIB counter as qca8337 is missing 2 extra
counter, support for mdb and ageing settings.

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
  net: dsa: qca8k: convert qca8k to regmap helper
  net: dsa: qca8k: add additional MIB counter and make it dynamic
  net: dsa: qca8k: add support for port fast aging
  net: dsa: qca8k: add set_ageing_time support
  net: dsa: qca8k: add support for mdb_add/del

 drivers/net/dsa/qca8k.c | 531 ++++++++++++++++++++++++----------------
 drivers/net/dsa/qca8k.h | 161 ++++++------
 2 files changed, 416 insertions(+), 276 deletions(-)

-- 
2.32.0

