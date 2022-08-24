Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061B559FA3E
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbiHXMqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234876AbiHXMqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:46:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF18790C7E;
        Wed, 24 Aug 2022 05:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uSxtp6cCO/JPJLp/Y5uU09OcFls/853lMuOjjJI3vmg=; b=yBwxcpvlq6AVp6sl0roNiulO7G
        9zTsPRWFSQ+hKKHxduJWNf8atR40bQyrZTzzrCvt6Qye61ELVuCs0qkUyrZzt56GKISn8w17anntT
        a+w42OOTECaukHBlbqttIJOHfb31EAhQBOeGlj3tLbG4l9PdfauvpVUMldWG5tTU2Nzg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQpmC-00ERhp-AT; Wed, 24 Aug 2022 14:46:32 +0200
Date:   Wed, 24 Aug 2022 14:46:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     Dmitry Safonov <dima@arista.com>, David Ahern <dsahern@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 00/31] net/tcp: Add TCP-AO support
Message-ID: <YwYdqEFQuQjXxATb@lunn.ch>
References: <20220818170005.747015-1-dima@arista.com>
 <fc05893d-7733-1426-3b12-7ba60ef2698f@gmail.com>
 <a83e24c9-ab25-6ca0-8b81-268f92791ae5@kernel.org>
 <8097c38e-e88e-66ad-74d3-2f4a9e3734f4@arista.com>
 <7ad5a9be-4ee9-bab2-4a70-b0f661f91beb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ad5a9be-4ee9-bab2-4a70-b0f661f91beb@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think it would make sense to push key validity times and the key selection
> policy entirely in the kernel so that it can handle key rotation/expiration
> by itself. This way userspace only has to configure the keys and doesn't
> have to touch established connections at all.

I know nothing aobut TCP-AO, nor much about kTLS. But doesn't kTLS
have the same issue? Is there anything which can be learnt from kTLS?
Maybe the same mechanisms can be used? No point inventing something
new if you can copy/refactor working code?

> My series has a "flags" field on the key struct where it can filter by IP,
> prefix, ifindex and so on. It would be possible to add additional flags for
> making the key only valid between certain times (by wall time).

What out for wall clock time, it jumps around in funny ways. Plus the
kernel has no idea what time zone the wall the wall clock is mounted
on is in.

    Andrew
