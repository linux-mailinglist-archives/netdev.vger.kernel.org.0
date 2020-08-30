Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDF3256ED0
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 16:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgH3O6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 10:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgH3O6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 10:58:25 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675C5C061573
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 07:58:25 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id b17so607624ilh.4
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 07:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hOx/cTUh9IAdjmbbm55Ym/oYzZwtGhVDXvbLNdpw9JE=;
        b=ov58osLTGWD67UzlelpjvthRt9qJ7ozWAs+En8Eh81UdX2o5B7xdW+XV5DLfsFkhaz
         uE79JP+iv6aJSKoGCpJsK4Wa4vZHMzhacdqnEkyFKrwkZxapj0xb2Bx7LimWZyVuz5yr
         3IKqnFEmi9wlzzuhgXfDe1Fx/40dpaS4sD+H7v+ZDN6F5dikClansEssPq4x2A5b5xij
         gyWmjpxojVaZq4ZR7Rbzs2jKG/bSu5PSHfl0Cld9f+EQPVBn7QVrMkGrqyCBxGLOx6qH
         FxzsQPe3wxJUo6HT78l2lP0GQs7SCXS3tZZk7XGdKnWHnpmGAZJ89SmE9jJWiu9RmSNe
         mciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hOx/cTUh9IAdjmbbm55Ym/oYzZwtGhVDXvbLNdpw9JE=;
        b=Y9jveCXIPcZj0uJ5wk+OnTs1Uk7XBoRw4D47QEF+pLCVHoyY3inBshjydh7FU7ntpM
         7f0AH65+O7zl9JyP7KorjIelNsqRRYiPzB85XyTb5sPVoFZagoM37+IuAogX+blEWLLk
         Fl/lJaxbn5sBOM5PGu22ctNuHWHV9JZhXS1WC2NUTHsA7/DG4kVqJ/4zYL6uYt8m+6lU
         8O75C/IB3v1DAXWeXy6L5Vp/6Zuu+ZERpYOPNAqN1j30PtXB99rHBu2QxvFctgXV9v1g
         kgTAEnm0DesI6uGAkbJC0uO6wryv5ZjPZ2f9NBjxWrhfgU0gpQi/J0f0pi08XVLoJ+tY
         doSg==
X-Gm-Message-State: AOAM530foWyDNCs5RPtFKUADvkoyOdpeJevWKtJO0iK8t56Q6d96zLDd
        LKJq8CDB+Fm4O05ojL5rnzDTukJLmIw4j5pNH9Ej+lBrxoDJbg==
X-Google-Smtp-Source: ABdhPJxDy6TOlzr+H9rFXDbWyZd/tfJpoNAQxoYnMOskUy3OWdF4D5GguJwWdFU1fEMrDIerH+hK53k6yvBfoeGwSAk=
X-Received: by 2002:a05:6e02:14d:: with SMTP id j13mr1113588ilr.245.1598799502297;
 Sun, 30 Aug 2020 07:58:22 -0700 (PDT)
MIME-Version: 1.0
From:   Denis Gubin <denis.gubin@gmail.com>
Date:   Sun, 30 Aug 2020 17:57:46 +0300
Message-ID: <CAE_-sd=Hfdhx1o8LmBB8eWanjLQEWe7UZ=SkqBP2wtJdDfvdzQ@mail.gmail.com>
Subject: tc filter create hash table and filter rule
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good day!

I want to understand how tc fitler works.
Could you please give me some advice for it?

I want to add and delete fitler rule by full handle but I can't do it.
I need some article where I can read about tc utility.

For instance I want create one filter rule and then delete it.

The commands as follows:

tc filter add dev eno5 parent ffff: pref 45000 handle 555:0:1 protocol
all u32 match u8 0 0 action mirred egress mirror dev lo

I get an error:
Error: cls_u32: Handle specified hash table address mismatch.

Ok. For started I'll create hash table with number 555
tc filter add dev eno5 parent ffff: pref 45000 protocol ip handle 555:
u32 divisor 1

I don't get an error.

Then I show output
tc -s -d filter show dev eno5 parent ffff:

filter protocol ip pref 45000 u32 chain 0
filter protocol ip pref 45000 u32 chain 0 fh 555: ht divisor 1
filter protocol ip pref 45000 u32 chain 0 fh 827: ht divisor 1


My question:
Why do I see the third string  "filter protocol ip pref 45000 u32
chain 0 fh 827: ht divisor 1" ?

I think I should see only two strings, should I ?

filter protocol ip pref 45000 u32 chain 0
filter protocol ip pref 45000 u32 chain 0 fh 555: ht divisor 1


Ok. Go ahead.

I want to create filter rule with full handle 555:0:1

tc filter add dev eno5 parent ffff: pref 45000 handle 555:0:1 protocol
ip u32 match u8 0 0 action mirred egress mirror dev lo

I get error:

Error: cls_u32: Handle specified hash table address mismatch.
We have an error talking to the kernel, -1

Then I use 827 hash table number:

tc filter add dev eno5 parent ffff: pref 45000 handle 827:0:1 protocol
ip u32 match u8 0 0 action mirred egress mirror dev lo

I don't get an error. I am showing the output below:

filter protocol ip pref 45000 u32 chain 0
filter protocol ip pref 45000 u32 chain 0 fh 555: ht divisor 1
filter protocol ip pref 45000 u32 chain 0 fh 827: ht divisor 1
filter protocol ip pref 45000 u32 chain 0 fh 827::1 order 1 key ht 827
bkt 0 terminal flowid ??? not_in_hw  (rule hit 0 success 0)
  match 00000000/00000000 at 0 (success 0 )
action order 1: mirred (Egress Mirror to device lo) pipe
  index 26 ref 1 bind 1 installed 7 sec used 7 sec
  Action statistics:
Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
backlog 0b 0p requeues 0

My question:
Why can't  I create the filter rule with 555 hash number ?

If I create filter rule with handle ::1 ...

tc filter add dev eno5 parent ffff: pref 33000 handle ::1 protocol ip
u32 match u8 0 0 action mirred egress mirror dev lo

And I show the output
tc -s -d filter show dev eno5 0 parent ffff:

filter protocol ip pref 33000 u32 chain 0
filter protocol ip pref 33000 u32 chain 0 fh 829: ht divisor 1
filter protocol ip pref 33000 u32 chain 0 fh 829::1 order 1 key ht 829
bkt 0 terminal flowid ??? not_in_hw  (rule hit 0 success 0)
  match 00000000/00000000 at 0 (success 0 )
action order 1: mirred (Egress Mirror to device lo) pipe
  index 29 ref 1 bind 1 installed 1 sec used 1 sec
  Action statistics:
Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
backlog 0b 0p requeues 0


... I'll can see that hash table with 829 number with ht divisor 1 has
created yet and rule 829::1 created yet. But I want to control hash
table number by myself.
I don't want tc utility do it by itself.

Can I control creating hash table number by myself ?

Best regards,
Denis Gubin
