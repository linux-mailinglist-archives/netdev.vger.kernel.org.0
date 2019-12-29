Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E000412C951
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 19:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387600AbfL2SEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 13:04:37 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33386 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732220AbfL2SEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 13:04:35 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so16986410pgk.0
        for <netdev@vger.kernel.org>; Sun, 29 Dec 2019 10:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YUrSj/QPvSWe9sDF33hbKWhr4NJQS9iwHC33OQIyAcc=;
        b=0YbtmRID+Pz4j1hbPrifrYTbpUF/V1tGz+V/heNfod8ez1JYkGnBdXvfRZfoMdwzKL
         sPVaH7IlmOGHoHoM4z16GcKIArr2EvVXJ+kFOq4rElMySN6z8mAcq84hNlWeLu+1jU+c
         W9PiOwHkfdb2bY+KvWAYr4X3DY9Txs2Gx2REwGSCb6XdpMfN5dAI/5JYw+vi9N4gmjRA
         Om7E+w4HUGBhWuewUNRyuw7v7K4PFJE4JStrF95EmNtGLLePMSStfuhtyu9ZXoixHq8b
         zDlUpKJILPw2fk2gmDpBfGduF/+yzeeYpbIY6kOzrDwQ9/Oi1Hih3ONqtKZ3CZs7DGji
         0XmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YUrSj/QPvSWe9sDF33hbKWhr4NJQS9iwHC33OQIyAcc=;
        b=BrhLbTQ3Z7ssNaMxzSDhiUdgzeJxgv7AynkdaLXpv7l453+9cQkUH3SgVqdoPn40bu
         JRwfcHT8NKQAodqI1QP7eujypMgm0AHzk4YS6em68cy20zutvl6skzYFPbOezIPowwAf
         7kfAsGOB8ZaxaOcrwwjpsInUDbWyFoTo2NB4yrTt9ym+EwaBACYHsHLZZgOkVSmt5HYS
         GeAIvDo7XzhhXEVtD0C9gVmBv7ikGj0GSPu+DtORxQwFiQ0WKeU5IfS9iNfQN0lICf6J
         PyEAh3470YU4IVLIj0lrzqosUP4eRmNw/eEgHjtpudQJhSX4LVh/atpPcVXesAdJM7RZ
         hLaA==
X-Gm-Message-State: APjAAAVHoR30MhM+i0/yR69c97/sg8SoFv5eve6nbFlcSQk0D16LhPo2
        +82dwT5Ss7hLpbJvrlNcp6h4f1bEXhM=
X-Google-Smtp-Source: APXvYqxvamy0SVKPMR6jwNcZ0xHIIsxoPGIhFJf/csSUrQ2b2k3A3QmOaH4xVXOijHK9TcxLQaXxug==
X-Received: by 2002:aa7:982d:: with SMTP id q13mr66575457pfl.152.1577642674909;
        Sun, 29 Dec 2019 10:04:34 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r37sm22175969pjb.7.2019.12.29.10.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2019 10:04:34 -0800 (PST)
Date:   Sun, 29 Dec 2019 10:04:26 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Leslie Monis <lesliemonis@gmail.com>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 00/10] tc: add support for JSON output in
 some qdiscs
Message-ID: <20191229100426.08babcc5@hermes.lan>
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Dec 2019 00:34:08 +0530
Leslie Monis <lesliemonis@gmail.com> wrote:

> Several qdiscs do not yet support the JSON output format. This patch series
> adds the missing compatibility to 9 classless qdiscs. Some of the patches
> also improve the oneline output of the qdiscs. The last patch in the series
> fixes a missing statistic in the JSON output of fq_codel.
> 
> Leslie Monis (10):
>   tc: cbs: add support for JSON output
>   tc: choke: add support for JSON output
>   tc: codel: add support for JSON output
>   tc: fq: add support for JSON output
>   tc: hhf: add support for JSON output
>   tc: pie: add support for JSON output
>   tc: sfb: add support for JSON output
>   tc: sfq: add support for JSON output
>   tc: tbf: add support for JSON output
>   tc: fq_codel: fix missing statistic in JSON output
> 
>  man/man8/tc-fq.8  |  14 +++---
>  man/man8/tc-pie.8 |  16 +++----
>  tc/q_cbs.c        |  10 ++---
>  tc/q_choke.c      |  26 +++++++----
>  tc/q_codel.c      |  45 +++++++++++++------
>  tc/q_fq.c         | 108 ++++++++++++++++++++++++++++++++--------------
>  tc/q_fq_codel.c   |   4 +-
>  tc/q_hhf.c        |  33 +++++++++-----
>  tc/q_pie.c        |  47 ++++++++++++--------
>  tc/q_sfb.c        |  67 ++++++++++++++++++----------
>  tc/q_sfq.c        |  66 +++++++++++++++++-----------
>  tc/q_tbf.c        |  68 ++++++++++++++++++++---------
>  12 files changed, 335 insertions(+), 169 deletions(-)
> 

Applied, thanks for doing this.
