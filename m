Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4181C65FD09
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 09:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjAFIr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 03:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjAFIrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 03:47:25 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FDD59FAA
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 00:47:23 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q64so895931pjq.4
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 00:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IqHOi8Sl/nmR2NWGg9FDs3mLqoQExThKgVwHJWOV7X0=;
        b=WCRgN6PMcCm7DVAtW6XUEVY5cfFvpqJtEo00HaSV1e2Bp9YsG6hYqewZOY/K4oXK4x
         UG9GuPGVitT4fEQvA705BphyryP0c3wrmsLH18Gg5erOTFvdD4zWj9F5MD2bY9qkMLkT
         bjbkSZuJ4bUD0v7IiIDz3FAkdTEcxxA/5odonZ2kjDAyAXFNl2QnVskysS4E1BdFEArI
         pH+J/Tn0eh5bCrnU1MFXxlGPeFdqeREsVBPFlfYjLSFXZLxjp4JGVmyivq5sjVYH5hqV
         b5AN6y6o4J0eVCRWRfDZD4FuTns1rnV03wjDBVe9ZfZx+uCvIFB0ZjcEk/xU5dNI5Kle
         pKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IqHOi8Sl/nmR2NWGg9FDs3mLqoQExThKgVwHJWOV7X0=;
        b=tbHR/VrxXFWMjYU+gDbYLy6+ZaayvNpGdo7TKrbfDVYa+nRcX4hv5xtYFBR4XaUqmR
         XEoL5s73+EibOab8qAPkqvTQbOnYpGYO6Sw68r6fBtDlzxTjxMjebmTLe9yy/9OIYkGy
         FeUNcuT+B2B7RUR6dElVL54+PFlMn4D7SJwPYi9IFR45+KrjXCe1oxTnK7qfBjPLm+bP
         F5U3ucjUxsLr8vHvwb65kcFXLyvGW6O264hfrYI+hfCmeMK0c2S/S67JFaW+Fs9SdjBb
         Q6ylX1Gyuz5r+2AnIRnxsw5DegIaDwtDL2XjupClmVNAsgTXbR2P6hN7mdLd6rI/9Il3
         4lsA==
X-Gm-Message-State: AFqh2ko/Rgi49+3cyrDy2HBiIOqyfK4ikNPlhcz2zBXAgz7tquBAy3Tc
        ePLPi/37EWOxXuoPaMHuNs8EOg==
X-Google-Smtp-Source: AMrXdXuqcvC0DZp3jAxgixbB5j/YsJF2YYzVXcUnX2QT3KW+f0sMj4RyR5Mc1kziDSnMYiCmhpPy0A==
X-Received: by 2002:a17:90a:9709:b0:219:756c:e09 with SMTP id x9-20020a17090a970900b00219756c0e09mr57019927pjo.29.1672994843065;
        Fri, 06 Jan 2023 00:47:23 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id u14-20020a63ef0e000000b0046feca0883fsm491669pgh.64.2023.01.06.00.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 00:47:22 -0800 (PST)
Date:   Fri, 6 Jan 2023 09:47:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 03/14] devlink: split out netlink code
Message-ID: <Y7fgF5RQDq3b77Es@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-4-kuba@kernel.org>
 <Y7aSeZqr9MYYgeoU@nanopsycho>
 <20230105102058.2e74c9a6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105102058.2e74c9a6@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 07:20:58PM CET, kuba@kernel.org wrote:
>On Thu, 5 Jan 2023 10:03:53 +0100 Jiri Pirko wrote:
>> Wed, Jan 04, 2023 at 05:16:25AM CET, kuba@kernel.org wrote:
>> >Move out the netlink glue into a separate file.
>> >Leave the ops in the old file because we'd have to export a ton
>> >of functions. Going forward we should switch to split ops which  
>> 
>> What do you mean by "split ops"?
>
>struct genl_split_ops

I see.
