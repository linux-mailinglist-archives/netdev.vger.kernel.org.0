Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB394B4161
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 21:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391003AbfIPTwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 15:52:50 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37093 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732536AbfIPTws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 15:52:48 -0400
Received: by mail-ed1-f66.google.com with SMTP id r4so1179857edy.4
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 12:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lf+sPRYo4A3Rir/R44WZZ7uF4mOF9gb7qApe7xAh12s=;
        b=oQTnCkJUdsDRDwCADqSTidoJMdad6k/AefioGdRLuA+TWiE+Eo6qKYGdIiHp9rlw+z
         6T2EbtFe7RAIQcMt3ZlWNQo6gCmPnbjCz+bgRByuA++smQrRZjD+klpUtCfJ5uNp/QLK
         3hcxRot3o8CzHilBxfThngyWvEkeNjn04DXMnKzGljNHHScZsrvD2j+685rQkci2LSgx
         WBbUhh2rZ3zNYwAONkukIB4Ta5tI5Q4vysuOmAyKJPPg2sq1afwhEyNWj1GvD960B0nC
         QwapwtTBZOmztiRPtePZ5ObkPiUjwNzGCCkTuzsIwA5BGi5sNfLRRR7mJ3Ci391/eUAN
         JTDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lf+sPRYo4A3Rir/R44WZZ7uF4mOF9gb7qApe7xAh12s=;
        b=GvW14heLVkxho0RQXz1oUdZYCtY1MmxLiX6Vrlehj8x6zSUOXCrrfZ+dB2eDzjNt/g
         p12rd5li/mR5/xx53QgZD5VOgXSshYgtJL8gC1+SfmgQ1jy6kjSQu19WjILbOMwMGent
         gKUAq4XrOXDe3LQo39vNxh6Va62sSsfPKhv3tE7jq4vHX5PD4N1FPkGEEq6p/75z4Kyb
         roMKlCcpBr8HGAmi0rXHzAMbjQBPawnH8SJoPTsCnJ7YpBhrkdKSBq2gQ7kt+4glftW6
         //+3kPoDMBZpxGI7BI8jfXYznQJDQx8zxgXGQaRmp+DGLUBy7f26GGnRQjieYSyR76oa
         otMA==
X-Gm-Message-State: APjAAAU3PjGmWx4dIodCMtNU7dVEfTk9vV73SB8z2sbeTQJsiqK5kWe4
        sif0dVgWi3eQanfECL+9ipRZHa/NniWHqwLXCNA=
X-Google-Smtp-Source: APXvYqyupa85MAyO0x3JIqRlQe1ps8Y7/bW1Rcjv7Ko2//VRELo80d04VWptjUTvgC2ARyYllyilsvqFaoNNP3k5jvQ=
X-Received: by 2002:a50:ef12:: with SMTP id m18mr1061981eds.18.1568663566156;
 Mon, 16 Sep 2019 12:52:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190915020003.27926-1-olteanv@gmail.com> <20190916.213627.1150593408219168339.davem@davemloft.net>
In-Reply-To: <20190916.213627.1150593408219168339.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 16 Sep 2019 22:52:34 +0300
Message-ID: <CA+h21ho1QoEFWz=JV5BXGe0BXN3tQ72jjt30oQHQvbWRaQ-e6g@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 0/6] tc-taprio offload for SJA1105 DSA
To:     David Miller <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "Patel, Vedang" <vedang.patel@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>, jiri@mellanox.com,
        m-karicheri2@ti.com, jose.abreu@synopsys.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Sep 2019 at 22:36, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Sun, 15 Sep 2019 04:59:57 +0300
>
> > This is the third attempt to submit the tc-taprio offload model for
> > inclusion in the networking tree. The sja1105 switch driver will provide
> > the first implementation of the offload. Only the bare minimum is added:
> >
> > - The offload model and a DSA pass-through
> > - The hardware implementation
> > - The interaction with the netdev queues in the tagger code
> > - Documentation
> >
> > What has been removed from previous attempts is support for
> > PTP-as-clocksource in sja1105, as well as configuring the traffic class
> > for management traffic.  These will be added as soon as the offload
> > model is settled.
>
> Series applied, thanks.

Thanks a lot, that's what I call cutting it close!

-Vladimir
