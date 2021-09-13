Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD12409AC3
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 19:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243612AbhIMRja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 13:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242897AbhIMRj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 13:39:29 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDFDC061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 10:38:13 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id x11so22823013ejv.0
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 10:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+MRitPQl2pxVzd+pIB3zwppGCNnbYYgrJx5wkG2Mq2o=;
        b=gIga8BLD/NCD06cJup1fDBr6yQLTH71I50LN74l2zRsiPNoaqMkP8/rohPMuzfv79q
         vVAns3yplD/hHfSMWmmJP5dNQTLXmZjGPog3iYPLCEnThRiEyd6cGGAGWFqX3yi3Hwmy
         uQT7wH9i1Ya0merqNoPLR7D8qtrqDTmqfZXO+CbRvCqqyTa51VFo83hZvOwUlQmjdpv0
         fUgvPVi73L3nTSodtNqKEEeiA0WpV16Uox1pPyU45pnGwKnS4jb/wo9vHHR/2Jmv0eZ+
         OIILam+yDIeXehO4fBm8bk7vGcj2uBOM88QnaUh0ttGA0suJLYjMzkCGIQjFOahHGEaM
         T5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+MRitPQl2pxVzd+pIB3zwppGCNnbYYgrJx5wkG2Mq2o=;
        b=Psm0LxDlG0fl+oGbcLUBzKt0EyJrZ1QDVIdyk2rkxCwkeNUL8ANrnNbe3wskAqrzyh
         VUY/ZLiJSemDLE+MVUkwhfSudxEtuvSLw5aYmPfoulj+Fif72MaKr7c3dGcjntDQdh8w
         QlI3vFd8x4HmXCSZPip07Fp+Ovawvi8veNZQozYdy3aKS0PRwejUchBAv4t94H8Vfxni
         asoDDBYvFOGKP322Wf6/5c/3LyiTPqjhtcFpDMajUE0hvlFuJ/GV5aiDi9WECuWNDDWH
         sAkUDdw2p2N1f9C+WgdMXuXuztocTztnkaXfyN9ObXM3h2r04q9P0gKi1L3beJwwfAm8
         oj7A==
X-Gm-Message-State: AOAM531aULia8/1D8vl8e+voESig53vhPQsT+T5skgFs9w41r9s5tGvu
        qRLs0quXZthlJuFh8La3bB4sXD+44Jo=
X-Google-Smtp-Source: ABdhPJyRJ6KlZsWkT8FibGBWvRtVJE8nS8sdf6n1/uoASsZYTLv0pGPj+3jlA0fgbssigiafyyUAdQ==
X-Received: by 2002:a17:906:aeda:: with SMTP id me26mr8637076ejb.83.1631554692359;
        Mon, 13 Sep 2021 10:38:12 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id la17sm3688795ejb.80.2021.09.13.10.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 10:38:12 -0700 (PDT)
Date:   Mon, 13 Sep 2021 20:38:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 8/8] net: dsa: rtl8366: Drop and depromote
 pointless prints
Message-ID: <20210913173810.lrzuzan5vp7l7b4u@skbuf>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
 <20210913144300.1265143-9-linus.walleij@linaro.org>
 <7e029178-c46a-9dbb-2ee4-58d062f6e001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e029178-c46a-9dbb-2ee4-58d062f6e001@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 10:35:53AM -0700, Florian Fainelli wrote:
> On 9/13/2021 7:43 AM, Linus Walleij wrote:
> > We don't need a message for every VLAN association, dbg
> > is fine. The message about adding the DSA or CPU
> > port to a VLAN is directly misleading, this is perfectly
> > fine.
> > 
> > Cc: Vladimir Oltean <olteanv@gmail.com>
> > Cc: Mauri Sandberg <sandberg@mailfence.com>
> > Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> > Cc: Florian Fainelli <f.fainelli@gmail.com>
> > Cc: DENG Qingfang <dqfext@gmail.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Maybe at some point we should think about moving that kind of debugging
> messages towards the DSA core, and just leave drivers with debug prints that
> track an internal state not visible to the DSA framework.

I have some trace points on the bridge driver and in DSA for FDB
entries, maybe something along those lines?
