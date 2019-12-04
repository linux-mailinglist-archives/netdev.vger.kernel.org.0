Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B821811304F
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 17:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfLDQ5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 11:57:20 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37879 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDQ5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 11:57:20 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so63828wru.4
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 08:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=geyE9NaxWHb5U/WjIDjzX/HRy4k+GvAyGrYt+fj/kfg=;
        b=dm9HnyiIzAVrc69HJQTQe/WsmrjJh2TsXUZh52QO8HTvt079QCv6Cu86jd60g8+cl0
         Bpi8ZB+cOdEMl0qKZ/9O9LQ6QTvFy2lOHtOigqrsNk8t6JZwdLbOYyTORtNn/zixiBIZ
         5KygnvR7St3Uu1M7PxpVrNnUuC2H1gc0dtPMAXMxLAy6E1EeZWqVZvdhzmAUR+5lMs8J
         XTXgXyql82E11j4zxzrbwMep5TzOZOoMEYNlAqMEwCOdlvxd8nPGzEPS1cI3zvyW7GN6
         XmE6uQXaV4Pb7kwITbYxWcY5JeYHgUcZbzNPKjuhYQBJzrIpYAYCi63JyzO5rOM0CJ+T
         V8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=geyE9NaxWHb5U/WjIDjzX/HRy4k+GvAyGrYt+fj/kfg=;
        b=ZdBkJwAdPOKSeaj70Lwgo5+TlCvHPZ9FmuhxtdplbnSOjabWEQTdbZU8werT4XJPCc
         R2vvznBz65CDZy9LCNdmtq9fDg2giYRAKAgYuCAD+pAa38X1gCUZ8NTQciH3QkArU9WI
         NRZa1qIn524QH+rA8Vr0QE9HJIKUPdmuooduP9Q2fol90vvPmPW/18gKrYoUAorPg9En
         J+rIusdyVwjNlOwWzZyGuSKShOF8+FuxlJIW5maFiUp8y8Z30S4EXqUpM8EcLXe2qGCF
         hHYFqyUPSKsWkplNInJ6b86NqkKjVVhH1iJsE30RsXiH0blifa/DnGP/EHMXYrZ+9jF/
         N5Cw==
X-Gm-Message-State: APjAAAWmKC9aPBpC/zRi4qrBnLxmtUSQPhR+W1hFg3idaY2VufNUkN3l
        YkKVB5PjT+1kU7CWqO7Jo+GjmA==
X-Google-Smtp-Source: APXvYqxLlKrmWUS/HCE+ShDKUxnwGyf7J/mQ+k58lpuQ/sgvYT0vRPslgVaH27b26NVh7mdx5By65w==
X-Received: by 2002:a5d:4a84:: with SMTP id o4mr5063426wrq.396.1575478637967;
        Wed, 04 Dec 2019 08:57:17 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:1153:c308:9cc8:f584? ([2a01:e0a:410:bb00:1153:c308:9cc8:f584])
        by smtp.gmail.com with ESMTPSA id v17sm8684488wrt.91.2019.12.04.08.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 08:57:17 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec] xfrm: check DST_NOPOLICY as well as DST_NOXFRM
To:     Mark Gillott <mgillott@vyatta.att-mail.com>, netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au
References: <20191204151714.20975-1-mgillott@vyatta.att-mail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <5a033c2e-dbf3-426a-007c-e7eec85fc3a6@6wind.com>
Date:   Wed, 4 Dec 2019 17:57:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191204151714.20975-1-mgillott@vyatta.att-mail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 04/12/2019 à 16:17, Mark Gillott a écrit :
> Before performing a policy bundle lookup, check the DST_NOPOLICY
> option, as well as DST_NOXFRM. That is, skip further processing if
> either of the disable_policy or disable_xfrm sysctl attributes are
> set.
Can you elaborate why this change is needed?
