Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE701B453C
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgDVMeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726060AbgDVMeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 08:34:23 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79B0C03C1A8
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 05:34:21 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id 19so2103923ioz.10
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 05:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GO9nhsK9rBOh932LJIbc4WaKC+wtXfAr4gvyI6gzsvU=;
        b=VtwPqJmd8ki9C/ko5iqLm+kNeNWjIEPAuOJt6az1gsJDy2+7KGqs++Ix3968HOkplJ
         8P5/Vk6wsbuYgNoVKxEITsUScr0IbrCyFF9n6h3PAeDQ9MV8znRhOl4y5+Y4ajzJWzfx
         H/CuyYXu4HbqtyA4FiYBhrob295hzWBBloj3L54g88c5J5g2l2cB2sTaBuBlmAgJCpcp
         iUDK2CkPaWGqXi57zwlyllbYpmD7Q0yAB5OHgnQLSmqq2u1nAJC+cHyqgDpNrO1BpLsP
         kVmrLqmck8eCbX5We1s/gt8k5z+tLSmP70QrkM8YxYXqU8fAXatSqOMuFyU5DMXzi4T3
         28gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GO9nhsK9rBOh932LJIbc4WaKC+wtXfAr4gvyI6gzsvU=;
        b=VpFQvvlTC/Sa0Rlct5g3xj5DeKcXmBa6h0WAYdhCn3Os3NpfnXju459tnV/HkwT2bP
         lunwmLgqiNP0kYwizio1/+vyMKZM/EHZb9WZAIOnQE/ZnVAIG1xsoegCxUkXnRlwEXLS
         3ge0yZs09yIgJYaUtUUqfpkP7L2op8AQpUZzqIZMofw9EKVoITnemvpbXK7GQiuRwtiQ
         7g2kSmSjVt5nZcdlf+vK6m6UwfpgcRNxA5kXVWAqaTKVagqM8nOFJrEF03Wzw4J9DbWT
         eJOS885dniCElXGxCAs+KPPFSedDcdPcccWJxOrleXXlNTgp5ZAHcMZlQPM67S7lXUKQ
         J8HQ==
X-Gm-Message-State: AGi0PuZDJTP+RnmOdwoYdxZqOgzV3HSduhoeakcb1y5lYfI9/rBc+sRE
        z6na/OpU+6IUSt9AXWOnk2QwZVTzJzX9XA0Lt1s=
X-Google-Smtp-Source: APiQypLadjkomXEXLQ0/KZf5tV1TjZ/1NLF4ei4qrulQzHNevRkBppgKYfGFBl1gE8DNsONPm9iqjiOutYvKq0nbI7c=
X-Received: by 2002:a6b:b8d6:: with SMTP id i205mr26214653iof.123.1587558860874;
 Wed, 22 Apr 2020 05:34:20 -0700 (PDT)
MIME-Version: 1.0
References: <49178de1-75cc-4736-b572-1530a0d5fccf.mao-linux@maojianwei.com> <a9a64f23-ed11-4b8d-b7be-75c686ad87fb.mao-linux@maojianwei.com>
In-Reply-To: <a9a64f23-ed11-4b8d-b7be-75c686ad87fb.mao-linux@maojianwei.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 22 Apr 2020 05:34:09 -0700
Message-ID: <CAA93jw4imiBa9JBjAs4p5R1bM_asBiTQzKE9zqnNVKRmGB=aYQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: ipv6: support Application-aware IPv6
 Network (APN6)
To:     "Jianwei Mao (Mao)" <mao-linux@maojianwei.com>
Cc:     netdev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>, kuba <kuba@kernel.org>,
        lkp <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

as near as I can tell, this is not even an accepted working group item
in ietf 6man. (?). Normally I welcome running code long before rough
consensus, but in this case I would be inclined to wait. There also
seems to be some somewhat conflicting ideas in spring and oam that
need working out.

It would be good to have an example implementation that could actually
parse and "do smart things" with this additional header, e.g a tc
filter, ebpf, etc. It has the same flaws diffserv has always had in
that any application can set these fields arbitrarily, with the
additional flaw of changing the mtu if these headers are added or
modified en-route.
