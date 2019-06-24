Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD7F51F34
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 01:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbfFXXox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 19:44:53 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34662 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbfFXXox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 19:44:53 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so24228710edb.1
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 16:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R8P3WscXMVpeq8XLsiakQ4NZTKYL+Y5bY3faLkkMWlU=;
        b=hbuZfjhQ/86rI56DFvZKUJLiVCi3nCV3LcRDRI3GXhRGoM3bxuKXO3BCxHh9MZbaK3
         ik6Vf8IYdujMGpg22PPtwlc2GeG85R3ni6SOaw/hfLPrTgATTAd3aLmSXKcFoCvWbGew
         Z4+nmAlCSzsAjZHRdV0kcpBesYyhFyWPdQ8WDXjMzQuMvWoJbnPDdO8GykHRTw5nwBlj
         xuojQzriam72Fu1fGNtuJvSRJdbSxQzNbnyv4EGhVEw9Kl+9wpwGBLGzeSrSyGgdtxQg
         1UEnePh2GHU9F9XDd6y55sDe7yCCCvsN1oKpX9d8sQhzTZzqwUBv4j7wjeBghDPXn4l2
         IOyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R8P3WscXMVpeq8XLsiakQ4NZTKYL+Y5bY3faLkkMWlU=;
        b=iOAcTqaJvja2ef1/SDPfP9BhW82x+Bg76QpdrqSNTEYKPzGkApiiKZSf/OMDmcfL7E
         WNxbiz1US6G++2y5PpMoTOspgPuZWxnNJIdbebWsBzCw6kaMmyoxCJ5AQ03mHrCwn2aF
         TFiz+4nxwLYuLzJw42mwKwzM+AkPAn/qu4/Fn21MYCENKW3Qi67E4miQZXicn4QebrRx
         Qx+7S33sNQJzOUwx0NUUGfvTItZijfFg3ZrFfhu6pnS1fC3ks88VxsSLkCABP0b8nm2T
         UImJnl5PQWus5WNMc8K83qxS9i78C66JpQr0HKQZKv6FC6GWLVbdP19JBk7Br/3vKD3L
         +Smg==
X-Gm-Message-State: APjAAAUFNtjZv3EGm3UBaGPhVX/ySfJ9M/3QQi2T2Lvb2TghCdz7bpew
        ennNVVP8yA+j6vQBbcApd4TtsDd+OmvfhJJI2OY=
X-Google-Smtp-Source: APXvYqy+0URwgOjbB1VHlJFrtS4jIf9qgLAkVnyGugk6BRFoK3ZxIauFR+AlP+BRnRm0gtBPEB87+EaVbB4nmKESZl0=
X-Received: by 2002:a17:906:7712:: with SMTP id q18mr130587698ejm.133.1561419891799;
 Mon, 24 Jun 2019 16:44:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190624212102.15844-1-sergej.benilov@googlemail.com>
In-Reply-To: <20190624212102.15844-1-sergej.benilov@googlemail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 24 Jun 2019 19:44:14 -0400
Message-ID: <CAF=yD-JRBw_MWHhOU2HEoRf4=k37bKFQJdypnv6CAzE1puuRsg@mail.gmail.com>
Subject: Re: [PATCH] sis900: remove TxIDLE
To:     Sergej Benilov <sergej.benilov@googlemail.com>
Cc:     venza@brownhat.org, Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 6:04 PM Sergej Benilov
<sergej.benilov@googlemail.com> wrote:
>
> Before "sis900: fix TX completion" patch, TX completion was done on TxIDLE interrupt.
> TX completion also was the only thing done on TxIDLE interrupt.
> Since "sis900: fix TX completion", TX completion is done on TxDESC interrupt.
> So it is not necessary any more to set and to check for TxIDLE.
>
> Eliminate TxIDLE from sis900.
> Correct some typos, too.
>
> Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>

LGTM
