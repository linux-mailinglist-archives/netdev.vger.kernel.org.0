Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DA25F6707
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 14:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJFM67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 08:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiJFM6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 08:58:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F1631E;
        Thu,  6 Oct 2022 05:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCBDCB81FCF;
        Thu,  6 Oct 2022 12:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3080DC433C1;
        Thu,  6 Oct 2022 12:58:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jM72sEmp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665061112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cy+TvXeuBlQBpKZ85Gz71XfrwaBFdgj2EOkEjFq4oj0=;
        b=jM72sEmpr2WmU4lD5kxfUFDLgPwhfdQkvrJiCluULi4OY1o5sMNbSsUY1L1aQLNsaU7IbM
        UXwFGPiIiOMzVMfDkf93GRmdXaDFh+Qoa2WH5PO4HOsZTyh4aWKdhjrdkXF7qKB6CrheE4
        7t0K0MOBB+//oXNLBPHEpxlzzlaU0pU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 58f73b69 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 6 Oct 2022 12:58:32 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id l127so1909319vsc.3;
        Thu, 06 Oct 2022 05:58:31 -0700 (PDT)
X-Gm-Message-State: ACrzQf0LkLizrLAYvyllcPhPDqug5DCXgwyIBPZHyXNZVpfxSFhEsbc8
        vYl7cU87kbHk3bQ+ltIY/1ToKYkbbyASXTjaY0c=
X-Google-Smtp-Source: AMsMyM6bN/N0v77xkMIHRe+au6d89krdEiug+7xWjxwXgig3YnOZy/y7fPjRCz3uGFAZP0QEevNmHhO3PqUzQLRsK2M=
X-Received: by 2002:a05:6102:1481:b0:39a:67f5:3096 with SMTP id
 d1-20020a056102148100b0039a67f53096mr2254146vsv.70.1665061110855; Thu, 06 Oct
 2022 05:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20221005214844.2699-1-Jason@zx2c4.com> <202210052310.BF756EBEBE@keescook>
In-Reply-To: <202210052310.BF756EBEBE@keescook>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 6 Oct 2022 06:58:19 -0600
X-Gmail-Original-Message-ID: <CAHmME9pvW1SF5hfaE796KLmisbX2TK67F3xO6OKV2ZBiqvEeOg@mail.gmail.com>
Message-ID: <CAHmME9pvW1SF5hfaE796KLmisbX2TK67F3xO6OKV2ZBiqvEeOg@mail.gmail.com>
Subject: Re: [PATCH v1 0/5] treewide cleanup of random integer usage
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 6, 2022 at 12:15 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Oct 05, 2022 at 11:48:39PM +0200, Jason A. Donenfeld wrote:
> > I've CC'd get_maintainers.pl, which is a pretty big list. Probably some
> > portion of those are going to bounce, too, and everytime you reply to
>
> The real problem is that replies may not reach the vger lists:
>
> Subject: BOUNCE linux-kernel@vger.kernel.org: Header field too long (>8192)
>
> But the originals somehow ended up on lore?
>
> https://lore.kernel.org/lkml/20221005214844.2699-1-Jason@zx2c4.com/

Heh, those aren't quite the originals. Same message IDs, but I did
evil things to get them on there.

v2 coming shortly to rectify this mess.

Jason
