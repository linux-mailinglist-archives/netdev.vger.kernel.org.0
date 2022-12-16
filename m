Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E821464F059
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 18:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiLPRYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 12:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiLPRYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 12:24:23 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82F029814
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 09:24:21 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so6746988pjr.3
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 09:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KM0PjU6914BLnpapx0qFxUaaSi4obQzN7ZSP5FROkb8=;
        b=mY2gg2Ypf2sYM39uUgyw5BFTPcstmVyDodPfzrVOQzVT2vOoQKoONznJ+60+Un4BDq
         K9xC9AIiVAw6gtEcadqD+O+rfbHD3fRNuqZh6xhK/LbtEc6TNzUGZQ0Xin4mDKIGrRR1
         0/M2jnooHOGf0NBFrb40521B6p59HvS66Em4jdrerzQCnaAYYullNYZLJMt/ugA56WkW
         wNozqFHzfWxXEhqaVMGOfaXk/ud/UB/MLzHhc0kOgXSvDEyXEvkBNH8cm5flUf86wXfc
         EKpi5Wf0aEDxMvuBS8u9FFZ0sNjIJQm+vebITgnz/B97XJn9viNqaxyc3/4Xdz17CpLf
         Oy4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KM0PjU6914BLnpapx0qFxUaaSi4obQzN7ZSP5FROkb8=;
        b=qnNE/Dh8EaN72dAbRJOUsvuZf6EkawJDPBqHgx/EWiIPumQTyycZDKNKPdwGq4pIpe
         xR7QqIqMkJTYak3jpt2PnJcQRH/2YQg7PQC8tptNsEuWzmeqgN7UJ8S+Tq/Jv4GnGqnJ
         dgI/dNGl1h887bmpsnnxoPhO7BTmk7pBuZ7iW61kwJ+7qZrvEVetrumFmC0Pf2VSkcRl
         3kSrIrIWlL15wFZvzUAKBKngGs9SU9xR9gsb4PGuXorctWxy9avPQ5iNQHHDekQzPvoQ
         Lh7+L/f4gI/WRTxhCHOTnjaDkTJNwfv24B0m/BNrpXPoImwGxTykvaXy36MWftRn0UQn
         gMXw==
X-Gm-Message-State: ANoB5pmXMkO8CqEMYGRoraxsTXTeW1SFnQ0PC7Tuh84ASeMP6tb7Mqra
        0y02Hwy7GnkkeDFSs0GOFesDdJDyhPapEBo8Ptw=
X-Google-Smtp-Source: AA0mqf5x8GcghHYo2VdVVrXff0hRmTafuz5IuxM7fY4ZEygbdwK/JsBG6gVGvX5CxHktLlB2aJcbhQ==
X-Received: by 2002:a17:902:a986:b0:188:bfa7:f8f5 with SMTP id bh6-20020a170902a98600b00188bfa7f8f5mr29831575plb.42.1671211460864;
        Fri, 16 Dec 2022 09:24:20 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id h3-20020a170902680300b00188c5f0f9e9sm1877747plk.199.2022.12.16.09.24.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 09:24:20 -0800 (PST)
Date:   Fri, 16 Dec 2022 09:24:18 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 216813] New: HFSC: "tc class change" can't remove rt
 service curve
Message-ID: <20221216092418.3e898d6f@hermes.local>
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

No one has touched hfsc in a long time.
Looks like more of an user interface issue.

Begin forwarded message:

Date: Fri, 16 Dec 2022 09:29:19 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 216813] New: HFSC: "tc class change" can't remove rt service curve


https://bugzilla.kernel.org/show_bug.cgi?id=216813

            Bug ID: 216813
           Summary: HFSC: "tc class change" can't remove rt service curve
           Product: Networking
           Version: 2.5
    Kernel Version: 5.15.76
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: karel@unitednetworks.cz
        Regression: No

When trying to change HFSC class with rt, ls and ul service curves "tc class
change" is unable to remove rt service curve.

System:

# uname -a
Linux karel2 5.15.76-gentoo #1 SMP PREEMPT Mon Oct 31 08:56:41 CET 2022 x86_64
AMD Ryzen 5 3600 6-Core Processor AuthenticAMD GNU/Linux
# tc -V
tc utility, iproute2-6.0.0

Let us create HFSC qdisc with one class having rt, ls, ul service curves:

# tc qdisc add dev lo root handle 1:0 hfsc
# tc class add dev lo parent 1:0 classid 1:1 hfsc ls m2 1Gbit ul m2 1Gbit
# tc class add dev lo parent 1:1 classid 1:2 hfsc rt m2 100Mbit ls m2 200Mbit
ul m2 300Mbit
# tc class show dev lo classid 1:2
class hfsc 1:2 parent 1:1 rt m1 0bit d 0us m2 100Mbit ls m1 0bit d 0us m2
200Mbit ul m1 0bit d 0us m2 300Mbit
```
Now when trying to remove rt from 1:2 class:

# tc class change dev lo parent 1:1 classid 1:2 hfsc rt m2 0kbit ls m2 201Mbit
ul m2 301Mbit
HFSC: Service Curve has two zero slopes
HFSC: Illegal "rt"

Ok, it doesn't accept empty service curve. Let us try to not specify rt:

# tc class change dev lo parent 1:1 classid 1:2 hfsc ls m2 202Mbit ul m2
302Mbit
# tc class show dev lo classid 1:2
class hfsc 1:2 parent 1:1 rt m1 0bit d 0us m2 100Mbit ls m1 0bit d 0us m2
202Mbit ul m1 0bit d 0us m2 302Mbit

Command is accepted but realtime service curve is still there. This is
apparently inconsistent behaviour. I would expect "tc class change" will remove
realtime curve if only link sharing and upper limit are passed.

If class has both rt and ls service curves, "tc class change" should be able to
remove one of them from class.

I would say there are two ways to achieve it:

1. allow to specify one of rt and ls to be "m2 0" and remove such curve from
class

2. respect passed parameters and when one of rt or ls is not specified, then
remove it from class if it is there

Second method seems to me more consistent.

I have looked at the source of iproute2 and check for two zero slopes is same
for adding and changing class:

https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/tc/q_hfsc.c#n410

It would possible to rewrite this check to allow "tc class change" to pass one
of rt and ls with zero m2. But I am not sure if this is enough and what will
happen if two zero slopes are passed to HFSC.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
