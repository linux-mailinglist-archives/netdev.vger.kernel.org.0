Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBAF6F405F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 11:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbjEBJmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 05:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbjEBJmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 05:42:40 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CD41BD4
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 02:42:38 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94a34a14a54so714446466b.1
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 02:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683020556; x=1685612556;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iqorCcmQs2qoCTOVvkP0FWFjyQv0deTBNrEASNxcxis=;
        b=SG+LOlewa5LCW1O5DjO246oA1V5l1F3K41+HO6x9kd7ddJxvJHKLRGSew9C8smcY+Q
         oGEkRIxDA+gyCjKYzVW7WB7lt9Bl7GBohww1L8fovBzyFX6U+VIlPBTaUH7vNJdde31i
         Uo+MEVyiXfabj6rtmcnCHUR8We78FB/4PnJrJdLd92bi5IWxbi28AXvOA//WK8rV6YDV
         A6Z0cSmwvvIa79QngJkDrL+IC0g6Y7RzKIVxogU5ONRHL91Cr5XOwixK9pxwPGZNl2WK
         BSWMb2+mBJSopQeI7gOEowpS6FC0Ar059y6cGwlCHBIuU/MwXfFJ2jZKQIHDbQOiXyeh
         Zc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683020556; x=1685612556;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iqorCcmQs2qoCTOVvkP0FWFjyQv0deTBNrEASNxcxis=;
        b=XfsTu9C+lZWtNH7rU+jLw+n1xepnJa1MHe9U8vTZhuPoJKt/nolpp8lOpkM7FfA3rf
         0SBWP3QQS6QQmB4tPtjit4o/ZV61rTfKofQMwwqUQriOFb0dI5joL6uX11TGTpTKoklL
         R2mBtuzl6RMznATxB2zaave6dRKT5JQ8YetnhkKgDYrto4sK8TjSfJGZLyUlTQ/N+Fdm
         JNkYvBHe1j+iLRIuSE2LYMGl0O0o3wlsJvJesZc8+XAzfAdejikn4/yV0PCElGYMKmd5
         HEk5tjyM8To181k4bti74D/9MDEu7CPkSyy5NELqoadDB9ZY0gd0r351kbLEPVXzRcbo
         ILZQ==
X-Gm-Message-State: AC+VfDzRRQKYkMY3RGQ95ygV9lGMju5h9mBQVWGCzH96YmxBiJkYwQha
        34dVkkZ98StFgqX+GIaG7bt/OA==
X-Google-Smtp-Source: ACHHUZ6FSbF7AKie+yNOXhQl4D1+XRSo9rd/9M5/G+ce8e44j91FsrbN3ZgHODgbsMRsl31knCZixw==
X-Received: by 2002:a17:907:3684:b0:94e:c6ad:1119 with SMTP id bi4-20020a170907368400b0094ec6ad1119mr14069443ejc.13.1683020556584;
        Tue, 02 May 2023 02:42:36 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l22-20020a170906795600b0094f25ae0821sm15749724ejo.31.2023.05.02.02.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 02:42:35 -0700 (PDT)
Date:   Tue, 2 May 2023 11:42:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v4 5/5] Implement ndo_hwtstamp_get/set methods in
 netdevsim driver
Message-ID: <ZFDbCjkMr7kQ153F@nanopsycho>
References: <20230423032908.285475-1-glipus@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230423032908.285475-1-glipus@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Apr 23, 2023 at 05:29:08AM CEST, glipus@gmail.com wrote:
>Implementing ndo_hwtstamp_get/set methods in  netdevsim driver
>to use the newly introduced ndo_hwtstamp_get/setmake it respond to
> SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
> Also adding .get_ts_info ethtool method allowing to monitor
> HW timestamp configuration values set using SIOCSHWTSTAMP·IOCTL.
>
>Suggested-by: Jakub Kicinski <kuba@kernel.org>
>Signed-off-by: Maxim Georgiev <glipus@gmail.com>

You need to bundle selftest using this feature in to patch.
