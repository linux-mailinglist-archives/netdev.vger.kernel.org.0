Return-Path: <netdev+bounces-10736-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C674F730065
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81401281459
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9ABBC151;
	Wed, 14 Jun 2023 13:47:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC20F7FC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:47:46 +0000 (UTC)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817FA2114;
	Wed, 14 Jun 2023 06:47:45 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-30aeee7c8a0so5064098f8f.1;
        Wed, 14 Jun 2023 06:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686750464; x=1689342464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AP5ftKd7wT4eV9g/VbxZ/AE3CMEtv7WQyJn0k4RoWns=;
        b=eCvv43moeko1ro/ZKiPW9DobGQEhEHREsOIW3VbfGIEAM/FrZaejQgnijxLEHJUCw8
         Ow0193V/VnxmVvNzTjwwCyUBQqbsbvkhzTUe5Ux4W1xMKKZ3DpCs4PMYcRptjSuONW+Y
         lykhkpFgTOHLRg6JsVN6TYHY58EsSLUkPyM5cOD6jTO94EjPJ3c0vc+xxpF2Z2KkhCGM
         xPcpbHP59HbBiKTf1D3vGMsa4EUTMGGaNBOqeRkBMqn4F2PfIiGBw4F1ZeKy6TpkDQhm
         Ic64O3aZ1ZFYFBGtDAZqt91rl54yJHrvb+PIdivgJop+uy0M7eha2l3AKpHdtLn5s7+K
         9gmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686750464; x=1689342464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AP5ftKd7wT4eV9g/VbxZ/AE3CMEtv7WQyJn0k4RoWns=;
        b=HjHnpOGQOWA8Oh8uXQIcmoYZ9+MkLOWIdDuuQMN9yv+T7G8n0G/cT0ttRwxG7xRKcb
         xWsSIIffBOHoWknF8wIo1FKQ7KiMUIES97XFf/79/OpqN1Z7cRPol+1LPxjNOFbCkRfV
         ZxW+EW+BwRJPIcOIkOKxU5huCtkyQctAgybyIJlyRDSQxdgMulmoN7d0aYYhMM4JN21i
         WeCUXDZpn/5iaOg2waDNpZAB16Le5Qfk9afFv0C0WLPol+9VioinESE2bGTRrsbDfbOw
         M2do91gXfR2KcuHs4UphdhZyECnfoJxuTdJdrL5FjGs200269o6BSX/4SLo4Thzu6vfr
         m4uA==
X-Gm-Message-State: AC+VfDw00+BxbWdLEQPrpbKSXdLGwdyLFhFVqd4a49MYU4nxkzKD6Qqw
	xwx5LvxfOQt94xddwxRUpVRTvu4Ea2e/x3jNEJ4=
X-Google-Smtp-Source: ACHHUZ6jxLLGneuKDGxLeZPAkGc72aGOLMzHb5scf00d9bCLr0d5pAAO7HUC96P6Zw68vDqVpOoTx1gqE3ixXHDxDlI=
X-Received: by 2002:a5d:5005:0:b0:30f:cb3a:2c46 with SMTP id
 e5-20020a5d5005000000b0030fcb3a2c46mr1591603wrt.20.1686750463416; Wed, 14 Jun
 2023 06:47:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230614134552.2108471-1-azeemshaikh38@gmail.com>
In-Reply-To: <20230614134552.2108471-1-azeemshaikh38@gmail.com>
From: Azeem Shaikh <azeemshaikh38@gmail.com>
Date: Wed, 14 Jun 2023 09:47:32 -0400
Message-ID: <CADmuW3XyYacFAX_S=mAkD8xB6a2P04kCCZHFr0EY45stt99exg@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: cfg80211: replace strlcpy() with strlscpy()
To: Kalle Valo <kvalo@kernel.org>
Cc: linux-hardening@vger.kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Please ignore this patch. I made a typo in the title. Resending.

On Wed, Jun 14, 2023 at 9:46=E2=80=AFAM Azeem Shaikh <azeemshaikh38@gmail.c=
om> wrote:
>
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
>
> Direct replacement is safe here since WIPHY_ASSIGN is only used by
> TRACE macros and the return values are ignored.
>
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcp=
y
> [2] https://github.com/KSPP/linux/issues/89
>
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> ---
> v1: https://lore.kernel.org/all/20230612232301.2572316-1-azeemshaikh38@gm=
ail.com/
>
> Changes from v1 - updated patch title.
>
>  net/wireless/trace.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/wireless/trace.h b/net/wireless/trace.h
> index 716a1fa70069..a00da3ebfed5 100644
> --- a/net/wireless/trace.h
> +++ b/net/wireless/trace.h
> @@ -22,7 +22,7 @@
>
>  #define MAXNAME                32
>  #define WIPHY_ENTRY    __array(char, wiphy_name, 32)
> -#define WIPHY_ASSIGN   strlcpy(__entry->wiphy_name, wiphy_name(wiphy), M=
AXNAME)
> +#define WIPHY_ASSIGN   strscpy(__entry->wiphy_name, wiphy_name(wiphy), M=
AXNAME)
>  #define WIPHY_PR_FMT   "%s"
>  #define WIPHY_PR_ARG   __entry->wiphy_name
>
> --
> 2.41.0.162.gfafddb0af9-goog
>
>

