Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A2357FB17
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiGYIRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiGYIRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:17:23 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51A313CDA
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:17:21 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d13so7178081wrn.10
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=plwj0SFeQQOBUB0dRP2yOGK0PA3u7vtSex6F23sBEqg=;
        b=L+k10AamdU+6H60Ns4ryGGehA6ecOqhx5dcJJL6equZ/epoTTUn+yTSBxll/DwMOs8
         94ZjlzWr/3hHlMuIq4Y/NTneiQZf15cRHRSH/MzuUxjSRK8sPTH6ZOniySYLmnU1NHsi
         8vrERcOQZfHBAIoHNjR32lbhAJeUfr020kymkZk4a385sfCqr+YGP4RmCF+eE+Ffsqeq
         W8iRc/QZFMaiyZBBsT16bjsn/jPMy8ezUogyuc0KMYs/ch6KP7RjmskOQJ+PMJrXXbuy
         5kQ7EdKhfTQA9kH+d0+ZMO5JWrB9RZ+ZyNMYGJH1VJr/3DCTe1a2HcZ5iJNWBzVIw2kB
         yQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=plwj0SFeQQOBUB0dRP2yOGK0PA3u7vtSex6F23sBEqg=;
        b=pZSAkF4rNW9/aHqpeEdnu7Mh5SkHUC3hxrzd+ynaQx19hjfeKDmhVqk+0EkcJF1E9q
         or9Q++qPiV8zdwKb4AacmtBYTvvYi3tYCfNginUfuhoq2yMJtxzPWOEASfyq59EqShb3
         4A9JRmE/RGJZyi4ybEaJORwvidnIFGLFBAuUvKP++ED5dyQoFEQFX9movKD2jlysvBW2
         zwSc6ptvCcBnq8D1Ge48iULAqwAzpBbzhOlYLWYdGBYLIJtL/yBw9UIzzOk863yrdvv6
         NEdqB8KedVfhTxHLFk7aFCi3hUffjvLIuy/Df6RatkDFJ7wJzcDPvVcKxgv4DVsmukFC
         mEqg==
X-Gm-Message-State: AJIora9Qgue6fW2BcT6AMaHTGjnkeFLScm96BfkJSOJkvrWHLnRHKQBs
        GX2LBNGhUSaOdnss2INILvAlxA==
X-Google-Smtp-Source: AGRyM1tBGYRF9WUG62K0ax6MqQ99n+7iNQU6HZVbGC/1XxI2rG8MHKdw3QTqubQvIH8/sVG99wakLQ==
X-Received: by 2002:adf:e84c:0:b0:21d:83ed:2ce with SMTP id d12-20020adfe84c000000b0021d83ed02cemr6827269wrn.582.1658737039981;
        Mon, 25 Jul 2022 01:17:19 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f5-20020adff445000000b0021e5f32ade7sm7916700wrp.68.2022.07.25.01.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:17:19 -0700 (PDT)
Date:   Mon, 25 Jul 2022 10:17:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <Yt5RjrqG1WZelSOH@nanopsycho>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-2-jiri@resnulli.us>
 <20220720174953.707bcfa9@kernel.org>
 <YtrHOewPlQ0xOwM8@nanopsycho>
 <20220722112348.75fb5ccc@kernel.org>
 <YtwWlOVl4fyrz24D@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtwWlOVl4fyrz24D@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 23, 2022 at 05:41:08PM CEST, jiri@resnulli.us wrote:
>Fri, Jul 22, 2022 at 08:23:48PM CEST, kuba@kernel.org wrote:
>>On Fri, 22 Jul 2022 17:50:17 +0200 Jiri Pirko wrote:
>>> >Plus we need to be more careful about the unregistering order, I
>>> >believe the correct ordering is:
>>> >
>>> >	clear_unmark()
>>> >	put()
>>> >	wait()
>>> >	notify()
>>> >
>>> >but I believe we'll run afoul of Leon's notification suppression.
>>> >So I guess notify() has to go before clear_unmark(), but we should
>>> >unmark before we wait otherwise we could live lock (once the mutex 
>>> >is really gone, I mean).  
>>> 
>>> Kuba, could you elaborate a bit more about the live lock problem here?
>>
>>Once the devlink_mutex lock is gone - (unprivileged) user space dumping
>>devlink objects could prevent any de-registration from happening
>>because it can keep the reference of the instance up. So we should mark
>>the instance as not REGISTERED first, then go to wait.
>
>Yeah, that is what I thought. I resolved it as you wrote. I removed the
>WARN_ON from devlink_notify(). It is really not good for anything
>anyway.

The check for "registered" is in more notifications. I will handle this
in the next patchset, you are right, it is not needed to handle here.

Sending v4.

Thanks!

>
>
>>
>>Pretty theoretical, I guess, but I wanted to mention it in case you can
>>figure out a solution along the way :S I don't think it's a blocker
>>right now since we still have the mutex.
>
>Got it.
