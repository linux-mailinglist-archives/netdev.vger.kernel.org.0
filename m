Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDDC1B96BE
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 07:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgD0FqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 01:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726178AbgD0FqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 01:46:24 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49775C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 22:46:24 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k13so18974987wrw.7
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 22:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8t+nRhss3LhfdZGRco3w+9CYt5/sZeg6LCpHr+pcA50=;
        b=RqYXC2EBZo+k+IF+30bHpCqR7RdLiYhPpLZiQuDGVDZqHNSASxaiajHjct6cWTcN3a
         FTfFn/SKXoX8gseyAT5+GvG+lFD2NPjr4oERW02UyMvxJIl/pxtQrUVfP8czFDUQQf31
         6zDq635I6MvfFUKVwHkZ8xYv1WXuh5Gnf/GlHoQlYwqcGF/1tMu9p4EXUB6yVKuur7CE
         Yhp1CGCyA6fLAxYyjGxAMrRbkySMvcov712vfWMlXdRKEISCUfY4MVx+uEqHi4/Fegs4
         H4S48Ib4PO3hmO0vB57nneFIA6oevQuBbMhoQc+3uJH/EDzw97rzkTGwHXXq1zk33/Rl
         IZlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8t+nRhss3LhfdZGRco3w+9CYt5/sZeg6LCpHr+pcA50=;
        b=iYbv9UJV7Id6AppkWqhi0bUDgBNAh2rKCd3Y6WjIAdV4fS2tcULCwuRJqSiDaZlDQ6
         dByb41hS1HtoC0GWrAZZi4W6OGMsmfwBiFtBat0XqLNYpDA9SxziNGTYzeoJY2LZaVNF
         sMfFoBrX2EUW3ES4BHJf5mit5sY0eG6YalmXRr45gGqAzaM15ZMBjeKhZXZ7kvvML9vz
         gTTLAWH7lnVsXspogr6ciR4a0vBAAk4Ze1dBhQlyQ2CAcxYFsqytz0hSc/gCsgf3jPyh
         h0gof7Z9SGZxCjLqZkDEcmX8TWfJP38QZdh1uQ/U+LLy0X+hHXytHo87dIHPmMMNghW5
         900A==
X-Gm-Message-State: AGi0PubPPdvIj8Fc5VScPXrXCcE3lVTFMnb0RIt44beBeaC4dqN9PPG3
        cxnTxtGOgOm+f+GP28RprwT9bZ4eBC94dWwqskU=
X-Google-Smtp-Source: APiQypKTFFgabZve+cupi7a0m2D9n16zbqcQ9u06JJHRc+O8Tn8yhH8a0DoECDjex/qp4qDy02sujxuE7hfW/QY+WPQ=
X-Received: by 2002:a5d:6107:: with SMTP id v7mr24195424wrt.270.1587966382998;
 Sun, 26 Apr 2020 22:46:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1581676056.git.lucien.xin@gmail.com> <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan> <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
 <20200214162104.04e0bb71@hermes.lan> <CADvbK_eSiGXuZqHAdQTJugLa7mNUkuQTDmcuVYMHO=1VB+Cs8w@mail.gmail.com>
 <793b8ff4-c04a-f962-f54f-3eae87a42963@gmail.com> <CADvbK_fOfEC0kG8wY_xbg_Yj4t=Y1oRKxo4h5CsYxN6Keo9YBQ@mail.gmail.com>
 <d0ec991a-77fc-84dd-b4cc-9ae649f7a0ac@gmail.com> <20200217130255.06644553@hermes.lan>
 <CADvbK_c4=FesEqfjLxtCf712e3_1aLJYv9ebkomWYs+J=vcLpg@mail.gmail.com>
 <CADvbK_fYTaCYgyiMog4RohJxYqp=B+HAj1H8aVKuEp6gPCPNXA@mail.gmail.com>
 <edcf3540-da91-d7af-12ff-8ca7d708bd3a@gmail.com> <fbd384a0-2f7e-3e87-0e8a-3291e1f15aa5@gmail.com>
In-Reply-To: <fbd384a0-2f7e-3e87-0e8a-3291e1f15aa5@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 27 Apr 2020 13:51:35 +0800
Message-ID: <CADvbK_dSxU-ooUt47T3s5Ao606M_7C8mKUnh5eL60ZdeOvh4UA@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 2:29 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/19/20 4:28 PM, David Ahern wrote:
> > On 4/19/20 2:39 AM, Xin Long wrote:
> >> This patchset is in "deferred" status for a long time.
> >> What should we do about this one?
> >> should I improve something then repost or the lastest one will be fine.
> >
> > I am fine with this set as is; Stephen had some concerns.
> >
>
> Please re-send the patches.
OK, will post v4. thanks.
