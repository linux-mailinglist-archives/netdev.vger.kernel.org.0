Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBF513CE18
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgAOUdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:33:45 -0500
Received: from mail-qk1-f177.google.com ([209.85.222.177]:46015 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgAOUdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:33:44 -0500
Received: by mail-qk1-f177.google.com with SMTP id x1so16960250qkl.12
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 12:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kmDO8fPoIZwlzNZi7r0J/nGnTOTmECKqFE0ZM2IZmGs=;
        b=Z39/Pkd71NyhAWZsbv/npWUaViC/WjpxAswiVV/ArqV95NkJKs6X49XReBx8EwIBx6
         4yWev/O7zQqVpCv9IiK9gH1lu+P8dgoLRwQ3VWoe+ZNEyVJM4IT0ZLXInxPIEW8ytgAB
         6++CZciKs05xLmldUIhD6WYsFapHdmJQ8PubFWpOjf6Q9RcD6noiRwkCF6mpuYWFXokD
         Q4hEbZcoS+IFXrUZLIQPCgljV5ftoSQ4HGArcFAzmBMMdbB1uy8P/RfvUwB2AcbsnnBL
         GgQ6tfEuEl4E816mjY5scZLTWpJtMNjmCdr360HVUaTAOt0HjOTNNca4olxpJAbDZyKV
         gDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kmDO8fPoIZwlzNZi7r0J/nGnTOTmECKqFE0ZM2IZmGs=;
        b=KUtsGQII0+T7Rnq+pmaLB8PHdDnGiO2mNUossep7XAUh6rfhH9qgxMb9fE/uu5F/is
         clOdDC9VuckraEwUhlLy1kJZUPvfatmucuja35UASabppZ0jGD7gxAVkSQXYtuEVrq9M
         O7qevtSxrNfzTrcJNz8HBVhWfXP7/URbnlkZEvlUIUhz/wSK+NOZjxqRLCPn8Vqe1vUo
         Fjh6a+iijQKnBGm8666tyM76G7D/Dia4h5lcoPd8KLHa5a4rcgwN4OF61BwwnxQH+hIK
         eU2EYQLgbc9dI0vMWlwUF+VMVBV1MZ1ND8QGg69qyGxRmaUr+QEzl2rKfDXtV1wJyQj2
         vxGA==
X-Gm-Message-State: APjAAAWGc9Xt1rUGaG6Z2dxwdeD4acgfJ5EIx968NoWGr5499TJDauKP
        inqgwi3XrvKKmDGf5jfBEDN1KETq
X-Google-Smtp-Source: APXvYqx9CIHzkdAbjG4HRLQkkWo4Kxd6bSEsq2p7taP5rasBz3RzTQGmzWCXmqr8Bq2WY/99Yx5r+A==
X-Received: by 2002:a05:620a:11a3:: with SMTP id c3mr29668379qkk.230.1579120423494;
        Wed, 15 Jan 2020 12:33:43 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:b4a4:d30b:b000:b744? ([2601:282:800:7a:b4a4:d30b:b000:b744])
        by smtp.googlemail.com with ESMTPSA id o9sm9103020qko.16.2020.01.15.12.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 12:33:42 -0800 (PST)
Subject: Re: vrf and multicast is broken in some cases
To:     Ido Schimmel <idosch@idosch.org>,
        Ben Greear <greearb@candelatech.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e439bcae-7d20-801c-007d-a41e8e9cd5f5@candelatech.com>
 <3906c6fe-e7a7-94c1-9d7d-74050084b56e@gmail.com>
 <dbefe9b1-c846-6cc6-3819-520fd084a447@candelatech.com>
 <20200115191920.GA1490933@splinter>
 <2b5cae7b-598a-8874-f9e9-5721099b9b6d@candelatech.com>
 <20200115202354.GB1513116@splinter>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9ed604cd-19de-337a-e112-96e05dad1073@gmail.com>
Date:   Wed, 15 Jan 2020 13:33:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200115202354.GB1513116@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 1:23 PM, Ido Schimmel wrote:
> 
> I'm not sure this is the correct way (David?). Can you try to delete
> this default route and instead add a default unreachable route with an
> high metric according to step 3 in Documentation/networking/vrf.txt:
> 
> "
> 3. Set the default route for the table (and hence default route for the VRF).
>        ip route add table 10 unreachable default metric 4278198272
> 
>    This high metric value ensures that the default unreachable route can
>    be overridden by a routing protocol suite.  FRRouting interprets
>    kernel metrics as a combined admin distance (upper byte) and priority
>    (lower 3 bytes).  Thus the above metric translates to [255/8192].
> "
> 
> If I'm reading ip_route_output_key_hash_rcu() correctly, then the error
> returned from fib_lookup() because of the unreachable route should allow
> you to route the packet via the requested interface.
> 

yes, IPv4 is a bit goofy with multicast (at least to me, but then I have
not done much with mcast).
