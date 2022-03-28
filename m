Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006B94E8D91
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 07:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238181AbiC1FuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 01:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbiC1FuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 01:50:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B582412A94;
        Sun, 27 Mar 2022 22:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 314846109A;
        Mon, 28 Mar 2022 05:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C6AC340F0;
        Mon, 28 Mar 2022 05:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648446508;
        bh=LQyxRKXMf0S7uzGj5hH8/MvLm79Jjubtz0m602VOG1Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=r5X52gFgn7hx5pBW0q/WF5RxNd/bFfG97hhie/kXFd6DHGiu014p/NEc7mw71W4xZ
         JJpY+PSzyAACVYpBT6O0ZzdFiKjp6QJrXwz+v0jZ7x8AJTX6/l/NDBnYq1sqlVgnP4
         TC9jttkCIwV4kZjwHq751BRBgg7/+OxOYMBKlQ/1/VEqBv9F3R4vDNzdzejBiC9izJ
         MwyCxqyS/J6At+JIUj9cKkOJws2Airt7fxk70wDV4zRR3FrKmDl6N3EgrhD7z/mJZs
         ndT9+LTH0vJ2Dvn9wSN5uSjcwCDucJNGGZLWHffCIeuhJtuxVUhgOof8UH0DuiljxA
         Bgz69gFqxOmfw==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] iwlwifi: mei: Replace zero-length array with flexible-array member
References: <20220216195030.GA904170@embeddedor>
        <202202161235.F3A134A9@keescook> <20220326004137.GB2602091@embeddedor>
Date:   Mon, 28 Mar 2022 08:48:24 +0300
In-Reply-To: <20220326004137.GB2602091@embeddedor> (Gustavo A. R. Silva's
        message of "Fri, 25 Mar 2022 19:41:37 -0500")
Message-ID: <87wngezkyf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> writes:

> On Wed, Feb 16, 2022 at 12:35:22PM -0800, Kees Cook wrote:
>> On Wed, Feb 16, 2022 at 01:50:30PM -0600, Gustavo A. R. Silva wrote:
>> > There is a regular need in the kernel to provide a way to declare
>> > having a dynamically sized set of trailing elements in a structure.
>> > Kernel code should always use =E2=80=9Cflexible array members=E2=80=9D=
[1] for these
>> > cases. The older style of one-element or zero-length arrays should
>> > no longer be used[2].
>> >=20
>> > [1] https://en.wikipedia.org/wiki/Flexible_array_member
>> > [2]
>> > https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-len=
gth-and-one-element-arrays
>> >=20
>> > Link: https://github.com/KSPP/linux/issues/78
>> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>=20
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> Hi all,
>
> Friendly ping: can someone take this, please?
>
> ...I can take this in my -next tree in the meantime.

I'll take this. Luca, ack?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
