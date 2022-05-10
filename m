Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF0A5221C9
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347702AbiEJQ4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347708AbiEJQ4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:56:35 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EBB27D004;
        Tue, 10 May 2022 09:52:38 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gh6so34243176ejb.0;
        Tue, 10 May 2022 09:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9xQwPtQrBfYT0IuemJx5F5so+crXxKK0HLvlBxjKC0s=;
        b=Okxteym8CaF/RHkBfO6Cp/WIgRcGbMBTJWIdNmMU19vXsWaAS8Z9L5ircpFp6VDy1S
         u10DkF0PLDeKl0gv5ijUtxkdcF6bG192cWFecvN8MBUJG7Gf6mTiy5C5HhKL4yKu+y7C
         fuY6AdEp9N1XEYZGCa4lJVnIb7TNode2Iu5C1xlRmg0nS7mbu3qxTeimBa81215XyjFo
         QElNUXkGIvL4YkC8lKNY8VCKfeTD0cAqUcjHZxtS/9ZzoiyeCWdvf6MDRaohKXFJocJ4
         hgsSm0nftb8Eh1JEkwsZlH1sB4qIgwF0i7eJAzKg0c4C7PNz0ybEYElL1dvCdzxHrOvq
         D4Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9xQwPtQrBfYT0IuemJx5F5so+crXxKK0HLvlBxjKC0s=;
        b=rJtN0WqRo/Rj5T1Nka5GFZ4sNedW6en3vj1uqMFa+Lqf23/PelyMjINSkfzhwE589Y
         FZKgmeL8kFjSHZmgw9tZO5r/fjEaCdvOYuT9hOLv1jaBKqb/FyNB2zfgehxCdsxE1apj
         MFXbTBBkzRcr2vGz9nWxfTgxwOn/E4gQEoAhg1tPj++X6WQVGp5Rl0/zOFgriRC8AAMD
         7sgt6RbhEzRtFY9KTY+e0aS+dlICtbkuHLDDet3uQh3iD+KCxRxCpW2JWCLH6Zl+vYqe
         vyb6uebQdYFoFHVoCsYhtIdPai7QIGiEHHPm2c6a7v8950Ufavy/EIU95zK7lXAODuDm
         hI7A==
X-Gm-Message-State: AOAM533/8dSDltKmROr4cP52PEOXXsXkKJHrCHSQ20Xq5bu8cJUxPc9i
        hn3SlTTwimo4ZwYw+AaMIfA=
X-Google-Smtp-Source: ABdhPJxZw7qCY5xAugBz1OmSZd7IfwPIm4rayHyJ2D2Dl9oe0PTmAbGz9w3tCVGoNe698i+vy9lkAw==
X-Received: by 2002:a17:907:d88:b0:6f5:1321:37ed with SMTP id go8-20020a1709070d8800b006f5132137edmr20817558ejc.67.1652201556379;
        Tue, 10 May 2022 09:52:36 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id a21-20020a170906685500b006f3ef214dffsm6221861ejs.101.2022.05.10.09.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 09:52:35 -0700 (PDT)
Date:   Tue, 10 May 2022 19:52:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
Message-ID: <20220510165233.yahsznxxb5yq6rai@skbuf>
References: <20220510094014.68440-1-nbd@nbd.name>
 <20220510123724.i2xqepc56z4eouh2@skbuf>
 <5959946d-1d34-49b9-1abe-9f9299cc194e@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5959946d-1d34-49b9-1abe-9f9299cc194e@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 04:52:16PM +0200, Felix Fietkau wrote:
> 
> On 10.05.22 14:37, Vladimir Oltean wrote:
> > On Tue, May 10, 2022 at 11:40:13AM +0200, Felix Fietkau wrote:
> > > Padding for transmitted packets needs to account for the special tag.
> > > With not enough padding, garbage bytes are inserted by the switch at the
> > > end of small packets.
> > 
> > I don't think padding bytes are guaranteed to be zeroes. Aren't they
> > discarded? What is the issue?
> With the broken padding, ARP requests are silently discarded on the receiver
> side in my test. Adding the padding explicitly fixes the issue.
> 
> - Felix

Ok, I'm not going to complain too much about the patch, but I'm still
curious where are the so-called "broken" packets discarded.
I think the receiving MAC should be passing up to software a buffer
without the extra padding beyond the L2 payload length (at least that's
the behavior I'm familiar with).
