Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931824BEC0D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiBUUqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:46:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbiBUUqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:46:23 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE71B237F1;
        Mon, 21 Feb 2022 12:45:59 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id bq11so10527956edb.2;
        Mon, 21 Feb 2022 12:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=sArEs4i+TWwbLDKHjUB5Hm9AhrhMG2e1+fbvFn1kdjk=;
        b=jy748iPwgDsaD45Y4tJIjkHIjodPrvI7bdKiLJUrQ704l6Ie2gpWZiVGc0Ru7Y9tVw
         zl/9/ZTlb7Wvhvbvqea46fHp+G2eijFBCW1ZRl372kI8h6Mc6ONcG+cqU0zDjiLfB+Aw
         HiiAzFTL9L0/+t+z9Ot2IPtVGK2sCo6+xmfqtOtdpSn6DJI3jTp8soVsuB/XlA+Cp3li
         Gsb2Ms7Rg/fuL+V4HyMhtsdsrWU1BnJRkF/VWsSZECcWtOhUdwPoZ/nx0R2ZHYTPzTL5
         8c2SCrNgo7JVqXCTGgzVPJfKgKJNAFrIkEL1O1rlGxtN595RKJURfLIDe1XcXkeszGCS
         MSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sArEs4i+TWwbLDKHjUB5Hm9AhrhMG2e1+fbvFn1kdjk=;
        b=YyqG6eux5jlh3ISmwetcI3DwkJ0bhL0al9MibmeQyS3nqK2LgfR6G2CCCuuk1cX2bB
         nsLaq2IaOllRcB1/BZ3SewklHslPJsTiPxKmP6WM2ZTVPw9Ir+C9F6RvfiZZ8EPS3MCN
         84kzp4Iy+Kp7BeL4sBZY/GEaNG/5QmA8+RNdjv5AYrkW9VJmhnRevKGC3ieifLJxPnPu
         tIzl91vKFljYFQG/TGKdTlJ/W53buoxkgxfAA6iKK1HmrzqdjDIYBR8WjRM0fULenrQG
         J7DElZXvwImwqTtoPZdXhUUpR2RdmQDY2jWlWCAdSapWo1NcBP6FMGvAN3uzMSkoTHPq
         v2tA==
X-Gm-Message-State: AOAM533qsNSXsG/ENptkKNaPJ5POkotHESKJk6/IeeKfycQAxyptfXCu
        2nlbDjqQU/+DId078R8ZUv8=
X-Google-Smtp-Source: ABdhPJwb4oapY7zioWOh4tvQOJemevk+jli14tRMx/qRS6MqyXHFmkFeYAKai1beCTJxhrU4vkLRzQ==
X-Received: by 2002:aa7:c90c:0:b0:410:a178:319f with SMTP id b12-20020aa7c90c000000b00410a178319fmr23245367edt.451.1645476358454;
        Mon, 21 Feb 2022 12:45:58 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id z12sm2452892edc.80.2022.02.21.12.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 12:45:58 -0800 (PST)
Date:   Mon, 21 Feb 2022 22:45:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: fix panic when removing unoffloaded port
 from bridge
Message-ID: <20220221204556.ymlwsrm4rfllp54y@skbuf>
References: <20220221201931.296500-1-alvin@pqrs.dk>
 <20220221202637.he5hm6fbqhuayisv@skbuf>
 <87ilt8hs5e.fsf@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ilt8hs5e.fsf@bang-olufsen.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 08:38:21PM +0000, Alvin Šipraga wrote:
> >> +	info.bridge = *dp->bridge,
> >
> > By the way, does this patch compile, with the comma and not the
> > semicolon, like that?
> 
> Yikes, sorry about that. Sent a corrected v2 now.
> 
> It does actually compile though.

Yes, I see, I think it probably works too:

	info.bridge = *dp->bridge, dsa_port_bridge_destroy(dp, br);

although I would never write code like that.
