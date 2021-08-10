Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B840A3E5187
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhHJDeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 23:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236494AbhHJDeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 23:34:12 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED188C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 20:33:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c16so19113253plh.7
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 20:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=e4m1YnxqjL4hNP26q3tKofQFStQZFrEYwaZQ6L4700Y=;
        b=V60GzVqTfandXnpTgffhVP2CgNhM6xXsdZacK8Nxmqyixo6uJdUu8Zv2sK5NSWa+kw
         pujeVlIYJJj1CG63eNPt5JHTwkXQW17dJClCevIHrydLPpuMMaDxxfAW4az9dNadVQHy
         Ub3iVgfDPVEPuc6ZSg/l2FMMOzIYZ8pjdepT7tX/RrAttTcRWsHHeZjEITaPjRM3s7i6
         lnTa6io7lPXusT//XIaJw7ribrtRNJqeBmyhUAMdyhFkIOstwPGec0APoq7BMkQb3B1Z
         N51ipzMAbDotvX2GXvcx1KO4EGuJrTv0j2VOIbOxHO8CeTYFlUZ0Y9gPRttT7yoekEai
         qHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=e4m1YnxqjL4hNP26q3tKofQFStQZFrEYwaZQ6L4700Y=;
        b=lLr+DoZLQRcU9dmKMwdxAiulsrFmjI62lBjvjkcHCsxvljNGIb2fTXsNNNYNd9rE0s
         zfCSXPolaDshjV2UNlOExY5KJsIshTB4C8X92oF//nlpUmxzi1TQ0BU0gAakQCWo3+1Q
         QHHgjQNXFYAYIKPsWdRJJAUZg1jaju9RklDKe6y31aG2emVWjllazObiIOZG6X10/Ala
         3tE8f1oodz6QEHvr8uw8vA8ys8ZKPl2jlrWiPuEnI3lNmP7jyfD0w9iP1FkmFe7dYY+X
         z9CRCyrIfZSM4LY5e+YkZipGHwmBGCH39USQ5jK8Se6pv0x6CahC0HFThcWQIOuJkUxB
         4AUA==
X-Gm-Message-State: AOAM5307m3+tybPfmIFahmumyvy+/v8f7TSvrwuu0PpDTIvlWsgeEWIe
        9bpnnksJAQQUd1Fbr6lm32c=
X-Google-Smtp-Source: ABdhPJzo4UTmBOI6XG3eaz02QX97gFSLOCXRVYwvXj6jsd2gozmxi7tjzYvX78RmiUi7bafoGjChZQ==
X-Received: by 2002:a17:90a:6947:: with SMTP id j7mr25278502pjm.196.1628566430549;
        Mon, 09 Aug 2021 20:33:50 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id x13sm20317113pjh.30.2021.08.09.20.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 20:33:49 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [RFC PATCH net-next 2/4] net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
Date:   Tue, 10 Aug 2021 11:33:39 +0800
Message-Id: <20210810033339.1232663-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809190320.1058373-3-vladimir.oltean@nxp.com>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com> <20210809190320.1058373-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 10:03:18PM +0300, Vladimir Oltean wrote:
> Ever since Vivien's conversion of the ds->ports array into a dst->ports
> list, and the introduction of dsa_to_port, iterations through the ports
> of a switch became quadratic whenever dsa_to_port was needed.

So, what is the benefit of a linked list here? Do we allow users to
insert/delete a dsa_port at runtime? If not, how about using a
dynamically allocated array instead?

> 
> dsa_to_port can either be called directly, or indirectly through the
> dsa_is_{user,cpu,dsa,unused}_port helpers.
> 
> Introduce a basic switch port iterator macro, dsa_switch_for_each_port,
> that works with the iterator variable being a struct dsa_port *dp
> directly, and not an int i. It is an expensive variable to go from i to
> dp, but cheap to go from dp to i.
> 
> This macro iterates through the entire ds->dst->ports list and filters
> by the ports belonging just to the switch provided as argument.
> 
> While at it, provide some more flavors of that macro which filter for
> specific types of ports: at the moment just user ports and CPU ports.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
