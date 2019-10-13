Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE317D54DC
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 09:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfJMHRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 03:17:45 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:40901 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbfJMHRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 03:17:44 -0400
Received: by mail-lj1-f179.google.com with SMTP id 7so13590188ljw.7
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 00:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=uswqv9VQXg0uwLwRSluBNJaJk9pll+kaGWwH3edyJLo=;
        b=ZlZRQix/b0rYndsXz0jZ/NPvyL6kSet26Py1w5G+WwV05tWHSpVqJE8KE+OgEGejE9
         csP6993RVmzHylZeNnrQprH0qldaEi0LHVC0irBwgAhoVmrCj//EXB2rQZjOS24EvbaV
         HmIej14uEcGk61Lau19viMhWYQ+fCAp6PcA8tGQPmm5Ma2CR+8j5NSVuC1ulAgncQ21n
         rpj4UyKCgwjHBVIwaYmFUD55qHpeVDWsVPl1PBgAZn1EgsZTa5W5DgZHw4WwcFGaERuE
         4FBntGe8GVaa1V+XGQPcv3Jyyf0+i4+wTu787I1/rmeQZ9MRaNL4QFW3xnt/W0N5yZw0
         vtVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=uswqv9VQXg0uwLwRSluBNJaJk9pll+kaGWwH3edyJLo=;
        b=uiBzobIc39V8j4c8S5WZDbicvAtFrdjrpKDQQcK1r7QdH8B2NjFe1dS+TD/3DIkn4+
         75XsSJVNqRuE3+BMxmCqTaeSl8UblwWdoIrK462lUXVuYGdUR1v4ele+pDYMYAaI48UM
         Q+onDXAiV3xo0I/zsl0b9G+O2nofHMWGuZH4wOHn8ZNaTZfUdOB2p3aNPvNmmq09N+HI
         Gt9HPFJAgsvZdmz82RyX5qONTSPLv0mDgbdg8672elMBEIxhk1GrcML81F4ujMcUIzU4
         US80n0jBqr44P9tnYhyMY0W+KC+wMB7lRthSirQtrykKZii7TFRM4FkSdtskVDR+Ndpg
         HRXA==
X-Gm-Message-State: APjAAAXgZsr+B1YCK6n7Q8D+FzuiN627lX+rFu/O17r1fJ3cuvAxNhUV
        H0hjS7q1V+E3XHP00EuC04TS0es/v5XH2PDd9uteg8o8
X-Google-Smtp-Source: APXvYqzxBt+GhGpzVBN0tWuSRRZ8Dq1R4lj6CELaFKBuGa3jci/lrKTIa5/QgMuJMyVWMN5EW+iw7618SBk9ZQrJ5J4=
X-Received: by 2002:a2e:7003:: with SMTP id l3mr13820593ljc.176.1570951062630;
 Sun, 13 Oct 2019 00:17:42 -0700 (PDT)
MIME-Version: 1.0
From:   yue longguang <yuelongguang@gmail.com>
Date:   Sun, 13 Oct 2019 15:17:31 +0800
Message-ID: <CAPaK2r9hYN7ok09nPLaF9z2=aVATRWvDtYhM0-W1ozaykMwssw@mail.gmail.com>
Subject: ingress bandwidth limitation for ipv6 is inaccurate
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,all

1.  according to my test,  bandwidth limitation is inaccurate for
ingress ipv6 .  The accuracy is affected by burst.   if rate is less
than 100mbit , set burst to 1MB or 2MB, the result is almost
acceptable.  but when rate is bigger , the result is approximately 1/3
of rate.
command:  tc filter add dev qr-869fbdc2-1e parent ffff: protocol ipv6
u32 match ip6 src any police rate 500mbit burst 1M drop
so except for using ifb, what should be done to get a accurate result.

2. can flowid option of  ingess's filter belong to egress's class.
for example    tc filter add dev qr-869fbdc2-1e parent ffff: protocol
ipv6 u32 match ip6 src any police rate 500mbit burst 1M flowid 1:10
 (1:10 classid  is egress's qdisc's class )

thank you for replying my two questions
