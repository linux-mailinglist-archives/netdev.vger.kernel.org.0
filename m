Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4A533BE24
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237191AbhCOOnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238038AbhCOOmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 10:42:14 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA60C0613DA
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 07:41:59 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ox4so51026798ejb.11
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 07:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1eoQmMIG4j1sTS6yO0ZeivFNfkQP/or4B27ckOl8agM=;
        b=mjX0YKkqtQ3et5QMwVzlgcY44S45Ck55sIS/bk13BJewzsHe6W/0jxunuXgs1MDwLa
         dM2aZyabuBGN3k8PVzC9i6ffTHfTxCIuwwto347r/6Dih4UKouYQ9LbRUJpDl1OGuENr
         DGhoit40L70NFzbeU9IdiJtb2r04FggV3B4YKYNwRVHiJg197GL5kuXXLuQpcAUNty+v
         PdVvTSY3rQwxNYuUJl4P5ZpINb5NHFqLEFS3GJf1QhE8sZE0sFDKif7eNc7x9U9o0oqe
         owltiMlgj/hPILyLGfuf8M/EggPz/978fq8Bo+bFJjey0doASfmRGR60U1WuKgPNUyZU
         Ir5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1eoQmMIG4j1sTS6yO0ZeivFNfkQP/or4B27ckOl8agM=;
        b=d+fmkbakLkGfncGsGHQ8/k2EeHrfEXTsBQT1lrVAaDsSE/pf321i86NpU8hrt8f3gL
         WLCD6DP3nZRBWEWqF/9KsYUZlR+a9nA3xaa/K+ct9MKBgPJtVsy8BHD21OqFQY2VdCnQ
         ynYbxWSSI2vW5lo4Uk/LST+Yhz+hUEf0LG1cxJ8vPhD6JKkzIVlcHOwIEnFYNGzMu713
         X+cs0Xq0u899zMD4MaQzUsdBkcIrmcSMPOxEeR24qSMw6ZCtPhiy/L/TmlNh9HwDXz65
         5yZvoMeZ/cFWZA36UiCMabBAmqwGmdIxbs/VVB1BtS/yIEzkUOp1AdLfQeYRYgGIS9+q
         tfNw==
X-Gm-Message-State: AOAM531pb25eYBHT/jSGd2uk15/WdvBuqQdY1xXFcFpr1oSjQyAMcmci
        u4wL3Zd2dLNrT+JZDpSgIO/2mQ==
X-Google-Smtp-Source: ABdhPJy4+wsaAoEJ0F3+Xlp+IL8xhumdhvjbB+ZsiHHYThh5Wf1fRVRHdPD6hHQrpBMsWRloV5tdxQ==
X-Received: by 2002:a17:906:1c41:: with SMTP id l1mr23856554ejg.299.1615819318110;
        Mon, 15 Mar 2021 07:41:58 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id v1sm7252869ejd.3.2021.03.15.07.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:41:57 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:41:56 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Xingfeng Hu <xingfeng.hu@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH v3 net-next 0/3] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210315144155.GA2053@netronome.com>
References: <20210312140831.23346-1-simon.horman@netronome.com>
 <YE3GofZN1jAeOyFV@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE3GofZN1jAeOyFV@shredder.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 10:17:37AM +0200, Ido Schimmel wrote:
> On Fri, Mar 12, 2021 at 03:08:28PM +0100, Simon Horman wrote:
> > This series enhances the TC policer action implementation to allow a
> > policer action instance to enforce a rate-limit based on
> > packets-per-second, configurable using a packet-per-second rate and burst
> > parameters.
> > 
> > In the hope of aiding review this is broken up into three patches.
> > 
> > * [PATCH 1/3] flow_offload: add support for packet-per-second policing
> > 
> >   Add support for this feature to the flow_offload API that is used to allow
> >   programming flows, including TC rules and their actions, into hardware.
> > 
> > * [PATCH 2/3] flow_offload: reject configuration of packet-per-second policing in offload drivers
> > 
> >   Teach all exiting users of the flow_offload API that allow offload of
> >   policer action instances to reject offload if packet-per-second rate
> >   limiting is configured: none support it at this time
> > 
> > * [PATCH 3/3] net/sched: act_police: add support for packet-per-second policing
> > 
> >   With the above ground-work in place add the new feature to the TC policer
> >   action itself
> > 
> > With the above in place the feature may be used.
> > 
> > As follow-ups we plan to provide:
> > * Corresponding updates to iproute2
> > * Corresponding self tests (which depend on the iproute2 changes)
> 
> I was about to ask :)
> 
> FYI, there is this selftest:
> tools/testing/selftests/net/forwarding/tc_police.sh
> 
> Which can be extended to also test packet rate policing

Thanks Ido,

The approach we have taken is to add tests to
tools/testing/selftests/tc-testing/tc-tests/actions/police.json

Do you think adding a test to tc_police.sh is also worthwhile? Or should be
done instead of updating police.json?

Lastly, my assumption is that the tests should be posted once iproute2
changes they depend on have been accepted. Is this correct in your opinion?

In any case, I'll get moving on posting the iproute2 changes.

> > * Hardware offload support for the NFP driver
> > 
> > Key changes since v2:
> > * Added patches 1 and 2, which makes adding patch 3 safe for existing
> >   hardware offload of the policer action
> > * Re-worked patch 3 so that a TC policer action instance may be configured
> >   for packet-per-second or byte-per-second rate limiting, but not both.
> > * Corrected kdoc usage
> 
> Thanks!
