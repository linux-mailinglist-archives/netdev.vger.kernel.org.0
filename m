Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7B745675D
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhKSBUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhKSBUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:20:48 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7C0C061574;
        Thu, 18 Nov 2021 17:17:47 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z5so35449208edd.3;
        Thu, 18 Nov 2021 17:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G50DWyTolt2iu8jO8DrdD4xbj/5BqFOAuX3/XpL1Ya4=;
        b=GzCNEFWgs9GC16O8BqIbXEzlPxqhPzMrCD8miymITKunO2ECE0h6cWNZurUpG2fVGY
         8z61dq4fmN8eHoPIrvagUTFjam7Pa03dMyNCVeYoOb4dAAMmuKOVxEhzb5veU7FV6et3
         E934YPaVNKh0vBesl2pZ32CPvpA/nmLujWxdNbbmYwUP3BpH+oXiGO/4qqkL0MiCtxSc
         rSwE2tVLbdm90Z1/SzQsqDrT5AfzhW06ewoTKgiAyOia901y4booGnBqTTAPZLKk4yZx
         WK9uw4Vw4bZUK5tna2wHVdQhB0+SFCWJpU1vH3DwXmhsqbsFRTC44oxXFRexprJuPxC7
         Lg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G50DWyTolt2iu8jO8DrdD4xbj/5BqFOAuX3/XpL1Ya4=;
        b=wWgmSv7KKkNe8iW9QxJUeJwYeJ8aNGv9WnKHgQBAbPhRgzYOqTzns+4Ji5oWpGYD3u
         QpfucGZ3Om9SDqCnqArpKhGew6/q4AfooGTw7/nv5kLjdXFw2eOiIkyY5tzV4Jq/W2de
         XvA4uPMOdveR6BG8sLaTX57wBW6LhuXuPNNGSzMM58H5t4ddaCVtvX/hUx4DGjXVSciK
         8m/fxMz6Mz0+9yJu9O+OSNYriWPY2NRw9WT8Smei3iFobRWJazvOikt3owsoggRCM3QW
         ALrjjRI2Fs0D+J2RFwsLe1GR6YKcx+F2mKYlsmqfMNLOqARItHungOAd0vhNSxImvhoy
         IXSw==
X-Gm-Message-State: AOAM532t/E6F/e6jIdNoEiL68A3h1RwfP18bKvTC2vrpzBU04QSEudNt
        JzDibgteYTelNRLH40EXeM+Hb/cdsBQ=
X-Google-Smtp-Source: ABdhPJw6FX8bd5OZD6zfwyNv1216J63NJN4B30Nnw0CkJv7zii5MRmcVzU3Ddea+Gz92KxXOqtPFxQ==
X-Received: by 2002:a50:be87:: with SMTP id b7mr17923636edk.199.1637284665817;
        Thu, 18 Nov 2021 17:17:45 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id hq37sm523572ejc.116.2021.11.18.17.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:17:45 -0800 (PST)
Date:   Fri, 19 Nov 2021 03:17:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 09/19] net: dsa: qca8k: add additional MIB
 counter and make it dynamic
Message-ID: <20211119011744.b2nht7ekqrh5cfbg@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-10-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:41PM +0100, Ansuel Smith wrote:
> We are currently missing 2 additional MIB counter present in QCA833x
                                            ~~~~~~~

I know that 2 is less than 50, but please, it still counts as plural.

> switch.
> QC832x switch have 39 MIB counter and QCA833X have 41 MIB counter.
> Add the additional MIB counter and rework the MIB function to print the
> correct supported counter from the match_data struct.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
