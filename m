Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6BB3355A6
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 05:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFED3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 23:29:38 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33240 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfFED3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 23:29:38 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so4196128pfq.0
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 20:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4Ef0nirmEraBXGoO/xfex12g/MC3WpaxrMid1law3SI=;
        b=ZD5czFcKcKBnQWJbG/uXtkMM1EDw9WCmG9EevCTnOiKLjTTKCjwOb5CiGE+mvp71qU
         useFGWgVoe3SwyF8fyhGMe+dovFxBTRzHSRetR9tc4qfXJOZQFs7h9Kwk2+zd4PfLfcH
         RWD8G/kCfqkPHpas/ymLffbqP/oUvp1MITp2vYgf1qd2VMZaG+SGs4wDPM8iW1a66gL1
         QmX4X7lydkfaXnqzD0Uz+6va5DUPVj0pP2Dbh4038bvjhlaXzQYbRCrON2SS4ZNDTus6
         le+sd75E2TiOEBe0iZ5W0tPy0E+RC/I9JYsvPxc9UfcbMU/ka/VkBgq7j5PhzCM1Ja3y
         +Ctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4Ef0nirmEraBXGoO/xfex12g/MC3WpaxrMid1law3SI=;
        b=gimzuDGXfbmFZmrF85Nzt5NDcaP9mN+qvwvzQdVfHRaoagSkfaAsq1u6ncemonj6fi
         WCHhYV3ANX+cofYqEhrBZk77kB5MK9omI7JD6Fl3O+jRtlucVYBWPnNuzVHL9jixz3YB
         JAcL13NNtqIWZ9b4gtWA7e8daVg5ukArnreUBlUZbQK2vOI1dcu+CJ5wW6DVYOmKYIko
         C52LfQ8EC6EeLsjYFACbVRu8sF/HpXps0H8UMj+ce268JSSvVl1oTA1UZJx1xBIqRZ0H
         ziwOvX1xABjlbXuWlyBrvekZK5clxFEjwSocj9hSfMadKdO4TnZZTSuV7BA4uKEHzHUB
         YoVg==
X-Gm-Message-State: APjAAAUFPnMITNN6+afLN5HE/Zw2rt143bGnoz++bD1wzJbfkTAIhsVP
        +8wZgsmZX1yj3J6zF/kbtdU=
X-Google-Smtp-Source: APXvYqzZZowMQwwaMKEojynwz5YeUxLqHWSN0760GZwAcvnGe+FV8pDiCQO1gfR70CS6drH04nerrg==
X-Received: by 2002:a63:8dc4:: with SMTP id z187mr1242157pgd.337.1559705377828;
        Tue, 04 Jun 2019 20:29:37 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 12sm8841482pfi.60.2019.06.04.20.29.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 20:29:36 -0700 (PDT)
Date:   Wed, 5 Jun 2019 11:29:26 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Lorenzo Colitti <lorenzo@google.com>
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Yaro Slav <yaro330@gmail.com>,
        Thomas Haller <thaller@redhat.com>,
        Alistair Strachan <astrachan@google.com>,
        Greg KH <greg@kroah.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
Message-ID: <20190605032926.GA18865@dhcp-12-139.nay.redhat.com>
References: <20190507091118.24324-1-liuhangbin@gmail.com>
 <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
 <20190605014344.GY18865@dhcp-12-139.nay.redhat.com>
 <CAKD1Yr3px5vCAmmW7vgh4v6AX_gSRiGFcS0m+iKW9YEYZ2wG8w@mail.gmail.com>
 <20190605021533.GZ18865@dhcp-12-139.nay.redhat.com>
 <CAKD1Yr1UNV-rzM3tPgcsmTRok7fSb43cmb4bGktxNsU0Bx3Hzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKD1Yr1UNV-rzM3tPgcsmTRok7fSb43cmb4bGktxNsU0Bx3Hzw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 11:25:11AM +0900, Lorenzo Colitti wrote:
> On Wed, Jun 5, 2019 at 11:15 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > How do you add the rules? with ip cmd it should has NLM_F_EXCL flag and
> > you will get -EEXIST error out.
> 
> The fact that the code worked before this commit implies that it was
> *not* using NLM_F_EXCL. :-)

Yes, that's why you got the issue.

> We rely on being able to add a rule and either have a dup be created
> (in which case we'll remove it later) or have it fail with EEXIST (in
> which case we won't remove it later).

With Maciej said, how about add NLM_F_EXCL flag when you add a new rule.
If it returned EEXIST, which means there is an dup rule, you just do not
remove it later.

Would that fix your issue?

Thanks
Hangbin
