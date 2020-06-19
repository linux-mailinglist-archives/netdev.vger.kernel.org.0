Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E43200AD5
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 16:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731756AbgFSOAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgFSOAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 10:00:31 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CE5C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 07:00:31 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g21so4780133wmg.0
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 07:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9M6xa39EBPyQvKuxTvUU9Wh4yN8vcLKFgzkUFTvszhE=;
        b=U5tosM1dXPdWYH1DSyrpAv29nUYkLYFJruKRYE/ObYeQ9fOknRYHr4iryrh5KHJrZO
         eg9WTw9n7SPT2TVHJSyXtCfHBbqas3oUHnpU0EYm29e1XM+lyNCY0tA21KOJ7EzXoHmW
         T4xbKwE03g9g+QSqMY8tov8CdBBfAKEab9RyJMmMGicexTl9SWf1UeWsFMn/z1yFHJzi
         S8BkpM8Ls7rbtczQJOwpp6ocz5Xi5Q3PEgWHkrc97UgMp/DkTLOqs50cYe8sz2M75vxd
         PfZH3cRhvs9u2jvVqPxvjEdCj5U5JqCTO+XdH07IxlwlBjCx4id//iwCm/IH53u3XL6i
         Zt3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9M6xa39EBPyQvKuxTvUU9Wh4yN8vcLKFgzkUFTvszhE=;
        b=ZAZUgaWUEmOm/eWtPY8pb3cyzzRFMS4jcGo0+MRJC3joX2MkhPiUtJ+VgFK0R+IY8d
         jloRyAo8rrGOoHcSxgufMDxG8tdaVZlD0fTxWkjRCwxBPLgfFZ1yoQSTuouUxeyQQVQ7
         vOZ8963IFMXyHKb23gvR9jIjD5YpAtt1Xn71bvczyEwrsQmdb258vw4fF3Fzog4cC5Ru
         vGFPCL82Ww3mNpxXqUeADMqTiGLNndyo7DMvOfCI+jv5Q3qnBUda7wSmUIYyvp/uSSMb
         Z8vsMLCMDc1eZ7fSkzsMTwKjg5Eo9mRN6YJWAcdLeOIWHOVRPOOvC4F+8KvnTSIkqQNC
         a1qA==
X-Gm-Message-State: AOAM53130efdPlZwIIo982CNQoNuXPBM7DylYL57qOtDEVgiAHHvatfF
        txDIFllF9ZHRck8wH90DqBZXCA==
X-Google-Smtp-Source: ABdhPJxCfzuGLr2dAd54FZsx8F4Q4Qb/f5FT9ZpsxWjucJniuxLu0sjsJW+YKm/L7GRv6o5nMwL6pw==
X-Received: by 2002:a1c:1b17:: with SMTP id b23mr3829541wmb.3.1592575229884;
        Fri, 19 Jun 2020 07:00:29 -0700 (PDT)
Received: from localhost (ip-94-113-156-94.net.upcbroadband.cz. [94.113.156.94])
        by smtp.gmail.com with ESMTPSA id x66sm7095250wmb.40.2020.06.19.07.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 07:00:29 -0700 (PDT)
Date:   Fri, 19 Jun 2020 16:00:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     dsatish <satish.d@oneconvergence.com>
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        simon.horman@netronome.com, kesavac@gmail.com,
        prathibha.nagooru@oneconvergence.com,
        intiyaz.basha@oneconvergence.com, jai.rana@oneconvergence.com
Subject: Re: [PATCH net-next 2/3] cls_flower: Pass the unmasked key to hw
Message-ID: <20200619140028.GA2182@nanopsycho>
References: <20200619094156.31184-1-satish.d@oneconvergence.com>
 <20200619094156.31184-3-satish.d@oneconvergence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619094156.31184-3-satish.d@oneconvergence.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jun 19, 2020 at 11:41:55AM CEST, satish.d@oneconvergence.com wrote:
>Pass the unmasked key along with the masked key to the hardware.
>This enables hardware to manage its own tables better based on the
>hardware features/capabilities.

I don't undertand the motivation. Could you provide some examples?
Also, as Ido pointed out already, you need to submit the driver changes
in this patchset too.
