Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2724E8D8D
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 07:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbiC1Ftp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 01:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbiC1Fto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 01:49:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C3950078;
        Sun, 27 Mar 2022 22:48:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6388B80E48;
        Mon, 28 Mar 2022 05:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF70C340F0;
        Mon, 28 Mar 2022 05:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648446481;
        bh=7WvjipyGg6RsfucDyVPM5ZDCMQ7EW5OtT8Dh7ipOWPw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IF2sIOU2jtJMxOIsuPM+6fW5O0Z0j++wP7ng9+hOlOYtjoqfxlcdG9CEkR1x0mml0
         lnn7+EqcftVG33r+qMfQFOPl0B7zIX1tQ+mAHREfw/19fdYElXMa8SFUsJwEW8QpKk
         eX84n5PZAvm3ZdiIbESKll2qdycWZClAR/sIXfCmXk4Hf509Mi8INzCV/P53qk5Suj
         G3xnb3lGMgu4GD8tW111FxcBWWbp1kp8s/zTOEeQex7SqTI7oK6XEAbZ4ww3CbI8RX
         +OlRFTSBA2WwWz9tIt9SwRs2PgNpGkxXoPjKA54CpYR7pkfsE3Lw13BkFBEKsCXyb2
         0MaJqyQ6JXyBQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] iwlwifi: fw: Replace zero-length arrays with flexible-array members
References: <20220216195015.GA904148@embeddedor>
        <202202161235.2FB20E6A5@keescook>
        <20220326003843.GA2602091@embeddedor>
Date:   Mon, 28 Mar 2022 08:47:55 +0300
In-Reply-To: <20220326003843.GA2602091@embeddedor> (Gustavo A. R. Silva's
        message of "Fri, 25 Mar 2022 19:38:43 -0500")
Message-ID: <871qym1vck.fsf@kernel.org>
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

> On Wed, Feb 16, 2022 at 12:35:14PM -0800, Kees Cook wrote:
>> On Wed, Feb 16, 2022 at 01:50:15PM -0600, Gustavo A. R. Silva wrote:
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

Like we have discussed before, please don't take any wireless patches to
your tree. The conflicts just cause more work of us.

I assigned this patch to me on patchwork and I'm planning to take it to
wireless-next once it opens. Luca, ack?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
