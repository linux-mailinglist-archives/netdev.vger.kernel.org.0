Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220AF3B33AB
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhFXQQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhFXQQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:16:28 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44816C061756;
        Thu, 24 Jun 2021 09:14:09 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c5so5585591pfv.8;
        Thu, 24 Jun 2021 09:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WfN0Frj56E6HhIm/MnEBVS0bsgQbJghIQhQlY6me8dE=;
        b=uU/ytBH9iiY4KwS1lIwKPyeQPs1e5wmGZ5AVCp4mENFSvwdbsDf1l8CpwVakNkhYvY
         AunZGpjEayBQ0voyqwJrZYQ4w7vRfXOy2ctSabQOe3CIwnTYAB539BggCPwD/1Q+IAbk
         /MEgruZMSmo2xNAJTM4THdIMr6+Yh17BzNBrbfhGE1YuRRrMZL1RQMJzo0Un0tDI+syD
         SiXvDJL8o6yBlne6ga1MDJkAdPHJvrK5azvwbWx0zASWttsInKVjYWR0X016ecXGvPRe
         AWk2Rf0lQ4z1Gl7GgZIYoCRCs/05onS26o5rG39RunGh66sPOpm+bCZBYqSTcgO7qOsX
         +txw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WfN0Frj56E6HhIm/MnEBVS0bsgQbJghIQhQlY6me8dE=;
        b=a6bn3N/4piS6HmATM4qINe7U6hPp891NND2QRcI+ea+iRO9ZxcITKmMYKafLPmX7KH
         Axf33na1xpYhz6gw3usy+5RnToq9Cope38ZzApUPw7TA2kIKA8K/Av4OogeSYenkVSPb
         GCFl154W5z3VZ8PBJSOw2MAsvLLRAS5a3HHvv2beKiz2YKjoHy0O6ScVdYKqSLR7XMo4
         pP2U/zCmItBGvUFf7I1i4xXbr9l8XzDzTiD6ynBleU9TY28jsWDe13UsVZ12Pf0B+4kT
         jzqiWbYUO+hNfAU7cKYJuXaHbjjmRGEsyTX427I3McZZKwIClYGl8CEUWYZS3axrHCtR
         yWCg==
X-Gm-Message-State: AOAM533DIMgo2b438j4J3ey2EAfKdQJ/9lsld0N96pU18BnO5kf0i8pI
        ZAdcmIqQffLJYZWYk98vY+SX76gR9dg=
X-Google-Smtp-Source: ABdhPJyK0biPLsUmi3b3iZ+WXm5UW24dKMy+pSyjKzs+6TkAXlllDoEZg25qVFkriaXNVDXBogyWTQ==
X-Received: by 2002:a63:2356:: with SMTP id u22mr5413589pgm.188.1624551248801;
        Thu, 24 Jun 2021 09:14:08 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o15sm3425870pfd.96.2021.06.24.09.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:14:08 -0700 (PDT)
Date:   Thu, 24 Jun 2021 09:14:06 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Message-ID: <20210624161406.GC15473@hoboy.vegasvil.org>
References: <1624459585-31233-1-git-send-email-min.li.xe@renesas.com>
 <20210624034026.GA6853@hoboy.vegasvil.org>
 <OS3PR01MB6593D3DCF7CE756E260548B3BA079@OS3PR01MB6593.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3PR01MB6593D3DCF7CE756E260548B3BA079@OS3PR01MB6593.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 02:38:46PM +0000, Min Li wrote:
> For linuxptp/ptp4l, we can use step_window to adapt to the slow adjtime.
> 
> I have tested this change with ptp4l for by setting step_window to 48 (assuming 16 packets per second)
> for both 8265.2/8275.1 and they performed well.

Yes, but that is a "magic" configuration that happens to work.

Don't you want your driver to work out of the box with every user
space program?

Thanks,
Richard
