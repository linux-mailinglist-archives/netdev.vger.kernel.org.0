Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC2A2EF37A
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 14:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbhAHNwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 08:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbhAHNwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 08:52:36 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E33C0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 05:51:56 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id 81so9754417ioc.13
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 05:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=EpJA7gkIJUzVXht4HIVTYFTt7UZeuilXPsPqv9dHNgk=;
        b=HnJ4A4D35sfZbuwEisdNbEJM4X6sB3LX+J5qMxBSbRRlFOzhbiG9WsIhQfRx33H2C6
         ZZQNw4AckL6/D+f+eMQ2FYF82skrsLNjJ1wg2Y0/zs67hLLYOJmvgEw1mITcKQywHcy2
         wlmkEIAqRiAyWqIPrdozqyyXG0Fdqk1TvBLuZjVTTMOX+nDd+KXEW8iN79KGOpUzJ7Ht
         G8koDSG0Eoag/kYR7wheVRvKEdImZuB99BD4tHHw+JkdVyx8KQBI6h6jIL+55riPpgpP
         dR1Hy3K8HS5C9IDBt7XGWP6614vW8FN2bsqyiCnf0A1YzWR/xEC7XXvg+RyiTNjcMvih
         3tXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=EpJA7gkIJUzVXht4HIVTYFTt7UZeuilXPsPqv9dHNgk=;
        b=ZHFIfByMpCBG0Ojl/+tKPzd+zstLMoa5spl2yxdCO79oXStmu7iL6tTrv0FVQNpu2A
         /297/+Rv7Zclt8GtIWb0kMpoib8wqO0Z73dPEEWXQURVTO0FN8x34ThrMhQBVsDOPnY/
         ZNol5CT2hVHlwiLa5SA+DQiDT45Znxths4YWCU+GEwec9wjlUNb6QjXkVcrcVvT5yrJk
         9upH8DZyt32h5Oj9RJ/SEq6nP4rBxgE8RIrP8g0jPvzXWdy0piuiXaTXUyJ5MQ8QwPgh
         tFck2lzPDpnrW627QXTRhKLgy5k+8tqFgBf5onlTCP4/ciOEVI+DXgGcZcoXP8iDsCqf
         3VDA==
X-Gm-Message-State: AOAM530/lZXa9dtOQoFTUwdixx6HQV9V1Q8OioGcIX+zXqbbwwFFlsu6
        rhAejDRuT9LpGb8rraPS0s0remVsyqMPf1NFTmI=
X-Google-Smtp-Source: ABdhPJx+hV4ZTlSlo4LPZqWRNb4sVjriFTb13IpHNBKORzFeBkHP+7aYlUeM+1Ls18RrFmYojOBKziR53BlYb2P9hWI=
X-Received: by 2002:a5e:9b06:: with SMTP id j6mr5399341iok.171.1610113915372;
 Fri, 08 Jan 2021 05:51:55 -0800 (PST)
MIME-Version: 1.0
References: <CA+icZUXzW3RTyr5M_r-YYBB_k7Yw_JnurwPV5o0xGNpn7QPgRw@mail.gmail.com>
 <6d9a041f-858e-2426-67a9-4e15acd06a95@gmail.com> <CA+icZUW+v5ZHq4FGt7JPyGOL7y7wUrw1N9BHtiuE-EmwqQrcQw@mail.gmail.com>
 <CANn89iJvw55jeWDVzyfNewr-=pXiEwCkG=c5eu6j8EeiD=PN4g@mail.gmail.com> <CA+icZUXixAGnFYXn9NC2+QgU+gYdwVQv=pkndaBnbz8V0LBKiw@mail.gmail.com>
In-Reply-To: <CA+icZUXixAGnFYXn9NC2+QgU+gYdwVQv=pkndaBnbz8V0LBKiw@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 8 Jan 2021 14:51:43 +0100
Message-ID: <CA+icZUW5B4X-SMFCDfOdRQJ7bFsZXwL4QhDdtKQXA3iO8LjpgA@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000f96d2f05b863db0b"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000f96d2f05b863db0b
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 8, 2021 at 2:08 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Wed, Aug 12, 2020 at 6:25 PM Eric Dumazet <edumazet@google.com> wrote:
>
> > > Also, I tried the diff for tcp_conn_request...
> > > With removing the call to prandom_u32() not useful for
> > > prandom_u32/tracing via perf.
> >
> > I am planning to send the TCP patch once net-next is open. (probably next week)
>
> Ping.
>
> What is the status of this?
>

I am attaching the updated diff against latest Linus Git.

- Sedat -

--000000000000f96d2f05b863db0b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="random32-prandom_u32-tcp_conn_request-edumazet.diff"
Content-Disposition: attachment; 
	filename="random32-prandom_u32-tcp_conn_request-edumazet.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kjoc8n210>
X-Attachment-Id: f_kjoc8n210

ZGlmZiAtLWdpdCBhL25ldC9pcHY0L3RjcF9pbnB1dC5jIGIvbmV0L2lwdjQvdGNwX2lucHV0LmMK
aW5kZXggYzdlMTZiMGVkNzkxLi45NWVkNDlkZTQ2MzUgMTAwNjQ0Ci0tLSBhL25ldC9pcHY0L3Rj
cF9pbnB1dC5jCisrKyBiL25ldC9pcHY0L3RjcF9pbnB1dC5jCkBAIC02ODUyLDEwICs2ODUyLDEy
IEBAIGludCB0Y3BfY29ubl9yZXF1ZXN0KHN0cnVjdCByZXF1ZXN0X3NvY2tfb3BzICpyc2tfb3Bz
LAogCQlpc24gPSBjb29raWVfaW5pdF9zZXF1ZW5jZShhZl9vcHMsIHNrLCBza2IsICZyZXEtPm1z
cyk7CiAJCWlmICghdG1wX29wdC50c3RhbXBfb2spCiAJCQlpbmV0X3JzayhyZXEpLT5lY25fb2sg
PSAwOworCQl0Y3BfcnNrKHJlcSktPnR4aGFzaCA9IHNrYi0+aGFzaCA/OiAxOworCX0gZWxzZSB7
CisJCXRjcF9yc2socmVxKS0+dHhoYXNoID0gbmV0X3R4X3JuZGhhc2goKTsKIAl9CiAKIAl0Y3Bf
cnNrKHJlcSktPnNudF9pc24gPSBpc247Ci0JdGNwX3JzayhyZXEpLT50eGhhc2ggPSBuZXRfdHhf
cm5kaGFzaCgpOwogCXRjcF9yc2socmVxKS0+c3luX3RvcyA9IFRDUF9TS0JfQ0Ioc2tiKS0+aXBf
ZHNmaWVsZDsKIAl0Y3Bfb3BlbnJlcV9pbml0X3J3aW4ocmVxLCBzaywgZHN0KTsKIAlza19yeF9x
dWV1ZV9zZXQocmVxX3RvX3NrKHJlcSksIHNrYik7Cg==
--000000000000f96d2f05b863db0b--
