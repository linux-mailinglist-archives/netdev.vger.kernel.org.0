Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50B1604D74
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 18:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiJSQbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 12:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJSQbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 12:31:49 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BCD16A4D8
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:31:49 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b12so26085594edd.6
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c8oqfdD/JjXEX7+EeuXuxWs3C2q22ek0lM4E2caTBis=;
        b=g+aFZaTtDyYHc/3mEIgzTkeUKEFd8eLlqcVfu0pTz5RtRh+4IeveKydwcQ6ELUN704
         9aeklJSMVhNtFlX4XX9a7kU34/hi0WDj2JDLjgG3h31ehZnhpiX72IOMNYCTVqDD3IjE
         p/+INtccR902D0DThb7Sg1wKDGZxFuLArlb5R3NN+L+Jrh+8O32Ku3rk9jDqG0YszpJH
         Oh039cjgrRCqMbOPGuyj7t6jHHplCyAKnyQ2sRyogKDtPi9D7ZkusuCcRyKnhr2zaiwh
         vynG1i+NEOSSvtLEPg2Z2N0YmX5YbtjXAfIl7PiSornK+rnsUVrtieyUJFc/AdOhptuB
         DeOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8oqfdD/JjXEX7+EeuXuxWs3C2q22ek0lM4E2caTBis=;
        b=W3oKW92fZ0oOvQHfk/TnQqSkp1/5mYK4OOmLMdW1Q5kww1PEMx/t/AVOOV9J2F1r5a
         oKOAMRg61S/MGkB617gVgeFQ8mgDgvYnUpFUqr8N/gbLS/ilp4rT6g0kT5R3K0SGMnov
         aE1IglJpdKWnI5gYUxjZ5PZGjmNMvOjWAZ2dU4x4rtZazsn4s2yN+GypJ2kyn3BnJ6FK
         oh/FquXSiXZtAwELrdx8JuLL1lhW7uvmktjxTpgnGLE2Z0L2dbcquY8+CIS0LmDzYixg
         PZ/ZG7jAbXnZ0pPyyA2D56JERG2ZLECO+f6i2C2Qmj13fi0Ux9CI6OmxODyKkpra9KTS
         x9JQ==
X-Gm-Message-State: ACrzQf2LAbQ9XzWCwpKS+sMZuEwlhDwKQ5wcvwfiavZ9RjAKz+qb5o5E
        5vGnec8/1yA0klwGX1e18XKnOXCUkE0feQ==
X-Google-Smtp-Source: AMsMyM6FYXeHEbIWSUqawTM6wHWa/2bHUC6zmW0rXN/F0XA6zpMkCndqXGgREYdIBxxkoaCuHmxc/A==
X-Received: by 2002:a05:6402:ca:b0:45c:dbdd:8143 with SMTP id i10-20020a05640200ca00b0045cdbdd8143mr8275333edu.213.1666197107365;
        Wed, 19 Oct 2022 09:31:47 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id v25-20020a17090651d900b0078da24ea9c7sm9208608ejk.17.2022.10.19.09.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 09:31:46 -0700 (PDT)
Date:   Wed, 19 Oct 2022 19:31:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net] net: ftmac100: support frames with DSA tag
Message-ID: <20221019163144.k723gzjnbq6ith4j@skbuf>
References: <20221013155724.2911050-1-saproj@gmail.com>
 <20221017155536.hfetulaedgmvjoc5@skbuf>
 <CABikg9zmmSysguNTXmM7cG8KqKBoEKshLKUCb5o_kpNqFm2KRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9zmmSysguNTXmM7cG8KqKBoEKshLKUCb5o_kpNqFm2KRA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 07:19:11PM +0300, Sergei Antonov wrote:
> On Mon, 17 Oct 2022 at 18:55, Vladimir Oltean <olteanv@gmail.com> wrote:
> > 6. Actually implement the ndo_change_mtu() for this driver, and even though you
> >    don't make any hardware change based on the precise value, you could do one
> >    important thing. Depending on whether the dev->mtu is <= 1500 or not, you could
> >    set or unset the FTL bit, and this could allow for less CPU cycles spent
> >    dropping S/G frames when the MTU of the interface is standard 1500.
> 
> Can I do the mtu>1500 check and set FTL in ndo_open() (which is called
> after ndo_change_mtu())?

Through which code path is ndo_open called after ndo_change_mtu()?
To my knowledge they are independent. The MTU can be changed even on an
interface which is up, and the driver needs to handle this.

> I am submitting a v4 of the patch, and your feedback to it would be
> helpful.

Well, I see you posted v4 within 2 minutes of requesting further
feedback....

> I got rid of all mentions of DSA tagging there, so patch description
> and a code comment are new. Thanks for clearing things up regarding
> EtherType 0800.

I didn't ask to get rid of all mentions of DSA tagging. On the contrary,
it is relevant to mention that DSA is the reason you are making these
changes. The changes would have looked quite different if you needed to
increase the MTU for other reasons (also see below).

> > With these changes, you would leave the ftmac100 driver in a more civilized
> > state, you wouldn't need to implement S/G RX unless you wanted to, and
> > as a side effect, it would also operate well as a DSA master.
> 
> What does S/G stand for?

S/G means scatter/gather, or in other words, the ability to create an
skb from multiple RX buffer descriptors. Since each BD is limited to 2K,
this limits the size of the skb also to 2K, whereas a scatter/gather skb
is essentially unlimited in size regardless of the length of individual
buffers.

What I was saying is that for DSA on mv88e6060 (which doesn't support
jumbo frames AFAIK) you're essentially still fine within the confines of
single buffer skb, you just need to allow MTU values just a little bit
higher than 1500, but not as high as, say, 9k, which would require more
effort/rework.
