Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4081687EA
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 20:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgBUTyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 14:54:25 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:32817 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgBUTyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 14:54:24 -0500
Received: by mail-qk1-f196.google.com with SMTP id h4so3001990qkm.0
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 11:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4MzZUSLi4kkVsnFo1IE1or3Z7NEYEsWVAso27bEBY1Q=;
        b=R139HaRemh3nVL2bQIB+n4/QKg2bhNfvpwS8Z6LOc5i1xLkUr1txTya8h6ZYThAZew
         won/KDybrgHIOhw8iteUPFf5BiaKZIjHijtSowYKLbDSK0/sv4tJOOqZ3SIWMT1qA1v9
         aj+6ekw95a1A/JbGVXJ9VCqczKfALAguQ1+JkNsZDR6wWdt3qQ3Dxavfu68ZV8sYY96w
         5u7cm0vc8/aE+t2UloZesaHCQjfvvuBXbsEN6q8N5R5UzoSZ6ELpw/6kRaMhWpkh7qS0
         ARnSuRK3e6oK0pjRsXJmD4MNWy6kZpdJRVyr8q6eVSucSOMeJahb1/lcAhcxGVjGHQry
         HTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4MzZUSLi4kkVsnFo1IE1or3Z7NEYEsWVAso27bEBY1Q=;
        b=gFRpZeUcL692V3cRhMVW6GhJRDOH0FyMiamsWJ33jYQ7iYsa+aqiTuTT2WNjf7RnBN
         BP11npU9CwoXLyUPpk43+0A5ayXWn8EDsKfPyQBq4CubRtxDYosX4MU/ieTtj2V/sJrR
         6qIfBmULWptMOgMqKpjF7s/0PugzRcCwswG+xGEYdvOimT+mZ0fArrAQBB7y4OaGjUif
         9NXNZdClfJL+OmpBiBDN1yhsENCjR7blh3GDv3T8DQAzvnBW2ywV7ezrloSZ8THhb6CI
         fS9SUH+zZSyDDbYZd2jaFou05f+H58N/cuLhhnxzphgI3i43gH+3kttxsg4Njbp/RE/u
         e9Fw==
X-Gm-Message-State: APjAAAW9uz0eWwS0D0t5CRPxJLiJmjRF9mDWnEM3qsqij1ZiUx1YMVp+
        48GtQrLGAfNDHpAnQH18Uv1emAsF
X-Google-Smtp-Source: APXvYqz8cmlpemOf9qhCq6NwbnI9Fi7EZMR48qYPtI+snwr8LiO3/HtY1gEJPw0c9bm1QJ69O9Ynxg==
X-Received: by 2002:a37:4a48:: with SMTP id x69mr34051000qka.57.1582314864057;
        Fri, 21 Feb 2020 11:54:24 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:6191:8310:a1b6:e817? ([2601:282:803:7700:6191:8310:a1b6:e817])
        by smtp.googlemail.com with ESMTPSA id 132sm2019266qkn.109.2020.02.21.11.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 11:54:23 -0800 (PST)
Subject: Re: [PATCH net-next] tun: Remove unnecessary BUG_ON check in
 tun_net_xmit
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jason Wang <jasowang@redhat.com>
References: <20200221195309.72955-1-dsahern@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <064afb26-2a46-3d29-66fe-8db5e24f8989@gmail.com>
Date:   Fri, 21 Feb 2020 12:54:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200221195309.72955-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/20 12:53 PM, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> The BUG_ON for NULL tfile is now redundant due to a recently
> added null check after the rcu_dereference. Remove the BUG_ON.
> 
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  drivers/net/tun.c | 2 --
>  1 file changed, 2 deletions(-)
> 

D'oh. Forgot the net-next  label
