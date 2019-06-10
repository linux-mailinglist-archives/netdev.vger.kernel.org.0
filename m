Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EAA3B881
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 17:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391286AbfFJPug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 11:50:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55201 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390646AbfFJPuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 11:50:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id g135so8945761wme.4;
        Mon, 10 Jun 2019 08:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j0cvrW0LiR2yAWHacC+paieH/BsPhO653fx0ilOqwbQ=;
        b=XrYcjT7N66H7PZl89qVvjkYy2lcUUR+p2y5QlMqTrKSYLfpAHr+5bhPvrKUDoDW2Gn
         gc8KQUOivmTgSCQR5PIvdxh3Np5UEb4HOX5Y/TgrcVFjLu1N/l6ZRZHcLQwZoZkFB2PK
         dnHDV+JZ8jRZwikhp0mK3D3c9YrIoYwTbrv+XI3t6hXqkMvOg/CU3HdRVKBqqbiWsoYb
         ZmrGKLaXtkNsJEc6GlFos05req6azeUDaSh/0lsYh1U2oaNxBegmv6xh+NlQSfkKDqss
         qqcF/nZdT+NcxD5fD2IRb0hwvT8zPzyEN97nHCywHGtE8NnApD9T/+hYylByZ803tbq9
         bqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j0cvrW0LiR2yAWHacC+paieH/BsPhO653fx0ilOqwbQ=;
        b=LkyJM7Ptyd/XBfWaoPqtCtqgopS07+Epo331Ng7gcCzqHfFZpJ5WbIUBVhRFCgUo7u
         MCUPiUu+O56UU+rZkJBXvaqdnj3ZP/Cn62z6AyCuZSxxhrlUCnpN7ZMGPIWPNtFkOYEx
         o6U3gczVSBh3lRSOq54TSOepTxjQnPvJJARfYAfINEB1kk9yd7x4aLT6l3WxH0fQ9KYg
         ++PS5jzF45lg/vJSrs4jWXLPXgJwwlqOO5FKfEW+TNp7rB4dYIGGKxJLMOzqVNANVmUY
         M7aV47kLa25rj14tjANt2klsGj1yPsyRthOfcBE7iHABmSomAO6ckMejQHBF45E95WW7
         Br+g==
X-Gm-Message-State: APjAAAULBbIs9GAJbGSogXdn4YBVUJjTplAwQDRXFoch/BAKpow+SXcB
        RJFbLF74A/5r8pzLVd+HbCQ=
X-Google-Smtp-Source: APXvYqzLna+aVnK3OUUKYltUUrEa4DJqameWzsVBUOMurnw3ZFvBDcb4Rdm+t6M1JqO46Sv5jxt2fg==
X-Received: by 2002:a7b:c751:: with SMTP id w17mr14836813wmk.127.1560181833344;
        Mon, 10 Jun 2019 08:50:33 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA40000C4C39937FBD289.dip0.t-ipconnect.de. [2003:f1:33dd:a400:c4:c399:37fb:d289])
        by smtp.googlemail.com with ESMTPSA id z17sm9711917wru.21.2019.06.10.08.50.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 08:50:32 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>, netdev@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: RE: [PATCH v2 10/11] dt-bindings: net: dwmac: Deprecate the PHY reset properties
Date:   Mon, 10 Jun 2019 17:50:11 +0200
Message-Id: <20190610155011.4305-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <ff6306c71a6b6ad174007f9f2823499d3093e21c.1560158667.git-series.maxime.ripard@bootlin.com>
References: <ff6306c71a6b6ad174007f9f2823499d3093e21c.1560158667.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Even though the DWMAC driver uses some driver specific properties, the PHY
> core has a bunch of generic properties and can deal with them nicely.
> 
> Let's deprecate our specific properties.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
I am not sure about the yaml syntax for deprecated properties but
the description inside the .yaml file looks good to me so:
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
