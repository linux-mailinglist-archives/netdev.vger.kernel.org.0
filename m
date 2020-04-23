Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD931B5178
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 02:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgDWAoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 20:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDWAoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 20:44:02 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272E8C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 17:44:02 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id x12so2958344qts.9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 17:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w1fYYyTMHR7rBWOVXtj5YRFvRa6Mln251rj3cX/OTm0=;
        b=TdnfJn9sGDya9pAbU/LLOiE9fiHZeZNW62Ks+hTnQ8YAmSoh48avvqpdqRcX04Xt/N
         glrCQuwBu9KrYiJgiv/PhQV6VOITxEnyAoyeuzcKDGWXqZUAn9GEVrLAKAKfQEG+QSCc
         T2EZHDaJ4DB8ZNkSjz2X9Wy/PdH0bhH0xh/dTu4LeBODRqfKBXgoEAyRAQlqYHimyUNw
         4AFUshryTwzcKAXVSGpx5WWVZqqI+9p+q4vveQKVJnrSCKgwqOBihAgcyYaE0jBBP+DZ
         EzKvTD7AAYNVRQ487UODjmGwp7oCMFjrotl581no4XcoM7x4uW2OPKcPuCMRJy1pavXj
         yBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w1fYYyTMHR7rBWOVXtj5YRFvRa6Mln251rj3cX/OTm0=;
        b=hVpfVEVcPwLCg2Akv8srdWL3HTw15GJhCvKRrNSRmIj5mqBGjUdVpj9vOmRxhCjSgg
         LVrwMZjCkS/z0vU6fVc24AG9mXN+j9aMRVDDh8QFHvL3U2MHoe7XlhCi2PiHqNCeXjyP
         uEPtkmNSdFe+IhOKW95UDcf9KbbCtg6HuS8oTNsiXWBZ8cLKsKqU5CWc74kiZIdHV3Hj
         2AgiH7MImkg3KZjiYhpdJTdv3XcZ77HTleXGYzyDhO3WSSiIB66LMDlI+7HTWIbdf8ZQ
         7SrErsIq/7RN1nces+4adxu3GXo8PPO/pqIM4XgaLvdtYu4wg+suAB8WeC1KXTjtVtlS
         4N9g==
X-Gm-Message-State: AGi0PuYKkJFxuyljlxtda/PGLfgewLudO977iu22QUezjpzDUHxNxIrw
        hKntnh9uVUPH3jeO79YX4Dk=
X-Google-Smtp-Source: APiQypL2hXDEv4ja2tDrAgZkmxD+XMVHKRG2FJcviLRbi//hIq79/fn2yMyuBOfWp8PlD5qsZnPIQA==
X-Received: by 2002:ac8:6f03:: with SMTP id g3mr1497267qtv.10.1587602641309;
        Wed, 22 Apr 2020 17:44:01 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.227])
        by smtp.gmail.com with ESMTPSA id y9sm620150qkb.41.2020.04.22.17.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 17:44:00 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1B899C1D6B; Wed, 22 Apr 2020 21:43:58 -0300 (-03)
Date:   Wed, 22 Apr 2020 21:43:58 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kbuild test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, kbuild-all@lists.01.org,
        Ido Schimmel <idosch@idosch.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>
Subject: Re: [PATCH net-next 1/3] net: mscc: ocelot: support matching on
 EtherType
Message-ID: <20200423004358.GA2469@localhost.localdomain>
References: <20200420162743.15847-2-olteanv@gmail.com>
 <202004230608.ERIsSgqQ%lkp@intel.com>
 <CA+h21hpDkc02Hd5JFbD_r3sAtFAOBStQN2dAT+n0aq5SxgKwvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpDkc02Hd5JFbD_r3sAtFAOBStQN2dAT+n0aq5SxgKwvw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 01:50:41AM +0300, Vladimir Oltean wrote:
> On Thu, 23 Apr 2020 at 01:36, kbuild test robot <lkp@intel.com> wrote:
> >
> > Hi Vladimir,
> >
> 
> [...]
> 
> >
> > sparse warnings: (new ones prefixed by >>)
> >
> > >> drivers/net/ethernet/mscc/ocelot_flower.c:184:54: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
> 
> What's a resunsigned short?

Dunno, but seems "restricted unsigned short", considering the below.

> 
> > >> drivers/net/ethernet/mscc/ocelot_flower.c:184:54: sparse:    expected unsigned short [usertype]
> > >> drivers/net/ethernet/mscc/ocelot_flower.c:184:54: sparse:    got restricted __be16 [usertype]
> >
> 
> [...]
> 
> >    179          if (match_protocol && proto != ETH_P_ALL) {
> >    180                  /* TODO: support SNAP, LLC etc */
> >    181                  if (proto < ETH_P_802_3_MIN)
> >    182                          return -EOPNOTSUPP;
> >    183                  ace->type = OCELOT_ACE_TYPE_ETYPE;
> >  > 184                  *(u16 *)ace->frame.etype.etype.value = htons(proto);
> 
> What's wrong with this? Doesn't it like the left hand side or the
> right hand side?

It's assigning a big-endian value (network endian) to a host-endian
variable (u16 cast).

> 
> >    185                  *(u16 *)ace->frame.etype.etype.mask = 0xffff;
> >    186          }
> 
> >
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 
> -Vladimir
> 
