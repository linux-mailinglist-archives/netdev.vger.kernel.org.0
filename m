Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DA755E0BE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiF0InY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 04:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiF0InX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 04:43:23 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5053F631E
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 01:43:22 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o16so11970539wra.4
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 01:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eIaHt431DOTF+WVJZjV+oZtpFuSBBOgymS2pDU1Ycis=;
        b=hy2wqZBYHUz+ndHgsyYs12mpGOz7Lebf0SlALDIhJk6V1WSJ78VID+5gWHXfLbNfFi
         ajm0Ge1SgNXf1pCt2iJXIyU8gRb5+xaBbxD9qSQCIdk9zoxyM+umePqP/pggawC0jlAK
         yObrBb8kBwEwqdjWRnHjGb/w5TUcLQCB2FF0/3vGBGq0O/5T3fyJQ2KXSX5rRm1k1gLG
         vw7RDKhfNFB15+VhyfHlie53242NUTxLqT/f/pquhCnkZPnTKo5oRvNXbvtVeqxC9v4F
         4A1xBQvoDsZ/8dyaZYKiBG3EekVRa1hYjRWwyqM5yQLmMZqEO8jgoz1Fi3ZxAcSXUnxD
         E4vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eIaHt431DOTF+WVJZjV+oZtpFuSBBOgymS2pDU1Ycis=;
        b=m6tb6u7d5OtQbLIMlQdXzHPbFpqydOUg/4FYLFY6TLcNrTXgDzpQlTiwkwolKK3BaK
         I7fOhiJ5nBLaGHPhjpef4KFjq1bCrOJkGWc0bJibc0aOjTLaw/puBQFHLbuWwS/yuH+W
         yexEJrQkycPeTfBCGas9wUacqKvR82vKHNaii9+DDz47JDFiyoPE2VO+1aP41tiuA1Dm
         mcrkTJck6YiNCL4pZYec7C8xBWdDytmUAbfRmIUbs5KvcyPh7IZPwvTwxb+6dtAM9lDk
         idnAcjqllHk1PCNN3KBDzGKWW2eIXDr2DsPLkGPIKX97tDzM+rwvcwQ5Bfi6s0xrzq7H
         76Gw==
X-Gm-Message-State: AJIora9sZcJRN8ez2zmjfEXSNSWFCXmwf+pyhAHRxt0LKUnhgLFpTU3F
        KA9kx3AZOLmXUjpWhbG1ENACwA==
X-Google-Smtp-Source: AGRyM1tHs5uOPHQREvn2AcvaHEt+Oz8ixsTfp7wwjk8RqBKUTxU2k2uiJtUIh9ojWskK9lf1N2ZdJw==
X-Received: by 2002:a5d:44ca:0:b0:21b:8998:43e7 with SMTP id z10-20020a5d44ca000000b0021b899843e7mr11514146wrr.613.1656319400727;
        Mon, 27 Jun 2022 01:43:20 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bg21-20020a05600c3c9500b003a046549a85sm6423477wmb.37.2022.06.27.01.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 01:43:20 -0700 (PDT)
Date:   Mon, 27 Jun 2022 10:43:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com
Subject: Re: [patch net-next 00/11] mlxsw: Implement dev info and dev flash
 for line cards
Message-ID: <Yrltpz0wXW35xmgd@nanopsycho>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <Yqmiv2+C1AXa6BY3@shredder>
 <YqoZkqwBPoX5lGrR@nanopsycho>
 <fbaca11c-c706-b993-fa0d-ec7a1ba34203@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbaca11c-c706-b993-fa0d-ec7a1ba34203@pensando.io>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jun 18, 2022 at 08:12:20AM CEST, snelson@pensando.io wrote:
>
>
>On 6/15/22 10:40 AM, Jiri Pirko wrote:
>> Wed, Jun 15, 2022 at 11:13:35AM CEST, idosch@nvidia.com wrote:
>> > On Tue, Jun 14, 2022 at 02:33:15PM +0200, Jiri Pirko wrote:
>> > > From: Jiri Pirko <jiri@nvidia.com>
>> > > 
>> > > This patchset implements two features:
>> > > 1) "devlink dev info" is exposed for line card (patches 3-8)
>> > > 2) "devlink dev flash" is implemented for line card gearbox
>> > >     flashing (patch 9)
>> > > 
>> > > For every line card, "a nested" auxiliary device is created which
>> > > allows to bind the features mentioned above (patch 2).
>> > 
>[...]>>
>> > > 
>> > > The relationship between line card and its auxiliary dev devlink
>> > > is carried over extra line card netlink attribute (patches 1 and 3).
>> > > 
>> > > Examples:
>> > > 
>> > > $ devlink lc show pci/0000:01:00.0 lc 1
>> > > pci/0000:01:00.0:
>> > >    lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
>> > 
>> > Can we try to use the index of the line card as the identifier of the
>> > auxiliary device?
>> 
>> Not really. We would have a collision if there are 2 mlxsw instances.
>> 
>
>Can you encode the base device's PCI info into the auxiliary device's id

Would look odd to he PCI BDF in auxdev addsess, wouldn't it?


>to make it unique?  Or maybe have each mlxsw instance have a unique ida value
>to encode in the linecard auxiliary device id?

Well, which value would that bring? It would be dynamic random number.
How the use would use that tho figure out the relation to the mlxsw
instance?

>
>sln
