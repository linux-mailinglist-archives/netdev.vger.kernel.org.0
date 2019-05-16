Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A713220A8F
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 17:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbfEPPCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 11:02:08 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41267 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfEPPCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 11:02:08 -0400
Received: by mail-pg1-f194.google.com with SMTP id z3so1696175pgp.8
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 08:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oQIpgPhDeITrfem6Q9vBqAlxsSxn7on1qPD5WhUkuCI=;
        b=LMAW81YACJdH8lc+yV5UY1LirSNlYfT9l1J2qKri2wpTcmoAU9SDnoH2zpM5WbxCnE
         2/9PLRXsO7fUMinhHqWqSiCqJVnPhgyZrZ0d+a1YjAByq8LsG31xYJlwl2yr0z3UT+qo
         +3vFKRc/eUGJbtShTPZgACEu7W/FyTLIen/k6l0JaBtNtxUuctQz0CwjpVpffeVzqu7S
         Jtk/9K/U8Zhy5V98n9hu+GRpku1mX6+527yEuV3IedymVi75DPIAJDsaGlC94UO2CvAu
         dyQfEz4Tl5IjDJ850qwWZ8abgsOWtCOvBZ/6S/v7onvIyrBDR5QMkklwVdooGjD0qpPS
         Edbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oQIpgPhDeITrfem6Q9vBqAlxsSxn7on1qPD5WhUkuCI=;
        b=T4IG5vTpAk8+fN0bRnE0ESutnrlS+pDlGNCjvtT175khxlVydfqt6vY7idUioEzSR9
         XXn4vVFdtiLnB8Y3gxBSnSif2Hun14/3nhoqUzFd9VIxHpJyS9Wg3yF5rWnlCwBWZ1vV
         Er/QimcKm971B0dCsonCVQR/fOnYoZiuujjkpzZNFxRE5vEt7tCmtiI59bJ8gnKWR2PQ
         GYlCD0pjO7bOK1U7PbP9O7Lqqmo0vAsuJVM6ZppOJydg2HLEaC6OCYIHAuQNx07GCoSZ
         T8cNrctAnp2ZKRvZBfkk9WiFFEqaq1ySWZsxTZkxo+2aTlf+Tkc9fDQRi2Wkvyw7CD3Z
         7ARA==
X-Gm-Message-State: APjAAAUeS971ACP0OV+Y/st+bZkB0+S0NKWKWAnY8kNW2v926BxkBRz+
        Z8ijoP2dXPjIVKmHg2G3wbQ=
X-Google-Smtp-Source: APXvYqxGQqDHRIdTzHVX1+dV1gRWPGachM7tli5SzQOBSJ7Q66L5NwtEZui43HpzbS4u+1uqen+ARg==
X-Received: by 2002:a62:ac0c:: with SMTP id v12mr54077669pfe.59.1558018927172;
        Thu, 16 May 2019 08:02:07 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:9983:b39:b7ee:6ed6? ([2601:282:800:fd80:9983:b39:b7ee:6ed6])
        by smtp.googlemail.com with ESMTPSA id z4sm6952379pfa.142.2019.05.16.08.02.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 08:02:05 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: prevent possible fib6 leaks
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Wei Wang <weiwan@google.com>, Martin Lau <kafai@fb.com>
References: <20190516023952.28943-1-edumazet@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <40038728-de12-ecb9-b382-2f6433f83d50@gmail.com>
Date:   Thu, 16 May 2019 09:02:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190516023952.28943-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/19 8:39 PM, Eric Dumazet wrote:
> At ipv6 route dismantle, fib6_drop_pcpu_from() is responsible
> for finding all percpu routes and set their ->from pointer
> to NULL, so that fib6_ref can reach its expected value (1).
> 
> The problem right now is that other cpus can still catch the
> route being deleted, since there is no rcu grace period
> between the route deletion and call to fib6_drop_pcpu_from()
> 
> This can leak the fib6 and associated resources, since no
> notifier will take care of removing the last reference(s).
> 
> I decided to add another boolean (fib6_destroying) instead
> of reusing/renaming exception_bucket_flushed to ease stable backports,
> and properly document the memory barriers used to implement this fix.
> 
> This patch has been co-developped with Wei Wang.
> 
> Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Wei Wang <weiwan@google.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin Lau <kafai@fb.com>
> ---
>  include/net/ip6_fib.h |  3 ++-
>  net/ipv6/ip6_fib.c    | 12 +++++++++---
>  net/ipv6/route.c      |  7 +++++++
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks, Eric. Attaching 'from' to rt6_info makes v6 much more
complicated than ipv4.
