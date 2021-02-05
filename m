Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6833114E7
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhBEWSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhBEOcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:32:16 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB2DC061221;
        Fri,  5 Feb 2021 08:08:58 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id i8so12708350ejc.7;
        Fri, 05 Feb 2021 08:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R5nFxy4Bvc9UqP6WzBzfQTEG0FAeu+haMx96np+omMo=;
        b=SkxTl7dg4/kQ6/uVdbjzPLlZhbFct6rOQUDHs7fnd78QqqRcYZQeeipCWfupHF40pk
         i5zDi4j51nwMspV+Ow/eO0GiLnR5XPb+X4M0L3l2Ax/rMw9ifSnz2b2T5vPGo8jOWbPk
         4ZlRaG6c3VAVb3WLshQ/b7lJJzRbnjX/w9y3nA1wMSz7q/V7O6oIf/XHzcWHJlUWF96M
         /Vv+rcACbpcODuNULltUHIBftCbbFDyxJcylH/EZVlYJRK18WGujg1vUA+yLJ1w8Oedp
         1i+Pt4MPOnJm+ahJPOEnW4td06UAcQg/JBZadILWbguPMGU2Ur1QpSzXYWb9yPaI1f9e
         w1NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R5nFxy4Bvc9UqP6WzBzfQTEG0FAeu+haMx96np+omMo=;
        b=lqw7579UQlVrb3Zvln/DLdQjSaor/GLJn+MEtFqHU2jDnGO9HslJ6UCJA+8xRLT3RE
         Wuh7pOjlB2olMmFtGOgzDL7KKNwZR/Yjd7CWLFPp9y6YmlhwqcixW+jZDoiu8hn44MNP
         sUtxj12836RWb7e8aYO4/HH1lIP2BHanLreSFLSYJF3JgsmHwkNcpn8T5TreLwvRLh7d
         z3/AvmQsa9bZviCMofrTcmhUBYaieinHhU3tiUFIGcXNUQV0ReHb86Mxy/FJc84mSPGO
         0XhZQNTppAg6tZ2X0rqKa4TASZfJudBx7qi4aBVixx4Hh1jJKthwgQlMLbo7ZtPHwMKe
         IaxA==
X-Gm-Message-State: AOAM530UPSsvxPLX3pxr2LmqGaPn+aPGaLeVJyv4HVXNQ32W3vJsh8nx
        DOylBMyZLeBAOh/h+GcbkHMFhUpKOlM=
X-Google-Smtp-Source: ABdhPJzYRW8GhrE8ij2ocDjjNLxXXtdRxY7LnssUqIvtP9+m2iGf6DAPG4l5T7OAzKWfzgoSTObIUQ==
X-Received: by 2002:a17:906:3484:: with SMTP id g4mr4159438ejb.38.1612534185720;
        Fri, 05 Feb 2021 06:09:45 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id zk6sm4019325ejb.119.2021.02.05.06.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:09:44 -0800 (PST)
Date:   Fri, 5 Feb 2021 16:09:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org, Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/7] net: marvell: prestera: move netdev
 topology validation to prestera_main
Message-ID: <20210205140943.6c6l2z2v453oteov@skbuf>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
 <20210203165458.28717-5-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203165458.28717-5-vadym.kochan@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 06:54:55PM +0200, Vadym Kochan wrote:
> Move handling of PRECHANGEUPPER event from prestera_switchdev to
> prestera_main which is responsible for basic netdev events handling
> and routing them to related module.
> 
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
