Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355DB391A6
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 18:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfFGQKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 12:10:01 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33897 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729325AbfFGQKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 12:10:01 -0400
Received: by mail-oi1-f195.google.com with SMTP id u64so1823015oib.1
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 09:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yvPm0jT5dgCFde5iRkHUuHlJx4ZoVDITe9+0bHAtcTY=;
        b=Mcrj5y9eBKsJQSh5lwTGt/AmHpKPKT3Rl3JWZhwZ38wCoxKxTLRklI4Dk6gvbHSn9d
         cSAUZRdPG4jfS9wyi86utqgTQOCmyNRenIMYI5NsOf7b3znE8gmmOGy+erAeDM9zKxTU
         SK3CtjJk8aDOE9kjHiBAOT0Wl42TN0m/SIxfzEMIE8z/mtW18Zcg7XB50pXiLfLeoZ8R
         U6n1d1yTsSPwG2ltulVcKs6GJBhJRny/IxsZdyBAVRg0V4KRw0ur23fZVWZzVCj0uACC
         J+JHfRp44JFWOB4hJqaM7pt8qdUmkCEYMQtw9jW9XAX35wUwIBLWFWREcUXJVd3xmPyi
         7sAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yvPm0jT5dgCFde5iRkHUuHlJx4ZoVDITe9+0bHAtcTY=;
        b=VteEoLp3/9EFr1VMMkDXUjs+JCGxcZCpIbYtxwFBSnJEV6dJrYEomz9UxMtX7Du6cg
         zHsJ7O/of3AXP0KNpYBYJN88F60uyt9pmF5sdwoWNIsszUqGMEBlug3zKox4VB5YCM9G
         RJ4bS9HxoK/yReeAJO1c9weYba7D4zJfwcxBshjM2i/vhhfW2Zv60B56KPjCFQ+hMWVO
         P7b8g+4tzxPkQt4OINej8XFw99O107X0VZfoobz+7oZb6D3JqIrDdL8rW+2Wun27Mp+c
         /2ua0lOkCDNbT3tStxFhIqR58wF4IqRCg4a/qxeqNhIlUaP+n8oZ8X133rcG7Y0XxeUA
         5ehg==
X-Gm-Message-State: APjAAAWRAj7wIiEXUn8Puw0H+gsYyp4lvdVwyUyfGQoTLtH2eKrtY3we
        TozTezkaUHhI0Rr8FFyy4vmGHXsxlLry5NpEnp1lTw==
X-Google-Smtp-Source: APXvYqwEqcAnm0aagapFCEQv4oVgrfCRSZL8odU7ijM7heoOM9yRV/50+c9sPS/kZBitVI/vxMB38tY/kqWn/pbK+5o=
X-Received: by 2002:aca:d550:: with SMTP id m77mr4406793oig.155.1559923800824;
 Fri, 07 Jun 2019 09:10:00 -0700 (PDT)
MIME-Version: 1.0
References: <1559768882-12628-1-git-send-email-lucasb@mojatatu.com> <66ee49271b9ecc89cd2ee7b9fbffd298ae219d14.camel@redhat.com>
In-Reply-To: <66ee49271b9ecc89cd2ee7b9fbffd298ae219d14.camel@redhat.com>
From:   Lucas Bates <lucasb@mojatatu.com>
Date:   Fri, 7 Jun 2019 12:09:49 -0400
Message-ID: <CAMDBHY+DSWg5GbHEHbEh4H96DfxuZ4Vv6Lx=LRHz4jxCH6esRg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/1] tc-testing: Restore original behaviour
 for namespaces in tdc
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, kernel@mojatatu.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Hangbin Liu <haliu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 7, 2019 at 8:18 AM Davide Caratti <dcaratti@redhat.com> wrote:
> From what I see, it is a fix for the reported problem (e.g. tests failing
> because of 'nsPlugin' uninstalled). And, I want to followup fixing the
> bpf.json in tc-actions, so that
>
> # ./tdc.py  -l -c bpf | grep eBPF
>  e939: (actions, bpf) Add eBPF action with valid object-file
>  282d: (actions, bpf) Add eBPF action with invalid object-file
>
> require the buildebpfPlugin (unless anybody disagrees, I will also revert
> the meaning of '-B' also, like you did for '-n')
Yes, those should definitely be tagged.  I probably should have
included them in the patch.

As for the -B option, that would probably be a good idea.  Required
plugins, I think, should always be on and require a user to explicitly
not use them.

So in that case, nsPlugin and buildepfPlugin, being required, should
have options to explicitly disable their features.  valgrindPlugin,
since it's not explicitly required to run any given test, doesn't need
that.  Maybe we should separate the plugins into different directories
based on this?

>
> few comments after a preliminary test:
> 1) the patch still does not cover the two categories that use $DEV2 (i.e.
> flower and concurrency still fail in my environment)
I will have to try that out and see what is going on.  I didn't try
the $DEV2 tests against this.

> 2) I've been reported, and reproduced with latest fedora, a problem in
> nsPlugin.py. All tests in the 'filter' category still fail, unless I do
>
> # sed -i "s#ip#/sbin/ip#g" nsPlugin.py
>
> otherwise, the 'prepare' stage fails:
>
> # ./tdc.py  -e  5339
>  -- ns/SubPlugin.__init__
> Test 5339: Del entire fw filter
>
> -----> prepare stage *** Could not execute: "$TC qdisc add dev $DEV1 ingress"
>
> -----> prepare stage *** Error message: "/bin/sh: ip: command not found
> "
> returncode 127; expected [0]
>
> -----> prepare stage *** Aborting test run.
>
> (maybe we should use a variable for that, instead of hardcoded command
> name, like we do for $TC ?)

Ooh...  Yes, yes we should.  Sounds like the new version of Fedora
isn't including sbin on the path anymore?  That's going to require
another minor change that I think I'll submit in a separate patch.

Thanks, Davide!
