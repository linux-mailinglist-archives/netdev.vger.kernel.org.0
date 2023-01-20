Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A1067522B
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjATKPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjATKPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:15:16 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DBA5BB9
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:15:15 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id b5so4442094wrn.0
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=ril1swV1R+hDAF9LknluyICUN2es7YWX6Imr0pDgjpo=;
        b=C+1n6li9rkMtthIDJ0i1JnxsRwnOJGLXYU76WnO2SPd97meX7h9jvhG9ONC4AWMyLE
         UiZmmg5ertTzKELe7dnQfXg6sLOjm4ocRy717sAEs8LTs6Byw5QKAa4A26TloL2Vrvar
         i8LUgRh87HnqPfbRUS7lS3Z8RkJ2dCuHzuNGTe67hNb1BoPzP0B5rj9OzPT3syo0iDmu
         yk7o8NsZtWYraw6cZGBWprGYcwADC3hvXl9//C4LoFRt84bpgrjEUFKBjknTolSS/S7f
         9oe/C0K2/322qre0cTQ39x4z76qgWd9UjiGeGrTVy0MioAeawQe/f//FO47uLdEOm4+Y
         1Mhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ril1swV1R+hDAF9LknluyICUN2es7YWX6Imr0pDgjpo=;
        b=jcKVGf3NJdylPjQzFyiEkWMoU9ZSrlWLFmDip4Se4hKYIYPpXm+0O6hxo0YgkSYtL/
         5W5uV8qlzbdJ1k+VMTPjRaM3uEW10vi6odLt82r8lQdTHV/ZZ8kj49PCZrspHjn0diK2
         qpjCe2DXVm60sayl8HBV2TH3dExzZq2opnUUK/r034ESjbEzM+PVJQ+gQKEUKJWuck4s
         7BFHei8CEy9LcivQHGA59tk5KSGYw2S85mWWtCpZIg0rw6KT23FCQ28syr3pHBAX5PMj
         +BBJv7pKbTIeSUvjCzgjbGYcouNsF/tDXTUe2dikicMxhbYkXv5J+sNwXt4pvFK2Lraf
         cOlA==
X-Gm-Message-State: AFqh2koQgwakQgc6KjZB6JgyDdfVxSgmSZENuka1E+5k+VaB1IQ7i3TN
        WuygIQUSYiZx1SZMQk5PrMRjrA==
X-Google-Smtp-Source: AMrXdXspp38zMEFlOmPzzPcZ9bV4OI1r50uFYJJa9bV+wIZ0z25b2cgR90lgJ5ffAc+d+9PuKAVl/Q==
X-Received: by 2002:a5d:4d8d:0:b0:2bd:da99:bb8e with SMTP id b13-20020a5d4d8d000000b002bdda99bb8emr12480445wru.52.1674209714537;
        Fri, 20 Jan 2023 02:15:14 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id t13-20020adfe10d000000b002b6bcc0b64dsm23441127wrz.4.2023.01.20.02.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 02:15:14 -0800 (PST)
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch>
 <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
 <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
 <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
 <84871cc7-2f96-7252-768f-5f869208045b@gmail.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hilman <khilman@baylibre.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Subject: Re: [PATCH net-next] net: mdio: mux-meson-g12a: use
 devm_clk_get_enabled to simplify the code
Date:   Fri, 20 Jan 2023 11:14:41 +0100
In-reply-to: <84871cc7-2f96-7252-768f-5f869208045b@gmail.com>
Message-ID: <1jk01hwlzi.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 19 Jan 2023 at 23:56, Heiner Kallweit <hkallweit1@gmail.com> wrote:

> Use devm_clk_get_enabled() to simplify the code.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
