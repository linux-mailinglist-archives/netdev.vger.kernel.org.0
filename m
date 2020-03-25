Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C8E192A44
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgCYNlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:41:52 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50775 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgCYNlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 09:41:52 -0400
Received: by mail-pj1-f65.google.com with SMTP id v13so1056030pjb.0;
        Wed, 25 Mar 2020 06:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fc6W0JXmmadOQ0swBSxFn65817l4LzrYHT49sb98cUg=;
        b=lLrrU0TNyaPUwk3xtXB+PN1ftG4z8BLpPfziRfD48kcHiMUF3J1NweM6t0y1tXGKbW
         7yu12WqX0ujKEZTuqHZwddEMTlZeZUk9aU4tI2lNDf0VuQO5CS/J+HNXMbVwWUuApj6J
         TJLrdgsMYwESP7JnVu7NTGAVRyEddFA5AmYQV5NgsOXOO1rMOpAH7yFU5KwZ/G/ws+/7
         9rdHERRzrpVec+KaGmrUnacnm07/D3G45wjI+FxKmsV8DcaWaHPudzj8CvC9zYS9REZr
         1E4FWR635lqCEnG1tM2SKRLf+VUPwKiPyBMLkOwG7/UicKkhyK3sRLOfmhojH7kodyIe
         6hIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fc6W0JXmmadOQ0swBSxFn65817l4LzrYHT49sb98cUg=;
        b=Mb/VY0W65sriPC0v+Ze5M76BR6WaxDVBTxx3a7rZV8YXn1r25jr3qQtpKdwh5UP+IT
         zuAGGmIpd9/SIb79gKsph5qw1BIYMexEh3P7mi9kivHZnu8QK2Jtszd3NKFaf5QnYoQy
         GxSfBpUeEi4ccntptJYrr91H+GJgR/Lfyr7GlBDPdlQp2hijEKb9SD/J/LIpG7K4MXnr
         kOyRZgS62hPIS1nAqHp25ebQT82x1z4ngM6qigDH+sb5Y6gUzNEUtyDpI23QPMMRPvZc
         MS+c5Le5xD3cf2uFgUhEYUu1MjY7aUDIVgee59U7BeOs838xwU3w5vo/XLi2ILkYOHNf
         VJQA==
X-Gm-Message-State: ANhLgQ3931ILiO2KhoB6xuwczDqyiDs8hUH0rFYiUgN3/xaE0ZNEQYgd
        tlr8smK3tN8b7Rc663jBhU3GMbI1
X-Google-Smtp-Source: ADFU+vtME+OlQ0JE+bJZcPyTEYkWi/mDZvuYCt5SUYnLVfdl4avtfGOJUo3bp2mtw9rS4zXMPuvYog==
X-Received: by 2002:a17:90a:1f07:: with SMTP id u7mr3995255pja.24.1585143710497;
        Wed, 25 Mar 2020 06:41:50 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id w9sm18816660pfd.94.2020.03.25.06.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 06:41:49 -0700 (PDT)
Date:   Wed, 25 Mar 2020 06:41:47 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Message-ID: <20200325134147.GB32284@localhost>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com>
 <20200324130733.GA18149@localhost>
 <AM7PR04MB688500546D0FC4A64F0DA19DF8CE0@AM7PR04MB6885.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM7PR04MB688500546D0FC4A64F0DA19DF8CE0@AM7PR04MB6885.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 03:08:46AM +0000, Y.b. Lu wrote:

> The calling should be like this,
> ptp_set_pinfunc (hold pincfg_mux)
> ---> ptp_disable_pinfunc
>    ---> .enable
>       ---> ptp_find_pin (hold pincfg_mux)

I see.  The call

    ptp_disable_pinfunc() --> .enable()

is really

    ptp_disable_pinfunc() --> .enable(on=0)

or disable.

All of the other drivers (except mv88e6xxx which has a bug) avoid the
deadlock by only calling ptp_find_pin() when invoked by .enable(on=1);

Of course, that is horrible, and I am going to find a way to fix it.

For now, maybe you can drop the "programmable pins" feature for your
driver?  After all, the pins are not programmable.

Thanks,
Richard
