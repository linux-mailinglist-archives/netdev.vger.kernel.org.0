Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329745BA413
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 03:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiIPBjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 21:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIPBjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 21:39:19 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FDF4054F
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 18:39:15 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id s18so14090353plr.4
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 18:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4olRgDhsI5nQOVJRspipuq+EQBZGo/q5MF/2KuVRJ68=;
        b=Eg+tA2FUwxcK4ZmdF/9OJ3DPGYDU4c7pAre27wWFT3pCP4Cj8uOdE7yamhW/ZQCa3O
         CiDBfDJvoGUwgaI97DBjGa3xEY86n/B8rqveQpr2Neybjr10kuxV8SJdCKiQgg6Dvu0W
         M3oVJEA3F9EsHIyR6k5YJ3pt+cSjJM0QVZ97pPEJnvqPmjBrtbmHKgpG7CfpPEYq3wsx
         9BKmspu6zF0vU4whQWfNQlw+LO+XzVrAmHGLALTfQIkOG1gu46V2n9iMs/3WOvCDDaIF
         OLnGU8jnFspcyOBtpPsESnd0VxlhvFgWdEoYlGiV24Zj+xMLdVgjl/bChO1URRVk1mxi
         rFQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4olRgDhsI5nQOVJRspipuq+EQBZGo/q5MF/2KuVRJ68=;
        b=M1p1/mK8GzX0PXnrIA3CiZRsc5UlTUKRj4VXjU7ulwDTmhvHW0GqZy+5pjaJFKbTTx
         u1Dm2yfsw9D5cl9bNsH7AWzs1AIqyUABOpfFYZFJ3s3lb0AXZoCfuH0Tbo9IWi04sUbd
         HDIabFZhs3XxuYnnTumkxIE11pm93xdm05Uc7ITtlGwaY1bFX9UFZMKgoZLW37YxctmW
         PsDZ47TQq+XFSf62Fifii6LnqA02JXbwAkXPSkcboNNltRAG+4E7zIMKwRCk1w/6Jhn4
         AOYfzeNC0JIgiJuRGbcnkEpA6Bo7zITixLgdfRPq6fqgmVh26+gFdXLP4h7ueG0tWkcW
         ISug==
X-Gm-Message-State: ACrzQf2hNLKsm5AwYZGV8T9Aaf/kG41yJ5P8w6QlpkpQEvG/rhM50m4n
        WDNg+ghh3ucywk6IEUWYkxGHddbTmQUioQ==
X-Google-Smtp-Source: AMsMyM5HD3b5wSg6BgSyv+XwecWxuQPVWcYjDFsKoWbuNh7+p2/gHVbqDJJ0QVWbldHIOvu0fa115Q==
X-Received: by 2002:a17:902:ef50:b0:170:9f15:b998 with SMTP id e16-20020a170902ef5000b001709f15b998mr2297081plx.102.1663292354908;
        Thu, 15 Sep 2022 18:39:14 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l6-20020a170903120600b00176677a893bsm13870963plh.82.2022.09.15.18.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 18:39:14 -0700 (PDT)
Date:   Fri, 16 Sep 2022 09:39:09 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>
Subject: Re: [PATCH net] selftests/bonding: add a test for bonding lladdr
 target
Message-ID: <YyPTvVzFWoVdf3D8@Laptop-X1>
References: <20220915094202.335636-1-liuhangbin@gmail.com>
 <970039e7-1c13-e6d7-cb70-53af92eb9958@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <970039e7-1c13-e6d7-cb70-53af92eb9958@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 10:09:05AM -0400, Jonathan Toppins wrote:
> On 9/15/22 05:42, Hangbin Liu wrote:
> > This is a regression test for commit 592335a4164c ("bonding: accept
> > unsolicited NA message") and commit b7f14132bf58 ("bonding: use unspecified
> > address if no available link local address"). When the bond interface
> > up and no available link local address, unspecified address(::) is used to
> > send the NS message. The unsolicited NA message should also be accepted
> > for validation.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> Acked-by: Jonathan Toppins <jtoppins@redhat.com>

Hi David, Jakub, Paolo,

I saw the patch checking failed[1] as there is no fixes tag.

I post the patch to net tree as the testing commits are in net tree. I'm
not sure if this patch should go net-next? Any suggestion?

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20220915094202.335636-1-liuhangbin@gmail.com/

Thanks
Hangbin
