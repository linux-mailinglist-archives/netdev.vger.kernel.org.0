Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E407F259917
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732055AbgIAQgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 12:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731973AbgIAQgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 12:36:14 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EAAC061244;
        Tue,  1 Sep 2020 09:36:14 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m5so956497pgj.9;
        Tue, 01 Sep 2020 09:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AO65Fr0fZKLnFc4dBwClbqMznpg/YjEg6B+AYSLym5w=;
        b=Houa7GbfCzgSnRUabUSsQ0akVcYReM7iXcdm5jzNQu/5x+foWPqLewC6rQrE7LDWN4
         /97Ie5R2tWUKBRgbE9IBUWlzK5kUk0TQR++Tb2O4Vw2/7QwyHrSfrM6IojLwa9dcX4iz
         dmDFaZkjO2GKZaRIzoab52x3BuZh5CPTndZEbmQxkO8JpY5v21K/v5k4GmuSDdlJbdua
         KRHLGDx9yC+QOFmVVuA5sQGSrAPE0bZ591Ido2T1okHlSxDIamz2kkleFqIHzwzAS04r
         KolqqMBxSFp1tQcoSg2c/cFOWxxPtplVk3cgWDZ97gTMIZBfckBUXjGG+wo1kjhxrp9t
         1O1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AO65Fr0fZKLnFc4dBwClbqMznpg/YjEg6B+AYSLym5w=;
        b=ECxXM1isjJfJbSSybGRrUVJoGlmPy6yn2Z4Qwb3xH0RKwWunKy21VyOMvaltfJGHpT
         PxbsK1fXY1T4PGYEblE87awOkaNI9qLa/RidzbX4yr1alXq0y0YcT+3OmBosLhO+Z+U2
         crHeOb9ZoKK2s3art00kfOp/J4bO7sd5PkcnK1EW+4QYnlwUyA83LCbA9Z6BtcqeZiy8
         dYDj98mvWu3fVb86mwt8EFMc3Z5nO1eCB9Z0axpIYNa+8u13U1d9dPi9CJT0cxKa2lxq
         TwFSpv5hrQwaV4otDZ945CRlTLAbGqhwjByBPzNcJyXc4+JlG+T4WLsE/ix90JXdE+sF
         6ijA==
X-Gm-Message-State: AOAM533ckVXVO+A9SNRhG5YEl4V9Ed4YwNmMaIyKY2PnDWQsK/esp7zx
        mXu0Bu6Kbx0fKLYwMisTswk=
X-Google-Smtp-Source: ABdhPJzsQpMLHKFhmXriZQPOH+ID2RaXTPWslatkI+JX6l5DDIicZHFLjYgiBH+ru/wMl9l6uM4tKA==
X-Received: by 2002:a63:4a1d:: with SMTP id x29mr2238358pga.317.1598978173788;
        Tue, 01 Sep 2020 09:36:13 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y8sm2654700pfr.23.2020.09.01.09.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 09:36:13 -0700 (PDT)
Date:   Tue, 1 Sep 2020 09:36:10 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v4 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200901163610.GD22807@hoboy>
References: <20200901125014.17801-1-kurt@linutronix.de>
 <20200901125014.17801-3-kurt@linutronix.de>
 <20200901134020.53vob6fis5af7nig@skbuf>
 <87y2ltegnd.fsf@kurt>
 <20200901142243.2jrurmfmh6znosxd@skbuf>
 <20200901155945.GG2403519@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901155945.GG2403519@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 05:59:45PM +0200, Andrew Lunn wrote:
> Maybe, at the moment, RTNL is keeping things atomic. But that is
> because there is no HWMON, or MDIO bus. Those sort of operations don't
> take the RTNL, and so would be an issue. I've also never audited the
> network stack to check RTNL really is held at all the network stack
> entry points to a DSA driver. It would be an interesting excesses to
> scatter some ASSERT_RTNL() in a DSA driver and see what happens.

Device drivers really aught to protect their state and their devices'
state from concurrent access.

Thanks,
Richard
