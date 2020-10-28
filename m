Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9EE29DB4A
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389262AbgJ1Xsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389254AbgJ1Xsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:48:38 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354D6C0613CF;
        Wed, 28 Oct 2020 16:48:37 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id p5so1390956ejj.2;
        Wed, 28 Oct 2020 16:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eNUOh/tk4ijb64RycOo+wN+pUm2kkFJSm3fn+Ar/eiE=;
        b=GWu5oT8xsv2dIUj9gddZ+6C6wavLn2bWvCITsO/7cOtJn3Fajw8AlR2JzCxQKfrzDh
         /rpIcRBCf5V8Ra6WMYLoGHGoylRh1W54ul1PAMtfvFOF3CBMtKLlcC1ztKofe849CpjI
         d460zzSBObsBbct42puLPy3dZHnSL7TzXTrKb2+hLuP6sKCVPdGBCzJgTKPLcyIKmfTR
         qvkj/6l6S+sO4+CQnYcIZ762QgQdxrbMVuw2yOAgXDwEGHuLmHdsyfraBdXRIaajbOpN
         KgSVSyDBiPkYgMLlXpYJrtH4v6DaYGpgrkVNGbQhUpUwr3yUG/dy+O8M3Nx2IgfEUXvn
         T8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eNUOh/tk4ijb64RycOo+wN+pUm2kkFJSm3fn+Ar/eiE=;
        b=ctlknFJXqFXMWo/wi2ZpMGXNxWrpIuIrTMXwM9kw4U1pAeDEohOtLEaKN/Hlnh7btO
         /6Ix9RTZMWXr4GS7mAjSbsIpTshNc3FeiWjQuEse8YFjvkXJLY0WJR5Y+lH11IJ/pQ+U
         ATpJuiEdok6C9hJfk7D/bdf+WlEMYP8U/wUwG2d4BbQVRQIwhVz9TxkqBL5YZC6kASm7
         55h72R9tPGUtQ8jFbwJwZVKmD9F/Q1hzble8MbHiWf7nMdveWLz/h2ZivtC+r5t/qzG9
         YOmFn885NvW3HG50WpKKrmz2Sfs/nNbOGy09Ue1KTxjzao7tfFzVP6kOK2ZE8fAVUlJb
         yMyA==
X-Gm-Message-State: AOAM530rLcMgwniyUTfa4JHsRy3icu1ZF/ecDwbZLRkjxF2a8knjtO36
        xmbuMnWgeGvehB8ReY4cy+bGSC7VtUM=
X-Google-Smtp-Source: ABdhPJwlw/fZewpfuiieeSgyxtrVgWiKIx/8QW6ubZurrVv+p4GbvTdqpGm2IQFDZPRQfnFtfEUg5g==
X-Received: by 2002:a50:e185:: with SMTP id k5mr6815654edl.48.1603881826478;
        Wed, 28 Oct 2020 03:43:46 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id y2sm2690102ejf.85.2020.10.28.03.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 03:43:45 -0700 (PDT)
Date:   Wed, 28 Oct 2020 12:43:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v7 2/8] net: dsa: Give drivers the chance to
 veto certain upper devices
Message-ID: <20201028104344.56exyeh5tbwefyw5@skbuf>
References: <20201028074221.29326-1-kurt@linutronix.de>
 <20201028074221.29326-3-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028074221.29326-3-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 08:42:15AM +0100, Kurt Kanzenbach wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Some switches rely on unique pvids to ensure port separation in
> standalone mode, because they don't have a port forwarding matrix
> configurable in hardware. So, setups like a group of 2 uppers with the
> same VLAN, swp0.100 and swp1.100, will cause traffic tagged with VLAN
> 100 to be autonomously forwarded between these switch ports, in spite
> of there being no bridge between swp0 and swp1.
> 
> These drivers need to prevent this from happening. They need to have
> VLAN filtering enabled in standalone mode (so they'll drop frames tagged
> with unknown VLANs) and they can only accept an 8021q upper on a port as
> long as it isn't installed on any other port too. So give them the
> chance to veto bad user requests.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

In case reviewers have doubts about this new DSA operation in general.
I would expect that when LAG support is merged, some drivers will
support it, but not any tx_type, but e.g. just NETDEV_LAG_TX_TYPE_HASH.
So it would also be helpful in that case, so they could veto other types
of bond interfaces cleanly. So I do see the need for a generic
"prechangeupper" operation given to drivers.
