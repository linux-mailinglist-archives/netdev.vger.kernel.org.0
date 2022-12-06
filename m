Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A4B6445A7
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 15:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbiLFOa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 09:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiLFOaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 09:30:25 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A931B7A3;
        Tue,  6 Dec 2022 06:30:24 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id v7so11329059wmn.0;
        Tue, 06 Dec 2022 06:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=60gpA3iO6LtTHFgDP5CRQS6Kg+m/1YsCOeCoo8dreMc=;
        b=eKBhWjHlsxs6ypSJR8cVj3SQueEsGRa/u2royrtMdGoBgbT5elUy7XUXwBtRsvHnY3
         4xk5i7OVVBscsemNwZxsFm8CkffeEUit34wVEGPcOuZLt3MZRnkDXaeGAasBMWAdk0LP
         LS12Qw7t8mN+vc9ybpzqaloyox/ll8IJrXcjwmAwBTqZjhwBBuuHTkyvqQ7VkL9Y8s9W
         5qAIKj9eOzIVk0GlwTL3CBg/ugKFtNjBJXGsHmb80k7UlHprmuBC02d53yg7mUhK8u6u
         A5V5/oWKJKURM4AhKcGXjKZ4M0yNv6a3aHuvKVqCXXpd76DqQZLhOr45SvLv1oAVzR/N
         3AlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=60gpA3iO6LtTHFgDP5CRQS6Kg+m/1YsCOeCoo8dreMc=;
        b=ZMb6yhSxHhkT0NkleYE1eFJTXzmHGtH7byFf2RBa+OdsPRa2BpbZe/c5GPux/VfTMa
         aX5x8jpReGCeW78a35nlwNOvrXn5tFHYxOuBx5oZtMh0FtE8iaOI0/nrQNJ1NHmI1Bqh
         hdWn0vz0j5DErBhX06gcI1xEgHn5WpWTFYJBtosKajk2kh9xqR4AsSYNBlBgZHW/5vUr
         tIJ6LpxNXgcNlvY91dCR+jEVvv5VS5l2WYVSWhGv+UTyCoVIfj0QNIfn/eLr89ZqoyCv
         kMVvtK4Ll+7s4B1LsefKK/hjwFA2QPOgQi5/T0TuoYVBHu1+iNenFMVDJ+2cl+FahhHD
         DMWg==
X-Gm-Message-State: ANoB5pm8hqCBgFaI1ywata/S3xI69kTozOgPLnwBTdWwutDsnVYkAeDQ
        JHppWAJ25bx7yuHdz51E6Os=
X-Google-Smtp-Source: AA0mqf67PP/tu+cXaQeQg71lSZDNXFe/YeU75rQIlOcI9yr9eJxHRrhlwyD4uLLuAvKH6Mmrh+Ob3Q==
X-Received: by 2002:a05:600c:4fcd:b0:3cf:a11a:c775 with SMTP id o13-20020a05600c4fcd00b003cfa11ac775mr54534880wmq.153.1670337022654;
        Tue, 06 Dec 2022 06:30:22 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id p17-20020a5d68d1000000b002420cfcd13dsm16630200wrw.105.2022.12.06.06.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 06:30:22 -0800 (PST)
Date:   Tue, 6 Dec 2022 17:30:04 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: mvneta: Fix an out of bounds check
Message-ID: <Y49R7GJLxSkI4VU2@kadam>
References: <Y49Q/Z1X1PKxIFfx@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49Q/Z1X1PKxIFfx@kili>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, this applies to net.  Not net-next.  :/

regards,
dan carpenter

