Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3365F326AD5
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhB0AuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhB0AuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 19:50:06 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04919C061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:49:25 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id p1so8561827edy.2
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SFETy+Y2ZkcHkGwl4XZhNcdFfOvcKfn1d8V4EJlQDY4=;
        b=X7Qrzs6ssHNh0+iky7lJ4xHODZrpPOxHYXRKVtcxO+rcOjHFGxHdtflWJJ0P9FzVeT
         olH8DzSaXJbmWsNDILnAwTBMcCBkje3GppDc050r0PEJoT8W4FqqqhO8qHSKTbYcptd4
         YVmex6fWevz3Pik6kF5sYKV7BKi8E/IkBFGpCf6g87HW5Pawe38vLN4o7gD8H8oJEIYu
         e1gS7/c+l4DkjKdJD6JpAww0egU9C/UIXB6JGiY88sp+ph3Q8cqBOjd2LawLvo5q8O0+
         /oxvCJR47v0g+BvLoaw3tcpCtH0Lm5MUbwdDknZe7mPe5Xu1N/+VRK73PtNYYMHh/Uga
         ey5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SFETy+Y2ZkcHkGwl4XZhNcdFfOvcKfn1d8V4EJlQDY4=;
        b=q9dkZ/iDEDADMC5gSAlpWmp/bLSv7Nfrbmi5OsFG+FnX5ikjC7nkdql9RA6uEVWdyj
         8EbfgXkvuz0/MmtbvHLG4I8/lmyt6QtAhC4WwYLleWCXJBA/lwyojmGmM8TgyfX8/Ski
         zt8eF5o6hjc180h0IIZxErkqZb8GLmXrCRkksiOeiZL9uikY+6VXCoUMjFfSmRx7lYUd
         ISHQsjhyMwas1IIe3vRzy6r5W3MS2rHLNznYakENwMENxkrGwmHBwohiTaXLsXU9qr8z
         9etBDTI2Meszu9bMgo9c56JOedx4z6DxPxv5awqM97sxGDBky/boY7s978I4NJI5Aoa5
         ZTOg==
X-Gm-Message-State: AOAM533TYlcJEDJSfU1RfShVFYtavEZHd6SRackMZOfjvxJTQR2eQVHv
        m5ffKlfQItDRJOe/zdSm0dY=
X-Google-Smtp-Source: ABdhPJw3OC9jAB9OhmYCcaz10nqjUJ+5qCRN6Lg5aD9sIv2zvgoIZd/uzcztxFlxKNZiPrJWoJlvHQ==
X-Received: by 2002:a05:6402:4ce:: with SMTP id n14mr6167369edw.309.1614386964573;
        Fri, 26 Feb 2021 16:49:24 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id t16sm2504302eds.76.2021.02.26.16.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 16:49:24 -0800 (PST)
Date:   Sat, 27 Feb 2021 02:49:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Markus =?utf-8?Q?Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
Message-ID: <20210227004923.vib4mksyoqt4ygz4@skbuf>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-6-olteanv@gmail.com>
 <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210226234244.w7xw7qnpo3skdseb@skbuf>
 <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210227001651.geuv4pt2bxkzuz5d@skbuf>
 <20210226164519.4da3775d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210226164519.4da3775d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 04:45:19PM -0800, Jakub Kicinski wrote:
> I see, so this is indeed of practical importance to NXP.
>
> Would you mind re-spinning with an expanded justification?

Sure, I'll do that tomorrow. Thanks.
