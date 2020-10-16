Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A4129047E
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 13:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407044AbgJPL5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 07:57:37 -0400
Received: from mout.gmx.net ([212.227.15.15]:40585 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407040AbgJPL5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 07:57:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1602849448;
        bh=yDgzpnzpuGMGkPVNieFTLxO8fGGIu0iIiuQ8SHzW54g=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=MWrJ70vHqXMAvm5wpalaoKjmU38+19nu8dasleJuyoqjp1b8M+0mgqNIEWtSssnS+
         YmHPKe9wO7SD6ej+WVhwbN52ngrxkejaXUqvYd2iQ1OfQxEnmbGiNlrH1hn9Lp8dNG
         J/9HMZOI1Fo+N5fbXqp1pkhrzlv1hBkjyeuo1PFg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.simpson.net ([188.174.240.147]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MdvmO-1jvhyI1Og2-00b1Ba; Fri, 16
 Oct 2020 13:57:28 +0200
Message-ID: <0de05d434358edcfc716f8efe5414584ffb541f8.camel@gmx.de>
Subject: Re: [patchlet] r8169: fix napi_schedule_irqoff() called with irqs
 enabled warning
From:   Mike Galbraith <efault@gmx.de>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>
Date:   Fri, 16 Oct 2020 13:57:26 +0200
In-Reply-To: <7e7e1b0e-aaf4-385c-b82c-79cac34c9175@gmail.com>
References: <9c34e18280bde5c14f40b1ef89a5e6ea326dd5da.camel@gmx.de>
         <7e7e1b0e-aaf4-385c-b82c-79cac34c9175@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Je+ixLaph24e/jyvc8SMIFScmljHJ6VnyQoJPULX30YXTbTslR/
 rnZrhdQeR55nKzB4K36XqgYqr0AqfDvV3CN4uq4hxaqx3a6e5wnqpVPElEGe5b1YWntd0sa
 WkC9m+ulR4jCJPKZlejEj3UzsBN/ukZgxnCgZ83PK4HIDoRu7veHA/zHN0xlzVsaXcOWl2O
 92DZU3DD4YkMBb0RitCSg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vnfkDzRA610=:AjvEhPmbXeO+ADBfDGfGOT
 xb6ivfV9XVGS/ZyuKgtaHxTfGNnK3WE6IYU58OSB2weG13CuqSxefgYMxJAL9/DG0HXRgHC5Y
 JttSHHjcdZkGAzwOs1RvvIC8w4y/Bt3zGshhVzKYJlHWCaoMFqYCz5TmC75jGPWmfQqasnbUf
 +IA6fQzSYErhgNPctRgx/pW1GXUN8WQi0wAsROBACSRI2Iqcv/fs5dUE5p87/a/8loMEernt5
 YWy2BW32XcN3eqey52gQ7BAUSP16FzBDnwv+mGcyuLH2iSyXPhRSRady2QyaxCp//L6/bNX6b
 6KzwA6qaSS5lGpXLgc7F8dng1JDn/qCzlWs07NWbTV9QnrJQO28LcZR1qyGFrzKknStqLYitC
 tcKlceFhNXonT7a9gqv1xPQm0IjtOyB0eSR1XOdW7izM1tzO5pJslvI1SgbfmClj4CLXks+YB
 lpTQTvvieA7JV2ipH3/+2DxVQl4RNb3GBxIiqcVXUfAzDbaidlkE8zHC33g0tMZtCR29fSyn+
 c9IXH5iFKjLxbUBoQur40Oh5Gjpm/JvqUg9hC4n4HENQOpan5xClG3qB6MPae++fefYUr3WzZ
 2amXM/x89+nXbz0iUHl1dlWaAPWoaqO11++WBoJf7PvGXKqTpjB23bo6k8gHIbVCPQJe6waNp
 Quhe7zvtQjjFAIfqvR1MuExqmwLZzPp5DeWCQC/15tinhero/6smwD1mau0b8CvpufguICs7P
 epigWQd25iuwe6R8YV+kbIURLY0nE8/YEoLHeU5nQEiZqDJAr7X6w1evv1LjBdJt5XoghUfbZ
 CdtjDK6m3GkBAnN4+zz3M+JgIDD9tjXgWGkwR0vIq8f5+L5XJiujFGGBVqqWJyyHNMCcw7El6
 1OxDt+YuhMqhc4inHF3A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-16 at 13:34 +0200, Heiner Kallweit wrote:
> On 16.10.2020 13:26, Mike Galbraith wrote:
> >
> > When the kernel is built with PREEMPT_RT or booted with threadirqs,
> > irqs are not disabled when rtl8169_interrupt() is called, inspiring
> > __raise_softirq_irqoff() to gripe.  Use plain napi_schedule().
> >
>
> I'm aware of the topic, but missing the benefits of the irqoff version
> unconditionally doesn't seem to be the best option. See also:
> https://lore.kernel.org/linux-arm-kernel/20201008162749.860521-1-john@me=
tanate.com/
> Needed is a function that dynamically picks the right version.

Thanks for your time, I'll just carry it locally.

	-Mike

