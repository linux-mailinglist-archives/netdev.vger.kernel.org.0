Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF88B2CE49A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 01:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgLDAql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 19:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgLDAql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 19:46:41 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C047C061A51;
        Thu,  3 Dec 2020 16:46:01 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id t7so2513743pfh.7;
        Thu, 03 Dec 2020 16:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p5agTR8u41YbnExBJfN6TKYZx+481KIUeoBgqkq7Nss=;
        b=TSzE4xdmSfNSvjfiajst4xDi9NI3T1C89h1ii8TRjQf1tYU+ulUFj0GJMlz1M9AKVX
         bAVR2VgKYw9IVtDmql2DxLV43ez/Hm3uFZMQFdwYtKvuVL1bFCkv9L/F/Xr01dMfS8Ay
         P6fm0U73TZzo0OJfLz6VDzHaMf/Bt50nYy/bmcAySbDKo7cAjKtgX3QUiLRB4JTTJx+0
         8HEXPX7scX7mJEhevLiwiVAOCLrxLj3tb919gmr/6o0MGXkf8an5wTfwFdHHlOR28lvE
         OUBgvlefebrm1uIzIjOjRq1ZWH2CF9hxDTcrMecLyR0r/zYiNAoYM147lH1ZbdX0Igv6
         JV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p5agTR8u41YbnExBJfN6TKYZx+481KIUeoBgqkq7Nss=;
        b=CRa7SGd/xA6ZHnMJsPjfPW6ABtg0mzm5UBRK8IB8Np3wNjQK8cqV50jQLafR0QO3oc
         YIXIBhw/Q5zmgr5KGVBm7qdZ6EzXC4C4gYB3DcMUc7l1vRhmB+QKDHhKLdoE1Vc4WjZh
         eZrzAw4BMK7CIRncE1LnPr36bRYj6RDUi4C9eb3Ki1VNaR5gwoxnVz52whO41GJTcP/7
         1TyRLDqy75fI9PWITa+lmmvfAn6aUmhUXJ3phvOJ0J5Q6z3vPQeDt/1mBpb+jRnwfJTk
         uliRLiGYKMbJLvCJVMmbDxgmvH07EFOlIY+cI38ck7nRT2rTxg/eVa39enytODJAq6vt
         KeLA==
X-Gm-Message-State: AOAM532/z0Zn0+szzm2HwCXmJbdNB+P9Nj1JgyqhPqrqMnLoii4LuPqZ
        aVZQMS6SLgB8CBjXdKAr0Sc=
X-Google-Smtp-Source: ABdhPJyMJS3YOR+OsSzrI2oltWbfyDblAgWnyQW4o49wONq+CQKS1dhVHTCl7/xQqRjy2+av3F28zw==
X-Received: by 2002:a63:5418:: with SMTP id i24mr5314055pgb.165.1607042760696;
        Thu, 03 Dec 2020 16:46:00 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id g8sm2129677pgn.47.2020.12.03.16.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 16:45:59 -0800 (PST)
Date:   Thu, 3 Dec 2020 16:45:56 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
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
Subject: Re: [PATCH net-next v5 9/9] net: dsa: microchip: ksz9477: add
 periodic output support
Message-ID: <20201204004556.GB18560@hoboy.vegasvil.org>
References: <20201203102117.8995-1-ceggers@arri.de>
 <20201203102117.8995-10-ceggers@arri.de>
 <20201203141255.GF4734@hoboy.vegasvil.org>
 <11406377.LS7tM95F4J@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11406377.LS7tM95F4J@n95hx1g2>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 04:36:26PM +0100, Christian Eggers wrote:
> Should ptp_sysfs be extended with a "pulse" attribute with calls
> enable() with only PTP_PEROUT_DUTY_CYCLE set?

Yes, that would make sense.  It would bring sysfs back to feature
parity with the ioctls.

Thanks,
Richard
 
