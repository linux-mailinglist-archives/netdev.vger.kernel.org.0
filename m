Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E3397131
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 06:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfHUEit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 00:38:49 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40906 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfHUEit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 00:38:49 -0400
Received: by mail-pl1-f196.google.com with SMTP id h3so619666pls.7;
        Tue, 20 Aug 2019 21:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TCRzSo2+YmALi9PZyz5wD52AgU/Uh3WkVnPqoJEWQQw=;
        b=e+TGLLWGYWt0SDDKEqwe2WROAYLoMCVytYe9yQy77KeHIhr1fJ2oJZcSJWzezDc6Zk
         NFO1XTG8DfQZdPwg4zjUnpnJx2NIsQ2uFdaf+nrSQ/7rg8WP5b02gTPTBvkePmQqfE2v
         MqJTcfd+v9ntiFpInF/uBiuIDAn47EAr1dm2q9EgcrDYC7wK8oNO3o3a8B1MjZopWHQ0
         BXCgCaltL7eE3UnZ5XuENpMuFcMnmmygzcqPFyGSNajGEBfIomshK2lt93QNOeDvUiWv
         3ThQJOPFK3kS28sT6iis7zLn/4AZYiH3xP8PKRySrNOfhR9L2N5fORgJl25b3MGOlEcK
         k7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TCRzSo2+YmALi9PZyz5wD52AgU/Uh3WkVnPqoJEWQQw=;
        b=UsWY3G/EMZrEoGJPrMQUDt6/f2hkvU4hJgP1TWKitIekHUH0I6SsUjFpR33GpvL4W5
         yfUwS4eLpA/YkPv/OFCtEEKwVMZHlgzBR7gXADGVtLtqP9BO2P0nfmmkIrkjsW0cJ342
         DTEmOrQZ/UgoJY6tdjiRBOEm9ccq7TpI2J0fyYKhADOtUAGr6YS7jrOoEfVlBEj5Lkiv
         /ZHPgk1k6mP3L7rtcjFO5jxnWDGiPfPqb0bwC9phPeULWZJRXRZiXOEHwPQmPasu25Ol
         rEK3Kn3GospmOkUlFFf+cITDK0QAwGcN171BsabPm+oDGnSSD71am2cSgF8ggpe7qrwJ
         vGrQ==
X-Gm-Message-State: APjAAAUCHB0CdP/ln4sau2xsENkaytcSmPwMfWStydyt5I34gDaghzAF
        Xl0ed4iO4hPV5Snv601S4YIrZN/p
X-Google-Smtp-Source: APXvYqxA1/bLdDKvrBgXA8vYsRSbgsbcegGf2i/C/IkGtomaF8gB+ewvM3+eoBWwHNN33yMJYfPciA==
X-Received: by 2002:a17:902:9b90:: with SMTP id y16mr28580615plp.17.1566362328969;
        Tue, 20 Aug 2019 21:38:48 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id g2sm39921718pfq.88.2019.08.20.21.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 21:38:47 -0700 (PDT)
Date:   Tue, 20 Aug 2019 21:38:45 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI
 driver
Message-ID: <20190821043845.GB1332@localhost>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 06:57:10PM +0300, Vladimir Oltean wrote:
> What if all we need is just a mini-"phc2sys-over-Ethernet" that runs
> on a kernel thread internally to DSA? We say that DSA switches are
> "slave" to the "master" netdevice - their PTP clock can be the same.
> I am fairly confident that the sja1105 at least can be configured in
> hardware to work in this mode. One just needs to enable the CPU port
> in its own reachability matrix. None of the switch ports is really a
> "CPU port" hardware speaking.

I did consider this method when working on an early version of the
marvell driver.  At least for that chip, there was no way to get the
time stamps on the port attached to the CPU port.

The DSA system (as I understand it) does not allow using the Linux
interface acting as the CPU port in a way that would allow taking time
stamps with the existing code base.  You might find a way, but I guess
it won't be easy.

Overall, the PTP switch use case is well supported by Linux.  The
synchronization of the management CPU to the PTP, while nice to have,
is not required to implement a Transparent Clock.  Your specific
application might require it, but honestly, if the management CPU
needs good synchronization, then you really aught to feed a PPS from
the switch into a gpio (for example) on the CPU.

Using SPI or MDIO or I2C or UART as a synchronization bus is not a
wise solution.

Having said that, I don't oppose improving the situation for these
slow, non-deterministic serial buses, but you will have to sell your
solution to the maintainers of said buses.

Thanks,
Richard
