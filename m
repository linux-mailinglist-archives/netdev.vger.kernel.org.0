Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C307629E9B
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiKOQPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiKOQPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:15:33 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA372A72E;
        Tue, 15 Nov 2022 08:15:32 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id n12so37210646eja.11;
        Tue, 15 Nov 2022 08:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iz7nTVfZagwf8/DnbFyom8eHy7HLuIkriMK+2Ddvk7g=;
        b=hSpuC30G2NF3ya0PrlwTbmuj5oCazBR+uLWZrbjS9RSud7hGI286kyvQcK8j8b4bUm
         8Gaz/EhonOCI4Z+t/H65kN4mstLNi+WhggwNmn5FRls1I1xYOmon2/pg7R+ntlan9BLw
         jaPdKogodCvhLYkXHq7iEN87gyKTHxcimZza5eYo1Gf9zFzYZ7D/VcPFlwVZ0y7Ad2QO
         Qbkpm63EZ4UoF7hB6TqU5F1LpgqdpmQKlD4dmXpjqAcPBuDDGJuHcXKms0/qs4uxiCtG
         Bcg8sdVi+oumwbveKWaOX0OboJ2Eu9OQ8g4VN1a7RW37mxN4maSTTZ08bvl6azHQo7pm
         jZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iz7nTVfZagwf8/DnbFyom8eHy7HLuIkriMK+2Ddvk7g=;
        b=E/8d2Wmg3E3b5RxwNkG3J1kCOioQ9SKThZ+RsPumLj8nIxeLGOyGRnIDMjIElmx39n
         OINXje93gDBMepuJfG+ao9C397AwgpKJA4VvWx9caUedjdmaKf6qDHog824Av+bLKAYp
         ix0FRLD5sON4RnGtQbmoX+O5dwZBhwVom/N/gAeMpxpah8B7hrKkbDaATePOyM/0U/M/
         IIkRcbLe7MZTVMk8Cs0KFzYOkV+ky/B+9diGZx4O0n8dzKVyuavb+v5DJxRXbNco8amW
         R4opeaWfrErWvh7am7hPFulIvDohh0fMwlm/ZxkGiCqCZtjDAdc6b2IESgVfwNpvLBNQ
         L9pw==
X-Gm-Message-State: ANoB5pmrh0csGturPELLUnSkNBy7FLun1M8y4zOiX8YMBlR8QpfQn95B
        q6Ixc7/4pWfsoFrSS5f2Cqw=
X-Google-Smtp-Source: AA0mqf6XqBrJ+wn2UsUi281+TIJGWfamIhMFzR2lavAMTAyXS4DHUmrhPV6sv1U3Jyv17jX5w8X8XQ==
X-Received: by 2002:a17:906:4a0f:b0:7a2:36c7:31eb with SMTP id w15-20020a1709064a0f00b007a236c731ebmr13584973eju.491.1668528931132;
        Tue, 15 Nov 2022 08:15:31 -0800 (PST)
Received: from skbuf ([188.26.57.19])
        by smtp.gmail.com with ESMTPSA id f7-20020aa7d847000000b00459ad800bbcsm6366176eds.33.2022.11.15.08.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 08:15:30 -0800 (PST)
Date:   Tue, 15 Nov 2022 18:15:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <20221115161528.nlshuexccymfkree@skbuf>
References: <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <20221115122237.jfa5aqv6hauqid6l@skbuf>
 <fb1707b55bd8629770e77969affaa2f9@kapio-technology.com>
 <20221115145650.gs7crhkidbq5ko6v@skbuf>
 <551b958d6df4ee608a5da6064a2843db@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <551b958d6df4ee608a5da6064a2843db@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 04:14:05PM +0100, netdev@kapio-technology.com wrote:
> I think the violation log issue should be handled in a seperate patch(set)?

idk, what do you plan to do about it?
