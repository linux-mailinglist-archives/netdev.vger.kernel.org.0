Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4841694731
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjBMNjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjBMNjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:39:06 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D7F7EDE;
        Mon, 13 Feb 2023 05:39:05 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id n10so4996859ejc.4;
        Mon, 13 Feb 2023 05:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Ekv3irQHY3cF7rcNIcy6sRi0xjN5QIEztPZj/u+DOk=;
        b=mY8CBFuL2YWSzOj6vbdf0Nb/rBR7REyNAGVJgZA2xfwUAAL57EVBfewISvp2Q6+1yk
         spdIB5bcQenbumDWOws5hVDWKTV6mo+YiVBcA5S3H/uW7HXUyJYXh5j99HxbL6X9bvT3
         Y2/fOPlpzC60HZzs/sCzXWWj+IKbP5AcjjGk4gn6jMDYDeBnMyb0dFLxvbkfgBD+UQfX
         Kt43ByqNUDIkNs9qeV++CWlXBJxswPZCqwvltABF2gXaH7WwOuQuy5nCT4C8KUIDm4sv
         8GKQYOZlau+HBvIiHbQorXVfBIdh32eJw/uN2dHBzNrORheVl6JyFN76QZa9Dcdt/Gid
         XoOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Ekv3irQHY3cF7rcNIcy6sRi0xjN5QIEztPZj/u+DOk=;
        b=eIJUvaZXJr5xmyiyaDctC5QqdGSiGSktDM+h3IUbKvdZWiyL34Fz8hqYMWeoxeL0ph
         sKKqX5CvPDm2GHql00mvn0nKLRcJy53QGUH9ULqCBacogZuWgYHDPzUY6FpxDxdRsd+u
         XttQa3uhfp65sJ7TUzjprowhuwmpo7WTDPBLyqLa9SOMzxrJJg7PzhBjzncDhybPvhOh
         bGFv/wwUwHvCJf0dETETK3FEsC0ql50ZtpuS2ijkrmYskmLKRhWPePx2Ks+sIljTCSQm
         +XVmasuLrGt0ZzPYPcY0cwxo0DO8eRa7bQ5CxXsJ2SFQhhtGpm0Fa3zviHicvzBtQ+JN
         xUdw==
X-Gm-Message-State: AO0yUKXFbEXrMPrNsgI+0E7o5Mu8hpZMJ9UxrHaWb9rDLQDCjdY4P24G
        XOgy8ygZqjX/Undg69969Z0=
X-Google-Smtp-Source: AK7set+LyPB5jPI4bx2jxEKNBDU92BBUxt4f5nkM8Ny0afwgXg3RuyGHpohyNlabsuH9qQwKrFmy3Q==
X-Received: by 2002:a17:906:1252:b0:889:7781:f62e with SMTP id u18-20020a170906125200b008897781f62emr25321869eja.22.1676295543952;
        Mon, 13 Feb 2023 05:39:03 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id i10-20020a1709063c4a00b008af21450420sm6849360ejg.85.2023.02.13.05.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 05:39:03 -0800 (PST)
Date:   Mon, 13 Feb 2023 15:39:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Richard van Schagen <richard@routerhints.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Arinc Unal <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] Fix setting up CPU and User ports to be in the correct
 mode during setup and when toggling vlan_filtering on a bridge port.
Message-ID: <20230213133901.lh47a6rlv7dseenj@skbuf>
References: <20230212213949.672443-1-richard@routerhints.com>
 <Y+njic6vxAlGp72l@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+njic6vxAlGp72l@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 09:15:21AM +0200, Leon Romanovsky wrote:
> On Sun, Feb 12, 2023 at 10:39:49PM +0100, Richard van Schagen wrote:
> > ---
> >  drivers/net/dsa/mt7530.c | 124 ++++++++++++++-------------------------
> >  1 file changed, 43 insertions(+), 81 deletions(-)
> 
> Please read Documentation/process/submitting-patches.rst
> 
> Thanks

Agree. I'm not even looking at this patch until it has a properly
structured commit description detailing what is the reason for the
change, and the change itself.
