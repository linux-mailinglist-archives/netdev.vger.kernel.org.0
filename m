Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742F7390DD9
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 03:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhEZBRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 21:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbhEZBRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 21:17:03 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE12C061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 18:15:29 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id q10so32486412qkc.5
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 18:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fbn4e63sl2faYTsNEiT0WVdxU+FOGEtoqDO8mON2oCw=;
        b=kHXaK2ioLlkNbqvwzKh9U+P3Ldusml9rbUSTPb6oImTG+0VRsVqWZPxiXq0ZZzLFiM
         mTd2LSSwvkRGoZri6fSW2l0kRWKm2/y0QEP8y1yP2VTLBr73JFxTtP1d9F1E3BVW3z6f
         5tDPJwM6K/EM27ENkOejCVvDQNlHixaf/wBRXNaBxezstsRdrIlDIobZPvRk7UkJOqmh
         VkDieg2C285xK9aqnl/D3hdSytpKi0wEml7/QtIMx+Hl/vDkNb1wMTAVdJQf3CoIHIIj
         U+iOiKr3QcxdhnatoSnJ8weOH//ejbh0KNYylFQh6QxdsNU9pWcmCc1RQVvLz8VlcGdT
         t6MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fbn4e63sl2faYTsNEiT0WVdxU+FOGEtoqDO8mON2oCw=;
        b=da2ZjXQ9K7Z0sAvnJ1IU+h9v4r+hrgZGJ+8IpyBDDbdAkYsy0welPo8zQKEyhV9tqb
         g2iDlT7m3YwFAk2Nbdv1IiChbPhqyqqC2A9j9KRIBppsU1HQN+AlRkHwR+OYycMTIzYS
         WP9DmBvEcvQbyC6WQi7eUhvSH0bzfDwT0MLtq1CgJgXoY/ezQemAUVitKj+dElks//pL
         lhB92b1AXxjYtYIuYH5sxGi0MJHjoUZPVfE0QOhIJm5IUB59I65/C7/yr76S7WsH5M9p
         pcqvwZLSLfYKtR4G+RCEPy2m62icajXgS/C66MCmHkNk9qhXuvWQV+j+zr4Ms26LcPKd
         SCGg==
X-Gm-Message-State: AOAM530KEIgDXiZJvc/6w9pkTGTsQQTi1CGQOKTBtNhII5quENoi/UbA
        bGNzqLp1UG9wS83KmRdT8Ikl5eGoJJX54QqMBz4Jib9XDB9UhX4c
X-Google-Smtp-Source: ABdhPJwv7SYwL/MS2xRvGCQpOtI/0DHJAB+BdVT+OZ2L3zLBCfiT7kjToRZxNvPHpiRIRiQ0bMNLhlgDoh0jTKwtIII=
X-Received: by 2002:a05:620a:3c3:: with SMTP id r3mr37647963qkm.35.1621991728889;
 Tue, 25 May 2021 18:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210525121507.6602-1-liuhangbin@gmail.com> <CAHmME9qHbTWB=V3Yw6FNLa1ZgP2gxb29Pt=Nw3=+QADDXArQuA@mail.gmail.com>
In-Reply-To: <CAHmME9qHbTWB=V3Yw6FNLa1ZgP2gxb29Pt=Nw3=+QADDXArQuA@mail.gmail.com>
From:   Hangbin Liu <liuhangbin@gmail.com>
Date:   Wed, 26 May 2021 09:15:17 +0800
Message-ID: <CAPwn2JTkdXRkT=azv+hPSUvcb-Gq51T11Z2MBFBsNCRG_8=Gsg@mail.gmail.com>
Subject: Re: [PATCH net] selftests/wireguard: make sure rp_filter disabled on vethc
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 8:19 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Hangbin,
>
> Thanks. I've queued this up in my tree and will send it out on the
> next wireguard push.

Hi Jason,

I have a question about the wg-quick(8)-style policy routing test.

ip1 -6 addr add fc00::9/96 dev vethc
ip1 -6 route add default via fc00::1
                                             ^^ Here why we add a
default route via none exist address?
ip2 -4 addr add 192.168.99.7/32 dev wg0
ip2 -6 addr add abab::1111/128 dev wg0

Thanks
Hangbin
