Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058B36EA52
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbfGSRpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:45:08 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33363 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfGSRpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:45:08 -0400
Received: by mail-lj1-f195.google.com with SMTP id h10so31573432ljg.0
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dNAALzOvftMNuIGo/Hvnr5KO7EC6ztWulyg3Fk0l3Jc=;
        b=Rqn8qj5UNOnX2Y6C0MDJSj5U5Mhxhe2BkesN3t+5CZ8lNabC9OfSlASlombTRYGKw0
         PsA3hhRhtpCkTCYx9AnAl6incofbfMtRC3tiJFGUdDY3hBZZueevEYihxD7cTRM1lX9+
         bOLoPpS5O2j+adBG8Lfn4PtZCybxckT9UulJ9BADJYKHYLIWL1OYVtPizkyz5BI7NQA/
         umnRkXI+6k9nVuNlayZaNJDfuI7rWGC1emyS9rsd7yIYUVTWsltG5AlSY7xGx86ApAcA
         a0JnylRDt9S21K4pc/Om1SVH6idBbCtMTuKFGuIQ9/+WDybKTC42AWzZhUdBK0cuShAn
         pD+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dNAALzOvftMNuIGo/Hvnr5KO7EC6ztWulyg3Fk0l3Jc=;
        b=UPFNblTZ8zEreb1RgTDVO0zxzbGPvNHtGZUliA5aqcQeLIzafgZtuK+jFJK3UIEXVL
         J9LZZBeruDJXXoDsNwuhMQW0WrxhJwoXJMkl8Z9znSTJvdEMSkCRPeovYoZX+H6AuRB9
         pET7T7E+hnjRioPYGpivoZZwcPS/fUvvlUUCFAERvKoLeUBhM/oOagXTzkDp3Ov4Q4oI
         GkavB5K1SnEXEeY9BIlRWXoLxLqfs0x3i190IZ/N7XH7QpTKAliTfpHbys298x+vgEkF
         kENZ9BNrFOp8wW2ifzVZG63yEerp6JttDDDXjJcaJsbes6E60VrdumQsYkjo2XlP1FOK
         /ovw==
X-Gm-Message-State: APjAAAVslNlMBKVsTtA795dY+YDuZaE8xyYlAW2eK437XLuwpS8CO4W1
        y5rzvnvcD+izmuwawH6jJavKHhtqJsWONo9iASJ68g==
X-Google-Smtp-Source: APXvYqxJ8gLqkFkjRUVHt7emv8EI40XfhprvCj9W+0xBDGMiIP5V3bdoOZobK4eON5c/d0Mh7vVaar/f+htzBegmJkE=
X-Received: by 2002:a2e:9754:: with SMTP id f20mr27952332ljj.151.1563558306044;
 Fri, 19 Jul 2019 10:45:06 -0700 (PDT)
MIME-Version: 1.0
References: <MWHPR11MB1757F23147F85B59BCF1628BAFC90@MWHPR11MB1757.namprd11.prod.outlook.com>
 <20190718.163207.289099133864098969.davem@davemloft.net>
In-Reply-To: <20190718.163207.289099133864098969.davem@davemloft.net>
From:   Catherine Sullivan <csully@google.com>
Date:   Fri, 19 Jul 2019 10:44:54 -0700
Message-ID: <CAH_-1qwjgoi7Yve0s1NS1oEKXmxu3V5SPZMzy-Wwux-gM0Pf+Q@mail.gmail.com>
Subject: Re: [PATCH] gve: replace kfree with kvfree
To:     David Miller <davem@davemloft.net>
Cc:     chuhongyuan@outlook.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 4:32 PM David Miller <davem@davemloft.net> wrote:
>
> From: Chuhong YUAN <chuhongyuan@outlook.com>
> Date: Wed, 17 Jul 2019 00:59:02 +0000
>
> > Variables allocated by kvzalloc should not be freed by kfree.
> > Because they may be allocated by vmalloc.
> > So we replace kfree with kvfree here.
> >
> > Signed-off-by: Chuhong Yuan <chuhongyuan@outlook.com>
>
> Applied, thanks Chuhong.
>
> GVE maintainers, you are upstream now and have to stay on top of review
> of changes like this.  Otherwise I'll just review it myself and apply
> it unless I find problems, and that may not be what you want :)

Will do, thanks for the review. And thanks for the fix Chuhong.
