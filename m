Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0164E3050E0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238888AbhA0E3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317604AbhA0BHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 20:07:53 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27E8C061573;
        Tue, 26 Jan 2021 17:07:06 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id a9so266162wrt.5;
        Tue, 26 Jan 2021 17:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=B5R3QKdstmOElf5fyDxWW24vlZ4mw418UdwCjmrTNw8=;
        b=Z4YB+eoj4dpO8IXUSmdZ7YShVtI3aIRk4c+5ZYNuMydczpwlhasu/mQT8yKLlZykP9
         TlgFk1pzn3UecTjVqrzRHuxAxfk4uOYdquxXcP0lqhqbbswB2Qf7JTNFo8RGm4HV35YF
         mDnel8nvv3GAQG12eEsjsEF6i5xn+W2Ivr6Vg9jA6iAYu4N8dM7zY+LacXCPVROVFVtx
         LJabYOvWu27SexyVbmqDtidXtfxg9cqsYT/0MSGVTSMHbvb7Ggv1M2kDbV++AFnPDj0q
         FQ+r3YdVt+vNcxGdGwNOEyWyUFBfeKgk4dJq6q0m/8HdkLD1tNE7+BFPRNa6kyDkACYC
         PM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B5R3QKdstmOElf5fyDxWW24vlZ4mw418UdwCjmrTNw8=;
        b=b3bCC4G63Vjo3hduR/JjhFhOjUaIgo94RBCdk9LTLIK0okjGZkoTDtsozs9byE8rR3
         emJJbE8eANTGlrFcayU6VXFZKC9Lpeoh/b9VerpvrJ0dxo00vy2rPSG5mexf9HjO5Ydd
         5mE87Dfu08zheDFdylhLU40NvkFFwkFDANREHeEQNaB5QGeHaZztS793UAWJiCA4DFAm
         Lt0x6khskHH5e9vxYKajA0MQicxuxNOHKt9vr94mbwNEEPJj2rdPKBgsV4MG0Q9CQUP4
         Los5Ew5s6b6Rw9JulMURsYUNF+ZfBHSXLuHJBll6xtAulD6j0p8MVQXlUhTTh0rRtnL1
         baRw==
X-Gm-Message-State: AOAM530mCkjMlOTUeRWbfXeRYFV9wCFfBuYC1vJOgxn3XDhj7dHr335t
        XHjHDzae7vNR70t5faK+bwY=
X-Google-Smtp-Source: ABdhPJz3clA3gFRXJd1XiDHtqB8JzibeH9n0ObM9qv7LZiL53dynUjYfroydzjEstpnHj93VuvrFfg==
X-Received: by 2002:a5d:4e47:: with SMTP id r7mr8715704wrt.312.1611709625644;
        Tue, 26 Jan 2021 17:07:05 -0800 (PST)
Received: from localhost.localdomain (host-82-61-142-146.retail.telecomitalia.it. [82.61.142.146])
        by smtp.gmail.com with ESMTPSA id w126sm394289wma.43.2021.01.26.17.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 17:07:05 -0800 (PST)
From:   Lorenzo Carletti <lorenzo.carletti98@gmail.com>
To:     linus.walleij@linaro.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Carletti <lorenzo.carletti98@gmail.com>
Subject: [PATCH V2 0/1] net: dsa: rtl8366rb: change type of jam tables
Date:   Wed, 27 Jan 2021 02:06:31 +0100
Message-Id: <20210127010632.23790-1-lorenzo.carletti98@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was trying to see if there were some Intel 8051 instructions in the
jam tables with Linus Walleij, when I noticed some oddities.
This patch's aim is to make the code more consistent and more similar
to the vendor's original source.
Link to the Realtek code the actual patch is based on:
https://svn.dd-wrt.com/browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb/rtl8366rb_api.c

Changes V1 -> V2:
 - Used struct array for jam tables instead of u16 matrixes
   (Thanks to Vladimir Oltean <olteanv@gmail.com> for the suggestion

Lorenzo Carletti (1):
  net: dsa: rtl8366rb: standardize init jam tables

 drivers/net/dsa/rtl8366rb.c | 273 ++++++++++++++++++------------------
 1 file changed, 139 insertions(+), 134 deletions(-)

-- 
2.17.1

