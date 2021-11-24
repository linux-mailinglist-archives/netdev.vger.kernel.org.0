Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB34145C784
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356682AbhKXOiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350936AbhKXOiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 09:38:05 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B7EC1E9D8C;
        Wed, 24 Nov 2021 05:33:50 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso4357929otf.0;
        Wed, 24 Nov 2021 05:33:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=091FqIUggUob/ZEgOD1UGmSVx8eqHMlVt+VyvTQhn6A=;
        b=5alA6/f+UhETRaXz3Ziw0Mbfo79WBHXEc9krzNgtd01IqyNVmRhY/0lZB/P6eLDJQW
         eoZjcdR6rFE3pNseQfZ/D4cF20VQuAdK9siwpsGXViPdZGdSZj5I7hCVl20qAoKihTGU
         9Y2cOZqzkmtsFqHF2VURZQn4cJm3wj70y+AFGjSq6Sge2gQczR5OFVvJJdJ6IFzUWzxq
         IVi22hsX9WOChk0ReYeUTGW+sRirou0ll7bhp3yZtfxQJtiPER1ed37a6y9j3340xgjb
         ErontMp+30VXcxUe44s8V4vCUHh05Mex6eQ39n7jGM/fHZcBKylMk53BPCN8cbtkTZqx
         +ZjA==
X-Gm-Message-State: AOAM531TyN2EynZbSlLf7LBYl1nok7NN7r4Hxj4bx77v+XJxg7AIKRGn
        uytjIbBVqRFhWWLNCZpA+SzEgd93DpVRF3YhMW0=
X-Google-Smtp-Source: ABdhPJzQoNI/Fsb1RYaYMIo8ITBU8mCa/gSsaWPVLoUcuICuMNXnffh1kRK/Zt6rxw8a35LfxbFQ+4vJZ0v59kljSMQ=
X-Received: by 2002:a05:6830:348f:: with SMTP id c15mr13170421otu.254.1637760829265;
 Wed, 24 Nov 2021 05:33:49 -0800 (PST)
MIME-Version: 1.0
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-13-keescook@chromium.org> <CAJZ5v0iS3qMgdab1S-NzGfeLLXV=S6p5Qx8AaqJ50rsUngS=LA@mail.gmail.com>
 <c5d1ee1f3b59bf18591a164c185650c77ec8aba7.camel@linux.intel.com>
In-Reply-To: <c5d1ee1f3b59bf18591a164c185650c77ec8aba7.camel@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 24 Nov 2021 14:33:38 +0100
Message-ID: <CAJZ5v0i61F9SpwfER8o5J_Kf=J9dJUv-qd+bG9hcL42X2eMRtw@mail.gmail.com>
Subject: Re: [PATCH v2 12/63] thermal: intel: int340x_thermal: Use
 struct_group() for memcpy() region
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Kees Cook <keescook@chromium.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 12:53 AM Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> On Tue, 2021-11-23 at 14:19 +0100, Rafael J. Wysocki wrote:
> > On Wed, Aug 18, 2021 at 8:08 AM Kees Cook <keescook@chromium.org>
> > wrote:
> > >
> > > In preparation for FORTIFY_SOURCE performing compile-time and run-
> > > time
> > > field bounds checking for memcpy(), avoid intentionally writing
> > > across
> > > neighboring fields.
> > >
> > > Use struct_group() in struct art around members weight, and ac[0-
> > > 9]_max,
> > > so they can be referenced together. This will allow memcpy() and
> > > sizeof()
> > > to more easily reason about sizes, improve readability, and avoid
> > > future
> > > warnings about writing beyond the end of weight.
> > >
> > > "pahole" shows no size nor member offset changes to struct art.
> > > "objdump -d" shows no meaningful object code changes (i.e. only
> > > source
> > > line number induced differences).
> > >
> > > Cc: Zhang Rui <rui.zhang@intel.com>
> > > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > > Cc: Amit Kucheria <amitk@kernel.org>
> > > Cc: linux-pm@vger.kernel.org
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> >
> > Rui, Srinivas, any comments here?
> Looks good.
> Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

Applied as 5.17 material, thank you!
