Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E29D4D4D6D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343723AbiCJPMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344156AbiCJPMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:12:19 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE61ADFD6;
        Thu, 10 Mar 2022 07:07:20 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id yy13so12782216ejb.2;
        Thu, 10 Mar 2022 07:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=60uYG3ckY3WcYm8l3Wrv4qJH3dnlWFZqsAvB7+3ByW0=;
        b=is2XzSK4nxrutLs8h20VyMU7x3CVgv/M56eIif7Nnfl/h77xnTU4TVvx9LJTFzKN54
         xbtUokAT0kbf6nUHZtgHz/6JxBbVHaLSg/9d9GyglRPJ1M8rmXT93D6Ia3I20/0uVnH1
         ps7cvKs1J4WQejow2+4miwnHu6jgg1GmqAuYOg9S6VloqH9t2uZZf3VtE1cYOrcRu8hZ
         JREp9V1GIqrHrWRAQyEZtTJYQ9DReztp52i9TlhxQGZzkMOgWVGGI2BxEBQAaIUfDkja
         rWtxHH/RJEDz7foPphypKWHQ2Jc1MBc3vJ0SsOulZBRqlED9CK+f8AojLcU7sNF955TG
         8Wcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=60uYG3ckY3WcYm8l3Wrv4qJH3dnlWFZqsAvB7+3ByW0=;
        b=fSkWTMuTkM9ct0CA8qwvucZh+2cVhpGRTbefwEVq3j7H5PViJeDADXm13Uwsp+y4Ea
         hCUnoNF0VL1PMbdczFmjGHVTHpHuESZNzGmlVw0SPTUgpfN3QZRV9+NVk4Aixq37imOj
         Gsmug7xmw7fRfoZQ1GiWAzU5zAmED0iJBb2V4ViUt7dkapCY+QYXt2xxaNiRivmRoxIx
         CQ8BDT5o2bkbvYVVlhD8bpqOUv3+uwWvivK0i2C3g1zhgZKKfNmKU1ncVs+DRq9RB9oc
         UIH3oTPTcpjZwzjz7PLTBElIL/3Dc3bz1Sh1xSz7hUDcGTD5Vpvlvmucd5p0TGRTD1hz
         72yQ==
X-Gm-Message-State: AOAM531dKMqdh7N+K+8qrhHRNnF+eqTSppA6DvjhSHy71qMwtSW7ibYy
        ULy41pmsbfi82xOTKW8s2Jc=
X-Google-Smtp-Source: ABdhPJxiCsP0sqkSn+ttfs3GtimM/042s3/C6Rgq02nQi/V1TT3l/TsZrKzhFHTcMUy/KcA8QeXpiA==
X-Received: by 2002:a17:907:7b92:b0:6db:71f1:fc20 with SMTP id ne18-20020a1709077b9200b006db71f1fc20mr4619349ejc.343.1646924839382;
        Thu, 10 Mar 2022 07:07:19 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id t14-20020a170906608e00b006d1455acc62sm1858557ejj.74.2022.03.10.07.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 07:07:18 -0800 (PST)
Date:   Thu, 10 Mar 2022 17:07:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220310150717.h7gaxamvzv47e5zc@skbuf>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <20220310142836.m5onuelv4jej5gvs@skbuf>
 <865yolg8d7.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865yolg8d7.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 04:00:52PM +0100, Hans Schultz wrote:
> >> +	brport = dsa_port_to_bridge_port(dp);
> >
> > Since this is threaded interrupt context, I suppose it could race with
> > dsa_port_bridge_leave(). So it is best to check whether "brport" is NULL
> > or not.
> >
> Would something like:
> if (dsa_is_unused_port(chip->ds, port))
>         return -ENODATA;
> 
> be appropriate and sufficient for that?

static inline
struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
{
	if (!dp->bridge)
		return NULL;

	if (dp->lag)
		return dp->lag->dev;
	else if (dp->hsr_dev)
		return dp->hsr_dev;

	return dp->slave;
}

Notice the "dp->bridge" check. The assignments are in dsa_port_bridge_create()
and in dsa_port_bridge_destroy(). These functions assume rtnl_mutex protection.
The question was how do you serialize with that, and why do you assume
that dsa_port_to_bridge_port() returns non-NULL.

So no, dsa_is_unused_port() would do absolutely nothing to help.
