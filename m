Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B401B4446F4
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhKCRXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbhKCRXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 13:23:41 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5E4C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 10:21:05 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h24so691372pjq.2
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 10:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Ez66n9LK5JSiVUxv2um/dQt/nZzmzprL+/z4JZ4EeV0=;
        b=PUgCtyjG+vFbL9ovC4Q2UNdd7zn61Q3ZrcKGVcERO5ME3MC+F40IFKsKpSNaFGPVgC
         a1ohf6nn0jC4dq9XP5wzPOMlZq0mPGJK1U4o5f8oOco/kGvS4fyssGqJcAZGevQwbO6+
         2icZkmpD8ACeCBP9gHtwGYept5pWTAftnLO+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Ez66n9LK5JSiVUxv2um/dQt/nZzmzprL+/z4JZ4EeV0=;
        b=GkRNgyXiNZ4qLX2BpsgZYG7tW7EIjdqcJL3JTQim3oQC+7dTcN+wkUhrT2zL9+yhGF
         p5+6eR77/ZZ26g/B4LjM+/Ugrzvmw8/AZeuU8XCCfpUXHAex95fBIB9gtqkQwjhtDXxi
         ddqp4Z7m3Hau/Y0EpUutEnLTlIqAT4/kG3regKc8z9U4vcI0mOezutDtAhRpHjTx3x4b
         Fc/kFu0GOHDFXFQN3j7u8PAZHI9uoSGFaqJ/REJnS04yhF8gGjQZhbM7E4bsViJzHzKf
         8R0ZZw/gixUc5DKggK/BvPZbofyrmILxopXwvtojhyFduJMFLS+rIGRJeHJmFZFOutGr
         buUw==
X-Gm-Message-State: AOAM533Nwcf1JheTOnAi0BuxZsPw/1AJpax/35Gmy7Ib3vvqTOXIPAO8
        fbbmYux3oRxmyF4+/NfGI7eCaA==
X-Google-Smtp-Source: ABdhPJz8Bb5eOQliSMGFdLYIGmLvUuFE+uiIi+hWqTOovtZg4jZhuJDUB02SYkeY57Lbhi/NmsFTxw==
X-Received: by 2002:a17:902:e5ce:b0:142:780:78db with SMTP id u14-20020a170902e5ce00b00142078078dbmr12506491plf.12.1635960064880;
        Wed, 03 Nov 2021 10:21:04 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:c80d:e9d8:d115:daf])
        by smtp.gmail.com with ESMTPSA id h11sm3325256pfc.131.2021.11.03.10.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 10:21:03 -0700 (PDT)
Date:   Wed, 3 Nov 2021 10:21:01 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH] mwifiex: Add quirk to disable deep sleep with certain
 hardware revision
Message-ID: <YYLE/QFd+qeSlwU9@google.com>
References: <20211028073729.24408-1-verdre@v0yd.nl>
 <CA+ASDXOrad3b=b8+vwuF6m3+ZcigVaoJySpDXXZOnC3O8CJBSw@mail.gmail.com>
 <cc7432f4-824a-abe2-e304-5ba019ac8c89@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc7432f4-824a-abe2-e304-5ba019ac8c89@v0yd.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 01:25:44PM +0100, Jonas Dreßler wrote:
> The issue only appeared for some community members using Surface devices,
> happening on the Surface Book 2 of one person, but not on the Surface Book
> 2 of another person. When investigating we were poking around in the dark
> for a long time and almost gave up until we found that those two devices
> had different hardware revisions of the same wifi card installed (ChipRev
> 20 vs 21).
> 
> So it seems pretty clear that with revision 21 they fixed some hardware
> bug that causes those spurious wakeups.

Seems reasonable, thanks for the thorough handling!

> FWIW, obviously a proper workaround for this would have to be implemented
> in the firmware.

Yeah, but you only get those if you're a paying customer apparently :(

I wonder if the original OEM got firmware fixes, but because they don't
use Linux, nobody bothered to roll those into the linux-firmware repo.

Brian
