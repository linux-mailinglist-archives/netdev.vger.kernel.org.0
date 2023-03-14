Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5706BA042
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjCNUBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCNUBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:01:06 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B13109;
        Tue, 14 Mar 2023 13:01:05 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z21so1516306edb.4;
        Tue, 14 Mar 2023 13:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678824064;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mo+SDhsSFJ4lLqNn2P/hTfQBp0VUbQ8+VVpoieb/s+8=;
        b=Dmk9PVUUrpK4CpibmKUVm+yjwzQpmBVrgkLHhObwnmlHRxSETDAIgyeiBF8Jwz6Jv8
         rNY3QEA0gpfH6jf4fuUqWVr71dYT6tH6Ok97zeTKeWKieEPBfeT4h8v9IcUwWZJESQ6G
         fE2JrTK/QpKWWMTGhNrtak+OiAGjNuoJ+maCMmgdX63oFO/UtzMSNgg/JVFvdYqKa903
         G6QTycxkBIM+11AxWKgNc67yJTnT+MMrIcKKgRToHEpGNnV+xihpT7uPA4/5uES0iWAR
         EmVqSxofIS5HhuUZXC321MoCTnTTKUT0C6V+rT8mWbUkmatlz6xNxHBt8OHKx6nAV7W2
         E1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678824064;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mo+SDhsSFJ4lLqNn2P/hTfQBp0VUbQ8+VVpoieb/s+8=;
        b=k3hgFNvVvv1DZzhIyYbWqKjtn8imiru0hS2uG95Q/pEPolkGvuwx1QeP+61bkdBrt9
         zcezDpxX0rWSQpMo7hF4P3YEQDcGKPtPnz/M6+9PixCVZShuJpYbFsywcCE8VyMNcD2F
         7PrSg4lDs901MAzoFPoQa+Zpv3x2GN8xeV9tmwdoMzgtHS9u5iwUnM2C3MUXZ/YjWASQ
         oWfbXo6BAMG/aWP+sm8+33jjhIyAxf9DyWxOOsU8sqVQMt+y3aFre5z6d8w6PQ6YkuHH
         AFxkSzmsbb4FaPCGXh4k2WIDl9QP1wz64VIhE6TJpvMCpgJ30cpSstYfxV8HBci3NzZz
         mRHw==
X-Gm-Message-State: AO0yUKXLXW3dbP2FXsKESqgoERQm85y8yoIbiyKPcJ641i+rn1eEuRLc
        cDmzLZQPt2bpJAuNehGXBnQ=
X-Google-Smtp-Source: AK7set+dRdMiLAYdi/+z5xWQobUWvTMvL7LrWD+ekfG1MgoKQUhLFFOngIqQ2+9+SaKKI1ZZaliwBQ==
X-Received: by 2002:a17:907:a0e:b0:895:58be:957 with SMTP id bb14-20020a1709070a0e00b0089558be0957mr4885678ejc.2.1678824063648;
        Tue, 14 Mar 2023 13:01:03 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id bg23-20020a170906a05700b008d398a4e687sm1518906ejb.158.2023.03.14.13.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:01:03 -0700 (PDT)
Date:   Tue, 14 Mar 2023 22:01:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't dispose of Global2 IRQ
 mappings from mdiobus code
Message-ID: <20230314200100.7r2pmj3pb4aew7gp@skbuf>
References: <20230314182659.63686-1-klaus.kudielka@gmail.com>
 <20230314182659.63686-2-klaus.kudielka@gmail.com>
 <ed91b3db532bfe7131635990acddd82d0a276640.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed91b3db532bfe7131635990acddd82d0a276640.camel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 08:35:28PM +0100, Klaus Kudielka wrote:
> This should have been [PATCH net-next v3 1/4] in the series
> "net: dsa: mv88e6xxx: accelerate C45 scan".
> 
> Lore *does* recognize it as part of the series, put patchwork doesn't.
> Sorry for the mistake, and please advise if I should resubmit a v4
> series.

I'm a bit puzzled as to how you managed to get just this one patch to
have a different subject-prefix from the others?
