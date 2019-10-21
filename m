Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22085DE52D
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 09:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfJUHRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 03:17:55 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:46671 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfJUHRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 03:17:55 -0400
Received: by mail-yw1-f65.google.com with SMTP id l64so4528132ywe.13
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 00:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RBIYORf0syka+WuaqQ4HNycL5g+DlxcP+y84DLNPIoY=;
        b=taKpaMyUTgeeDD972MIZjt3FUsoJpy8NnRcAkW9WJac6tT7IoZAxc6ydaNDtF41Eew
         2mPV8OnqnvXQOOvW/lR4CgP4GR9FaZSLQqPAALdWBbv5c4qvbIUWTC/KFyihXK8WT3Vf
         AsWJBBZe4BaFpr+oJPcGMSXIkYUKtKIcltDw7DN2vrgpJb+Y2lEzcgLndvzlHFHyEDN8
         8AVIonRqFKHxwj4AJsGEB5HQ54LYQsTa0e+MoNvZDkxqfcSJy6r1xwX+pe3IVXgZK8H9
         9enbs6a2QciXfhrKorhD/o5QbabF/E1weLPWjzhPQsqMic84xLGaF8ecl3o1jxXD3hNc
         yzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RBIYORf0syka+WuaqQ4HNycL5g+DlxcP+y84DLNPIoY=;
        b=YsBaL/VnGkT1CjqCWWWbwhl/1xBMSViWSRbsp02vLOuSUhuK568TBJUqOO7FueahC2
         YzdQR1gvH2pz782xts+d5iejx+3AFMUR1gGhYHlcttvo1P10q0vgHjlX6evji6St9AFH
         qEuL2rVl1qYxFdz6yjsKhGoRg+2ndQlOJMgVaXMHo3WhdqN9gSzwX3kUxOeoYJtzCULi
         qNkn+n8JGfPCLyVS233PDXgfkjSygE98EYQf2Ut6wDgmitvyTT6UZz7tzCtzYUg8+Zmj
         R5LZBoEl9xzdfZZ6PsVoXyUTlxQDABE+1CiQMzuBavh8ZV12DapEAwnL4OKXH0/Zsm0G
         kO5g==
X-Gm-Message-State: APjAAAXNUYF4+IPjbPEmy7PrY0mVENvAzMGdJavbvv6B0SBxyTi3SOC6
        3PYDQf+qkF4QHDek0G1TdI6m1piWd+0wg1wy3EgnGAluC37BbQ==
X-Google-Smtp-Source: APXvYqwJvUe2t2v+8kA1cTLWwj29O/8DPe0M9xioQFQffRpQ98JKhshAxgzFHaC+UKPXmhjH1OLU6/ATKy7RV42RIUA=
X-Received: by 2002:a81:4e0d:: with SMTP id c13mr15066096ywb.52.1571642272488;
 Mon, 21 Oct 2019 00:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com> <20191017182121.103569-2-zenczykowski@gmail.com>
 <20191021063122.GC27784@unicorn.suse.cz>
In-Reply-To: <20191021063122.GC27784@unicorn.suse.cz>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Mon, 21 Oct 2019 00:17:41 -0700
Message-ID: <CANP3RGfJJUEm31Qy66et+BWxE40GsaN-XSrtw23rqWgw6CuW1g@mail.gmail.com>
Subject: Re: [PATCH 02/33] fix unused parameter warnings in do_version() and show_usage()
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Considering how frequent this pattern (a callback where not all
> instances use all parameters) is, maybe we could consider disabling the
> warning with -Wno-unused-parameter instead of marking all places where
> it is issued.

Once you fix it... it stays fixed.  There's no cost to carrying around
the extra annotation.
And the warning still finds other places where you're doing it wrong.
