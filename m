Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0970F6211AC
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiKHNAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbiKHM76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:59:58 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B215513FB3
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:59:53 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id b2so38372787eja.6
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 04:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AqzYlfR/mH5JClZhxYXyAhXniLe+VOq3+UPKWSQZz5c=;
        b=KsPR9Z9wopYkGu828wPcuivwHZoAZHkw/cosmy9RMqygTieoK/i0aMwMsJSNY4N70j
         ndONdlkVhupZmRZCpUcqOn8obpErBwnvE+4ZlzJ8HeLBnvAteM8ZS196msKiKxit4reG
         7VWFNewNBrGuN6b0OYRos8hH9hJcxJLRf5AAgC4LPHqSoDaiY3KOpwtrKaKJA8PMZjZR
         7DddW0fgV7ko25pQGwmlabsfFq8LeTA4i5AwnBuu7zFt8SUBhfMdWLDKyt5UG+ggwOBo
         vOwIUo/484n4N8i1uFwvkYo6YjEYzjhzBcvhuR52JxMAw43hZnwfFcRMrA2ffEtFLRc9
         R7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AqzYlfR/mH5JClZhxYXyAhXniLe+VOq3+UPKWSQZz5c=;
        b=bci6dZKPbtZ/pVYTR/o2QqsJ+dl0ns+s2tPG+Yj7tZkH0syU/ew85NTKmmCDiaiQi0
         GmBREQ/CV7+pl89WejbPxQjAhmM9mrCffmbUUz5U/KJ5w9V7tnFjDWRCElGUgel4Yc5x
         mpv0zqzESbcAb5wjh5hc1sn2tlub6XCFr15D2ElLISbD14CWUJLJlCiXpFfY2rSO5jKw
         /R2cS61EG3cGm9fC0lFDDRTM38ukd1X4ZOQojH6j5GdCWsF0HLj9xi1iKf5sMD0A8/zc
         0zvxSVsWmUeUyJbkrrn11Wv3sgCC9jueER2U42XxrY/iac0/pes/n8DnAfPfY94Ov6ZE
         XahA==
X-Gm-Message-State: ACrzQf1K6Xkj87tJ8hCnsVw64DkNtOgtqeWiio8dOw0jDH85mUax0EAt
        Ua2VsvZ4BaHZ+JgFIcCG1sxgCg==
X-Google-Smtp-Source: AMsMyM7nx2pbJiSB8XqDuSDOId5LW0ckHc+ywqajGV23Ts8v1BMvW2D32+yN3niN5REA6bXPDXp3bg==
X-Received: by 2002:a17:906:4a06:b0:7a2:6d38:1085 with SMTP id w6-20020a1709064a0600b007a26d381085mr922137eju.114.1667912392173;
        Tue, 08 Nov 2022 04:59:52 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id vc7-20020a170907d08700b00782e3cf7277sm4603900ejc.120.2022.11.08.04.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 04:59:51 -0800 (PST)
Date:   Tue, 8 Nov 2022 13:59:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: Re: [patch net-next 2/2] net: devlink: move netdev notifier block to
 dest namespace during reload
Message-ID: <Y2pSxnZjdrsSjW2j@nanopsycho>
References: <20221107145213.913178-1-jiri@resnulli.us>
 <20221107145213.913178-3-jiri@resnulli.us>
 <Y2oPRR+P2ecMLPMl@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2oPRR+P2ecMLPMl@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 08, 2022 at 09:11:49AM CET, idosch@idosch.org wrote:
>On Mon, Nov 07, 2022 at 03:52:13PM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> The notifier block tracking netdev changes in devlink is registered
>> during devlink_alloc() per-net, it is then unregistered
>> in devlink_free(). When devlink moves from net namespace to another one,
>> the notifier block needs to move along.
>> 
>> Fix this by adding forgotten call to move the block.
>> 
>> Reported-by: Ido Schimmel <idosch@idosch.org>
>> Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>Reviewed-by: Ido Schimmel <idosch@nvidia.com>
>Tested-by: Ido Schimmel <idosch@nvidia.com>

Sending v2 with cosmetical changes. Please put your tags there again.
Thanks!

>
>Thanks!
