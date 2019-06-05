Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA1836268
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 19:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfFERY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 13:24:57 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33221 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFERY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 13:24:57 -0400
Received: by mail-pl1-f193.google.com with SMTP id g21so9944633plq.0
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 10:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nZ+eJe1Rb95EYE6BH3kgT1HyzegHVIc/U3qyme32T/Y=;
        b=K69GP6adbrrQTtKXQHKiuKrARR+5FOfgh22RnKGT+S3fC85nXjnIpWhtnDQE197COj
         KFba6fP6gpn84/qhwdzXpePfFhkbNIsN9rOLQwWNSE1ZgtA0gStHB0I32QjqZf3trUaY
         xuSbJ5VDNjdYhloGq3BZOyztdzFqjQ1pTWxQen1hHYzz8p00ifGAd3BYEMm6Ed6sIHA7
         c4jtpssdGAIkDRlm4AJvp3SasY5KvrUfVN40NWuwiUDr+eLP/GpdIw32sQxtiPZ3gHLV
         5jBpg1Te6ejaoPFrjJw90INn513pm4qnsA0ginB8boHtT4NTbKnkJCiz0jnZYc4WDuhg
         NcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nZ+eJe1Rb95EYE6BH3kgT1HyzegHVIc/U3qyme32T/Y=;
        b=DE7qjrhliBPX/Ojg+W3QJ0Sl5yqftnjQYEfqiiIKvnJtQ/iW65T0GKty5BciA3p9Yu
         A+XKNrw2PQtsQw9AnmVibpus3aL2wEkxgMmV5rzoTM43Gw7q7guvRb4TpBc4EBYrwFIS
         2h4270wmfZKDIK7zl5Jus2BPMfvMeWOTTbJDoZo/oJPNvf3efHI5SFgY/OfBM5yzVuSp
         uAIxa5Eh700fy+FKbG12prbLZ8B//JygVAgRbYu83+mG+1E8cXqqJUOAInoGSW5Wh5ym
         9BAk01ma3OOdmkvN1priBejU6c1HuLpvuLx5HOgo+hoPrd82pYs44JC2BW0RykDoWEnm
         KOsw==
X-Gm-Message-State: APjAAAWXWw5t1l5ckv0ZbCfzIj6EYrqNuxZ1TpZNgqavNd+aCUSEte8U
        EOmHRKI/sjYf8qTNCjqhtd8hIANs
X-Google-Smtp-Source: APXvYqxQWgI1O3U4JCqM3EzJNDPeZt82Bqefa8pHaDSnvjpASTbP5dLhESnXdmLgyU6L2OIIjAM70g==
X-Received: by 2002:a17:902:a716:: with SMTP id w22mr44971707plq.270.1559755497126;
        Wed, 05 Jun 2019 10:24:57 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 144sm16015336pfy.54.2019.06.05.10.24.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 10:24:56 -0700 (PDT)
Date:   Wed, 5 Jun 2019 10:24:54 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Message-ID: <20190605172454.h4w2y5qkfgl47hn2@localhost>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
 <20190604142819.cml2tbkmcj2mvkpl@localhost>
 <20190605063021.GC3202@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605063021.GC3202@nanopsycho>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 08:30:21AM +0200, Jiri Pirko wrote:
> Tue, Jun 04, 2019 at 04:28:19PM CEST, richardcochran@gmail.com wrote:
> >On Mon, Jun 03, 2019 at 03:12:42PM +0300, Ido Schimmel wrote:
> >
> >> +static int
> >> +mlxsw_sp1_ptp_update_phc_settime(struct mlxsw_sp_ptp_clock *clock, u64 nsec)
> >
> >Six words ^^^
> 
> It is aligned with the rest of mlxsw code.

Those can be fixed, too.

Thanks,
Richard
