Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214242C5700
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391116AbgKZOWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390912AbgKZOWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 09:22:11 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0AEC0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 06:22:10 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id f23so3207171ejk.2
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 06:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=FPT5qvIne+a7AZC3ewghBub8NGaZrVrp3vB6jORoThE=;
        b=GtiQiMnqyK/rmTNQpft5g4Fl5MRbOkRsjmtT6XgZTHpFRce8LW76mQBww8I6pqKO1y
         AuzpvpECBqF2VOOvirrI6NYBh2ATmPvrt1mn7YkaibrjTTy45OoIAw9zE5nwIpIKfJQn
         3KiA3ZqmIhy8wdJ/zwBBBUHUejy7/73b4BkzPLVEVKW4oLEKl2A4bVfRmiIsGrZY0rVn
         WBwvjiJWa0QeSmMBUO09cPrFb93as+hgHqSv7wQJ4iaGcqm2iFoN7l0FY7MeQVTH9a2X
         zFseFURRoJ0ZsJpQwMwU9Sxxg4dijCjSfzJSywzVfr/ch4hD2QSQ75jYefPD8VLG20AE
         FG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=FPT5qvIne+a7AZC3ewghBub8NGaZrVrp3vB6jORoThE=;
        b=UA4hTAcrGRfNcfMGBoFlLIqYWPTsmzJ+obawgn/VHDSR1sR1a1QJj9DYhyJz9DM323
         CLMNFnt/DzEesA49TiaSxOAhTcbT25zo2KXwW86iMqsu/2i7SvCBzzs9/EK8Jz0ON++l
         cW2TvsmSjSzrecuGgV79wjzgnY1lvwWvQWr/FZfxd5bKoRW1Y6jQTDOtQNqevA/khDvB
         Y7qeXHRK6HJanDB/ftR9dS3fOPOHPcSCT+UY8phdfoblv+J23D4FEHpSLH8AiX/5L+SE
         UZ9WwipRJ4eV9g1pFvLkbdk1EhtcXTVPdvWumubo/oipfM8BxvR377JHdWd9dLdX+oW5
         9L8g==
X-Gm-Message-State: AOAM531b+kGDE7FSN9oUuAFOoweyQ4CowLaMGmUIN/499gPZttBO0LgH
        0F4rb2hxWgJ+Z4Au2ZfiZvRX+vpYYHSQVvwrH5Rz0A==
X-Google-Smtp-Source: ABdhPJw/ZmVzTr94r1/dh7LDJeMQebqt5ugkCW7f8+JD+m85up7ZZo5Cn3duMM7hFK+dMhcDDKG+H8DjM1zvhWbaauE=
X-Received: by 2002:a17:906:f8c5:: with SMTP id lh5mr2862629ejb.77.1606400529109;
 Thu, 26 Nov 2020 06:22:09 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a54:3cc7:0:0:0:0:0 with HTTP; Thu, 26 Nov 2020 06:22:08
 -0800 (PST)
X-Originating-IP: [5.35.99.104]
In-Reply-To: <20201125152742.05800094@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201124122421.9859-1-kda@linux-powerpc.org> <20201125152742.05800094@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 26 Nov 2020 17:22:08 +0300
Message-ID: <CAOJe8K1EVPapfRrtzK1hD4_St9vqFT1aad4JvE1Ch6X-rD6=iA@mail.gmail.com>
Subject: Re: [PATCH] net/af_unix: don't create a path for a binded socket
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/20, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 24 Nov 2020 15:24:21 +0300 Denis Kirjanov wrote:
>> in the case of the socket which is bound to an adress
>> there is no sense to create a path in the next attempts
>
>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>> index 41c3303c3357..fd76a8fe3907 100644
>> --- a/net/unix/af_unix.c
>> +++ b/net/unix/af_unix.c
>> @@ -1021,7 +1021,7 @@ static int unix_bind(struct socket *sock, struct
>> sockaddr *uaddr, int addr_len)
>>
>>  	err = -EINVAL;
>>  	if (addr_len < offsetofend(struct sockaddr_un, sun_family) ||
>> -	    sunaddr->sun_family != AF_UNIX)
>> +	    sunaddr->sun_family != AF_UNIX || u->addr)
>>  		goto out;
>>
>>  	if (addr_len == sizeof(short)) {
>> @@ -1049,10 +1049,6 @@ static int unix_bind(struct socket *sock, struct
>> sockaddr *uaddr, int addr_len)
>>  	if (err)
>>  		goto out_put;
>>
>> -	err = -EINVAL;
>> -	if (u->addr)
>> -		goto out_up;
>> -
>>  	err = -ENOMEM;
>>  	addr = kmalloc(sizeof(*addr)+addr_len, GFP_KERNEL);
>>  	if (!addr)
>
> Well, after your change the check on u->addr is no longer protected by
> u->bindlock. Is that okay?

Since we're just checking the assigned address and it's an atomic
operation I think it's okay.
A process performing binding is still protected.

Thanks!


>
