Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D36692A14
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbjBJW12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbjBJW11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:27:27 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294C07F83D;
        Fri, 10 Feb 2023 14:27:26 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id fj20so6144000edb.1;
        Fri, 10 Feb 2023 14:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dI3q7FYVCWjLDBVXxhDsYu3nYOANeG7+NTZx60qVe0o=;
        b=AWK1VR2Ulc1Zz9Y1ZjaVoZ8Ng3GfMjc7oz+4MS8bSMv2TWpy8BOWMc0jc4nfb2d9nE
         MGBzxIyL27cvb72c8dmGClwJpltabtuKsKwtSP1KdzdgoB4Hrn7CJl9XcKw2u/gBnXZB
         1rG9OzSwD/C93qAiug4uj0FMGRq8Nz/DC/f2tZ1nuTwJ7XuxXQRPB7RrTAVCmzRmANWR
         XsJPgMiJjdURpzRflMctATgY35idz4XOVYY8QPF23NzE8CryTKvKD8yod08i2E+pX7fh
         coJZN4UFJ/QYUsWwJP2YcN2EGCYbDYUix2qG87rswku9IefxCNLeJM88R/1PgbTvUBhI
         UqVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dI3q7FYVCWjLDBVXxhDsYu3nYOANeG7+NTZx60qVe0o=;
        b=S4pJyR+M/AEhkmM6pvjXip3rcBP8fmkTNvaE5GS0qqqXBRcqhM+rItuoToP4F1Fxtt
         p44BqRMaf8mdfmRkc2uSsMOzR9/R8QBfKDvHtBlSFNLNQJ4nf/ZpPiVYl6EDUkLWWnw5
         2JfpfN1NpOPjc1mnWvQ1sv48lZI8430W6afW1tknnv722qFXSFJeKhClHQl9PXnuQIYb
         Ka3F196frNtfowVZU5BVgUuMmB4736g4kASZlMvu9YwdzIHGNME51eTrxsOyQlW8cjIn
         tAk6fxU6sAYtBeyDsv3vCwNnusdETS+r7bwWit4Vu7je3zDd5p7BiVMUAhvCQkAMoDaP
         6htg==
X-Gm-Message-State: AO0yUKVzruF8J9lqmnrMydV2BNiEKmdQlIBBhLHim2jrbVbJgUXxcK4Q
        zCV3CpB5VBnA4AtKF3qg7Og=
X-Google-Smtp-Source: AK7set9HbCzSw0JmXpCiMALdNFeTBR42aGnutinBjZFU+0Uy2/jr9VXUSpHmGTXr4a1dGyt3kzBDbg==
X-Received: by 2002:a50:d548:0:b0:4a2:223d:4514 with SMTP id f8-20020a50d548000000b004a2223d4514mr17918752edj.8.1676068044714;
        Fri, 10 Feb 2023 14:27:24 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id w9-20020a50d789000000b004aacee2728dsm2847008edi.19.2023.02.10.14.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 14:27:24 -0800 (PST)
Date:   Sat, 11 Feb 2023 00:27:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard van Schagen <richard@routerhints.com>
Cc:     "arinc9.unal@gmail.com" <arinc9.unal@gmail.com>,
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
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "erkin.bozoglu@xeront.com" <erkin.bozoglu@xeront.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: add support for changing DSA
 master
Message-ID: <20230210222721.3rbszzzjnrctjrnz@skbuf>
References: <20230210172942.13290-1-richard@routerhints.com>
 <20230210172942.13290-1-richard@routerhints.com>
 <20230210185629.gfbaibewnc5u3tgs@skbuf>
 <42C4F87B-520A-4F43-924D-9CDA577B04C7@routerhints.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42C4F87B-520A-4F43-924D-9CDA577B04C7@routerhints.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 09:41:06PM +0000, Richard van Schagen wrote:
> > I believe you need to reject LAG DSA masters.
> 
> Not sure what you mean: how is this different from the change_master in the Felix driver when using 8021q tags?
> But. Can add a check if you prefer. It might be a good idea anyway to be future proof. The MT7531 has support for LAG in hw.

I mean, like Documentation/networking/dsa/configuration.rst says, that the user can attempt
to put the DSA masters in a LAG and create a larger DSA master which is that bonding device.

The difference from the Felix driver is that Felix supports LAG DSA masters and this driver doesn't.

I don't believe there is any other restriction in the code which would prevent a driver which
implements port_change_master() from accepting that as a valid configuration, so it's going to
be the mt7530 driver who acts as the final frontier in this case.

An "if (netif_is_lag_master(master)) return -EOPNOTSUPP" will do. But it would always be good
to check if it's really needed :)
