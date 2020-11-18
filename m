Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6212B887B
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgKRXkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgKRXkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:40:22 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A6DC0613D4;
        Wed, 18 Nov 2020 15:40:22 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id o9so5280591ejg.1;
        Wed, 18 Nov 2020 15:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dYEg6jWrPkkD53OAHB3soxjlN28LSPDv84400U2paVQ=;
        b=iIQfwh1LxtqMIVtXSq+tbCkZtDnA1zaS9i6mmWLIe8z4ZpHRemHjRNwAFQiIxrUCra
         NyHaor6DBzYbqNXVKmqNam4tFAjTJ/4m+YZeRAXosZZyLiXF0TlPMDdi+m+laqVk12CF
         bP3ke4fdLMG+qA5eJ+wzkqkFm7WDTKVMA7ifPImzs9++tFDwkJwyVr5RqMhuFAnm6Nb5
         msL9AUcZpilItQ/ZI3W4ccv3GAR9Um7KczBpgP4e9nFM0cJvlIfsy8vZ5ovHtdAtpK5o
         uGgsWoQWnts/QfdnXI2nfqgM5q5xOqMU8KedqRhTsiKn0uZtFRcNRzG7zmHT2Mx/1OPw
         9W1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dYEg6jWrPkkD53OAHB3soxjlN28LSPDv84400U2paVQ=;
        b=efEY5Ssc1PQL8IMxJkfBae2ICtva4KqN0YlWhttp3a8RHhZ7cRH4uBUTGiz0ynXJLi
         AtvjFcWGrqgwk7uviU4iqOfigEwjVMi1bsn8/8JBQEUIHB9S/uJY0SSS5N1xgdO5k2vJ
         IIeV3x4e6Zu3fPlv16C4K2jhmqoQyGOINivM8kk0jVkSi7ENyHta0idgsLROUmAeL7s+
         DUMwBWdonDwIQaJhNxXjPIGtJqCHTdmo8wac7k/YD1yQ466eLZVw60TKsgMQh/gpygNy
         IVLvNmABlVd/mguDsAipI8s9lZMOPn5IbEiNzWSTvd7tRctF/8xPyo4pKLEhKgNy+YDK
         OEZw==
X-Gm-Message-State: AOAM5306ggBLOwBguhDf/eBkvmQnNdWopP6iIfKIo6xV/2mVJkntI/hS
        q0kRT+4MQx6LsE2Nuc3bhjg=
X-Google-Smtp-Source: ABdhPJwzMT5hNpDkngkqFx6uhBOO1xguLw1XxFSQ0hkS91QQhtD72KtANsYgbnr+w+TsH08IytL7kw==
X-Received: by 2002:a17:906:c20f:: with SMTP id d15mr25754407ejz.341.1605742820626;
        Wed, 18 Nov 2020 15:40:20 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m26sm13518241ejb.45.2020.11.18.15.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 15:40:20 -0800 (PST)
Date:   Thu, 19 Nov 2020 01:40:18 +0200
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
Subject: Re: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for
 KSZ956x
Message-ID: <20201118234018.jltisnhjesddt6kf@skbuf>
References: <20201118203013.5077-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118203013.5077-1-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 09:30:01PM +0100, Christian Eggers wrote:
> This series adds support for PTP to the KSZ956x and KSZ9477 devices.
> 
> There is only little documentation for PTP available on the data sheet
> [1] (more or less only the register reference). Questions to the
> Microchip support were seldom answered comprehensively or in reasonable
> time. So this is more or less the result of reverse engineering.

I will not have the time today, and probably not tomorrow, to review
this. I want to take some time to get more hands-on with the UDP
checksumming issues reported by Christian in the previous version (in
order to understand what the problem really is),
https://lore.kernel.org/netdev/1813904.kIZFssEuCH@n95hx1g2/
and I will probably only find time for that in the weekend. If anybody
feels like reviewing the series in the meantime, of course feel free to
do so.

One thing that should definitely not be part of this series though is
patch 11/12. Christian, given the conversation we had on your previous
patch:
https://lore.kernel.org/netdev/20201113025311.jpkplhmacjz6lkc5@skbuf/
as well as the documentation patch that was submitted in the meantime:
https://lore.kernel.org/netdev/20201117213826.18235-1-a.fatoum@pengutronix.de/
obviously you chose to completely disregard that. May we know why?
How are you even making use of the PTP_CLK_REQ_PPS feature?
