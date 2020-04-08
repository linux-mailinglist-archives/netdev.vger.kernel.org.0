Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280FD1A2958
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 21:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgDHTak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 15:30:40 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:46079 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729297AbgDHTak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 15:30:40 -0400
Received: by mail-ot1-f54.google.com with SMTP id 60so5106911otl.12
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 12:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oP/A2ybxGuJwIMMoZUOiyYRpwDSGPOm62DRqTZafPXw=;
        b=UjlW526A1zBaA8DtiFJMY/STLWNjuYvn0PzSTS23CyDIqXfbDfByb5XEmQGWSheipL
         0t3i9g4m9Quu7lZ5ivdK4s3cV3w5IuoBapRzql5rPmIHQnuAqqksfu/cJ5+oCDpr9I3u
         ZCKRtsRpd+9JIltSSr6LcfecayqpJpcCqKt1Zf/Yzr7WllM5R6Q0CbASZ4k44Ya4Jbun
         UGSXbeN+Z0dz7DlNrgPI3BUjA8g25ewPEo0fqLq1sD5x7YelY/8cEnsqRCri9AtMMvza
         tR1H4VDcPQSNnHw7FvvZJob6bluDv6+V+E2dK9RTXEGwgogluhs077s2G0shoOPNGbac
         Lhfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oP/A2ybxGuJwIMMoZUOiyYRpwDSGPOm62DRqTZafPXw=;
        b=su4sffUiii3JileHpf2V1YxVxl9Wn1U/w2EC3msqGRh5ywrOsWuNOPlVNzBkYUGJqt
         DznPatrR40rNLJtftXIS6nZYLmgqRFCqX4UKWP4aEXqzMEDYUU3tb/mM0G80QOjeF9jW
         BhvZAd8tlJwzCMcI0O6on6/jxx/dnTQJ76cFSsCTLSu+wRdtpps4dj4raWD8uZ2rmsf9
         25HZZeKfyl6XR5+GLGrbuPDhBr+EYAYvpfLN70IHsxj7XrpIEnh9D+nOC8VJpBaO/Cqe
         qo16cch9kX+bbEWFdSjZGigHXnlUbgnDyoWkoJ6uStJtwSZF/V+h+o6AlFVBksDA+G/o
         SuJg==
X-Gm-Message-State: AGi0PuYyJTo8/7BX2MxUV5e2uAAX2hfltJD5vpBBHXFR9b/agEQsupkJ
        k6VDcs0vXiztFfPh3LNJI6Dct2YwZmE2lUl6S8ys08YyynU=
X-Google-Smtp-Source: APiQypIGCqpbVf4m/dv5/vD3zEO+IubhR09VnoaMnijaB9Zh4LdZwlSVrXgDkLFIJEGnAUFqWpyKAcRXo3SBLa+mvEE=
X-Received: by 2002:a4a:ba0b:: with SMTP id b11mr7250693oop.92.1586374239227;
 Wed, 08 Apr 2020 12:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <HE1PR0501MB2570BC6028E3020D84AE4E40D1C00@HE1PR0501MB2570.eurprd05.prod.outlook.com>
In-Reply-To: <HE1PR0501MB2570BC6028E3020D84AE4E40D1C00@HE1PR0501MB2570.eurprd05.prod.outlook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 8 Apr 2020 12:30:28 -0700
Message-ID: <CAM_iQpWOn=Y+f-2F-uAGC16eKVKjwE1JtngRRyeATt9Xrw2ELg@mail.gmail.com>
Subject: Re: Weird behavior (bug?) with mq qdisc
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 8:13 AM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
> I would like to hear more opinions on these two issues (1. qdiscs are
> not shown when the number of queues grows, 2. tc qdisc del for a queue
> reverts to noop, rather than to some sane default). Any ideas about
> fixing them, especially issue 1? Some kind of notification mechanism
> from netif_set_real_num_tx_queues to mq or even complete reattachment of
> mq when the number of queues change...

For 1) we don't update qdisc's when changing tx queues, it should not
be hard to call ->attach() in netif_set_real_num_tx_queues(). But it is
not easy either, because mq_attach() merely attaches default qdisc's,
let's say if you already have 4 non-default qdisc's in your case, you
probably want to just duplicate 4 more when growing to 8. IMHO, this
is not a bug, it is just inconvenient.

For 2), I do not think it is a bug, as you can think noop as a deleted
qdisc.

Thanks.
