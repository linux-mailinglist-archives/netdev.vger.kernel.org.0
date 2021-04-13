Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB1335D940
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240167AbhDMHq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240389AbhDMHqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:46:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A52C06138C
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 00:46:33 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id 20so3801283pll.7
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 00:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xeJKYAaXmn1gi4yGWdYjqmCbNI+I1WlGtaPB2x7C79c=;
        b=jpgqYuVbk67rwjnMe8Eac/kQQNyfzkwtu2z1Gxi/qJMKfhSbWqjmJXw9JNUoX+7P3W
         VuaU5x4kKqpRQd+gnykk3S1J8jX5L6cP2UxuakobP0+t/SIk2WIiSJfNNGKbVapsFgnQ
         81+lOmMwv0JKtAXZqZrQ23PChX1WSvcK2HNieh7svueWFkN4yjONReNqi8UxZgyoqGS1
         4eTMjFb4fQbI/FCqVAWf2NI+Sb4zKGbb8p1FSvH94s5B1JQdJmdn5oePh6g7vtu56NYB
         gWUEsuZ7ScR3Z+54cGbeNR0hZvikCArQkBwl198a0OXxXy09x/NKBLN0LJtBiDTagn9B
         zT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xeJKYAaXmn1gi4yGWdYjqmCbNI+I1WlGtaPB2x7C79c=;
        b=b4JHrZkTnesb4kpiOzWT9OagXDBCSIwiZAfW0rys2Pcpb8QXUTtBCNaTP8nr+ey1Ik
         hCbjN7pRDuWpwYUmuUz42y1gOTxPS6GzlPstmeb2cW/qqCY4VS7YAgOs5SqKVdrXGXwx
         5y5AsPvk9sCBPEgy9cn7lCU/xlbfxzvrw0bDdr6GFqpwZgjSB08szYFev4A0NR4UijF+
         VM6IlCQTva5OKMbRjRr8E7dza8orQ1Zf9pmbuUnHhBHFo0Mx4lNwnalvig5KsWd1sylt
         pw7oqm9PjCujYkMsTEKAUHVvI3UKC09dhBlHwhaMl7bzAzhYkIojDuEv3tvutjAvSamV
         Xy+A==
X-Gm-Message-State: AOAM533NEOViZac2SFYvRjiOfjj0SLGCs+TRWkefEmLx3H+yyic7ycZ4
        3eNa8F7AGpleaHuV1+4pgbDmqg==
X-Google-Smtp-Source: ABdhPJzeB8vHQ4uSgVXQVU13sSOcoDuXcoDMe5awRSIP1E/sIWZ6QRg9czacZdLMLRsGjVF4ZsvEFA==
X-Received: by 2002:a17:902:da91:b029:e5:e7cf:d737 with SMTP id j17-20020a170902da91b02900e5e7cfd737mr30231555plx.24.1618299993274;
        Tue, 13 Apr 2021 00:46:33 -0700 (PDT)
Received: from dragon (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id c12sm793373pfc.69.2021.04.13.00.46.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Apr 2021 00:46:32 -0700 (PDT)
Date:   Tue, 13 Apr 2021 15:46:26 +0800
From:   Shawn Guo <shawn.guo@linaro.org>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH 2/2] brcmfmac: support parse country code map from DT
Message-ID: <20210413074625.GE15093@dragon>
References: <20210408113022.18180-1-shawn.guo@linaro.org>
 <20210408113022.18180-3-shawn.guo@linaro.org>
 <82182ad8-c728-d313-047c-79478c9ee85f@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82182ad8-c728-d313-047c-79478c9ee85f@broadcom.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 10:22:47AM +0200, Arend van Spriel wrote:
> On 08-04-2021 13:30, Shawn Guo wrote:
> > With any regulatory domain requests coming from either user space or
> > 802.11 IE (Information Element), the country is coded in ISO3166
> > standard.  It needs to be translated to firmware country code and
> > revision with the mapping info in settings->country_codes table.
> > Support populate country_codes table by parsing the mapping from DT.
> 
> one more thing though...
> 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> >   .../wireless/broadcom/brcm80211/brcmfmac/of.c | 53 +++++++++++++++++++
> >   1 file changed, 53 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> > index a7554265f95f..ea5c7f434c2c 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> > @@ -12,12 +12,61 @@
> >   #include "common.h"
> >   #include "of.h"
> > +static int brcmf_of_get_country_codes(struct device *dev,
> > +				      struct brcmf_mp_device *settings)
> > +{
> 
> [...]
> 
> > +		/* String format e.g. US-Q2-86 */
> > +		strncpy(cce->iso3166, map, 2);
> > +		strncpy(cce->cc, map + 3, 2);
> > +
> > +		ret = kstrtos32(map + 6, 10, &cce->rev);
> > +		if (ret < 0)
> > +			dev_warn(dev, "failed to read rev of map %s: %d",
> > +				 cce->iso3166, ret);
> 
> Do we need a stronger validation of the string format, eg. use sscanf or
> strstr. Would also be nice to have brcmf_dbg(INFO, ...) here to print the
> entry.

Sounds good to me for both comments.

Shawn
