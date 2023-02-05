Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410FD68B020
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjBEN7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBEN7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:59:21 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D0F1BC4;
        Sun,  5 Feb 2023 05:59:20 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x9so1248954eds.12;
        Sun, 05 Feb 2023 05:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H928Sia096fL9yNby5D5FV45r+kPFEPsyI18CYMPqAo=;
        b=ixzJrQRVPIw3tQ3WgdkmW2cTOdM7OQSUuNSNMdJpQgDIWjIkzmNtffcfIcNTqUff8/
         M3v73gURVfSbNifLI2oljzFPVZ/y7e8zKXlGJR6OI9AiuXuysXLwZVRSWVAKmSNpS/4Z
         yQkWYMvxjj5E5Qpc7Cw1DmQlMep5AlsmY39x7p/z+HgPIWznUYmXAyjBGv6IBQBN5OXO
         cDGllWmvUcfoPiRLvhh+VxgZ+i4++pfcXRvWziPWNI/C7/1nDB3QKvdanc6ag2xtO4fb
         N3CdVQ0g7IVVYCLi+PGvaY2Dr9qfjsc5P3xsoC8yPG2oefkzNuXX+R9V+grQEjmwbiHV
         cbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H928Sia096fL9yNby5D5FV45r+kPFEPsyI18CYMPqAo=;
        b=wjpfbOIs97VZjjJyZ9pQgEN6Gvfi9Mv+bh73qkfxiyxr+9L+fmtLJoKeVTp0PEFEsf
         Nivzg1a/iE0VCyaAT2vX1ogY4IXjXmIDYmLXEN4y7FGbn+A5buhVeQzNf+4iNXxSwkN/
         bnaPTZSNbTeDZMrRtSGHY+WrVRsEVvwVKWkTHb3DPZIlDK7j8RwPqoGFDy2M8EHu1Xk7
         HKXSxAsmQck8x1xeMwuUL0B78DGNANwZ8mU3XjQpCL6RYBg+R6/sEVh/+Lvc7dR0yDUV
         uj1xn6nPYmLD1Yo4DzQXypdNzVtLrFfoNRWMAyyWE73CSY8Bzk8lqheo3VxBNn+U1oAz
         vVsA==
X-Gm-Message-State: AO0yUKV3fM61C+ACqrohygzqp5IT1YLNmZxWaW5c8TIEHMIUPc7DIVHb
        WTyG7YF76nwjpvQnf+qPIqLY+w4ZNOuj1w==
X-Google-Smtp-Source: AK7set8JgkwFZV//cqpVHmwWrcKs67dCJT99NqH0AFWou+RCLskdjI7XIN6/xT0mpwPQwNqkLvQpQg==
X-Received: by 2002:a05:6402:510d:b0:4a3:43c1:842c with SMTP id m13-20020a056402510d00b004a343c1842cmr12696290edd.0.1675605558537;
        Sun, 05 Feb 2023 05:59:18 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id fg10-20020a056402548a00b004a23558f01fsm3800736edb.43.2023.02.05.05.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Feb 2023 05:59:18 -0800 (PST)
Date:   Sun, 5 Feb 2023 15:59:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [BUG] vlan-aware bridge breaks vlan on another port on same gmac
Message-ID: <20230205135915.thabi6b555lr7lrr@skbuf>
References: <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
 <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
 <20230121122223.3kfcwxqtqm3b6po5@skbuf>
 <trinity-7c2af652-d3f8-4086-ba12-85cd18cd6a1a-1674304362789@3c-app-gmx-bap60>
 <20230121133549.vibz2infg5jwupdc@skbuf>
 <trinity-cbf3ad23-15c0-4c77-828b-94c76c1785a1-1674310370120@3c-app-gmx-bap60>
 <20230130125813.asx5qtm6ttuwdobo@skbuf>
 <trinity-4103b9e0-48e7-4de5-8757-21670a613f64-1675182218246@3c-app-gmx-bs58>
 <trinity-757008e9-a0a8-4d44-8b0a-53efa718218e-1675604935206@3c-app-gmx-bs34>
 <trinity-757008e9-a0a8-4d44-8b0a-53efa718218e-1675604935206@3c-app-gmx-bs34>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-757008e9-a0a8-4d44-8b0a-53efa718218e-1675604935206@3c-app-gmx-bs34>
 <trinity-757008e9-a0a8-4d44-8b0a-53efa718218e-1675604935206@3c-app-gmx-bs34>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Frank,

On Sun, Feb 05, 2023 at 02:48:55PM +0100, Frank Wunderlich wrote:
> Hi,
> 
> sorry for the delay, i'm very busy recently :(
> 
> noticed that i missed 2 commands ("bridge vlan add vid ..." below)
> when testing the vlan-aware bridge...now both ports are working with
> vlan-tagging...the one inside (lan0) the bridge (lanbr0) and the one
> outside (wan).
> 
> BRIDGE=lanbr0
> netif=lan0
> vid=500
> #ip link add name ${BRIDGE} type bridge
> ip link add name ${BRIDGE} type bridge vlan_filtering 1 vlan_default_pvid 1
> ip link set ${BRIDGE} up
> ip link set $netif master ${BRIDGE}
> ip link set $netif up
> bridge vlan add vid $vid dev ${BRIDGE} self
> bridge vlan add vid $vid dev $netif
> 
> #extract vlan from bridge to own netdev
> ip link add link ${BRIDGE} name vlan$vid type vlan id $vid
> ip a a 192.168.110.5/24 dev vlan$vid
> ip link set vlan$vid up
> 
> btw can i see somehow if a bridge is vlan-aware (the flag itself)...
> "bridge vlan" command also lists non-vlan-aware bridges with vlan-id
> "1 pvid egress untagged"
> 
> so vladimir your last patch works well, thx for it. you can add my tested-by when upstreaming
> 
> regards Frank

Thanks for double-checking. I was wondering what could have been wrong
with the patch and just not seeing it.

You can see if a bridge is VLAN aware with "ip -d link show lanbr0".
Add "-j" to the list of arguments, and you get json output which you can
parse with jq if you need the info in a script or other program.

The software model of the Linux bridge is that where you can add, delete
and see VLANs on a bridge even if it is VLAN unaware. Those VLANs are
simply inactive until the bridge becomes VLAN aware.

I will send the patch today with your tested tag on it.
