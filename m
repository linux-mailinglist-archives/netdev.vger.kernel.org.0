Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997411B118A
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgDTQ1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728998AbgDTQ1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 12:27:52 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD26C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:27:51 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id u127so232753wmg.1
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NDQrL2gFYmpfi41JWwj3/SutzMlTw1xej/mNeMulLjk=;
        b=BBZIhAOMk74DX14MlMULaNJmczgXEuDrPDDF3t/0iyexpIJ7OAlUFwgoJu2FOVv6G/
         q91IWWmmbwi9vb0UUX0lRMshlmqT1kgq2Imdc1Z3zH5QJu4jDCtPJpiQM0Dv2cdCXD5S
         ZKnyoiUrNry4WaME0fwBNi1qCBs7EQadfVQZR5zO75m6+9j8E7SeKhSA4AXXoh6Sx8Zg
         4OVF+/G1V0CBXZJu+ECAHmKf6Bb+4CFqvSffTzLJm+SNMzfWrKBz8twt5Kb8AGBBISmG
         Y0OOrsXaP+UaaoCsekNQnhNkk+guXFeXmSDgZJfWItzOHe1Pddx7aDy3QMHVa51iFnxb
         QvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NDQrL2gFYmpfi41JWwj3/SutzMlTw1xej/mNeMulLjk=;
        b=ISVqQjNF0N/ZKyKRVelDek3N5Me2OSV4I/hUvj6aGZtgOG+vZOb5bS0E1DOdyfghuN
         A+XD6Kp2wJ34ndof2bCFeQkjICLZHRuC2i4CQp+rhqWWcxteaAsNEqcKLSCaly5cMo6n
         pcFvsDBFcW13a/t7bZEQBDnMMsLDYFWxif4PXwCDeIGoZpa9MQSQknc43eObHpzI+vgM
         n5ELLSpWGIjDAl+qxukCn6aqxe3kt6f4GAjbX0ISkgwcVMsQ1R8qqRTRZK2Ib+0/I6aG
         IeoHEa7te8OMY6ALu4f0dufFJ4gbBmLYzBQ5VLMIsBMblH7UdnzEyOdk7hEB4xJGioiq
         SF0A==
X-Gm-Message-State: AGi0PuanG2eThTFHjVs3Ws9G7BiG/7JHGYjWkigg4v4vmLrEngHnEUcI
        Rv54VXu+tRvoNdH3xe01RxlN9KIKXuw=
X-Google-Smtp-Source: APiQypKcmgnMZypo9VQQcwVG+Hw/cRJOXDHyQzL5MTMeH6RiCvegDtZxflw8V4NlAOlIOC9uDreabg==
X-Received: by 2002:a7b:c10d:: with SMTP id w13mr164961wmi.78.1587400069515;
        Mon, 20 Apr 2020 09:27:49 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id 185sm146245wmc.32.2020.04.20.09.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:27:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@idosch.org, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        kuba@kernel.org
Subject: [PATCH net-next 0/3] Ocelot MAC_ETYPE tc-flower key improvements
Date:   Mon, 20 Apr 2020 19:27:40 +0300
Message-Id: <20200420162743.15847-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As discussed in the comments surrounding this patch:
https://patchwork.ozlabs.org/project/netdev/patch/20200417190308.32598-1-olteanv@gmail.com/

the restrictions imposed on non-MAC_ETYPE rules were harsher than they
needed to be. IP, IPv6, ARP rules can still be added concurrently with
src_mac and dst_mac rules, as long as those MAC address rules do not ask
for an offending EtherType.

For that to actually be supported, we need to parse the EtherType from
the flower classification rule first.

Vladimir Oltean (3):
  net: mscc: ocelot: support matching on EtherType
  net: mscc: ocelot: refine the ocelot_ace_is_problematic_mac_etype
    function
  net: mscc: ocelot: lift protocol restriction for flow_match_eth_addrs
    keys

 drivers/net/ethernet/mscc/ocelot_ace.c    | 18 +++++++++++----
 drivers/net/ethernet/mscc/ocelot_flower.c | 27 ++++++++++++++++-------
 2 files changed, 33 insertions(+), 12 deletions(-)

-- 
2.17.1

