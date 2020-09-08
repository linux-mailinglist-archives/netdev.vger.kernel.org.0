Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C638C261EB5
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731605AbgIHTyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730634AbgIHPhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:37:36 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDACAC0A5533
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:22:33 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d190so17512749iof.3
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wv47zvinBhKg0vq/6EAnZ39ueq4uvNH/PtA8bcvftxQ=;
        b=GakHKna5vrBVVaJesL5Q3UZyQ6H/ra8rIsoElc4u8dgLJnYm3Hx5jUg7cZuA7GEMOC
         j8gETqMrvIKEhz8z99J/sEnH9SqnHhmwiSg9LwQicaxzogKlVCziTUkJmlE5PDwaMo5t
         Y6f+XKzYDwYqPvBjnfADY777J3QJoyBSz0bSxsGF3NMrXrFabeWq43tGyM7Cj32i6ye0
         sRj/nRz+bETVE/WP2yfeNoVHTA8zzKu3kQHTuWEafxfpRbKciEuC2ZTNY6S9NE7lsaC7
         IK/CWVmEzS4LZjLWhpbS11qH4jkro4qZeicuK93azkizcAA8pCccC3JrVB0yvGowTaoI
         O0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wv47zvinBhKg0vq/6EAnZ39ueq4uvNH/PtA8bcvftxQ=;
        b=EYhMd3JHmiR+g1mnjX6vHaEgzQV+8bPhJux0pNT/GKGCuFFqHxGG+YGvV/GC/mNHMc
         LT8BR1TYnR7cQxMmQlZPyH2cwBKJoCSJdFoTUHkj+aiTIjnAjPj4sqYLnPh3+mOUFwif
         1fE6p66HleITUGlPBqPYOPgJL/FW9O/JM07+yamVfDG6oowSlVv6xCEW4xn8yNvyq6F9
         HGDq29/jSk8rFmP9Go7HiYkkK1o+3nBxRGLuAbiUCTj/FzZ5kbFcax+Y+RvS3Y4ZCd4P
         XsMTI4ibzKQBHmX/BnVkfz4Dn43rjQDIb9g1hdIOYFEKoNYyvULrArhPoj8lnyo/4Yt0
         oTtA==
X-Gm-Message-State: AOAM533BDgi+Jv0Jj5Zv0UQfOlN7eB6p+ZDaJ0ufIaEmkewhnACs0XMT
        /1GP3OWpabeL8DSX/tJn+wqXZI0N3uDJeQ==
X-Google-Smtp-Source: ABdhPJz6RYf7DstdZv29CDtF0Bxiz9zDyL8VZ+lrg3fQsMKMt6+miTtaGwJ3TkiCmstf1GFoNpGJgg==
X-Received: by 2002:a05:6638:168c:: with SMTP id f12mr22166158jat.16.1599578553211;
        Tue, 08 Sep 2020 08:22:33 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id m23sm8720222ion.6.2020.09.08.08.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:22:32 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 12/22] nexthop: Emit a notification when a
 nexthop group is replaced
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-13-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d7d4e5e1-201e-a553-3240-ae83226ebf47@gmail.com>
Date:   Tue, 8 Sep 2020 09:22:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-13-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Emit a notification in the nexthop notification chain when an existing
> nexthop group is replaced.
> 
> The notification is emitted after all the validation checks were
> performed, but before the new configuration (i.e., 'struct nh_grp') is
> pointed at by the old shell (i.e., 'struct nexthop'). This prevents the
> need to perform rollback in case the notification is vetoed.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


