Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37F22B2A3C
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgKNA4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgKNA4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 19:56:36 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493C6C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 16:56:36 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id o9so16403589ejg.1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 16:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sXVhG5m7OHKjE1L2cIE+fFgnVf1BtS3yV0/Bdbc+Z0c=;
        b=jKjOyHuRprYyV3Un3UoOfqGvsZ6BOlQsBEWnGdH5kga0Z9FNoTiP87tT3RJITi7tNy
         jPDTTYPRO4B88QaMavdBAvx51GHE7kWFToiPkFF655GDTNfYi5/ugElGkzKrfZCBUPCq
         qXx7wJj6BYiNo5HDEKzk/tgHjqhZyrjWhfrhd5E0nptKE5EEmVNgkx9AHZMKgfCjCwx9
         20L9v6YEaqH4K9WRe1shWqA1JSE6XBsikH0ySgo7RmUvaSEj49dfVvL25VyLEYmFzHJJ
         ECjHe/Ec/kKlSfKYbGRJdK2yfkbQ8IfIfg73BszBWol3SNSuV/CgPGflBKypBoqntl+2
         N8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sXVhG5m7OHKjE1L2cIE+fFgnVf1BtS3yV0/Bdbc+Z0c=;
        b=telYC5/x8s4xoAP1pZ75LLyWZ06J8agFdArRpywE12XAokfEgkt9SLOK2DZEVJvOgX
         CsEP9ZUdpWEXRNX1SCHvPpEawujU4cE7crU5/4teSPxkFigklZ/I65XYARPZAxS7llsV
         +aVWk1TfMKXnVscey3y1MNGTnUVNjmMJHJGndVZdnm13JcQjPIrfyrS4pt8C3l504w6k
         DxBTuiw++oxTHay1e3gaiTIoCp7owBcHkN1v9Rlbw0JW24QTeCutUShuZoi1bQvRmYXv
         JoODfmZ4gohYTVXVuc1fGmEzv2uDHkKhnaN1lqr51MyS1xwb1vjxb7bjmLbck6Qa5W7i
         k5YQ==
X-Gm-Message-State: AOAM5301meJO9WHm7Nw1OuBHeUPDyw2VYgsGZmBLLAxY8pddct6xydnd
        yWPfJGBQn/o8EAmw8tu9Fak=
X-Google-Smtp-Source: ABdhPJwcLlY8CxUJB6BXEF88Lhwjnl2iN97OqcEvL2EocRTYyeCr2NlPxZ1ScZCZgyxJaIOI7djeDQ==
X-Received: by 2002:a17:906:1a0c:: with SMTP id i12mr4601747ejf.176.1605315395058;
        Fri, 13 Nov 2020 16:56:35 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id 64sm5504015eda.63.2020.11.13.16.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 16:56:34 -0800 (PST)
Date:   Sat, 14 Nov 2020 02:56:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
Message-ID: <20201114005633.axcb6sc5qddycsuy@skbuf>
References: <20201111131153.3816-1-tobias@waldekranz.com>
 <20201111131153.3816-2-tobias@waldekranz.com>
 <20201113162709.608406b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113162709.608406b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 04:27:09PM -0800, Jakub Kicinski wrote:
> On Wed, 11 Nov 2020 14:11:52 +0100 Tobias Waldekranz wrote:
> > Ethertype DSA encodes exactly the same information in the DSA tag as
> > the non-ethertype variety. So refactor out the common parts and reuse
> > them for both protocols.
> >
> > This is ensures tag parsing and generation is always consistent across
> > all mv88e6xxx chips.
> >
> > While we are at it, explicitly deal with all possible CPU codes on
> > receive, making sure to set offload_fwd_mark as appropriate.
>
> Uncharacteristically unreviewed for a DSA patch :)

Yeah, I don't know what happened...
