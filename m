Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B5FE105
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 13:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfD2LFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 07:05:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37641 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbfD2LFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 07:05:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id y5so14178653wma.2
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 04:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JyCdc5gZkR3Qq1DjvPmdztMb+4DbBLd30vsC8ayEy68=;
        b=JwqPiMmlkBbRl+8STUVjxV7mu9j7I9gu+7xnz+6/MRSZPfd0eELUIPE13g2nyX1BcP
         UJ3Rfh2muIiKCN+2iUciSFXr9sgT3tYCivqYlZB5CWJBd9DXFdvJAiA8ZkzLlAEgbG7m
         3LIWHCLCnZa+bQNv0EB1Xga3wL+CF+uEDr+8kYERbI2zFYf947r5Z/2Xo8zUpg1RoZEX
         tRhQVLMuF/TO/OHURICfhahTD61AnI6q92mzExtbtl7Un0WSPReAuC7MZCt9seOwI6Vm
         TJlf2YCzkw8qBGfmLQ/dRZ//eEd8pBGPKFDljgyRL+/dYfRMksu3/NDmFevCwp2B41IF
         WGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JyCdc5gZkR3Qq1DjvPmdztMb+4DbBLd30vsC8ayEy68=;
        b=Ui4JxTYunInjuKrzNw/viEB7Yw6RVsjsUt7SBZVBYjTwRYJ1mqPyC1YYFw9FIxDGaB
         X84XLZ+iXy//ajYoVuEwfGGhUj3wyuA4Nak9yscSxVdaDowXJsfUe1gSeoPlHCYH/KJV
         ajoVaJTU4rWbAS4hEt8uT8MWWqaRsIxZowl08LqsXWWjVS8XGGEYZzVRI8N5aw1n4h4J
         ET3CYVehyBwGP1UHt4tW6SS43zg09gTrqLcBhWbBf3p6oWlQT0gXrXldG2jnji2Wup3T
         DNdmcHq1RO43Hp0sRfjJkgdxDQm12klEXXTFUQ97wDDSU2TLHyicbnUc+dx9k9iW9XF9
         NYgQ==
X-Gm-Message-State: APjAAAXGz7HPZKL5BOprqJHbGWDCurK3QGswTEI8cq1nOA4CwIxhSiMr
        IOIanv7V5MDr/ZWKo3AmwSqLvg==
X-Google-Smtp-Source: APXvYqw/L3v97PCfK7QGFiHA4eaBEqBhwMoz4vrRQKAAJImMY8oVJ6Nxd5q9Cnl7N71aiEA5Q9rUmQ==
X-Received: by 2002:a1c:c181:: with SMTP id r123mr16610408wmf.13.1556535913172;
        Mon, 29 Apr 2019 04:05:13 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id z4sm10799474wrq.75.2019.04.29.04.05.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 04:05:12 -0700 (PDT)
Date:   Mon, 29 Apr 2019 13:05:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: Change devlink health locking mechanism
Message-ID: <20190429110511.GD2121@nanopsycho>
References: <1556530905-9908-1-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556530905-9908-1-git-send-email-moshe@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 29, 2019 at 11:41:45AM CEST, moshe@mellanox.com wrote:
>The devlink health reporters create/destroy and user commands currently
>use the devlink->lock as a locking mechanism. Different reporters have
>different rules in the driver and are being created/destroyed during
>different stages of driver load/unload/running. So during execution of a
>reporter recover the flow can go through another reporter's destroy and
>create. Such flow leads to deadlock trying to lock a mutex already
>held.
>
>With the new locking mechanism the different reporters share mutex lock
>only to protect access to shared reporters list.
>Added refcount per reporter, to protect the reporters from destroy while
>being used.
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
