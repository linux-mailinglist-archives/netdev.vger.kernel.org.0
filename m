Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC88A2B1258
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgKLXDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKLXDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:03:08 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DCEC0613D1;
        Thu, 12 Nov 2020 15:02:57 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id oq3so10502075ejb.7;
        Thu, 12 Nov 2020 15:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fFCuLzHCF3NunfdYOvUYUqRdVNrtCS9FyDx6R97c2zw=;
        b=TRtIDRlc7aNz4c+JwOh2/fhJ/Wkt1A+ziOnROykzE9Gmgn964r+fWw4czkNcfjcYE1
         O8kP26p4nWAWFwT8Py5+4sGgSJx7wFCjuVKv9Bwx6VHd3A5ioGLLy+4s2MuN5BgX3LcK
         CrYZo7f2fYd9WRBvqcVh6ZlLDLx2CLUVE3efZ0jO7RuT5+v8gr26p/C1ZbO+wCEjFuqk
         JuMs2AoD6tbhqdZ+WvTbJu5v5dhnRiXM/Sr405NcsA0TC0BO6ZVDqfhZb5m9yaLpYtlr
         Zv5YnjVzoOen8/6l1RdWOPDaqhzX67kEVHHGvJr9lZ/FXWy/5C9G8x2/3LuoR4k+gmlg
         r4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fFCuLzHCF3NunfdYOvUYUqRdVNrtCS9FyDx6R97c2zw=;
        b=HYVR9cXZpCtPYafFd7BbDaUB+bUj10q+V46QSy5M/5Rhd7M4tQuwBzg4JNoFD5lWwd
         DhbVRLjwD8JNFdTf/C/RK55a0kealYHRlbUKq1X7FgsztM6XTwmhgMlT2WOyNAlYzuCk
         srT8lNq4T2wAPGdHqyQfnVaIDwtiI3JrvSwno3xw2ye0u1DPgFaWz6ttdBZ+hYsBNvAN
         Xx+I76u9N2Bl5ohUA+vcOIcqbbIGYsoSvmblfKzyqCKz7wfycB2X5aKJ+UM3CfTY/6Wy
         YYn7UVDCFVuk+W8jzAeh4AEHiepcphdcX4N0UM5TKTsCTuGlo0Y6VIQ1Yt0NcM36N/Ha
         iInA==
X-Gm-Message-State: AOAM5315HzKo6V6HXXArUn2iUbeGWRnZ3r/vnq4GXogtvsg21f2nzAkN
        1pIgazhGifmBkih26nP9p3E=
X-Google-Smtp-Source: ABdhPJyo0ryDTr8bZPrg57Ideb/leoI2q59daDlVfI/r8YhkJ/hvQy5NItaQXyvkVPO17X/oIH5aMg==
X-Received: by 2002:a17:906:bcf9:: with SMTP id op25mr1554430ejb.223.1605222176665;
        Thu, 12 Nov 2020 15:02:56 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id d2sm2695782ejr.31.2020.11.12.15.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:02:56 -0800 (PST)
Date:   Fri, 13 Nov 2020 01:02:54 +0200
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
Subject: Re: [PATCH net-next v2 03/11] net: dsa: microchip: split ksz_common.h
Message-ID: <20201112230254.v6bzsud3jlcmsjm2@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-4-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-4-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:29PM +0100, Christian Eggers wrote:
> Parts of ksz_common.h (struct ksz_device) will be required in
> net/dsa/tag_ksz.c soon. So move the relevant parts into a new header
> file.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

I had to skip ahead to see what you're going to use struct ksz_port and
struct ksz_device for. It looks like you need:

	struct ksz_port::tstamp_rx_latency_ns
	struct ksz_device::ptp_clock_lock
	struct ksz_device::ptp_clock_time

Not more.

Why don't you go the other way around, i.e. exporting some functions
from your driver, and calling them from the tagger? You could even move
the entire ksz9477_tstamp_to_clock() into the driver as-is, as far as I
can see.
