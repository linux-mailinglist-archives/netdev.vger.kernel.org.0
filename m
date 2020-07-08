Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9032218579
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgGHLEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728589AbgGHLEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:04:47 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E364C08C5DC;
        Wed,  8 Jul 2020 04:04:47 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id z5so21501394pgb.6;
        Wed, 08 Jul 2020 04:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x5Oz9T0/nlpWj7gcRwNRrBgun+HLR/g5S659t05tKAk=;
        b=LR39heqMav7WHvZ4pKnrJQ31+4CyEVw+2hGuDisH+j9n1gkJwVc2/K6mxG1EQjfVil
         LIGEYplcDD5qpXFPV8tgnl3KRw8fbxbycvmGyxMWqGiq9Q3ph4o5oRCLRWDrKdWli+by
         K2ivVVunWUo+RHTwLF6uZtpR3HuqutuT1+xRXDuNSnW5Cy5Uwsy6qT8XR+16J4XQi1pb
         JpvHS3+4fBTNk6cV0cehgvv2T8it1xEcJ1UEMhQXNnAwEadlHIUJX7Re5TNCGBmLQ14e
         Szcu1XewElo2h5mjv/uqNISLi0pICRMI7+Cw5Zshlsz9/d92OMWqo6gCKvlaQ14N7krb
         2DxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x5Oz9T0/nlpWj7gcRwNRrBgun+HLR/g5S659t05tKAk=;
        b=bnGlypUo+N9hlMU6KzzAR1+oypsZWGRplZuP3gf4mUwxppKH6l/8ygr1tTyimIcLbP
         GHdOAq/7zxniqq0xyFrHXxcJpDoCGGDD+gpz+wrD72lRQJtl7NQwlUmH1I2s6uVBNNsy
         vbDoN4twklOX0V1zV2SxXnCgZyRB3q56+7A2yJNEkXU/zYauD8r2Fl29ElwV1CMdHvxh
         iLDUoquaNf7bydPxJMDwvSgJf401s2CPzmJeHQRsRGMGdwkdwvx1fqI++C2kX/pzLNZm
         aO2+fLose0tXCMEDODU/Dv+iHqsFnxut4sfZC5QFurWkOib1Z3fiTaQWFiIs57OPtwqf
         D6Bg==
X-Gm-Message-State: AOAM531Ca0WbvngjNp+Xio1H5cnQs52w0tm0uBNrRKzECMxi+Wop9gV9
        PUgdxzwxS4fuiSyQk1bXvmA=
X-Google-Smtp-Source: ABdhPJxb5ozr+JWoQl+Jz5jWG6SYLjXBLp6JNhv89WOi4DyJQNDOmtFEPYGpDsnU7XuR0T9m4Cl2xw==
X-Received: by 2002:a62:64ce:: with SMTP id y197mr31491046pfb.19.1594206286983;
        Wed, 08 Jul 2020 04:04:46 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d18sm5092249pjz.11.2020.07.08.04.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 04:04:46 -0700 (PDT)
Date:   Wed, 8 Jul 2020 04:04:44 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sergey Organov <sorganov@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
Message-ID: <20200708110444.GD9080@hoboy>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-4-sorganov@gmail.com>
 <20200706152721.3j54m73bm673zlnj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706152721.3j54m73bm673zlnj@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 06:27:21PM +0300, Vladimir Oltean wrote:
> There's no correct answer, I'm afraid. Whatever the default value of the
> clock may be, it's bound to be confusing for some reason, _if_ the
> reason why you're investigating it in the first place is a driver bug.
> Also, I don't really see how your change to use Jan 1st 1970 makes it
> any less confusing.

+1

For a PHC, the user of the clock must check the PTP stack's
synchronization flags via the management interface to know the status
of the time signal.

Thanks,
Richard
