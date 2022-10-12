Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8135FC136
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 09:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJLHYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 03:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJLHYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 03:24:17 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88616A8CEE;
        Wed, 12 Oct 2022 00:24:16 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ot12so36174306ejb.1;
        Wed, 12 Oct 2022 00:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n7JewGH9iWfKR3wctVAGhZTshcDuU8P5RA2jbmo77HU=;
        b=g/ss9La9lkUgIRYVEPsADAgaZeSmaz9kOBWnnNCoNQbA64ax4NbPhUxeJG96gPgY8Q
         SbHwUxqg2VAS38Ji+x6ZKpBrOVYB0wTWouXWFI0CXrw25LYICxWio+Lj/TUJdVtLHVeo
         sHQibOXJgj5HxblBbmVe4VSJU1xTb3s4LFYipNFexwL7kHgxiWwMxM9NgkYYErJAbqW3
         ld0nEUrSjyxKFiWj9csATMZvZpwoH4u1MVEbrz4lfP8EJYJjJ10ILvGG2HkYYyrAyPbc
         lt5LLBS9jHTR919Zg3OF2O0U0js0VgFlqNMTHMpK+ljr8nzlABk0YS9wFLGELj6gbXnG
         6dLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7JewGH9iWfKR3wctVAGhZTshcDuU8P5RA2jbmo77HU=;
        b=z5jMOVNXE6W9a/KveS7IBfnH7Qn8lGhxW1RldpVrUo1TPo6U2PUFJNvUEsRY5AyBcH
         R762fXFD46autX+zmRc+4JF7VfHtmJTTzxB4XAuSSy4H6JLi0D3qAyZKpJcHBStDVcS7
         6li2ruUSyzxlSc981d56N9QsrzV8etkoyiBEzLH96YNv8q9hqZhqA6SotwV9ihWmwbpL
         s7Dhd5R7HJIeE+j898rygq9RPSse46oVvntlAopAg+9BOp0OLAC9/eWsThq/MH+dDHGu
         d0vj/SDn3lmSA5o+w04V8LCnYT5dyiIZzXSDPC3PH+MfGS+opM4xG+jB8Ve2Km0UMIaw
         yM9g==
X-Gm-Message-State: ACrzQf0QlLs6q6qtM4b1cQ206dW/lIXWVv5cFEEXLW0s96Yil5M18EEn
        OGOww7Gsm8TLJw6WPouwNOt0y70E1iWqSQ==
X-Google-Smtp-Source: AMsMyM4HyC97hb3AEK//YvvdhMfV8NwwbmBo9V/rvlEdLv9pd0KN8gpYavkIIPPPcOPnGxGEnq/6zw==
X-Received: by 2002:a17:907:2d8b:b0:781:c864:fffd with SMTP id gt11-20020a1709072d8b00b00781c864fffdmr20791881ejc.681.1665559454881;
        Wed, 12 Oct 2022 00:24:14 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id g1-20020a170906348100b0078d2a2ca930sm754046ejb.85.2022.10.12.00.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 00:24:14 -0700 (PDT)
Date:   Wed, 12 Oct 2022 10:24:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix inband mgmt for big-endian
 systems
Message-ID: <20221012072411.dk7dynbttnaozyrl@skbuf>
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
 <Y0RqDd/P3XkrSzc3@lunn.ch>
 <63446da5.050a0220.92e81.d3fb@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63446da5.050a0220.92e81.d3fb@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 02:44:46PM +0200, Christian Marangi wrote:
> On Mon, Oct 10, 2022 at 08:53:01PM +0200, Andrew Lunn wrote:
> > >  /* Special struct emulating a Ethernet header */
> > >  struct qca_mgmt_ethhdr {
> > > -	u32 command;		/* command bit 31:0 */
> > > -	u32 seq;		/* seq 63:32 */
> > > -	u32 mdio_data;		/* first 4byte mdio */
> > > +	__le32 command;		/* command bit 31:0 */
> > > +	__le32 seq;		/* seq 63:32 */
> > > +	__le32 mdio_data;		/* first 4byte mdio */
> > >  	__be16 hdr;		/* qca hdr */
> > >  } __packed;
> > 
> > It looks odd that hdr is BE while the rest are LE. Did you check this?
> > 
> >    Andrew
> 
> Yes we did many test to analyze this and I just checked with some
> tcpdump that the hdr is BE everytime. If you want I can provide you some
> tcpdump from 2 different systems.
> 
> Anyway it looks like this family switch treats the hdr in a standard way
> with the network byte order and for anything else stick to LE.
> 
> Also as a side note the tagger worked correctly before the mgmt feature
> on BE systems and also works correctly now... just any command is slow
> as the mgmt system has to timeout and fallback to legacy mdio.

Could you provide a tcpdump?
