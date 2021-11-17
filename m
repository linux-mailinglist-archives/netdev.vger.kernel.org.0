Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA48D453F75
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbhKQE3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhKQE3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 23:29:46 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9C2C061570;
        Tue, 16 Nov 2021 20:26:48 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id t21so1035302plr.6;
        Tue, 16 Nov 2021 20:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tS1+hrsrVzfQyOyashnDo/1MOiewYsmRz2aYDUPV49o=;
        b=lxBEbNwMW1lHDoIwuqj28c8tm0NjGUuTFBJSUJHyDJJG0UBSxIbqIwauHI92BqEfDH
         HlUQ6j4o9XAZV3+4Gn4iXZNIZiN5H7Ak/qSk7DOCrgPrJs+cONqpLeWAcIAnJlwl5f+u
         ZSvkGwyybv1XH46QPpr6zCt50wqyxdq5rytd6EUFf8TFl54TSY+LnC8wKgOgILTwjpTJ
         P726ugo3RfyuzY7qT7z1kri6+Qw9r88k5JiiOIE1BqfxfgsUUnPX+sAVhFoNkKwScK/9
         H1O7UYICoJtlq9e3ryf5+LDrmunurg9DkPN0O+alJHD29pKf+02VCedH6IHaVT55pb0f
         VVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tS1+hrsrVzfQyOyashnDo/1MOiewYsmRz2aYDUPV49o=;
        b=hv561G5qzU8xoriLL16RGmD8XdNUzq+TYvJkkXc7uFpikHvvyrMopC9U3UQyQV3TLj
         E4DRWwRLkyksyl/Ur+OF8eSovn49sEeIy+S9vQL30iLB/uMxUxdm2ttPlBVMZV5ZxMID
         w90Jh46m5voagPl3/y2SHxD6N2dpCrxCIDPG71zUWkAgD1+tiZ/PLmvHT37quqqapXdQ
         HS7c0sNwy6IZImy8zVBaahK7ZEAS7xsqxcQli83yFYVO8LQCxRW/LbehBeeler8lJhZv
         ez0L6Jvglvd+3Qc409+DBX6SqMO3B28WWRJPObGcSKKeEH2wHL2zRkYk3ywltxfjtoed
         h8ow==
X-Gm-Message-State: AOAM533cMXu52DTsVJbr60T57GPoQl6VP/l+4OfmXWrI7XMFgr7B5Dl5
        K5ItnXGq3azNqOFkSd+2sWw=
X-Google-Smtp-Source: ABdhPJxGxJv0Zv2wAjmIKvIusG0vR1m1fkt+DrH84i9dq3xSvWRzSH/46yZBdmayD2vtxIliNe0+YQ==
X-Received: by 2002:a17:902:db12:b0:142:3ac:7ec3 with SMTP id m18-20020a170902db1200b0014203ac7ec3mr51376829plx.2.1637123207961;
        Tue, 16 Nov 2021 20:26:47 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id pj12sm3909958pjb.51.2021.11.16.20.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 20:26:47 -0800 (PST)
Date:   Tue, 16 Nov 2021 20:26:45 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: ti: cpsw: Enable PHY timestamping
Message-ID: <20211117042645.GB23271@hoboy.vegasvil.org>
References: <20211116080325.92830-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116080325.92830-1-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 09:03:25AM +0100, Kurt Kanzenbach wrote:
> If the used PHYs also support hardware timestamping, all configuration requests
> should be forwared to the PHYs instead of being processed by the MAC driver
> itself.
> 
> This enables PHY timestamping in combination with the cpsw driver.
> 
> Tested with an am335x based board with two DP83640 PHYs connected to the cpsw
> switch.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Acked-by: Richard Cochran <richardcochran@gmail.com>
