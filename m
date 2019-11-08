Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6AF7F5A0E
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731269AbfKHVeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:34:37 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42150 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfKHVeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:34:37 -0500
Received: by mail-lj1-f196.google.com with SMTP id n5so7687209ljc.9
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iVwmfCxmYlGm1umF4hzbYjqVXwkqLwJV7uiys2HXotY=;
        b=h8UmYkOxKBDW3Ji9V8gSLC90Lv8INWtdO6eIMyWaEbmJgOD0SJSoeMJwPXAQXMDdqT
         IbWKWRJh2pq4hyni+m7rOZlkZywAZO8Z3oYJ3asRxgwVw1c56ba2G/6yEKGqmO/i9Wru
         ptpSN5TbYEy8FNkmOrk0k5aJBlF7Z51uFjpWGtcqY0obdT65eAwcYzCbhc6Xo0QkL/JY
         qRJlaLPyWBChT4tPx+FtUJSCd05EfMGWL+/+Dx5Lf74Wt9572ylmDALVWkGOYZ/XHvEh
         tuncA01p+elslmMXEQgxG/Ayt3heXvdpnpPe99GNea8+2ziQp4Au1LPpDWD4VdvQShw4
         Oduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iVwmfCxmYlGm1umF4hzbYjqVXwkqLwJV7uiys2HXotY=;
        b=du3F503XHBVx9+em5YZIrg5B5nUflsztFbi4oSS1+IOMFpo8hqwC4cYvXQ3+LbkGs7
         izhxlEBt7MtYJu2BLmE7CWzjVSZ3WJyYS8164sxYZ9ZrnqMhmEqZA7jZYIDFW5SbkNhc
         B4/JHZA6s4xuek2MnBPGUUfRXrUZspPXcANJ1/ViGsKvREOH6YVd8IIZKaZU/+XrjkgU
         i102oKRQE5ePesvQKIcdzbjvsRzsDnsJQOIJDWu0ld+gNEIemdF5rH0F0ttcLnsrfxz8
         3G4FkveQPUSfMSrsZdzEaWN1cL5UsXP/gfWctD/iWMfoQuWv0E0OvEB87o3kC1DKicLQ
         2c5w==
X-Gm-Message-State: APjAAAVdyYWQ49xH4Bk6IyAycu2V6YMUyWfLJeCoDsDDZGeQHbxmJAd0
        GMPJORPshxoP2vdBQRK28qub7Q==
X-Google-Smtp-Source: APXvYqy+CScmrjFV80FpCyFPh+baJll0UA+hrc3T9V4VrDzeDL1dOUDtc/4aq/WcctTGXgHOOauF7g==
X-Received: by 2002:a2e:8595:: with SMTP id b21mr2817240lji.155.1573248875254;
        Fri, 08 Nov 2019 13:34:35 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 68sm3530246ljf.26.2019.11.08.13.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:34:34 -0800 (PST)
Date:   Fri, 8 Nov 2019 13:34:28 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: disallow reload operation during
 device cleanup
Message-ID: <20191108133428.40f10fff@cakuba>
In-Reply-To: <20191108204243.7241-1-jiri@resnulli.us>
References: <20191108204243.7241-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Nov 2019 21:42:43 +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> There is a race between driver code that does setup/cleanup of device
> and devlink reload operation that in some drivers works with the same
> code. Use after free could we easily obtained by running:
> 
> while true; do
>         echo 10 > /sys/bus/netdevsim/new_device
>         devlink dev reload netdevsim/netdevsim10 &
>         echo 10 > /sys/bus/netdevsim/del_device
> done
> 
> Fix this by enabling reload only after setup of device is complete and
> disabling it at the beginning of the cleanup process.
> 
> Reported-by: Ido Schimmel <idosch@mellanox.com>
> Fixes: 2d8dc5bbf4e7 ("devlink: Add support for reload")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

I have no better ideas, so:

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
