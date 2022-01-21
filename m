Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C9A49620C
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 16:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381551AbiAUP22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 10:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381538AbiAUP2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 10:28:24 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2544C06173B;
        Fri, 21 Jan 2022 07:28:23 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v11-20020a17090a520b00b001b512482f36so6610617pjh.3;
        Fri, 21 Jan 2022 07:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r+33jODPoZ1MgqlKNkNxul3SU0pMB0I3n5t9zD6dBGk=;
        b=kwbppzcKwShSfAfBEK5YPEx2D4Mc+5bkBtvbNtUfkzDL3pqJIemqEgOZEeqCF4Gln/
         /58IM3B1dPeH4Rx1EA1wPrRt6jyh0RwQ4R0MhxoGaI4W7JBLVLUDnRqLXN/hXUNM3M8n
         S1OKuKeA+JabuHBpE2ZfygNAruuPCJYSD2+oPNLLKFNhqMjCDRVu66pR5+HUwMRFuRnQ
         npPJNd45IICP61BoLmcLjc2m1Y1JjPgyAa3dm51gEjzK+TfItUxIk9nGUzjxgdKPoA6Z
         uyEzdih1cLLzYJiM0i9VLYF7B7v4IdV12uW7dzMwv//yXs8ifPUYP/P+ymdRbeHGlZPD
         GWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=r+33jODPoZ1MgqlKNkNxul3SU0pMB0I3n5t9zD6dBGk=;
        b=L5IU+a88eXKg1ULfkk6mKwEdbOpovoPoBzo0XMuxxeG3dqeFuqnF3PL4vokTtz1ce/
         dD8nYW38lg8SsLhDJvmXeP/5ZH2qwIajbUrdGmqrNqjpLgE6iFgDPwu4NrC4hEPWdUKh
         6fhyWq6VGsBHliMmpo9ttKUykeN7eZ67HEEv7OfIsnLcziQPdpDPIDg6EE7JJqzDz7w5
         +mD5IH0wjnIY1OL5066YeYIq4jjD0gJALyxmgstBLSA3439QStfTk4LNlz1i+1KOyVJ0
         Q4bkbNOGtHzdGR32ILYwJ0PWBj4OLMyExVFs+O7Qhbdbk+eW4hnW5VXTh0uro2tnI0Bx
         pXGw==
X-Gm-Message-State: AOAM533zCDhkfbOmTxwPAQcdFnS+pl9hrnEnoMUGF0dyCzup6Gw7Px9X
        V0AjyX0dAoYXqObBrBuSedU=
X-Google-Smtp-Source: ABdhPJzdZ9cXUno+7zcJLzR+pWB3x/1OtU+OZbQyzdXi+nlSO0BTEpl7trLNjeN0zrwbIPcSCk2dYQ==
X-Received: by 2002:a17:903:1249:b0:149:a59c:145a with SMTP id u9-20020a170903124900b00149a59c145amr4181057plh.108.1642778903382;
        Fri, 21 Jan 2022 07:28:23 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b7sm8366640pju.42.2022.01.21.07.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 07:28:23 -0800 (PST)
Date:   Fri, 21 Jan 2022 07:28:20 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <20220121152820.GA15600@hoboy.vegasvil.org>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <20220120164832.xdebp5vykib6h6dp@skbuf>
 <Yeoqof1onvrcWGNp@lunn.ch>
 <20220121040508.GA7588@hoboy.vegasvil.org>
 <20220121145035.z4yv2qsub5mr7ljs@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121145035.z4yv2qsub5mr7ljs@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 02:50:36PM +0000, Vladimir Oltean wrote:
> So as I mentioned earlier, the use case would be hardware performance
> testing and diagnosing. You may consider that as not that important, but
> this is basically what I had to do for several months, and even wrote
> a program for that, that collects packet timestamps at all possible points.

This is not possible without making a brand new CMSG to accommodate
time stamps from all the various layers.

That is completely out of scope for this series.

The only practical use case of this series is to switch from PHY back to MAC.

Thanks,
Richard
