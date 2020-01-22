Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F6C144DC2
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 09:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgAVIbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 03:31:11 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36957 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgAVIbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 03:31:11 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so6291977wru.4
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 00:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C9VupiqQIOr5qPjO+YCK5GRYq3nKVhSx0lnsrIuwGvo=;
        b=K8TeOoRiUZYYhKRk6vd8JNxdcgJmNYQ/vecsbyHzto6U72803efC1Zj9LcrYtH4YmM
         FCThhZ75bWVWWHeFg3FYGY0Y4+WmG0/QGsnIqiiu5u8S7SW4sX00+sABb5G8QOG9mIQT
         2NcRO++23ypvSpPPIZ+VrafcY8spJZrLqp/cFu9vu5GjLJgo19ODTAR+I/E/jVAVlgyz
         Z2nCFlcCobDmKKIAiqBAUcwGmSavj135+aYeq1kyCQcAu+uMsnCeUuZnk9cf+ySMuU83
         b66EJYxWeMP5HdZwJXXchmNj3PLdskrqo1hMf7jLuqd2wiYF7SgEQ+l7d0Af1qm+fW+o
         hnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=C9VupiqQIOr5qPjO+YCK5GRYq3nKVhSx0lnsrIuwGvo=;
        b=lMeudfNYmtt3KUo2LkcWQUJFwJxcro+NhDtp7C1QnlB4k89RPDdQd6j0LIOtIfwybw
         YsCsREnexJtMgF4mUFCduHZxmFik0fl6wnh3jxHoMkRP5X2IRTYryvOw/HYKl1rE2zOw
         VEAzQfKWeEHiUJ4UYG1NnCZuIMQAA9B4vj4a8/5AmjKyiwj2Ecnfw6WHbsFBDC7C/63h
         eoJbX/8s1BVk99Pk6hy7s7FRhIsH2Gh/fyjxMw8J7BxFqkrsk1yL+JsPKdNUSPnBFzFV
         K+nGiIWW3+u8z5Dm2rF2SvkPKKDiggDFEvhpor2+Fv1fyfNHGXdgJ2Khg298BERYL8em
         BhWg==
X-Gm-Message-State: APjAAAWqA+IJTZqwzEMkfyKoIli7e7mV7DtgxzukYtAHmWVFA/3Olhbz
        9JV6N7/l65zKh0/RTZwIxrRI8/fKKZw=
X-Google-Smtp-Source: APXvYqx9qcv0ryTp04Dj5uuqhBg4Ccxa2d1yMRJ4zjKk2qgl2timPclKlASgV3WsQJGoZXzPto/rFQ==
X-Received: by 2002:a05:6000:367:: with SMTP id f7mr9728007wrf.174.1579681868850;
        Wed, 22 Jan 2020 00:31:08 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:cc79:45b2:a26d:365? ([2a01:e0a:410:bb00:cc79:45b2:a26d:365])
        by smtp.gmail.com with ESMTPSA id a9sm2775862wmm.15.2020.01.22.00.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 00:31:07 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] net, ip6_tunnel: fix namespaces move
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>
References: <20200121204954.49585-1-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <b56ba08a-5325-da84-4f43-5d8997920b9c@6wind.com>
Date:   Wed, 22 Jan 2020 09:31:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200121204954.49585-1-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 21/01/2020 à 21:49, William Dauchy a écrit :
> in the same manner as commit d0f418516022 ("net, ip_tunnel: fix
> namespaces move"), fix namespace moving as it was broken since commit
> 8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnel"), but for
> ipv6 this time; there is no reason to keep it for ip6_tunnel.
> 
> Fixes: 8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnel")
> Signed-off-by: William Dauchy <w.dauchy@criteo.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
