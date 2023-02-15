Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E06C697557
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjBOEWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBOEWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:22:22 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0EF2705;
        Tue, 14 Feb 2023 20:22:21 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o36so12448942wms.1;
        Tue, 14 Feb 2023 20:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3YMLkksoZ4jJfn+msaHSyMfsNrZTPgUVFMg2RlFg3t4=;
        b=BtSsFKyisu7AZjIWvgF1BV4h9kmjVWCFS790Z365i0B9bA7d5TYhchzvaiTPUkrNCS
         3UpOL7+vpT4/JbAMwowbO/YWGk2Lj6IAoCKpdyeCoQOs4hVKg/T0yazmBqtn3gLPOx1x
         UDSutiwYWZnWMLXDd+36uQ6qsUG2+qRmhJHmvrVny7jwIv0y3JpNh5aW0yd6A73fJi9H
         CCDpt/EVp3bm6tJ9Kk2N5yvqZSvb/yz8jy+PWosPW5y4PQ2kQlU41wRPPJ6KPGexpE+s
         ebYsifoYnIYe6y1jVQV5kIAD/qikrEd3CtwGhPEForeD7uZIZirxOA69UyVwU2mmbEXL
         I7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3YMLkksoZ4jJfn+msaHSyMfsNrZTPgUVFMg2RlFg3t4=;
        b=265jlHt7lOVhEvQ8IBsHJbSZJ6MAMwBwLEV6VpWQFql40Gk/BDAauQbZea+RNewNcq
         lDispjNuSmFBHb3XhY9vqKoAZDqmsbgI1NzSHZeE5KABYkeZHDS/dCY22eHlEatC2fPj
         iutsw7grcC6x97l2WaHfWPApKYNveKNL1OK+HQMwo1baja/+cw5zNvNJopmT2uswijyI
         oaVvbRyvSyji9JV81hM6lNfCpMltklOcCsKcVu2OYwkBontVCYkbymZhUxmQysEnItZZ
         yhxYgSOJt510yHuOL2PuozGM8Ki2qhid428+raLJqNT567QZg8wF9Oha32xDE8mF9HZV
         0FDw==
X-Gm-Message-State: AO0yUKUBzKx0NAoSe+QlrToA0xjaUUcHjY56VIPh+WVxfpi0RgovpOoS
        ur0nm+d8fdUdR3XpuAF35Wo=
X-Google-Smtp-Source: AK7set/G/g+U7EHZpv3SmlkR1b90u+q38dhjWNehIjyNvpWHbFfi5Mjf2RjxaTk9e32N+GhwmzYgZg==
X-Received: by 2002:a05:600c:3583:b0:3dc:53da:328b with SMTP id p3-20020a05600c358300b003dc53da328bmr1375916wmq.14.1676434939932;
        Tue, 14 Feb 2023 20:22:19 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id l4-20020adff484000000b002c569acab1esm2405146wro.73.2023.02.14.20.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 20:22:19 -0800 (PST)
Date:   Wed, 15 Feb 2023 07:22:16 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: Uninitialized variables in
 yt8531_link_change_notify()
Message-ID: <Y+xd+AkAJpTnLY+h@kadam>
References: <Y+utT+5q5Te1GvYk@kili>
 <02c16d4c-1e88-c9b4-4649-a6125c160c09@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02c16d4c-1e88-c9b4-4649-a6125c160c09@motor-comm.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 09:51:56AM +0800, Frank Sae wrote:
> 
> 
> On 2023/2/14 23:48, Dan Carpenter wrote:
> 
> > @@ -1534,9 +1534,9 @@ static void yt8531_link_change_notify(struct phy_device *phydev)
> >  {
> >  	struct device_node *node = phydev->mdio.dev.of_node;
> >  	bool tx_clk_adj_enabled = false;
> > -	bool tx_clk_1000_inverted;
> > -	bool tx_clk_100_inverted;
> > -	bool tx_clk_10_inverted;
> > +	bool tx_clk_1000_inverted = false;
> > +	bool tx_clk_100_inverted = false;
> > +	bool tx_clk_10_inverted = false;
> 
> Thanks, please keep reverse christmas tree.
> 

Right.  Good point.

regards,
dan carpenter

