Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D44177412
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 11:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgCCKYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 05:24:01 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35437 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgCCKYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 05:24:01 -0500
Received: by mail-wm1-f68.google.com with SMTP id m3so2254327wmi.0
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 02:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2wZ+cBu8jdk2zA4M4aP6M64mLUKvVHrWGv0KaKv0GTk=;
        b=eSN1JeU2Mj8ONH1QYBtJm+ovZNskO9S6xZM4Ca2mn5iXZqPMqKABGqkiRQGCCAVbU1
         UUxoRO03Lsv8sBo3bFVUvjDVKpdbM5OaaZjbdN6ERgFGqOEJ0HUtnfBayCcB7A0vyBUI
         2mwHt2pVJCyYAbdWqvrGnUEwGbSEJbhLpoiiKeqU9ts1S9KWJKBl062wP47imlthZ0CI
         WHHsIlKuRy0itXhn27GpEPbdRl00VoxjyzazDPFuNvNZSIclel4GAIf4DSObwpfEsQMf
         uZ0ow8CbJC8d2LhgCSaoL8MjTmddPbmtGD4huQSbwWdVFBMteKQQ30/Yjhlwd78aOltX
         WT+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2wZ+cBu8jdk2zA4M4aP6M64mLUKvVHrWGv0KaKv0GTk=;
        b=euGYAjqbsAs488XMDEQvC+ree/2juvIpbw55/+bcelSwLyCoyhzj3t88dFfTD8yBhK
         qSxHFNhkux+3SiyXoelQ28BcS6OOkaeowGapKZ6PD4wUlxK7xj4mC7ufsqhm9FAPJDbR
         ZXBug/uQgtNLJzAmrR3+eNOopg+UGAl7U7r88PjFp4FutDNgnL0+yuWaeZnqVaSuDwJf
         4cEcYHepr6uY9IGqJ7rWFSEf4qk2jm2gzGOlA/pKe1xWLHFMzDfwHDbmYC38+xC0ydlp
         t9IHhDr21AMRk/xKJlj46Q4nYA5KxXzZYegF0+KNdHvzEYHTmp9MTig4lI/XaYj+7SFX
         /bYg==
X-Gm-Message-State: ANhLgQ1RiHLByB5E1UdaJHduoioPdu1k8of7/3BAV3X9GkWndjS4RgMy
        rutttBtGN1Wu5XAsRyCUKP8GaQ==
X-Google-Smtp-Source: ADFU+vtLzIgh0wfsvkNXPXlGt8YvqM1EhObJGl6IDPzaJL5RSJllQkl2yFPPuXvReaMoCwsGNMW9hA==
X-Received: by 2002:a05:600c:301:: with SMTP id q1mr1362063wmd.182.1583231039407;
        Tue, 03 Mar 2020 02:23:59 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id v8sm32154395wrw.2.2020.03.03.02.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 02:23:58 -0800 (PST)
Date:   Tue, 3 Mar 2020 11:23:57 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH net 01/16] devlink: validate length of param values
Message-ID: <20200303102357.GF2178@nanopsycho>
References: <20200303050526.4088735-1-kuba@kernel.org>
 <20200303050526.4088735-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303050526.4088735-2-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 03, 2020 at 06:05:11AM CET, kuba@kernel.org wrote:
>DEVLINK_ATTR_PARAM_VALUE_DATA may have different types
>so it's not checked by the normal netlink policy. Make
>sure the attribute length is what we expect.
>
>Fixes: e3b7ca18ad7b ("devlink: Add param set command")
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
