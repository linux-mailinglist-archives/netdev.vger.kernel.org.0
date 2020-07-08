Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C39218550
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 12:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgGHKzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 06:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgGHKzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 06:55:09 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E87C08C5DC;
        Wed,  8 Jul 2020 03:55:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m9so9549135pfh.0;
        Wed, 08 Jul 2020 03:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PBn0kG772UiRofP2vcjNJnGOHseI8tNLjt18LXfHgfM=;
        b=gBQTnyl5XQbz7QLwruwhpPZNpRDxt5cQZprhMlwkkb2tOSEoozJD6JurK8F/aIYp9r
         0FCfhI+IyHfRuVNgfb7PulpmQizTMiuNcV72ITUVpbmneuavA3eOKelwFFIuVQ4MtP0D
         0mdJNjRYy2ffNeNrCDrkHb0HwpyDx5xFYRj4TtQq/SI86iGLC93JfQs3dXR47omSWz0z
         WIzrJeGMdrURNQGDykSPdqVTGrGtUwxURq2j2p7/gibqwEMroAlDBXFu4MUwKF5oA62b
         mAqiyML/Tt3/nf63VpPqtBNil2XFSCdaA7ZnIx6sH6dvXUPpqbKT+//PUMCnCnr7wdey
         yXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PBn0kG772UiRofP2vcjNJnGOHseI8tNLjt18LXfHgfM=;
        b=p5CzGAG4jO+APHHIoT9qlXYE46mBKcWYFL/TEQc7vJmFQcvbZL63wjSSZRPPE45UgI
         K8dBg5X6m8AI5AFScw6k0ZoMce1kyHqMx8GVIpU9gqnTA3lsuXr2R7nJJqTr0imsJoYm
         tfTUlVqsR1Ii60Pzn1TadP5lPWO+jJtY6PiGHI9VuSJsvfPKdmB2Uw42aOVZd0YiNdo0
         kGfxt/ETjhxSlYCuCFpmTW82g9xNK1HdgsE1+rp+Jet5r6iBSyb4jUrdF/D0jSfB9d4G
         eG3qi/mKyZg/T+B0iMwis4lsux7jCeVThoq+qfo7XEAr5/HD7QUbD0y7+TayRGvpCGGw
         61WA==
X-Gm-Message-State: AOAM532yFbDDFXtwkZQ73SRb1Ou+0sHUnhxlwh4u1OT/7m+6vQ7aOrSM
        OyPP2nYYxUM47oIZXwz5GSQ=
X-Google-Smtp-Source: ABdhPJxDRRhChhbBwU6WplFG6NNjrSI88JLFqCzRTJ86Tmq94sqixN+4KdDzOUX2GRmEYYB8FFbCQw==
X-Received: by 2002:a63:5461:: with SMTP id e33mr38807251pgm.321.1594205709230;
        Wed, 08 Jul 2020 03:55:09 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id f131sm3828328pgc.14.2020.07.08.03.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 03:55:08 -0700 (PDT)
Date:   Wed, 8 Jul 2020 03:55:06 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch
Subject: Re: [PATCH  1/5] net: fec: properly support external PTP PHY for
 hardware time stamping
Message-ID: <20200708105506.GB9080@hoboy>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-2-sorganov@gmail.com>
 <20200706150814.kba7dh2dsz4mpiuc@skbuf>
 <87zh8cu0rs.fsf@osv.gnss.ru>
 <20200706154728.lfywhchrtaeeda4g@skbuf>
 <87zh8cqyrp.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh8cqyrp.fsf@osv.gnss.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 09:33:30PM +0300, Sergey Organov wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > On Mon, Jul 06, 2020 at 06:21:59PM +0300, Sergey Organov wrote:
> > Both are finicky in their own ways. There is no real way for the user to
> > select which PHC they want to use. The assumption is that you'd always
> > want to use the outermost one, and that things in the kernel side always
> > collaborate towards that end.

+1

In addition, for PHY time stamping you must enable the costly
CONFIG_NETWORK_PHY_TIMESTAMPING option at compile time, and so the
user most definitely wants the "outer" function.

> Makes sense, -- thanks for clarification! Indeed, if somebody connected
> that external thingy, chances are high it was made for a purpose.

Yes, exactly.

Thanks,
Richard
