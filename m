Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF8565BFDA
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 13:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbjACM0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 07:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237136AbjACM0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 07:26:35 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78ADB7C1
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 04:26:33 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bn26so9811367wrb.0
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 04:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IlQ6wkRLyTuxgq8NGIOsKiIdSCr6W/fI+vm84ngVIKA=;
        b=7V9ExTh4taqT6k+Eey28EAFJbjy0OeDxCYmE5rz8QaZIubH/gkcsRDYUBxjeY2kiqI
         VKKhF8POoRrrjiT+7ulWNJTf6fIT1lAAXJQaX7KGlTH26f88x0EN3j8K8iQ82U3YYBK7
         SV0809UJdt18VZI+w1Q29doVOLQUpvryKwfCLrf2V9BNmTlR3sGwX+16uOwTArKfC4kZ
         TtT01T9lANRw2Vtra1PGqpJoE8Zxtu1xgkDis8Avt0b4ISYKTcnrb65UBQo6xHKBcnle
         +8WsL20/LkljnRUgdGlIFuGq4bAMY+sqRGnC7A48jyE9l/3EM6q5elWesKaHk3WcmG3x
         +MGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IlQ6wkRLyTuxgq8NGIOsKiIdSCr6W/fI+vm84ngVIKA=;
        b=KWxe4N38twQV8IkURPROXTYPD8w+zz3qUFGZs6cYqoUmq+7VQLrOmx1J7PUHHHApOz
         9W8M0aTKWNQ76qZhu4eXUGkVGsfhJVuA3vv4RNQrT/wBc2NZnp+S0fenMPilBT93S4ka
         MjG0SRxPzCh5aWsEMXq2DOwVKMPmnodHQbSmRGhuErmIBAUo5NjY9MzG5DHOd494mcu2
         YOn0tYi7r6Px0VEeVMkpNn4gbKkpN19uxevO6uUT/5dT8wMaqRmnnBDWL57UGovdL1Rw
         yLPAUXNe/9NhraeJTQtHMypfwqZd9yaRy0vCwDigBCyANx71aOyik5zQfqtyvdWcKVpH
         cs3Q==
X-Gm-Message-State: AFqh2kqwdQan0mrBlcEMeoNgADmTzESPmZnLFU8fWh0cUv9BQIORbDd5
        DbnfNGKgIqQnjHj4TkfWVuUKFg==
X-Google-Smtp-Source: AMrXdXt5V3+HhnF8Rt4lqKEH8e6zlgzvWfavDQb+OB55G1+nCTDK4ZLaccRHHaJd8gbWi132iF9H6g==
X-Received: by 2002:a5d:58c5:0:b0:28f:c68f:f5ee with SMTP id o5-20020a5d58c5000000b0028fc68ff5eemr10633635wrf.28.1672748792219;
        Tue, 03 Jan 2023 04:26:32 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t4-20020a5d42c4000000b002876ab9debcsm20641950wrr.36.2023.01.03.04.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 04:26:31 -0800 (PST)
Date:   Tue, 3 Jan 2023 13:26:30 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <Y7Qe9qHUVuqr2Wgd@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221217011953.152487-5-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Dec 17, 2022 at 02:19:47AM CET, kuba@kernel.org wrote:

[...]


>+bool devl_is_alive(struct devlink *devlink)
>+{
>+	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
>+}
>+EXPORT_SYMBOL_GPL(devl_is_alive);

Why is this exported? Drivers should not use this, as you said.

