Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 362E4ABA31
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390731AbfIFOFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:05:33 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:41041 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729217AbfIFOFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 10:05:33 -0400
Received: by mail-lj1-f174.google.com with SMTP id a4so6116630ljk.8;
        Fri, 06 Sep 2019 07:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=182E5sg6St3sZx9J5F9ld4St4yIHLxY1HEKoKECXpBc=;
        b=JEKLD6Udpjv3dyPimpG7jJ8zyUiraLdGh8lpj9iw4UrbRtK+ogpYKJqP5a8Y5+2MHo
         I60inS7EdBPXh6sDqxXVGgwa8yM3rBrv4gPIzD1MPe3hKmQF8Ro3+4eMl8tkyL4fqPL1
         +twutwosG4z0d9J7exny7YWaOzCfLjgGEFquLOd9/goy84KdDo2eIK+S0noPFP+d5ZKb
         NLaFD8dIv/sz/t8Q1lwxYXOKj8CUv6zCvpAlXzZC0zUBEi0fDb5EEVFqZH5WPf6f7InK
         fEaPfDAS7dDrGt5q97FSMzRDC4Rz06xlyNkVw8wEORspzUj+vuQ8Cjgcr0kFcxcN1Iww
         n8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=182E5sg6St3sZx9J5F9ld4St4yIHLxY1HEKoKECXpBc=;
        b=udzZzEt/ySEIaXpCHYNNTJsU+FisgCruRXb2XJtbtEo0qTusHosDyi81srGzqq8RVK
         UqoOAD1oSm/f89uYvtRAaETq8X7pJk0OTut2SQpQSYuuW64bPzoyt/rEudWOXOr5UZCy
         Gs6x+6n7+mdSuvY4A+N/pviVUmZmIU2GCc7hX6cznTnE8WW7jESUagXS4DLzoIcswyjt
         lHMp2akxZYCarK4o/87VtL0cpih7/G4I9DYag7iug4WKrY1GS7Tjhz/kjm7pJQgGuud5
         /v2PQ12JEQGfMUq0+K2Fg/yA7sc6mv+W6v+66bL6mymA2+iQOKR2u69iE9V0Z8wT13A4
         FmZA==
X-Gm-Message-State: APjAAAULrh20L3X2WWTx5EV2x2pnNqL/wOcTFfp2KB408uMkncNYkGXj
        WvSNqGuxsNOE6EE1y8WTy7SnEE6Ue0eZMgBqQMY=
X-Google-Smtp-Source: APXvYqwMa/CMglE9NosfpBvYlVJ8HfjTa5yYJ6yVe+BtVtxjN6t3qJ+3wsWhuYk7gmwDLc1Y3nFcpTcjl69x+v4UdVg=
X-Received: by 2002:a2e:7d0d:: with SMTP id y13mr5869218ljc.191.1567778730893;
 Fri, 06 Sep 2019 07:05:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190906094158.8854-1-streetwalkermc@gmail.com> <440C3662-1870-44D8-B4E3-C290CE154F1E@holtmann.org>
In-Reply-To: <440C3662-1870-44D8-B4E3-C290CE154F1E@holtmann.org>
From:   Dan Elkouby <streetwalkermc@gmail.com>
Date:   Fri, 6 Sep 2019 17:05:19 +0300
Message-ID: <CANnEQ3HbaH9c7OD1CZU0KMubsqFQT5ZpUTG_W1H8uXJzahV7ag@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hidp: Fix error checks in hidp_get/set_raw_report
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Fabian Henneke <fabian.henneke@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 4:56 PM Marcel Holtmann <marcel@holtmann.org> wrote:
> patch has been applied to bluetooth-next tree.
>

Thanks a lot!
