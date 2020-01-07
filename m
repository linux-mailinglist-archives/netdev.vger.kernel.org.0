Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC36132852
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 15:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgAGOB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 09:01:26 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42148 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbgAGOBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 09:01:25 -0500
Received: by mail-ed1-f66.google.com with SMTP id e10so50430260edv.9;
        Tue, 07 Jan 2020 06:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1DdkH/5E1tsHkzF5jhXew/z+AFPdpz7/Gvbqbl9G+dg=;
        b=d098/Ap5WZLDYOVx0LUlRnuUilSy+QZyFpM2S+2zMcaSMbQYhJs7Zsv6FI/Ks5jxXv
         dQO2dtGfqCwe9noHFs3y6uhVVyyaaGYPvZwl65t38wPj+hyImcuTHeqj5VyIA4f2lLWb
         UFEa9gC++l0TOhMPwTDLWof0xt/wpRXKZdRfavRYAv8KnTTjshhiZxdDSWfOtyFbT1Bv
         ymkgIQhCEUdCHX9AxIdCz7QsLJrymPx3I4pwcbwTXRCmuq1rwukCSqsog4onHzB8ED3B
         As0e8Ppu27OLG9hHYWl1FLz5+jvWgt0sYgd2BvjO6PTzcD9XD4qEGylhNQzi6oZNCc0p
         +UOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1DdkH/5E1tsHkzF5jhXew/z+AFPdpz7/Gvbqbl9G+dg=;
        b=lq8YThUGlMsKIZE4i7vF5A4PutyGuvXe/5S7kgV9OZc8TYBk+KTfidY0yQtEUEmYPO
         MgpXrKAp6VowgAy3e/sg2DQmsIbNLHWbV7iLGWfZ9lbz/bftTyIQyFOJMqmRC+wOJkfy
         VnwB/JTjglqEPLGSgf76Wg47yJgEnDabWwiAj7U94XuBc/5jCWe3boDjHE7PxpJFxdbT
         IH9sX3QBgVDlFldBHcIruhf+NHh6XlCoZZ4ycDHC/c7k/dIJO8+NVJwdF9tAQLxYBSEU
         4htvJU7i5PhP232KFhK+bGpkn02LRTq12rrfvcwH9/H3svyReTc4Hm41aT9t8aX/NimN
         FWVg==
X-Gm-Message-State: APjAAAWcXviDAnnAqK+FAGCeNRjwFr1GP4Z3FweORL89ja7TPCMgWF/S
        yZfDdjK2xZXbUqDicadoGo8z9NXqSCT6N0j3A4I=
X-Google-Smtp-Source: APXvYqyj/Sjok9k+8DFvLcnokJSMsKngAK+B55iujYFUBH+0eeHn408PpI8AyVvrp43iXISHPpiSNBLhnBPRapSUjiQ=
X-Received: by 2002:aa7:c80b:: with SMTP id a11mr115581083edt.240.1578405684201;
 Tue, 07 Jan 2020 06:01:24 -0800 (PST)
MIME-Version: 1.0
References: <20191226203655.4046170-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20191226203655.4046170-1-martin.blumenstingl@googlemail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 7 Jan 2020 15:01:13 +0100
Message-ID: <CAFBinCBJwHmQaHMEdZziD=qopqzG6sc2PABkt4E5Hrf927ussQ@mail.gmail.com>
Subject: Re: [RFC v1 0/2] dwmac-meson8b Ethernet RX delay configuration
To:     jianxin.pan@amlogic.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jianxin,

On Thu, Dec 26, 2019 at 9:37 PM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
>
> The Ethernet TX performance has been historically bad on Meson8b and
> Meson8m2 SoCs because high packet loss was seen. I found out that this
> was related (yet again) to the RGMII TX delay configuration.
> In the process of discussing the big picture (and not just a single
> patch) [0] with Andrew I discovered that the IP block behind the
> dwmac-meson8b driver actually seems to support the configuration of the
> RGMII RX delay (at least on the Meson8b SoC generation).
>
> The goal of this series is to start the discussion around how to
> implement the RGMII RX delay on this IP block. Additionally it seems
> that the RX delay can also be applied for RMII PHYs?
>
> @Jianxin: can you please add the Amlogic internal Ethernet team to this
> discussion? My questions are documented in the patch description of
> patch #2.
do you already have an update for me on this topic?

while we're discussing unknown bits of the Ethernet controller I also
remembered that we're currently not describing the relation between
the "fclk_div2" clock and the Ethernet controller. however, as
described in commit 72e1f230204039 ("clk: meson: meson8b: mark
fclk_div2 gate clocks as CLK_IS_CRITICAL") this is needed for RGMII
mode.
it would be great to know the relation between fclk_div2 and RGMII
mode on the Ethernet controller!


Thank you!
Martin
