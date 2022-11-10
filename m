Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86D5623CF5
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 08:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbiKJHyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 02:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiKJHyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 02:54:23 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979B2631D
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 23:54:22 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id z14so1035351wrn.7
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 23:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j83EA1TAQEaL6GbH+V4RzzvEapdXttc/TC/2CKxHp/A=;
        b=L7CpkoqWm0HIX8rB2P0Z7w6otNsPf1zhWkuZnq6M8HZX3sNxgftYT+GQ3G24U18Zwo
         7LGuXGd0BLsAsvys9zTlPzodVK/QSUINyYmmvyhnakFgRYzhKo5PAQVHQRpyz9Sk4X3L
         VEFG7XlLPMaUbKsFfbRxEEHGAQ18C48T7qc21/8oIFaFEXtLTAMeXDG1aqm3CnHi0ygc
         pM8UPbQDvVgHGo9vbhMZM5lbPHLVaJ3G4itwQ67oEN6vWSKYIDq+vTyDzLnuEs8zZots
         F3GTkwLYzXHnP5Z2iufl1fEKesdIIm817Vp3thQ49n6mOLnvDI2aH0YpqdtsAReeCWL+
         ddrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j83EA1TAQEaL6GbH+V4RzzvEapdXttc/TC/2CKxHp/A=;
        b=suVzfQpEDdaMGNB+9uu0Ui6BH0M7XMxAW4Y/w/b3nkwTtQlTcmoR+ERAzoHqNg04g3
         g1S7ek7Aq1enCbDb14X4qh7JkSeSJ3qfLd8wqWyCHA2h2JIJH6XD2z5nQE39zUlm+Oyz
         eydBsV8NWXPJUfJPNjVpt2jKkWbrsGC1MwFq7Cg6no9ZzBAK1UdspDMbdx5z8E9LmbxC
         nhTdXnss1rZphi5W65+1cYMUWPu9nG5e+oGdjRSTz2Brar7MOmyS3on62nMqOC8dGc3K
         CX6MnynrPt7wD7lTXO2lHW4rJlOsFCawluDYCIPp82l3/hl6d14ZYLZB89ieuPDe4QgX
         AYYw==
X-Gm-Message-State: ACrzQf1QS8AaGLrb3PjLRL1OT0t5hyFNGpD04d3JxRuqVrBvkdYeZrOp
        nH12CfcqXZiaqFUL7oVJremjmdDRnATRgurD
X-Google-Smtp-Source: AMsMyM6uD4s7+o+IlokFwvGKU+w0eHDHCk9qc1XODGEdpu5nM8dZndfCl7FlKso8niMoZgVYWBLTRA==
X-Received: by 2002:a5d:6145:0:b0:236:a948:9e35 with SMTP id y5-20020a5d6145000000b00236a9489e35mr39526351wrt.185.1668066861173;
        Wed, 09 Nov 2022 23:54:21 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j7-20020a05600c190700b003b47e8a5d22sm4628519wmq.23.2022.11.09.23.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 23:54:20 -0800 (PST)
Date:   Thu, 10 Nov 2022 08:54:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: Re: [patch net-next v2 3/3] net: devlink: add WARN_ON to check
 return value of unregister_netdevice_notifier_net() call
Message-ID: <Y2yuK8kccunmEiYd@nanopsycho>
References: <20221108132208.938676-1-jiri@resnulli.us>
 <20221108132208.938676-4-jiri@resnulli.us>
 <Y2uT1AZHtL4XJ20E@shredder>
 <CANn89iJgTLe0EJ61xYji6W-VzQAGtoXpZJAxgKe-nE9ESw=p7w@mail.gmail.com>
 <20221109134536.447890fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109134536.447890fb@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 09, 2022 at 10:45:36PM CET, kuba@kernel.org wrote:
>On Wed, 9 Nov 2022 08:26:10 -0800 Eric Dumazet wrote:
>> > On Tue, Nov 08, 2022 at 02:22:08PM +0100, Jiri Pirko wrote:  
>> > > From: Jiri Pirko <jiri@nvidia.com>
>> > >
>> > > As the return value is not 0 only in case there is no such notifier
>> > > block registered, add a WARN_ON() to yell about it.
>> > >
>> > > Suggested-by: Ido Schimmel <idosch@idosch.org>
>> > > Signed-off-by: Jiri Pirko <jiri@nvidia.com>  
>> >
>> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>  
>> 
>> Please consider WARN_ON_ONCE(), or DEBUG_NET_WARN_ON_ONCE()
>
>Do you have any general guidance on when to pick WARN() vs WARN_ONCE()?
>Or should we always prefer _ONCE() going forward?

Good question. If so, it should be documented or spotted by checkpatch.

>
>Let me take the first 2 in, to lower the syzbot volume.
