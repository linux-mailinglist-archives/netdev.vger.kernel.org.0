Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280C8453B30
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhKPUu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhKPUu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 15:50:27 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E6CC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 12:47:29 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id w29so190623wra.12
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 12:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:from:to
         :subject:content-transfer-encoding;
        bh=ZNsE3J7B6LaaSfBBrhxW9Hu4IrmRukTEGmTZ7qJ+5Vc=;
        b=oTXfNf8uXxRuUlLYzGiPYqHSmtrGoROzhtVOue4qHqYZAlo/qNaoRciLgblcelLIva
         hFBJLUhC9YuNPImxyGXQLo2Md+9dYjCN1rw5tund1JY/GQc/aBkkmQL+uzZynDeyMCPs
         AdCSbWFjyFCoW9rLAquarHBPz7MV/IgS5KSxq0O+Jgryss+DBl2zC4u4B3Ek3RQ1nfLc
         igI9eFJW2Ecpx8+WP7+7PvKu4XnsXNF3umjaJXN4M6kYAONZx4YxO0IdhdorrFLf6HFU
         Wpm+krabAoavsH8m74VWvOw7ro17dg5zwOszSCOQqS5ABQLupeVMrOTyeuDcC6Mw7tNV
         Lxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:to:subject:content-transfer-encoding;
        bh=ZNsE3J7B6LaaSfBBrhxW9Hu4IrmRukTEGmTZ7qJ+5Vc=;
        b=OWEQX/rSZ6lEp+VMUDCYq0Hw22PgcOmP1I3h5yv5WYPy6kwhHWrtmjyFxgm/IOgAHR
         jZKV043N4Z0KZew31Jpvn9fcXWynGZ7QolHH4ji5JPatApzuuBJvoRWtDxFBxGmBdmop
         N4p+AtehOA/RntUmDtzkBoWTEHFFBBu7kDN7Nfx4AdjlbBh250yHBJqkebHJo+GCIY/d
         RUyvGOUgSdvscAje5yl1U0CuxIh38i6Fv/U4vrayv+tS81mN1Z9qBOwEg0n4vW1cFKW/
         KjKYwvJ+FEwzcH33VPYXSiS42GH74vgh8j26qJHID1fFBycCJlbZpKkx6qaY+dEU6Hl6
         lZeA==
X-Gm-Message-State: AOAM532AYwwVZLWnLo2trzVOLw6iIFeBjg+zTecXT/BK9ktlsLnclpmB
        gqgmIrU/1CGN8TNQ09pwbKifmmSI6eY=
X-Google-Smtp-Source: ABdhPJyFZ6Sjl24+ewTNofl9F6/A8XN4oicl2Fu4uDE3DFt8MnEnw4lsfLCtMwxgocbaKYDRrX7aZQ==
X-Received: by 2002:adf:dd87:: with SMTP id x7mr12721377wrl.158.1637095648374;
        Tue, 16 Nov 2021 12:47:28 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:a8e5:fe9e:889d:6654? (p200300ea8f1a0f00a8e5fe9e889d6654.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:a8e5:fe9e:889d:6654])
        by smtp.googlemail.com with ESMTPSA id o63sm3664046wme.2.2021.11.16.12.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 12:47:27 -0800 (PST)
Message-ID: <82793a62-054b-75e1-d302-74375f61ae03@gmail.com>
Date:   Tue, 16 Nov 2021 21:47:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Set __LINK_STATE_NOCARRIER in register_netdevice() ?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quite some network drivers call netif_carrier_off() in their probe() function.
So I'm wondering whether we can/should add a
set_bit(__LINK_STATE_NOCARRIER, &dev->state)
to register_netdevice() and remove all these netif_carrier_off() calls.

Question is whether there's any scenario where a driver would depend on bit
__LINK_STATE_NOCARRIER being cleared after registering the netdevice
or where we want to preserve the state of this bit.
