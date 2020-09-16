Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E183126C149
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 12:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgIPKAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 06:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgIPKA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 06:00:29 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DD7C06174A;
        Wed, 16 Sep 2020 03:00:29 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id w1so5683118edr.3;
        Wed, 16 Sep 2020 03:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kv9fwVSdMjPtvsSnxmGO3fkBoe+GHiU00vGndpd8sog=;
        b=BxfljAmtSCe4UqLuDveGKKVWgQstSaJiCtoMfTzJ4akE6TvUSLrdC2MydrCkpWU6UP
         1NOGRBSeJaUbmrz11j3G0d7gUQ328I9nJlFHH7u8NSPAeSaKhBPYVpt/z4yoh8sI38U9
         Y69Z2hvEGCgjdktzsWJEGkk7JRXwkownamXBSS7aLXg5W/qDmTBR+U7/x4ugB0ubrDy/
         sw8WmnyGoMG9YepiGQtI05L13rTFpl9QuvlHIUK4mY6T+7JdIrf01E1BzmwWd0ef4K+v
         0sVtfu1TH+bJbo9/q5KrD2eteeMni49JetTGrZpFSVKjy44U7HWPnCSYy7W50h1Jidir
         9nmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kv9fwVSdMjPtvsSnxmGO3fkBoe+GHiU00vGndpd8sog=;
        b=BpRRphrbqWKFJsGy15X8gnyglvEUAeq8/PVaKc+JLKsNQu+uo3sFIbziQLPgBu5jRt
         5co7iX6E5XHu3GF9A7Q8jvL5zb2ArmpXte12Xw5nUb4ZTFVmjOwE/tPJg1L4HS1T/EM5
         5STaFgqjbDizQEg98Z52N4blEBbgF6XSafh6YUpUsQAhmj+W5K2WNjo7Dr3UW5jrR/R6
         xRHcoHVk/d9WkaqV3i0uQmGIXuzWESp+tvZQxZJg72dDyciD13MslM7sf3auuuVjdwxR
         feSV8ZkUq7Y6xWOe14TmBbrvRtZmP04/bQI4feEHO4+/ROd2IiqGWSVRrai7skAN2Ird
         5ZhQ==
X-Gm-Message-State: AOAM533Hzww+DTimzjN5+gLrTqCnm1bR74u2IZjRd3ROAIcSAXBEU3hj
        bUyBjbdKneUP6rpHEwYwIsQ=
X-Google-Smtp-Source: ABdhPJwXTMREV+V+0t3OTipIvoKX22NzJXJgeiaTXlChzE5AheIWUQfz0Umk4uuM9AuGq4STFdhmIg==
X-Received: by 2002:aa7:dcc6:: with SMTP id w6mr26881330edu.10.1600250427652;
        Wed, 16 Sep 2020 03:00:27 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id lz22sm12125426ejb.98.2020.09.16.03.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 03:00:27 -0700 (PDT)
Date:   Wed, 16 Sep 2020 13:00:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     hongbo.wang@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, mingkai.hu@nxp.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        idosch@idosch.org, kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Subject: Re: [PATCH v6 3/3] net: dsa: ocelot: Add support for QinQ Operation
Message-ID: <20200916100024.lqlrqeuefudvgkxt@skbuf>
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
 <20200916094845.10782-4-hongbo.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916094845.10782-4-hongbo.wang@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hongbo,

On Wed, Sep 16, 2020 at 05:48:45PM +0800, hongbo.wang@nxp.com wrote:
> From: "hongbo.wang" <hongbo.wang@nxp.com>
>
> This feature can be test in the following case:
> Customer <-----> swp0  <-----> swp1 <-----> ISP
>
> Customer will send and receive packets with single VLAN tag(CTAG),
> ISP will send and receive packets with double VLAN tag(STAG and CTAG).
> This refers to "4.3.3 Provider Bridges and Q-in-Q Operation" in
> VSC99599_1_00_TS.pdf.
>
> The related test commands:
> 1.
> devlink dev param set pci/0000:00:00.5 name qinq_port_bitmap \
> value 2 cmode runtime
> 2.
> ip link add dev br0 type bridge vlan_protocol 802.1ad
> ip link set dev swp0 master br0
> ip link set dev swp1 master br0
> ip link set dev br0 type bridge vlan_filtering 1
> 3.
> bridge vlan del dev swp0 vid 1 pvid
> bridge vlan add dev swp0 vid 100 pvid untagged
> bridge vlan add dev swp1 vid 100
> Result:
> Customer(tpid:8100 vid:111) -> swp0 -> swp1 -> ISP(STAG \
>             tpid:88A8 vid:100, CTAG tpid:8100 vid:111)
> ISP(tpid:88A8 vid:100 tpid:8100 vid:222) -> swp1 -> swp0 ->\
>             Customer(tpid:8100 vid:222)
>
> Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
> ---

Can you please explain what is the purpose of the devlink parameter
command? As far as I understand, the commands from step 2 and 3 should
behave like that, even without running the command at step 1.

Thanks,
-Vladimir
