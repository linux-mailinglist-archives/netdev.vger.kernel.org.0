Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A53E3461D7
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhCWOtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbhCWOtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 10:49:24 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623F7C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:49:23 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 16so25929905ljc.11
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=J2SF4K9/ETdvufuKNwH4JIKpqQiWOL6J/SOPiBqGwXE=;
        b=njEleu9WZQIjEbVT76yJCrn8PDhkqorr6IiY3Iehge1N5itPJk2ChqxmYO3P/zRz8q
         Cnytzs6wrWmd6jdTfyR4gFOpBWrQYPWC1i18aJ1gNg4NDZEuYZvMMyIoAXn/Ne3pwqi5
         2uoEMzRQjOjDUqhAYPytexn090y/FasvMgfQjTZO3BklF4DsdG8ZrpHMje15tu4qirMZ
         yYHGyRSq6xXVuHZXIxNQCJvPBwgMaMvgtsM4NsDOnBBeXOaqd9M0ZsudChd/QCyuUZKX
         LE1eTeP2Ey9LqI9BMj+qAuRrq2fAIGDOvE3cYgKAMNbXcJXkso+ZUmoLhI/B5yPSzSr7
         qygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=J2SF4K9/ETdvufuKNwH4JIKpqQiWOL6J/SOPiBqGwXE=;
        b=kZFc0Dd0wcuIn9fV3ptU3cdMXkwavDVgT0ejOqbn3lxrM+QegALdU9uoKacl4XNqzk
         QBUgwIBUsnzfwaxL6h37ztcr8Y+ePnRPW6gn4BkZtFB44Y0l1kwlbzRu6kilpKhsSB0/
         1dEMd9V++/9QIieDxknkBHgsddksHX2mx7yNjSkZ1dR2OXTx1XVTF+OWaZG0CLUPeGhK
         DhBL24uoJqveIfEVM005Kt4V/VsQJ7PQ8kVufwQkDHfYU1ssTZxIWuUcCokSnBML7vwe
         tyDVqzCeJyki3y8recHL3kL297kYx68oWqILmvoR/oQLlr8Gps6lMzd2+pVtiGfh68XL
         EMMw==
X-Gm-Message-State: AOAM532Nu9qZgOAZSKryARPBid4hVat2tb+OMXxsl7qcrkfR0VmghUke
        mJU2bh5x4iazrztVdFT8JlTPgvL92TO+KljqVGI=
X-Google-Smtp-Source: ABdhPJwIwBS2k/dt10p+CYF3xyRFbh+8kDYuh2NOhXsHizYLI8UfjZ9mQe90RIvpQcqh4GVWnpUrhA==
X-Received: by 2002:a2e:9084:: with SMTP id l4mr3272962ljg.498.1616510961504;
        Tue, 23 Mar 2021 07:49:21 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id l17sm895173lfg.178.2021.03.23.07.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:49:21 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
In-Reply-To: <YFnh4dEap/lGX4ix@lunn.ch>
References: <20210323102326.3677940-1-tobias@waldekranz.com> <YFnh4dEap/lGX4ix@lunn.ch>
Date:   Tue, 23 Mar 2021 15:49:20 +0100
Message-ID: <87a6qulybz.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 13:41, Andrew Lunn <andrew@lunn.ch> wrote:
> On Tue, Mar 23, 2021 at 11:23:26AM +0100, Tobias Waldekranz wrote:
>> All devices are capable of using regular DSA tags. Support for
>> Ethertyped DSA tags sort into three categories:
>> 
>> 1. No support. Older chips fall into this category.
>> 
>> 2. Full support. Datasheet explicitly supports configuring the CPU
>>    port to receive FORWARDs with a DSA tag.
>> 
>> 3. Undocumented support. Datasheet lists the configuration from
>>    category 2 as "reserved for future use", but does empirically
>>    behave like a category 2 device.
>> 
>> Because there are ethernet controllers that do not handle regular DSA
>> tags in all cases, it is sometimes preferable to rely on the
>> undocumented behavior, as the alternative is a very crippled
>> system. But, in those cases, make sure to log the fact that an
>> undocumented feature has been enabled.
>
> Hi Tobias
>
> I wonder if dynamic reconfiguration is the correct solution here. By
> default it will be wrong for this board, and you need user space to
> flip it.
>
> Maybe a DT property would be better. Extend dsa_switch_parse_of() to
> look for the optional property dsa,tag-protocol, a string containing
> the name of the tag ops to be used.

This was my initial approach. It gets quite messy though. Since taggers
can be modules, there is no way of knowing if a supplied protocol name
is garbage ("asdf"), or just part of a module in an initrd that is not
loaded yet when you are probing the tree. Even when the tagger is
available, there is no way to verify if the driver is compatible with
it. So I think we would have to:

- Keep the list of protcol names compiled in with the DSA module, such
  that "edsa" can be resolved to DSA_TAG_PROTO_EDSA without having the
  tagger module loaded.

- Add (yet) another op so that we can ask the driver if the given
  protocol is acceptable. Calling .change_tag_protocol will not work as
  drivers will assume that the driver's .setup has already executed
  before it is called.

- Have each driver check (during .setup?) if it should configure the
  device to use its preferred protocol or if the user has specified
  something else.

That felt like a lot to take on board just to solve a corner case like
this. I am happy to be told that there is a much easier way to do it, or
that the above would be acceptable if there isn't one.
