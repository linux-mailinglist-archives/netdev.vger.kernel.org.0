Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D405890BC
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbiHCQo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiHCQo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:44:57 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5103841983
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 09:44:56 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gk3so20305849ejb.8
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 09:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=oiZPPs5MYI4/+W8yBMwCWKj6VS0spM9Blj9rVuT6y0o=;
        b=RSE84gDSPn39xr+1byZPyrJwh4O8nimo8zEb56V2vpcURL8cR/iKnRrj5KqE46OWG3
         0JgOT/61TRpBg4ovhC5wHfMEinnsqdEek0C6UqOArCWCF25O7lTJ9XofEXMVX/6sU++H
         JkOrPY9idXwhzAvQUNzMTWyybEgQodqSjd7/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=oiZPPs5MYI4/+W8yBMwCWKj6VS0spM9Blj9rVuT6y0o=;
        b=icXv9r+/hIWOoEHFKaCC7Ns3gsOLiNigAO0DC32ULHJQF/se4rtVMb1pMBZN03X4CP
         o67XfSPDHzURB76D/2URSbkwD+xdRiOZJesjz0OLNmV8g0GsGhRvzsbY2gDbVMhV6q+0
         kxjD9TrLXhq3AUmnf/CBUgQaSEyMdGOU/M6CeMF8O9R6yOFym8TIfYMglNGrE+l+gc9R
         UQAbo6Xr8ljkOi+zEFERb/bwV5e/baJT4oKxrMV2XBxBLKB/wrvtlRiwFWSBm5k2Edyd
         zUatuCogEsZ8qYbvv1A961DRGel/unPZEqKOtk0o5yVlUHdQpQyJ0CxdsNSBgxbl5ZOQ
         E8vw==
X-Gm-Message-State: AJIora/pk4vR1z/oOnN+dUkD2PuJaOqv9w7AVMn3030eByok2Vsh8bKq
        RSHXuDXNCRO8vqF5dfYQFNP7y+Ms66PcMMQL
X-Google-Smtp-Source: AGRyM1s8drcgIXLzfciVs1ArGAwbV8UcwHtECHB3sGi2aTooeTimQ9FMgSi34hOHtitAG5IoCehx5w==
X-Received: by 2002:a17:907:9813:b0:72f:2031:19b9 with SMTP id ji19-20020a170907981300b0072f203119b9mr21208499ejc.473.1659545094626;
        Wed, 03 Aug 2022 09:44:54 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id k5-20020a17090632c500b0073087f7dfe2sm3365498ejk.125.2022.08.03.09.44.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 09:44:54 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id bv3so8328494wrb.5
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 09:44:53 -0700 (PDT)
X-Received: by 2002:a05:6000:1a88:b0:21d:aa97:cb16 with SMTP id
 f8-20020a0560001a8800b0021daa97cb16mr16942311wry.97.1659545093700; Wed, 03
 Aug 2022 09:44:53 -0700 (PDT)
MIME-Version: 1.0
References: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
 <CAHk-=wjh91hcEix55tH7ydTLHbcg3hZ6SaqgeyVscbYz57crfQ@mail.gmail.com> <1bbb9374-c503-37c6-45d8-476a8b761d4a@kernel.dk>
In-Reply-To: <1bbb9374-c503-37c6-45d8-476a8b761d4a@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 3 Aug 2022 09:44:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=whxqSBtkvr4JijDBQ-yDrE91rFHt9D9b0jj=OMYL8mEsg@mail.gmail.com>
Message-ID: <CAHk-=whxqSBtkvr4JijDBQ-yDrE91rFHt9D9b0jj=OMYL8mEsg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring support for zerocopy send
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 9:39 AM Jens Axboe <axboe@kernel.dk> wrote:
>
>      If you look at the numbers Pavel posted, it's
> definitely firmly in benchmark land, but I do think the goals of
> breaking even with non zero-copy for realistic payload sizes is the real
> differentiator here.

Well, a big part of why I wrote the query email was exactly because I
haven't seen any numbers, and the pull request didn't have any links
to any.

So you say "the numbers Pavel posted" and I say "where?"

It would have been good to have had a link in the pull request (and
thus in the merge message).

               Linus
