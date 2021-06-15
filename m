Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186173A8200
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhFOONb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhFOONJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:13:09 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3F4C06175F;
        Tue, 15 Jun 2021 07:11:02 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o88-20020a17090a0a61b029016eeb2adf66so1698598pjo.4;
        Tue, 15 Jun 2021 07:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O8ALFFCClhnXnTiKsvTsWlZUgDd+IIwt/B3WnpyR8rY=;
        b=Iaxw+VUwGwNTenChpV1k2CktxntMgYWKzP+OuElPnN4P18WtUHAo2T08FTy4enmYcX
         hM/N7g8rwBqVkuFUdYM9LwzhaTV18Oz9QudC8iHqjhKCG9xf16o73PTlHRnpDYu/K0WF
         p3Y+laZcSodX0ue7FcFDdbW5qJ9q6b9YxdNuBYxc1mg582iWWJyfSFQrk2T6f/jdYaLA
         x2Bp6Ljrgs2NA7eawp/j+Oryz87of1p/T7xulcSP4Z3WU2kkKheTSqkYqw8F80Mz31jK
         aXK3vGCsrEfHr31vO9oaSDYWMYXboqbPzTWjUC+vOvb8q1/GP5mEz08V6k8+plm1Up74
         ewKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O8ALFFCClhnXnTiKsvTsWlZUgDd+IIwt/B3WnpyR8rY=;
        b=pzeaTCM26zOSS0VqI/OAFfg++w0pjxXUBiS84YgvnLzFcRnJY6XHIdb332st8Wg6zQ
         Nedq8ITcln2rU+JUE3AciGfSFKHTnTvCY6voNtrtI+eLDaVCAvVb92iW4OKWcLu/Bx64
         KXbDXBlDVgXFOmxZD9aFr31h08e4XEQ8T65S4jR3ZWPDJcGrAFrWWiRY1Zv0tgGXEvf8
         OrxlUqEHA7sa8nrDzVVVBQqKB5rX/zjk2bGUZyuRHvJunTLtvRgLgU/9Vpxd2PViuhUA
         6JVWEahgyqrTV21y17b4gPQj2+wiezaM7jofj3zD8ZnbKcaP5pP75G5ywUCtv3YFdq6K
         Ol+w==
X-Gm-Message-State: AOAM5326wqGP9mNK8HHQ4fw8elFKU3ZNQjUCuJGqwhelcLqnh77wGnJa
        NEWPCaVSjtHmILsfl4Q53p6snjU94zY=
X-Google-Smtp-Source: ABdhPJw0vKm9FdQKsG0hoeqxUJDXC0FEQYo3JyuE9Wmc+L3FZWZ5OYwm+11VYvW6kCCvzc0iO/B5CQ==
X-Received: by 2002:a17:90b:3004:: with SMTP id hg4mr5231547pjb.12.1623766261749;
        Tue, 15 Jun 2021 07:11:01 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ls17sm2616272pjb.56.2021.06.15.07.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 07:11:01 -0700 (PDT)
Subject: Re: [PATCH][V2] net: dsa: b53: remove redundant null check on dev
To:     Colin King <colin.king@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210615090516.5906-1-colin.king@canonical.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <55b9ba06-eeb6-f836-6414-9e2dcbbe3d39@gmail.com>
Date:   Tue, 15 Jun 2021 07:10:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210615090516.5906-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/15/2021 2:05 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer dev can never be null, the null check is redundant
> and can be removed. Cleans up a static analysis warning that
> pointer priv is dereferencing dev before dev is being null
> checked.
> 
> Addresses-Coverity: ("Dereference before null check")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
