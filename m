Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998CD1910D5
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgCXNT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:19:56 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39623 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgCXNT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 09:19:56 -0400
Received: by mail-pg1-f196.google.com with SMTP id b22so9007068pgb.6;
        Tue, 24 Mar 2020 06:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ebjznMFl+ZgcgqKdNPHSKXfiEzop411av9HdLnE7IFw=;
        b=mI9A5jKvJ49z6cnf6rYFl/QiWD6C73VCnla6N1XyjYKihxpdNiMLAAsjzH74Y84JXP
         Ven9+GZdf2D4CYyd76UJ7zMRSlkZRkO8UbrUGb+7SncEBpsaQm3WqI+zMS90grwOeviH
         K1ftv2hXar1VdtdykACxyGGmByCJdmOzX1z/CNSj+P80nLIHgb3874SQFe8qATPQPWOJ
         KXg8H3hcW/UbwEueVYBxeUChfXyJpZaRlCC9cvgTUE9jQPWaWCb+WNjeprPjpmk52E5T
         CuDlq79874IjwPbKF8cAysJQvU3hUKuK5MRMnbW2PA7Lri8l4mXKxUDDb1EwDlIAhstS
         omPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ebjznMFl+ZgcgqKdNPHSKXfiEzop411av9HdLnE7IFw=;
        b=J1DAdQDUnEnx/c/E4n83RiodQj+CArp9aYMXm+dqpuzLYeHmc/26s6F/EURywIFog6
         OpYji4w2XwSJL5KoQXuJVxSntndYkw3TLNUCyLi8kZpyOG56iBk4V4BtQhwYpNm1lNvq
         l8YYyuQTHxMA3Wt2CYINUm3YwYGTBYJEsr+URctyeBjSiwDR/hwu7oU3Mm2GUAEObgX2
         rBoEUSvmvat2U7BYTtneUFPE8vC/3DGc2Y0qCPQBPBdca9Na4d1ch4u/156nLa4XbXx6
         VmH3naeMY+abovh49viF+RZ3tIsKPrK9qTJUbf+RoQ4PN+Crnhe8FDL5LAwf71KVSYTT
         PWvg==
X-Gm-Message-State: ANhLgQ1T4MkHXMtxm3fxEw2oEVnM/xi84eO9xLb3wUqZcX/igrTdghcq
        VYrhV+YaUjyll0dw6THfMZc=
X-Google-Smtp-Source: ADFU+vt78KeM+4zSqcuPkFBk5K8J/LDNqnffc5v9LZepi0Dya4W0SUNZ27zStfMdWdXzbBlSAh08ww==
X-Received: by 2002:a63:450b:: with SMTP id s11mr27130174pga.45.1585055994782;
        Tue, 24 Mar 2020 06:19:54 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id t11sm2320636pjo.21.2020.03.24.06.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 06:19:54 -0700 (PDT)
Date:   Tue, 24 Mar 2020 06:19:52 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Message-ID: <20200324131952.GB18149@localhost>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com>
 <CA+h21hoBwDuWCFbO70u1FAERB8zc5F+H5URBkn=2_bpRRRz1oA@mail.gmail.com>
 <AM7PR04MB6885A8C98CA60FC435024647F8F10@AM7PR04MB6885.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM7PR04MB6885A8C98CA60FC435024647F8F10@AM7PR04MB6885.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 05:21:27AM +0000, Y.b. Lu wrote:
> In my one previous patch, I was suggested to implement PPS with programmable pin periodic clock function.
> But I didn’t find how should PPS be implemented with periodic clock function after checking ptp driver.
> https://patchwork.ozlabs.org/patch/1215464/

Yes, for generating a 1-PPS output waveform, users call ioctl
PTP_CLK_REQ_PEROUT with ptp_perout_request.period={1,0}.

If your device can't control the start time, then it can accept an
unspecified time of ptp_perout_request.start={0,0}.
 
> Vladimir talked with me, for the special PPS case, we may consider,
> if (req.perout.period.sec ==1 && req.perout.period.nsec == 0) and configure WAVEFORM_LOW to be equal to req_perout.start.nsec.
> 
> Richard, do you think is it ok?

Sound okay to me (but I don't know about WAVEFORM_LOW).

> And another problem I am facing is, in .enable() callback (PTP_CLK_REQ_PEROUT request) I defined.
>                 /*
>                  * TODO: support disabling function
>                  * When ptp_disable_pinfunc() is to disable function,
>                  * it has already held pincfg_mux.
>                  * However ptp_find_pin() in .enable() called also needs
>                  * to hold pincfg_mux.
>                  * This causes dead lock. So, just return for function
>                  * disabling, and this needs fix-up.
>                  */
> Hope some suggestions here.

See my reply to the patch.

Thanks,
Richard
