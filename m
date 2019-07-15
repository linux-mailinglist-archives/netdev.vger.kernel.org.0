Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C307C69920
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 18:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbfGOQc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 12:32:26 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46927 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730071AbfGOQcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 12:32:25 -0400
Received: by mail-io1-f65.google.com with SMTP id i10so35010341iol.13
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 09:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ExPf+8V5Sa2WwiUuyXyWEhZTlNrB7yeAb3JVT/2awNA=;
        b=ib1vp1GNUIcMI0W9GN4cmhJyNmFnkHYrI99E/GA+upyB5TNLjUaNKO5BEMhQv0/cIi
         ++7ZxQFkp7rKXu5PIwVb0LSmKULTyze/NPNI3JrMvg4gmZDVugsxVrpIlOFF7vKNskHG
         ckXCWH9Gbo542uXblXpholosJUsTd+dgGtYn00NJ2CsdQ/Bw6aTjF4d8Kk+kqflw59ce
         uboOUVum5BJ/R6Noqk4sSnSdb82go2o4K36fBDKd1xpmAOzTMjWOglMYjw1tSldOcZqm
         OH1r0YEjaQTHYJ8ax75AqZr85tmgX5kIWW/dc29+RGrL9B+qtF+qlIeo1JYOPYa8yyDB
         JKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ExPf+8V5Sa2WwiUuyXyWEhZTlNrB7yeAb3JVT/2awNA=;
        b=UQGQjN4uxMkbRbRmzHChnhGoZlxT6WHlGzziT4Kg1yfn0PMEnE+M319yzvfpQ3af36
         fkngDB0WrCW7z2bck5Kjmsgkdf/b5mQaRcjuOKtLDoYrPYXyQ1ps4TTlaaR/gLwuNNwz
         ezni04i4Whv1TL3RsV/qvH4YuxOp+qDAOWkFtMUMtAbI2SyBENM+BcSAh6ZGpV7HCGIn
         uKksBwmecXwG36Pr3w/Cw5fdA4zHRz16LKz1WJuQy9/B1gL+8qWKWUmrJMprU4iDI3XJ
         CxBbTCPwlyATVGiTbYZUqMbJNbMnPOTelTu/IDAwdAAtX9lvrfya1VtU2RA4cjFKjhYU
         DWdg==
X-Gm-Message-State: APjAAAVVcrfE0GHCRVy2MiHV9a5NMNUbRvRRTUvBdNPobneSm/Hyyhyo
        BWXSQAHSZWUY6+9kO8lkRMu4hfKS
X-Google-Smtp-Source: APXvYqwrDztCXhMMg7/tyKOr/UYboTLILbHGY+oeK1e97NT/LLbe4UFAqEq/vSUZ9nvu/y3PndQ1Hg==
X-Received: by 2002:a5e:8f08:: with SMTP id c8mr25233507iok.52.1563208345002;
        Mon, 15 Jul 2019 09:32:25 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:51b4:3c95:43b6:f3d0? ([2601:282:800:fd80:51b4:3c95:43b6:f3d0])
        by smtp.googlemail.com with ESMTPSA id p10sm32605612iob.54.2019.07.15.09.32.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 09:32:24 -0700 (PDT)
Subject: Re: [PATCH net v3] net: neigh: fix multiple neigh timer scheduling
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, marek@cloudflare.com
References: <552d7c8de6a07e12f7b76791da953e81478138cd.1563134704.git.lorenzo.bianconi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <397fddad-b242-be56-7787-34af4db37abc@gmail.com>
Date:   Mon, 15 Jul 2019 10:32:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <552d7c8de6a07e12f7b76791da953e81478138cd.1563134704.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/19 3:36 PM, Lorenzo Bianconi wrote:
> Neigh timer can be scheduled multiple times from userspace adding
> multiple neigh entries and forcing the neigh timer scheduling passing
> NTF_USE in the netlink requests.
> This will result in a refcount leak and in the following dump stack:
> 

...

> 
> Fix the issue unscheduling neigh_timer if selected entry is in 'IN_TIMER'
> receiving a netlink request with NTF_USE flag set
> 
> Reported-by: Marek Majkowski <marek@cloudflare.com>
> Fixes: 0c5c2d308906 ("neigh: Allow for user space users of the neighbour table")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
> Changes since v2:
> - remove check_timer flag and run neigh_del_timer directly
> Changes since v1:
> - fix compilation errors defining neigh_event_send_check_timer routine
> ---
>  net/core/neighbour.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

