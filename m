Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FED19FED2
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 22:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgDFUMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 16:12:08 -0400
Received: from mail-qv1-f51.google.com ([209.85.219.51]:38523 "EHLO
        mail-qv1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFUMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 16:12:08 -0400
Received: by mail-qv1-f51.google.com with SMTP id p60so682063qva.5
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 13:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aSq+LTW1JjLXX8aHmTo8v4eCLtTr4rUkTZQLSFkWIY4=;
        b=M6g0gOZ1gfW0AZgWf5wpStynjAzDfFKRGquWDpBoa681hEc4CbQBuOmmWfi6tQ+s2j
         jXtJPmDPD7UqijqEN1fh0GZdRABWXnwMDKJsfcIBxc5bqO5L2n1dMg6HjglWZuu25xSy
         iewwTSp8+O6pCW3gnokcfJRfpEAdGKan+jEMbpyveryqZbBy4udUYZUHqHhUZtT490rB
         SM7dXbBYCrdYyCpztpXSJImrwUXPpHXq4vVCHo/9lxsoZkKfo5AlpjFF16HZeWHT4PGX
         ZB3i2dskoCReT/SH81rVJyBDdxR9KvxBTXCj5o/hmT3+onq8eHFZqNyu8jN3RgGFTZAz
         FgDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aSq+LTW1JjLXX8aHmTo8v4eCLtTr4rUkTZQLSFkWIY4=;
        b=sDDJUvs4Nl+iExJ3xoXoCvYFsMv+xgVHIrDyOckHbwC8xgz/ap6pShIoUkwkDcZXDR
         JESue9S3RgrLWjUcvwq0VdiSC+qO4jqy6NQoJOhhbQV8CDyrYhxRR+Ztwth1h8f4Kk/e
         s0VBIui/4a8BQf6yoxYLPBOdIyPxEq3F3uvyqw54AMCrmiJ3kzMq7KwlSUL9DjGJ4cXY
         t6qom1UtWCnMVnpckaw7FnsXSuTdtiCy7Kaam0SmnafL82nycK2eSt3igF3y+JLY1dJT
         ce9luNgHA7TXG0RCbeVUfckf5XBnxEfY7BuVQLxOz/Z3FeCiMi3M7FoPqumpuDTfI7xp
         0TYw==
X-Gm-Message-State: AGi0PuZkkIrgvTEbx22qfiTjk4T3bymMZ0zPqTlI9/NilqXbta9afJ8q
        5/seY71YhoXk5+IPrZFZ0KtLzoZp
X-Google-Smtp-Source: APiQypJrjtDuDh/Fpop86v+NylAKwa3rwBYOqyTQ7+KluSuTG57ylc3vLatbIt9iZN1sFJBAdb3WvQ==
X-Received: by 2002:a05:6214:17c4:: with SMTP id cu4mr1517353qvb.129.1586203926816;
        Mon, 06 Apr 2020 13:12:06 -0700 (PDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id p24sm13981885qkp.60.2020.04.06.13.12.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 13:12:05 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id e17so565076ybq.0
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 13:12:05 -0700 (PDT)
X-Received: by 2002:a25:4882:: with SMTP id v124mr13210252yba.492.1586203924600;
 Mon, 06 Apr 2020 13:12:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200406080343.2a0c4e7b@hermes.lan>
In-Reply-To: <20200406080343.2a0c4e7b@hermes.lan>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 6 Apr 2020 16:11:26 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd8iKLSJT-fC_rSd9ZwVYJ1-g+y==BF6SfRG1UWN+AE=g@mail.gmail.com>
Message-ID: <CA+FuTSd8iKLSJT-fC_rSd9ZwVYJ1-g+y==BF6SfRG1UWN+AE=g@mail.gmail.com>
Subject: Re: Fw: [Bug 207097] New: recvmsg returning buffer filled with zeros
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 11:04 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> This is most likely just a programming error in the sample application.
> Someone want to investigate it?
>
> Begin forwarded message:
>
> Date: Sat, 04 Apr 2020 11:00:23 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 207097] New: recvmsg returning buffer filled with zeros
>
>
> https://bugzilla.kernel.org/show_bug.cgi?id=207097

From the link in buganizer to another discussion thread with the whole
program, this appears to have already been resolved.
