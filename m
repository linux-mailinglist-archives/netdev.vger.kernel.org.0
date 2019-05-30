Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B904630127
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfE3Rnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:43:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35253 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Rns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:43:48 -0400
Received: by mail-pg1-f196.google.com with SMTP id t1so2437820pgc.2
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Y0eaCb5imPLyD5iKhSXph2wjPVG0CCZNmdUwzYGmq4=;
        b=mY8YJPH5a3TPMUSQSDLbcjj9uMeT/wyMJ2DaiBpoR3YVJJlQqe9mNQew4zq48JFQL+
         iZgJqXxH5ORMr9Rab3m2JNnF+4xyYwEsRBTt533uvdm6R44NpBBRfM40kgVeIpDpaBVZ
         PlSs3RiOZoxyqprej9cCLJrrmeDbrVJsGz9xaNXnOc8eM+n1+4bcK/rLRjPHw6aiAX4Z
         dpq8e4IDs/gfEPB/uQCthRNUXQ20c0ExOf462WShfhRSfVRNtBvY+Cch2EvOYxAyTdvw
         bVgOXlXM5pcf7O+srB10v29PYNoubfOj2WsYInaqOmqbp2kmvvz9tawmVa8j0xBEVY4n
         O20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Y0eaCb5imPLyD5iKhSXph2wjPVG0CCZNmdUwzYGmq4=;
        b=eqippaDmT4BQt3EEAmdlQWG6E6o/HX8JGvRL1OtwR8IH96IhZhcOzCeUlHLyYZ3ZNt
         YYzLxqZqIk9khOB8cJqKjrzN9p1o1EGlkUGcGt7rx00bl48w//e2Ng6CPEn94Oh8f7U2
         j19cC0vtYLeFL9Qmszaz16ioJo7Te1CWwxPL8thOrVu7nhHjKb7s6yIdQXIPwIyXEIsR
         QnRZzLJuqK0rq3IFQm0jzJSyvDOaElJwT5QDkh/yS6CLzb9OWAcYE+7sPDI5lpjO7VJv
         Rkg8w/ni8oMwjMnN9nhBYHFUTVjJ9SFXZ8PQHaFlt6UkkR0OLF8sgaLxpQlUcKfu8T37
         AJ9w==
X-Gm-Message-State: APjAAAWgaZxCKpvPUFWwpPkRe1ausiRv2piAVrB7/31LV1TeNPwgUrto
        T5S8rIstVb4aiVgr3hlTCxFuXw==
X-Google-Smtp-Source: APXvYqzp4FLVc3M++ZF9nfdkc0bJEZUyjK5tpMEjSWLqtdx8HS57taTD8wfrx432kX75twhHyeXEBA==
X-Received: by 2002:a17:90a:22a3:: with SMTP id s32mr4690360pjc.0.1559238227873;
        Thu, 30 May 2019 10:43:47 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j8sm3416308pfi.148.2019.05.30.10.43.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 10:43:47 -0700 (PDT)
Date:   Thu, 30 May 2019 10:43:45 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 1/9] libnetlink: Set NLA_F_NESTED in
 rta_nest
Message-ID: <20190530104345.3598be4d@hermes.lan>
In-Reply-To: <20190530031746.2040-2-dsahern@kernel.org>
References: <20190530031746.2040-1-dsahern@kernel.org>
        <20190530031746.2040-2-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 20:17:38 -0700
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dsahern@gmail.com>
> 
> Kernel now requires NLA_F_NESTED to be set on new nested
> attributes. Set NLA_F_NESTED in rta_nest.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  lib/libnetlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/libnetlink.c b/lib/libnetlink.c
> index 0d48a3d43cf0..6ae51a9dba14 100644
> --- a/lib/libnetlink.c
> +++ b/lib/libnetlink.c
> @@ -1336,6 +1336,7 @@ struct rtattr *rta_nest(struct rtattr *rta, int maxlen, int type)
>  	struct rtattr *nest = RTA_TAIL(rta);
>  
>  	rta_addattr_l(rta, maxlen, type, NULL, 0);
> +	nest->rta_type |= NLA_F_NESTED;
>  
>  	return nest;
>  }

I assume older kernels ignore the attribute?

Also, how is this opt-in for running iproute2-next on old kernels?
