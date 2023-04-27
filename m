Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8326EFFE3
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbjD0Di0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242863AbjD0DiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:38:14 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C27340D2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:38:13 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-51efefe7814so7950432a12.3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682566692; x=1685158692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ELPzBxhv31gJFedKIGPMZx4OFsn/wYXDDLjuH8tqHzk=;
        b=cBQI4hqkpm2Ft2aqMx+KcZLPfkyFFBotV/uCaYCIQwkjMQ+Qh+zidrciBMIcedwfg3
         r/IXJIdvn7kuGE9UdzvM5oyM+EEQ2Mq0eUHnncZgMRc66U2aPAWv7qSyPqjB8aMV0ibp
         /CeHE5Q5Nepx7tPdBsmNQp7JhX3JgTg7B/rqAS8iYAxKmOi1V2R243JPrmnahHQy0e0v
         sQ42oeYjNdI3iGNdr2Irnnu5+A3NwKUpMWzLa5KQHSdsfXiufXVQtj34CdEVLkcK0EAe
         tQuhBVNKKM+lIw3ZeeRnkeffxPFy5olJifc8Ud8B+FmNFfM/tM85NsL6boO3i/O5sLAn
         Horg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682566692; x=1685158692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELPzBxhv31gJFedKIGPMZx4OFsn/wYXDDLjuH8tqHzk=;
        b=DEw2iCQtC3WtV3AiCmaR2lXq3lSXqbhpmUjLCOUaKAjZlCBKFvk0WQWzDkwfoSVVcm
         fu5gpbqktgVAucIYWbYgkGYwlLw50zDrP8nWK5D5MWThSpFwkW1PvaOz2OpAjXZa8a+Y
         D9tUBpd72KODr/M0Gihyy4JUFvmhDsH7VFQnctAS7es6MFG+2o8LrLTfpDh6f4CDV9Xn
         z2vE0CQygDhRki64wbn24miTKC6C8NX6u4hmekLXh1boWrwV5cT6Y4422W0qAc4Fmab7
         vZgJX+LmcmmY8vsAoV9Vh340+mZCUNhsrx/1r8cXWMXK08J20D3tmIkrwErI+WLmzXZC
         GW8w==
X-Gm-Message-State: AC+VfDyY8W5DNczJC6BhcU+fl4UjWcxcCMHhOln9HOfRDFrKp9uCPv4d
        7KemBfL0wjEX8KF4beO4qXY=
X-Google-Smtp-Source: ACHHUZ5DIrBPBMxtEwJWiZ8UQH3tdqxAQflcchlmaIUKOO+c5qwKs67QRubNzsX4xvVs7hzRjYxOig==
X-Received: by 2002:a17:902:d3cc:b0:1a1:b172:5428 with SMTP id w12-20020a170902d3cc00b001a1b1725428mr71026plb.18.1682566692389;
        Wed, 26 Apr 2023 20:38:12 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jc13-20020a17090325cd00b001993a1fce7bsm10621600plb.196.2023.04.26.20.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 20:38:11 -0700 (PDT)
Date:   Thu, 27 Apr 2023 11:38:06 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [Question] Any plan to write/update the bridge doc?
Message-ID: <ZEnuHppYIE3bCxEs@Laptop-X1>
References: <ZEZK9AkChoOF3Lys@Laptop-X1>
 <ZEakbR71vNuLnEFp@shredder>
 <5ddac447-c268-e559-a8dc-08ae3d124352@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ddac447-c268-e559-a8dc-08ae3d124352@blackwall.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:04:47AM +0300, Nikolay Aleksandrov wrote:
> Always +1 for keeping the man pages up-to-date, but I tend to agree with Jakub as well
> that it'd be nice to have an in-kernel doc which explains the uapi and potentially
> at least some more obscure internals (if not all), we can insist on updating it
> for new changes
> 
> I'd be happy to help fill such doc, but at the moment I don't have the
> time to write the basis for it. As Hangbin nicely offered, I think we can start
> there. For a start it'd be nice to make an initial outline of the different sections
> and go on filling them from there.
> 
> E.g. as a starter something like (feel free to edit):
> Introduction
> Bridge internals (fdb, timers, MTU handling, fwding decisions, ports, synchronization)
> STP (mst, rstp, timers, user-space stp etc)
> Multicast (mdb, igmp, eht, vlan-mcast etc)
> VLAN (filtering, options, tunnel...)
> Switchdev
> Netfilter
> MRP/CFM (?)
> FAQ
> 
> Each of these having uapi sections with descriptions. We can include references
> to the iproute2 docs for cmd explanations and examples, but in this doc we'll have
> the uapi descriptions and maybe some helpful information about internal implementation
> that would save future contributors time.
> 
> At the very least we can do the uapi part for each section so options are described
> and uapi nl attribute structures are explained.

OK, I will try start a draft version after the Labor holiday.

Hangbin
