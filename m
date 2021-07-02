Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F663B9A8D
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 03:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhGBBbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 21:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbhGBBbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 21:31:33 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6747CC061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 18:29:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b12so6490542pfv.6
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 18:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wKaRT4oclA5LX4YD5bwhBUiTf56m8NS0XymmIaIcnC0=;
        b=ue7Pk3O5fG+Omfx1DpJDmmI7MoYjOleGOfy/cc48fzBaF4OMDkE05sYSQfGyVbh0XE
         v/7IXAcZ86aApMFKa/zDsVTs0C31t9KnKK6rKMzfb7doy3TfGMEgN/wkT/DPZJuoXt8z
         j4ENVfALyEbLsQV7DsNhv1fRGWrqtpuYP9KGhhFnYvIn1uFXyMz07/9zPc8Ej1LwEMJh
         nOT7ZhLvW7AAd/N2Erw86uEUntLswQk8EE6xpwbOBt48MdEOt/Z/nZuF7jkqqk/Z21EF
         gi6TpcfxH5Z3MjdBkbtQ14gf0DH8q8LGBtf8F1KD/4VRJqQnOMwy96qd3/iMPRfWV18B
         W2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wKaRT4oclA5LX4YD5bwhBUiTf56m8NS0XymmIaIcnC0=;
        b=Db2hhtI8REC+hre7XIvLcjZMxUzEMV9aeBC+zusJJfpmbo216SVYZW2jYzY+mKkSTq
         LOGjdh4t8uwT2HzsiljxsADoDbQWbdmOyZS0oxCRDN3Els2jMxuiDnG1eLYiPXR90UeY
         5mRFrzal8M3oXq2eSJVVElfpPWCJ31O8F+cAlefxrl9fJpBYKctUskS6tZ2wX6xi46wu
         AUsBp/SKX5DqiqJ77XvCS1Rk6a1G6IiX+PrxJs++5KwrZ+ZRtNSGcREhrNJS8YOjE2cD
         wcVGlGNTk4h0DH94iP2PDUATsRpxoYVOz69pLsJ+A5fHlfGlQqy4stVYSlhbeoBviyjK
         5XTw==
X-Gm-Message-State: AOAM531PJwSXq8UJ2idM0EyIxvfjLHs+rKWGqNIE1Zto5DCoWZwZuA/3
        TvFDpF+kW1bPsNskWNdvWsZ/D3cjrRA=
X-Google-Smtp-Source: ABdhPJwEWaK2cnNAqEJ6+8cnLWmn47c5Fhpv40kf+zM5x1NR5OhFd4WsGbcnOLvZRZFb9aGXBKHrjg==
X-Received: by 2002:a63:1a01:: with SMTP id a1mr2439969pga.269.1625189340760;
        Thu, 01 Jul 2021 18:29:00 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id gg18sm11423291pjb.0.2021.07.01.18.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 18:29:00 -0700 (PDT)
Date:   Thu, 1 Jul 2021 18:28:57 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] ptp: Set lookup cookie when creating a PTP PPS source.
Message-ID: <20210702012857.GA30639@hoboy.vegasvil.org>
References: <20210628182533.2930715-1-jonathan.lemon@gmail.com>
 <20210628233835.GB766@hoboy.vegasvil.org>
 <20210702003936.22m2rz7sajkwusaa@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702003936.22m2rz7sajkwusaa@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 03:39:36AM +0300, Vladimir Oltean wrote:

> Like perhaps the fact that ptp->pps_source is an arbitrary NULL pointer
> at the time the assignment to ->lookup_cookie is being made, because it
> is being created later?

Oops.  @Jonathan please submit a fix as soon as you can.  This patch
is already in net-next.

Thanks,
Richard

