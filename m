Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A46655F482
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 05:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiF2Dyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiF2Dyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:54:46 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AF025EB2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 20:54:45 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-fb6b4da1dfso19805231fac.4
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 20:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q7GNFMTS9DqZwcZdyGaE/7vf3HHyw0LHD0zHR91H9nk=;
        b=Py3qQVEMTCvvTZNcuJ+1nLN+bATfKi0W3oPxhjwJN3x0u/cNbz1uGE4VZmsoOSF2TH
         XL1AltzV1C0p3xCo/DTfQDrKLECN4e9nOMd5qZumsrrt9gYTpq7JS07Q1QvaHTopq0m7
         5F2RH45z+k6XcxDZmFo4hWoTRKt51+dc7MIBBgT7QCYrO8W+tiHo6kDdwPAp9JqKXeC1
         b64uDEDmHp28/Zu++Jy5Uw77rjlNOf+ougXcMIMIsRFTQcCKWiSym4NnLEnPf6l47K28
         za8yZCPZI5KHWhlXwDGxkbTnTuCFqpuTU/VUAc6+fSdQQPtaIerW5tV6elZScTWf63Tf
         S94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q7GNFMTS9DqZwcZdyGaE/7vf3HHyw0LHD0zHR91H9nk=;
        b=OQhF86Xipw8ucC638dHPsuS22LsySvNgCcrdeyhO9dk4Cbp7oegHgsRfvkGAGP/J2l
         xq/CmLLdxkwlPeJtPNs9Ug20ddusmvEH5wHxm9hb7QduFZ5pXeOONhMFq5+hat5+MP88
         F+hpeKMIPKVMXXAmOgmF1d6nsxTl8otYTB/OxFBjE358xGokHMGVWJl9G5CUTFaIwdw/
         bMUWWq8L0awE04MiQjooCkLstXFKh5NgBLXH7u/dqdVvjx1WUAoP0zEhtMdQs/9k0RtZ
         2nTvbu7lKdK5SlRzNdO7KxvIeoP7gT7Tc1BtjXluC/cOz2C8h03QQr6JxclhbE2hIebA
         h37A==
X-Gm-Message-State: AJIora+k630ZCdRjiTb4OL9aLYSlkBpMT/Oy4Tez1MHUO1W7IhCkqu3x
        Y/6CHrmfHISJifQFdbd+FdEXQHOV7Q1KLw==
X-Google-Smtp-Source: AGRyM1tIv6m57iyiUic4VwR/NyT7h/4Z+K9WNG1/O8TE9DUxd8VkayU21IC7xCkRscP3juRd5YxIAw==
X-Received: by 2002:a05:6870:310c:b0:101:e7e4:891 with SMTP id v12-20020a056870310c00b00101e7e40891mr1773081oaa.65.1656474884453;
        Tue, 28 Jun 2022 20:54:44 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id r6-20020a056870580600b001089aef1815sm5636756oap.20.2022.06.28.20.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 20:54:42 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com
Subject: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave MII
Date:   Wed, 29 Jun 2022 00:54:31 -0300
Message-Id: <20220629035434.1891-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last patch cleans all the deprecated code while keeping the kernel
messages. However, if there is no "mdio" node but there is a node with
the old compatible stings "realtek,smi-mdio", it will show an error. It
should still work but it will use polling instead of interruptions.

My idea, if accepted, is to submit patches 1 and 2 now. After a
reasonable period, submit patch 3.

I don't have an SMI-connected device and I'm asking for testers. It
would be nice to test the first 2 patches with:
1) "mdio" without a compatible string. It should work without warnings.
2) "mdio" with a compatible string. It should work with a warning asking
to remove the compatible string
3) "xxx" node with compatible string. It should work with a warning
asking to rename "xxx" to "mdio" and remove the compatible string

In all those cases, the switch should still keep using interruptions.

After that, the last patch can be applied. The same tests can be
performed:
1) "mdio" without a compatible string. It should work without warnings.
2) "mdio" with a compatible string. It should work with a warning asking
to remove the compatible string
3) "xxx" node with compatible string. It should work with an error
asking to rename "xxx" to "mdio" and remove the compatible string. The
switch will use polling instead of interruptions.

This series might inspire other drivers as well. Currently, most dsa
driver implements a custom slave mii, normally only defining a
phy_{read,write} and loading properties from an "mdio" OF node. Since
fe7324b932, dsa generic code can do all that if the mdio node is named
"mdio".  I believe most drivers could simply drop their slave mii
implementations and add phy_{read,write} to the dsa_switch_ops. For
drivers that look for an "mdio-like" node using a compatible string, it
might need some type of transition to let vendors update their OF tree.

Regards,

Luiz


