Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5688128812
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 09:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfLUIOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 03:14:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43073 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfLUIOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 03:14:09 -0500
Received: by mail-wr1-f67.google.com with SMTP id d16so11523471wre.10
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 00:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TR5crWUI7BmA2I/X79qSDeqrl32KMIfvfTyCKtLiGDo=;
        b=Lb9bPEDpJfdfPchFLIBfGQIVsvP1ZfyVKaQFTcUnjDGYPsMyGHYMjrdBR3uZ8UEFMx
         GLCYOFKbMegsAaaI+Ln0G41Lnvd2RJGyy1dRCfNXPLuQmrLzvua/8KkQ/OpY0Tbhy5bo
         J07Tg2c1QRRhXqt0lwKsEbgYOnwUjliLzZ+haAZVLI5YX4uGLIfsERZRBDDbNIQy7rg2
         QelO0NqwSLx/Dtr0bkNQXQQJRuK5o/87NZndmTZbhdYLDIrbgVsi/IHV+1VHCUvhc64t
         3f+DwqT5aDTx4zY87KtF2uQP/ChfS6vbMUUV6F0q1nkrjnwF3YjGvBveqRSOKSi4l37Q
         I8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TR5crWUI7BmA2I/X79qSDeqrl32KMIfvfTyCKtLiGDo=;
        b=DjQ4LAfVEP+isv0e2WWJpQhEIZO4HlCIwgRMjOc8ck+q+rDeLVs5R1AZfAhZwRRKFT
         HdcrUb69Y8wKSGjMp/7pxkezgZszuijaJx/QGSENIbarYW3m8puGkjgeNav0MSYZiPOV
         RI30L8GIRsFEGCGdgzbe+b+FgDOOkPPBY1Xqw/B+HUop9avMWYzbeTlOCy6VFKAc+0zg
         QHX5v8fjCt6oeMegMqLTORfXCHTPELUJ0VYKefTIrSb0NTrQTtwtVG0dKyMUAuRGHHle
         gELSmBiNc4ybd7ooDVASWLEfKyslhUpHYSlXZNAHL3v/a0Fn/uK2eA7LpxS274+LQVl6
         JoDw==
X-Gm-Message-State: APjAAAWVr3BhCBuhxdfQZ+qcv4QoEndi/DXNF2UhWXPWJqvoCqf2r50Z
        GDj4UtA4mcpq22PB6NdRTWvy1Q==
X-Google-Smtp-Source: APXvYqx+bDDCSsNVbmY6TlF/Zv0xk6aH6OL8T4Qo3e2mHykMNR3t925itd6Bb79Ot2zue/nlLxbH6Q==
X-Received: by 2002:a5d:480f:: with SMTP id l15mr19538996wrq.305.1576916047472;
        Sat, 21 Dec 2019 00:14:07 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i8sm12657077wro.47.2019.12.21.00.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 00:14:06 -0800 (PST)
Date:   Sat, 21 Dec 2019 09:14:06 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, saeedm@mellanox.com, leon@kernel.org,
        tariqt@mellanox.com, ayal@mellanox.com, vladbu@mellanox.com,
        michaelgur@mellanox.com, moshe@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 0/4] net: allow per-net notifier to follow
 netdev into namespace
Message-ID: <20191221081406.GB2246@nanopsycho.orion>
References: <20191220123542.26315-1-jiri@resnulli.us>
 <72587b16-d459-aa6e-b813-cf14b4118b0c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72587b16-d459-aa6e-b813-cf14b4118b0c@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 20, 2019 at 07:30:22PM CET, dsahern@gmail.com wrote:
>On 12/20/19 5:35 AM, Jiri Pirko wrote:
>> However if netdev can change namespace, per-net notifier cannot be used.
>> Introduce dev_net variant that is basically per-net notifier with an
>> extension that re-registers the per-net notifier upon netdev namespace
>> change. Basically the per-net notifier follows the netdev into
>> namespace.
>
>This is getting convoluted.
>
>If the driver wants notifications in a new namespace, then it should
>register for notifiers in the new namespace. The info for
>NETDEV_UNREGISTER event could indicate the device is getting moved to a
>new namespace and the driver register for notifications in the new

Yes, I considered this option. However, that would lead to having a pair
of notifier block struct for every registration and basically the same
tracking code would be implemented in every driver.

That is why i chose this implementation where there is still one
notifier block structure and the core takes care of the tracking for
all.


>namespace. If the drivers are trying to be efficient wrt to
>notifications then it will need to unregister when all netdevices leave
>a namespace which it means it has work to do on namespace changes.
