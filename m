Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB366BF2B4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjCQUg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCQUgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:36:20 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B36743915
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:36:19 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z21so25041460edb.4
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679085377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AqjxzeWs79iOMWhYJn3jT4Jg8VZgXU4x4MtnJEvi6pI=;
        b=XWtsaWsJtWw+XxYO1x6tysrs8PjMryT+4I5wAjjJB0h9PCXoQvPFzQxoFQNYiAm3N+
         aEbrOjYHOpFL73gjQmscELsDGjbRrFQYnUu+ehiBn3MjgaRgg4VutlrMOznvZnDpXT9q
         xU+VdNs4hS4VsUxF2nzf2n5Ucc/pcEGJvJIMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679085377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AqjxzeWs79iOMWhYJn3jT4Jg8VZgXU4x4MtnJEvi6pI=;
        b=HEGiWSkNy+YQQZlUeTlsxwvtoA93kJq4WsEL4/+SnE7cG10b90+fg0dsxT/aYLVAjR
         mmvmP6MZvv+rJjLN86QFQrolzJwXp7jqtS3ijS0SFip0VbEWGUIb3ZaRCZMDISjKd5SG
         xTAHmBWvoK5KvojmSxHHBnojBoJGi9rS/A5QLtB/HXHm+nGVlrODZJEl//WjNIzGccgt
         S7wrkpEJFCUgpfTNCUWUqRuaZs3XDES0AYJqvwsBoVFuYxCGRNq2oYfrx6CgS5+oBJQW
         cPFiZgRXO7D6PVMdRmgzWpaxtfrN1WP7T9s1AhueEFdT5z84XDZs2S+QMhiueLBV+8VN
         Gnmg==
X-Gm-Message-State: AO0yUKVWC4vfNu/jxMLqxTW29Kr1kKMx92b+DA8LayXF0iS62qAsZXd/
        cWhPZD9FsPpb8GuKUeCbd3L2/sqTLXNoaaXRYFTNKQ==
X-Google-Smtp-Source: AK7set9cMFZM/zgrhs1oiIX35HuTTPq/MUoWo/yfRXtIxdf10y58ASoW5Ne3tFYMtkDIctwf42yrsg==
X-Received: by 2002:a17:907:381:b0:88f:9c29:d232 with SMTP id ss1-20020a170907038100b0088f9c29d232mr622200ejb.57.1679085377367;
        Fri, 17 Mar 2023 13:36:17 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id yj8-20020a170907708800b00930170bc292sm1350596ejb.22.2023.03.17.13.36.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 13:36:16 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id o12so24943281edb.9
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:36:16 -0700 (PDT)
X-Received: by 2002:a17:906:9615:b0:931:2bcd:ee00 with SMTP id
 s21-20020a170906961500b009312bcdee00mr303770ejx.15.1679085376150; Fri, 17 Mar
 2023 13:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230317202922.2240017-1-kuba@kernel.org>
In-Reply-To: <20230317202922.2240017-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 17 Mar 2023 13:35:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjJxtMDPoFzuh8CfzcDbrKwvCYFXrvaEe6=e2syr7TwoQ@mail.gmail.com>
Message-ID: <CAHk-=wjJxtMDPoFzuh8CfzcDbrKwvCYFXrvaEe6=e2syr7TwoQ@mail.gmail.com>
Subject: Re: [PULL v2] Networking for v6.3-rc3
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 1:29=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> Here we go again..

Well, this time you're missing the diffstat and shortlog....

Other than that it looks fine ;)

I've pulled it, because the diffstat I get is within the expected size
(ie "slightly bigger than the v1 diffstat that was missing some
stuff"), and the top commit matches what you claim it should be.

But a bit more care would have been appreciated.

              Linus
