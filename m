Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83EE12FE07
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfE3Okd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:40:33 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41268 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfE3Okd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 10:40:33 -0400
Received: by mail-pf1-f196.google.com with SMTP id q17so4102744pfq.8;
        Thu, 30 May 2019 07:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kTJ8ArZPwoTe/kc7tRSB1MJFUVvoMiPQO4L8f7dIrOQ=;
        b=bod9phgBa5JtqUmKiyoDSFx3HrcoPp763LLeiGf5nIvNkt44bgVAX74OFWaqYtgzjh
         Exn7fgHzMEQMa9tGabi9N7dnmaBfRUXP5TUfQcZLsSpm1H1TEL+XzCPODmB/DOzubsGY
         4Hp7H7t7UKHY+6FRIgUGAxkpZ1FXk85WwTRiAXITeguxejLc+W/wDoY/CtaYCUrr+RzU
         k/A486Lw+4GCNjvouEwV7wP1WEYtdZFO9fGrEr2UPjsL39HlgXtGhN/AkjzcKc8yzvbw
         /vIvC7iQApcrwkJZGsPcZwlKWudmXaxE7m3hdN4GcoGrQKhjXCJnjW30HCbBiRMKXWWl
         IL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kTJ8ArZPwoTe/kc7tRSB1MJFUVvoMiPQO4L8f7dIrOQ=;
        b=q3cNdSvXpV+AuI7yFQ0rBvA4af5NpoDfcFsYWfQ+C8y38L78Loj5FnInDBl7rv2DHb
         AIrea1yoeL7ShoCmli2LxwJIIIatCn0nsIVFmlZfJc9CsqkAlblrzFIeMbEMX54CCbA8
         aP/MvPc1X+cULL9NLcfI9d9jYDn3zcyf3L5YnqL3WvOxQa2IFZNPhLkxgRU5iwnjlmip
         aJ4c4UMUdG+QWt/S+ygvWmrJWBJadQ24u4sCSbGQFP/Lr7NyAsEIwQvlFB9UVa2VZGaI
         CeiBeGkhat2x5x6+3lXAAKc1eR2t8QZDPl1eXAFbkBVTCVSt1k02Ue3D3WhQ7+GWOIcg
         /uRA==
X-Gm-Message-State: APjAAAVoIH2U3gPiUnXllyj3cAT1AWzvGxwe+cXCr2oNlofsOwalX4BI
        6Cgc9EYxNZurFTEDCeSny8ve9Kz2
X-Google-Smtp-Source: APXvYqy+jGwyjdT7xv3z4MeNxisnvbzp/p+LwQXtxYIeSPxt+RBiZpFYgDCtTyzGSlETNENf/kPR/A==
X-Received: by 2002:aa7:9dc9:: with SMTP id g9mr4081079pfq.228.1559227232508;
        Thu, 30 May 2019 07:40:32 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id j7sm3192837pfa.184.2019.05.30.07.40.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 07:40:31 -0700 (PDT)
Date:   Thu, 30 May 2019 07:40:29 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/5] net: dsa: mv88e6xxx: Let taggers specify a
 can_timestamp function
Message-ID: <20190530144029.r7ziskwqq7vurf43@localhost>
References: <20190528235627.1315-1-olteanv@gmail.com>
 <20190528235627.1315-4-olteanv@gmail.com>
 <20190529044912.cyg44rqvdo73oeiu@localhost>
 <CA+h21hoNrhcpAONTvJra5Ekk+yJ6xP0VAaPSygaLOw31qsGPTg@mail.gmail.com>
 <20190530035112.qbn3nnoxrgum7anz@localhost>
 <CA+h21hqko57LB0BB2TSGSr4p9_czPM-g9krO+wnU7PgvaMdSDA@mail.gmail.com>
 <20190530142356.vxkhsjalxfytvx2c@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530142356.vxkhsjalxfytvx2c@localhost>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 07:23:56AM -0700, Richard Cochran wrote:
> I recommend forgetting about these meta frames.  Instead, read out the
> time stamps over MDIO.

Or SPI.  It appears you use that for Tx time stamps already.
 
Thanks,
Richard
