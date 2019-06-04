Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCB135113
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfFDUfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:35:04 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37241 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfFDUfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:35:04 -0400
Received: by mail-pl1-f196.google.com with SMTP id bh12so2714838plb.4;
        Tue, 04 Jun 2019 13:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GIw9IC0OvLZ/iRL94T6OVpdRrqmbMt7kJFXbM56zULk=;
        b=kRKi+tF3qSUO2t8m9qUPooGE4JJevAkhwWHueE6Fblonv5p3H2EVFbGUtKJJoDcmoI
         vhgOG/BaJxhVnCQyN8mVVVYDqgyCgVhB07ExfGYrdQKUqSdNxe6BNMegaSZqmaqa5XWF
         ebNL0EVuvhPcRxzQw27Chc/S7kxaeqrTJCRFx1bkWT0+Yh1kHorzrLrTfMizupXaJAyn
         2fJnwhSUdEljc0h1ckI5muTUpprtgkIx0vA+w6wNJcDCf1uaPvXJBEjXfsCEReS63oXW
         FHCUxbMrblMKUYKhfggJGrmIVmde9uNEQoyYTEd7U7guKVYLg/LTMPYguRbrevuu/s4g
         E0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GIw9IC0OvLZ/iRL94T6OVpdRrqmbMt7kJFXbM56zULk=;
        b=XLPPlrSCM/ppUEEw4KwMyPYPKlQvBAU1+AlG8mtRur4Xr4aqr7ihnOVQDn0xijBPEk
         7zgSsJ2p8BCqbUnyxAXKG1k9/5gf2PoeQkVuSo2FZ6mTMpiuZKr/sNpZxAXfxBbQBUiO
         S+GszhRw7DtNBAo8O0PZMTcqVj1+RCNFIddV5xX2LD58gXtn5Zdc4O96UOnzMZeI/0Po
         urq7GU/JvE7sihCFBFe2CyhL6DFovbgzTYbpLXg8tJ/gpFwcNNExHmJkydveIq9i05d3
         BDKZ2K/wid2SM0+VybB15dCOJDnCQNLEJHrfgNy/YzHcUkfEMn2mT2RZ/V5F8lRExnWk
         Z6kg==
X-Gm-Message-State: APjAAAW9lt9J/JcflJlK/hiROWZGdydARZxHLSWFPcDo5bms57hjnJQ5
        3dmEe1Wy0NB2aXtRV5sIHIRFDOga
X-Google-Smtp-Source: APXvYqzQTiMWLHuAeH/oP4RDWXwQgf/bbXND9vYeOgX+AfwWijfY15Z9niqGz31kXaUzqRS3/YUJ8g==
X-Received: by 2002:a17:902:a40d:: with SMTP id p13mr37174196plq.11.1559680503211;
        Tue, 04 Jun 2019 13:35:03 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id m19sm1383742pjl.0.2019.06.04.13.35.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 13:35:02 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 06/17] net: dsa: sja1105: Limit use of
 incl_srcpt to bridge+vlan mode
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20190604170756.14338-1-olteanv@gmail.com>
 <20190604170756.14338-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <069734c5-9f0f-12d7-b514-1e5ba495fc5c@gmail.com>
Date:   Tue, 4 Jun 2019 13:35:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190604170756.14338-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2019 10:07 AM, Vladimir Oltean wrote:
> The incl_srcpt setting makes the switch mangle the destination MACs of
> multicast frames trapped to the CPU - a primitive tagging mechanism that
> works even when we cannot use the 802.1Q software features.
> 
> The downside is that the two multicast MAC addresses that the switch
> traps for L2 PTP (01-80-C2-00-00-0E and 01-1B-19-00-00-00) quickly turn
> into a lot more, as the switch encodes the source port and switch id
> into bytes 3 and 4 of the MAC. The resulting range of MAC addresses
> would need to be installed manually into the DSA master port's multicast
> MAC filter, and even then, most devices might not have a large enough
> MAC filtering table.
> 
> As a result, only limit use of incl_srcpt to when it's strictly
> necessary: when under a VLAN filtering bridge.  This fixes PTP in
> non-bridged mode (standalone ports). Otherwise, PTP frames, as well as
> metadata follow-up frames holding RX timestamps won't be received
> because they will be blocked by the master port's MAC filter.
> Linuxptp doesn't help, because it only requests the addition of the
> unmodified PTP MACs to the multicast filter.
> This issue is not seen in bridged mode because the master port is put in
> promiscuous mode when the slave ports are enslaved to a bridge.
> Therefore, there is no downside to having the incl_srcpt mechanism
> active there.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
