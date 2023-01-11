Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F195966578D
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbjAKJeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238698AbjAKJdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:33:47 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400612AEB
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:32:17 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id q64so15281861pjq.4
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oS80I8J72yZCr89Pq9CT4N/7c8E1AClLIxFHz/sEIo8=;
        b=IkIko5oiVnteFQRwAJ0nD7E4JMkej9tbP3x0aB+djHd0jHiNa0YFToh9UsZWJ9Qjx/
         jd8cIKnw0TgwxMBiT6hZI9j81s3YHvujWl9saROqnB6/uhHVXKiT6NSD+MjkzatVzTjF
         kXsTgrqB+hV6jOAOcSKBpA5AanjBF09cOoe8mz1nL/XUZHnWCppy9qZqbio3Z14meTMr
         WWc4xwMfdn3Iwih3gqxn1yZpwRiS0eEYZQkmlpEeS7H22PegeUkyR44/01+gmFVJ6Oea
         YjDh4HFu9Y0N0FdZov5MO9vZB+0Y3YJWSlUqYWAUkK6OF1m8H3mAi9LAjMkCpcbTV77p
         uM4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oS80I8J72yZCr89Pq9CT4N/7c8E1AClLIxFHz/sEIo8=;
        b=k8X347j56f52DtMywGNDDRochk9w2kaqNABo6EOZZVBYlBheMB5nSWcgsUBPTrmZWn
         BwciHeHXOTlIYbGzRFWlnMrycfw/hsDxuRmuyp3OqdzhUWabZMC1HIQhyE/Zzip2CtUW
         gTkyyCyys9lmxMfxecQ89fjUUlZPcmRRcrBXComyGqWVG/Rdw8xHj7g3FmcTPxCHf9ah
         QCofEy56O0/aGxLTTA3r2SOmo2zErM5rChxQ0j6JRfC2uq7juRzLYtxeO0LU/4JeJ1q5
         lRH0UY2VZzR4Tp6sdsFituntGjKDKKagvCj1Kk1XEVBYO0bkhkhS3W80qdFNMQfpCkD+
         wY5w==
X-Gm-Message-State: AFqh2koreM3/nBAO05xQ/fYR3Z40bgAz3CQ5seY4Cu8YdsrhH6kazkRw
        8Du36hGrD+Uqx5+7A6EZ9acZWg==
X-Google-Smtp-Source: AMrXdXteL1NeK/Uz74IMCNrPwTN6/kzhM8SRrpD7WQFMWzvZAkyBscDAmDVRsGyYRpG7RDQy4W9GvA==
X-Received: by 2002:a05:6a20:4e15:b0:ac:31c7:9d7 with SMTP id gk21-20020a056a204e1500b000ac31c709d7mr1713251pzb.52.1673429536803;
        Wed, 11 Jan 2023 01:32:16 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id t18-20020a62d152000000b00580f445d1easm9438013pfl.216.2023.01.11.01.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:32:16 -0800 (PST)
Date:   Wed, 11 Jan 2023 10:32:13 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y76CHc18xSlcXdWJ@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-8-kuba@kernel.org>
 <Y7gaWTGHTwL5PIWn@nanopsycho>
 <20230106132251.29565214@kernel.org>
 <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
 <Y72T11cDw7oNwHnQ@nanopsycho>
 <20230110122222.57b0b70e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110122222.57b0b70e@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 10, 2023 at 09:22:22PM CET, kuba@kernel.org wrote:
>On Tue, 10 Jan 2023 17:35:35 +0100 Jiri Pirko wrote:
>> >I did find it convenient to be able to do both pre and post-registering,
>> >but of the two I'd definitely prefer doing it post-registering, as that
>> >makes it easier to handle/allow more dynamic sub-objects.  
>> 
>> I'm confused. You want to register objects after instance register?
>
>+1, I think it's an anti-pattern.

Could you elaborate a bit please?
