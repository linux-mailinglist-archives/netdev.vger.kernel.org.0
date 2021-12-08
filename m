Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D5D46CB9E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243949AbhLHDoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239374AbhLHDoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:44:22 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CA4C061574;
        Tue,  7 Dec 2021 19:40:50 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id u17so1679213wrt.3;
        Tue, 07 Dec 2021 19:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xLdbS2DM5SiAQIeNKqEFYAZrG+r6tBhfKvhvGIX0tFU=;
        b=JUS02oW9cog8HsaRPcAPQQw0lkaSAd1qrzj3eCGmkNlTEwQDCG1ibHWGN7umqdT7CD
         y5Vnv6rYJthoNy3xedtULYLRM0NBiYK/CaT4Pool99WBM75F/MKF53mux/DSuTwcYvKE
         VjJdxRbni4oCwGIM9DwreUkRLH3jX9NjxVoUFfF73ARQ296xstIofJBpcW9rATgH+7ft
         iTYfwOYJ72xvKRjnX5FbQtCmD7ob0sXTVZW5L75jenBYlhQWR8TsNhh7WAZLG3UuEwtO
         AvRATtQoR/Pa9E3g27tVXciOXu9J1yUC9cZG4RzrwxorGRWHgZ0NTY7+4+/t1mUt0kXQ
         XpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xLdbS2DM5SiAQIeNKqEFYAZrG+r6tBhfKvhvGIX0tFU=;
        b=bAPjZHWxlLPq16CEKZaHw3yyg/EuD2IOgvLEqfABod5/n3uYEQKBkoMH8ipT2vu/zp
         6Ik+aU/bNx8Zrax1fOuKlCEZsUly/0m85CI4LVm3nupDQcGRyUzw0J7QQTy20b22BHZh
         OCI25ugNIhZFmeQ2OSNHiUbIeZpSo1RHGwldeF6dEAZVVCfzCsT/eHwAj4bJ2NHujmjM
         zgSQU9TVVEBOT1XVmlDN4RDtnxNtnGBMfCOCsOgV07+ZXbpR7v/BK+7EszpUBIJfTbAU
         sjagbtERZ67iJ1Cha+bBKwlUPl0OLTVSCQ8FzWmNBBwcRoaGILAZol/IVkDosRFJR5pa
         7c+Q==
X-Gm-Message-State: AOAM5334Yr27nxFQFhRnV71LDf5ddohZlnnYJgF4QBQTbvLnUafVtwY6
        MHNiuU8Mt2oO3toc649Vyao=
X-Google-Smtp-Source: ABdhPJwrBuGW9JddqRM+BeKfUhR7tN+zIMFZmLG95gtCBE9IQQCOfjD0bQaXtIjMnf/OIXYV7IDPtw==
X-Received: by 2002:a5d:4343:: with SMTP id u3mr57143744wrr.450.1638934849367;
        Tue, 07 Dec 2021 19:40:49 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v6sm4488944wmh.8.2021.12.07.19.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 19:40:49 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v2 0/8] Add support for qca8k mdio rw in Ethernet packet
Date:   Wed,  8 Dec 2021 04:40:32 +0100
Message-Id: <20211208034040.14457-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is still WIP and currently has some problem but I would love if
someone can give this a superficial review and answer to some problem
with this.

The main reason for this is that we notice some routing problem in the
switch and it seems assisted learning is needed. Considering mdio is
quite slow due to the indirect write using this Ethernet alternative way
seems to be quicker.

The qca8k switch supports a special way to pass mdio read/write request
using specially crafted Ethernet packet.
This works by putting some defined data in the Ethernet header where the
mac source and dst should be placed. The Ethernet type header is set to qca
header and is set to a mdio read/write type.
This is used to communicate to the switch that this is a special packet
and should be parsed differently.

Current implementation of this use completion API to wait for the packet
to be processed by the tagger and has a timeout that fallback to the
legacy mdio way and mutex to enforce one transaction at time.

Here I list the main concern I have about this:
- Is the changes done to the tagger acceptable? (moving stuff to global
  include)
- Is it correct to put the skb generation code in the qca8k source?
- Is the changes generally correct? (referring to how this is
  implemented with part of the implementation split between the tagger
  and the driver)

I still have to find a solution to a slowdown problem and this is where
I would love to get some hint.
Currently I still didn't find a good way to understand when the tagger
starts to accept packets and because of this the initial setup is slow
as every completion timeouts. Am I missing something or is there a way
to check for this?
After the initial slowdown, as soon as the cpu port is ready and starts
to accept packet, every transaction is near instant and no completion
timeouts.

As I said this is still WIP but it does work correctly aside from the
initial slowdown problem. (the slowdown is in the first port init and at
the first port init... from port 2 the tagger starts to accept packet
and this starts to work)

Additional changes to the original implementation:

We now have connect()/disconnect() ops for the tagger. They are used to
allocate priv data in the dsa priv. The header still has to be put in
global include to make it usable by a dsa driver.
They are called when the tag is connect to the dst and the data is freed
using discconect on tagger change.

(if someone wonder why the bind function is put at in the general setup
function it's because tag is set in the cpu port where the notifier is
still not available and we require the notifier to sen the
tag_proto_connect() event.

We now have a tag_proto_connect() for the dsa driver used to put
additional data in the tagger priv (that is actually the dsa priv).
This is called using a switch event DSA_NOTIFIER_TAG_PROTO_CONNECT.
Current use for this is adding handler for the Ethernet packet to keep
the tagger code as dumb as possible.

From what I read in the old series we probably need to drop the priv and
move to a more specific use to prevent any abuse... (or actually just
add an additional priv just for the tagger to prevent any breakage by
removing priv from dsa_port)

I still didn't investigate the slowdown problem that is still present in
some part when the port are actually init.

Hope Andrew is not too angry about this implementation but it seems
flexible and not that bad.

(also in the current code I assume a tagger is always present. This
should be the case or a check if the tagger is not present is needed?)

Also still have to work on the autocast handler but it's really a
function to add with the current implementation. Tagger is already have
support to handle them.

v2:
- Address all suggestion from Vladimir.
  Try to generilize this with connect/disconnect function from the
  tagger and tag_proto_connect for the driver.

Ansuel Smith (8):
  net: das: Introduce support for tagger private data control
  net: dsa: Permit dsa driver to configure additional tagger data
  net: dsa: tag_qca: convert to FIELD macro
  net: dsa: tag_qca: move define to include linux/dsa
  net: dsa: tag_qca: add define for mdio read/write in ethernet packet
  net: dsa: tag_qca: Add support for handling Ethernet mdio and MIB
    packet
  net: dsa: qca8k: Add support for mdio read/write in Ethernet packet
  net: dsa: qca8k: cache lo and hi for mdio write

 drivers/net/dsa/qca8k.c     | 263 +++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h     |   4 +
 include/linux/dsa/tag_qca.h |  79 +++++++++++
 include/net/dsa.h           |  11 ++
 net/dsa/dsa2.c              |  37 +++++
 net/dsa/dsa_priv.h          |   1 +
 net/dsa/switch.c            |  14 ++
 net/dsa/tag_qca.c           |  90 ++++++++----
 8 files changed, 464 insertions(+), 35 deletions(-)
 create mode 100644 include/linux/dsa/tag_qca.h

-- 
2.32.0

