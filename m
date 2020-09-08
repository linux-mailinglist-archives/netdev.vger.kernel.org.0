Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F99260B62
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 08:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgIHG5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 02:57:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58427 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbgIHG5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 02:57:41 -0400
Received: from mail-lj1-f200.google.com ([209.85.208.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kFXZQ-0002qR-SA
        for netdev@vger.kernel.org; Tue, 08 Sep 2020 06:57:36 +0000
Received: by mail-lj1-f200.google.com with SMTP id s14so4311158ljj.6
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 23:57:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vzp7zmy16qSTY1Tj4XpNRu/ljIgkqSbcbe8XDlpXvi4=;
        b=qc/QupfuK4091OguZb5sP0lVPh78LFPrH/bX6zct7vUPNthR9Sn1RHYYY0uT3iuEle
         Rh9PjgXmNqridR8AYKLWS5du8ewZzziQUhIuq8Sd1fGgOaETeDiz6iEEhhCljZiQWX0H
         XURj7mq2meBrxTXw2hIiZ4IjGLngITBRNz5ZkcS/a+TRoL+ph2LA4rfdy7fcsMJv4jN5
         sQZ7L1tjlIowk2Plh3K9HqHh9XgnEK0L7DQz0E5TFpC1ra44pT4XMesAbzotDL/Wwk9q
         SsgSLUBqEPXnTiOccGBU75qtP0zW0deNqcwir8UO4vRilG1t/kkj8+zSFyqVezkIA7gQ
         LdZA==
X-Gm-Message-State: AOAM530fZGcpj+llDH1YHgJeoVFJuK8Z40UE1kZdIAnbipQCDN8Y9H+B
        LUYP3D4T6zPQ7QI9ED/YyuAk8SvF6h4qOw7x7++ylHXt2OeJF8hLLtsMFlpnHM49I8sYcUuHrjk
        UkJKCB8MWqZpk9ek5oGkO6KWOdNyHIxxvp8BsJCAgMQib0ODA
X-Received: by 2002:a19:a411:: with SMTP id q17mr11860165lfc.203.1599548256274;
        Mon, 07 Sep 2020 23:57:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygp/Cy9i5kwwqPW29UqRHI61VnfUXcFf9tILlkpm11JRKPQHotL77csl2OK1RXodhDbYgfkWa4aatVJw3RBRA=
X-Received: by 2002:a19:a411:: with SMTP id q17mr11860150lfc.203.1599548255889;
 Mon, 07 Sep 2020 23:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200907035010.9154-1-po-hsu.lin@canonical.com> <20200907131217.61643ada@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907131217.61643ada@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Tue, 8 Sep 2020 14:57:24 +0800
Message-ID: <CAMy_GT-kaqkcdR+0q5eKoW3CJn7dZSCfr+UxRf6e5iRzZMiKTA@mail.gmail.com>
Subject: Re: [PATCHv3] selftests: rtnetlink: load fou module for
 kci_test_encap_fou() test
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 4:12 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  7 Sep 2020 11:50:10 +0800 Po-Hsu Lin wrote:
> > The kci_test_encap_fou() test from kci_test_encap() in rtnetlink.sh
> > needs the fou module to work. Otherwise it will fail with:
> >
> >   $ ip netns exec "$testns" ip fou add port 7777 ipproto 47
> >   RTNETLINK answers: No such file or directory
> >   Error talking to the kernel
> >
> > Add the CONFIG_NET_FOU into the config file as well. Which needs at
> > least to be set as a loadable module.
> >
> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
>
> > diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
> > index 7c38a90..a711b3e 100755
> > --- a/tools/testing/selftests/net/rtnetlink.sh
> > +++ b/tools/testing/selftests/net/rtnetlink.sh
> > @@ -520,6 +520,11 @@ kci_test_encap_fou()
> >               return $ksft_skip
> >       fi
> >
> > +     if ! /sbin/modprobe -q -n fou; then
> > +             echo "SKIP: module fou is not found"
> > +             return $ksft_skip
> > +     fi
> > +     /sbin/modprobe -q fou
> >       ip -netns "$testns" fou add port 7777 ipproto 47 2>/dev/null
> >       if [ $? -ne 0 ];then
> >               echo "FAIL: can't add fou port 7777, skipping test"
> > @@ -540,6 +545,7 @@ kci_test_encap_fou()
> >               return 1
> >       fi
> >
> > +     /sbin/modprobe -q -r fou
>
> I think the common practice is to not remove the module at the end of
> the test. It may be used by something else than the test itself.
>
Hello Jakub,
Thanks for your feedback.

For this case I think it's safe to remove the module here, as it was
never loaded before and thus causing this test to fail.
If other tests in this rtnetlink.sh need this fou module, we should be
able to spot those failures too, however this is the only failure as I
can see.
(pmtu.sh will need fou module to run as well, but it will be loaded there.)

Shouldn't we insert the required module whenever the test needs it? So
that we can run the test itself directly, without depending on other
tests.
Also, I can see modules for tests were being unloaded in other tests as well.

Thanks

> >       echo "PASS: fou"
> >  }
> >
>
