Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C473D34A9
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 08:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhGWFrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 01:47:13 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:59622
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233935AbhGWFrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 01:47:09 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id F2EE33F345
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 06:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627021662;
        bh=ScM5eUXjBnVPe8LbBTYSW47mZlMEZMzsEaWNVZaNkWQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=nsvN0ErA8WaW8/lOXcgd0q8rEbSTVwUA4Tq1e8CLkVWHSi9ztgt7RNj7e+oMzg2RK
         YF4eDjV+resTr3gBQVu8X1O9IW++zISGD6qp9QqB9dN8T0/t846pi2RrcMcPn33J1e
         Zt0eHxC0jWORsANSPjDWp5eOLSBgI88UYuLLjWwhv8eOl+q+xeCAo3sk2OAsDBwyZw
         MK0LgswaY3q/013vmIPCv55k7rTV/2Q8fhuLYMNdDIxD+PpQN9zI/xwnknqzXP6mjq
         lBeooBXCiz/q43F6bMcvXciSj1jTgsZyYtP/Omvzqdj2JQDbh0ACwYKXw2usycYU73
         zx34lpljRomPw==
Received: by mail-ed1-f72.google.com with SMTP id c20-20020a0564021014b029039994f9cab9so164185edu.22
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 23:27:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ScM5eUXjBnVPe8LbBTYSW47mZlMEZMzsEaWNVZaNkWQ=;
        b=UDEAOqFR2c9F7nc+jaHW5/upwnTTILhvrGT/iPby2xLwfU3BmyvTzyKFxgKlbwKCpF
         ponSbyM62dmWur1IGh2B9sder4eWyVI8A71zlm1aZEZT61QUN5T5XMxIWFvqQ+xvKzSR
         dUxpesgPhkUhS/zROsNlu/Cb0HmTOw4zDi/3+nw7OlRgNwEkO6Nb4gmYyhtAZQVd7dEc
         J15GGL+7VL+RGa5NoJ0mzz4jyIU0e8j2P4dzAUoYI9G3knd/BvnPGVOsRoVQwSdbgmcN
         FNeBGZNfxXXR9PSSUUIOl4hKI2LNlQOnwNPvtT8mSmeQgK7xQVmYAwXQ5nytNgdLUTPQ
         g0vQ==
X-Gm-Message-State: AOAM530Yf+DU/Y5xc75HwcJ+dpEAe1dfYgf2iz3ZjAyzhaopnnzepMC+
        MMorDTt8kRGvd/O2dLWG8nP+uTstypOeL1RI6vFL8zXb8Niq4keS888GU0V0KtVNBldtn905r55
        eaf/Zwy0emISO2AolzLWoEPhBY5HzVezXEQ==
X-Received: by 2002:a17:906:e0e:: with SMTP id l14mr3313195eji.501.1627021662758;
        Thu, 22 Jul 2021 23:27:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ+nyDEENcrVRLwr6YxB1sHYJA1zCxcGsDlpGPB37Ly4NJOfWs4Dn45abWgrRNkKKGjwgnGw==
X-Received: by 2002:a17:906:e0e:: with SMTP id l14mr3313181eji.501.1627021662625;
        Thu, 22 Jul 2021 23:27:42 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id u5sm13449844edv.64.2021.07.22.23.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 23:27:42 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-kernel@vger.kernel.org, linux-hwmon@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jean Delvare <jdelvare@suse.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: (subset) [PATCH 00/15] Fix some DT binding references at next-20210722
Date:   Fri, 23 Jul 2021 08:27:18 +0200
Message-Id: <162702163038.6229.12663832282139727924.b4-ty@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1626947923.git.mchehab+huawei@kernel.org>
References: <cover.1626947923.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Jul 2021 11:59:57 +0200, Mauro Carvalho Chehab wrote:
> Due to DT schema conversion to yaml, several references to dt-bindings got
> broken.
> 
> Update them.
> 
> Mauro Carvalho Chehab (15):
>   dt-bindings: mtd: update mtd-physmap.yaml reference
>   dt-bindings: firmware: update arm,scpi.yaml reference
>   dt-bindings: net: dsa: sja1105: update nxp,sja1105.yaml reference
>   MAINTAINERS: update mtd-physmap.yaml reference
>   MAINTAINERS: update arm,vic.yaml reference
>   MAINTAINERS: update aspeed,i2c.yaml reference
>   MAINTAINERS: update faraday,ftrtc010.yaml reference
>   MAINTAINERS: update fsl,fec.yaml reference
>   MAINTAINERS: update mtd-physmap.yaml reference
>   MAINTAINERS: update ti,am654-hbmc.yaml reference
>   MAINTAINERS: update ti,sci.yaml reference
>   MAINTAINERS: update gpio-zynq.yaml reference
>   MAINTAINERS: update arm,pl353-smc.yaml reference
>   MAINTAINERS: update intel,ixp46x-rng.yaml reference
>   MAINTAINERS: update nxp,imx8-jpeg.yaml reference
> 
> [...]

Applied, thanks!

[13/15] MAINTAINERS: update arm,pl353-smc.yaml reference
        commit: e460a86aab669e00c5952a7643665f3096fbfe27

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
