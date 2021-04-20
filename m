Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFF936540C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 10:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhDTI1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 04:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhDTI1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 04:27:07 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC34C06174A;
        Tue, 20 Apr 2021 01:26:36 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r20so7202444ejo.11;
        Tue, 20 Apr 2021 01:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Puq3uu3VM/r/ZxcT7seTw3qGPFeA4IvkP0YTU1D5aKE=;
        b=gzl7k+XbQmlzNoSuTvdfgSphFfJQRLenPJ0Gj2kYZM3qsXk2SmTxzFU3l8iI5+YQtJ
         ggtHbqiyxPNa4RodTUd6mL5HKj0q9KZunxHCC/LozOR6f0pW1HhXMFFJ3wHH8UhvumMd
         uTM6slNqTEKc/EM+GqsTvX2/Q+o3xfoSbs4J2ApLBk+PSzxJXt/cTXI6TMLremdsQRhD
         lTOUoijcNXuu9p2eexQ4N5u1kwwZE/rBt2BA10FXC2dzWBSzxAyXxcIdG1eyAhKE4SOC
         bRYI6fbhUGwatFofWo72FV8fnMGitsB3BnS7XJRN7T0WSB4EELGJeqFe5/PpMuSYqqRq
         1wFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Puq3uu3VM/r/ZxcT7seTw3qGPFeA4IvkP0YTU1D5aKE=;
        b=ax/d9WnLDtwMIKA1Ns2UXhxzkl3NbiL3tjaFm7o441xn7OinHuAlrVyW5VZS7xuJL4
         uOI44FIsSm+9tQVzuWgpNP+a1YNai7wkdRmAcfCHa/UMWmyjZjX9gtPX44eOJXaE2+6z
         oVVSNHRNuHjvj/IR5PV4NrjJDdTGSqljs6N9WhQAahs6kzIrA6JhpiPEjMjeN4GQijFf
         wuj6vgGDtXe7ACI/tPLs2OvdETfxJcbEMeRWeuZNiXIxk7ELLTWJBVPy5CYrKvTuC0mm
         p0hIkb0EYDUkldRaQsS1Opd+7VQUDO7Vix8bCatN3HYIggIUoFl0aW3esEbYJ2Sn0G+c
         G6BQ==
X-Gm-Message-State: AOAM532/fiy3tiWunFEGmtkJFY7HgTWRnZpma9HMPy2uq0KO9FwZ+/R+
        VsNO5neNENXsIp8Rf2Rtfls=
X-Google-Smtp-Source: ABdhPJyrhCRacWIpY3ASRomiG1UZ70YRI8DByoUoShUYc23am8NJiaWB5VeU3Iv6sR2x3QOVVPOWEg==
X-Received: by 2002:a17:906:f9da:: with SMTP id lj26mr25630986ejb.98.1618907194807;
        Tue, 20 Apr 2021 01:26:34 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id i8sm5780615edu.64.2021.04.20.01.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 01:26:34 -0700 (PDT)
Date:   Tue, 20 Apr 2021 11:26:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        Po Liu <po.liu@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [EXT] Re: [net-next] net: dsa: felix: disable always guard band
 bit for TAS config
Message-ID: <20210420082632.3fy4y3ftkhwrj7nm@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210419123825.oicleie44ms6zcve@skbuf>
 <DB8PR04MB5785E8D0499961D6C046092AF0489@DB8PR04MB5785.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB5785E8D0499961D6C046092AF0489@DB8PR04MB5785.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 03:06:40AM +0000, Xiaoliang Yang wrote:
> Hi Vladimir.
> 
> On Mon, Apr 19, 2021 at 20:38PM +0800, Vladimir Oltean wrote:
> >
> >What is a scheduled queue? When time-aware scheduling is enabled on
> >the port, why are some queues scheduled and some not?
> 
> The felix vsc9959 device can set SCH_TRAFFIC_QUEUES field bits to
> define which queue is scheduled. Only the set queues serves schedule
> traffic. In this driver we set all 8 queues to be scheduled in
> default, so all the traffic are schedule queues to schedule queue.

I understand this, what I don't really understand is the distinction
that the switch makes between 'scheduled' and 'non-scheduled' traffic.
What else does this distinction affect, apart from the guard bands added
implicitly here? The tc-taprio qdisc has no notion of 'scheduled'
queues, all queues are 'scheduled'. Do we ever need to set the scheduled
queues mask to something other than 0xff? If so, when and why?
