Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDED13641D3
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbhDSMjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhDSMjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 08:39:00 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BAFC06174A;
        Mon, 19 Apr 2021 05:38:29 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y3so4209977eds.5;
        Mon, 19 Apr 2021 05:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WyiBlnYjhbSGD9o4an9TKaeVZuwFqnQ44fg8yEv4OAQ=;
        b=Rex54pJ4nvKNwo3ltVsyB2Yao46jdouKbL+oZSSePiRwhBRBG/uxxadYRlG8vcP/Ld
         lkFyn4ZwACDtHy9Q9KQHXsX8jsdn6i069wnNGjesp4nkqfD9eXjXh9ytXWWc/JjtigER
         wD3QXzeoA1QhVsrIdLDl2puRyufOJ9lgSlq90Xr9PCD3AbV1gprRAh7Z/fzf60d6WfPk
         7Kmsh86aeIaVEtdlhnraRzsu8+ouQ5g+WcRU9poRm7ra4+AjFFW9wrCtIbfABe5+ubdT
         K8ziW301Jvlkds68sJjsC9yWAEQTRS6XcuRW3xBCxPM5HAMERMoWbgaIvnU2TuudZeHJ
         ENRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WyiBlnYjhbSGD9o4an9TKaeVZuwFqnQ44fg8yEv4OAQ=;
        b=K086MSIGOp+gB7h27OE9lTaACbx/K1XOvVqkc6vKFYNHLdDC3+LVBkD4LQDI6vkWUq
         o/Irfg+AWnZ/urVhIF9ZQb97ZM+xvwWg8q2E7NmEcmx6aqzyK0feILgc2vLCAW/2Bk0X
         gRNHYcX11yNDCnhI61+OsawIpmLbUKumen70/y0B0wmhOEijdAjlhmw5MsdOBuJ+iyrh
         PyF5zdxw7R0109pGt1nQRzPiCbQ7++LqA1T3YVVYOkMVq19/vtEYiurDTclIaLbBDqZ6
         BREl6v83W8VUoQLTU78KMJF5Cmrv0mAzSxm5eMiEw/56a3QsXvh148lbRBIglUozGW14
         3lOw==
X-Gm-Message-State: AOAM530yfEcB2G8PJFude7HJC8sVcHQbeHQZgqldsHC6UeGojQgD298r
        nFM52ZPnQGq2RRY1ITraxdc=
X-Google-Smtp-Source: ABdhPJynRxsCnMAJeBnZAmZ24tOceobIY9ad/kKwG3ye3Sm5qQhzI2yFpwyI23Kob+yjLoOBQzg9oQ==
X-Received: by 2002:a05:6402:37a:: with SMTP id s26mr6997757edw.159.1618835908036;
        Mon, 19 Apr 2021 05:38:28 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id i8sm3602021edu.64.2021.04.19.05.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 05:38:27 -0700 (PDT)
Date:   Mon, 19 Apr 2021 15:38:25 +0300
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
Message-ID: <20210419123825.oicleie44ms6zcve@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaoliang,

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

What is a scheduled queue? When time-aware scheduling is enabled on the
port, why are some queues scheduled and some not?
