Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A342215079
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 02:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgGFAXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 20:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgGFAXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 20:23:23 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E994CC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 17:23:22 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x9so31512366ila.3
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 17:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VpOZD5FSe6h+Qq52zkFsRZIlNV/n1rJ/M+V24KgEnhQ=;
        b=JaFbLlaZ/Q0b5cV0EY4PRhAdK/RLvj6h/0kIXSDEdndipcZ4Zl2wppXN2FIs54Blxu
         52/7sVAJLUYsUL6QrIkgvTkiUEXvnS3/fiKn9sZyx/4zmeeNnQ+Umht6LCLMLtwbZNp5
         pBZQc8HH/2gMUWCcGgcTWo1KaS82UNSFSqAHkgtHKf3fvwhroQFf1TOr886oPIDD6u78
         89b8iVdRVbfjRMEqU+QmwjzCQhbKDZxxjRL1YoTefBNK74S+pJFnHFF6iDc+Em2ixqSl
         pXy2wdYSFVGyO4rgVsx9D6MPiJ29Dr8NyYbTPiT3/VMQ1Tp86zwwrSd0mxIXx3o61y//
         iMPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VpOZD5FSe6h+Qq52zkFsRZIlNV/n1rJ/M+V24KgEnhQ=;
        b=FcH3HFkIeUPNA85PJ0nPZistbsjhqplNrduSsz8vQTOI3zzOZ/J5XGt/+cXnZuB9A+
         yLUBA25Qr1xxJF7eqCkEZogV6YqA6RfcKdjOqFqMRcdkmybwyl2wNqtQQBYZf2DAjob0
         hNil+UxKxBVtpxCUoIo9noSksNELb1V5mrvXyFeCZeVC9AFzkhJjIKKV1Ga5wIZbXw/B
         qd+YW+nR8a6LI4X2B4lYKBaaSbtLmra/awM0SghMtsnxNduglIHE8nQdbvkyNDWWuYEM
         tfD0hb87YyNJAI/XBkLboaNIQ9s7cgl1Xbcr6S2A1o21kRqUWlq1O7tBDcrEkbITRwW4
         8ewQ==
X-Gm-Message-State: AOAM532Yni0W2UTGhJnB4EO19lJZTPUHGtbvAvpUsZJtYBsnYqo90wh+
        rO02FNy2I1A9Wzd83nbmUTXVySnttKB+K5iuwpIuXGLI/XU=
X-Google-Smtp-Source: ABdhPJxy/aINlfZJJeDePWVHBPxg1xZCVsBNiDNr7CwPGHq92n8n30uG0eRM6CvgpJpteoSkXHqWoIMKmkQuGcDszzQ=
X-Received: by 2002:a05:6e02:147:: with SMTP id j7mr28031801ilr.22.1593995001985;
 Sun, 05 Jul 2020 17:23:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200701184719.8421-1-lariel@mellanox.com> <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
 <8ea64f66-8966-0f19-e329-1c0e5dc4d6d4@mellanox.com>
In-Reply-To: <8ea64f66-8966-0f19-e329-1c0e5dc4d6d4@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 5 Jul 2020 17:23:10 -0700
Message-ID: <CAM_iQpVR9XwvOfo-nznh6pmWV2FM8F_SaUikx9QpNt_GB0c6Qg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
To:     Ariel Levkovich <lariel@mellanox.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 5, 2020 at 10:26 AM Ariel Levkovich <lariel@mellanox.com> wrote:
> However I believe that from a concept point of view, using it is wrong.
>
> In my honest opinion, the concept here is to perform some calculation on
> the packet itself and its headers while the skb->hash field
>
> is the storage location of the calculation result (in SW).

With skbedit, you don't have to pass a value either, whatever you
pass to your act_hash, you can pass it to skbedit too. In your case,
it seems to be an algorithm name.

You can take a look at SKBEDIT_F_INHERITDSFIELD, it calculates
skb->priority from headers, not passed from user-space.


>
> Furthermore, looking forward to HW offload support, the HW devices will
> be offloading the hash calculation and
>
> not rewriting skb metadata fields. Therefore the action should be the
> hash, not skbedit.

Not sure if this makes sense, whatever your code under case
TCA_HASH_ALG_L4 can be just moved to skbedit. I don't see
how making it standalone could be different for HW offloading.


>
> Another thing that I can mention, which is kind of related to what I
> wrote above, is that for all existing skbedit supported fields,
>
> user typically provides a desired value of his choosing to set to a skb
> metadata field.

Again, no one forces this rule. Please feel free to adjust it for your needs.

Thanks.
