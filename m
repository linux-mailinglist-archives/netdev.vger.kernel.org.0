Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622B131D8B1
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 12:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhBQLoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 06:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhBQLnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 06:43:35 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D7EC0617A9
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 03:41:20 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id b14so15547827eju.7
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 03:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rA0qOj5Qnr9OamD92a8nM+3wqNABpMmQrWuhOp9m0xA=;
        b=HKa5r5LLSJrImLuSduT0LUlKvZOkUUEbxeqfv8VUKtmaUrTFEbGRwysvQhE3Q/UqpX
         0z2x+D8lzzIhVyR6CLEzFxnbLhVyc4KvJ6nRRo0BwP06gMdsJ808pdHAQIS1picuIHaT
         EtLtPAnP5XodHT14E+DXB5+u2Kb0Y9Tn3baWxqV6Sz+QlSLoYWo5Q60xce6aueDcFEJK
         hV4xB0iKQdwtCI+vBPh0ZUnOluk31q7QHxV/tknCEc4iY7x2ko6f1U9fhDPSQRwp/9oh
         tyFyZvN8kVmCA+h+Jokmxg1PZFh35spRLcetKxOSOAtD/D/6xDebFW9ZTShePOPvGgSO
         gubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rA0qOj5Qnr9OamD92a8nM+3wqNABpMmQrWuhOp9m0xA=;
        b=pv0PyD2qud5Dvk4xiLHi/GjRdMjXMDN+gi6fpM619pOBAcddplF70JqOC58436bKyX
         HVjO93u8wkv8/zOUEEwXUYhfh5MglBTsJBIIzJbt8Wgfvb9etwF0KlULtzSTME/BxbNW
         BZx1hZV3sglkQE5hpMH2F5KS6xHwM9tmMs34DCIA4vsSp7653AzwyKCKBbguVGwgPRUD
         ct2UjM791Xwn25QTeIBY38usVZQpJHiaC01WMYSn8UlH6nJgL6t9fV3E9H05MR+mTszj
         I7jQ+XGla6lDk+EcQyfE/AgRXaunExqTh6vTgynXcmWREUl9xhIfte5CM4RuAZWeiaL3
         +7rg==
X-Gm-Message-State: AOAM5310CM3bVjjMsf2mxVU3rbaRbAcWixi/Z+gVsTbk25QMP1hZ1VWT
        cmshRW71sQTRKv3lLE/+9mk=
X-Google-Smtp-Source: ABdhPJyOVNXYjgTRtz/HOlrB3ZzpDUxOxQlm2HKhrykfL1mSsTVI7Nedunmg2f4z7XkLjOxGBvOSEw==
X-Received: by 2002:a17:906:9b4f:: with SMTP id ep15mr24969012ejc.423.1613562078770;
        Wed, 17 Feb 2021 03:41:18 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q14sm936822edw.52.2021.02.17.03.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 03:41:18 -0800 (PST)
Date:   Wed, 17 Feb 2021 13:41:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [PATCH] net: dsa: tag_rtl4_a: Support also egress tags
Message-ID: <20210217114117.c7oit5tvwjztina2@skbuf>
References: <20210216235542.2718128-1-linus.walleij@linaro.org>
 <YCyNjB5PpYomt4Re@lunn.ch>
 <CALW65jZG35HNxYe=GXDGUVY6kLBExKczDM_pRU_ZrJ9QnHBUNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jZG35HNxYe=GXDGUVY6kLBExKczDM_pRU_ZrJ9QnHBUNA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 01:37:21PM +0800, DENG Qingfang wrote:
> On Wed, Feb 17, 2021 at 11:29 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > +     /* Pad out to at least 60 bytes */
> > > +     if (unlikely(eth_skb_pad(skb)))
> > > +             return NULL;
> >
> > The core will do the padding for you. Turn on .tail_tag in
> > dsa_device_ops.
> >
> 
> Please don't. .tail_tag does far more than just padding.

Qingfang is right, this is an EtherType tagging protocol not a tail tagger.

Note that there was an interesting discussion with Florian and Kuba
around the Broadcom switches that require padding for short frames too:
https://patchwork.kernel.org/project/netdevbpf/patch/20201101191620.589272-10-vladimir.oltean@nxp.com/
