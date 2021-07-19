Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9D13CE837
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353178AbhGSQjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355441AbhGSQgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:19 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92000C06E447
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:47:05 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id q190so17394844qkd.2
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IZ/aMT3ojtxRKoI8qNJQ76GzxDBvFdKj8PzjnETaVWM=;
        b=UdwRH6kU0+sAP8CZAy13RM4YVLi3lvRvXz3BbrQUDOVQ8HfS9/APOlSSJ6NatwAGj6
         arm36EuNk1bzVpCZrr+bh0Ej5GjkDHZswe01sErFtYc4EXKr8uhLWHsoJXlJv07LUINr
         OfRDH3dLH6rTA9n2IPNA/z3M4qc1uKOdYojqMApM/2Dcz+F24b/QaqLd3I1TJsbeLrYy
         7GjJBbbpkWezmnBxZ6Nio7ItPlLClzasVzycCHLYJdAbnKqDgtoIU3wzRZPkSsqk9fCq
         9LlGsVzFJ0lCA6q774ybqjw18+OBdp8OGPSVaaFaof1XO4X1uXpShzdPEGgffoTGpZ6j
         CX8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IZ/aMT3ojtxRKoI8qNJQ76GzxDBvFdKj8PzjnETaVWM=;
        b=LGs4zFeay+WpNx1GsW14x59CyFrkOtExEtKCJcPsUBzM9c31ZBx2J0lOIaIzfq/Z8g
         QgEn84g/77yPon/Q/QxnhCYkb66/WIDOBW92tPLmNWBKU3bmp6FTQnWfiIJ/UhErSfRa
         gptmnf0XE0O1yGm4DJjtmGGJyAyAHS45e6y6ZsgTHOvxM++WJwKpdVX2Dk/ecUUBu3Q+
         hTEpuGKQOyeEPB2GqBtwfX8xbLRL648+EmAhhZEPDhLU/8g9UlKuSq2zOwk6PFu7RSFx
         WmIeEGHpY+FF4esgx9PQ/JQKpdp/I7+7rto4vrAsPfTHlJAOFv6DwrftjYUx+tXrPm3v
         af4w==
X-Gm-Message-State: AOAM530MR+zFVm8KBPThDg+B/1Yc38dCPrkY1jsmnIB48yQ0udCUkioq
        pnhc8RC2HLGgHlNf/cAnzs8=
X-Google-Smtp-Source: ABdhPJzXIBwAHmzPTu/KYAu9HMOJMACVNcsLaZZmQ2f3NKBaFw2fm624FXd+KZjKy0jjmo8H5Ljhtg==
X-Received: by 2002:a05:620a:3186:: with SMTP id bi6mr25632624qkb.472.1626714451484;
        Mon, 19 Jul 2021 10:07:31 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:194:8382:2ab0:871:9ac6:c7bd:f923])
        by smtp.gmail.com with ESMTPSA id c15sm4348376qtc.37.2021.07.19.10.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:07:31 -0700 (PDT)
Date:   Mon, 19 Jul 2021 10:07:28 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net 8/9] bnxt_en: Move bnxt_ptp_init() to bnxt_open()
Message-ID: <20210719170728.GB5568@hoboy.vegasvil.org>
References: <1626636993-31926-1-git-send-email-michael.chan@broadcom.com>
 <1626636993-31926-9-git-send-email-michael.chan@broadcom.com>
 <20210719124323.085fa184@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719124323.085fa184@cakuba>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 12:43:23PM +0200, Jakub Kicinski wrote:
> On Sun, 18 Jul 2021 15:36:32 -0400, Michael Chan wrote:
> > The device needs to be in ifup state for PTP to function, so move
> > bnxt_ptp_init() to bnxt_open().  This means that the PHC will be
> > registered during bnxt_open().
> 
> I think it's an anti-pattern to have the clock registered only when
> the device is up. Right, Richard?

Yes, indeed.

> IIRC Intel parts did it in the past because they had the clock hooked
> up to the MAC/PHY so the clock was not actually ticking. But seems like
> a wrong trade off to unreg PTP for SW convenience. Or maybe I'm
> biased against the live FW reset :) Let's see if Richard agrees.

Totally agree!

Ideally the PHC appears as soon as the driver instantiates for a HW
device.  Telling time from the clock is independent from the network
interface being up or down.

Some drivers are lazy and fail to decouple these two orthogonal
issues.  In some (all?) cases, there is no HW limitation involved,
just sloppy driver work.

Thanks,
Richard



