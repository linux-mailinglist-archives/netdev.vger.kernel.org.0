Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415A457A108
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237533AbiGSOQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237085AbiGSOQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:16:23 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B3EDFCF;
        Tue, 19 Jul 2022 06:47:13 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id mf4so27295977ejc.3;
        Tue, 19 Jul 2022 06:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ETPYyloEFdyBzQWObajkaBRkKPp4gQ7kPv9PBYe2erc=;
        b=YgbtmXtrMSveGqTKsERJ1+XFFwGK5viciTFGd14IPy1eWnpxCtJ0ZizkJJI34RP0E3
         Wa7l7Sr1HLVkRQ0qCPY1Q3rmvvm1jHbl3Rd0/Z8WrObwCL6XdGHEWHurHlUTAI7jqFHh
         4P66yW5eRdoKb8iQPxLXqYLFPqPbKO1aveL6CPiw1YPuSdDE32GRPzNJbYnXVbql/Jhw
         M/Er7ixdFA0anT3X57DKQ4ODT0zVCTDxTa4b9nSQR2L22OSaHVjP9b9igGnGW9pAHE0D
         /eZ3GErLNjQMXiHqXHCeRdvufrWXB0J2Xx737QQyFvVtDMrBATar3ADeR+UKtQY4qmKf
         +qRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ETPYyloEFdyBzQWObajkaBRkKPp4gQ7kPv9PBYe2erc=;
        b=yDSC3z90PDIhxb7oOgA6ECmex1K+oG4BKS6W4NeS0UzoPANlUSLjo4u3jh8oibnhqF
         rwKhU9gUimYKM/3t8mjBOlkmKBzsKawi3ZK6ZvirTB423E5zbkLXcTVX7AMigPXXDote
         iBFvhbXI6BQLoK8HCaaLBkDHyhNP4ce9Z+vmSyHxlwIoCjBgO+TEvihgsHOGSFrI+maJ
         UWfm2yWK+OP4NixL2pPL7rI5/QBIdXS/cTCzOXLUIfu1sKQzgLd9q/ZV/MJd/mdlD4jn
         aIBeo2ovSXA4LdR9LcrU+bIc5YmJ6MVCnBQLS4MQPXfx0aXEnLmVcRBD1QB8OkpbOsHc
         VCKA==
X-Gm-Message-State: AJIora+2Tc6/gnT80hdEtXLJn9P6QxWuqf/DwHJZLCd3c1hsPOcRW0Pe
        nxlRTBcdF9LBnQYLTp00RiY=
X-Google-Smtp-Source: AGRyM1vjayw4zUofmU9mkBXEG0SQV1Eh/t4ctobL0/nokmQOXLRxaBzoH+p1WkK9POQwfSw3SceF7g==
X-Received: by 2002:a17:907:2887:b0:72b:68ce:2fff with SMTP id em7-20020a170907288700b0072b68ce2fffmr30090257ejc.423.1658238432105;
        Tue, 19 Jul 2022 06:47:12 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id mb17-20020a170906eb1100b006fe9ec4ba9esm6693846ejb.52.2022.07.19.06.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:47:11 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:47:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 15/15] net: dsa: qca8k: drop unnecessary
 exposed function and make them static
Message-ID: <20220719134709.um3rj2ocze65qqej@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-17-ansuelsmth@gmail.com>
 <20220719005726.8739-17-ansuelsmth@gmail.com>
 <20220719132931.p3amcmjsjzefmukq@skbuf>
 <62d6b319.1c69fb81.6be76.d6b1@mx.google.com>
 <20220719134427.qlqm7xp4yyqs2zip@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719134427.qlqm7xp4yyqs2zip@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 04:44:27PM +0300, Vladimir Oltean wrote:
> My request is that you prune the dangling definitions after each patch
> that stops using something exported.

Not "after" each patch, but "as part" of each patch.
