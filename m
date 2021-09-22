Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A294F415001
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbhIVSkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhIVSkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 14:40:11 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A60BC061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:38:40 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id c22so13276676edn.12
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R+oyWfZDQLDZBvpboIG1KSedEFzzPSRui6ASAkTKmqE=;
        b=IJJ6WceebSoE3gnX5BwRBoU4FZGKFbCq9V7zpGiqcpkp2LCF5PltB6MZi0iP1mTmHa
         eNJCsUNOCLuf3kehmhintBB/DD7EM4AC+cco5KqhRMP8O6Y2LXO/D+hZ5GjDhFh6qQH2
         nyO/UmulVioOTULi0rtMIrZxifPjHEaUuU4OHWby3N6GSXhlGeVcKTMqSzE+Xd/z5pcX
         kARnNl579zgIXXyjoULlGPM6lpfeKgEkOd3iu9XkOHoeX3tSg0okCCz6oNbOrlTFp9HM
         2M//atSpbiKOur+JDSgfSH7vifzekoHHi+4uG8nqpsG8uld/mQ5ffyCaBZLXNYaYs8fe
         LULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R+oyWfZDQLDZBvpboIG1KSedEFzzPSRui6ASAkTKmqE=;
        b=sP7jVZpjGXsg516IBDgawt2R8S1ym83M9KYiVbGx2FLqA90yq3GX1/HcWXoyBpDJaZ
         WCQ5A5PvKHFJpVhBBvOlXbrvqQSUAtWwmtATds1NTWpVPT8cn1+naVZAc6F00Q4a+62e
         s1/1/Fe4OmyCAdj6Vc5wRwp6NZAvsgNE8CGmu3+47oqRX54Qv/q8QMSgQD7EVaEnpzkI
         aUxdcF6H06eYyQa7NhJEhoI7TDSz+f7WBTXsDlFWEZLKdnnbP8WuyXjVgC841zWkAqLt
         OCnKt9NIewXrOgbkVQySyHD9s0Xydjcp/eWzQO1nQMOc3vko1r/AGbFUfOcsXf/60uv6
         sJRA==
X-Gm-Message-State: AOAM5316bqcOEZwJB2UkHrDlO7a3BkMtDdEbPNjrzzwOiaK5apDzg6xU
        IZ5kdJZ2Llux88F22D1EiW0=
X-Google-Smtp-Source: ABdhPJyxMSAIpv/YbfMxBWiQqUoTEt+vhrLGtiB1zM3hIBQQ/eESLuY/Gwf0/M3zJ7SPZz5rQbBziA==
X-Received: by 2002:a50:e14c:: with SMTP id i12mr887840edl.125.1632335918758;
        Wed, 22 Sep 2021 11:38:38 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id s4sm1392206eja.23.2021.09.22.11.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 11:38:38 -0700 (PDT)
Date:   Wed, 22 Sep 2021 21:38:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dsa: sja1105: stop using priv->vlan_aware
Message-ID: <20210922183837.z2ujekutxyasvxde@skbuf>
References: <20210922144401.2445527-1-vladimir.oltean@nxp.com>
 <20210922162443.rdwyp4phk6cwpmm3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922162443.rdwyp4phk6cwpmm3@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 07:24:43PM +0300, Vladimir Oltean wrote:
> On Wed, Sep 22, 2021 at 05:44:01PM +0300, Vladimir Oltean wrote:
> > +	if (!dsa_port_is_vlan_filtering(ds, port) &&
> 
> omg, what did I just send....
> I amended the commit a few times but forgot to format-patch it again.
> The dsa_port_is_vlan_filtering prototype takes a "dp" argument, this
> patch doesn't even build. Please toss it to the bin where it belongs.

Superseded by v2 which has message ID 20210922183655.2680551-1-vladimir.oltean@nxp.com
Florian, please note that I did not preserve your Reviewed-by tag, due
to the patch looking fairly differently now.
