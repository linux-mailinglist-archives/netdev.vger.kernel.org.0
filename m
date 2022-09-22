Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D7C5E6B6C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 21:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiIVTE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 15:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiIVTEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 15:04:53 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523681570E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:04:52 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id a29so10218229pfk.5
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=WDmqcjtKpiOpzCNFo4l6LRrz9vV7ep04hvJTW8kVwVE=;
        b=S9Nb7S/8nQzkdbClqlGGqgt2ccPWjbNHP9Ni83QzetsP0PUeRF4PfDIjT3rRrLWxgt
         1VQFKxasCEYi3XitEq+6Jwi7rsCGyEFaD5PIN5XYvasMrdwow3EQOdFl/c3bWpm/S94b
         py1967yxaDgTYkbv3ruzWfNLumO/7DV5qH1arfr6L4YGufOR9EoD2Q1u4bV8JcvxMgdY
         cTJ/8PGHn+fwjahao6QFFgVVZZg1Zt+FJH3feUEjGx4He5umZLCmWwEgZTCRLzExZbB/
         iuIZk64jPyKXCbut93wd/eVH+SH6RNGsEY3zsDcE0Ek8kY9hMpVcGkzrK4qjFldH6ppl
         CHPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=WDmqcjtKpiOpzCNFo4l6LRrz9vV7ep04hvJTW8kVwVE=;
        b=4wQ8RBiD75rSICpxD9qXx5Irn34eMhMStpc+LFYjKqhaoXWWrfFaMhcuEQD7Z/Kdf8
         SF7eU5n8/GVLo76ZGP16mv9UwRAbXuAqwuHXbkBPzdcHA7N1gX+MRzlnQoih+ZeZ+Tj9
         12cZpWsWWUrYlQamfcPrD//ECCGlGD7JVuW2KB4kOgJkQsUJtoLQSi5kmZu06pYr59CT
         QnwfMqp2WIYpTLLufhjVt1ibYYJY0UgU6yhMrj5uoKOADl+wDvxN6zkoUP+XKTvgHmLk
         Advi8t9SDyOzMSsMOrka4qWTYaiDnmrQWeXtH1LhXqVjyZRYra+5faXiuX2TuPQ9/kk1
         m6qQ==
X-Gm-Message-State: ACrzQf1xrXZSvhEfAudZ8PVxiCGFG5cLPNo1UIAgn6M6Ub+mgeJy2JJp
        67why1SZtqlby9edtQHpRE9qnb+/ZhFbxw==
X-Google-Smtp-Source: AMsMyM4rS9QgdOhFlQVe0xa6lzj+j/KO4Xwbu72oM1AYKzPMswInzElOE8tHPLlN1a7Yk66KEA3CIA==
X-Received: by 2002:a63:2215:0:b0:43b:e00f:7c7b with SMTP id i21-20020a632215000000b0043be00f7c7bmr4238918pgi.511.1663873491721;
        Thu, 22 Sep 2022 12:04:51 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090abb0c00b001fba4716f11sm128514pjr.22.2022.09.22.12.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 12:04:51 -0700 (PDT)
Date:   Thu, 22 Sep 2022 12:04:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <20220922120449.4c9bb268@hermes.local>
In-Reply-To: <20220922184350.4whk4hpbtm4vikb4@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
        <20220921113637.73a2f383@hermes.local>
        <20220921183827.gkmzula73qr4afwg@skbuf>
        <20220921153349.0519c35d@hermes.local>
        <20220922144123.5z3wib5apai462q7@skbuf>
        <YyyCgQMTaXf9PXf9@lunn.ch>
        <20220922184350.4whk4hpbtm4vikb4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 18:43:52 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Thu, Sep 22, 2022 at 05:42:57PM +0200, Andrew Lunn wrote:
> > On Thu, Sep 22, 2022 at 02:41:24PM +0000, Vladimir Oltean wrote:  
> > > On Wed, Sep 21, 2022 at 03:33:49PM -0700, Stephen Hemminger wrote:  
> > > > There is no reason that words with long emotional history need to be used
> > > > in network command.
> > > >
> > > > https://inclusivenaming.org/word-lists/
> > > >
> > > > https://inclusivenaming.org/word-lists/tier-1/
> > > >
> > > > I understand that you and others that live in different geographies may
> > > > have different feelings about this. But the goal as a community to
> > > > not use names and terms that may hinder new diverse people from
> > > > being involved.  
> > > 
> > > The Linux kernel community is centered around a technical goal rather
> > > than political or emotional ones, and for this reason I don't think it's
> > > appropriate to go here in many more details than this.
> > > 
> > > All I will say is that I have more things to do than time to do them,
> > > and I'm not willing to voluntarily go even one step back about this and
> > > change the UAPI names while the in-kernel data structures and the
> > > documentation remain with the old names, because it's not going to stop
> > > there, and I will never have time for this.  
> > 
> > Yes, what is being asked for is a very thin veneer. Everything
> > underneath still uses master, and that is very unlikely to change. Do
> > we really gain anything with:
> > 
> > .BI master " DEVICE"
> > - change the DSA master (host network interface) responsible for handling the
> > local traffic termination of the given DSA switch user port. The selected
> > interface must be eligible for operating as a DSA master of the switch tree
> > which the DSA user port is a part of. Eligible DSA masters are those interfaces
> > which have an "ethernet" reference towards their firmware node in the firmware
> > description of the platform, or LAG (bond, team) interfaces which contain only
> > such interfaces as their ports.  
> 
> Let me make sure I understand you correctly.
> 
> You're saying that you think it should be enough if we make iproute2
> respond to "ip link set dev swp0 type dsa conduit eth0", and show "conduit"
> in the "ip link show dev swp0" output, both human-readable and json?
> And the man page description stays the same as what you've pasted, except
> for replacing:
> 
> .BI master " DEVICE"
> 
> with
> 
> .BI conduit " DEVICE"
> 
> and so does the IFLA_DSA_MASTER netlink attribute name stay the same?
> 
> In this message, David Ahern said that the 'master' keyword could be
> acceptable, if an alternative was also provided.
> https://patchwork.kernel.org/project/netdevbpf/patch/20220904190025.813574-1-vladimir.oltean@nxp.com/#25002982
> So could we also keep 'master' in addition to 'conduit'? The kernel
> documentation already uses this iproute2 keyword:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/Documentation/networking/dsa/configuration.rst#n412


My preference would be that a non-offensive term was used and put
as the preferred choice in the man page. The other terms like master
will be accepted as synonyms.
