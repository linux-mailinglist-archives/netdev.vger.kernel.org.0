Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A4E396194
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhEaOnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 10:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbhEaOlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 10:41:36 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04275C061352
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 06:54:11 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id k15so2759174pfp.6
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 06:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CVeBM0Ekhx6UTciN25KbgWurqjTi28ARlepkWWUYEUE=;
        b=q6qGcImSM28CmA+uQAHzmhEBC82j/bGc1gpZctjuRJH7iuGWj3tE4zpx3rxClbYGkR
         fPZqfHqLjIBBaINvJL1mMxIhL126GtRoQHS2jCZ5iyYBQJaQX9BWt86Vvey1gD7hD84T
         IFoktGRETYkbKe10xvHWSQfGbeDLH5taOczzU3HqrSnqfXeGbRlMdRQaihrt9mgEj60C
         aeymddOmJybeId1Jt26GosW6RqLCRNpLheC6s9MdxorLqhHaPCfIOladnOATs55GEE2j
         KDXrdt7uwMVgrXZOdIxiBzU4FvB4Dr1uLWdP4xCQxtiycZZwtLI0mTqBlftyvdoUSinq
         6Fng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CVeBM0Ekhx6UTciN25KbgWurqjTi28ARlepkWWUYEUE=;
        b=UqqqF9bMy5MjhppagjyV+Gcm+V1bHbsuti8v4jbUXMNlr9Yx7EDOhq8fj16VTE1vbS
         jSkXcVT6vmcSX1OLa7t1SklD294acujRW0MjmgryDK66oCWlpZQseeu3k0aSzPw43iFG
         7IY6dPB9nlRPWJv7KgEJNBZ46/VzAaMyTAvodh7Ifd1IqMOFj0g5wqVsQeUOKy7Stdrm
         dX3BLeDq+WD+49E2rMQgdTfKAHTakOoLAe/RsUPklaqGWF02eHqeSoJ8uE9hp/d48cny
         o6htQuJw9phJvZ/quUOhnRFWXG4Taw6s1D8bdmLarxFY7ZZ2S9Yz/n8CZY+X2gcCoJpi
         hhFw==
X-Gm-Message-State: AOAM530XOlomuON5mHwfPMpDui3288seXuBCOE8ZDWp7x4YfFZHWmw0N
        PyknzpLKW275gAflo8yH3EI=
X-Google-Smtp-Source: ABdhPJzFYz1JNVdmp3l0/ng7buw2UaTYxNAN//iNcX9cY1+JM1lxajxrMXT5m7tcUHc4OObKBZ7AdA==
X-Received: by 2002:a05:6a00:248e:b029:28e:bca9:5985 with SMTP id c14-20020a056a00248eb029028ebca95985mr17484889pfv.10.1622469250508;
        Mon, 31 May 2021 06:54:10 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 2sm23818pjg.0.2021.05.31.06.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 06:54:10 -0700 (PDT)
Date:   Mon, 31 May 2021 06:54:07 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Message-ID: <20210531135407.GB7888@hoboy.vegasvil.org>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-8-yangbo.lu@nxp.com>
 <20210525123711.GB27498@hoboy.vegasvil.org>
 <DB7PR04MB5017604C9B3AE7C499B413D3F83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
 <DB7PR04MB5017313658AC779FBA59843DF83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR04MB5017313658AC779FBA59843DF83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But one problem is how to check the phc availability for current network interface.
> If user can make sure it's using right phc device for current network interface, that's no problem.
> Otherwise, timestamp will be token on wrong phc...

Right, when user space requests the option, the kernel needs to check:
sock -> dev -> physical phc_index -> vclocks.

Today we have ethtool get_ts_info.  We could add get_vclock_info for
example.

Thanks,
Richard



