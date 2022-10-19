Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64194604910
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbiJSOU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiJSOUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:20:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA67C102DF0
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 07:04:03 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b12so25425109edd.6
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 07:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HflUofiRuFxm0c51yDKz6Wh6uwbqc6LfNuv+gdMs9dM=;
        b=leZyiTKRFs9uygWxlw0nST91b1dbgK/k+FRGdZsnvWW2LptjSxbgSzw0wrcj1PsIc8
         NfYmkColyHu08aEf4QPwASAgsLoo1miF/XUyowgsAc4M6jbGHth320lMW+4vmmkifGuu
         5gY4pLlY8PUW3prDioJkrIgorDfV8LAlwH8hHUCVjZd93z3lplW2fsmOBE+7W1K4eo5u
         XjMyA/uLxrOWUl43JlggGQIGqsEbGgbxuyL2K++/z0P30VVjYdP8ZQye3bzsxE1fSlqV
         PEZDGMKTJmtuDjZOQLmnNkFevmly2BpoSmzZ78AzIVDsTIqbX5J8SZzpVApYt520CAku
         RS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HflUofiRuFxm0c51yDKz6Wh6uwbqc6LfNuv+gdMs9dM=;
        b=k4LixABcGT79cHIz4Q+iWzIbCxk9SykWIKiZJQ04gwzImOACnrIp2fPSpSsSG5WZqU
         XCR+6IwfStGoloxVgffUVQRhRGtkUX+Kdt7btWT1tbEZgS0QNzFy9w2bSUVit7RgPa8/
         T8LMMQvNvBolx0inczhvM3O8OC2G9EmLrBm0Q8Sifk6mUqCQctxkbi8O75iUGXwvuRIJ
         gAol101ARvBGiYymgW+bUqB4wlbD8H5ifS4U1ASuOQ/gb+G1VpMhHaqMJPoDODTVwCsF
         94wzo8QADkF3po5zk4Uv3dVkM162lDjVEp8lZcMODyKzV1lho0KoZBqoRujOFi83SIpp
         InZA==
X-Gm-Message-State: ACrzQf3OmI00KXcaMBXVi5MVi782oPGRZGP8yb6FunoMcJfgX9siQhpD
        a0OdXTlcCzVB2azTK7jItnM=
X-Google-Smtp-Source: AMsMyM5XSW6ybO2Jpej1iPH2exf3urM+MhYcS22mpqCgscivrpAgPEcL+uOFoJLdNqYqLyddiULdUw==
X-Received: by 2002:a05:6402:2751:b0:443:d90a:43d4 with SMTP id z17-20020a056402275100b00443d90a43d4mr7760796edd.368.1666188163296;
        Wed, 19 Oct 2022 07:02:43 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id k11-20020a17090632cb00b0073d83f80b05sm9055001ejk.94.2022.10.19.07.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 07:02:41 -0700 (PDT)
Date:   Wed, 19 Oct 2022 17:02:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net] net: ftmac100: support frames with DSA tag
Message-ID: <20221019140239.hboqna4lugwmnwph@skbuf>
References: <20221013155724.2911050-1-saproj@gmail.com>
 <20221017155536.hfetulaedgmvjoc5@skbuf>
 <CABikg9ziSUJ5_DWro_TgCDMRYmgBfQNaEjKrCFQjaoUhkwRZOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9ziSUJ5_DWro_TgCDMRYmgBfQNaEjKrCFQjaoUhkwRZOg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 04:57:05PM +0300, Sergei Antonov wrote:
> > Which VLAN tag do you mean? Earlier you mentioned a tail tag as can be
> > seen and parsed by net/dsa/tag_trailer.c. Don't conflate the two, one
> > has nothing to do with the other.
> 
> I used print_hex_dump_bytes() in the ftmac100 driver to see what is
> inside the received packet. Here is how the 1518 byte long packet
> looks:
> 6 bytes - dst MAC
> 6 bytes - src MAC
> 4 bytes - 08 00 45 10
> 2 bytes - 0x5dc - data length (1500)
> 1500 bytes - data
> 
> I am not sure what is the proper name for these 08 00 45 10 bytes.
> Tell me the correct name to use in the next version of the patch :).

Humm, how about IPv4 EtherType (08 00) plus the first 2 bytes from the
IPv4 header? 802.1Q EtherType is 0x8100.
