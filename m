Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A9B251BE9
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 17:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHYPLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 11:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgHYPLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 11:11:04 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA292C061574;
        Tue, 25 Aug 2020 08:11:03 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id 2so1915839wrj.10;
        Tue, 25 Aug 2020 08:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=zGwmmwPw3Le2wH1Emc9uaafD9ZICagjL8Io08HFMTg0=;
        b=kmIa3bGpCHQR9WehyCp7+1HD5BfIVmwhr7LEWscMsQYHBD/EgJwjdITfG/wmcw3M6F
         fAk5xFqYrAeIe5BsW5GS1XYU/+Zusmtr/JS8kzZnk8JyW030xuHZxwrBbaExW89LIbxU
         AQe4qPT1a5/UD+ZuoUUCkybUarwVq4QMRPAeiRHzR7USA6Osi9rZZ3YmggTHDwesXS5y
         biZA+TN+kQ1yrU9WbagW3BaNygWBCIvr4ECuc4Ds4vaaA0H7oWqHV90i8kvSKy11YTaz
         LGGKsX1Ii/hEzDx9iSVKYoDEsYa1E+7/JReAaicezSotN/TtuGe0w4Vy5N8bAFBEwK9m
         zfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:user-agent:mime-version
         :content-transfer-encoding;
        bh=zGwmmwPw3Le2wH1Emc9uaafD9ZICagjL8Io08HFMTg0=;
        b=Q06W/8+UQjFIigGBKu+iwHtiwIK2guAg+88vG7asyqILGJjwbzmghl5i+pbtPcKLLj
         wB4kEh1ANgJBWEKkj5k095QlF81e1YJLVrDRlm5ozLysnCEqHEhURLVjkVi75A0TvSs+
         Gn5jwxilqdp4qyfcaFV2N+h5PSxsgk+9bzJTxvHjh5YbE61L6zPOjLwvCWMAXBXyIwHo
         fQCEhGmhqOcAbLY5EWtnQe2ENsVgEJzOrVhFwgOr7UmZPAMt4pCNxVFBPHJYMAb+4+oi
         FyEdcMXJhQoDOwO+7KIs2qgd7JXDVIgc5cXZUa4j05VcmtUHwCneckeRtGjxo0BWKzTe
         CbnA==
X-Gm-Message-State: AOAM530cxdiDe8XTCyJTYr/5+3oWvqUt2G/JkMSYQ7ssVk9tVZ0jTEsk
        2deI6Xofpge6je04Uva6k11PwFpc7+s=
X-Google-Smtp-Source: ABdhPJwgBnGNu33aGEgjIVktAH11ksdR/aOlw+gqj6vInGkZPyORLyPKDOh+Vo+kPXgG9fTRRxmKsw==
X-Received: by 2002:adf:de8d:: with SMTP id w13mr10928850wrl.129.1598368262506;
        Tue, 25 Aug 2020 08:11:02 -0700 (PDT)
Received: from ?IPv6:2a02:8070:bb9:bc00::fc? ([2a02:8070:bb9:bc00::fc])
        by smtp.gmail.com with ESMTPSA id j11sm30262625wrq.69.2020.08.25.08.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 08:11:01 -0700 (PDT)
Message-ID: <c8915d7b91035e15dc87a4540a6dcfc5c4c0bf1a.camel@googlemail.com>
Subject: Re: v4.19.132: r8169: possible bug during load
From:   Christoph Fritz <chf.fritz@googlemail.com>
Reply-To: chf.fritz@googlemail.com
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 25 Aug 2020 17:11:01 +0200
In-Reply-To: <eab4f025-fabf-63fc-6bde-0a936cf2731b@gmail.com>
References: <c3193408e36e762a53a13867c0ea8e253147edf2.camel@googlemail.com>
         <eab4f025-fabf-63fc-6bde-0a936cf2731b@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-08-25 at 13:06 +0200, Heiner Kallweit wrote:
> I don't see how the improvement to the r8169 driver and the issues deep
> in the network stack should be related. Was the referenced r8169 commit
> result of a bisect?

Nope, just a best guess.

It takes some hours to hit the issue and most of the time there is no
trace, just a frozen OS.

> The Debian kernel may include additional Distro-specific patches.
> I'd recommend re-testing with mainline kernels.
> 
> Also 4.19 has been out for quite some time and boards with r8169-driven
> chips are very common (basically every consumer mainboard). In case of a
> general driver issue I'd expect to have received more such reports.
> Do you use any special network features on your system?

mhm, ... maybe a bit unusual load: a lot of tftp, NFS and KVM.

That's the first time I'm using a distro kernel. I guess I'll just dial
back and stick to backing mainline again.

Thanks
  -- Christoph

