Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E096B85D4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjCMXFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjCMXF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:05:27 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B3221959;
        Mon, 13 Mar 2023 16:04:35 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id r11so3435318edd.5;
        Mon, 13 Mar 2023 16:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678748647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FB8Ui7aB1q1yvb8FVgLJ9bAl5Qx318FcsSeRuev6vaY=;
        b=fbL2bjdsbAOU6bmXLkJLshswntGHKtZ6LApJkQksRwNXY1lbo+1ItOWvLcjANIT33A
         0AMZNsUtCU1zObgF/WV33Ie7kBoC+QGuLxqy8OZLo8QNnjlfqt1mOzYMK0F7FBdr6uqC
         be/Ub6EAEax7zIFsx46SNAqrZQxI9YR2eN1QD0b6ZAwzFo3vJPFCrVAMY3tCvrf/sVaK
         wPP/DSCLYOZtd1ZlhXCTTkCJxkzNHfjglX+Fi2UqqXEM/4pQAYot24w4A12Z+pdZRUqP
         +vLtptjQfyfMXfVWh6D9MJx9QbhvzthfJ8N3QXLtLrtbJ5hnuB7SlUNhn6Y09tWZZF8Q
         QQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678748647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FB8Ui7aB1q1yvb8FVgLJ9bAl5Qx318FcsSeRuev6vaY=;
        b=k/4LeXmAtivcn4bDnGplUWQdyYKUJbN/F6YQbRcuqGg/W4uO+hi1L/NgHYFUhNtnlU
         9EshvC16QUnp1MLM07KVHCQMI9nGQHJWp3DBmNLpL2+CkUsxlD6yYoOr1rGY7sbe+7L0
         D+7t82eHNBE7+F2/Ib2gLxl9rTH8rJMgEHumhAmz+G5F9Sp4Btrr2CKp6GWEQq9H4zjP
         mUwBvD6OQgmsiZ10QwXeEV4UOMhKYsyES6jTxk9roWQOBKS6Ksu5ltatKix2Krx74/x/
         /jdz1k+PeX0s1b55QQedsBOLzUUa1CxEY1HA6Q5pUa4jjYYwHrR4F6d7F2TCDiS1x/px
         pweQ==
X-Gm-Message-State: AO0yUKU6zGa8vAmbjt1Z+GAdSJWkgyQ8AMiyHevxN3AY9F6NnCV6sMmi
        8VWtDGurrg1owQaaLxBa+rY=
X-Google-Smtp-Source: AK7set+c38k4SobQg6fRXJbxW9hsgcGZNXV6tLWaYIgcLQHuQe5d9JERYOaT0hj6+J4bWMGO9/o18A==
X-Received: by 2002:a17:906:a18e:b0:921:5cce:6599 with SMTP id s14-20020a170906a18e00b009215cce6599mr183291ejy.41.1678748646681;
        Mon, 13 Mar 2023 16:04:06 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id r9-20020a1709061ba900b0092b65c54379sm319526ejg.104.2023.03.13.16.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 16:04:06 -0700 (PDT)
Date:   Tue, 14 Mar 2023 01:04:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Danila Chernetsov <listdansp@mail.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: dsa: vsc73xxx: Fix uninitalized 'val' in
 vsc73xx_adjust_link
Message-ID: <20230313230404.vww27tkxh6xvp24h@skbuf>
References: <20230312155008.7830-1-listdansp@mail.ru>
 <ZA9yj1FT7eLOCU34@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA9yj1FT7eLOCU34@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 07:59:27PM +0100, Simon Horman wrote:
> On Sun, Mar 12, 2023 at 03:50:08PM +0000, Danila Chernetsov wrote:
> > Using uninitialized variable after calls vsc73xx_read 
> > without error checking may cause incorrect driver behavior.
> 
> I wonder if it is:
> a) intentional that these calls are not checked for errors

probably no; this is precisely the only vsc73xx_read() call whose return
code is ignores. I'd say it partly has to do with the fact that vsc73xx_adjust_link()
returns void, so the author was thinking there'd be no point in checking
for errors, but there clearly is

> b) errors can occur in these call paths

probably yes; one of the instantiations of vsc73xx is over SPI, where
the controller can time out, etc.
