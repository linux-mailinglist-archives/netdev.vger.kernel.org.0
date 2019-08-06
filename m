Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECFB83536
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 17:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733014AbfHFP1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 11:27:38 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34485 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730177AbfHFP1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 11:27:38 -0400
Received: by mail-lf1-f67.google.com with SMTP id b29so54259054lfq.1
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 08:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yr6wTIW9AZHT4v1yCkb9IVo1Y7SBeHK4zcIIvimdZtI=;
        b=G2hwEOkCh5El/euSGyWfI68jU8DiAxG0l2VpMDHFEOerPTtqOYDVienMYX1PFwl7XP
         jdWtrDorW83oWnUj4KD8nWaf+/fvWuyaRSMMsC0KweUWWnH1sU53WEDMUST95ZcT9ffI
         QNoApZTD5R+Gg3Wy7G5LV7JtCMTJaYAFp1+LblBz+r2iXFFiF2EU6ZZY64BsKSILNxZQ
         H8iujVCBYeKO7Kn6z55cjIcibFoXzro9SLimYh9vRtt5WxnSWN0FtYZNDAEiYbUsDujO
         AUf9r9KzbvZPyYo/lTRLqqKWFqzUxyYRB97qKYrjoatUb/CCGfgBq+LdrJuWIR90I3hR
         7zcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yr6wTIW9AZHT4v1yCkb9IVo1Y7SBeHK4zcIIvimdZtI=;
        b=D8YSOtHeH4cFcqiw4sxLfNP1hLQ7SLIz8Ii9M0DEQuJD/FKRaPxgWEkqN1h87pstCU
         3yDlbxMJxRdfGrX4lfRjYCGTMDq2J7dfYwsh2CUHezY0wmsoPJvLXJ1oCtD+jufclf6Z
         9uOvj5F4qZc1wxILUCEVnGaFxY+xibJModFpamB6UYFZ3tYc7j66Dss45gatGxRttpoa
         AnNrQmEDaqPbAsHVnADyHHN03t6GxkzqL7AKdFPlu/PQdU7DfvU5GtxzTApxjirYt8wJ
         xUtXCxws88YztPIVo64uANPdjcD6XuBxvBeIBsXNpiCgaTFPxXs6f4Yn+G2dpUU1+632
         MJUw==
X-Gm-Message-State: APjAAAU84Eo5P2gTaRBXuJHpqamvdkbChbEalaDZFL/2p7CFfx3mJxBg
        H49WZctDO0r0pFEZkUTI4P0ndmg+4pzAeUH8MPI=
X-Google-Smtp-Source: APXvYqxF6yh4Eakz2aJALhEBKrXOVLAGDdKV8aHOfcgRWOLKyDKd4TSfMeHg5rfzFSV9+grmyhfCqAN4mb1sOPk0RU0=
X-Received: by 2002:a19:ca4b:: with SMTP id h11mr2724800lfj.162.1565105256011;
 Tue, 06 Aug 2019 08:27:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190805001541.8096-1-peter@lekensteyn.nl> <20190805152936.GE4544@mini-arch>
 <20190805120649.421211da@cakuba.netronome.com> <20190805235449.GA8088@al> <f0e5683b-ea6c-4966-6785-f154697f76f1@netronome.com>
In-Reply-To: <f0e5683b-ea6c-4966-6785-f154697f76f1@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Aug 2019 08:27:24 -0700
Message-ID: <CAADnVQL=qhaM9DC7=Bic7ASb0djy9AGtq9L28yM89PpNo0twHw@mail.gmail.com>
Subject: Re: [PATCH] tools: bpftool: fix reading from /proc/config.gz
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Peter Wu <peter@lekensteyn.nl>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 2:36 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> >>>  {
> >>> -   size_t line_n = 0, optlen = strlen(option);
> >>> -   char *res, *strval, *line = NULL;
> >>> -   ssize_t n;
> >>> +   char *sep;
> >>> +   ssize_t linelen;
> >>
> >> Please order the declarations in reverse-Christmas tree style.
> >
> > Does this refer to the type, name, or full line length? I did not find
> > this in CodingStyle, the closest I could get is:
> > https://lore.kernel.org/patchwork/patch/732076/
> >
> > I will assume the line length for now.
>
> I am unsure this is in the CodingStyle, but fairly certain that this is
> a convention for at least network-related code. And yes, as I understand
> it refers to the length of the line.

Let's not over focus on this.
It's a preference, but not a strong requirement.
There are plenty of cases where it shouldn't be followed.
Like logical grouping of variables take precedence of xmas tree.
