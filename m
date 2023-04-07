Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A531C6DB483
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 21:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjDGTyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 15:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjDGTyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 15:54:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00443AD0A
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 12:54:08 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 60-20020a17090a09c200b0023fcc8ce113so2163437pjo.4
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 12:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1680897248; x=1683489248;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+EPM7tp45sADf/MYLgIkfWEFxLaeJNCu/hrVzpHyDFA=;
        b=4BmRGxpD2mKVXms8CYIIfNeja+mUdsFbb7D0aZko+pP6GrcTQJpKTjSDMdZdsxgMbN
         z5t0cwUThyV/96+HNeSkLrhL6GAl9RvgZrJZZYsfuPfH6beCmZGTWdbFP4HoF7wZ4cOm
         6uZq2LEssFw+zqFlf64nt7WnVFZBoQImMVao4ff6OgRr3o6/Qt6s/ev4og/+O6lNX0ii
         Q7ujf6d1Ayx44I+gKBuYkKcd3JhqjSnHWmRM3nCaWe8R6ConBjTUUB/dC9fXM+r5juVl
         CsKpx4bLFUa73oi31x1W3/+HPIz8ynNrEyu7+T4AOtBr+h2BS9vo4wAdyHHL3a0HbDHJ
         rcSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680897248; x=1683489248;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+EPM7tp45sADf/MYLgIkfWEFxLaeJNCu/hrVzpHyDFA=;
        b=70d2kIvbkVlzXai5K5aC4GvjhWPTh7JAFZZiDCTj1MOaRcTjKEojR7ZjomNzG1d3WS
         2Idyrk4KRbijd+DHtwau6GMtXfFKie0q6NkgU3qJEL261jmZgja122tZcxqHJDsA8NvK
         mUHFkxUfbbTi+KkvacrCbk9kRrcN5rgDjWLd8oFNlKBarHNa5VILlnJ7yHXH2BtHyTLX
         VKymcH/OIvK4PsyxJyc9orYO+LGIqYaj0+IP1uqsDCSrvST50Of7SEjXCX1xd4VTRaMz
         zs5JZiHBGBF+RkB4uk02RvejgeHIwM6t2N8h4nkjabydUCsAgeFODGmzFopyd86ajS4J
         XV/g==
X-Gm-Message-State: AAQBX9cU+3qRv4gC5qF/dZ04LJhPa/BvvRjD/hDB1worFpa6nPP5dlBW
        czPy6bsfEjtjSsNT1SW8daGvl4mBsPEzFntE+ESe8w==
X-Google-Smtp-Source: AKy350b0U55VbpOrM3xI9CL65Ykv5gJBAhrWPdGvc0aau6cMlxmELQwq0gS1+8UByW2ejw6oW1BeDg==
X-Received: by 2002:a17:90b:1e02:b0:23f:680e:78be with SMTP id pg2-20020a17090b1e0200b0023f680e78bemr3250700pjb.48.1680897248195;
        Fri, 07 Apr 2023 12:54:08 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902b10100b001a505f04a06sm2566933plr.190.2023.04.07.12.54.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 12:54:08 -0700 (PDT)
Date:   Fri, 7 Apr 2023 12:54:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: iproute2: dealing with tunnel type mismatchs how?
Message-ID: <20230407125406.10ac2ec4@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luca notified us of a bug in iproute2 tunnel change that does not have an easy
way to resolve. https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1032642

The trigger is doing a ip tunnel change request on the wrong type of tunnel.
In this case it is doing an IPv4 type change on an gre6 tunnel. Doing this
is not a valid thing to do, but the kernel and ip tunnel command do not
handle it well.

The root cause is that socket private ioctl's are a bad design from the start!
The same ioctl can return different data depending on the interface used.
The change request requires that ip tunnel do an ioctl
to get current values, and the returned data depends on the type of tunnel (gre vs gre6).
Netlink related API's don't have this type of issue.

None of the options is great:
1. Leave it alone, this has been this way for 15 years.
1a. Make the call to fetch tunnel parameters with a bigger buffer so
    that failure is not a stack smash, just garbage in.

2. Change kernel ioctl to not allow IPv4 socket to be used when doing IPv6 tunnel
   operations. Not easy since the socket context is not passed down through the
   tunnel ioctl calls.

3. Add logic to ip tunnel to do netlink calls to find the type of device being
   changed, and catch mismatches there. There is not a simple direct way to get
   the type, although it probably could be inferred from the ip link type.

4. The whole 'ip tunnel' set of commands is actually superfluous at this point.
   Same things can be done via 'ip link' and none of the problems happen.
   Therefore, start process of deprecating and removing 'ip tunnel'??

5. Remove the change option from 'ip tunnel'.  And force the user to make
   a new tunnel if they want to change endpoints etc.

Ideas and comments appreciated.
