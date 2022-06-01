Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F01539E43
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 09:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350334AbiFAHfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 03:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346357AbiFAHfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 03:35:09 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E77719C3
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 00:35:06 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id er5so941089edb.12
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 00:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ty7O53YsyHmR9XZszWr9+5E8bvXaLHnarWtMUeJeGqc=;
        b=rYtC/I+ubkn3cmGIImzDMseieo6R8RMcmEbAThYUh3803iCF9K5IWjOfoPqDhzQkay
         gKQsiVtOo4Z/4LdD80RK3FssztDS0ZT4v/UTUCoUYh+CNRm6P5RVyzqfV/vErmG5WLvv
         DugOP2eTrid/Re/hvMHCcnlNGZQ5R7/VH39YjFvXvlEOjpK5vhsunw+GUaJJ7Iz9mLXr
         CLchRFGLFxLKROdWquDd+mMWmXMZRmPtSzLyBFeyp1qH4gsQAmniK86Vujug0mh8YJct
         VPHCM/E964yvMzZ5+Qop8TlHLf9Fg63NUp4+mFV/j6qrap9q9SdRU8CIsT1zNkf4rs4b
         N6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ty7O53YsyHmR9XZszWr9+5E8bvXaLHnarWtMUeJeGqc=;
        b=J41s8kgqHuRdYreapwD2eB04m4S/pTUDsUaBPk2UmSVX5T/RGuIQrYmolkqMhTvMVe
         YCBzD/aNgiU2DKsKyCRBE6K8nXe8cQvr2I5+6AcSkXky7Dk6JfeMk1M6BtK9MSnlwthK
         l+x2XpcxcG/Ts7agwIYUi9h41YA0qwnrR4D09li4pQRZNwPw4wSnL5VpVJ7l5CWhizlE
         WxoIgJL3qxXBxGjagEFYNhRRsgggJPTwhmnqL2SLn9logz5H1NJIq5Iyteob5oLKGjNO
         iKZcTcFc4qTfop+3Ap/wLYSE/75AdzLnzagojVd9Q/1g5aJLmCnNSlGGIRa/tKPXKB2B
         n+GQ==
X-Gm-Message-State: AOAM5318mXZsqt94LUegsHzK716PAdxCHr6r/+s90nE1bWGOpIDcE5q2
        iyWdoDNqJsV8JPGICNsh6vOuBQ==
X-Google-Smtp-Source: ABdhPJwrEmbNmN0ee1MmU4NlHOwR8A2rutesA+61kpP9KBLtfODbFGCcQ2WmGWtHjSajvMoC+/sJeQ==
X-Received: by 2002:a50:a691:0:b0:42d:c66d:e7db with SMTP id e17-20020a50a691000000b0042dc66de7dbmr19694887edc.258.1654068905621;
        Wed, 01 Jun 2022 00:35:05 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id w7-20020a056402070700b0042aa153e73esm517549edx.12.2022.06.01.00.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 00:35:04 -0700 (PDT)
Date:   Wed, 1 Jun 2022 09:35:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YpcWqL5By3hU+AVP@nanopsycho>
References: <YpHmrdCmiRagdxvt@nanopsycho>
 <20220528120253.5200f80f@kernel.org>
 <YpM7dWye/i15DBHF@nanopsycho>
 <20220530125408.3a9cb8ed@kernel.org>
 <YpW/n3Nh8fIYOEe+@nanopsycho>
 <20220531080555.29b6ec6b@kernel.org>
 <YpY5iKHR073DNF7D@nanopsycho>
 <20220531090852.2b10c344@kernel.org>
 <YpZt0mRaeZqrp4gU@nanopsycho>
 <20220531154159.5dbf9d37@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531154159.5dbf9d37@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 01, 2022 at 12:41:59AM CEST, kuba@kernel.org wrote:
>On Tue, 31 May 2022 21:34:42 +0200 Jiri Pirko wrote:
>> And again, for the record, I strongly believe that a separate dl
>> instance for this does not make any sense at all :/ I wonder why you
>> still think it does.
>
>For purely software reuse reasons. I think the line cards will require
>a lot of the same attributes as the full devlink instance, so making
>them a subobject which can have all the same attributes is poor SW arch.

Sure, I understand the motivation.


>Think about it from OOP perspective, you'd definitely factor all that
>stuff out to an abstract class. We can't do that in netlink but whatever
>just make it a full dl instance and describe the link between the two.
>
>Most NIC vendors (everyone excluding Netronome?) decided that devlink
>instance is equivalent to a bus device which IIUC it was not supposed
>to be. It was supposed to be the whole ASIC. If we're okay to stretch

I agree, that is incorrect. That is why I was thinking about sort of
"alias" to make it right (2 PF devlink instances would be one connected
by alias). Not implemented yet though :/


>the definition of a dl instance to be "any independently controllable
>unit of HW" for NICs then IDK why we can't make a line card a dl
>instance.

Well, it is not independently controllable. Well, truth is, that in our
current implementation, there is one independent "configuration", and
that is flash burn of the gearbox. It is done using a "tunnelling"
register which encapsulates register communication what is done during
flash burning.


>
>Are you afraid of hiding dependencies?

Not really, I'm just not sure I see it is worth the excercise.

In czech, we have this saying: "kanon na vrabce". I think that the
following picture is better than any translation :)
https://i.iinfo.cz/images/72/shutterstock-com-kanon-delo-ptak-vrabec-strilet-1.jpg

Will think about it some more.
