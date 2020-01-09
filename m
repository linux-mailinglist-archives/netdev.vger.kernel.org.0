Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D25E135E1C
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 17:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733095AbgAIQWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 11:22:07 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33825 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731343AbgAIQWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 11:22:06 -0500
Received: by mail-ed1-f67.google.com with SMTP id l8so6140586edw.1
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 08:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YqRY3/0o9dC9SLR0E/AbmkzMGeajnGiCClhJJgN0l/c=;
        b=YdyElQCH47WiNjIgR+kZ1xIeeO3h/KkvgjBJR+0wwAIL8zuO1ElRkrjmw2x/uBAj32
         P6R92Ur8PHhP0rOShoSyF7AnYZBr5H68k1IiAql/szXSicCAPcSwswVY60sDgfS7zjL8
         NoApCOlBjs/giRdvMK5qk3MRTYWcf7EmW2IIA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YqRY3/0o9dC9SLR0E/AbmkzMGeajnGiCClhJJgN0l/c=;
        b=VzDHRj5QqkguP3CRA6n4vVrDiv/wBv19YEirlJpgV16pEktcIFeS4UHQBoQqMkU1zb
         7fpcXUXL/IgUAVHF1XLIGEMFe4xkmnRtnuvHJhcmfTQKQe+h4rdQhYGGWpJvJXNK50BS
         qfBsFzB5qJMh384+b92ng+Jnxy+4YQ9arF+pYMkVUvtDt9Pt6YV86mgs0FzKc4zFCt0Y
         BdYBFVOxjm1baOY9nvx3ubryWjy06YU6whlOM6s/prw1dQXjYRiaq84ejPnvPCQH4tXM
         fsrdZxtaMxR58kBHYK5hesoFSJZJL+Bkc6arMmwNPnNUtgB75FPUhKGLARNv/EZSYJu6
         ruEA==
X-Gm-Message-State: APjAAAWC/ZJZxmgTs7QfXkRgGekyeUC3LcXMh3ALZeobOKg6HAO0W7AY
        L6ZO1IFcRldivDOW26jdasQYH2jqqPifgl/PV7uWvQ==
X-Google-Smtp-Source: APXvYqwlqS2n/fOPF8yvlTtnPUKvIc2ov7IIFH/LsC+tfvyP8nC5SHfrqJM+tixVYznf5O+UZL0y4ou97mlONNVkao4=
X-Received: by 2002:a05:6402:1496:: with SMTP id e22mr12050287edv.132.1578586925132;
 Thu, 09 Jan 2020 08:22:05 -0800 (PST)
MIME-Version: 1.0
References: <20200107154517.239665-1-idosch@idosch.org> <20200107154517.239665-5-idosch@idosch.org>
In-Reply-To: <20200107154517.239665-5-idosch@idosch.org>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Thu, 9 Jan 2020 08:24:55 -0800
Message-ID: <CAJieiUhXp9=-L1Qmy0ssBdsasVw5Qnu5_NcNMaY7VLKQ-kFyPA@mail.gmail.com>
Subject: Re: [PATCH net-next 04/10] ipv6: Add "offload" and "trap" indications
 to routes
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 7, 2020 at 7:45 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> From: Ido Schimmel <idosch@mellanox.com>
>
> In a similar fashion to previous patch, add "offload" and "trap"
> indication to IPv6 routes.
>
> This is done by using two unused bits in 'struct fib6_info' to hold
> these indications. Capable drivers are expected to set these when
> processing the various in-kernel route notifications.
>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---

Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>

Nice, Thanks Ido!
