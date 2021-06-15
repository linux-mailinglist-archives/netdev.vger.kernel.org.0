Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0963A86D7
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 18:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhFOQvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 12:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFOQvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 12:51:12 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374C1C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 09:49:08 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r7so37607797edv.12
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 09:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VDbzDI8/q6ogKmJfHmV3WG2/cjubuHWxq+EPbNOcDXQ=;
        b=VXLECvGLDq5XD+mYxYwvcvw4a0KgEDfGlbnj5t4bCg0+4r/uXO5sg+hz0INtzHNQeV
         x86j+nCNfuF2AJKDNDKbm4QpmB/8e0vmisQT5isQwAn+HROMSSoir24+p2wpnPgHBdHI
         OwS3ft0LkQap7RxsHZU6lsWjaJR7KAA/j0xaUu7TGtihU97d36L/KzCzMKn2SvAuCMFT
         MbWye+LhxrjCnN4u07qGeNspf8ZnCTsqOj8leCtwoKmd7N75hn/yd6KwG52gPO/OdWpM
         HESZ1BVfPuIMNxfhbdqAGXy25PUNs4ewicCs74edpgq4ywxHsbPX7SZiDf1Elc8Xwo7u
         mbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VDbzDI8/q6ogKmJfHmV3WG2/cjubuHWxq+EPbNOcDXQ=;
        b=FIwXuJXJx445o7jYacPllXmOYLZfTUBFA9Uz08NOt6wf3FFi0LVMKTbQnPtVGqnlJG
         WNK7Lytw2YMAvZ/mWv6rz2ZpV9EQdBWhH+Uqtv0wAAOTJBRSZNv7kVyDDh2b19bQNYzP
         LNoFWPhtcYbUf7Ja1LE+7vA1y/RvXvPwObk4tKsByOp5PEnTKxyOEx9IFW8CItf/S/A/
         htVuYMrOlf4n95crtae5K5qxdDh+ijC09/AbUYIZdpS6eJk6Yy3p94X4x8cOc6+aB6AZ
         9PRf4AyAgYyQCQC1V59S3+z5svAZ07wLIqABXvN7GG/HzFAIeMGjZTjxPGGy89uGI9A4
         Do0w==
X-Gm-Message-State: AOAM531v98YYebMpczfETcqfii+2kyd9MhwZoJ1nDNbEeDk/trR6HnmW
        wcX6XHg35cFZrLNHCSv+VCw=
X-Google-Smtp-Source: ABdhPJyAvbxpMLYrmv/8nV8ZWrrsYom8iugZQ6CKzX6epzhoWaxXByr6Evy2oJ4KCv9BOG+jqJyc1w==
X-Received: by 2002:a05:6402:5256:: with SMTP id t22mr546509edd.54.1623775746755;
        Tue, 15 Jun 2021 09:49:06 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id u15sm12775796edy.29.2021.06.15.09.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 09:49:06 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Tue, 15 Jun 2021 19:49:05 +0300
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        calvin.johnson@oss.nxp.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Message-ID: <20210615164905.62f7m4k5ezpm7vhm@skbuf>
References: <20210615154401.1274322-1-ciorneiioana@gmail.com>
 <YMjTDkJU58E3ITCJ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMjTDkJU58E3ITCJ@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 06:19:26PM +0200, Andrew Lunn wrote:
> On Tue, Jun 15, 2021 at 06:44:01PM +0300, Ioana Ciornei wrote:
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > 
> > By mistake, the of_node of the MDIO device was not setup in the patch
> > linked below. As a consequence, any PHY driver that depends on the
> > of_node in its probe callback was not be able to successfully finish its
> > probe on a PHY
> 
> Do you mean the PHY driver was looking for things like RGMII delays,
> skew values etc?

In my case, the VSC8514 PHY driver was looking for the led modes
(vsc8531,led-%d-mode").

> 
> If the PHY driver fails to load because of missing OF properties, i
> guess this means the PHY driver will also fail in an ACPI system?
> 

Yes, it will.

The PHY drivers were not changed to use the fwnode_* calls
instead of the of_* ones. Unfortunately, I cannot test this with ACPI
since the boards that have this PHY (that I have access to) do not
support ACPI yet.

Ioana
