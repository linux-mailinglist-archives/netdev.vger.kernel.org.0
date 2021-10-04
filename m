Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626114205EA
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 08:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhJDGkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 02:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbhJDGkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 02:40:36 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FD7C061745
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 23:38:47 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id n8so11763741lfk.6
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 23:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=aYN7JB0UiIqnEd1up6VCc7D3bCgke8HG87B0yLPIHbQ=;
        b=3KZQJV5EcuDqFD+7ZT8pn9MvgEofIlfPhNr26kcfDN+qnwuwlD6z5NYBRdZafUfMR1
         L0c4hxxO3U6nD4F3jiLEPQqRyrfDIoxId5e2isueeuYjjkOyh8ORdURHD9UBhOEqiNve
         dO4/8gDAQJ9XxYEZ0xTO9ZYiqypv1QEf5koc6/e9U3MGZazPu6AwVob6l4JyMp2Eu9Vc
         hmzVShBvx1kEiuvi+1Omy/xZqoKjtkcT024vnK+DK1O6HXvBzRDxKoICHE8cbvG1SshZ
         EDtRziodmzge4XZr1cPphSdOjESJ6lddDk7sPQ+dzdqfjGsQ72ekFmmJ9cFnDyfY634w
         720Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aYN7JB0UiIqnEd1up6VCc7D3bCgke8HG87B0yLPIHbQ=;
        b=HRSKbWGcs/3TuqPqQRbp/u+T0uezcMaGtwuhmljMkrYvWaSa+rwPHewtAcNC2Oyh7E
         ywZll0BWyrgUl4vgd3YHn81tNgb4C2iSBNhCJqISo0QuNbKMPWN3MmOAsEPrzlWulYAX
         79fzpqnXQkN9M/vE+oDyqCYQIEkwISiGNB/ojuFDAVbMevbQDbyu36htLYPl4Vv4BVbA
         8SprZ1sTu8IXUWshbcgdF3m9qKiZo2grO7G2jcpeETSZg2nXveJszyIbAN/ED2Y31W4i
         lL8sb3G12ZBXdPu75Vmcqh8FfTU4si9m75x80gCenFljq/AcjJe4BXoGZ/AdQcpRuiTF
         DhZA==
X-Gm-Message-State: AOAM531KW6Hef8Gb4f7xDcLhuo/l1iJMJr5q3zdXbOlmAyGCxXCJiMvr
        dQ6w1Kr6MsxAN59TekGFk0eYtQ==
X-Google-Smtp-Source: ABdhPJxIafv9ONcjynwTZsDwanGVlOQpzaWn86HpS/46s38RZxy/el0NudM8vbls0F545a/wfkvSow==
X-Received: by 2002:a2e:711d:: with SMTP id m29mr13870217ljc.299.1633329525955;
        Sun, 03 Oct 2021 23:38:45 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id br38sm1512717lfb.305.2021.10.03.23.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 23:38:45 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net 0/2] DSA bridge TX forwarding offload fixes - part 1
In-Reply-To: <20211003222312.284175-1-vladimir.oltean@nxp.com>
References: <20211003222312.284175-1-vladimir.oltean@nxp.com>
Date:   Mon, 04 Oct 2021 08:38:44 +0200
Message-ID: <874k9xmgzv.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 01:23, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> This is part 1 of a series of fixes to the bridge TX forwarding offload
> feature introduced for v5.15. Sadly, the other fixes are so intrusive
> that they cannot be reasonably be sent to the "net" tree, as they also
> include API changes. So they are left as part 2 for net-next.

Please give me some time to test this before merging. My spider sense is
tingling.

Have you tried this (1) on a multi-chip system and (2) in a multi-bridge
setup?

--
Tobias
