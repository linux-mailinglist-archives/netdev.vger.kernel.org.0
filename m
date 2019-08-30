Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1775EA3012
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 08:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfH3Gg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 02:36:28 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56247 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfH3Gg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 02:36:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id g207so2074099wmg.5
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 23:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z/RSED/kwcwsGToB/IOepXNrOYTyt6uJncdAwRBYdjo=;
        b=XMw5GvvcyFz6hKnb3g+bk0+pbstWXkiSyCADKHoTh3zlMEFIyiCXKa4BrU0T2EqEiC
         jdVUua2mRyM9Kd4VNIxg+lTOC1X5DRlyTlWaVRCE2kxDN233jhmCmGVIkeHj+BZB9MCW
         6bfDwNIhhWM44XSJUBbEACF3ZD0s+QX0FLFxyzCd8BZK68FsQzMw24b27bbq+FZZL91H
         ytJu99yu8qFHrxQxPCYmSalSyZW0q63no8GqEKnZCaZXkehjHJuP8sGiApccW4npnuou
         Sp2x0ctVznRD2OkBv2YZD/Vz+ZzjAyl7u2L3mD8mGj9JfwP3Vu5CYJQz5fS9Cg02LVnL
         jTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z/RSED/kwcwsGToB/IOepXNrOYTyt6uJncdAwRBYdjo=;
        b=U0Pvlddvx9nJ7V1Z4ZcL+XDlidn6ENL4ZLVf4YIDhntnrFlDSMPnOO6s793kaTRvo3
         wbCU5LzbeYZFygxRfO4wx6K4ZYTLUOnY/gPsZBHmZSomGy8zHfZ2KMcCR1yFOEvCvy6Y
         +7oA4v2Idcu3J0o42WO3pQF2q/fZxcpyqNXYSXCuZbK1oif8kM/46vhZoJBln2IHwTq6
         F93yfBC8l30WYtM8L5Aby6RK3UUuPtov6BrSE/6UIEaUZ+mlLFO147SxstXAAwq4rTSi
         /vhuUN6AkCW9IxQPyAZEZf6x03ZrN2+TrC5aqw2US6/f0NS45vrsyEkA5vqwXm9ieF5B
         qOOQ==
X-Gm-Message-State: APjAAAXZWQfvtVCE1FmuZxEgbQYXpZneljtg2iXof94JkBAfahy8vMTf
        pqcqhUou1Bl8lPn4H0y3Xc3rWw==
X-Google-Smtp-Source: APXvYqxmg5jjVOXpHumS2I7fv4DxCRMZGOdvC7Rfvplq9fotOrwEDyJD0G4rrenXgM9QnvWo+Cw4jA==
X-Received: by 2002:a7b:c84e:: with SMTP id c14mr16153146wml.46.1567146985762;
        Thu, 29 Aug 2019 23:36:25 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id q124sm3873372wma.33.2019.08.29.23.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 23:36:25 -0700 (PDT)
Date:   Fri, 30 Aug 2019 08:36:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     idosch@idosch.org, andrew@lunn.ch, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        allan.nielsen@microchip.com, ivecera@redhat.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190830063624.GN2312@nanopsycho>
References: <20190829193613.GA23259@splinter>
 <20190829.151201.940681219080864052.davem@davemloft.net>
 <20190830053940.GL2312@nanopsycho>
 <20190829.230233.287975311556641534.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829.230233.287975311556641534.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 30, 2019 at 08:02:33AM CEST, davem@davemloft.net wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Fri, 30 Aug 2019 07:39:40 +0200
>
>> Because the "promisc mode" would gain another meaning. Now how the
>> driver should guess which meaning the user ment when he setted it?
>> filter or trap?
>> 
>> That is very confusing. If the flag is the way to do this, let's
>> introduce another flag, like IFF_TRAPPING indicating that user wants
>> exactly this.
>
>I don't understand how the meaning of promiscuous mode for a
>networking device has suddenly become ambiguous, when did this start
>happening?

The promiscuity is a way to setup the rx filter. So promics == rx filter
off. For normal nics, where there is no hw fwd datapath,
this coincidentally means all received packets go to cpu.
But if there is hw fwd datapath, rx filter is still off, all rxed packets
are processed. But that does not mean they should be trapped to cpu.

Simple example:
I need to see slowpath packets, for example arps/stp/bgp/... that
are going to cpu, I do:
tcpdump -i swp1

I don't want to get all the traffic running over hw running this cmd.
This is a valid usecase.

To cope with hw fwd datapath devices, I believe that tcpdump has to have
notion of that. Something like:

tcpdump -i swp1 --hw-trapping-mode

The logic can be inverse:
tcpdump -i swp1
tcpdump -i swp1 --no-hw-trapping-mode

However, that would provide inconsistent behaviour between existing and
patched tcpdump/kernel.

All I'm trying to say, there are 2 flags
needed (if we don't use tc trap).
