Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A5E14CAC4
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 13:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgA2MXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 07:23:23 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40435 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgA2MXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 07:23:23 -0500
Received: by mail-ed1-f66.google.com with SMTP id p3so16647838edx.7
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 04:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kF8tDt5M8Kk3ENik9hWJMXdmqzdbY8geKJAdQAbvj/E=;
        b=mFxp3lCDdA/bYunpZSGHDJ77iP3tDC59SDgdP5hJmkyXTfXTwI1hoU446+gfGpLX+I
         fuU4tFm40+BTdjvKOewICujnNfpwLDHwi7IZ1JqXk5V6MalRqaX5ZCjFCOrQ380igBwG
         EYWatER5T9DrJemkxUxUvTqGyP7AhHPFpVLnX/FQWWjG8YSNN90yzE0bouswYWwcecdv
         PbUZ1oHH1vRSfqaBE2l2ag7ovtRnaydEsH3nWg21uk1LPmISdqOBFojJu8GLXJ/m+hu7
         4MSOgIz2O3PWEqS8oK1cteioThiIGovSGlVgoJa7lqWVpLsAIhfidBQ2F1WpF3S9oAfu
         UKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kF8tDt5M8Kk3ENik9hWJMXdmqzdbY8geKJAdQAbvj/E=;
        b=LFBu1lthX/PXSWG752RpL/8M2orwpW8GMcfvdVDfOxAisZfUS/9jZeWclb4AT8+lEl
         h8EPmhMiAyQTRc91SuM+DnvE6fe/T3WMKe5WsnI2wgvKcfNk9C2u3uUryrVUiFIi7eLH
         djplX6qctSB1J3eTETJDt6Klc+/z5vQYa86WJnjGuL8FSKd0dQH1C7oTFaNYLslKINv9
         URTQKnPe2/eqgcj9xt0dajjrEwXb+Te6mPiojEEv6DA5fMlkpXdu7FSB5qHRgeGxpFlI
         r59uoB8XmYhp8Wxccmp1wEWXy9mUUsyI3a1PsRSU2pmwN/R5bf4NiCutvQtAWEsS3XnW
         SOYg==
X-Gm-Message-State: APjAAAXNkH15rnj4qqmUx/HdlKJxtFngdtk47zD/T196SjZQFmKOsZ9E
        2sjnVF9p5YKtCzRKITOHtuJxVfxbWEtqdXfiNW8=
X-Google-Smtp-Source: APXvYqwljzAV8fEd2ASeJHrUqfxqEzLzOD+PfPxvxbGl5gVTy6mZn6lbVHU2i1LoGdxDQFVMpGcWXh9gz5uoXEQrAxs=
X-Received: by 2002:a17:906:f49:: with SMTP id h9mr7478789ejj.6.1580300601371;
 Wed, 29 Jan 2020 04:23:21 -0800 (PST)
MIME-Version: 1.0
References: <20200128235227.3942256-3-vinicius.gomes@intel.com>
 <20200129.111245.1611718557356636170.davem@davemloft.net> <CA+h21hoDDULPuhkEDCby0RBs+3r0angFVvyvazvedRTdWX_UYQ@mail.gmail.com>
 <20200129.130954.13079744457854627.davem@davemloft.net>
In-Reply-To: <20200129.130954.13079744457854627.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 29 Jan 2020 14:23:10 +0200
Message-ID: <CA+h21ho5_cWhfLF7nynTJ4=TbGPTO=Daq6k7Xu3tCrPEd7LRPQ@mail.gmail.com>
Subject: Re: [PATCH net v2 2/3] taprio: Allow users not to specify "flags"
 when changing schedules
To:     David Miller <davem@davemloft.net>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jan 2020 at 14:10, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Wed, 29 Jan 2020 13:24:30 +0200
>
> > At some point, the 5.3 kernel will go EOL. When would be a good time
> > to make the "flags" optional on "tc qdisc replace", without concerns
> > about different behavior across versions?
>
> 5.3, and 5.4, and... and how long do distros ship that kernel?
>
> This is why it is absolutely critical to flesh out all public
> facing interface concerns before the feature is merged into
> the tree rather than later.

So the answer to "when would be a good time" is "never"?

-Vladimir
