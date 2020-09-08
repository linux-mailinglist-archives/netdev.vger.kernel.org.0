Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1302B261308
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 16:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgIHOxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 10:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbgIHO0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 10:26:04 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB320C08E819
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:25:15 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id v196so11098834pfc.1
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UBty8M6L5SvxYNMesXi2qZ6G60zmJGJi4Vd7iMk+Fnw=;
        b=YcxOD8EYSYJAZ468jR43l92j1QpHrww7W1G4nz5GklfWEEfekFqfRibGIXgWUliBo5
         coxi6EVS+79JWoZw8o4S+8X1OBvaOQ1E/YiQYzTe4R0WnD44WuqJQ5+u1HGn1hytef1f
         kgiQudP594yROIdn14WgbZGyKymu073J8mn9Kq0d7kRUFPIHmja8eAJJNxR/9CSytceX
         ML8JdzS16PkoQLdcFCcy5EYSlB3nDUaNutYA+4Bz4P/7GJGGhqhScXMpfuFhazMu7nXP
         hRYML+cz5QQrV31ZFkyKK0tUx1PqE7ptWgH7loYlMYZq+Kt6xbRyfdlxbqpI79Va+HwC
         u39g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UBty8M6L5SvxYNMesXi2qZ6G60zmJGJi4Vd7iMk+Fnw=;
        b=FwDC051YRMtOzyekmmlt2nC+iYVSRzDzTuPnRTKS30H1R7XPAgQcKVjYPdrePgRheb
         c9+U11eMrefGr8fUrno7y8y3SvoZHyWXlHtxIeuRDb5edhLG9A9kO8vCWqKHs6gXuV7m
         mGBHzNYLBaItmcqYlAoZ+Ir02LoIDMdrfkUksMF2t2EUp5/ExOgsVTXXCAzEAAcK5cMU
         LQU0wSQ79bZnTBAPY7sAsKwzW/oVnDd6vD36MTqAO2bDKRZaIl8QMcgA44UKLmdS3f1a
         1+oynUzlDIaT67tZ4PPGLxSXchE9zUF6m0SWnDfwDNBKDLDqx8rzOA4RzIqZeIde90HX
         Ab2w==
X-Gm-Message-State: AOAM530y0w/Neh1un+Z79+LWz1OHiK6oEHKWCIReMkqDs8H9kIKu6aCM
        AZkIL+CVHkayK+AfPQYAP5++yxc/67o=
X-Google-Smtp-Source: ABdhPJxdFyYejJFK1kT55fEjEkm+uuinZNdlJBUlOpnzLDe+YGuIeqdLT7AjWiHBC5XvX90c6fUptg==
X-Received: by 2002:aa7:824c:0:b029:137:165:ddce with SMTP id e12-20020aa7824c0000b02901370165ddcemr23621574pfn.0.1599575115535;
        Tue, 08 Sep 2020 07:25:15 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id c185sm9104172pfb.123.2020.09.08.07.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 07:25:14 -0700 (PDT)
Date:   Tue, 8 Sep 2020 07:25:12 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/6] net: mvpp2: ptp: add TAI support
Message-ID: <20200908142512.GA31515@hoboy>
References: <20200904072828.GQ1551@shell.armlinux.org.uk>
 <E1kE6A3-00057k-8t@rmk-PC.armlinux.org.uk>
 <20200905170258.GA30943@hoboy>
 <20200906200402.GX1551@shell.armlinux.org.uk>
 <20200908074158.GD1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908074158.GD1605@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 08:41:58AM +0100, Russell King - ARM Linux admin wrote:
> 
> Should we always set the TAI counter to zero every time the TAI is
> initialised, or just leave it as is (the counter may already be set
> by a previous kernel, for example when a kexec has happened).

I think if the power on value is zero, then leaving it along during
driver probe is fine.

Thanks,
Richard
