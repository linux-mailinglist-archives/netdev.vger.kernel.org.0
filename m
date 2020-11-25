Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7BD2C38A9
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 06:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgKYF24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 00:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgKYF2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 00:28:55 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B94C0613D4;
        Tue, 24 Nov 2020 21:28:55 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id k8so1022108ilr.4;
        Tue, 24 Nov 2020 21:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZIu6+O3+yyiVX/MHHYUt+wowUIgO1iDeZ1EMSN3r5fk=;
        b=D38++zrxJuTN1IsvSRQmKdSMpKNP3etxI/MzOX3mkBSj10nB/eVpBljb5RuXjhL2ft
         z2mJiGxD4GVHWP/H1/kRGwUX/8oitl39aYcaG6jvXz5hXQCI9uX9LayxgrpwOV9C0r54
         upmufNG3xrmys1W2xNGT7lrPjePJTnNeOmwkAeXdhDVOmdZg8EQreJ8N1yleGBjT8/pS
         ysC7X2Sr5Y/H/It0EJFhVDa1yfShLgg687MF96WRWy9ywrJ4vDJCc501L9FMc5vfill2
         Fva76aeVxfCjOpc3kI9H4s5a8GRm10d+PBDli3YLRjoUb9Cb4+4nl4Z1ffQPHLHLWxvX
         Fhmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZIu6+O3+yyiVX/MHHYUt+wowUIgO1iDeZ1EMSN3r5fk=;
        b=bFUP/gh1TZ9Z8lclcocgHXUDC2HeqCke0qpBOKQFXSZTLhfukv7+FvDKB15kmYGyr8
         QOdOSsmWJfMme0NTP0yq5zyM+EuYM1LUYljdfuprbbb1y55hFAzFPeweUK43ozuMgC7u
         QeZYBcESZ9mYAehdtCChwKkyEaOAJte1Q83lesfG6tyVCCD95BUmWgeirjntmLlxqQRo
         JhtCtwDNQlno5QlkWNR9uerxeXUA0xJXXjbIqITGBu9jgZg9J0oPmH0LEoAi0jUPgJLM
         9DyE8r/0lSh6qZDe0vEgvZErCBauJy/221Ov99XsoPbt9/KFK8SwZpCCqrxZcKptbiQh
         4ONw==
X-Gm-Message-State: AOAM533Yu0/32WbwYZhTazI94h2Udo3UGmnRavzzbchY01x8uYUsyPmY
        R0E2ZFeUlra5xIUAr53ib+A=
X-Google-Smtp-Source: ABdhPJx3m6NB4FZ7hc4vISeMZ2cpGB6GxIMw57BZulGDVirxVLwXXeguK8FQZlUMIuaDbD7hgX/3vQ==
X-Received: by 2002:a92:3f0b:: with SMTP id m11mr1727906ila.166.1606282135001;
        Tue, 24 Nov 2020 21:28:55 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:b920:c7b8:6a02:a6c0])
        by smtp.googlemail.com with ESMTPSA id b7sm467035ioh.27.2020.11.24.21.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 21:28:54 -0800 (PST)
Subject: Re: [PATCHv6 iproute2-next 0/5] iproute2: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <20201116065305.1010651-1-haliu@redhat.com>
 <20201123131201.4108483-1-haliu@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <07bc85b3-3ae0-eaa5-e8a5-921dbd4a4e4f@gmail.com>
Date:   Tue, 24 Nov 2020 22:28:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201123131201.4108483-1-haliu@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/20 6:11 AM, Hangbin Liu wrote:
> This series converts iproute2 to use libbpf for loading and attaching
> BPF programs when it is available. This means that iproute2 will
> correctly process BTF information and support the new-style BTF-defined
> maps, while keeping compatibility with the old internal map definition
> syntax.
> 


applied to iproute2-next.

Thanks for the detailed cover letter. In the future, please use '$'
instead of '#' for the prompt on the commands or offset the command
lines. Lines starting with '#' are considered comments by git.

