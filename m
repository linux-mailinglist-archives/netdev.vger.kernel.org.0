Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774BF3DF4B1
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 20:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbhHCSXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 14:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238476AbhHCSXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 14:23:48 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CA5C061757;
        Tue,  3 Aug 2021 11:23:36 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id go31so37655557ejc.6;
        Tue, 03 Aug 2021 11:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RA+iQWQTeYlsLY2I1OK863JprrWYyeqL7Fz/PQqMnUA=;
        b=sjXLmJ7eWfTfzpvQU57ZaF/6XY2NLa+WYw0zN2WeKFlfbSSH2lgKk+eHaGlyXjrgP9
         AMkTzoqphifICTbi6DJ+X/IYjGwSEOgcPs73DfNqzu9FxYqB+SGI/alMYgB0+Xh8vl0B
         XETer64OR2YMk2qr347HeNrAKNLIt+QbKreLX6tcRNFi3plTxoT70eDDDfb8YWRjiX7w
         33CiwDFPM95SkQ2YI+Gb1inIQaiRWW4rrA0O2AuE/0XsQvdaPkpYU0YD7U1eVIUvWA+e
         EKspCn09i28DPdRhfIXtztZA44Wvpd37zfBGtmjiD5684wOmVoYzL+5alPS7wWRkownS
         rwCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RA+iQWQTeYlsLY2I1OK863JprrWYyeqL7Fz/PQqMnUA=;
        b=T/36T/7fLM6IZcByLUSBAqBQr4ga7VeXAnUOdDLwsMKbU8MuE4vwW0QKDOY5LKJwai
         qoZBbWW3ugAdm67h0XpNx/sDr6OA6AxP/zlMt+KFgVfcbPhbXKoZB2G20vqGCK0+gI1L
         jTylvYCuSP8vsIR/sRD+AjiEUbZWVwBl9axr0PHs3jSYPZy4wrO0TFPEIl1j5+I8zoGa
         YX2ujVerkAx5N6+qFdvBBeKRT7EjZ9LIfT3x1eUDmmwO7MaNCM+EV9rLFKzvZDCE0Yir
         AAtmWYXqPiBcoSsQN21BLAQ8PQ7kJYS6ibuacm65te3NVYsaAGGFiQz3vke9FNSUgxS6
         3N5A==
X-Gm-Message-State: AOAM530jI1H4L6o01bVCDTTFJZClZxwR1NtVyex8LqdL+XAx83aCpvcL
        uoYkPJclHP35pbO++nG9kiY=
X-Google-Smtp-Source: ABdhPJwOgUdAbv2xPdPo89MY8rKRJHap2afTvPSwUStzaGBu0/3szRY/7SWM8uiNTPJYMPh9XY/B8A==
X-Received: by 2002:a17:906:404:: with SMTP id d4mr21836488eja.449.1628015014978;
        Tue, 03 Aug 2021 11:23:34 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id b13sm8575284ede.49.2021.08.03.11.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 11:23:34 -0700 (PDT)
Date:   Tue, 3 Aug 2021 21:23:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: Re: [PATCH net-next v2 4/4] net: dsa: mt7530: always install FDB
 entries with IVL and FID 1
Message-ID: <20210803182333.s2oc4yizwrzy746i@skbuf>
References: <20210803160405.3025624-1-dqfext@gmail.com>
 <20210803160405.3025624-5-dqfext@gmail.com>
 <20210803165138.3obbvtjj2xn6j2n5@skbuf>
 <20210803175354.3026608-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803175354.3026608-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 01:53:54AM +0800, DENG Qingfang wrote:
> On Tue, Aug 03, 2021 at 07:51:38PM +0300, Vladimir Oltean wrote:
> > 
> > The way FDB entries are installed now makes a lot more intuitive sense.
> 
> Did you forget to add the Reviewed-by tag?

Yeah, in fact I did. I was in a rush and by the time I figured that
I didn't do that, I had already left home.

Still, in fact the patch is obviously correct, which is nice. Standalone
ports never learn and the FDB lookup will always miss because it's in
FID 0 (a separate FID compared to the bridge ports) and there is no FDB
entry there. Packets will always be flooded to their only possible
destination, the CPU port. Ports under VLAN-unaware bridges always use
IVL and learn using the pvid, which is zero, and which happily coincides
with the VID which the bridge uses to install VLAN-unaware FDB entries.
Ports under VLAN-aware bridges again use IVL but the VID is taken from
the packet not just from the pvid, so the VID will be >= 1 there. Again
it coincides with the vid that the bridge uses to offload FDB entries.
Nice, I really like it, it is really simple.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
