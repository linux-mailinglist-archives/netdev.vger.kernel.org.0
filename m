Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5575A1BC9
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfH2NtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:49:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53595 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbfH2NtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 09:49:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id 10so3791784wmp.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 06:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HsA5AiZYcLjGaOwF7llG2D8YWXDZ7fAurDyqgUx22cQ=;
        b=Smiubh10AZvy1V5/a3s9ngk74AY/Gn/dplsTUfPlBGrWfI2iXfguDSeowO4ocsHvk1
         Iz+4/Mi4Xw3NAVZOltljgx6/2szcMQU35rLITwq+mgDElGosjMdWZyCDI4EgM6ccSCNl
         h5fVC2owNRY4l4bPEpamPDVdadJ0VgkVCIsbTlRhX4xdpmw0YobpQiZDPL0YmieOrN1D
         Oi1pyQLxw/E4EBp6rwFro1h8IKA/hEemLSIV0p/mxQALFuCVJ/cu48RD/p9zHZvsCwcp
         +sPWyM/cK29se/O5RDe3bbIfVoawGXs+KdKYbiSL4EO6b3DcjLCilTYi8sS1NLLBkHk4
         zVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HsA5AiZYcLjGaOwF7llG2D8YWXDZ7fAurDyqgUx22cQ=;
        b=MivroHBBNQkjc6AGFGkM4J/IsX4EakSpisb6Z78JnQiF0BUU+4YCrffeetIMgZPU/A
         kjuZd4ljB8r28x5POvlcYDwi6rSVI550ItoyjgMIPm+D36jmbhechR1LeBKt4WIN64bY
         F5ZABttv3JtsVtMqkYnGJxQaLzfXaf0YOo46DWsTe3lPZoLz+ysvdSL2uvnetLJIsPYn
         AaOjJnFfFbGdn2iyRXXCK/zY0wqwv/CRi7np3/It+9ixDqiKUNA21fpiUquinaqgqT5S
         k6W25BswIx7m0TA6DR9QoLp0HIuO4/EHV/VGg7WTn63PcjAp+RXOdGBM1BOdOQ0GWyoP
         8l3Q==
X-Gm-Message-State: APjAAAX0v+f6ZMNh50xBnlWwNQqeGnrmrVNpLo9UtKLgdjkaNI1Mvczv
        ZFXYDJwl3MFgeBjUPgrPXFcZRQ==
X-Google-Smtp-Source: APXvYqyMdHJOwSyphJQegodWp0CqprlA/IWiOz3w8db3EETvDyHh6uUV9K/25pu/R3AqXMHpRimViA==
X-Received: by 2002:a1c:f604:: with SMTP id w4mr11797299wmc.169.1567086541944;
        Thu, 29 Aug 2019 06:49:01 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id x10sm3671157wrn.39.2019.08.29.06.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 06:49:01 -0700 (PDT)
Date:   Thu, 29 Aug 2019 15:49:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, allan.nielsen@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190829134901.GJ2312@nanopsycho>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
 <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
 <20190829095100.GH2312@nanopsycho>
 <20190829132611.GC6998@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829132611.GC6998@lunn.ch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 29, 2019 at 03:26:11PM CEST, andrew@lunn.ch wrote:
>> NACK
>> 
>> This is invalid usecase for switchdev infra. Switchdev is there for
>> bridge offload purposes only.
>
>Hi Jiri
>
>I would argue this is for bridge offload. In another email, you say
>promisc is promisc. Does that mean the Mellonox hardware forwards
>every frame ingressing a port to the CPU by default as soon as it is
>enslaved to a bridge and promisc mode turned on? Or course not. At the
>moment, every switchdev driver wrongly implement promisc mode.
>
>This patchset is about correctly implementing promisc mode, so that
>applications can use it as expected. And that means configuring the
>hardware bridge to also forward a copy of frames to the CPU.

Wait, I believe there has been some misundestanding. Promisc mode is NOT
about getting packets to the cpu. It's about setting hw filters in a way
that no rx packet is dropped. For normal nics it means that all packets
get to the cpu, but that is just because it is the only direction they
can make.

If you want to get packets from the hw forwarding dataplane to cpu, you
should not use promisc mode for that. That would be incorrect.

If you want to get packets from the hw forwarding dataplane to cpu, you
should use tc trap action. It is there exactly for this purpose.

Promisc is for setting rx filters.


>
>I see trap as a different use case. tcpdump/pcap is not going to use
>traps.
>
>	Andrew
