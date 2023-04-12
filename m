Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1B86DE8CB
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 03:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjDLBWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 21:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDLBWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 21:22:52 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1794222
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 18:22:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nh20-20020a17090b365400b0024496d637e1so15264619pjb.5
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 18:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1681262570; x=1683854570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+T1h4ESSVIJLg1DItxBn2RvhHgq+c/0p6CPjiNHDYRY=;
        b=AtuP/0S1/fYLTNM/X1lXYAMrb8TvqHqDSHhrdG/Qpa7zAoi+pRoRIVMiqqG5V+JEca
         ZvuJnaAVyrHeqLlMm6AAHedBfLH8rUo8E4bRVlzmb2IBLTyxC8M86R8h7BQuMiHQFRkn
         +joIiGx7e9IeTLPsCJELRMJKJpjQAWclj2er90hb+PmYoQU+Wom/T6BCj3xpbm8gXhF+
         ZY8T8LrQfnnT/SX8AGfzAb8bE+A1BrqBYd+ZfkSvu6jDnuGiLj7Uak1evJDHphykmfLp
         gqmysG09s0/ZlSKRGmUJmv/FyDZbS39XqAl1QUqJKbQAPgybFj04EuoeQOmcnUkYCX2Y
         q/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681262570; x=1683854570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+T1h4ESSVIJLg1DItxBn2RvhHgq+c/0p6CPjiNHDYRY=;
        b=So6zVN8CDmRg4JoPysPStpt92ny0Dij7RD43REWS+VPNWE70+Ff2gbAQkxnajAjYRq
         5+fhPxWHDRuMJsQmA0l9ESDSSYe+EnfUn2BbzVWBx5F6XRrqZUX+ImWYSTf+6jI1qulj
         Ni0BLHHwzWDyDFmsoQc+jwqokvnRXDIdVgEtcZbpTwnRBkek0Q/cy6vdVl0vaQoe0Rci
         y6gBMiqJCFDHYIO3aZ3F7H4psVL8GAfSbB6BAmo9Bo/5Z9t7LfiwwcJ6bHQ7r3AZtmUy
         llTccgZ8YSE/L1hgTGaLt3ncNncIOxOd3c6FBvkQ6NORRobzQLlLSR8XNZLGw0OwVmiO
         FDYA==
X-Gm-Message-State: AAQBX9f7OFStNCS+Y5ipuCXQgTHOC0Kr53FmHXnQ8SbMESFa6QWOVJT6
        43GRkyACg6HjVwb+d+L1v2XiFQ==
X-Google-Smtp-Source: AKy350aEzvroLEFD9gnlc0NBM9gdrMc6pTl7zBKBnnRw/r7Tx1vIFqCI7E5SIdFHDNJkOy//MTkZNg==
X-Received: by 2002:a05:6a20:4fa9:b0:d9:8a1b:3315 with SMTP id gh41-20020a056a204fa900b000d98a1b3315mr11830591pzb.59.1681262570275;
        Tue, 11 Apr 2023 18:22:50 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f9-20020a63de09000000b00502e6bfedc0sm9292004pgg.0.2023.04.11.18.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 18:22:50 -0700 (PDT)
Date:   Tue, 11 Apr 2023 18:22:43 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andy Roulin <aroulin@nvidia.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>, netdev@vger.kernel.org
Subject: Re: neighbour netlink notifications delivered in wrong order
Message-ID: <20230411182243.120bf51e@hermes.local>
In-Reply-To: <20230411174131.634e35d3@hermes.local>
References: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
        <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com>
        <20220606201910.2da95056@hermes.local>
        <CA+HUmGidY4BwEJ0_ArRRUKY7BkERsKomYnOwjPEayNUaS8wv=w@mail.gmail.com>
        <20220607103218.532ff62c@hermes.local>
        <CA+HUmGjmq4bMOEg50nQYHN_R49aEJSofxUhpLbY+LG7vK2fUdw@mail.gmail.com>
        <78825e0b-d157-5b26-4263-8fd367d2fb2c@nvidia.com>
        <20230411174131.634e35d3@hermes.local>
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

On Tue, 11 Apr 2023 17:41:31 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> > >> Neigh info is already protected by RCU, is per neighbour reader/writer lock
> > >> still needed at all?  

Yes there is nothing that prevents an incoming packet changing the contents
of a neighbour entry
  
> > > 
> > > The goal of the patch seems to be to make changing a neighbour's state and
> > > delivering the corresponding notification atomic, in order to prevent
> > > reordering of notifications. It uses the existing lock to do so.
> > > Can reordering be prevented if the lock is replaced with rcu?    
> > 
> > Yes that's the goal of the patch. I'd have to look in more details if 
> > there's a better solution with RCU.  
> 
> But the patch would update ndm->ndm_state based on neigh, but there
> is nothing ensuring that neigh is not going to be deleted or modified.

Making the update atomic would require a redesign of the locking here.
The update would have to acquire the write lock, modify, then call
the code that generates the message; drop the write lock and then
queue the message to the netlink socket.

