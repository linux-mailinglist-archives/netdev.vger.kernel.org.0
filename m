Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85AD6139F7
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfEDNH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:07:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34384 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfEDNH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:07:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id f7so903890wrq.1
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bIX74g/Ebw6UXLbNNWzw4fo2NH6a/QGR4Dtf+2q0aD0=;
        b=aP+Gx+n9L5sgKnRZXtE6elh0uIqEirFfd9dC/RjHG7mBwU5GkfZt+biVib7L8y7QY6
         dB91OsrwoO4Kbs/sHONdfQpNVZs2KlTov88VbHc3+F8qWLt3qhWdNyr8bQ3ZzrHFMaWl
         dZTXrCnFSf9Yz9aIDpUWxKvng6Hdbde+70aL9ypnubKpCcF3cVVg6wnPnvamrVtLPv6C
         I2YqBku+LkKGGkrRN8aeOfMQzueLc0oLxr1t/zh8aj/jK0T19rec0Q/SAs9DQJ2IuOMA
         3q/iObDu7GOwHbVEvJZhlr1f/MTuwQyyGRykr1u8p6J1LB0lumbNSrTL5tfDSohbv3bd
         b4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bIX74g/Ebw6UXLbNNWzw4fo2NH6a/QGR4Dtf+2q0aD0=;
        b=ML53gvWpPe4WrhGdCQq/WdzA22mV2fiGfu9aUUscPNt0InzDLrpr/YPACs2ZSpNAbW
         UZYeFZCxf/080kaBZc56+JxukgrixdyaKwHMrN0iLQPsrQ8+O/7qZh26HvEhPpOoE2Y8
         JL/dqTimv61Q7Tb1Rzwy/djs05kW2XsFR2P4y1o2g+pcVINi4KdZrzsjFJ+iYecynute
         eOw0OjxVzICdFib6ylF4tkh11Xi5Vr50txjpfBu4sSSnYe89XcbExCok7rgHK/fqfxM1
         f/q7bONdTNgD0AVr/jdiWupeDxlCtsvlLggyVG8b0nmd1uWCo5v3P1haebWyS8gs46Xo
         gVgg==
X-Gm-Message-State: APjAAAUguip04vmloaOE/6cYkaJJZOt9W2FjYux3TaqA176Wb7ZKiyuC
        K6Ehksxel4gQAfS9YmCb/yU4Cg==
X-Google-Smtp-Source: APXvYqx/ozBnqo9/lHr34HT+3oRk0fay36BQn/4qD9XF+nwCp+gkn1jy7+yKzyg3DAdfpezw1JxywA==
X-Received: by 2002:a05:6000:3:: with SMTP id h3mr10677218wrx.314.1556975247343;
        Sat, 04 May 2019 06:07:27 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d6sm3457846wrp.9.2019.05.04.06.07.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 06:07:26 -0700 (PDT)
Date:   Sat, 4 May 2019 15:07:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Joergen Andreasen <joergen.andreasen@microchip.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        pieter.jansenvanvuuren@netronome.com
Subject: Re: [PATCH net-next 2/3] net: mscc: ocelot: Implement port policers
 via tc command
Message-ID: <20190504130726.GA14684@nanopsycho.orion>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
 <20190502094029.22526-3-joergen.andreasen@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502094029.22526-3-joergen.andreasen@microchip.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 02, 2019 at 11:40:28AM CEST, joergen.andreasen@microchip.com wrote:
>Hardware offload of port policers are now supported via the tc command.
>Supported police parameters are: rate, burst and overhead.

Joergen, please see:
[PATCH net-next 00/13] net: act_police offload support
That patchset is also pushing flow intermediate representation for this,
so I believe that you should base this patch on top of that.
