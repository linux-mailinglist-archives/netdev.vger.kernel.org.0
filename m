Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCAC6686296
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjBAJLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjBAJLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:11:49 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4F361853
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 01:11:28 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id d4-20020a05600c3ac400b003db1de2aef0so838728wms.2
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 01:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n3Z/bid+sWBm2o34dc1EebbwJ8kPpqt9xquIjbF2na0=;
        b=mdJdgYywbob3PfDCxjXR/oRpPGaJp4Kf2Qiayk9C1hl6o7jIV87Sqy8d+Byx0PedWy
         ksOJqIEZsBun8oVSkLjRTG3lO56hrWT0TBXiqLsP+nXRnQag6VsfSGS/KHvZO0pN439F
         85IbKwaC+i3JwWyByjCmxjy2QNV4PDJm1ch6o4vVmqoA0Rg6NndcVZvIW5P7fJdbm+gC
         xmXZ1DHjh4t39GPnO02+qGzshYi/kWuiVuRtikKexzsIi8SdNgbMETQSktzrJlWrV9go
         7t8St3842VJec4Y/hSzk6FNyw1j/eXxSGHpGVpCjOhOGgIb5V2RxAWJAIAV2ykOajtwD
         vcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n3Z/bid+sWBm2o34dc1EebbwJ8kPpqt9xquIjbF2na0=;
        b=309dGhShQTGbukMd/f/PGeZRctFiLwaCiMzkW7Db8Vn+9aqdvRWpa0FIRJoZl8Rdqn
         f353AQY9ILyKE9lc+tj6RJ2IMzloc885gMzgB5JpFyYw71/DKI4wVHhjZPl6xpNDmHX6
         2vpNd8lqxzq3IEYvlD21THi0N3xrTGgQ/7nTrv4oBqG7I6Xw8BX7PboR9f4VGsa31Boy
         0rG5qliuR66/rvq0cNp1b+MLr8TVtMBeimeXQGdU042yuh+td3gY8/G0vFh2nz7XngUk
         JgoGXvaZbkJSisdwMr7iLSBu80/p9PxzCBvGhqkjAHDpXMU8jCUWOFSLSeBIK2Gn+iRA
         cieg==
X-Gm-Message-State: AO0yUKVRxm0OQVGrqDkMkumiM9WQzedoNgNf7br6i52WglIp8Peil3T4
        R8m4IaTahIR/HjSMqZqvAVeJ75g+LfwoaZtkLnw=
X-Google-Smtp-Source: AK7set+HSFQy6N2s7xGm2W0GNwEIt9Mmu1F0V5GD9viZu8gIsKwPupSSo3QlE3xqs1KXwLI3rb5Bmw==
X-Received: by 2002:a05:600c:4fc6:b0:3dd:caa8:3ad6 with SMTP id o6-20020a05600c4fc600b003ddcaa83ad6mr1212346wmq.38.1675242687147;
        Wed, 01 Feb 2023 01:11:27 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j25-20020a05600c1c1900b003daf6e3bc2fsm2371577wms.1.2023.02.01.01.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 01:11:26 -0800 (PST)
Date:   Wed, 1 Feb 2023 10:11:25 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Praveen Kaligineedi <pkaligineedi@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Jeroen de Borst <jeroendb@google.com>
Subject: Re: [PATCH net-next 1/1] gve: Fix gve interrupt names
Message-ID: <Y9osvYPMdw3uKjA1@nanopsycho>
References: <20230131213714.588281-1-pkaligineedi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131213714.588281-1-pkaligineedi@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 31, 2023 at 10:37:14PM CET, pkaligineedi@google.com wrote:
>IRQs are currently requested before the netdevice is registered
>and a proper name is assigned to the device. Changing interrupt
>name to avoid using the format string in the name.
>
>Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
>Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
>Reviewed-by: Jeroen de Borst <jeroendb@google.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
