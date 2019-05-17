Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B54FA21C93
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 19:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfEQRfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 13:35:53 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:42965 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbfEQRfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 13:35:52 -0400
Received: by mail-pg1-f174.google.com with SMTP id 145so3603384pgg.9
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 10:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GfCDm8sUKy3R6j2sDtGbVs2+WjATZEuKgyEXc8pGzDA=;
        b=DYFujcpnR73nKQG6ZvlHKnQOnML4yf8OUuJaVezO/Dxtp2m66FZ+WCWhnVbvYNMCX5
         MSNMq2jI91f2nTg7Ck11DrELBNAQAjpINkrVaRRYjw4gqLQu306pwLq9PAclAjVZWGdD
         e1htNLiqhQv+na0etoPEOV0KlvLzEMjqpVDA3ta/2yTW4TgqEa1OUJIvWnyn6AfBCwrc
         yfIYiVnDADnb9Ary5TzDdHKy/JkYsE2qpGd8yFXWyivXtNRkmFF75a1zN/TuhZbgBe8d
         7czV2nr5SrZyasEuFGTpqyMFqW0NjEvBZA4cRNC5TTWTn7zh9ROctZN3H1snSwMKa+Y9
         VioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GfCDm8sUKy3R6j2sDtGbVs2+WjATZEuKgyEXc8pGzDA=;
        b=euA4D3fkPML3y57rS6E8T3RmfAfptCr/hdrJVJ4Vg0t7RhWlxGaVc1ix/YleHrxOAP
         FWjbQb98xZt8YHY+TLLTwxDIQT7tVvTe3utnOs/IXrglFNzcax6PBuGEFGCZKinlbj4p
         /Kjm89VrnEyCq1WdfmZal61sI5fGvucWoVqie08+w7SSmvRzNn011enNKNaRgR77xkZN
         0OpGOBmmXLs2u8eWjje9/DhsL0fyIrqtKRpyA6BVVDJicuV9P1FhpJaix4FKB4SgPAIa
         jj5C1RDMIjX02iN+bBxJBI2mjR+vkrQEfd8I76hB/+eYxxdKkUYD+No1PdQqCpsf8FI9
         eDeA==
X-Gm-Message-State: APjAAAWSzoimDG0eiAxzg/Yk3tCuKzrTRBTqZAkVJKzzfL/DMzEoXZPK
        JmXIlsxV3urN9T93nX6uNUvbyA==
X-Google-Smtp-Source: APXvYqxhmcI8pO/7KvLUTsf6PAIj4oE4umK/nyMO/HvSZh7yTIgsuXc6G0XLSeje2THOtb/dvcazPw==
X-Received: by 2002:aa7:9a95:: with SMTP id w21mr42624587pfi.248.1558114551856;
        Fri, 17 May 2019 10:35:51 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z66sm12580295pfz.83.2019.05.17.10.35.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 10:35:51 -0700 (PDT)
Date:   Fri, 17 May 2019 10:35:43 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        emersonbernier@tutanota.com, Netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        David Miller <davem@davemloft.net>, piraty1@inbox.ru
Subject: Re: 5.1 `ip route get addr/cidr` regression
Message-ID: <20190517103543.149e9c6c@hermes.lan>
In-Reply-To: <2e6749cb-3a7a-242a-bd60-5fa7a8e724db@gmail.com>
References: <LaeckvP--3-1@tutanota.com>
        <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
        <2e6749cb-3a7a-242a-bd60-5fa7a8e724db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 May 2019 09:17:51 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 5/17/19 4:22 AM, Jason A. Donenfeld wrote:
> > Hi,
> > 
> > I'm back now and catching up with a lot of things. A few people have
> > mentioned to me that wg-quick(8), a bash script that makes a bunch of
> > iproute2 invocations, appears to be broken on 5.1. I've distilled the
> > behavior change down to the following.
> > 
> > Behavior on 5.0:
> > 
> > + ip link add wg0 type dummy
> > + ip address add 192.168.50.2/24 dev wg0
> > + ip link set mtu 1420 up dev wg0
> > + ip route get 192.168.50.0/24
> > broadcast 192.168.50.0 dev wg0 src 192.168.50.2 uid 0
> >    cache <local,brd>
> > 
> > Behavior on 5.1:
> > 
> > + ip link add wg0 type dummy
> > + ip address add 192.168.50.2/24 dev wg0
> > + ip link set mtu 1420 up dev wg0
> > + ip route get 192.168.50.0/24
> > RTNETLINK answers: Invalid argument  
> 
> This is a 5.1 change.
> a00302b607770 ("net: ipv4: route: perform strict checks also for doit
> handlers")
> 
> Basically, the /24 is unexpected. I'll send a patch.
> 
> > 
> > Upon investigating, I'm not sure that `ip route get` was ever suitable
> > for getting details on a particular route. So I'll adjust the  
> 
> 'ip route get <prefix> fibmatch' will show the fib entry.
> 

If you want to keep the error, the kernel should send additional
extack as to reason. EINVAL is not user friendly...
