Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FEE532A85
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbiEXMjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiEXMjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:39:01 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE0F87A29
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 05:38:59 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id f9so35140161ejc.0
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 05:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=g0lJM0akLYueQjfQYKkkke7gVw71AuMiuKOW5FVjrWE=;
        b=CLbw/mJ69J5UKovEPKuV9Rrf7BYXvzY8/QrIMPTPEwKmPdDg31ALcqMjCL97v4sfid
         aoM5QHhdE575CjKWtqDuIixLPZqbuWwetGPQeyc/f/cy0extRAys0oA8X8r8rvfW9WVP
         1kshkh7g6m0DDJoL6la99tBShQ7WKUdzI6I70i0zwR+3jpY7BJDereRC3FuIS5OvMewp
         IuBArHKIw5Npm0LHTkt5DjNXlp+SdjU7k5PaFZNsbg9HtySuViioTDbbSoRm9qK1swRE
         HP20XM+G4cVBZ9JpcfR9gElCiXgB9Gdv1gbUrI+nvnRKOYl6mAzo9yLgvYbKzwK1ScYn
         NBiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=g0lJM0akLYueQjfQYKkkke7gVw71AuMiuKOW5FVjrWE=;
        b=gb95rHBEWbBU+7vRovW8LMqH7H4/WC40Eq3LYRdFEoQRqmGHuZ2S2THbAIHOUCgN5t
         dBKqnvqiGHyAdCsc3A4tMi+KzDYXZjwdbr3wY95mGp2+V2L1bUZxZoGrvHqISScCnKSF
         kLR9kZI7n3FYKSHB1COI9j46L5kd1hOK/u2cF/BS2cROZuyKm9k2/Nr78ApitCjTwybO
         /lkGRd/e9XBFwnuqKbp0TG/3M15jfUNHDd7EG6dExoaHAa5gW+1xsCSKTgavrnKyH4u/
         O/UtnaWg7psEjPsAegu6rGPsyiFYt+Upb5b7pWf6ErC+Rd/yRh+m4K3h1IRHdUtMFh9S
         VD3A==
X-Gm-Message-State: AOAM530JTpgiNkF9zPFrOs8y1Q2KRPmB4x4mJXt4WK0Ag2++TOYdoFVa
        7N4pWTkCaLKpgWtZihzkYD4=
X-Google-Smtp-Source: ABdhPJyzvWha3VSDv0H3KSxQsNff4pLPg9fEaM4aadQHp9pHW25vj47b6/GRbmXIIU74HK3vaDuM7A==
X-Received: by 2002:a17:906:5783:b0:6fe:a263:f648 with SMTP id k3-20020a170906578300b006fea263f648mr19702617ejq.493.1653395937766;
        Tue, 24 May 2022 05:38:57 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id am5-20020a170906568500b006fee16142b9sm2240830ejc.110.2022.05.24.05.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 05:38:56 -0700 (PDT)
Message-ID: <628cd1e0.1c69fb81.d28b0.df81@mx.google.com>
X-Google-Original-Message-ID: <YozR3U4ZWiT46W+j@Ansuel-xps.>
Date:   Tue, 24 May 2022 14:38:53 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC PATCH net-next 00/12] DSA changes for multiple CPU ports
 (part 3)
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <628cc94d.1c69fb81.15b0d.422d@mx.google.com>
 <20220524122905.4y5kbpdjwvb6ee4p@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524122905.4y5kbpdjwvb6ee4p@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 12:29:06PM +0000, Vladimir Oltean wrote:
> On Tue, May 24, 2022 at 02:02:19PM +0200, Ansuel Smith wrote:
> > Probably offtopic but I wonder if the use of a LAG as master can
> > cause some problem with configuration where the switch use a mgmt port
> > to send settings. Wonder if with this change we will have to introduce
> > an additional value to declare a management port that will be used since
> > master can now be set to various values. Or just the driver will have to
> > handle this with its priv struct (think this is the correct solution)
> > 
> > I still have to find time to test this with qca8k.
> 
> Not offtopic, this is a good point. dsa_tree_master_admin_state_change()
> and dsa_tree_master_oper_state_change() set various flags in cpu_dp =
> master->dsa_ptr. It's unclear if the cpu_dp we assign to a LAG should
> track the admin/oper state of the LAG itself or of the physical port.
> Especially since the lag->dsa_ptr is the same as one of the master->dsa_ptr.
> It's clear that the same structure can't track both states. I'm thinking
> we should suppress the NETDEV_CHANGE and NETDEV_UP monitoring from slave.c
> on LAG DSA masters, and track only the physical ones. In any case,
> management traffic does not really benefit from being sent/received over
> a LAG, and I'm thinking we should just use the physical port.
> Your qca8k_master_change() function explicitly only checks for CPU port
> 0, which in retrospect was a very wise decision in terms of forward
> compatibility with device trees with multiple CPU ports.

Switch can also have some hw limitation where mgmt packet are accepted
only by one specific port and I assume using a LAG with load balance can
cause some problem (packet not ack).

Yes I think the oper_state_change would be problematic with a LAG
configuration since the driver should use the pysical port anyway (to
prevent any hw limitation/issue) and track only that.

But I think we can put that on hold and think of a correct solution when
we have a solid base with all of this implemented. Considering qca8k
is the only user of that feature and things will have to change anyway
when qca8k will get support for multiple cpu port, we can address that
later. (in theory everything should work correctly if qca8k doesn't
declare multiple cpu port or a LAG is not confugred) 

-- 
	Ansuel
