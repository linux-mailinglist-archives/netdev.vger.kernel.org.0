Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCF82BB985
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgKTXDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgKTXDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:03:06 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97849C0613CF;
        Fri, 20 Nov 2020 15:03:06 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id cf17so7598676edb.2;
        Fri, 20 Nov 2020 15:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oMctvuL0LC+KbeCtLx97RH5qb5AFi0FCJMWr7Dkegdo=;
        b=ZIKpyZtlYnalRfgua4tDJvzTB1P4zGLzphXi3kaf+fNDlkSMXIRdvlCEOXtaXhJ/wj
         TwBenfyrQ54JzkHaxiDIi2JG9qC0aw3jUd//HjA2PyS6g76DnyEPUqzKG1YZrwRtEzBG
         j2sda3U3OkxPuFUaECRjsmQ/A7wx7CfhqTPyl95d8DX/KwDC7a7L2OST1V6Kl0kzCb0K
         FsZz309LgKlnEhPQTAWgvojHHou6KYIM9906uh8b2uTHMTFsItor2fPmaxP+5KkgWDWg
         aL2basu+I7M1xiOWdyg+IcFYdOXkbigMYZ/0VVYtTWSKwFzEFFMmBFIDx7iRgBvW84MU
         Wj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oMctvuL0LC+KbeCtLx97RH5qb5AFi0FCJMWr7Dkegdo=;
        b=iWgvzY3vhuylp9lt10E6LiuVIxaTU3VupxsfprL7Pn2fDGrprh69y/7yhl9t3N8mB7
         ejw8R9IkZ/v8uaVliWZAtr4tuQuQkQUGwR8Fm3AMoR6FqMPSbL1oV2UUY17hGs2a4Nem
         KUUpFA5N0dXoYYEPSKbpSQuV0dvnwcimuNq7RkZIff+0BX/ppGePR+sUnF+/x6mcUxQg
         /eUyO6/+jxXro72kvxlPVHOtq2PzA95CmpplZkVLZUqMXfeG6/uPJahBMVfq0diVtNZ2
         lywbtXiXO9qZqZuQV787IUkiv2ZEApkE+thGLjWj7JCoyNjf9MpQjeg9BAYwfn3r3nq/
         3mbw==
X-Gm-Message-State: AOAM5300VoGnAJVshCY+oIZjZKqtbS8FTXdU5NRtLxpQURH4REJUsBDd
        NtbWG+J+38dqs+BhXXrUI1Y=
X-Google-Smtp-Source: ABdhPJyCmdvIoarNNcQltgfGEl7LdVs0y0vjK70olbFGo1BEMdnDGkhBJHbJv+LFlgNXs0MAnqDVBA==
X-Received: by 2002:a05:6402:114c:: with SMTP id g12mr37402873edw.167.1605913385354;
        Fri, 20 Nov 2020 15:03:05 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id j9sm1623904ejf.105.2020.11.20.15.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 15:03:04 -0800 (PST)
Date:   Sat, 21 Nov 2020 01:03:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 06/12] net: dsa: microchip: ksz9477: basic
 interrupt support
Message-ID: <20201120230302.znjnsqnv7jm3vjdt@skbuf>
References: <20201118203013.5077-1-ceggers@arri.de>
 <20201118203013.5077-7-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118203013.5077-7-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 09:30:07PM +0100, Christian Eggers wrote:
> Interrupts are required for TX time stamping. Probably they could also
> be used for PHY connection status.
> 
> This patch only adds the basic infrastructure for interrupts, no
> interrupts are finally enabled nor handled.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> +static int ksz9477_enable_port_interrupts(struct ksz_device *dev, bool enable)
> +{
> +	u32 data, mask = GENMASK(dev->port_cnt - 1, 0);
> +	int ret;
> +
> +	ret = ksz_read32(dev, REG_SW_PORT_INT_MASK__4, &data);
> +	if (ret)
> +		return ret;
> +
> +	/* bits in REG_SW_PORT_INT_MASK__4 are low active */

s/low active/active low/

> +	if (enable)
> +		data &= ~mask;
> +	else
> +		data |= mask;
> +
> +	return ksz_write32(dev, REG_SW_PORT_INT_MASK__4, data);
> +}
