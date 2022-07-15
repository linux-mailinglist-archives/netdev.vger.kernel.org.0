Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E9D575D56
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 10:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiGOIX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiGOIXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:23:55 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1E11A067;
        Fri, 15 Jul 2022 01:23:54 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id v12so5335141edc.10;
        Fri, 15 Jul 2022 01:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=50nutsC+krU3NXgQSYAVbec1C+SRe1EzNwOq/IlzrT8=;
        b=WWEYmDyFgx3g+pYU3bGS0o5MZYptqnSL1KuNLaFAQuz3z0s60An7jvwZEffsynwWmH
         QSn8DQccXv3Dc/qRli6SC3A5TYqGyT7kt9XhSk5hHSl7IckjPQDzt/LTUxkaVTRibtXy
         /m76fNkUySQHmtrNROPYW4DVKN+8WepU3GRq3q+cIVmtmnD3RMmXtXLJZOJadIqtbtS3
         sH658NGdqOWMr4A4Tfsw7yzMSaGoN4KDXVVHApbE23b5tZcvchsw+Y39L1oxsdLZkbNn
         xTviGs5CMQgyBadzkXJ2uJk1+C96NMuGGGZR2V3ITp99fF2AsZq3s40Ip1w+IoryBD2k
         472Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=50nutsC+krU3NXgQSYAVbec1C+SRe1EzNwOq/IlzrT8=;
        b=baF7DdU4nadF1eobDuTOJi0txl4A2DQufAw0/eA0W5AnEJuyOXmVI4suKIhn4aIrg/
         Vp/QSF0cPQ7KBvIHp7MvUZ/BVC3WLizFpioXB2VtM56tTchiP/UffJIRZqyp6s8B3bOQ
         KIlKHYGiaLUGdphJwJBdL+KsAE6lxiLm0kJVud1Lpsd/zlBefsV/a6UzWvoQVuWVRIr1
         TEuJnDPpf8f5GOpCr/X5B0s2nZFBsJ+BuNcZxfIWi+U6LdGtfuWmTr1yDdPSH/ooT4Q5
         T1zr3AoHY3mLrF/ZN1Kq67AavsA23GgKV24sEKm8bjCre5v2wSXmpZhsOYH2rHlzxHX0
         W2tA==
X-Gm-Message-State: AJIora9Hpx1Ah0JE46Nfw4xCgL7KLj9ujGnOV4z0MmZDE57DfHQw5+f2
        vTnZeEpSD6We1wnU2u5j9uU=
X-Google-Smtp-Source: AGRyM1smXMI1BwVdhCbmCWc0lJMQ9OIrv8ol0j/5bdXMhaBf0F1BmjBfrEkTGDL47EpHd0/d7GiEWQ==
X-Received: by 2002:a05:6402:241c:b0:43a:ec26:1ae5 with SMTP id t28-20020a056402241c00b0043aec261ae5mr17837412eda.189.1657873432659;
        Fri, 15 Jul 2022 01:23:52 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id u13-20020a17090617cd00b0072b31123174sm1705146eje.62.2022.07.15.01.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 01:23:52 -0700 (PDT)
Message-ID: <62d12418.1c69fb81.90737.3a8e@mx.google.com>
X-Google-Original-Message-ID: <YtDJmvLJqo8iD/u8@Ansuel-xps.>
Date:   Fri, 15 Jul 2022 03:57:46 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] net: dsa: qca8k: move driver to qca dir
References: <20220713205350.18357-1-ansuelsmth@gmail.com>
 <20220714220354.795c8992@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714220354.795c8992@kernel.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 10:03:54PM -0700, Jakub Kicinski wrote:
> On Wed, 13 Jul 2022 22:53:50 +0200 Christian Marangi wrote:
> > This is a start for the required changes for code
> > split. Greg wasn't so negative about this kind of change
> > so I think we can finally make the move.
> > 
> > Still waiting some comments about the code split.
> > (Can I split qca8k to common function that will be
> > used by ipq4019? (and later propose the actual 
> > ipq4019 driver?))
> 
> Does the split mean that this code will move again?
> If so perhaps better to put this patch in the series 
> that does the split? We're ~2 weeks away from the merge 
> window so we don't want to end up moving the same code
> twice in two consecutive releases.

What to you mean with "will move again"?

The code will be split to qca8k-common.c and qca8k-8xxx.c
And later qca8k-ipq4019.c will be proposed. 

So the files will all stay in qca/ dir.

Or should I just propose the move and the code split in one series?

Tell me what do you prefer.

-- 
	Ansuel
