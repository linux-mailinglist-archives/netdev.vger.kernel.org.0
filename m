Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8216A3F9F16
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhH0SqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhH0SqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 14:46:18 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46239C061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:45:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a25so15799581ejv.6
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1gMWtXIh7PEGe96PRzvOtkeA/0pp5vwSevNduWK9GgU=;
        b=On1PktVfsjXwx2E+mJx72OaZEtbVz3S56lzS4AwBeW45v6SQaZcaZZVF+3rrhtXHqu
         MEEW1GVGyu4QrxgaWLO+8djMQSmMbWsUKYeqtUfzWSb3dfEz9ymEoAleB1CQX1xoqcX+
         lRMrU1Ius6rJocsXAfyfgjoNOjIJeGgPTGOkwBHi1HrgXkkRJQdFAsvW4lA1F03bV+PY
         CgY7NjriFN+ex/A/FF8Zo4pswnSFalaHu9ONjFkxxvOmEnUh2usj5yNtuF8qS9wYJ5XN
         pKdIywVX9mv4eNYc6EPwDnF4oAHNoAAmgC8ctMDg6IaGroLNtsj/6vWq3cTvh9XlH7us
         6zsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1gMWtXIh7PEGe96PRzvOtkeA/0pp5vwSevNduWK9GgU=;
        b=MqQcuS43tNFK68xeShwM5SwGvbT5Zi1xQfczzyM62DYtUzA7gXR9MxYHeQkysIxTRS
         yqq50pidgj9y5Blp43YwT2PpZCa4czDOmBKSFQVRe/naLhIifUFJ4N0bdESD7CETBvsH
         w13MCmCdlNIFHQ0bWecLvLRgn636yuM5Ew1kISEZ/Mqxvx/Rz52zrnhqVop/mVHFXQJo
         RIx5tlLctVqiUzbirSlndKnmnNtBy3LO+jwN2GSlu9jEAOTyOkbmuI5A44ZQivRKPHrt
         i30LlaFoc9XrSMmOzPYk0Yj/J65CYHhZwzpOgDqyH3l/ox7cPb5Z/J28p/nqcI5GyOTV
         j+iw==
X-Gm-Message-State: AOAM5303mIt1g87lOdlPpdrk5GxVtB1NBSV4h+O5yx+jpmYYwD738rG/
        J8YOKJncvHJN3CQNT844MfOIvD3ecp8=
X-Google-Smtp-Source: ABdhPJw7Ss91DTiqppNRPStftmM1OKny9vTYFEcDeoE//gyLCsq+UO+DSTNbotYMK45ERMNXGNbw8A==
X-Received: by 2002:a17:907:98ce:: with SMTP id kd14mr11534296ejc.440.1630089927828;
        Fri, 27 Aug 2021 11:45:27 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id d22sm3296324ejk.5.2021.08.27.11.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 11:45:27 -0700 (PDT)
Date:   Fri, 27 Aug 2021 21:45:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: stop calling
 irq_domain_add_simple with the reg_lock held
Message-ID: <20210827184525.p44pir5or4h5nwgk@skbuf>
References: <20210827180101.2330929-1-vladimir.oltean@nxp.com>
 <YSkwOWoynVOs5i8n@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSkwOWoynVOs5i8n@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 08:34:33PM +0200, Andrew Lunn wrote:
> On Fri, Aug 27, 2021 at 09:01:01PM +0300, Vladimir Oltean wrote:
> > The mv88e6xxx IRQ setup code has some pretty horrible locking patterns,
> > and wrong.
>
> I agree about the patterns. But it has been lockdep clean, i spent a
> while testing it, failed probes, unloads etc, and adding comments.
>
> I suspect it is now wrong because of core changes.

It's true, it is lockdep-clean the way it is structured now, but I
suspect that is purely by chance. I had to shift code around a bit to
get lockdep to shout, my bad for not really mentioning it: I moved
mv88e6xxx_mdios_register from mv88e6xxx_probe to mv88e6xxx_setup, all in
all a relatively superficial change (I am trying to test something out),
hence the reason why I did not believe it would make such a huge
difference.

I realize now it puts you in a bad light since it suggests you didn't
test it with lockdep, and I apologize.

> > Only hardware access should need the register lock, and this in itself
> > is for the mv88e6xxx_smi_indirect_ops to work properly and nothing more,
> > unless I'm misunderstanding something
>
> Historically, reg_lock has been used to serialize all access to the
> hardware across entries points into the driver. Not everything takes
> rtnl lock. Clearly, interrupts don't. I don't know if PTP takes it. In
> the past there was been hwmon code, etc. The reg_lock is used to
> serialize all this. The patterns of all entry points into the driver
> taking the lock has in general worked well. Just interrupt code is a
> pain.

I empathize with working in the blind w.r.t. locking, when rtnl_mutex
covers everything. As you point out, threaded interrupts do not the
rtnl_lock, so that is a good opportunity to analyze what needs serialization,
which I do not have on sja1105. Nonetheless, my experience is that
hardware is a pretty parallel/reentrant beast, a "register lock" is
almost always the wrong answer. IMHO, proper locking would need to find
what are the sequences of SMI reads/writes that need to be indivisible,
and only lock around those, and lock per topic if possible.

> > Fixes: dc30c35be720 ("net: dsa: mv88e6xxx: Implement interrupt support.")
>
> As i said, i suspect this is the wrong commit. You need to look at
> changes to the interrupt core. There is even a danger that if this
> gets backported too far, it could add deadlocks.

Ok, retarget to "net-next"?
