Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC134DA1A
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfFTTWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:22:31 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37541 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfFTTWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 15:22:31 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so282509iok.4
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 12:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GpW/+qj9o3OJ5b2wITE4G+NuTjxqWZBI74hTP6D4IPw=;
        b=jQlZ9XvmHmofGU35j6sKmdqFQApzAqoDJ2wjzTDBNDUv1vnqoRZYzCqH6a7nDrybzy
         j7dtmmlcx9jGj8MFWFiQLK5xY3Ufoyuyn26Zqc1LvxxI7b4EJWp0GEaLI9+uhpBISs7E
         u5ZSTT0uIDUpZXvikMa76Y18NlofNclPCQWAvdyy2tEqYIQwMj/XDAmJE0MKjy12mQnO
         ujDhEUgewR4rZX9A5BzXaKPLuKxWwRsFpzEGgpd79/9AQBDpqY1I9JVoqKcVNZtBJogI
         QLYx8trLh8LnomirJ7KvCouAHo8u+6HHsO0h90k+qmlXYwgEfD8jeDAN6LFlbF7dO0mu
         3jXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GpW/+qj9o3OJ5b2wITE4G+NuTjxqWZBI74hTP6D4IPw=;
        b=rHkm/WyLLLKisvl0XPzpba8P3w5u5Oh97GkC+34YfBfy5WpJLXNmbJFGSU7yLSiCza
         aQLJHYbf0E6B/KxTuj9qFxOrpa0G/9nmE8lpRwra+KRa9U+rVOnDcy8iqxD9q+GQYOuE
         ChuKLPWy3RRiYBdJIfF4L/Rrt32YVRR++SFuW8nGjwzG/ANLvl7658TsjRZflutZR1cg
         wEhWIfWzqx/9T8LdaAkyy1WqvNcijhr/XMJIj8EG3r5yhR7xraZvy/gVQwg1lZ3SyCM+
         t6a5gtfNhrp+ddmrsXh8HKIhhVHmaO2cAszg/W4nsnWzcsiB8d0gDttO3ZX/jV3TcWbW
         qaeA==
X-Gm-Message-State: APjAAAWuxiQFLVBw8oafzE/0su0V2RXP13g6B74KbneeAahPDpe0awXn
        UcJQrNEEX2ihUqL4qXGpT26WEzrG
X-Google-Smtp-Source: APXvYqzIAKFj2ZqjWocGgv2YiKiaDyJNRAqsrIaUURmFvHXflxrRkSxs32FgirxAzHq7C+4ch88YGg==
X-Received: by 2002:a5d:890d:: with SMTP id b13mr62432296ion.124.1561058549884;
        Thu, 20 Jun 2019 12:22:29 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:9c46:f142:c937:3c50? ([2601:284:8200:5cfb:9c46:f142:c937:3c50])
        by smtp.googlemail.com with ESMTPSA id z1sm998022ioh.52.2019.06.20.12.22.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 12:22:29 -0700 (PDT)
Subject: Re: [PATCH net-next v6 08/11] ipv6: Dump route exceptions if
 requested
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560987611.git.sbrivio@redhat.com>
 <13c143591fe786dc452ec6c99b8ff1414ef8929d.1560987611.git.sbrivio@redhat.com>
 <26efcecf-5a96-330b-c315-5d9750c99766@gmail.com>
 <20190620210226.724c2893@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <de992236-46a0-228f-4992-f0909c52c539@gmail.com>
Date:   Thu, 20 Jun 2019 13:22:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190620210226.724c2893@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 1:02 PM, Stefano Brivio wrote:
> Same as my comment about IPv4, except that, for IPv6, distinction
> between skip and skip_in_node is strictly needed, but buckets and
> nexthops are traversed in the same order and 'sernum' changes don't
> affect that.

ok
