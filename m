Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFD55BD8A3
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 02:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiITAFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 20:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiITAFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 20:05:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079AB3F327
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 17:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HRQCUhvTbSSBDklmtO6xFe4UlwO/ZAZlCUmKmFjObfg=; b=xZBz66Aid1FBx6NnP5FxqyfPFS
        a3vLnhhKkljbaMw5zzkKnPoSa6WayfX4tdoxy2ylckEReQQLSkoVuqOY8hUAsjf2ZJFg8hfi2aByH
        vcCRGvu4Fvcz2jryGXKhp22gWohBqqOUFOz9e42RbeSv3so/zHLJnk/TwmjmqW4+MGmU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaQlJ-00HCNM-2n; Tue, 20 Sep 2022 02:05:17 +0200
Date:   Tue, 20 Sep 2022 02:05:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v0 6/9] net: dsa: qca8k: Refactor sequence number
 mismatch to use error code
Message-ID: <YykDvXQXt8EKwtgZ@lunn.ch>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919221853.4095491-7-andrew@lunn.ch>
 <20220919221853.4095491-7-andrew@lunn.ch>
 <20220919233057.ppfarnbf25znkzj2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919233057.ppfarnbf25znkzj2@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > -	if (!ack)
> > -		return -EINVAL;
> > +	if (err)
> > +		return -ret;
> 
> Probably "if (err) return -ret" is not what you intend. We know ret is 0,
> we just checked for it earlier.

Good catch. Thanks.

> 
> Also, maybe a variable named "match" would be more expressive? This
> shows how easy it is to make mistakes, mixing "err" with "ret" in the
> same function.

A lot of this code gets removed in the next patch. I'm just trying to
keep to lots of small, easy to review patches, which in this case
results in some not so nice intermediary state, but the next patch
cleans it up.

       Andrew
