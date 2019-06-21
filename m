Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34064DE26
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfFUApx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:45:53 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46974 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfFUApx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:45:53 -0400
Received: by mail-ot1-f68.google.com with SMTP id z23so4586234ote.13
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yn83a1qnKvst/9+tB+MPPbc1m+I8WEQi/GEdO9P6tXE=;
        b=AfdscoZY8FTKhS/IU/se9zotn8sYAlkd6CkW3o6sriJoE2iCHvbectl6id1/oCMtgj
         w3ggqtPxzCartLjblSnXJBiutJjc7hQ6+wRdehNSFGytK470P942O/5PzJBNZyc0FS1E
         i2UWf/0XJ7aEeTzbV5jsaIjcEqQ/arY+PoYnfecaZgJAnHoozI4pQ0aYNgX6j8xR8BNS
         3U1WL3nMx6cB0RA7ttgMFYQ7eu4ED6vH3nzOEEcxpeRkKZlJbQexMJoztJuCDK45zX7F
         lNWQSMCTyv37HslFvxqWK6eAZn8wjS0mJvivj9dTBfm5+bLj0rFJmPirIFJ/IWS6RK5t
         mkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yn83a1qnKvst/9+tB+MPPbc1m+I8WEQi/GEdO9P6tXE=;
        b=Ds2xcgq0U0C4Qyw3LmNAmPhZMNnnL+YS7VgoDGrduIrZM3M8UM9AYV+fuz3LG+SFbM
         HuDGef8wB2qH1XM3AQAImp2oqKSItqxUM6iH6EkAlU73NRkuueWFE+q8LUktADDQ62YV
         HSDUcxcKRoQDVw12VAop5GpSyJxd9Xu5GANgWL1M8HfwfcbzL29yEodwE76O/z+O9nYL
         IBhbyJPjsPpR4BPsfuV9m/tQqGqgEhqfQRa5LEqV0f+F9cJBUqvo01+mbRSlao8YFRou
         qwuO2sICvf1kYuyOVAJrCCkAQ3Pfng4mZ8HTq1O3iZxaby0vsLT0Josa0ckBbWC0js0i
         +i9g==
X-Gm-Message-State: APjAAAUXFxN6Bys1cI5+gpEpJVGj5IYgwCDIDYaBW+LMZlzmq0cdN1iH
        mVaofP5691jbQzkbb9MIVYzHmNUR2PGluvM6keNJWA==
X-Google-Smtp-Source: APXvYqyBrPyZHtEKg52tGGot/2xwoVfzPk3+J8qs5bRpCw7GC47U/QeXwAok2m7h8+rRa11dfED6WRWrU5GMZQnTKJg=
X-Received: by 2002:a9d:7184:: with SMTP id o4mr6978816otj.65.1561077953046;
 Thu, 20 Jun 2019 17:45:53 -0700 (PDT)
MIME-Version: 1.0
References: <1559768882-12628-1-git-send-email-lucasb@mojatatu.com>
 <30354b87-e692-f1f0-fed7-22c587f9029f@6wind.com> <CAMDBHYJdeh_AO-FEunTuTNVFAEtixuniq1b6vRqa_oS_Ru5wjg@mail.gmail.com>
 <0bd19bf9-f499-dc9f-1b26-ee0a075391ac@6wind.com>
In-Reply-To: <0bd19bf9-f499-dc9f-1b26-ee0a075391ac@6wind.com>
From:   Lucas Bates <lucasb@mojatatu.com>
Date:   Thu, 20 Jun 2019 20:45:42 -0400
Message-ID: <CAMDBHYLYpbARw1P3YadLMbm8R3CDaT83R2J0n6P22OwYFxi-Pg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/1] tc-testing: Restore original behaviour
 for namespaces in tdc
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, kernel@mojatatu.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 4:52 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
> >> From my point of view, if all tests are not successful by default, it scares
> >> users and prevent them to use those tests suite to validate their patches.
> >
> > For me, explicitly telling the user that a test was skipped, and /why/
> > it was skipped, is far better than excluding the test from the
> > results: I don't want to waste someone's time with troubleshooting the
> > script if they're expecting to see results for those tests when
> > running tdc and nothing appears, or worse yet, stop using it because
> > they think it doesn't work properly.
> >
> > I do believe the skip message should be improved so it better
> > indicates why those tests are being skipped.  And the '-d' feature
> > should be documented.  How do these changes sound?
> If the error message is clear enough, I agree with you. The skip message should
> not feel like an error message ;-)

Very true. I think I just put that one in quickly and meant to come
back to it later, but either way it's a bit too vague.

I'll get that corrected, but I believe I'll add it to a separate patch
after the requires functionality goes in.  I want to update some of
the documentation as well.

Thanks,
Lucas
