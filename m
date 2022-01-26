Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4520149C736
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiAZKOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiAZKOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 05:14:50 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE078C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 02:14:49 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id n8so21665740lfq.4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 02:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=UOo5cvIiZREl6uP4YcssGwlg61ZqPc8mTlvnFID9fEQ=;
        b=UffQtYPeKWeMguTgswjaF8k6ATapFmbcZxHcHXKuu+HvsDZpLcW/uoE0wZCgX2/EVY
         GUovQd7iWCf/EB9/cw4Oavn+io0PloJtEqdAQkgi8AR7HN73lEhyj05tMMDP96C5GWGd
         NJVvNKbaZJatCQN5VFPzhVnttYHvDqk3Q4kVi+d1ysQ9BaP85luwjkMOJnKNVib0hRm8
         fo9UVKZlwZ3JiLx70VttbRSzj5MaxQIggEx4zHmEc4gWOJ+9cNtUbbO9956HQF6WOr2l
         ev5JJY8b/v8XOJZirVhc4SYMeeNIBaxzLGufZF3XKRq3z/enKBZOOVUkcJoI9zLF7DqN
         C9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=UOo5cvIiZREl6uP4YcssGwlg61ZqPc8mTlvnFID9fEQ=;
        b=yru0RcLZzI1UgeDXMPm9IKXZK5ms2Sjs7W3k9cyoePcUYJxLAZNLZtMHrGzzQxVMHu
         bdTe6Mf9K1Zqp9WqJ8w2/vFuAhKsZF6hbYSX3JLWyn847LlnvTx63bpyaSJ9i90LnPj9
         LqCldaxGT6Bgo36uFRk1X7d9IRCvoCzR8fewgblVR+86SlXgJAI7yzag8udzcXqgCDqE
         ksrJ2EsZeeVU5ZLOsQyy0yFgRV/bkcNr1mTat+q3CWgEVyRZLUZOJybuocrkMEoJmCPA
         VRqLf0oJM9gZU4AB0kUknUOZFXDgU4oYGdC4MofUsLcEXK5roob5cV0jvxNLAjVeqHKH
         huRA==
X-Gm-Message-State: AOAM531ANyGxA/AoyJbRpOhtTk4TpK+aQigspgCEo+wRzF5UO7aJIfgL
        pSb0v2ejv+vcItZl9ZQs9+yrzcLPPyjNTQ==
X-Google-Smtp-Source: ABdhPJwmo80IoFsQhYIXxm3NWigQZv33LC/Wq/gPmzb3oCzixpKpK4dmscAYukmxXcpsYljTyNSz9g==
X-Received: by 2002:a05:6512:77:: with SMTP id i23mr4088981lfo.24.1643192087968;
        Wed, 26 Jan 2022 02:14:47 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id h13sm1351906lfv.100.2022.01.26.02.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 02:14:47 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/5] net/fsl: xgmac_mdio: Preamble suppression and custom MDC frequencies
Date:   Wed, 26 Jan 2022 11:14:27 +0100
Message-Id: <20220126101432.822818-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch removes the docs for a binding that has never been
supported by the driver as far as I can see. This is a bit of a
mystery to me, maybe Freescale/NXP had/has support for it in an
internal version?

We then start working on the xgmac_mdio driver, converting the driver
to exclusively use managed resources, thereby simplifying the error
paths. Suggested by Andrew.

Preamble suppression is then added, followed by MDC frequency
customization. Neither code will change any bits if the corresponding
dt properties are not specified, so as to not trample on any setup
done by the bootloader, which boards might have relied on up to now.

Finally, we document the new bindings.

Tested on a T1023 based board.

Tobias Waldekranz (5):
  dt-bindings: net: xgmac_mdio: Remove unsupported "bus-frequency"
  net/fsl: xgmac_mdio: Use managed device resources
  net/fsl: xgmac_mdio: Support preamble suppression
  net/fsl: xgmac_mdio: Support setting the MDC frequency
  dt-bindings: net: xgmac_mdio: Add "clock-frequency" and
    "suppress-preamble"

 .../devicetree/bindings/net/fsl-fman.txt      | 22 +++--
 drivers/net/ethernet/freescale/xgmac_mdio.c   | 88 ++++++++++++-------
 2 files changed, 74 insertions(+), 36 deletions(-)

-- 
2.25.1

