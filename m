Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6121D3DE1
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgENTsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727124AbgENTsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:48:06 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F12CC061A0C;
        Thu, 14 May 2020 12:48:06 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id j3so4859987ljg.8;
        Thu, 14 May 2020 12:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UM6g2a97Qr15ZVZrS+9k+t3FhiMgu6vYpKrUc29rMtc=;
        b=gqj8+3vMqSzbhYdeicKrT7ZL9dAspmfumIkEgUa5NVmAhKmTbHbTU0ne7xSspsTtvo
         QDNS6LhEzK/vTRFCD4R6TKn7jE8LsBUpGdlaJ59G56Q73lNA6howXV7jxH6z7V+UM/3b
         YK4gqhhcINO6LwRGjtl7MY6Jr75cNU/R6gESwRTs/0VlaNphJCMUWns9uvx1mBlqcHrK
         dDNHQYcPVqFGTi4w1phcg13+8+Zy+x60XO8mkM67q1/P+uFcPpZqZZMBbW/12lPn2Rxn
         Jk7RdLot9MKy/VIVDWOcfBZOvYzMHcrq0PgeGuHck6zmk3nzPe9rD4rWCx6ha9SaQBNm
         +jVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UM6g2a97Qr15ZVZrS+9k+t3FhiMgu6vYpKrUc29rMtc=;
        b=Ay3PKxmgPYWxuIM8cjSWVOXPYqYqKkOh6lEaxY9Dr2wDRutWuRUqCWdrf5simIjZe7
         IG2S6JN5VuQBt5yme3ZJu3RDrSHeu3PYmlg83oq8CjICfKql/IcYnc6WGcMCMCdAAubd
         wfqWRDDVVxAPaqMNDI8GOm7FM+smQ4QWPSfc6eMcCnCvFvUVxJpFN/hU5EX9bensRaEI
         a37u78Fplbl3EnroSGBbHAm/PB3uimJoBNjMW5dELUf6AUC7nPP6kUyrCnd+HQM2tySU
         SgIf9rB6iMgPx5ND9Kv3Pru6wv7IiedRbTW6Zo7P6N/fwXNaoQfGqGUw7OAOEpLMM1EN
         S7jQ==
X-Gm-Message-State: AOAM531aOK/BizGhl8mC+d5pz0CqgLcoaiDCx1TgEf7J+WJw6XQKr3eM
        lFltFSQiwubVlD/q3uhZvevhrhWUlI5fCXwGDtg=
X-Google-Smtp-Source: ABdhPJyMCv4AqK4iIfdpObzAoqu6HvSqELmU5tnvzFHwHgi+1VOiVItheZA5sLB4ESsu0low1fmDNzxv8sP6aCaJTY4=
X-Received: by 2002:a2e:9641:: with SMTP id z1mr3534986ljh.215.1589485684571;
 Thu, 14 May 2020 12:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200512174607.9630-1-anders.roxell@linaro.org>
 <CAADnVQK6cka9i_GGz3OcjaNiEQEZYwgCLsn-S_Bkm-OWPJZb_w@mail.gmail.com> <alpine.LRH.2.21.2005141243120.53197@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
In-Reply-To: <alpine.LRH.2.21.2005141243120.53197@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 May 2020 12:47:53 -0700
Message-ID: <CAADnVQJRsknY7+3zwXR-N4e6oC6E87Z32Msg4EXaM8iyB=R3qQ@mail.gmail.com>
Subject: Re: [PATCH] security: fix the default value of secid_to_secctx hook
To:     James Morris <jamorris@linux.microsoft.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 12:43 PM James Morris
<jamorris@linux.microsoft.com> wrote:
>
> On Wed, 13 May 2020, Alexei Starovoitov wrote:
>
> > James,
> >
> > since you took the previous similar patch are you going to pick this
> > one up as well?
> > Or we can route it via bpf tree to Linus asap.
>
> Routing via your tree is fine.

Perfect.
Applied to bpf tree. Thanks everyone.
