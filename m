Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F20843543E
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 22:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhJTUDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 16:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJTUDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 16:03:40 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A99C06161C;
        Wed, 20 Oct 2021 13:01:25 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id r17so8920644uaf.8;
        Wed, 20 Oct 2021 13:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l+6y9qtoGeZP6g8xchKzxYt0QVJGn7ItWZlIhS1UU1M=;
        b=NaWfdLGfgtT0n7MATTZlYbABm6kNBnX3+ka6rHfCqCFjO0aXtb4bjPEhgyE3ISj1Zx
         1b0mSSZ/deXDY9Y5n+W1ddWKn5i31LJtp3w5YYEUCO7FJur46afCOfGmuMuvqt2CUbsV
         6IjZRc9on3rp23Zg2zR0vu1FHQ40dq+49dS84bgop8mAKUeUiw5cwey/YIAIhiij712N
         W6BCuJjwPLWj3jD1SJfRWPOSJ8xSvnk1D734zxZAqgEKpHXWkd86JFJPaemmUCrGSq3w
         sfl/Gqdl2GyMkZ47Z60yB7NkmzvciqYPLcVCIq3mlTa3kQqFtH2WFKcfsTNielpeAXKb
         go/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l+6y9qtoGeZP6g8xchKzxYt0QVJGn7ItWZlIhS1UU1M=;
        b=eH0sgEUJKJVG8I6G7k1l2WjAGiDy8a41WrzgzhhVG0Pa/UU7k6umRdqWFufJs3OqXO
         hhVXfRwh1wtQQVdoO0ZHLeeCsmLY+7dxaPAyVXVQJnvGpeez1KIpoXnOFZF+Hrb0+7A0
         EWXmnyhy+q0LVnIziwaMgRT1u+tB2X712p6kyltFDu2MSKbKVNdbQJvE7QfayPuoXxh5
         Ha2GXsf5SVB7C1Jez/f8YEoGdkm6VfjoyaTMRRUtaTnDhDuJBJ0X/9MsmQVd5DxUrQu8
         1kzivlGg+7KPIaDjIvzpjwrcl1wGq5YAcdzeqwyflHs67FLvRAarlFJkaIfvapFjzdJ9
         V5vw==
X-Gm-Message-State: AOAM531mKbITPQZ4QvrSbl7NXH6ubdV79HPDJEvoMBJVfT7qNh3bkrPV
        m1JprO3bveZNGCCkEbw5tuBytKd3tzWh3D6755Q=
X-Google-Smtp-Source: ABdhPJyCenrjtedk7J3JZUqzVwGcUGWBB/3jA3XWholS0jfSnzQF7ZdoAuIyZ4ohc4focXM5PMINPr93W3VrZHp+4qs=
X-Received: by 2002:a05:6102:3e81:: with SMTP id m1mr2167565vsv.44.1634760084832;
 Wed, 20 Oct 2021 13:01:24 -0700 (PDT)
MIME-Version: 1.0
References: <20211020095707.GA16295@ircssh-2.c.rugged-nimbus-611.internal>
 <CAHNKnsRFah6MRxECTLNwu+maN0o9jS9ENzSAiWS4v1247BqYdg@mail.gmail.com> <20211020163417.GA21040@ircssh-2.c.rugged-nimbus-611.internal>
In-Reply-To: <20211020163417.GA21040@ircssh-2.c.rugged-nimbus-611.internal>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 20 Oct 2021 23:02:17 +0300
Message-ID: <CAHNKnsSC3bfZQxpwqYfyw8bB06otaK8YWkgtZfFOnX9vMkOVgg@mail.gmail.com>
Subject: Re: Retrieving the network namespace of a socket
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 7:34 PM Sargun Dhillon <sargun@sargun.me> wrote:
> On Wed, Oct 20, 2021 at 05:03:56PM +0300, Sergey Ryazanov wrote:
>> On Wed, Oct 20, 2021 at 12:57 PM Sargun Dhillon <sargun@sargun.me> wrote:
>>> I'm working on a problem where I need to determine which network namespace a
>>> given socket is in. I can currently bruteforce this by using INET_DIAG, and
>>> enumerating namespaces and working backwards.
>>
>> Namespace is not a per-socket, but a per-process attribute. So each
>> socket of a process belongs to the same namespace.
>>
> > Could you elaborate what kind of problem you are trying to solve?
>> Maybe there is a more simple solution. for it.
>
> That's not entirely true. See the folowing code:
>
> int main() {
>         int fd1, fd2;
>         fd1 = socket(AF_INET, SOCK_STREAM, 0);
>         assert(fd1 >= 0);
>         assert(unshare(CLONE_NEWNET) == 0);
>         fd2 = socket(AF_INET, SOCK_STREAM, 0);
>         assert(fd2 >= 0);
> }
>
> fd1 and fd2 have different sock_net.

Ouch, I totally missed this case. Thank you for reminding me.

--
Sergey
