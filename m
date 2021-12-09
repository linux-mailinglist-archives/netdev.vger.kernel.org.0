Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79DB46F716
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 23:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhLIW4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 17:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhLIW4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 17:56:20 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E09C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 14:52:46 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id z7so14803249lfi.11
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 14:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=aBAmz2mfae10zTo+mGux5mBIceBhW4rtqbo7ov9BQFw=;
        b=eS7SzJf30odlBsRM6JtjUXNtPo+CFvgs6vGiGE2Q7oF7MvduXVWBWx4hqR482z13ut
         vI3BxAwBTPAd5S/SDR5tsTKTIvyLXrJqEsex+YVsSAXxQ1vAAGw0WZZOl/1QqfVpby1a
         6jT388GPLPNzoLtQitrRPOonGFf5Pmw/AGwIXQJ65DLTDZdo9nLC9SNA9HNnlIde97kb
         0yV5Sq5BaoNTxTHlTa5aKxsi6cG1ppY3Xkpk2IRta7DfzUE00tApWJI2ZxJQQLx4WcaJ
         vJzd+2rDhmwoUIsiV1ADbhUU6LnsdIGgbhhmklalmjZzuueA85lrllpjsS6IGWnW/IDv
         sLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aBAmz2mfae10zTo+mGux5mBIceBhW4rtqbo7ov9BQFw=;
        b=j36A/PXIizSe+WNiM/8hmTcxQL4Wweju/TXLIqAkPvQL+HdVaIaF9n4w9P73Vhl7Tu
         ektwYm0nQCoDj8tzl955MuE5SvMTvPeeoKS+v/1+SWMwbDUgwZnQjFmPU0nodjLjNE1X
         CIDq9XzPB6yZxm99tNyHZxrkWlGvfBeSrMjcLcAUakOXcPrV9ldItgMzKTCFAxmgCPeF
         RR88blgkAvKcQqe2W0UWjybqiMq0fGMxuc50rmO2rGt5rmHMFPEFjaxvT/dNygNkIZxb
         jCyWPxw9aoSslcrLZEQBQpYpqtfk3dygax6ZUml0lcDaHjkjrCrhj1wCyAbgre+4o2Wc
         SxaA==
X-Gm-Message-State: AOAM533BuA2uxUeNJyN89EM33Xm1d0cBY8CPI686W4usqN5EUoQzbXpL
        QEr+uzehFoUiuID25C0fbxnbTRPf5kjY/g==
X-Google-Smtp-Source: ABdhPJxtu1SwkQS1ACe+bR1Dpg4RsxwS84twwNUEgpoVev4r+MFkZAgijzLnzC53sdyCcEzvg1TghA==
X-Received: by 2002:a05:6512:6d3:: with SMTP id u19mr8579091lff.453.1639090364546;
        Thu, 09 Dec 2021 14:52:44 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id o15sm129051lfk.175.2021.12.09.14.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 14:52:44 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add tx fwd offload PVT on
 intermediate devices
In-Reply-To: <20211209224146.gfldu66kqmkgcg54@skbuf>
References: <20211209222424.124791-1-tobias@waldekranz.com>
 <20211209224146.gfldu66kqmkgcg54@skbuf>
Date:   Thu, 09 Dec 2021 23:52:42 +0100
Message-ID: <871r2l2xxh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 00:41, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Dec 09, 2021 at 11:24:24PM +0100, Tobias Waldekranz wrote:
>> In a typical mv88e6xxx switch tree like this:
>> 
>>   CPU
>>    |    .----.
>> .--0--. | .--0--.
>> | sw0 | | | sw1 |
>> '-1-2-' | '-1-2-'
>>     '---'
>> 
>> If sw1p{1,2} are added to a bridge that sw0p1 is not a part of, sw0
>> still needs to add a crosschip PVT entry for the virtual DSA device
>> assigned to represent the bridge.
>> 
>> Fixes: ce5df6894a57 ("net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT")
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>
> This makes sense. Sorry, my Turris MOX has 3 cascaded switches but I
> only test it using a single bridge that spans all of the ports.
> So this is why in my case the DSA and CPU ports could receive packets
> using the virtual bridge device, because mv88e6xxx_port_vlan() had been
> called on them through the direct mv88e6xxx_port_bridge_join(), not
> through mv88e6xxx_crosschip_bridge_join().

Yeah this is by far the most common setup, that's why I missed it as
well.

> I guess you have a use case
> where some leaf ports are in a bridge but some upstream ports aren't,
> and this is how you caught this?

I've been doing some work on running kselftest-like tests on a multichip
mv88e6xxx system. In that process, I discovered this issue along with a
whole slew of other nasty things related to isolation of standalone
ports.

I am finalizing a series to tackle that which (while not exactly
elegant) should get the job done. Stay tuned :)
