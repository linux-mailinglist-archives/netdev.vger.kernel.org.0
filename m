Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE2C64CEF3
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 18:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238444AbiLNRls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 12:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiLNRld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 12:41:33 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901EF1DF1D
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 09:41:32 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so7938708pjr.3
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 09:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hofcxATKF4mIVOgM653h462eanwfoB3pQrHw6InB/Ts=;
        b=ET9ZU8eIUgEI9vQVxLHhTMT99jRUaGwnnXDfMFidd1EXOs1COfmzWxhCHYuWH6HIMb
         +ITfyI4/+11bNzWj5XW4iv1HamYHHqFXtQNZW9DDDtAG8qe+WQ6sAG2clqdfCM810Ukk
         ZcHeP+VAJ+IqGirZfVQcO2iReVkFzeZtWVAc8xB6RqUITP3UcPXRKUBcKVf8WJhBL10N
         S/pNs0HB13FUoU142YT6NHGRSQZAWrQ6KFaYSqyr+dKfwUCU4Iz6PtPPqB4swLh3I6nH
         cTcK22zij1dnLx14x6waXnQOWxuvVRqtvXzVjiAw94CA3NXCPjuOUeeaEL85nAlLJXHa
         eccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hofcxATKF4mIVOgM653h462eanwfoB3pQrHw6InB/Ts=;
        b=wfKw5DH7IVHWhpSSMS2x+i1/AFZNQqn5dlSVqosZNLlzarsglvUWYR0X+IfMrT9TRY
         IEXxIGwaVT1dhjzi0SQMA19SKgUYWxS8Agj45yMMG78mT5R7bHsBV1VAZZmNqKEUxRdm
         by765zJozDFI/8062rF3JmoyaNHNcGLyneBpjtJkTIQ6a9YZOFxirPSaVayPHqVzPycu
         Vr7h3uDovJc7+5rMszvv8xn9iWh6ld67YuAB+tMDVj7t5OWCdbj+N+yxkj8N8ujJh3yn
         ayA+EaFjEMIlna9as+zI33bmokSMY8ntehQ7mAp5P/uD8nUqUMozsiFcoMCYPyEF7Uqn
         DEFg==
X-Gm-Message-State: ANoB5pkLxRblcstYCjN848CIIMEvjU/arObF3HIGoSh0QW6L5hbDj9G9
        /zqBrXrVDWx57pKw75ledVmt3CmAXadWxvaEhB4=
X-Google-Smtp-Source: AA0mqf7uNBFF6iHZ/qRy0BoffzXs6cnBZcl55o/hDOJHdrVoRaSYMgclylj/o3e0n3+m2H6PjI/hBQ==
X-Received: by 2002:a17:90a:af84:b0:218:c8fd:c213 with SMTP id w4-20020a17090aaf8400b00218c8fdc213mr26420673pjq.36.1671039692054;
        Wed, 14 Dec 2022 09:41:32 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id bw4-20020a17090af60400b00218bedf8739sm1717894pjb.17.2022.12.14.09.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 09:41:31 -0800 (PST)
Date:   Wed, 14 Dec 2022 09:41:30 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [ANNOUNCE] iproute2 6.1 release
Message-ID: <20221214094130.7b11ec2e@hermes.local>
In-Reply-To: <0e6d6a35-88bf-d577-67d0-7c3f70268c10@tessares.net>
References: <20221214082705.5d2c2e7f@hermes.local>
        <0e6d6a35-88bf-d577-67d0-7c3f70268c10@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Dec 2022 18:16:36 +0100
Matthieu Baerts <matthieu.baerts@tessares.net> wrote:

> Hi Stephen,
> 
> On 14/12/2022 17:27, Stephen Hemminger wrote:
> > This is the release of iproute2 corresponding to the 6.1 kernel.
> > Nothing major; lots of usual set of small fixes.  
> 
> Thank you for this new release and for maintaining this project!
> 
> I noticed that the version that is now displayed with 'ip -V' is a bit
> different. Before we had something like:
> 
>   ip utility, iproute2-5.19.0
> 
> Now we have an extra 'v' before the version:
> 
>   ip utility, iproute2-v6.1.0
> 
> I don't know if it is there[1] on purpose and if it is the reason why
> the link was broken. It is just a detail, it was easy to fix my script
> parsing the version on my side.
> 
> [1]
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=83de2e800531dd30c2f2dd6e5196ed26c16c0407
> 
> Cheers,
> Matt

Sigh, all fallouts from one typo to a script.
