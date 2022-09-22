Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B79D5E5F91
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 12:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiIVKON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 06:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiIVKNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 06:13:50 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3813ED8E3E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 03:13:40 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id l10so8325674plb.10
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 03:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=OfnB2AmdGYyOW3nmaqtcCAjUJ5qi2LxKoHjSUIC7aCo=;
        b=Sz7xFd5Qe+1pgVAkO1Ay8aw3+p3yxqHMuEXRDZA73RrMiqg4yQDJaf9lj2FVApivHE
         cKdoNRzAxy3GwwmN0crEuIt1+ys/nHqln4J6W/M8jRcDAeU4iwZ6tE+XQV/6bU6hKDa4
         zAy6MLEudluW+QnQ3yvAW8OJ3I6+nFtz6czd9xXwgiCvlwJb6GKpQ7dr1ITTDxXwLgjz
         Af+v+VLruIXiuwcFbwi1njDzQ1CKM8d+jmuo1tz021pFA6niv+g1MGDJ5/mN2zNU2I2l
         xtNw3WwCqaOjWgImb/hQLH4dUiTeHEaQ10Y85vOU8SPR0R52QCZJ0s/O+QwexkfmKsGQ
         EQbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=OfnB2AmdGYyOW3nmaqtcCAjUJ5qi2LxKoHjSUIC7aCo=;
        b=BGDoCToJAXl0iOQfGBI1P2OEwcwD1uMTxt8slSMmO7W3pHGuJlZ0iqG4D2Q6BV+Wcy
         lVILQ0UuZYyXKU6rfyeULSCdqt6cuqhKcrWjmp1bU0KILuBCuZRpZ841QLCS93lXM47z
         MVaPefFLMQ3J26PZ4SHfuuqZJFN7E8a9/Ckf/EXB8J4m8U71JyMU7yRoqunCtXI58HzY
         sPjw5tM0OS264H55MXxoM/xz903lPohpH3X/64vEgcUnyBXMNIbAUTDrpeYHVBIPg+jV
         lhLePy8w1UUCj5rfD9dcToHoZCeYFdrJc5KrFNgbwyDY/4N/YC9290hnJ2lB0m1I4cKn
         m1RA==
X-Gm-Message-State: ACrzQf3InuzUThLrGJHxVYszhF/l+Nj+241tFrmP36pZqfa+JoVwWxDh
        xFiGrN5wNTpSCdP2nmLpzTo=
X-Google-Smtp-Source: AMsMyM5Y28Rbb6d+T+RMNm1vPPEXjT/EKMjxgmvpJwCW2vFghwGlBuCruY/4aBxEMlzOKeCKf+8NsQ==
X-Received: by 2002:a17:90a:9281:b0:203:19a9:e57e with SMTP id n1-20020a17090a928100b0020319a9e57emr14512077pjo.97.1663841619697;
        Thu, 22 Sep 2022 03:13:39 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ij29-20020a170902ab5d00b00172e19c5f8bsm3676086plb.168.2022.09.22.03.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 03:13:39 -0700 (PDT)
Date:   Thu, 22 Sep 2022 18:13:33 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Guillaume Nault <gnault@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new,
 set}link
Message-ID: <Yyw1TRSMRUbmOOtK@Laptop-X1>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
 <20220921060123.1236276d@kernel.org>
 <20220921161409.GA11793@debian.home>
 <20220921155640.1f3dce59@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921155640.1f3dce59@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 03:56:40PM -0700, Jakub Kicinski wrote:
> Looking closer at the code it seems like what NLM_F_ECHO does in most
> places is to loop notifications resulting from the command back onto
> the requesting socket. See nlmsg_notify(), report is usually passed 
> as nlmsg_report(req).
> 
> I guess that answers Hangbin's question - yes, I'd vote that we just
> pass the nlh to rtnl_notify() and let the netlink core do its thing.

Thanks, I will update the patch by using rtnl_notify().

> 
> In general I still don't think NLM_F_ECHO makes for a reasonable API.
> It may seem okay to those who are willing to write manual netlink
> parsers but for a normal programmer the ability to receive directly
> notifications resulting from a API call they made is going to mean..
> nothing they can have prior experience with. NEWLINK should have
> reported the allocated handle / ifindex from the start :(
> 
> The "give me back the notifications" semantics match well your use
> case to log what the command has done, in that case there is no need 
> to "return" all the notifications from the API call.

I didn't get what you mean about "no need to return all the notifications from
the API call"? Do you ask for some update of the patch, or just talking about
your propose of NEWLINK?

Thanks
Hangbin
