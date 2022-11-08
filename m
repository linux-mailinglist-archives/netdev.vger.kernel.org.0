Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040DF6209C0
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 07:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiKHGxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 01:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKHGxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 01:53:44 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2611DF3F
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 22:53:42 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id l11so21013668edb.4
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 22:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zMGYYIx/laNxcd3bO69ir/AUGnVOyE7PdbWCIr5a6y4=;
        b=HEbNcOPhkfy9ov4AhFBLrACAe51wmEJHP84zVmnltUvw2iiWzZm1CETsPK0PDwsio2
         9zV3ve5a/ZU38VvB+3ThZcttS9NkF9EfuwDmLq1WgSIUbGwO0mFFb2eoC8U7vjdu1NBk
         Ay1rYblhlXbYAF65fmpCsOiod2asuAkY/C/FK9z7UvEHKVsLLADxHdZliCTRo4GIh9S5
         DN9CwQzUPCaDHzOzwsIdSYrblOFKwdWZzFwMnddRB4H7P7ab1VL1BASxQiCD0fXsnAYm
         iz7BaGIVK5kUpstt6yZDkteARxTFKzw/8UQ0Idv9Aupy+p+AkkHZpb3g/Bw2bsxNwE29
         1sQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zMGYYIx/laNxcd3bO69ir/AUGnVOyE7PdbWCIr5a6y4=;
        b=xnQGgPv3+qLcTRH8/e2dJR8TT7NfHifJmwXvvwislWhKhsW2socw4i2O3VNVn1i4rS
         NBaT1wIDsMtGAnFJ8QK55QCHcbqHLNzNvJxbsjKJQ/ZgYwauHBcmwo7A/1hXXeEMK3/c
         b60j3jPo0oFx4oBd0yqn66RLhEOVWUTZqiTIeO8cZYm0xgFa0yGCIkuYiBjKk1GNsTpb
         6G6BdnrKHYg4AjcXmrv31aOV7PUkJuM57kc0YQg8S/Fezqureh550bX6DWCoVPTi3aV+
         NrXvlby80ki3DLOz1MCLalKn0k4uTSJNATiN04p44ZqI9Ra7V8GSY5hVH9BLJT+nYQrK
         4uGQ==
X-Gm-Message-State: ACrzQf0sGIgqNw/PihRoc9KfKgOCVSD1357W+ttU0jZVTUwzivJxecnR
        rve1Mf43Aa4ZVDmoHc7SknmPBQ==
X-Google-Smtp-Source: AMsMyM5FriklogJtYhCMbC/7i8E016YXM6ne2YdzlL2wVUice6U+Els4MIsVkZrsqZ5zlktCA4kgxQ==
X-Received: by 2002:aa7:de0a:0:b0:462:d2a0:93a with SMTP id h10-20020aa7de0a000000b00462d2a0093amr52227340edv.275.1667890421307;
        Mon, 07 Nov 2022 22:53:41 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j7-20020aa7de87000000b004617e880f52sm5063335edv.29.2022.11.07.22.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 22:53:40 -0800 (PST)
Date:   Tue, 8 Nov 2022 07:53:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, idosch@idosch.org, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: Re: [patch net-next 1/2] net: introduce a helper to move notifier
 block to different namespace
Message-ID: <Y2n881qPpY9J8MQ0@nanopsycho>
References: <20221107145213.913178-1-jiri@resnulli.us>
 <20221107145213.913178-2-jiri@resnulli.us>
 <20221107202937.6ec5474c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107202937.6ec5474c@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 08, 2022 at 05:29:37AM CET, kuba@kernel.org wrote:
>On Mon,  7 Nov 2022 15:52:12 +0100 Jiri Pirko wrote:
>> +void __move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
>> +				   struct notifier_block *nb)
>> +{
>> +	__unregister_netdevice_notifier_net(src_net, nb);
>> +	__register_netdevice_notifier_net(dst_net, nb, true);
>> +}
>
>'static' missing

Yep.

>
>> +void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
>> +				 struct notifier_block *nb)
>> +{
>> +	rtnl_lock();
>> +	__move_netdevice_notifier_net(src_net, dst_net, nb);
>> +	rtnl_unlock();
>> +}
>> +EXPORT_SYMBOL(move_netdevice_notifier_net);
>
>Do we need to export this?  Maybe let's wait for a module user?

Ah, right.
