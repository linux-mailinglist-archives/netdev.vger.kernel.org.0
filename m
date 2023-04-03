Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6236D4386
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjDCLaS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Apr 2023 07:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbjDCLaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:30:17 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF32903C
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 04:30:09 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id y14so29001506wrq.4
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 04:30:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680521408;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4aFFFiR94sZ/jVqAegTdqg++sQP+GIHewIM+7z7rxYg=;
        b=b95qtuZhUhQ/dwlZgGkqzYL659tWCsSaSgTs6RBaLXDlaU0YRb4z9DFrawMo34N/+a
         ug28V7Tv28Qph7GE2Gp/gf9LANKq2oRYoY3WnhGKL25cwoMSydblHuZ7O1tQR99jjKnS
         ikBvY2OpQ61RrVmR/ro69FAL8eYNmqOUt+MdNWllvuWj7nlKTdHaGodkVCfs+fVA9PkS
         NXyFqQl3wC8nPinmr2+9R8iAz6jUXKxIAD1ViDSaV5XjGMmnXU6168H1kcih+PdOigBf
         u5cNVEWW0ZSo5DRs+QCje/CgzZCdARyxDDuR30elRujpRHKIsip3TM5Wuosu9jzlSiYD
         5vEA==
X-Gm-Message-State: AAQBX9dNqAQ/LVXah3ytJ3YSK9IHIZPgQHaBzKML7WU1KNm/k08z9cqO
        YrBdmU2p9XpYj5XbFQg73Fk=
X-Google-Smtp-Source: AKy350ZHJ5Q8PqXl5Gt0Hd67A19QbgCfbmBa1zNMwc5lBuv0bzfNt9ZoktZHPeYLKoPzA/jDgqImFw==
X-Received: by 2002:adf:ce81:0:b0:2ce:a65e:817f with SMTP id r1-20020adfce81000000b002cea65e817fmr12164373wrn.25.1680521407671;
        Mon, 03 Apr 2023 04:30:07 -0700 (PDT)
Received: from [10.148.83.3] (business-89-135-192-225.business.broadband.hu. [89.135.192.225])
        by smtp.gmail.com with ESMTPSA id x6-20020a5d60c6000000b002dfca33ba36sm9553057wrt.8.2023.04.03.04.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 04:30:07 -0700 (PDT)
Message-ID: <1998a6a01c5f1905f0f4e1e72d4e19500fc352d1.camel@inf.elte.hu>
Subject: Re: [PATCH iproute2-next 0/9] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?ISO-8859-1?Q?P=E9ter?= Antal <antal.peti99@gmail.com>
Date:   Mon, 03 Apr 2023 13:30:06 +0200
In-Reply-To: <20230403112348.patphgia5en6v2ec@skbuf>
References: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
         <6546e93dca588c3c01e56466e6f5ae10e37870bf.camel@gmail.com>
         <20230403112348.patphgia5en6v2ec@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir!

On Mon, 2023-04-03 at 14:23 +0300, Vladimir Oltean wrote:
> Hi Ferenc,
> 
> On Mon, Apr 03, 2023 at 01:18:07PM +0200, Ferenc Fejes wrote:
> > Seems like Stephen merged Péter's manpages patch [1] but IMO your
> > version [2] is a better overhaul of that, also Péter ACK-ed to go
> > forward with that version. Looks like you rebased this work on the
> > new
> > manpages, you have any plan to submit the changes from [2]
> > separately?
> > Probably Stephen missed the whole discussion and about [2] and I'm
> > admit that putting acked/reviewed into a mail inside the discussion
> > might be misleading (probably thats show up for the original patch
> > in
> > patchwork). Sorry for making it complicated.
> > [1]
> > https://lore.kernel.org/netdev/167789641838.26474.2747633103367439718.git-patchwork-notify@kernel.org/
> > 
> > [2]
> > https://lore.kernel.org/netdev/20230220161809.t2vj6daixio7uzbw@skbuf/
> 
> Yes, this is true. I still have the delta between Péter's merged
> version
> and my suggested changes, but it needs to be broken up into a
> gazillion
> smaller patches which I haven't done yet. I now also doubt the value
> of
> some of those changes as standalone patches. I wanted to get the
> preemption
> stuff over with first, and this is why I've submitted only what I
> have.

Understandable, thanks for the info. With all respect of your time, it
would be nice if those changes make their way into the manpages in one
way or another. I think it has enough value in its own too, but I agree
it has much lower prio than having FP merged and running :-)

Ferenc

