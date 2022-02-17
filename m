Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEB44B9578
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiBQB0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:26:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiBQB0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:26:06 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F9D2A0D4A
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 17:25:53 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id l19so3677933pfu.2
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 17:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+619F6UacS3FbkkNMbsN7cTPEX+VxrRPyLNfw4lOdq0=;
        b=nAKfLKGap19KmidpC9uqf+5gNyW110ZlIwlOaiFHKL+5uyWVO7T6E+WCNGEKJj8d5m
         sadD08gONkP6vToNtR4axn6BLt3DesGoCgb10PpsjRBkEIGrIwgKGQSNzzECtD9pIruZ
         ciTZKOn7+HP+nArRrq2JQ1MXKb9Bgnoyf0Lji+peylWxlpXRdisn14qSamgnZpHmkVsk
         jWG68rCop7Xv8fq53FEcIQnSwnyB8y789Chgb8T2vxT6UOCnkUK/4DlkwQGzv6+1JhXZ
         l8KcZ1SjDAMgu2a0ldzEo8yciJVthZEGQnFE/lCS2lTdDvoAhAHG7J7ZMQsI1CqFDU+T
         6MMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+619F6UacS3FbkkNMbsN7cTPEX+VxrRPyLNfw4lOdq0=;
        b=fqp/+w8WWn804mIfO9+jCTCjPdQAn9ytHWy8gBHm1PyF/H07pnKbU/qBR64HMBoP8B
         nLDeF/Q8dxarHgYayd91AdtQdV/tF6vHZzo70e9fyNI3qLHxZuRsY8PfgCls3P5dak0I
         h20dubUQ9MB06Sm8vNx0GZ2VjzkvQV0NDsbgW3zBID7nJAmvXhYtRGWP+Wrh0GkfGFAe
         7lYWWa/wrwCsTdK7AIHhHwdxK8lFlmGVQrSLL8eGoLnFB6x+umAy6fq+Lzv0gi7ajaEf
         bsUOwaquEcCwwQzf0peDs3/Z1mCmZsXUmMcoGIhP+Tiq7V7p+rv/VOpbkJQRzx5MZ7fX
         smaQ==
X-Gm-Message-State: AOAM532TvyYV4XNRovQKlck2z6mpOlmGZcky3ucwesdHf4MF56lkaem5
        ulq/n8mLiBqRRfjtmJsf2q8=
X-Google-Smtp-Source: ABdhPJwBEhjFzsx8GiiAl6fMii1q8iAPq35CZBVg+Q49+PZAlbjXh9hcIwnBp9qToW514pR3mP9Zmw==
X-Received: by 2002:a63:2142:0:b0:35d:a95f:d1e9 with SMTP id s2-20020a632142000000b0035da95fd1e9mr549335pgm.237.1645061153188;
        Wed, 16 Feb 2022 17:25:53 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d15sm44373635pfu.127.2022.02.16.17.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 17:25:52 -0800 (PST)
Date:   Thu, 17 Feb 2022 09:25:46 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>
Subject: Re: [PATCH net-next 5/5] bonding: add new option ns_ip6_target
Message-ID: <Yg2kGkGKRTVXObYh@Laptop-X1>
References: <20220216080838.158054-1-liuhangbin@gmail.com>
 <20220216080838.158054-6-liuhangbin@gmail.com>
 <c13d92e2-3ac5-58cb-2b21-ebe03e640983@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c13d92e2-3ac5-58cb-2b21-ebe03e640983@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 09:38:31AM -0800, Eric Dumazet wrote:
> 
> On 2/16/22 00:08, Hangbin Liu wrote:
> > This patch add a new bonding option ns_ip6_target, which correspond
> > to the arp_ip_target. With this we set IPv6 targets and send IPv6 NS
> > request to determine the health of the link.
> > 
> > For other related options like the validation, we still use
> > arp_validate, and will change to ns_validate later.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >   Documentation/networking/bonding.rst |  11 +++
> >   drivers/net/bonding/bond_netlink.c   |  59 ++++++++++++
> >   drivers/net/bonding/bond_options.c   | 138 +++++++++++++++++++++++++++
> >   drivers/net/bonding/bond_sysfs.c     |  26 +++++
> 
> Thanks for the patches !
> 
> Do we really need to add sysfs parts, now rtnetlink is everywhere ?

For Bonding I think yes. Bonding has disallowed to config via module_param.
But there are still users using sysfs for bonding configuration.

Jay, Veaceslav, please correct me if you think we can stop using sysfs.

Thanks
Hangbin
