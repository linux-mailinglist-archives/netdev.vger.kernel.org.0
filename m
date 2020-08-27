Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E25C254AA9
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgH0QZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 12:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgH0QZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:25:57 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F93C061264;
        Thu, 27 Aug 2020 09:25:55 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x143so3909086pfc.4;
        Thu, 27 Aug 2020 09:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1HTBOiQwFo90quHJ+LNDvRWLBbY5CwhPJGAyaR2M3rE=;
        b=fgF1uQ8hk7szifJefmtG8YlLyBYbkFuO5D/fHJE2YABdNu3+qUvqRVor2R/kkHTHzZ
         aXLP27TSWWCRxjRwMZ2HAXGsVwd9iNkYXeN2k48SvF1xyUSoIZS3CljhbHJisqBK8yxa
         /4BTfA9urApZfXgXY0w75iGJHNRhMximsnQYC7muiV1V3GTU551YrjxM6Zm4nX9cmbSc
         BGleHLu7btgvDx4kfN4c8jtnpSA8vz5zsMS6Wj3pE+IxekWhsxnbm5jfw9ytgN36mTYs
         2eE8de0svmHfEk1xbeXZX1MwTMWSgis53LshKnenZlf0DgTkHPO8tLqvMJgKUNixO49k
         YquA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1HTBOiQwFo90quHJ+LNDvRWLBbY5CwhPJGAyaR2M3rE=;
        b=FbPK4j83bLjkKQpMBWwCoRNgAA8GJuf8DNKFDh7gW+STmdHy1OO0BlXuPtyzcETwjV
         4LVkDKDO+co8byJD5aQBMKkVk65ACIUXfZ1TaoZ4t3zvhkpz5o9V0Jb05qzie+JTYba8
         xXJ6ZgXT8iTxtv7y5zW4LuaJoYFApQU18i48fwlvkKzhWK36kICtqkx1ca6yxYu7/Rc5
         lbmVLcS356W3MbXvc/lyZzZ3812jZchrCIG0YkWHn+imrHDmo7yBft3SXqoQmxg7c0tr
         gkdMFTWeLpb6GivXOaWVWyxy3HrLdaVIoPrrkgXlJMrt/NlpELPCktCOMoAiCSZgr2ca
         JFxA==
X-Gm-Message-State: AOAM5310AJtAdxNHIzhupQRpIoqBNUIJFNJynBgTiREyCPkoMxm5ht9c
        +aYkrOHmeK25Jr+bIRRxB/A=
X-Google-Smtp-Source: ABdhPJzLm5ON71Oba+P4rBOhH2xDiarke+2hUWZAUpL5C2qgl29GPkob3YbUsPKsFduHMYJgE9YvMA==
X-Received: by 2002:a17:902:9349:: with SMTP id g9mr17114212plp.313.1598545554571;
        Thu, 27 Aug 2020 09:25:54 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id n72sm3490767pfd.93.2020.08.27.09.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 09:25:53 -0700 (PDT)
Date:   Thu, 27 Aug 2020 09:25:51 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
Message-ID: <20200827162551.GB13292@hoboy>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200820081118.10105-6-kurt@linutronix.de>
 <20200824225615.jtikfwyrxa7vxiq2@skbuf>
 <878se3133y.fsf@kurt>
 <20200825093830.r2zlpowtmhgwm6rz@skbuf>
 <871rjv123q.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rjv123q.fsf@kurt>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 11:55:37AM +0200, Kurt Kanzenbach wrote:
> 
> I get your point. But how to do it? We would need a timer based on the
> PTP clock in the switch.

Can't you use an hrtimer based on CLOCK_MONOTONIC?

I would expect the driver to work based solely on the device's clock.

Thanks,
Richard
