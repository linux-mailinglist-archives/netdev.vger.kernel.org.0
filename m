Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1AD63BBB1
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiK2IdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiK2Ic0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:32:26 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1884259877
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:31:43 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z20so18725491edc.13
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=287JiUA2oQmM2pNNjCPcYh3VGsXmR2ra6mVMQuG3Pus=;
        b=b3IO/8vakfZMrPtt1gXg0nCfHaxP4/IGZkiP4QyeZH3DnDvDynIo9mTQc+G+xGXwZH
         7ERs1FYAxok8ADW2pf2TVhL4kQK2jaEW6FjR1wRvSrP+6WX+im9iKPdZZujxOxcHg0ju
         29L08CPy0g9qNQo3Pz9qSb2x/Iv3U927h2wTyv8ljuQ9MejqQZGN+87mUNKf8nIYFUcf
         pz47dptt5+xDjOuvXuyjgKPXyovWalVtoIO3jqALn7ZVObqMCtEoOesXjYg0bOKy9W41
         HfM6ZFwgYlyKaWb6VS9/dswQpsHDS5qs0sPtJJ3XqKxp0f8opIk5aliXNii8WogYaaNn
         AB7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=287JiUA2oQmM2pNNjCPcYh3VGsXmR2ra6mVMQuG3Pus=;
        b=wl54LqOsqfdemgLwC01eywWDMEytfUhdLoYhvwLzm1uy3dGzkPmV3IMAlf6TEG2Co0
         KLfDY68k6lLf7RBUgmC2GUzOabgYXHOkJldi2CsiR/RC5ciGSvAPKKof2pIMqtgtfDes
         qeUT8qbxWAC+oaEmToChaaw5GUo1/FeVjs5fxxYknk2zF1z/fh8p3BH9dRLla6BtlqeU
         VOUXUQTb2Z0LB9rX2mFFtgNtKS8+zs2xA8XD1PdfVTajgJessjEqky9E/mWdI05326VY
         R6+5ZywWOg4wwlhIK4d6DFYQbW7DGUgcNegKaSEtFxDNpt1cDID8Fqht7tognWKc5B+2
         D+ag==
X-Gm-Message-State: ANoB5pmc/t+wR8DCDl81x+WUkb/7uqzwWvwapYkxBxWwcxbKfOr9B9+x
        DaeWfqpe3Srge6+++vEClW4FhexiSl47rXZjMjU=
X-Google-Smtp-Source: AA0mqf6IgwnzIhgMbtVx/00Ih7/h+lkbdC6K45k6byM+ggyJtzSITkDfrV45csMKs50pBxERfobJqg==
X-Received: by 2002:a50:fc10:0:b0:464:2afe:ae18 with SMTP id i16-20020a50fc10000000b004642afeae18mr52188491edr.183.1669710701549;
        Tue, 29 Nov 2022 00:31:41 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id og14-20020a1709071dce00b007ae035374a0sm5972887ejc.214.2022.11.29.00.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 00:31:40 -0800 (PST)
Date:   Tue, 29 Nov 2022 09:31:40 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4XDbEWmLRE3D1Bx@nanopsycho>
References: <Y30dPRzO045Od2FA@unreal>
 <20221122122740.4b10d67d@kernel.org>
 <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
 <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
 <Y35x9oawn/i+nuV3@shredder>
 <20221123181800.1e41e8c8@kernel.org>
 <Y4R9dT4QXgybUzdO@shredder>
 <Y4SGYr6VBkIMTEpj@nanopsycho>
 <20221128102043.35c1b9c1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128102043.35c1b9c1@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 28, 2022 at 07:20:43PM CET, kuba@kernel.org wrote:
>On Mon, 28 Nov 2022 10:58:58 +0100 Jiri Pirko wrote:
>> >Long term, we either need to find a way to make the ethtool compat stuff
>> >work correctly or just get rid of it and have affected drivers implement
>> >the relevant ethtool operations instead of relying on devlink.
>> >
>> >[1] https://lore.kernel.org/netdev/20221122121048.776643-1-yangyingliang@huawei.com/  
>> 
>> I just had a call with Ido. We both think that this might be a good
>> solution for -net to avoid the use after free.
>> 
>> For net-next, we eventually should change driver init flows to register
>> devlink instance first and only after that register devlink_port and
>> related netdevice. The ordering is important for the userspace app. For
>> example the init flow:
>> <- RTnetlink new netdev event
>> app sees devlink_port handle in IFLA_DEVLINK_PORT
>> -> query devlink instance using this handle  
>> <- ENODEV
>> 
>> The instance is not registered yet.
>> 
>> So we need to make sure all devlink_port_register() calls are happening
>> after devlink_register(). This is aligned with the original flow before
>> devlink_register() was moved by Leon. Also it is aligned with devlink
>> reload and devlink port split flows.
>
>Cool. Do you also agree with doing proper refcounting for the devlink
>instance struct and the liveness check after locking the instance?

Could you elaborate a bit more? I missed that in the thread and can't
find it. Why do we need it?
