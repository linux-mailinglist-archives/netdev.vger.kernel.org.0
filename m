Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97B42503FD
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 18:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgHXQy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 12:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728603AbgHXQyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 12:54:53 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C797C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 09:54:52 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id b9so5437191oiy.3
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 09:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0E7pGvMNR/icrl555qIP4CCGFnyDIWwW1gBbuMxbE20=;
        b=LNlLKbEQ+w+CzdVi7k9UxUi+ezYJdMikFhsbqIquGcp+UUpUwN/enklVPZAtrttQkN
         C3sU5E0otqzyO//3k/Byb2N12yJG6yyXwpqnwJFGD8Xdr1qEtL1gKNHengH6MoM69tDH
         6D4rpw3OR4E5IAyFOavgAwGsyH8+Sf5wQt1dUKkvrE4H2uDSYjZ8Kda+lHgvOlVhI00k
         QBe0v1hc+7Z0OwmuCWn1dfzybGmoUo2ZSA9Mzis2/EPpdhdy4KWuChxMB/6LgmcKqw3c
         Wl1d3x/H9dqe0X+pjYga4zpWqV/AM+kphJSkE1Y+fmakB/Oqh5UWopcIMeVUVmhoocym
         uknQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0E7pGvMNR/icrl555qIP4CCGFnyDIWwW1gBbuMxbE20=;
        b=dYO+ZLSE2+S3HfJ6/JoZKfufPlO9ttBSJ2MyuHvTc8I+ow3xHO4+jmniu2BiUiORWB
         7E80kJjlEz+C6EXqWe53J2CwFoIRyBxGgQehPqjRxawMOhyKevcWIUTAznh3NYLjMspw
         YRImjhEAa7J6o8dmHK31TBBg8KiP7phaQi1uRKaQL4Vx3o2b/cwxVqjvdwAOAjr7JR1V
         ZsFd2fHemwUT3QMwISfN35I6kSZOs+hWGt+oJpve6qiC33XLCEROFpZ2oJe/MKg8rPpW
         CxxC4ZFDcZ3t9oQ9gdLLJ2UNsfTNyXVaUGvlVnjD04RvXIvCMMA2xjyVDJYJXbyJ1CFE
         yJ2g==
X-Gm-Message-State: AOAM533ZoaXplZ7fDL6U39sCsghnfW3JH6OwHm/xvLOb7nm7JzK00pRL
        d3R0SM+WHDE3Yg3mlqAg/eE=
X-Google-Smtp-Source: ABdhPJwAt5KP5bNqpfLxSNA+5W0Cs02terJ4iTq72jwUebLaKvgMnwrXumggHAHSIiWscowL/e2RrA==
X-Received: by 2002:a54:478f:: with SMTP id o15mr152651oic.77.1598288091869;
        Mon, 24 Aug 2020 09:54:51 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:12c:2110:d2ae:4b39])
        by smtp.googlemail.com with ESMTPSA id w11sm2316408oog.33.2020.08.24.09.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 09:54:51 -0700 (PDT)
Subject: Re: [PATCH 2/2] genl: ctrl: support dumping netlink policy
To:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
References: <20200819102903.21740-1-johannes@sipsolutions.net>
 <20200819102903.21740-2-johannes@sipsolutions.net>
 <3e300840-35ea-5f05-e9c1-33a66646042e@gmail.com>
 <251b824ef444ee46fb199b7e650f077fb7f682ea.camel@sipsolutions.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9d6372e5-66cd-6313-5302-5306a4cc8686@gmail.com>
Date:   Mon, 24 Aug 2020 10:54:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <251b824ef444ee46fb199b7e650f077fb7f682ea.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/20 1:54 AM, Johannes Berg wrote:
> Arguably, pretty much all of the code here should go into libnetlink
> then, since the kernel facility was expressly written in a way that
> would allow dumping out arbitrary (not just generic netlink) policies,
> just needs wiring up in the appropriate netlink family (or perhaps some
> additional "policy netlink" family?)

good point.

> 
> I can make that change, but I sort of assumed it'd be nicer to do that
> when someone else actually picked it up.

I think it would be better to put this into libnetlink from the start.
