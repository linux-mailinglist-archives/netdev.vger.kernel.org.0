Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136F9309974
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 01:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhAaAkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 19:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbhAaAkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 19:40:13 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39962C061573;
        Sat, 30 Jan 2021 16:39:33 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id g12so18653444ejf.8;
        Sat, 30 Jan 2021 16:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8emZ/+wsE6Y2IQlfPHKjyHe/TnMtAbs64va9Ainsf2g=;
        b=kaJ8pg6reY+C6iLzWJjRcGJZ9NqOq0AthZywh3MABCKnMmDLX12Utj1Mho4cRFY/nd
         NneVVBYmJIRcPpvf3UWvUhpRhFg77xx9vFKP7jXFgJg5RfXU3h9Xp3/LdMqaQjTVcTid
         hYoM90gxp67PuCzdC9mL/e9A6RlX0LXVe++gfesPyzFabU9xhtodeud8iLBziTcgi9Wm
         jntSOe61Ap9ESPmKgCkXRzKM9iMUVg3ROeRvtANMAvI4DDwqrwdaDYAryB7R+HKhTvPB
         nr73pN7JcBpOZPGezRpWbFctIvvvIv87HKd1kTAltkNtoUqL1OOGyNPQD1E+SMquXFWm
         auNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8emZ/+wsE6Y2IQlfPHKjyHe/TnMtAbs64va9Ainsf2g=;
        b=VnBKi8WfeCscCcwKINerCQBvrnkwR0FqmNRlj65R/Esor2MI/jV1xb3dxkf/JQNby7
         B9PzWkoM/PZvaZDjczazZrUy6MaidRcM8fVUDisAtt/KTSEmSIjB+dEp6oOuihtXnT04
         RUeBWCz1/LW3RyXjOaLb4wMSBW9A6Icb0Rf6i68ZHEdMn82mq+Eoo9mTzH51oW6aJzln
         j5jTBK8pDl3LR4eX9y9tLz2iucETtn6iZSMcX/kfXQ8nHjyA4Broq6jxmtMGOnyGS5hG
         gCDd394JYuUy+Gv1k4k3bwf1J1HQMl85HhkTfSkRVaMdvLfgXGOr8zUq7kZF94CnSncf
         UaYA==
X-Gm-Message-State: AOAM5337z4jnyKbGjIaRd5cKDVb/CD+Kcv+b9IMsk7zZcw6n2a4whomT
        OZMYuzp819hr3x6cT3CCfmg=
X-Google-Smtp-Source: ABdhPJx6xTXCf8+VgIXEPV6lTUEOMThXkecyGfIYkWoZ7cyvlOrL7ftJa2mWgXImyeEiT8RGUb9Ebg==
X-Received: by 2002:a17:906:8611:: with SMTP id o17mr11030650ejx.145.1612053571791;
        Sat, 30 Jan 2021 16:39:31 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b26sm6621984edy.57.2021.01.30.16.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 16:39:30 -0800 (PST)
Date:   Sun, 31 Jan 2021 02:39:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: override existent unicast
 portvec in port_fdb_add
Message-ID: <20210131003929.2rlr6pv5fu7vfldd@skbuf>
References: <20210130134334.10243-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210130134334.10243-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 09:43:34PM +0800, DENG Qingfang wrote:
> Having multiple destination ports for a unicast address does not make
> sense.
> Make port_db_load_purge override existent unicast portvec instead of
> adding a new port bit.
> 
> Fixes: 884729399260 ("net: dsa: mv88e6xxx: handle multiple ports in ATU")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Tobias has a point in a way too, you should get used to adding the
'master static' flags to your bridge fdb commands, otherwise weird
things like this could happen. The faulty code can only be triggered
when going through dsa_legacy_fdb_add, but it is still faulty
nonetheless.
