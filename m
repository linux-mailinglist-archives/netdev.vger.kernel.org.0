Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF98536562C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 12:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhDTKbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 06:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbhDTKbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 06:31:41 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFDDC06174A;
        Tue, 20 Apr 2021 03:31:09 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id f6-20020a17090a6546b029015088cf4a1eso4376643pjs.2;
        Tue, 20 Apr 2021 03:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/pqYuVEVyGbD6G0F1pZ44n9k5T8+DxwsVUEl0nbUlzY=;
        b=CLuIQV3Y8s6+hQPyfVqZjKRQSWv4edE2G80ngVVS2KepQJxuGxmHKOupqe+zlcv+r1
         WTUqW9wKOXA35EUu+KBkJWPP+98Bb7RiW4DDgaBWi+QRVtPNirUrKWUQhkRBye50CQI6
         6+AZj+H/Px35O1aPrUdO1np2iDLXHL0/x0rGM0CJNdvAg9C6RO8WAYmRvgZM6lJs2nTv
         VTSRL62xUOuPRnYjN7NUG2yONGjDb6VSVbLHQxEn17usUG0SsZxTtWiaVKBijV/I71rZ
         y7mcVkCUvNUEM+0MHtt+zotBfkZikqrQXScQUzQg/fnVJUkAji0p4HCeeR2P7qmrZXn6
         l/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/pqYuVEVyGbD6G0F1pZ44n9k5T8+DxwsVUEl0nbUlzY=;
        b=f4GRMLD2KEsBHfgKEbpN3fuvxhoKfxv0EZoXWjBNuJHYog+dWl7Ue9lBoRbYRZ0S7y
         rw814zR9FkvS26OSbSFGThdUavwH+gt3X+yWgioXeMlEyzcbS2CwJppUEDRxQp1IM0/R
         hkx1F5q+MvIVmhOhVMLyj3mrMVws7YCZXz7yvJ+50TfzceP16QZFPOQsMR05dEHnu3AP
         cppdBRfYefB9sWgAK0mCXzsqfg1/ruj0P7if40NDGSt6f2tTq+jwvSWJyGrP8epGAT0l
         GeGA7Mw3ATAdeVEyWNX3r72SB3o+m7aChjjO4kbEMcPbydlmR+P7Meqm7nOgYn0z9XY9
         KHzQ==
X-Gm-Message-State: AOAM531f74UKku2aXI1i/+u+menpQgGLdb3I8Nhiz9oXtawo4UlQdmdC
        NHE/IHRtm888JyQkGoKSlnI=
X-Google-Smtp-Source: ABdhPJxDVxa6g+YmrGIK8MbCSiDDyPrdR0uHwCh1Sh3ieT7yQHuwN/8fXHfTghJZfe9TDmaWOHA87Q==
X-Received: by 2002:a17:902:8347:b029:e7:4a2d:6589 with SMTP id z7-20020a1709028347b02900e74a2d6589mr28700859pln.64.1618914668673;
        Tue, 20 Apr 2021 03:31:08 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id g23sm16593764pfu.189.2021.04.20.03.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 03:31:07 -0700 (PDT)
Date:   Tue, 20 Apr 2021 13:30:51 +0300
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
Message-ID: <20210420103051.iikzsbf7khm27r7s@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210419123825.oicleie44ms6zcve@skbuf>
 <DB8PR04MB5785E8D0499961D6C046092AF0489@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210420082632.3fy4y3ftkhwrj7nm@skbuf>
 <AM6PR04MB5782BC6E45B98FDFBFB2EB1CF0489@AM6PR04MB5782.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR04MB5782BC6E45B98FDFBFB2EB1CF0489@AM6PR04MB5782.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 10:28:45AM +0000, Xiaoliang Yang wrote:
> Hi Vladimir,
> 
> On Tue, Apr 20, 2021 at 16:27:10AM +0800, Vladimir Oltean wrote:
> >
> > On Tue, Apr 20, 2021 at 03:06:40AM +0000, Xiaoliang Yang wrote:
> >> Hi Vladimir.
> >>
> >> On Mon, Apr 19, 2021 at 20:38PM +0800, Vladimir Oltean wrote:
> >> >
> >> >What is a scheduled queue? When time-aware scheduling is enabled on 
> >> >the port, why are some queues scheduled and some not?
> >>
> >> The felix vsc9959 device can set SCH_TRAFFIC_QUEUES field bits to 
> >> define which queue is scheduled. Only the set queues serves schedule 
> >> traffic. In this driver we set all 8 queues to be scheduled in 
> >> default, so all the traffic are schedule queues to schedule queue.
> >
> > I understand this, what I don't really understand is the distinction
> > that the switch makes between 'scheduled' and 'non-scheduled'
> > traffic.  What else does this distinction affect, apart from the
> > guard bands added implicitly here? The tc-taprio qdisc has no notion
> > of 'scheduled' queues, all queues are 'scheduled'. Do we ever need
> > to set the scheduled queues mask to something other than 0xff? If
> > so, when and why?
> 
> Yes, it seems only affect the guard band. If disabling always guard
> band bit, we can use SCH_TRAFFIC_QUEUES to determine which queue is
> non-scheduled queue. Only the non-scheduled queue traffic will reserve
> the guard band. But tc-taprio qdisc cannot set scheduled or
> non-scheduled queue now. Adding this feature can be discussed in
> future. 
> 
> It is not reasonable to add guardband in each queue traffic in
> default, so I disable the always guard band bit for TAS config.

Ok, if true, then it makes sense to disable ALWAYS_GUARD_BAND_SCH_Q.
