Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E9F1EA27B
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 13:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgFALMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 07:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFALMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 07:12:51 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3563FC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 04:12:51 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id y13so8844913eju.2
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 04:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7RW0TPmnGqCtRyUS4ma8U9vLM9ZqdDjiujyI2SxJfiU=;
        b=B7vacnY2GgKCqAEPOg6Gy60x/bJk3lCU/HiiOfIH8vedjwP7nwK7hx4WVQ+Q32RVfI
         yK8KuQouj1jQ6MM564IUpUPVQAXU5c+DpL0WoRrF2Fc7Ywg5by68noblPqRU+MM0cCKU
         PJnfUN4BfiGrUMA/fciAp3kRkmSBAgqqCC5iUF6cHBzuTPGtkZv8KRy6foZFCO+5/EDb
         9dtRW+74RpcsPP5qe13KsOu5CysIIBw5yeYqGGqiEKzSuB6BQ2zba4bDbpakyHHeKU2v
         GbDaMePF7udC6SrltAoc9obdaK9tJ8LbbIwNBq+VcLI4HKQ016SBp0ig8prD0y6bBRxC
         r8dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7RW0TPmnGqCtRyUS4ma8U9vLM9ZqdDjiujyI2SxJfiU=;
        b=RFiryQ0d0cwVAspXknJjOck49KBaW7uXrjMhB1xgaHfK3wfL6sMUimHzRLuCdSLEZ/
         Bq+mxw2lt4VyxTW6IZ8YpmC2qN0ek2FkhYmB+xl5G8S6uUXo4sHSlCNsG8g/axLW4JX4
         jL3VLHiLIdyNEnaQ+3y7BqPfUP9aCLIP856DbkDiw32ox6PU1xvLLzzl6h/aIulwoX+b
         mv996Hxb3VzIYY7aHIyQffZ39i0Lw6UJmK3VL0wcYkNDedPPoy7GisOUyA0b0Spe0lot
         dTqncCoDeC4bZVxhZiBbn+pC5SkkxAIcfbtUWu+vdWldyebzt6kXcSEh43BieQouieyS
         oTAg==
X-Gm-Message-State: AOAM531y2mzpe3ESrSIlcEuulGmi81wBl4rOcZwJW84j+hDRqANdOKbo
        BechBH2Mo7jUKMAG5wuv7DH6A6xgotn1thmz4nU=
X-Google-Smtp-Source: ABdhPJxToDsQud58Dgbxa1NSfIBRQ0q+kn3FzL5I5kgEFD/IBwm/XBdhZIbpNciBfO9ZrYthb1zpRCBDoZv/R2GZZj0=
X-Received: by 2002:a17:906:2e50:: with SMTP id r16mr18416247eji.305.1591009969956;
 Mon, 01 Jun 2020 04:12:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200531122640.1375715-1-olteanv@gmail.com> <20200531122640.1375715-2-olteanv@gmail.com>
 <20200601105430.GB5234@sirena.org.uk>
In-Reply-To: <20200601105430.GB5234@sirena.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 1 Jun 2020 14:12:38 +0300
Message-ID: <CA+h21hqp92JBchpesxT8spZs7P7nmW_Vf0tev_Li4hjWw2_vUw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 01/13] regmap: add helper for per-port
 regfield initialization
To:     Mark Brown <broonie@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

On Mon, 1 Jun 2020 at 13:54, Mark Brown <broonie@kernel.org> wrote:
>
> On Sun, May 31, 2020 at 03:26:28PM +0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Similar to the standalone regfields, add an initializer for the users
> > who need to set .id_size and .id_offset in order to use the
> > regmap_fields_update_bits_base API.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Link: https://lore.kernel.org/r/20200527234113.2491988-2-olteanv@gmail.com
> > Signed-off-by: Mark Brown <broonie@kernel.org>
>
> Please either just wait till after the merge window or ask for a pull
> request like I said when I applied the patch.

The trouble with waiting is that I'll then have to wait for another
release cycle until I can send device tree patches to Shawn Guo's
devicetree branch. So this seemed to me as the path of least friction.
In my mind I am not exactly sure what the pull request does to improve
the work flow. My simplified idea was that you would send a pull
request upstream, then David would send a pull request upstream (or
the other way around), and poof, this common commit would disappear
from one of the pull requests.
But apparently that is now how things work, so could you please create
a pull request for David with this patch?

Thanks!
-Vladimir
