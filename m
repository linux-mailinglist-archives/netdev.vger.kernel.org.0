Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C222CC5D
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfE1Qoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:44:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33995 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfE1Qoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:44:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id f8so21037426wrt.1
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 09:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s5gpDJDIIqHWW3ORaaAMnY55WUStot88zMeEb4dOWhs=;
        b=p6GUJ2uY7Q2BHrVzFcg3Sy4KgSOGdoIlxdWGUOvZpbpiNUvSad+kQmWJLzcZxFc2Zm
         hmlKk/I/NGHV+Kqp06zIeUbP+O/80MfIBbou5JSO/GuMWb0m/hr/arMVuLVzrWM8wzkX
         yy9B392IZjSI7luP6jx734FLm4e1YXOlGsr5lekRPaGbZJNJn8YcWO6eQ6lI2JPs2jVA
         6ssCDPopN8fs/RosLW0I/dX/NUxVUA7TJXS9rc6tTtFn7hZtPA7Ex56XQSh7f8jecQds
         ISGwhZpN+zEF0ep7MpA5eTgIOXfIu69X16X0yUcaUgwUGhGBLxw69KSPArkX4N5tpVuG
         3wbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s5gpDJDIIqHWW3ORaaAMnY55WUStot88zMeEb4dOWhs=;
        b=QvOW/FoLQNv3AOWudP1EZU/napPA+9528/OuEW3KwA81xCN0J/EVOnNHNyQKx6bnhX
         2Zf7uGqbu6U1sHXvLt9FdxKuNDor9kk3DAshWEbtp3iCpMB/CMRWZQea6BABO3xpIfFC
         WYy2KCnPykp0p7I0rsenlsGvq2SlfbpfdVnJKMj4uDQv1gfQh9KR75WYB7gKTQ5ygkGF
         /Jb/daOnQstD/QJaropKgZXNqcYDuWOh6KDhTEQy5ptNXbtPrmUwrE71mXjEceeb+kHO
         YGUvj5dCrFlgER/5+htpjAAEqEijNmOakL4cFn/7oKwkAQS4puia8B1hbQ6zYEPPPXYx
         PGYg==
X-Gm-Message-State: APjAAAUuvjCFA2K4uOsRSWF6mb5A+fevETcoCePsVVstKJBgRns36ysX
        kP9E27EJbionfhFJa2VksNndl12g61yn0TAWlJC7Dw==
X-Google-Smtp-Source: APXvYqy5am64h5+oDMazk2XQ09zXK4mJIncO4MBHwkKoeCCCXMfvoAQIpq9urw3hn4uGSs6RL6d1abHmb5iQCceXmI8=
X-Received: by 2002:adf:db89:: with SMTP id u9mr41544450wri.294.1559061891611;
 Tue, 28 May 2019 09:44:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1558557001.git.jbaron@akamai.com> <20190523.121435.1508515031987363334.davem@davemloft.net>
 <CAK6E8=fXs5kHVhcNyVHY5V3ZDkn3_FBcMPSnFoe4Fir-qU_1BA@mail.gmail.com>
 <CAK6E8=dEtKU49wMJbTCQnS+=O9Gt8GZh4KOQ2QTawxnACtzX+g@mail.gmail.com> <d3064376-6bc9-fa04-6ca8-a0c8e982ee03@akamai.com>
In-Reply-To: <d3064376-6bc9-fa04-6ca8-a0c8e982ee03@akamai.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 28 May 2019 09:44:14 -0700
Message-ID: <CAK6E8=fa6G-YoOg-VJqT6jfjOQYqDvTMU=9awQJGByBB5gUW=g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] add TFO backup key
To:     Jason Baron <jbaron@akamai.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, ilubashe@akamai.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 7:37 AM Jason Baron <jbaron@akamai.com> wrote:
>
> On 5/24/19 7:17 PM, Yuchung Cheng wrote:
> > On Thu, May 23, 2019 at 4:31 PM Yuchung Cheng <ycheng@google.com> wrote:
> >>
> >> On Thu, May 23, 2019 at 12:14 PM David Miller <davem@davemloft.net> wrote:
> >>>
> >>> From: Jason Baron <jbaron@akamai.com>
> >>> Date: Wed, 22 May 2019 16:39:32 -0400
> >>>
> >>>> Christoph, Igor, and I have worked on an API that facilitates TFO key
> >>>> rotation. This is a follow up to the series that Christoph previously
> >>>> posted, with an API that meets both of our use-cases. Here's a
> >>>> link to the previous work:
> >>>> https://patchwork.ozlabs.org/cover/1013753/
> >>>
> >>> I have no objections.
> >>>
> >>> Yuchung and Eric, please review.
> >>>
> >>> And anyways there will be another spin of this to fix the typo in the documentation
> >>> patch #5.
> >> patch set looks fine. I am testing them w/ our internal TFO packetdrill tests.
> >>>
> >>> Thanks.
> > The patch series pass the packetdrill TFO tests :-) It'd be great to
> > support of TCP_FASTOPEN_KEY sock opt additionally.
> >
> > Acked-by: Yuchung Cheng <ycheng@google.com>
> >
>
> Thanks for testing. So patch #3 adds support for the backup key to
> TCP_FASTOPEN_KEY sock opt for both set/get. Is this what you are
> referring to or something else?
yes that support is great. so no more further request. patch looks good. thanks!

>
> Thanks,
>
> -Jason
>
