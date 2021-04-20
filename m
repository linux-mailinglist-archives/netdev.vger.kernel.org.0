Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272AD365638
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 12:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhDTKeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 06:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhDTKeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 06:34:11 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5286EC06174A;
        Tue, 20 Apr 2021 03:33:36 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so20206557pjv.1;
        Tue, 20 Apr 2021 03:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u3Nzr15z81WtZpDHgfqJlJJcLPK//uWHmdJqHtGbaJ4=;
        b=iBYQ5xmPpHEih9gCrzuAtNh0FzwE/z6Tt+NO3d5cx7DsrOnmgUqSWRvZCof/hC7nYC
         ASoue6ZUil2+oG5/BdpUn0ZFrBsdm1tQnRRmwmOU/2nsXIFzh/2vAB4vb7E1b7Y4/1zi
         vor67QqrTUQ64CzgV60npjBXOGfXd0lIHc1UWs5ACbwk6CCmEPzCUs6EhF9PNiE3miQ/
         Fn0KiDi4+YEq0zsb35cW/aIxS3QArxZlC95/d4ijB4jsw93kwZJDRnQtVBkRrgwaFIzk
         /jNx9eGzM7LW7VXwXjJufhx2abL8ln4JdU3hac5/DaAB9B4d3+6UlhQP6HXpIher9aff
         XfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u3Nzr15z81WtZpDHgfqJlJJcLPK//uWHmdJqHtGbaJ4=;
        b=osNDEiWo0Ev2QsoRt7Ny3Et0HI9iG7/8srT+Fqiuq5ZlT48dflGp/n6DDvJPyfyYmS
         +zor+MYhKCS7kvG6m8k3v9e7lnBxNNahkocKIUi6EraRy+8bzX86/UFhIpxCqWWdadHj
         pdv5mSN90gVDZ35rdyVBHxlOTqw3OcYuNcAU/dP3ofBt4gmjMHVcvETLl5yXfnB9lCcz
         e7p9GC7ERnbKqryCK1Mo1U7bFxAcTXUDDWk7t+2HbO+yF5PA4vBvxRmggC1XRHRPUGGQ
         JDyYYOfJVdGqh0e971oCP6SiIThPWUQdwnW3izjOrl9cOIH0DEyZ/UzoPtdXL1jWnN4h
         oyFw==
X-Gm-Message-State: AOAM5336KYYO5VuDe2Z3FvXKypYY1GL9c4UxB5HbpI+tgkBNmq19LjJy
        Oay6Mpfvd7tyiFzrQZb918g=
X-Google-Smtp-Source: ABdhPJwrcBwxwNKOx+Mccv9rEkF/D9SSC0GsMPoHu/x2QLHqLlLx/O+NXEP3GCcAT8SNo6Iorc263g==
X-Received: by 2002:a17:902:a38d:b029:ec:8faf:2007 with SMTP id x13-20020a170902a38db02900ec8faf2007mr16393342pla.75.1618914815820;
        Tue, 20 Apr 2021 03:33:35 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n11sm9268572pff.96.2021.04.20.03.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 03:33:35 -0700 (PDT)
Date:   Tue, 20 Apr 2021 13:33:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arvid.Brodin@xdin.com,
        m-karicheri2@ti.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ivan.khoronzhuk@linaro.org, andre.guedes@linux.intel.com,
        yuehaibing@huawei.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, colin.king@canonical.com,
        po.liu@nxp.com, mingkai.hu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for
 TAS config
Message-ID: <20210420103319.6nbh3fivjgwupjgl@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 06:25:30PM +0800, Xiaoliang Yang wrote:
> ALWAYS_GUARD_BAND_SCH_Q bit in TAS config register is descripted as
> this:
> 	0: Guard band is implemented for nonschedule queues to schedule
> 	   queues transition.
> 	1: Guard band is implemented for any queue to schedule queue
> 	   transition.
> 
> The driver set guard band be implemented for any queue to schedule queue
> transition before, which will make each GCL time slot reserve a guard
> band time that can pass the max SDU frame. Because guard band time could
> not be set in tc-taprio now, it will use about 12000ns to pass 1500B max
> SDU. This limits each GCL time interval to be more than 12000ns.
> 
> This patch change the guard band to be only implemented for nonschedule
> queues to schedule queues transition, so that there is no need to reserve
> guard band on each GCL. Users can manually add guard band time for each
> schedule queues in their configuration if they want.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
