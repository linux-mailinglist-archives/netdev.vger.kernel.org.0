Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49264571C11
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiGLOQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbiGLOQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:16:16 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C838D606AD
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:16:14 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v16so11346041wrd.13
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H6EusyMExVM7Gm79nFEAN60AaPdq/mwIzo03lqkK5to=;
        b=P3GgEWafItynEPUeRoCoHrX6LEoiB4cSe6VLjnMqZxKLcw360/3q3ZdzMy3QStTwyV
         i3L/GkvRMLBDK8QE7cpyBbnWf907DsC6ldeB+8AXnqYNmiDeR36RWf+LFrhq+cHUjUwj
         5+ojoBl2r9oyNHAiEwwmTLUlRC83dixxS4y3Kr4msLF5PrCpLEX78Df9dokn6wlOb3xB
         HheIpAc+AyirpsmDli6vcSupxSCRg6UXoHy097DBCtH0210XOXbSwMTKE0Qgw3nAvsZg
         A42D4WhKjIXr8jPJGcQBk2qoePD+mE/Zjd8zaBHgSzeGzojzp7iRwRUMEbLFgmqt/Nn4
         2wVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H6EusyMExVM7Gm79nFEAN60AaPdq/mwIzo03lqkK5to=;
        b=EQlT5AbHy8X/Ng1fsN1/Au+cdO2SEtrSDBV/dun6h56lQhj8wVm59WCXnCu41azuhD
         v55Oh31HsXcbgm+Kzle4twH6WwWi1KrapcaRVdazHgmbfPUruE+1m75J4rDcJvdP/nm6
         ugPAdIqGhfQkI8ig/h3c3Y6RlQW8Y2w7mp9ex+bwbfzjFU9aVuvhzt4BNDXjAVkQQmtA
         BufPqQYKY/bUmufM3Q98FRvBEo5WlarhfrX3KRC7mJtc3YV484MvKA5vN9n7U5dsL+Oy
         H+4yjL/c4AZKqW5e8VUuqhT82oQPTJI+9ziySxLNR5Ry7gQk2HNhVWafj6RdHGMTmH5K
         oF3g==
X-Gm-Message-State: AJIora+rejFtcG50R1Jr6M4YfZ9RkdltmyJQuG4GcV1ZRip48fznQ2Na
        C50Ok0VxHEGOPiqvel4a3soJiw==
X-Google-Smtp-Source: AGRyM1vUisiJCR5RiiETEvKukffmxe5MGt+FdRdnFXFKeItratrYVmFl7eNgeokgZgsYh9GORZx1sA==
X-Received: by 2002:adf:ed41:0:b0:210:20a5:26c2 with SMTP id u1-20020adfed41000000b0021020a526c2mr21587720wro.603.1657635373374;
        Tue, 12 Jul 2022 07:16:13 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b10-20020a5d634a000000b0021b89f8662esm8642369wrw.13.2022.07.12.07.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:16:12 -0700 (PDT)
Date:   Tue, 12 Jul 2022 16:16:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: Re: [patch net-next RFC 07/10] mlxsw: convert driver to use unlocked
 devlink API during init/fini
Message-ID: <Ys2CK/S7gh5hItyI@nanopsycho>
References: <20220712110511.2834647-1-jiri@resnulli.us>
 <20220712110511.2834647-8-jiri@resnulli.us>
 <Ys14Gorcg1JV5UIF@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys14Gorcg1JV5UIF@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 12, 2022 at 03:33:14PM CEST, idosch@nvidia.com wrote:
>On Tue, Jul 12, 2022 at 01:05:08PM +0200, Jiri Pirko wrote:

[...]

>> @@ -2102,6 +2108,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
>>  			err = -ENOMEM;
>>  			goto err_devlink_alloc;
>>  		}
>> +		devl_lock(devlink);
>
>Why not just take it in mlxsw_core_bus_device_register() if '!reload' ?

Not possible, devlink is not allocated at that point.


>Easier to read and also consistent with the change in
>mlxsw_core_bus_device_unregister()
>
