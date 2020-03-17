Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8BE51876C3
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 01:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733173AbgCQAZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 20:25:53 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40800 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733159AbgCQAZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 20:25:52 -0400
Received: by mail-qk1-f196.google.com with SMTP id j2so16803158qkl.7
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 17:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MWi2uJL/zroL2Qv43xW6Nsf14OjBG1xrgxiGG0NgYA4=;
        b=nPc4Owz1jJ1JPbIEHYMIA1+dbwMVysBghm6LwjYjaCZx0zCyz5h8lw4zpz5rQoGe0w
         9+2LIfHKd6zCJfCfOwbwEto5DoHopzA4HvneBEXOvsbcpQW6ciMrrxFmQPQIv1zx/sAu
         wg2LFImI9FdTC97bXSsBy74PNgxGDEPAPZv8ViW6zWzKZXziIM+Z/DdCAal1y9vRfXIX
         S3B40WX0AXGyXEOVGQWHSSdEOZZ2t/1ifhime6xaxc7HAdg041Rncnp1RKCBFyCfHuxr
         IsAaCu3gUnPXzJkJj1Ivophz9jEf9s+Pi7sy0TPepOoKpDtwcFXwpaPqGnJM8hf7uRfz
         UjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MWi2uJL/zroL2Qv43xW6Nsf14OjBG1xrgxiGG0NgYA4=;
        b=ZL8++IMlyqDAMsIVELAC2I57qxSL7eiazhIUKdCkilcRnUbryG3YnmuCCd2nvF20YQ
         v7il8LHN5DvrXkRIdqk6XdeKOTX5WSrIODuvcc5RZ/5+rXMbrk3MeZRok7MB1u+++hUp
         QEjZhqqjVi9AR7F/tL8L2Vfxmto7TRJk8KPgajHUu+HkO2dL3MNODkV1J1xapZoDK213
         44T6VnsMKC6TQ95T3cYb4i8thvrFILctLrJOWejMpwKn5+7sENlxxKsAOrikIrdw/eXg
         hKsuDrUz4jhLL1Bu5xgMVnODE5pT/nTDCXcvWIhPZ+mN5IYX0ObiU1ZHLrDwPRCr0mG4
         0UnA==
X-Gm-Message-State: ANhLgQ0dlAjB+cLYss5N6+RGUiTr70m52TMDWvESmiJ7qPTNGw77/mP6
        oTCL6SVXyi+bcG5UjzDFRKM/YeZHVRYxwRkq55yIVQ==
X-Google-Smtp-Source: ADFU+vsr4ionX4T+Bthkxjc/SZe0zRbbYI9m+En9ZMzjLYoUml30igFYy/13bfPc8jhZKn7Tn27gcQbP9qS1aDVwELM=
X-Received: by 2002:a25:aa6d:: with SMTP id s100mr3542806ybi.274.1584404750506;
 Mon, 16 Mar 2020 17:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200316230223.242532-1-edumazet@google.com> <20200316230223.242532-4-edumazet@google.com>
 <20200316161635.5b2710d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200316161635.5b2710d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 Mar 2020 17:25:39 -0700
Message-ID: <CANn89iK1=8SwQZx3vf-MLYAvSh2L1tOLQHrbiDdE58POT-mvRw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net_sched: sch_fq: enable use of hrtimer slack
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 4:16 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 16 Mar 2020 16:02:23 -0700 Eric Dumazet wrote:
> > @@ -747,6 +750,7 @@ static const struct nla_policy fq_policy[TCA_FQ_MAX + 1] = {
>
> nit: since nothing has been added to fq_policy since we introduced
>      strict netlink checking please consider adding:
>
>         [TCA_FQ_UNSPEC] = { .strict_start_type = TCA_FQ_TIMER_SLACK },
>

Thanks for the hint, I will add this in v2.
