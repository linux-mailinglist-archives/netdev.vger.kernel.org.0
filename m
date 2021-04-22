Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310FE368984
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239882AbhDVXyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbhDVXx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 19:53:56 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CACC061574;
        Thu, 22 Apr 2021 16:53:20 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id x12so50575578ejc.1;
        Thu, 22 Apr 2021 16:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VcDa7JXyDwZQNdFlc7drb+ntXTyxijC8uwkWEfms2sk=;
        b=MmXzJ2O1KRRvls1dEXShSLzxv0JGL8Kx530ZvzdbQERIBq/TgX0YTMMZWdk00ztzwF
         9z3ZSoPuygkS2vTvkRmzg2tQEDqbhIThBhOBtBjUI1XGGnDomtFarJqhtIv+VQKeBz+8
         uA2nqXPMCNHNe3Uuj5AGa4frw94eP4LGN0Yfd3OxQi0SiP1LyIsQaDghDdDDlLu+eTWv
         rDi0dQlBn1qH/03g4ZrmmOhrEyTnwGV+JdhcCXyA9uq6gLoLiu4+devjdZ95nmFFX/0P
         7bs+xPvBhHbXl1BwFlhD0RDhMVCik/+6mjdv0DO6z9G8DIUTK05F2UG7zcSktr4dJ3ZT
         TELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VcDa7JXyDwZQNdFlc7drb+ntXTyxijC8uwkWEfms2sk=;
        b=TZZUEqGJyOTQwsFSr5mEgt5gGJatIvmNGeeFrSPvCqsZyWR28LuVXqds15ypOdTj2Z
         35wISko2r1p6U+YIx1WgZb0QFXZRRaU2w8mZQLcryh5ntp9eyvspY0MvpWqT/7ZVGM7u
         iiEjh+uFL3ESFa6VB3TQD3rd9kKY8XWFJOT0WYzRNecNNZZ02hbbRH9VyoZ1hG5M8tQK
         uMq9ArNkm+nhXZS25wk/SNTGHAsgcNehaBSH8FUs0B7ohZgLdg8qWSsbkM8o/f03Wbba
         dYJhBBxORGtS7HqkzAFfZ6LKSOIw1pEOSMGWr1UNQvYB/U6CSvhlkpoVuWbRKRUrmbvM
         kNlA==
X-Gm-Message-State: AOAM532FfEpoOTZvB6fA9XAFGfh8twRa8L4W54bSbr0doR4OSMeUlNQw
        jYGvYX/87sE8MceA5N99OO0=
X-Google-Smtp-Source: ABdhPJyrAZLbURUoqCRaDyyb9i/t2CfKOuovMMhURawiXP0dnFM9p+9sIfy8o8Z3j/uSL4zsZIZWvw==
X-Received: by 2002:a17:906:2b05:: with SMTP id a5mr1219754ejg.446.1619135599168;
        Thu, 22 Apr 2021 16:53:19 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id jt20sm2755187ejb.79.2021.04.22.16.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 16:53:18 -0700 (PDT)
Date:   Fri, 23 Apr 2021 02:53:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     mohammad.athari.ismail@intel.com
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: pcs: Enable pre-emption packet for
 10/100Mbps
Message-ID: <20210422235317.erltirtrxnva5o2d@skbuf>
References: <20210422230645.23736-1-mohammad.athari.ismail@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422230645.23736-1-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mohammad,

On Fri, Apr 23, 2021 at 07:06:45AM +0800, mohammad.athari.ismail@intel.com wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> Set VR_MII_DIG_CTRL1 bit-6(PRE_EMP) to enable pre-emption packet for
> 10/100Mbps by default. This setting doesn`t impact pre-emption
> capability for other speeds.
> 
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> ---

What is a "pre-emption packet"?
