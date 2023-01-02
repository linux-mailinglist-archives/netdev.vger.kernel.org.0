Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01E765B344
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 15:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbjABOSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 09:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjABOSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 09:18:52 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D0D2DF4
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 06:18:50 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id bi26-20020a05600c3d9a00b003d3404a89faso15130322wmb.1
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 06:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1KCZT/GmDvYNwGPx8XH6qfnYshf16h+qKmWX29v0gJY=;
        b=QUsV2brYMOOU/z71XplA75og6w/vD74RBFUXt9X72aho6Rc5oeCSaNQelbI2g6ipiy
         d1+BtTtSUcCO6nUbKjcGoKksOAn84HEkJ3vYY9QvIGRiOJoZqnZ/R56ivESvj4m5jB22
         lgn8M7hkxSG0Ua2eMltM4XbXMCyhJ/6wpy2TtbgqGkA/b1pyQA13aT3oy6vA5ufYAD+k
         eoQSI3sgdW/Fb1U/p+XiC7a7XqYgbB48dhzEA1tXTzW+Iyiy9BUVoanPJdcOIEApoaFp
         Tf8vZBjMQFFF0on3SOyszJFDBIOTENaDCtlcwfOMLewIm0KDylMKp5TGkvd/jWfhjMu5
         ucFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1KCZT/GmDvYNwGPx8XH6qfnYshf16h+qKmWX29v0gJY=;
        b=fRObk+DyCx02yYea2P1iuXdBOyBFn7Nn8JVxN06/jpkyzchQzXvAVUdYBSz4O4QC1d
         eVB1cBgmssR+d8kjGJ8svlNN4knPN0jk+fwfnsQFiYyrgytrY8fHJuxON3n0J8nZj6f7
         IG9ex8WGzkaKV3uJ8FkOhwPq31Vnh19sQ2X01dYb9+7BOs+GCZXJYCkFy2tz/z1NASx6
         z7STTH2IJQOGIWp2PixQgVseNqOrmsnVTPMpvN2SSWFalqlUchfuCt2Hn0vEoxCtHY22
         c84fqSMN1yfbGKhO/l2VvnJWOI/Pa8i9PO1HLj2Z/K9dZ1jPsgzesnsEp/AY3ioxmP3q
         dNhA==
X-Gm-Message-State: AFqh2kr6Fui9recn8ev7tAt8eKc84ocjUoBoFCJRha8/F1lG+gp9DCkj
        lExBZYy/Y3XGtu8xkLxekirwsHn4dXYPeOXeXUNhBA==
X-Google-Smtp-Source: AMrXdXtcnqyfq05nyAKi6/ab5ekoZIieRvHshwcxTcIeqxBB+C6uiX+hDfeAPlFnb6oDCw1FOE1gaw==
X-Received: by 2002:a05:600c:354b:b0:3d0:4993:d45b with SMTP id i11-20020a05600c354b00b003d04993d45bmr29920633wmq.4.1672669129426;
        Mon, 02 Jan 2023 06:18:49 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c199100b003d99da8d30asm17023048wmq.46.2023.01.02.06.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 06:18:48 -0800 (PST)
Date:   Mon, 2 Jan 2023 15:18:47 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, leon@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC net-next 05/10] devlink: remove the registration guarantee
 of references
Message-ID: <Y7LnxzyikpKqNH1R@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-6-kuba@kernel.org>
 <ac6f8ab5-3838-4686-fc20-b98b196f82c8@intel.com>
 <20221219140210.241146ea@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219140210.241146ea@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Dec 19, 2022 at 11:02:10PM CET, kuba@kernel.org wrote:
>On Mon, 19 Dec 2022 09:56:26 -0800 Jacob Keller wrote:
>> > -void devlink_register(struct devlink *devlink)
>> > +int devl_register(struct devlink *devlink)
>> >  {
>> >  	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
>> > -	/* Make sure that we are in .probe() routine */
>> > +	devl_assert_locked(devlink);
>> >  
>> >  	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
>> >  	devlink_notify_register(devlink);
>> > +
>> > +	return 0;  
>> 
>> Any particular reason to change this to int when it doesn't have a
>> failure case yet? Future patches I assume? You don't check the
>> devl_register return value.
>
>I was wondering if anyone would notice :)
>
>Returning errors from the registration helper seems natural,
>and if we don't have this ability it may impact our ability
>to extend the core in the long run.
>I was against making core functions void in the first place.
>It's a good opportunity to change back.

devlink_register originally returned int. Leon changed that as part of
his work. I believe I expressed my negative feelings about that back
then. Sigh.
