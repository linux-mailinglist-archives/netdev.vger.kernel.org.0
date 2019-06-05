Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B123E356FA
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 08:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFEGaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 02:30:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53423 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfFEGaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 02:30:25 -0400
Received: by mail-wm1-f67.google.com with SMTP id d17so974308wmb.3
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 23:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kurgYOyX3jnQd2CwmBmUOfCkz5QArXnn37OgMbFPaKg=;
        b=Fvjha0kmfYiRgZrsNyxnpBbn5W31rfj8yDFdyEFMHL0EbHhU/vDq8YueT6IJkd6jCY
         6d/z6kPsxX/1a6+CRzDJqbaz0zLlYZgyT3s9ArV2AflhLUbhHUC682wMUF+ZHjqd5XWz
         9aUtyGJlHJbs2R+h7lK97A8MvTBhe0T+pAP7XrP+xgT5myJorbYkB9/LjgTuE7oPf87k
         1jA/Tb8qAF7ry/YyPBWNL9HPE04jGTtyUiEO/v1iLIXCivQ07LYnrCpuoVn70E/IGBZI
         mc92RLpQf9XwBv6Gw9/HIr9WvyerCyJk/XW3BL0FlWRxAeEbS7u34yZelKV0QSHXKeQh
         UwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kurgYOyX3jnQd2CwmBmUOfCkz5QArXnn37OgMbFPaKg=;
        b=aydvQdSpbhchz9rifCUNVkuwdSp624IQWpw8D9gmXyagp9Lv+UVRP9MrBRSGy20ouG
         D5/cnGkWUlmEcRcy0yvl2aapS70R6fYUnfxJUK91n7EdNAHsrVeCdY282xRW4jZliGmk
         bQytLRTa7R3t9WEsEI2GxQaAXu0n5jEcE+R4Uc48qIlYEp6Gm3Kv6/jXViuEXvNQF71n
         jKDGQbAhIMS/EndY1Iz+7mNpahhi/LXRUk+nOo3P9MoGDxEJw7patDJEsXEb6PAvKCfy
         Ft5UH0lBiJE+gY7WDcWPbmK/nMDi5UJKzf4iS92hdQZvgdfC0KP9gCbMVpIDGfEnswJh
         botQ==
X-Gm-Message-State: APjAAAW3GTz4wlMdXDWDUIFCKqR85forG5sK/iBSGn41+N2TTdLg74J+
        Y/sfGyUNfsJ5fi2mo0pjhKqH9g==
X-Google-Smtp-Source: APXvYqyjKByjjy3SspperzVdyjGyRM2XvOWXjjDArECetwIHjbybJahsktcR170enj1V59FSIT5CgQ==
X-Received: by 2002:a1c:e715:: with SMTP id e21mr9291935wmh.16.1559716223192;
        Tue, 04 Jun 2019 23:30:23 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id t6sm12174719wmb.29.2019.06.04.23.30.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 23:30:22 -0700 (PDT)
Date:   Wed, 5 Jun 2019 08:30:21 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Message-ID: <20190605063021.GC3202@nanopsycho>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
 <20190604142819.cml2tbkmcj2mvkpl@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604142819.cml2tbkmcj2mvkpl@localhost>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jun 04, 2019 at 04:28:19PM CEST, richardcochran@gmail.com wrote:
>On Mon, Jun 03, 2019 at 03:12:42PM +0300, Ido Schimmel wrote:
>
>> +static int
>> +mlxsw_sp1_ptp_update_phc_settime(struct mlxsw_sp_ptp_clock *clock, u64 nsec)
>
>Six words ^^^

It is aligned with the rest of mlxsw code.
