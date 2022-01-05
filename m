Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D72E4859CD
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 21:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243870AbiAEUJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 15:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiAEUJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 15:09:55 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EAFC061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 12:09:54 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id p37so348327pfh.4
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 12:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eIfkhHCNLVveKZqHORZeVZkWuCfGvdjKa4I2e2SBo6Y=;
        b=lv/XegQtBt/wOX7nlBECei9SUENRvXhGwdftcwxAjPpN5ZqqKRl1oAmo4db6mA7Qlx
         c5nJq3fp5O10vFkmT7mZbOZubt48Ft0BvWN4ZrvUaAphRdUDYzZwj/vKLSOTFB+cgC8W
         b1Y/TmGT3jfrW8Mnz4MAdhhuoNM77JoBagdE27DLISXewbhHXgdI405NxabbzVfv2qic
         yTknLWpegqOyvHiENcimCg891CEyFI1dZpYMOwqb+79YoGl2tUjPnNmYZHK1xW1shFrU
         M00vZdgTdHBhrIkNixJXw47iFYwpjWdBxEQUUw8j4eH3YclFT472gOiPEhkYpgjtTbL2
         X9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eIfkhHCNLVveKZqHORZeVZkWuCfGvdjKa4I2e2SBo6Y=;
        b=iaxLN2hgKG5Iy4wPvIGCFBf3ghVewAPRTdtXtON5nD+13hO8zeH0wwik7/Cb/e+gH5
         srlPUcH2Aj6cC9Pmvdl8w0QikhknHHYfSkpZWrCoQ/Ng4EWE/T3YzsbpV02a9lA3Ma6E
         Cxv8XgtzDMmte6aQPKl2V44KKfP0Th4rUyUex10rd2Cj9aHusaiEHO8qn6g25FTSVVeH
         3ktVRRxRjRULYGItQ9Dy1mSw7CLsXJAFIUSe/sFSRFKp2lAraMUeUQpiTplzVRFtrCp6
         DXFAdlVVodKO5tiYuojDurP139kJ1h6qiD7XuByxUXURu2f1rTRZdubOBRDEsqHbdZNX
         tpgg==
X-Gm-Message-State: AOAM533MEymWh4tvqFhC3lepDKm7c7VEgNwqFCNXT1ieqjcEV+9yZ0db
        BBf4laS7n0ec8XhW6ljOl0s=
X-Google-Smtp-Source: ABdhPJw0xlLuuQEu/D/wtK61542zFKlK1FsmfHSb/f5Dd37QiIkYb66qlkMhsYuzJAaGQieWjLbbGw==
X-Received: by 2002:a05:6a00:16c7:b0:4a5:d9c1:89da with SMTP id l7-20020a056a0016c700b004a5d9c189damr57274397pfc.34.1641413394503;
        Wed, 05 Jan 2022 12:09:54 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k62sm3460038pja.23.2022.01.05.12.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 12:09:54 -0800 (PST)
Date:   Wed, 5 Jan 2022 12:09:52 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next] testptp: set pin function before other requests
Message-ID: <20220105200952.GA27023@hoboy.vegasvil.org>
References: <20220105152506.3256026-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105152506.3256026-1-mlichvar@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 04:25:06PM +0100, Miroslav Lichvar wrote:
> When the -L option of the testptp utility is specified with other
> options (e.g. -p to enable PPS output), the user probably wants to
> apply it to the pin configured by the -L option.
> 
> Reorder the code to set the pin function before other function requests
> to avoid confusing users.

Acked-by: Richard Cochran <richardcochran@gmail.com>
