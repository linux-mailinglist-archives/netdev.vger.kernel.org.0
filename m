Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89C021F5CD
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGNPHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgGNPHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 11:07:24 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4353FC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 08:07:23 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id b15so17547368edy.7
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 08:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8YZ2PJZyOB7nbZ+ggthxYV3z967EK/MP8Pl5h9HOBVk=;
        b=yBkiK9HpVPLv4KezAhRFC1kuToxIeG7aWh2V3NUUmVni1ZMuhVaSWoPFx9ep2dt484
         Z9nRtjKZNwJeLCnjajS5J4bO3SvwlIbu3XE0cezenB/r/ipLqaTieHZNVurQqvp9yYEf
         3Z0v0sUg5ROZpq6F8n//jfcPUNfTheJ1CdNvRhVWW/aI1nOQdhfyzn3KID6n1Kdc6zve
         1JiWAeyJh/oDjBV340EHcfWePUtbaMXmHBGXB8jZWvv1AKqTF0/eo/EVITZ4qDNEAlIf
         ivi9rrQ8Mrw/k7ZNoSd0PxOgq9pB8CgdDCPtXSzhFJWmgmBCrkZFWeKlKZvsABuHyBX1
         SN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8YZ2PJZyOB7nbZ+ggthxYV3z967EK/MP8Pl5h9HOBVk=;
        b=NWL9WErMLM6X6BnfddFrg6hn/fC6Pzd/zUYH8wQVwS2J5LebQOzakwtXzNbAL2oQTO
         XnPG+FavrGjlasa4HBFU1tfZbpZAQ8ln9f9aQ2Zkekq80bMml/Fe6R0ijsuy/mxgXIX1
         vt0IZLZ4WJCFZdt0LCDy3XrTkCASjeZ32PMpw9b/Fk2XPzsBwwKLxl+7n0Z9eOXG9+UX
         0y9PWK+N7Zu+85BriD30HDbVapON7pMXUJYsaKvchfDneFem4E8Q970p+MvNTpF3fMv2
         arIu4rVGg+AbFNfUQL+iPNL0TUMO5kUs5HqbNGR4c8GPSkrMaX9c6TrPymEfwEvkkBNw
         KkSw==
X-Gm-Message-State: AOAM530SZhaRR6BO2sJJ9AMyvY/tL9CA//WQuyGzb538ZG+RusrfH7YD
        Hm7tJ2uvxaTYDUmZ5uj9HNrs2g==
X-Google-Smtp-Source: ABdhPJy+OE+vGsEtk0PqariBG47N8cUeRJ7Bbp3WX8OviPR89RF8B7Li2G9AkWoj3PjhAuLRAMA+6w==
X-Received: by 2002:a05:6402:134e:: with SMTP id y14mr5100529edw.4.1594739241935;
        Tue, 14 Jul 2020 08:07:21 -0700 (PDT)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id v24sm12645068eja.29.2020.07.14.08.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 08:07:21 -0700 (PDT)
Date:   Tue, 14 Jul 2020 17:07:20 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        thomas.lendacky@amd.com, aelior@marvell.com, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com
Subject: Re: [PATCH net-next 01/12] nfp: convert to new udp_tunnel_nic infra
Message-ID: <20200714150718.GA12799@netronome.com>
References: <20200714003037.669012-1-kuba@kernel.org>
 <20200714003037.669012-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714003037.669012-2-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 05:30:26PM -0700, Jakub Kicinski wrote:
> NFP conversion is pretty straightforward. We want to be able
> to sleep, and only get callbacks when the device is open.
> 
> NFP did not ask for port replay when ports were removed, now
> new infra will provide this feature for free.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks Jakub,

looks good to me.

Reviewed-by: Simon Horman <simon.horman@netronome.com>

