Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44373E20E7
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfJWQrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:47:45 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51294 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfJWQrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:47:43 -0400
Received: by mail-wm1-f65.google.com with SMTP id q70so14862361wme.1
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L8IkN7HHGSPVZAZUo95DyY4C584DLlV893i5dCIKpfc=;
        b=aRfN8CJ7nRny8b0N2jREjtWfO0zODCX0emRNL5HfoRQWOsUMHs80YzRxwHOcF7TTay
         ZAf+hqJipOmmNF5/BxRykxqjCzOyNErB5Rki01h+a8tT2NgmOXqv095s7GB0nXUn16Fv
         Cc4E5qla3Os/S4dnPn+P6goL/U8WdNLvTfSRRtDCJ95w2lGNTE3zIljYiNiUVQsy/jPi
         +tdgcvIO8aI9240ykClR+srz3EUFcCzx+M6XttzwaC7JDyxj+NnSlZAXAUox/01OijYn
         hEDqvL5r/HrrQ/eD8JQkqfQdLQFuO/otREYe0pIT8gMJcx00r2Ot9bWuV1g5oIngCY48
         q5Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=L8IkN7HHGSPVZAZUo95DyY4C584DLlV893i5dCIKpfc=;
        b=SRjclYED8tdXMC6y7NcFaX0Xku5rmMexH+Y1RvWduMVYOZbL/8Q8qhxKc+V0OTlEyi
         qpgpTDmjkAekHtj5xMPa37ESth1aS5EG5efIOfKbnOhzh8AiD6vVjpOUJXWrBAlx8YpW
         XvYiRgyOr7UkG3TiZdJKVF5gHl9Q0ydQBzEZDHGvw4PZECSGOlJLz2Wa/uIVzOEF7GF8
         UmS3qTbcEgA4VzkWP+jNFx+0/tsifOzXvWJAQZduI5o/klRRy0frTM49ui5c2+HfYZ8x
         q2B03G5WxBcknvFPfAYeNg84fYlxo3qgGuGKgpjjV7YL/f0/4QEC18qQQrCJxxVo1+6V
         EqEg==
X-Gm-Message-State: APjAAAW6NLpPde4fyNmfajJXiujaBOx/yaLAntLq1My3DwUNdnAKRHCK
        jyUVzJtEEuNKaOcqN0Y1JtWtqg==
X-Google-Smtp-Source: APXvYqwKbgZ/dsACl6qyJbd2p3KYksFWiJzXJ0in+55lAROYpdYvLCi+76iYejn49Cs8AzkcFvzkPQ==
X-Received: by 2002:a05:600c:2107:: with SMTP id u7mr781504wml.13.1571849260343;
        Wed, 23 Oct 2019 09:47:40 -0700 (PDT)
Received: from [10.16.0.69] (host.78.145.23.62.rev.coltfrance.com. [62.23.145.78])
        by smtp.gmail.com with ESMTPSA id g184sm16270642wma.8.2019.10.23.09.47.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 09:47:39 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] netns: fix GFP flags in rtnl_net_notifyid()
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Pravin Shelar <pshelar@ovn.org>, Jiri Benc <jbenc@redhat.com>
References: <d2d9d7a0168e9c216b6755021ef4cf5b3baaf3b9.1571848485.git.gnault@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <43e5d5d8-3cd9-9de6-f9b6-f5c3ab2eeea7@6wind.com>
Date:   Wed, 23 Oct 2019 18:47:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d2d9d7a0168e9c216b6755021ef4cf5b3baaf3b9.1571848485.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 23/10/2019 à 18:39, Guillaume Nault a écrit :
> In rtnl_net_notifyid(), we certainly can't pass a null GFP flag to
> rtnl_notify(). A GFP_KERNEL flag would be fine in most circumstances,
> but there are a few paths calling rtnl_net_notifyid() from atomic
> context or from RCU critical sections. The later also precludes the use
> of gfp_any() as it wouldn't detect the RCU case. Also, the nlmsg_new()
> call is wrong too, as it uses GFP_KERNEL unconditionally.
> 
> Therefore, we need to pass the GFP flags as parameter and propagate it
> through function calls until the proper flags can be determined.
> 
> In most cases, GFP_KERNEL is fine. The exceptions are:
>   * openvswitch: ovs_vport_cmd_get() and ovs_vport_cmd_dump()
>     indirectly call rtnl_net_notifyid() from RCU critical section,
> 
>   * rtnetlink: rtmsg_ifinfo_build_skb() already receives GFP flags as
>     parameter.
> 
> Also, in ovs_vport_cmd_build_info(), let's change the GFP flags used
> by nlmsg_new(). The function is allowed to sleep, so better make the
> flags consistent with the ones used in the following
> ovs_vport_cmd_fill_info() call.
> 
> Found by code inspection.
> 
> Fixes: 9a9634545c70 ("netns: notify netns id events")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
