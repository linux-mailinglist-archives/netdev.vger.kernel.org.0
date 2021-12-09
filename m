Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B4646F4D3
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhLIU1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhLIU1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 15:27:07 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC5CC061746;
        Thu,  9 Dec 2021 12:23:33 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r25so22865599edq.7;
        Thu, 09 Dec 2021 12:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f8uvUI5BY3lo9YiSsZpgDXouT/InJg5cLCGaYQDFMDU=;
        b=nYXL+CAv+6QxavEh4bK9TyRI0H7FFAu5kIG571p+0okcqYHPoLxy/rwoAsMiTiasLX
         AV+iICnoMjMBDCty3a9Be0SMAM6NpbBhC3miCmkXpkL43R9eMPKk6txHRd2I3u+e7t2h
         RT/iLkcIcBMmdXy2F1lbk1Mco8W9/qBIriNuFusQyVtAeWzLaybg32y+1z2QcVKqgqPw
         6s6MdfebKjaq55otMnWJQUTIx3F+LUmwwvWXIJ1B6lNImPmFS57EUsN544UoIGlph0gK
         ZFWv3CbSDzbcNXboQVqBBGQZwKCg68UMlKJySN3yV9f7iC7w2AyR9XhoNROSgGNHRGhn
         NZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f8uvUI5BY3lo9YiSsZpgDXouT/InJg5cLCGaYQDFMDU=;
        b=VUz4PRAbfDcyCdWzSz0oP+fyT+P+/WIPGfZIt6wjk/iI8H0oDiPiwjdseUcNN0EyxT
         8NvX07u+NrA49ROdk/QvJSw3qDtAWbFCR1HfiH92NMRvRbq6AKzELnfY6tS1y3GTrqSM
         P3aQJMGLZR6wPX3kgY2gmPqPLS/ovBjgp3Irbeko3kqI38Mh04dFU5E51jfBdKnhLJYG
         G9fnQw8DbcVqik/LrB3On10i8BghmNeGxWzatkwOVIjvOuCVrhw1O0gG83KXogRGo80/
         zEvrx2s0MmFkZczF/3ylpXZA78LKJ3Fxxqc9LG6M4O29BDfQQGhe3z+6H6smfZX1o0Kt
         716A==
X-Gm-Message-State: AOAM532oeKPddMLyWrXHggqGYjU21cuJjezoRrl77Fxgx6jYpUQq5naW
        6yCAiIRc5QWmsFnER6P/fSA=
X-Google-Smtp-Source: ABdhPJwqn80d7WMYeeRVDvMjwthOeqjTwODQh53soK5bLNBK2hF/ACz4RFStJzO2lKP6Uwi7LNxgYw==
X-Received: by 2002:a17:907:97c3:: with SMTP id js3mr18676561ejc.240.1639081411604;
        Thu, 09 Dec 2021 12:23:31 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id hz15sm404252ejc.63.2021.12.09.12.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 12:23:31 -0800 (PST)
Date:   Thu, 9 Dec 2021 22:23:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 2/6] dt-bindings: net: lan966x: Extend with
 the analyzer interrupt
Message-ID: <20211209202329.6ogowkumh3lz3ve7@skbuf>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-3-horatiu.vultur@microchip.com>
 <20211209105857.n3mnmbnjom3f7rg3@skbuf>
 <20211209154247.kzsrwli5fqautqtm@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209154247.kzsrwli5fqautqtm@soft-dev3-1.localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 04:42:47PM +0100, Horatiu Vultur wrote:
> The 12/09/2021 10:58, Vladimir Oltean wrote:
> > 
> > On Thu, Dec 09, 2021 at 10:46:11AM +0100, Horatiu Vultur wrote:
> > > Extend dt-bindings for lan966x with analyzer interrupt.
> > > This interrupt can be generated for example when the HW learn/forgets
> > > an entry in the MAC table.
> > >
> > > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > > ---
> > 
> > Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Why don't you describe your hardware in the device tree all at once?
> > Doing it piece by piece means that every time when you add a new
> > functionality you need to be compatible with the absence of a certain
> > reg, interrupt etc.
> 
> I though it is more clear what is added in the patch series.
> But then, if for example add more interrupts in DT than what the
> driver support, that would not be an issue?

I haven't kept track of the lan966x driver development. It looks like it
is pretty new, so I think it's ok in this case. But I've also seen
features introduced years after the driver was initially published (see
ocelot fdma) where device tree updates were still necessary, due to
minor things like these: an interrupt isn't there, the registers for
FDMA aren't there, etc. After that kind of time you'd expect the DT
to no longer require updates unless there is some unforeseen event
(something is broken, a driver is radically rethought). Sure there's a
fine line between how much you can add to the device tree and the
how many consumers there are in the kernel, but on the other hand the
kernel doesn't have to use everything that's in the device tree.
For example, at Mark Brown's suggestion, the DSPI nodes in ls1028a.dtsi
declare their DMA channels even though the driver does not use them
(it could, though, but it would be slower). Similarly, the DSPI driver
for LS1021A has had a while in which it ignored the interrupt line from
the device tree, because poll mode was simply faster. To me, this kind
of approach where the device tree is provisioned even for configurations
that aren't supported today makes sense, precisely because the DT blob
and the kernel have different lifetimes. It's better to have the
interrupt and not use it than to need it and not have it.
