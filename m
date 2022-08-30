Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC305A5FBE
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiH3JrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiH3JrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:47:12 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C9FA8CEB;
        Tue, 30 Aug 2022 02:47:04 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id m2so10589139pls.4;
        Tue, 30 Aug 2022 02:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc;
        bh=Mdm7RXxbaiMqbIvwgVNg80rbBKHP9tvmmvaTXp3Y6WA=;
        b=af/6rNSkVcUc/gsvwmvc+nHOYxPt1uZZ+bfaoby1m5MYYfwGrQCbrN8xZBUYrRSa4u
         ix39rICk+6Iprt1YHGh7uTJzxvOpI40UjqHztnXGIOELa0XackHrBG5hGJpBjDEAlbus
         85fawValBaXq3ndITaP3PH7ekIFZPSAPvjIlylwG4BxccBbgsBk1BQEefQdh/ARLXAn1
         TooCHbZHFRzFEmgeK92n9LAkUyao1RZ+oL6Ca/OD63pR2dz1S8HlrLL6XM9UXGbZlLwe
         i76Umk/vT7KSA0haxXAva5Cl7MGmQiGbDBaw/7UIHbSKiaYLNFW905D2KSWVkCbeeyBx
         HwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc;
        bh=Mdm7RXxbaiMqbIvwgVNg80rbBKHP9tvmmvaTXp3Y6WA=;
        b=MShtxpJt9ezfhHPkq5btnLNlTv2jbV8tL1+ZHq5ln6IlT9dDSo/zTisF3rNf8YMt00
         t4J8ESVyjffXmL46ypb4TPG/0MOzQgdmcrmJ5248upysCmmFQjgB6Wpc9jtxXzBsofZV
         OI4M6EcoPJNl+u89sRhg86WVDpAvmb7eksHq/a1lZOAVTfdoLhipUY3DIjA2PPoW6sZo
         B4aSL/FRBezUqnrOm4EPXEBB/BarOlHuuEQwd/wOyPcE6yxd9LKGetmRjy7NKc+ClvbD
         X19lMb0fiGnWp+NE/a+GzaoO8aYGBN/Hmmddfva3YKd/lyV61hO21j3tKQtWZzaEZMfH
         UkaA==
X-Gm-Message-State: ACgBeo0K6N/p6e84D7go47uZBueiGh3p4sEpPbLodb35zDYdjMG0DVIi
        5WnnybnLMvxpLSznU37IiL0=
X-Google-Smtp-Source: AA6agR7xCWG3rqVyJpWshuWFHbkYjJMQBZGVnhJrpx0cSatHFvpKI8kCMXDE2f3TZXh7/Rp1lmVGdQ==
X-Received: by 2002:a17:902:8605:b0:16b:e755:3c6e with SMTP id f5-20020a170902860500b0016be7553c6emr20432589plo.42.1661852824425;
        Tue, 30 Aug 2022 02:47:04 -0700 (PDT)
Received: from localhost ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id z124-20020a626582000000b00537e328bc11sm7029073pfb.31.2022.08.30.02.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:47:04 -0700 (PDT)
Message-ID: <630ddc98.620a0220.8913a.c476@mx.google.com>
X-Google-Original-Message-ID: <20220830094701.GA286783@cgel.zte@gmail.com>
Date:   Tue, 30 Aug 2022 09:47:01 +0000
From:   CGEL <cgel.zte@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn,
        Yunkai Zhang <zhang.yunkai@zte.com.cn>
Subject: Re: [PATCH v2 1/3] ipv4: Namespaceify route/error_cost knob
References: <20220824020051.213658-1-xu.xin16@zte.com.cn>
 <20220824020343.213715-1-xu.xin16@zte.com.cn>
 <6c0c312c-5b95-6650-e002-0ba76bbdd854@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c0c312c-5b95-6650-e002-0ba76bbdd854@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 08:23:56AM -0700, David Ahern wrote:
> On 8/23/22 7:03 PM, cgel.zte@gmail.com wrote:
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index 795cbe1de912..b022ae749640 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -118,7 +118,6 @@ static int ip_rt_max_size;
> >  static int ip_rt_redirect_number __read_mostly	= 9;
> >  static int ip_rt_redirect_load __read_mostly	= HZ / 50;
> >  static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
> > -static int ip_rt_error_cost __read_mostly	= HZ;
> >  static int ip_rt_error_burst __read_mostly	= 5 * HZ;
> >  
> >  static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
> > @@ -949,6 +948,7 @@ static int ip_error(struct sk_buff *skb)
> >  	SKB_DR(reason);
> >  	bool send;
> >  	int code;
> > +	int error_cost;
> 
> can be moved to below where it is needed
> >  
> >  	if (netif_is_l3_master(skb->dev)) {
> >  		dev = __dev_get_by_index(dev_net(skb->dev), IPCB(skb)->iif);
> > @@ -1002,11 +1002,13 @@ static int ip_error(struct sk_buff *skb)
> >  	if (peer) {
> 
> to here and then name it ip_rt_error_cost and you don't need to
> 		int ip_rt_error_cost = READ_ONCE(net->ipv4.ip_rt_error_cost);
> 
> make changes to the algorithm.

Yes, done.

> 
> Also, why not ip_rt_error_burst as well? part of the same algorithm.

done.
