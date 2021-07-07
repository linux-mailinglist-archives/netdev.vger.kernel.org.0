Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325683BE98D
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhGGOTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbhGGOTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:19:31 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AEEC061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 07:16:50 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ie21so1661256pjb.0
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 07:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uJSdheoq4GumqWc4wbxihqldMl1XEJjJZsDk1VuJaMk=;
        b=g8MdTjWZKx3AJjVyY3/FxRBN6AQDIWEOilzoJ2XDrYVTaAPwSbFXYhptuJl6fH+LsE
         PrYPRolfPQ503NpU4eie8tjEnhh9ST4fpXRLMThldmEq6h4VBGgu1BdVvKpQPNSO5u7L
         M1yAeh0r5L/LbqJVF/XXBfwrEwyAdoVxk2XgjM2/ZKYWCMZaVBp+v97ukOyk4JB3BoZn
         3D7gQnw2io96fdCHsvGRAMTGbFcrvjDpFNurc7haPjelUL4OkUs4pDPW1PV6aO5C4I8H
         5Td7q5dKzvjToqmeeuATLco9usCZGnwqHdttPLC9RPhPcPMzNmmcBOdkEGtL1RdKiT4l
         tCDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uJSdheoq4GumqWc4wbxihqldMl1XEJjJZsDk1VuJaMk=;
        b=eb4TMx74I5OZUema3VL+/kQiGIxyZmG1ayQ3J15AqKkSUV5+6E0ETi36Pn2isX5CvT
         4TF01hRuOBH4hWbbzXnlso9qtzNCUiWc/z/QB0ELZqUatyedn0mnyW0FRkTDKnW+8dec
         L0irdmhslXHTa7xY5PTAfF6Ph7DTfqszZ76DPltEnvd8oq1q9A7n8WhfmIBvel7vSCLx
         V0VtOO3Mir8Haa54P7WGhQ7+FnylBRKAM9yn9dVxipOCDy9a3UN2NZ1YB+g2QR004+u6
         dz11M8VAfpG8AErMxJU8wAWzzaaFcMossaJ1uZf5RFJkyR+F6LJ7HrI5Ikp0ZUNr1VLx
         L/Dg==
X-Gm-Message-State: AOAM532Aq1mtGNpoM4zsB4F4WkNyaxYB+6uTLLOk/Ub+I45T6JD/uHXR
        fNxavPlPg/PZw+yXHa1O2BM=
X-Google-Smtp-Source: ABdhPJycQ/PhFrHC7EpslwHRWUQSVkT0R3qvD0ZoPJmLoSlLDJqptvlRXEOGCDo6Zp78y7A0FSqAPg==
X-Received: by 2002:a17:902:d20a:b029:129:b7ab:a248 with SMTP id t10-20020a170902d20ab0290129b7aba248mr5606126ply.32.1625667410600;
        Wed, 07 Jul 2021 07:16:50 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a15sm20510152pff.128.2021.07.07.07.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 07:16:50 -0700 (PDT)
Date:   Wed, 7 Jul 2021 07:16:47 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, olteanv@gmail.com, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] ptp: Relocate lookup cookie to correct block.
Message-ID: <20210707141647.GB14834@hoboy.vegasvil.org>
References: <20210707002712.1896336-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707002712.1896336-1-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 05:27:12PM -0700, Jonathan Lemon wrote:
> An earlier commit set the pps_lookup cookie, but the line
> was somehow added to the wrong code block.  Correct this.
> 
> Fixes: 8602e40fc813 ("ptp: Set lookup cookie when creating a PTP PPS source.")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
