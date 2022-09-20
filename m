Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D165BE342
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiITKb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiITKbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:31:21 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0D16F54B
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 03:31:20 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u9so5054748ejy.5
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 03:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=zoggemZuapkdcSUqGdUIGUwaS0xRE/VeZBVvnX0k3xQ=;
        b=acuHwTBkPY+1lHcqkQ88/voF6viSLGjLx7HTo1OvfwMkchwlQlgUokLGgXBgq0RUUa
         D7N4/0uvRuy2ng71uEz41dqh1NMhLuUvPzVmiEYCYTGiL+3mEZj2BxodovI4ogFvph2G
         UtcuDncnZ/WAuwiA5Nldeuu+5szEd1GgcLN0UCHEDy3idkUUFrxT6q/RvgMuC1hM+14N
         nq5vpQMo2uPLn9v1C9n4SoW0Dg2nCgCiTHXZT9tqRZz4Sguqb9knG8NlRGmP1fTvZB2i
         KU9GY5Qw/XQg02aJgGP4xzbLyYxs9IjY7Q1OJ/JVPl74oc8r8d11q6At+32DRgJXcHHb
         VCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=zoggemZuapkdcSUqGdUIGUwaS0xRE/VeZBVvnX0k3xQ=;
        b=FzODuKlivw8uvM2V9fcN3EdBPoHKVm+IBBMAhLUu79DQJ6oRcxAgjGVq0fGf2SGo93
         4hkt4Ar/kNL5Fhbs80tzQp+nlSzm2hxRm3fYfK/bbq/dq8fj69RMj4eL4r6d/H2LZIWi
         A6fUCYFKvTaQ1YbW2vXt1eMO14UYXn5GMJuZ7y7n51brpTK265lnSKvE508ZQqR9lcE0
         ZJOx4bS7aSR9AsbzxFRZSP68QyJWUGtbPZBCojEB8lUcOARQloX7Mg72TyzCWnHbq70m
         EXEj76tqCuqd0cvdtNUJomOZ+BXQbo5sdUHfnTCLuXYC3zCwOkmuzKdVlSfhi3ITbs6n
         OFQg==
X-Gm-Message-State: ACrzQf1wRJbaX1Ckv3OMaftIa3RUVG0Ry/WGbQaEiNSe1DNa1zLd1X/8
        H4hB28/oy9sVnj/Vej3CDRg=
X-Google-Smtp-Source: AMsMyM5fccii5pfpOAiDgn9ETkCv5GXD6QQMlTp+c4FG3dLBhoRudhFgNzZvy7Ljh4b5a++nab6ZJQ==
X-Received: by 2002:a17:907:86ac:b0:780:df48:6a74 with SMTP id qa44-20020a17090786ac00b00780df486a74mr11420541ejc.656.1663669878472;
        Tue, 20 Sep 2022 03:31:18 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7dbcd000000b004548dfb895asm226318edt.34.2022.09.20.03.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 03:31:17 -0700 (PDT)
Date:   Tue, 20 Sep 2022 13:31:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 3/7] net: dsa: Introduce dsa tagger data
 operation.
Message-ID: <20220920103115.xoddfehdhmztr6cq@skbuf>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-4-mattias.forsblad@gmail.com>
 <20220919110847.744712-4-mattias.forsblad@gmail.com>
 <20220919220056.dactchsdzhcb5sev@skbuf>
 <3f29e40e-1a3b-8580-3fbd-6fba8fc02f1f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f29e40e-1a3b-8580-3fbd-6fba8fc02f1f@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 08:41:30AM +0200, Mattias Forsblad wrote:
> > Can you please also parse the sequence number here, so the
> > decode_frame2reg() data consumer doesn't have to concern itself with the
> > dsa_header at all?
> 
> The sequence number is in the chip structure which isn't available here.
> Should we really access that here in the dsa layer?

I'm talking about this sequence number:

mv88e6xxx_decode_frame2reg_handler:

	/* Decode Frame2Reg DSA portion */
	dsa_header = skb->data - 2;

	seqno = dsa_header[3];

I'm saying, if you get the seqno in net/dsa/tag_dsa.c and pass it as
argument to mv88e6xxx_decode_frame2reg_handler(), then you should no
longer have a reason to look at the dsa_header from drivers/net/dsa/mv88e6xxx/.
