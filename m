Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5099F407921
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 17:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhIKPmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 11:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhIKPmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 11:42:11 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B84AC061574;
        Sat, 11 Sep 2021 08:40:58 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id kt8so10677665ejb.13;
        Sat, 11 Sep 2021 08:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sAFNqrTSWiT0vsQafb7aIZgEw5AJOV83yB1qrdk4MXQ=;
        b=GwagWNNVvHIMZZoMHqmA5YtkS0dqGKpDGcp8JLU0+QfsUR5DuxJvkqmqmI4mgAQU0h
         6xt9L4iMSFgYzRp7df9KSbt873XBBbqpsk4YXS95N1hG+DXswb1rIHFTPOHU14Qkq3D4
         22kR1Ve813yyD5VNV5A7RGUjxmZqZEKe49CWwKbBrlPVXEy5j1ARKV3YazGnJHlHlBzY
         Y+T/ajBLr7HrXU/3+1QbmoZ7UXGBMKPsRpgrn/FAsm7XkwkfJGqSUl0b6KKeCkC7tFeV
         1rim1EHmMhlbcBhfa8idXRovWAFwJib2n0JwPVLF/VvHQNI2Xc8fklfwELwBtAbQkTYt
         qicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sAFNqrTSWiT0vsQafb7aIZgEw5AJOV83yB1qrdk4MXQ=;
        b=glHP4c0XNkEjPvIXaABcnQZo27Inqt2nydr1srDDHw/zgPV9arnUo9a+OYbtl3NTZB
         lx9c4THZPXoDoBiAfkOMsuwQjKtOBRyLZK+1nJQ8She0yKbySCEMe+D2T1ClO8XFXVCx
         ehmfZc9eoz+FwOid7+F8h7vAy3nZzAcRVyObFDQK3Ox4zK8snMZcVVb3lK/61Pp1niPD
         EAmRmFEs2CNXv3SsqK9vaUtRHUb2bRwIQUgv1htbHgTKAZIyWN2ujsohKNk58V03Bn0T
         0OZmIEcIuOWuF1omMIIfMbi1VsSHcy4XuH7ARmWriRYJa6acWzJVA/+Nvjvb2WI6xn9F
         XtJg==
X-Gm-Message-State: AOAM533liyoAYLCs9hwGI2Cr690SOKFBBTuO4AgBGuxrypIr3HWUK02I
        5ng5sjR2JcS8z6r/yiFdWZdLjLsS1IBKDA==
X-Google-Smtp-Source: ABdhPJw5MpejuscxpkDzAnmnqcWUirlhme6FUjeR9ceMHrVQvfHptsmGVV8ziLWetZpQufOoTNSLjQ==
X-Received: by 2002:a17:907:1113:: with SMTP id qu19mr3388939ejb.524.1631374857159;
        Sat, 11 Sep 2021 08:40:57 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id cr9sm1072975edb.17.2021.09.11.08.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 08:40:56 -0700 (PDT)
Date:   Sat, 11 Sep 2021 18:40:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: qca8k: fix kernel panic with legacy mdio
 mapping
Message-ID: <20210911154055.rzlresshnug6rshh@skbuf>
References: <20210911150731.16586-1-ansuelsmth@gmail.com>
 <5ec1a416-45e5-4679-9aa4-aa96b7f738b0@gmail.com>
 <YTzNCGutVkKZJz3t@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTzNCGutVkKZJz3t@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 11, 2021 at 05:36:40PM +0200, Ansuel Smith wrote:
> > > +static int
> > > +qca8k_internal_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
> > > +{
> > > +	struct qca8k_priv *priv = salve_bus->priv;
> > 
> > You are only moving code here but while at it, mind fixing that typo?
> >
> 
> I think I didn't understand what you mean here.
> Sure I will fix the typo and sorry about it.
> Aside from that anything wrong with the 2 new function or there is a
> better fix that I can't think of.

"salve" is "hello" in Italian, and even though that is a greeting,
surely that is not what was meant, but rather "slave". So even though
that is less positive, it is at least a technical term with a clear
meaning, so I think Florian's request was to replace "salve" with
"slave" while you are moving the code anyway.
