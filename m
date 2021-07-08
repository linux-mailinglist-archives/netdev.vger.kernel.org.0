Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1CE3BF3AD
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 03:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhGHBxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 21:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhGHBxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 21:53:22 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD7DC061574;
        Wed,  7 Jul 2021 18:50:41 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id x22-20020a9d6d960000b0290474a76f8bd4so4301936otp.5;
        Wed, 07 Jul 2021 18:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iEVLnnKUTx52/0fMucAnzWE082XWeBdl7Fv1TW0tngs=;
        b=pyXYLpmUH3RwaJJS99nW57KfKuXK84csZktYgBjQTTDRU5oxQTUvIwtUmJ5bGXWsxH
         6/hBdLv1OsXI3LL44j4D8rXeHTeJK8/ufPoKyamA5/16aYRcKEPEYSMIPcOy9OUCs4vW
         ZS0U1Q9JcP9v30GSnZ3Ww1oYR+JWiSDpykwnffTWg8Xgg1Qy1c7SBoG0yTfVC8vTh+jp
         ETHx2oyaQlEzUwjTisqLxRTyOSP/NhBcmZdqkiPL4wyKTIUcKfeo8GWJht6A2AU/zgc4
         wgsVMn+j152Ftv/Tk0Zak9Ov/OjnQmBCU+04fMlHQKjyK8TJ/QFGZxVF72zOpfZupBjK
         xM5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iEVLnnKUTx52/0fMucAnzWE082XWeBdl7Fv1TW0tngs=;
        b=nry2QKEVVHQSb2vzcsqycAcTM7atbkdvD8RpoTtThH8gmhljk6cbrOjVVITtDDG8wh
         Wekeqt3l74eChAgpaldb3T43KqdCAqqgIsn933UXSEuVH9rsM/Xj/HKVHNfOqEsxUeLM
         wjcMzG1ljVFDRjuY5lyChayvg/ZIjOq5hNutveyvwmS0YOEFR9954orQYVsqJ5BOTUxb
         Sa4Vb1NhABSXRu0LGavifBoq1cUgrzCpfNS3JGQm8qZrfu26hH1SgR/jYau7p0/XDQmf
         vq0Iz3e8slG4jFAIDS0nbAyVowZBp+dB6RiiokJ6vg5gPLO4A2E4eonzIum9umnERMUV
         ivpQ==
X-Gm-Message-State: AOAM530FEi0+/j6KvPhUUemQMQqIy0YxkiY7833rVUwM8gtewvQ2KstL
        no9ZV8M5FJvVXiWdwXZIzkFdUjUryx76mA==
X-Google-Smtp-Source: ABdhPJx0QfK9mvDctVujneOatljjyjWH/wdXTRzJbj1Dyk3qOEVni5jLnX9FTxgO3YGwsggfHn5GYA==
X-Received: by 2002:a9d:82d:: with SMTP id 42mr21749901oty.235.1625709040614;
        Wed, 07 Jul 2021 18:50:40 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id o20sm135632ook.40.2021.07.07.18.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 18:50:40 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] selftests: forwarding: Test redirecting gre
 or ipip packets to Ethernet
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <cover.1625056665.git.gnault@redhat.com>
 <0a4e63cd3cde3c71cfc422a7f0f5e9bc76c0c1f5.1625056665.git.gnault@redhat.com>
 <YN1Wxm0mOFFhbuTl@shredder> <20210701145943.GA3933@pc-32.home>
 <1932a3af-2fdd-229a-e5f5-6b1ef95361e1@gmail.com>
 <20210706190253.GA23236@pc-32.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <391b6a56-b7e0-867c-617e-a05afec50b24@gmail.com>
Date:   Wed, 7 Jul 2021 19:50:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706190253.GA23236@pc-32.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/21 1:02 PM, Guillaume Nault wrote:
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -3767,8 +3767,7 @@ static int vxlan_config_validate(struct net *src_net, struct vxlan_config *conf,
>  		    (conf->flags & (VXLAN_F_RCV_FLAGS | VXLAN_F_IPV6)))
>  			continue;
>  
> -		if ((conf->flags & VXLAN_F_IPV6_LINKLOCAL) &&
> -		    tmp->cfg.remote_ifindex != conf->remote_ifindex)
> +		if (tmp->cfg.remote_ifindex != conf->remote_ifindex)
>  			continue;
>  
>  		NL_SET_ERR_MSG(extack,

Looking at the vxlan driver and that restriction is unnecessary. While
IPv6 LLA requires a device index, allowing separate LINK attributes is a
legit use case - as VRF shows.

Do you want to send a formal patch to fix this one since you have it
diagnosed?
