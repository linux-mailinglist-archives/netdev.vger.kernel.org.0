Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE2B647215
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiLHOoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiLHOnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:43:55 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F12A9FDB;
        Thu,  8 Dec 2022 06:43:52 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id m19so2083783edj.8;
        Thu, 08 Dec 2022 06:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hxx3hHyejbLeDuFDwXBpuhfnpA1JIN/KUaBCLSEkMeA=;
        b=HTKA5wG6DmDi7F08nntDMIly7BQqtuJfK/I0e+nHC7DR1K7Nrte8VBhNTDJTrgBJjH
         0nhq4VV1+LWJ6Rm4RCI6qFVS5WoezWedUC8NYDZJoHAHo+HDOa+1URCh2FfBrVVxW2r6
         scaQ4aT5Wn325/Np9RB1LsYFH5KztRNULrlHOQoS94O0rwBopgUjBBKh51Io6VmZ2Wpy
         ZV1o6PiqLc0kxvn5eo7e3ULcUk11Ul4cpKyNpH4WC0UukSg7heeEHay/R5ulgGSv0A12
         pkfdQAwRhMysAYcWMHbhqIJiwZOqSrbyLJuG8kGUXv7OUJOAGVF/lTJBm4tDFtrPgux1
         cA+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hxx3hHyejbLeDuFDwXBpuhfnpA1JIN/KUaBCLSEkMeA=;
        b=KaSLwXAzn9+tvdjVh+hO92ZkmIS5wh1g03h14lCc0l21+2bTfJybxFn1Ru94/RxSLC
         NhxPD7vUnMZgMbBZrtR+7xL7xwGMkkV+vQaNBmXD0/dnN6SJEFFUd3vGNtkmd/IW+3KW
         ikQn36+oTnqy3UQECg448a2TuAUStAdajAHkOsQ5fLpqeOQcyz5UvHN/0sZfw0E+NOmO
         Dqk2CpAnPdLaAZOMwHUekon1WcOS0YJcCnTX52FcqIBdlNOB8PadkiIn1tCXACJh5xPC
         nQs6i/SCHdwH6mZGQ0MWdu7H1qFYaOnthWuSOAe/LApHIEnI+f3PGQUBbcUV8a/kvPCu
         EMxQ==
X-Gm-Message-State: ANoB5pn3WeesYKQwAa67pUEs0FymIMdIztmylphN4bUHtSSLHmQu4esx
        VJhWvgDFuRTnEE7ZdmS7Gec=
X-Google-Smtp-Source: AA0mqf4cgx2tq6G2SbUIWAFWFEhoZDuKQ2An308eQP7dSymXMr1Xp19aqJMhQxWkq46+lp4Wuw5OJg==
X-Received: by 2002:a05:6402:c2:b0:468:9bc4:1c7 with SMTP id i2-20020a05640200c200b004689bc401c7mr2437790edu.38.1670510631079;
        Thu, 08 Dec 2022 06:43:51 -0800 (PST)
Received: from skbuf ([188.26.185.87])
        by smtp.gmail.com with ESMTPSA id r8-20020a056402018800b0046cd3ba1336sm3469312edv.78.2022.12.08.06.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 06:43:50 -0800 (PST)
Date:   Thu, 8 Dec 2022 16:43:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221208144348.lypst4vltnczswhm@skbuf>
References: <20221205185908.217520-1-netdev@kapio-technology.com>
 <20221205185908.217520-4-netdev@kapio-technology.com>
 <Y487T+pUl7QFeL60@shredder>
 <580f6bd5ee7df0c8f0c7623a5b213d8f@kapio-technology.com>
 <20221207202935.eil7swy4osu65qlb@skbuf>
 <1b0d42df6b3f2f17f77cfb45cf8339da@kapio-technology.com>
 <20221208133524.uiqt3vwecrketc5y@skbuf>
 <c9dc3682dd9e4c2a9d81a7df0f3f9124@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9dc3682dd9e4c2a9d81a7df0f3f9124@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 03:41:24PM +0100, netdev@kapio-technology.com wrote:
> What else conclusion than it is the ATU op that fails?

I don't have any more time than to say "read the rest of my email", sorry.
