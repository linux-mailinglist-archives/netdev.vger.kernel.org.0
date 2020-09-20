Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0A62711C5
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 04:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgITCeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 22:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITCeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 22:34:19 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E72C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:34:19 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k133so1164593pgc.7
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PAe/FqlZNg9x2k4+5iA9OgI4f51NOhZrtFYnzRKp8lQ=;
        b=KffGVF0do5a8FuavxgWob3dpaH5y4K/K0SyKyZaHsOteXw+S1tyqx1e0E/GeQGOsY0
         z8h9+BDWuUVJAEcCcV3Y/lOicAQo8tz3E7FVRTWH4M1mm8aPwQRR3Ay4uGBKVlqlPZSP
         eHn8we86VpmC/MAw7oYlRXqXdmMh8zz/6RKseHvnk0N2rRMrqbdEseAatBeR99qntJs6
         IkXWOCL7wt8HXeyFNNCJJY/B+gyg6p1kwsiSeSni/KoYcEgahPmmJwRdGYb/4rYk36U3
         H96j+6+MTr20jOoyGWYjLGKhtyst4e8b2AJDOSNGwgCiRQuB2qusfCOWJ2/rfpIrPU9R
         leFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PAe/FqlZNg9x2k4+5iA9OgI4f51NOhZrtFYnzRKp8lQ=;
        b=Q1V22JLRQuS1ND6QFYEtFjq1u52taont2wfa9bu0zmqj9epOjIobhOOAIWi3W5TcgF
         labfrNiH2l3i09yFuJwDBXng31tXbnhA4Dg9uyEPK7Nb6W9SfnFoxd1g+GuNgbkFDD7F
         k7yTq8FvgXhGKwvYIknZ9vbqQJ+aCqCA3LAo84tizMCSuAT6j+6X1K7wP2XX+C47Mmgg
         jGER1vtQbQze0M1IvgFbJyCAXi/fkoLxpqcgHQNg1z+AVfGvwE2HxSR0gZo+/1pHzef+
         ws23g2B7kmkRd7lwESRuaO9VVWsoE8KjW1ut6jmF1VzsOalGv//CfQCPld24AQTtuq9/
         BFfA==
X-Gm-Message-State: AOAM530GCDUgEb5AAz4NDeP9XjSrYZPPDixH46mRj3Tb3gXdlKzZ7EmO
        z+nNpxzpGHaU+exEePCa/uo=
X-Google-Smtp-Source: ABdhPJyD84aQFDoKTPhY5L9GoOGWUrLRIJKMd8tu1ZOMgNUVjQ/EiH6JG7uj3A8XjnAMr5qHOwjo4w==
X-Received: by 2002:a62:e501:0:b029:13c:1611:6527 with SMTP id n1-20020a62e5010000b029013c16116527mr37093664pff.7.1600569259351;
        Sat, 19 Sep 2020 19:34:19 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id in10sm6926685pjb.11.2020.09.19.19.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 19:34:18 -0700 (PDT)
Subject: Re: [RFC PATCH 3/9] net: dsa: convert check for 802.1Q upper when
 bridged into PRECHANGEUPPER
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, idosch@idosch.org,
        jiri@resnulli.us, kurt.kanzenbach@linutronix.de, kuba@kernel.org
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
 <20200920014727.2754928-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4bfcb189-b790-ccf9-d1d7-620624ea528e@gmail.com>
Date:   Sat, 19 Sep 2020 19:34:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920014727.2754928-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/2020 6:47 PM, Vladimir Oltean wrote:
> DSA tries to prevent having a VLAN added by a bridge and by an 802.1Q
> upper at the same time. It does that by checking the VID in
> .ndo_vlan_rx_add_vid(), since that's something that the 8021q module
> calls, via vlan_vid_add(). When a VLAN matches in both subsystems, this
> check returns -EBUSY.
> 
> However the vlan_vid_add() function isn't specific to the 8021q module
> in any way at all. It is simply the kernel's way to tell an interface to
> add a VLAN to its RX filter and not drop that VLAN. So there's no reason
> to return -EBUSY when somebody tries to call vlan_vid_add() for a VLAN
> that was installed by the bridge. The proper behavior is to accept that
> configuration.
> 
> So what's wrong is how DSA checks that it has an 8021q upper. It should
> look at the actual uppers for that, not just assume that the 8021q
> module was somewhere in the call stack of .ndo_vlan_rx_add_vid().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
