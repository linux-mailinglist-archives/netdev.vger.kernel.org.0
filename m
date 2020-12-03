Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1982CD122
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 09:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388325AbgLCITK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 03:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387629AbgLCITJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 03:19:09 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838EDC061A4D
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 00:18:23 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id bo9so2072314ejb.13
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 00:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=BHE7BUY2JKkG89Max7ctelLbeq4mWkjZxzugrG1DHko=;
        b=t2G5Zebthc4UF6qA7IBfx6fBIGsQe8JlHC1OkuAaLmWvruQjt4CqylwgGbrvWqDNpr
         vweabUktPeeg4bINNnNTg6RpEUN9HbXmoh2aTVYNikrc4zzlPBHjVVIhmxSGa4EKJnX3
         ZPKvAT1sDBFQQ7SH6ksi/7/Xy+W5/BBbT3clnkUqTz38nZPnSyEHPALJLpqdVKQD8Q9c
         1WIZ22EpJF+IabaLv0RuvR9mI0Dy7wvjzY5/95cG9wktHATMTtJes2Lqo/4QeQKaDnLU
         1lRPFjgD3LYCr9qQP+hcpENvPkhIAaVG5AnZWNWE24xupMTJscMHAhTn/rL0bBXW5g2p
         g+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=BHE7BUY2JKkG89Max7ctelLbeq4mWkjZxzugrG1DHko=;
        b=kgDw2FekXNOr6HBDrNqv2E0ZTYNoB79IA0OQSG29CAHPWinIYHi+MatXJS94SaNgbH
         vaIhuz7TfOiS5t6K8uYL2WHSol8vOKaJQrwHUAigL0aZl3IMaVB6sNxAwV6Pq1h+qfCk
         AmAxb7ZDTFGX3OnqJ6julGOArQuziQoy0hBlVAgub3rSvZLMJ5zdmG3ZCikREi2n7nXY
         ZJcX5rUEjdF1IlVYHVCiAhSeHHqb5M8EJrt9hCMqm8aZqAFESIPgrvwhhbYiMk4g5bLM
         w1vfdQ7YyWIk4M97TASIJkl/jZ9Zp9430zNGLXzr9UMDCQxktIevEypAfxhwVWeT7Xqb
         CP1g==
X-Gm-Message-State: AOAM531TuftN0PI6YBbcyBuxMMT0cCbnSl3u3i6DnzZO5XHubNdcVGME
        m6uFEuEYwvCKJ2Fq8ydoG8E1hWlHXf2MoRy8Jmcijg==
X-Google-Smtp-Source: ABdhPJzskyGm/TJjhqxQ0WIqWi8o9WQL8penwwoMneV6Vlm+G01IHotwP7477J1Y2O/EgDAVXg2yPuu2zeakn7FkN6E=
X-Received: by 2002:a17:906:8042:: with SMTP id x2mr1585563ejw.79.1606983502114;
 Thu, 03 Dec 2020 00:18:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a54:3cc7:0:0:0:0:0 with HTTP; Thu, 3 Dec 2020 00:18:21 -0800 (PST)
X-Originating-IP: [5.35.99.104]
In-Reply-To: <20201201104734.2620a127@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201201093306.32638-1-kda@linux-powerpc.org> <20201201104734.2620a127@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 3 Dec 2020 11:18:21 +0300
Message-ID: <CAOJe8K1FPGr-2OgqaWOEz4ZHUONJ-p2yW6Uw-dVjXVurGmDwxA@mail.gmail.com>
Subject: Re: [PATCH v3] net/af_unix: don't create a path for a binded socket
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/20, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue,  1 Dec 2020 12:33:06 +0300 Denis Kirjanov wrote:
>> in the case of the socket which is bound to an adress
>> there is no sense to create a path in the next attempts
>>
>> here is a program that shows the issue:
>>
>> int main()
>> {
>>     int s;
>>     struct sockaddr_un a;
>>
>>     s = socket(AF_UNIX, SOCK_STREAM, 0);
>>     if (s<0)
>>         perror("socket() failed\n");
>>
>>     printf("First bind()\n");
>>
>>     memset(&a, 0, sizeof(a));
>>     a.sun_family = AF_UNIX;
>>     strncpy(a.sun_path, "/tmp/.first_bind", sizeof(a.sun_path));
>>
>>     if ((bind(s, (const struct sockaddr*) &a, sizeof(a))) == -1)
>>         perror("bind() failed\n");
>>
>>     printf("Second bind()\n");
>>
>>     memset(&a, 0, sizeof(a));
>>     a.sun_family = AF_UNIX;
>>     strncpy(a.sun_path, "/tmp/.first_bind_failed", sizeof(a.sun_path));
>>
>>     if ((bind(s, (const struct sockaddr*) &a, sizeof(a))) == -1)
>>         perror("bind() failed\n");
>> }
>>
>> kda@SLES15-SP2:~> ./test
>> First bind()
>> Second bind()
>> bind() failed
>> : Invalid argument
>>
>> kda@SLES15-SP2:~> ls -la /tmp/.first_bind
>> .first_bind         .first_bind_failed
>>
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>
> Is the deadlock fixed by the patch Michal pointed out no longer present?
The thing that I'm not satisfied is that we're holding bindlock during
unix_mknod().
I'll send a next version

>
