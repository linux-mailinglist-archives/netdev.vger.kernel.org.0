Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FC74585C3
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 19:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhKUSHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhKUSHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 13:07:07 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD84C061574;
        Sun, 21 Nov 2021 10:04:02 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w1so66669855edc.6;
        Sun, 21 Nov 2021 10:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1LdVT6NYneTu6nnRmAMLQEopOuPlGvl148MWOysuFzk=;
        b=PBOnNLjyELMnUsjOD+drQLDyKINxy6j+vrcSSzjXW3usEqJJZlRyGimMbu3b6okHrl
         8/d58s7eVrHtXS67a0pnokIhBkbNmdeZi6zcRyee1Vt2xz/wg+FV7q6/jwmEs2K16tNa
         35aA0emBZFcZlezTHnK95o5eBiLf0x8PWeYBck0c3I/NseT9TYRV7qUGN9+yraKVdQOE
         EcjPftGivl9gXUuC7XXyOPeSpm1kvXdtFf8W2gFrX7tOm2VofpM4pnYORLvDvf2VdEGK
         htZHQPGTqkeKp8Yx3GtYfBhuKBKrrLbQzcUz5bRJnAMw5LVD3Osyuq7QS5LNbmFytUKI
         zUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1LdVT6NYneTu6nnRmAMLQEopOuPlGvl148MWOysuFzk=;
        b=LSkGiVeU7PI0Vs4WtsAc6IS9tFfaJLvwPDlHnRpMSNqjVYrWy6kWoIykReywVR4+BE
         o+/iVByPTAqX4VOfG98JyYNh/8gFen3DCEw5f6svuIyLzML7qxm24hv/PQ737MfUUpBy
         RYVlND7GsPtRx6NSfasR1Fg3mWiO7Gqj9F2gVrMArnIpby9obgGC7VeUGtsQK4H0Sev3
         xXIrLCzAYNvcMibVfIuMcFx6bhXjLC4t58h2o4KUmvwuX222mNjOTRqnbjgN1Snr1EBQ
         ErPoAxIh3l1jaFXfBH+cIRyxag4FfTOeTPpcalVga6fZ0HLO07D3mReGMhGUrWfWqgTu
         kIxQ==
X-Gm-Message-State: AOAM533fD+FU3a+XCisHcQtkbDYrcNmqsXKIeh8wMCKFO7MkviZYYEmC
        22NedGN7QwmTLTTCM7nzwd8klxpwGhE=
X-Google-Smtp-Source: ABdhPJwg8GO6m/ZUzVFrF6H35kDx3H8+xq6W5ZxNkl0XVPvdQngqbeWMlzFLtZ6SuwjW+tR1c8O/IQ==
X-Received: by 2002:a05:6402:1c09:: with SMTP id ck9mr54130923edb.389.1637517841144;
        Sun, 21 Nov 2021 10:04:01 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id q7sm2846599edr.9.2021.11.21.10.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 10:04:00 -0800 (PST)
Date:   Sun, 21 Nov 2021 20:03:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 18/19] net: dsa: qca8k: use
 device_get_match_data instead of the OF variant
Message-ID: <20211121180359.6botb2ttg52tm5e7@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-19-ansuelsmth@gmail.com>
 <20211119022136.p5adloeuertpyh4n@skbuf>
 <61970ca9.1c69fb81.c7bcc.3d36@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61970ca9.1c69fb81.c7bcc.3d36@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 03:32:06AM +0100, Ansuel Smith wrote:
> On Fri, Nov 19, 2021 at 04:21:36AM +0200, Vladimir Oltean wrote:
> > On Wed, Nov 17, 2021 at 10:04:50PM +0100, Ansuel Smith wrote:
> > > Drop of_platform include and device_get_match_data instead of the OF
> > > variant.
> > > 
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > ---
> > 
> > Why? Any ACPI device coming?
> 
> No ACPI device coming. Notice we could drop an extra include.
> Is using device API wrong for OF only drivers?
> Just asking will drop if it can cause any problem or confusion.

No problem, just that this patch is a bit weak on the justification side.
People usually don't make changes just for the fun of it.
