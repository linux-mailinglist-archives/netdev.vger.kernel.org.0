Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9669D231F94
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgG2NuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgG2NuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:50:02 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8898EC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:50:02 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m16so11817516pls.5
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q/VNVR3PlpyXGobUaKBeyXjVVsKD4mDYZJ63Zh8bt4M=;
        b=H4bz89ONrMNv/6RD4lxXgGp8+mnJkgYeaHREoJI1OJBb1K8cvdEqTXrPsXx6g1bLZh
         jnJRu52t+77lV0Le6SMmSQbNBoLN8RTl2WOaIeyMpMfOPCuN/IF8g8eRbibrB8CguBNI
         26pXr6wue8bpfokcLS9nJNVeQAsMviVSlRN7MmiGtXfHpNIFGIQNMUSpvL5TE608PcyL
         mleylK7J2ek2uV2yTEXsUanhH2cN62mXIq4S27Cff1ykkGtFkNDZQKX5cgUiwmJVaPRN
         hh3Z9E8kPt0/On0RExqSEkdT+sirX/KQ+3+TgCL6pdsDSVC7C8uhd5WrQ/I+Q8Hr1QGG
         l7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=q/VNVR3PlpyXGobUaKBeyXjVVsKD4mDYZJ63Zh8bt4M=;
        b=WP8kpVZyV7lZeTsQuzaf2R7+tzcggK42Dxs+0W+aWhu5W5AZFSdLwYIUbiEJJFvDtz
         nHLBoNZoT9cZKG0AbEaaJgOba2vSPt90X93vgT+2hiEbr6jGV2JpBWPSHCCg2Q0siVt6
         NOtAA7/RuFuKZLBUyxrsY+Y6M1furiigV8mdGw3qHVEywwCH6eXEY7nGT+18WSBj3lAj
         8hWeOGnKo8RFpROXTtwBgjS4aBe7fc06ijvimAce8ttB7VR1smGgkRtO4QZIGhHpwiq3
         iJDUDNpPr0RFxKRYkqUg3Fdusor3AepcZErp/d7wiYqftxvk2Tif0+t6PzPxrka0V70m
         9GFA==
X-Gm-Message-State: AOAM5301IOuoWDc67Qfbg/w56NvOqPZEDbPSV2ptVG38nr0Kc+MR6LgH
        Zy7sS3lI7/tW6u48COncUbw=
X-Google-Smtp-Source: ABdhPJzvoDG9fG2hTDIoL0nxSjqK2YQ6QdgZRNEO/3Vctjs551iRZTeCa8uGaoSSX0dguclCZZK9yg==
X-Received: by 2002:a17:90a:b63:: with SMTP id 90mr10231895pjq.47.1596030602049;
        Wed, 29 Jul 2020 06:50:02 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x128sm2440648pfb.120.2020.07.29.06.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 06:50:01 -0700 (PDT)
Date:   Wed, 29 Jul 2020 06:49:58 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Petr Machata <petrm@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
Message-ID: <20200729134958.GC23222@hoboy>
References: <20200727090601.6500-1-kurt@linutronix.de>
 <20200727090601.6500-5-kurt@linutronix.de>
 <87a6zli04l.fsf@mellanox.com>
 <875za7sr7b.fsf@kurt>
 <87pn8fgxj3.fsf@mellanox.com>
 <20200729100257.GX1551@shell.armlinux.org.uk>
 <87sgdaaa2z.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgdaaa2z.fsf@kurt>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 12:29:08PM +0200, Kurt Kanzenbach wrote:

> I'll test it and send v3. But before, I've got another question that
> somebody might have an answer to:
> 
> The ptp v1 code always does locate the message type at
> 
>  msgtype = data + offset + OFF_PTP_CONTROL
> 
> OFF_PTP_CONTROL is 32. However, looking at the ptp v1 header, the
> message type is located at offset 20. What am I missing here?


My source back in the day was the John Eidson book.  In Appendix A it claims


                   Table A.1. Common PTP message fields

   Field name                    Purpose
   --------------------------------------------------------------------
   messageType                   Identifies message as event or general
   control                       Indicates the message type, e.g., Sync


So I think the code is correct.

Thanks,
Richard
