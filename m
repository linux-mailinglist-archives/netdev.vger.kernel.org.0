Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24842ADF98
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732704AbgKJTcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732004AbgKJTct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 14:32:49 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D0AC0613D1;
        Tue, 10 Nov 2020 11:32:48 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id v22so3690425edt.9;
        Tue, 10 Nov 2020 11:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VM/5N1Cfxe/m3bRipJoTI2B3zhN3N0f0sMhjH2eyUBU=;
        b=KdkNh6b3qKXeJvvlcUmKWOeRgPT/zxH3+orznfb65IsHrz7oKYGtiIZacKV/w9g3rP
         1BHn9xyNAFCM66rdtplI01RPdvPFOhsOu163eyvaJLtISgPqleiayYU9t6U4RjyMe3No
         +mzIGAocaRP9G5AkadyXwHz+zNt8x9QJDIdy0HTZpuZlHMc1/OI0/xezTXDREFrQms2i
         CUEcAK5uInTPaSRJ4HXPty6DGW3/+Vcrh+2MCjiwZxlF/ox1llqaLProMD4XFRytgNSV
         PxUs4yxgM1oAdMEDdAHaSHKLOaf+TytLPyUjA4Q3B5QYCdQzPF3kDW7yEspTneFO3QSm
         zy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VM/5N1Cfxe/m3bRipJoTI2B3zhN3N0f0sMhjH2eyUBU=;
        b=ENOBqh3VG0VERa0mWgXi2agTqnYrN4hKdOezr4kNnpf3HHwNVvPlejA+tAdsaEfonh
         +SDCk0xC9Fajoaqo6yLyqDHp9mlZqkbb6N1sQbXe2xLDXPVBrmfoBB28ZTCoi4hlzXSv
         ig++tckd+qAN8fGi29rUIs7klm3AOuI5TCwDVJfag5dhOU86UAHQO1n3VMRXFelU5bIs
         KnYMX2p6o4J0J1GMKRhG3UJkLV19YRoxNWC2+cAut9VPdI6+6mvxHYV4VbRnNy+GnEUG
         e6+4cg6yQVBtuxGW4kJ4NpcLGEAEHRwwOAYIvN9ZrR1X0C9MWVqg2yALVCHzjuf5l/sm
         XlSg==
X-Gm-Message-State: AOAM530OogVPeCQBbtLYv0ilzeG6JiYss6JavJR06Z0RQvLFFTux9cgm
        PwjxtLqA7Rj+/ggJ7OZGvxo=
X-Google-Smtp-Source: ABdhPJxCG5xnShiAvBFmxb7Da3biTlYt98r8QqBxKW8iMTt6wpgkAlO2l83uFJaTB/QDYZpHzQp04g==
X-Received: by 2002:a05:6402:234a:: with SMTP id r10mr992643eda.311.1605036767418;
        Tue, 10 Nov 2020 11:32:47 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id cz14sm1918012edb.46.2020.11.10.11.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 11:32:46 -0800 (PST)
Date:   Tue, 10 Nov 2020 21:32:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201110193245.uwsmrqzio5hco7fb@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <5844018.3araiXeC39@n95hx1g2>
 <20201110014234.b3qdmc2e74poawpz@skbuf>
 <1909178.Ky26jPeFT0@n95hx1g2>
 <20201110164045.jqdwvmz5lq4hg54l@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110164045.jqdwvmz5lq4hg54l@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 06:40:45PM +0200, Vladimir Oltean wrote:
> I am fairly confident that this is how your hardware works, because
> that's also how peer delay wants to be timestamped, it seems.

So I was confident and also wrong, it appears. My KSZ9477 datasheet
says:

In the host-to-switch direction, the 4-byte timestamp field is always
present when PTP is enabled, as shown in Figure 4-6. This is true for
all packets sent by the host, including IBA packets. The host uses this
field to insert the receive timestamp from PTP Pdelay_Req messages into
the Pdelay_Resp messages. For all other traffic and PTP message types,
the host should populate the timestamp field with zeros.

Hm. Does that mean that the switch updates the originTimestamp field of
the Sync frames by itself? Ok... Very interesting that they decided to
introduce a field in the tail tag for a single type of PTP message.

But something is still wrong if you need to special-case the negative
correctionField, it looks like the arithmetic is not done on the correct
number of bits, either by the driver or by the hardware.

And zeroing out the correctionField of the Pdelay_Resp on transmission,
to put that value into t_Tail_Tag? How can you squeeze a 48-bit value
into a 32-bit value without truncation?
