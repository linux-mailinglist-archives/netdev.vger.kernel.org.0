Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EE2BA119
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 07:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfIVEvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 00:51:37 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:39294 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbfIVEvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 00:51:37 -0400
Received: by mail-lj1-f172.google.com with SMTP id y3so9191799ljj.6
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 21:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QYMkJvvpfizVUmR54Ubmj8VISMMiodmRo0ArPXrwBsU=;
        b=hEprYMfP9PPZ7yA/J1LFnXlONyVva1M/XKkhTvIF6ANcf1MkHRXore3Xyii4vCU3rU
         qJBf2vQ+7aSJlsI+3i09B8N3HGEw4dqaE+HXvZGktfRyn0HeP7TYR/PobSHqD6u8Bldl
         vlyl9a5nQ5RJ8GWktqa8Ja9AFzZfyg651XcxxM/EosXgEapXFmeHDqQdLUeysfTKByEl
         ERCR7lRd6x0IM/oFAzK2AJZs23PyyWZQ65TTCDfAljfISeHizs5wvc3sujbBCLx5yxdo
         IoaGOkr64XNkTCg4Fp/C75QMdOQgZLzhjnF1liobOY6AbqldiYgEuh10LfvaBulOOjhw
         p55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QYMkJvvpfizVUmR54Ubmj8VISMMiodmRo0ArPXrwBsU=;
        b=NF9a1T4FlzQs62jsjPRjv9zvbEhSvTmMXg2RQcSzzdovZ6UsshNeQkQYe+qg9rHxuM
         9bpfDPeAZBIudqyveFCrdlUaa8WhrI7QwoDHfH7bBzUMnbT9vRD8HQ2fpr7mbvI8F8mV
         j/M4KONzBXcOunuLRYbKrm/UJ/oTJyrEjP+l+NyB9RO1if4hc1pg27BG2tHuT+ZJtMmm
         i1EkiSrp2V+R9Z8zHeObIMdm0aoTA69gyNH/g9QcXHgkOLXyaY3QE20nrTnsvFq9FxoX
         ydrB1LdPxpZHSoU6Tg7USwZ/oDlLe/JAbBX2H1aOWzGTQbwTP91azS4+wjeDP37eGag2
         G/Ag==
X-Gm-Message-State: APjAAAVanQWB4W+aaxcFoa7CSYR6yn+sTsJapMQk42cjhnFVsUjEu3vd
        FrUoANdP6wlcr58yoUgr2wcJEul26bHSm4VAHwA=
X-Google-Smtp-Source: APXvYqzquJO9HIRD6+XIVXR88wA61c/FexKusYxQIdF5aGzqVSHdsqHv2LwqLAWcLvImamu8EWM7zbpgqh6lr0Ap/H0=
X-Received: by 2002:a2e:730a:: with SMTP id o10mr11256683ljc.214.1569127895300;
 Sat, 21 Sep 2019 21:51:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190919.132147.31804711876075453.davem@davemloft.net>
 <vbfk1a41fr1.fsf@mellanox.com> <20190920091647.0129e65f@cakuba.netronome.com>
 <0e9a1701-356f-5f94-b88e-a39175dee77a@iogearbox.net> <20190920155605.7c81c2af@cakuba.netronome.com>
 <f1983a74-d144-6d21-9b20-59cea9afc366@iogearbox.net> <CAOrHB_Bqhq6cy6QgyEymHaUDk-BN9fkkQ-rzCqWeN35sqiym4w@mail.gmail.com>
In-Reply-To: <CAOrHB_Bqhq6cy6QgyEymHaUDk-BN9fkkQ-rzCqWeN35sqiym4w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 21 Sep 2019 21:51:24 -0700
Message-ID: <CAADnVQJBxsWU8BddxWDBX==y87ZLoEsBdqq0DqhYD7NyEcDLzg@mail.gmail.com>
Subject: Re: CONFIG_NET_TC_SKB_EXT
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 21, 2019 at 8:15 PM Pravin Shelar <pshelar@ovn.org> wrote:
> > > Any suggestions on the way forward? :(

since there is no clear and agreed by everyone path forward the simple
revert is the best option.
Next release cycle you can come up with something that works for everyone.
