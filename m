Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292996EA6C3
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjDUJRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbjDUJRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:17:45 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EEF6181
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:17:42 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-504e232fe47so2496849a12.2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682068661; x=1684660661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ho8J7Mo5mHRy1sjeLejouOFCiOdgZ2KgA4dOHyimRTo=;
        b=kfk6sU5O66izeAsBWUiLNIiqjHohHxPO8HlH6aqua+SIC3dnirYpGBQJUPRdhkxSvI
         rG2CmuNNHJi4kHymhP30nmiyEj4thamq22a5L7H2dfVQXC4Z4c/rXfSpnlTVIXV6B/he
         zYnXLSRlvXSjCj2fZXyIYBj5fYKXGZQDrKAu05XYQ6Hg5apdK75Ju9c4VmNSdOjlGvzi
         /WWmTQCbiyqtjKCXKmYKixVmC0WY4ofUc/UkzKZwo8bElI4M5MnGGaFnDzgqAkBdvvVY
         YHiZfFEYjvU1jlQ224OuU3C9nGsG8tC5l8LPSeSibSnXxk71htk9ByKSRM2aCOzP/4jZ
         8ZaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682068661; x=1684660661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ho8J7Mo5mHRy1sjeLejouOFCiOdgZ2KgA4dOHyimRTo=;
        b=Kc1CHKP0n/bkyI2ZfjMzgTdzfj8YciJEiuQSVNnwzwoLEjBNTw2EyAF2ENXxcAxF4r
         LKT7FO5IopNvlW0Z7Zt9FlagpegMmSCi0aC7XunozKp+NE57Np9AjjQR+ZxJG8zFiaop
         4k+eS7uodwau6GHAkvjJM0O/Q1whBbWS3nFSOhdxeTARQ6MsRRgl24Kt2jHQwUcxHDUL
         BwOMoG6QSZXNaxGHm2umJtk+tdgNJO9RyvWrDHby9EXk3Ypp+p1zBMjTlQzGmgbm0EDQ
         hmJj5IWfUTZToKLTeC2S5KUb2Rzey27MgLuGme469+/7YCdHieO0+sR7n0Jp57f5d9S1
         dJ1A==
X-Gm-Message-State: AAQBX9dKPd6Dg4Xa0Mqdm/szhwAWAOwCDLor9v2GBmK2nlPVlhxl63gi
        LoV5UAxbnBHW/5kQXSEbziQ=
X-Google-Smtp-Source: AKy350YjnPS/SpcWc4mIOOU+QL9oxQ55688lDakZi7hl3SdXwCtg2pnLGPYEGm2ZfHz7+26FzqkuzQ==
X-Received: by 2002:a17:906:3acd:b0:932:7f5c:4bb2 with SMTP id z13-20020a1709063acd00b009327f5c4bb2mr1450002ejd.75.1682068660729;
        Fri, 21 Apr 2023 02:17:40 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id bf18-20020a0564021a5200b00506b88e4f17sm1635389edb.68.2023.04.21.02.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 02:17:40 -0700 (PDT)
Date:   Fri, 21 Apr 2023 12:17:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Simon Horman <horms@kernel.org>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: Always assign be16 value to vlan_proto
Message-ID: <20230421091737.deetnyj6cakrn3mg@skbuf>
References: <20230420-bonding-be-vlan-proto-v1-1-754399f51d01@kernel.org>
 <9836.1682020053@famine>
 <20230420202303.iecl2vnkbdm2qfs7@skbuf>
 <16322.1682025812@famine>
 <ZEI0zpDyJtfogO7s@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEI0zpDyJtfogO7s@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 09:01:34AM +0200, Simon Horman wrote:
> Hi Jay and Vladimir,
> 
> Thanks for your review.
> 
> Firstly, sorry for the distraction about the VLAN_N_VID math.  I agree it
> was incorrect. I had an out by one bug in my thought process which was
> about 0x0fff instead of 0x1000.
> 
> Secondly, sorry for missing the central issue that it is a bit weird
> to use a VID related value as a sentinel for a protocol field.
> I agree it would be best to chose a different value.
> 
> In reference to the list of EtherTypes [1]. I think 0 might be ok,
> but perhaps not ideal as technically it means a value of 0 for the
> IEEE802.3 Length Field (although perhaps it can never mean that in this
> context).
> 
> OTOH, 0xffff, is 'reserved' ([1] references RFC1701 [2]),
> so perhaps it is a good choice.
> 
> In any case, I'm open to suggestions.
> I'll probably hold off until the v6.5 cycle before reposting,
> unless -rc8 appears next week. I'd rather not rush this one
> given that I seem to have already got it wrong once.
> 
> [1] https://www.iana.org/assignments/ieee-802-numbers/ieee-802-numbers.xhtml#ieee-802-numbers-1
> [2] https://www.rfc-editor.org/rfc/rfc1701.html

Any value would work as long as it's not a valid VLAN protocol.
I would #define BOND_VLAN_PROTO_NONE htons(0xffff) and use that.
