Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F027B2BB908
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgKTWaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728852AbgKTWaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:30:13 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCB7C0613CF;
        Fri, 20 Nov 2020 14:30:13 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id a16so15029792ejj.5;
        Fri, 20 Nov 2020 14:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZBbL+XDUqpoQ3rGpeupy5JBX0nq/L9G4dN5u1AMzhbc=;
        b=QwY/yWT3XA8vJM9VTbxoxoVwHFFsvjypbln5aXIaizabw4k2SRpZ0OayIF4RY6TWab
         LuBaxc6SjofwoT5UdmUCHs8x2G9+C1RVQ96qan8dsRkNbHJSN9J2lnCHEIZPc9R8YQxy
         1JVzjkbxZwHaaxDs9hEz3pu4zapzwH7r7YtRq+dvTxX5zk292ML+UPx/7n6akmFGmUQQ
         bkJGkq1cGEsdRFOXcxCnsWaKvSXkhLlbQGXhUb7MIQzu6QdRvpgAhtyMCE8LQuAU9EUl
         amfFB+mwJQHZhWNxiB20gnIZIxg+tL2d02fNYmTDFvAjSHAKtWbxj6HSipccGf8XY5OE
         UXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZBbL+XDUqpoQ3rGpeupy5JBX0nq/L9G4dN5u1AMzhbc=;
        b=M6EBc6gbNajr70VCbTPJn+5j04khzrCmfE0Hm3nDt/zDj9LmrcKZM4VfTp9gcFgnPl
         cMNlgQ7R9X4cY86okZchWYp1O0qAM95a/opsr4KBD7uIeRGTqCkh/HvOEdY1t9egl3s5
         dF19CFFsrN2sGM+SbzZ6dosDz9ssUXeVkjmjh3vd4mMhrmYFOTv4gRWegos0beGWS3YO
         NKWQgW0FpMwLQc7lo4RUXzqRP4tTwK5FEkA+hvFIKPlq9OrriuHlOiZLGEAgtsOTLpGr
         q8SKLnXrr5LCkVXX+/V6egsB7KUfbF22XNTbDO1JPP60f0pfSaeeAgiXZ32kGQ3O3Z4n
         /KJg==
X-Gm-Message-State: AOAM533OrO+uEiNjK98TdFqLAO59I589PSkhJA/pUUqqtWk9uLvaeyHJ
        KxViZk30wDg9XZq2Wnjjagw=
X-Google-Smtp-Source: ABdhPJwpb3solTwHPeYfKHmx/1TYo0NKPUCYhJN83s+O6ZF+5MqRptHkywKMT0ZnUFpaxwwq3ZVRJw==
X-Received: by 2002:a17:906:ca93:: with SMTP id js19mr33813254ejb.124.1605911412048;
        Fri, 20 Nov 2020 14:30:12 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id k17sm396109ejh.103.2020.11.20.14.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 14:30:11 -0800 (PST)
Date:   Sat, 21 Nov 2020 00:30:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net-next v3 1/3] net: ptp: introduce common defines for
 PTP message types
Message-ID: <20201120223009.dffsl5ihqhslndlj@skbuf>
References: <20201120084106.10046-1-ceggers@arri.de>
 <20201120084106.10046-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120084106.10046-2-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 09:41:04AM +0100, Christian Eggers wrote:
> Using PTP wide defines will obsolete different driver internal defines
> and uses of magic numbers.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
