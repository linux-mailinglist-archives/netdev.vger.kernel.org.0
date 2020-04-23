Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A481B53F2
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgDWFIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725562AbgDWFIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:08:40 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDB0C03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 22:08:39 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u6so4811431ljl.6
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 22:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9BVyp7v+7JNNnPWd2XprNpHBALMJvmY4oS+xcvJkz+8=;
        b=nSvnI+9RdkBuZvXzcrujqdE+s8EVInUiPc0ZGizFjORCoHaaTIVsJMCUxjcJiRiflE
         f6GZebaPPg9bcqFpo3lqhJj9d525aQGd9BVTJvQb4Z5d7xEtDVKPmFRiuDQaZclpzGzW
         Mg24IruyWgku9B9oxyScxUNO8qB1KLQR/s2Xt6OmubfWZ3QUV6GKW70QAgczes+7Z8CT
         xqf0GU+290xiqR6gYCsHudYYAjrkZytQpXL15Gm+zwOAwcceA23jtW0eJmu8IMnohh8r
         fh1KOh3pwegGQsID+TFJASjlBPIaldIQeYr16ATjzjXhJgSxSPwC2A3Z3j6OYMJmH27m
         Ozhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9BVyp7v+7JNNnPWd2XprNpHBALMJvmY4oS+xcvJkz+8=;
        b=m3sFTynMCSj3SFqWEustd8R+en/UGF7a0Ue17woPWciN5McVjUGh13IlSPgPtxtDtR
         0OA0ub3oWVk4XFBYRZigDazljxDIzb0BFrVMwxypnjvjsOT+VduZnvAqJBEphHk3E1KH
         NBdgTMtdByPyFeRIqp6r8A/2y2VqIlqDJmonauidgmt61pJvqBshdoYWjTmNzyw00wIj
         Q988UfYikIMSjQ6gmAVlINJzxTLtwNI2ypoYIo1x3ZaI2DlhLCpEQ3PCnJC1O5SpC4mu
         agieA9iIvI+Xo4IIz+DRiCOi//LXywzfk/+7qE0wSpji23GBhigV4wJmoaBpXCw643EG
         4E0g==
X-Gm-Message-State: AGi0Pua/mJPI/jvHR88TB02YGiRKoAVmVESwcTAgE6sCr+cM9jVCixt5
        8MPQoYw5OG419K4HWIuuZfQgCqMqqHBH4HY5/3g=
X-Google-Smtp-Source: APiQypKyEeznKjIqfdbwxg23UkfzCN5TEXkXpS32ecZVIaoCoutdw5ZfY2uw/2whob8UCFBBPkatQkUwGBNJEYdk/GA=
X-Received: by 2002:a2e:b80b:: with SMTP id u11mr1263630ljo.212.1587618518100;
 Wed, 22 Apr 2020 22:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200420161843.46606-1-dsahern@kernel.org> <20200420162715.GA91440@rdna-mbp>
In-Reply-To: <20200420162715.GA91440@rdna-mbp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Apr 2020 22:08:26 -0700
Message-ID: <CAADnVQ+QAo--54s1fOrbA4TLvc_qa5+z4rs+MPZiQE8Vhj9+YQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: Only check mode flags in get_xdp_id
To:     Andrey Ignatov <rdna@fb.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 9:27 AM Andrey Ignatov <rdna@fb.com> wrote:
>
> David Ahern <dsahern@kernel.org> [Mon, 2020-04-20 09:18 -0700]:
> > From: David Ahern <dsahern@gmail.com>
> >
> > The commit in the Fixes tag changed get_xdp_id to only return prog_id
> > if flags is 0, but there are other XDP flags than the modes - e.g.,
> > XDP_FLAGS_UPDATE_IF_NOEXIST. Since the intention was only to look at
> > MODE flags, clear other ones before checking if flags is 0.
> >
> > Fixes: f07cbad29741 ("libbpf: Fix bpf_get_link_xdp_id flags handling")
> > Signed-off-by: David Ahern <dsahern@gmail.com>
> > Cc: Andrey Ignatov <rdna@fb.com>
>
> Makes sense. Thanks.
>
> Acked-by: Andrey Ignatov <rdna@fb.com>

Applied. Thanks
