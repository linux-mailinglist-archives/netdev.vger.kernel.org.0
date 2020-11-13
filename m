Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576682B243C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgKMTGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgKMTGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 14:06:14 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE69C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 11:06:14 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id t13so9428685ilp.2
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 11:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b3kuVxaxl2HPF+2E83j0paQ6SkzBU2CrBRMXSA3lAwE=;
        b=DCLBEJi+8ioiDlcqnjVW7OJL8g82xXWkUdj29h2HPiU72eyeBzuDwsMZ8szPytXj7Y
         EFpHLW0wqmvhDYss6vRknSyh+bL7hy1SbbGUfP6JkXJWbizEL+MSyro2k/NsTRUsTCI5
         Ws53Qy4GeNUeEtugjPK/Iis5rOcqVRLBHBLnU/R1oC7MCS4k6fvCVxNuZaMz1l88c9vm
         9E4D4B65ZIGa/obM9962vxcz4QNGuct/OMz5KGvTDkxlRHONIbzkfsMYhLWwCQkLvlKO
         x2TJxop98P7aQNydzY3uaugOGreVqk40FtSN7bwqgrfjet6NfmLACr/YYepyW/wFcHc8
         3djA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b3kuVxaxl2HPF+2E83j0paQ6SkzBU2CrBRMXSA3lAwE=;
        b=MPDvvzscbAzuQ/GM/C9J9QahvlP+3jgaMPwT5UiPEg9CczVlOdBkMyY1jGmCE3VTmi
         t6fUpsEqSbmwwUO02mnp5XFbzfMGGCzDajs+miBDhr2M7U3OM1idpHn7QQBMH59nkXCG
         UBhqX9vVS1aWd0Hkhy5XXRKHR25mqFnzZGsMj5BKMgND+mdjSgJEx7nolqZIv8JO5Qwy
         ixebDXh99913stws1K+yUX2FP6qG5R0Nr0obE8QMijxAhu+263b9faDtkplcDwZJKEnT
         4E0q25IGLRCoT5etnZ/CfCK/l3bc73rBcITzbrXyISknEyILIaAr6D6HbJaos4Pb9kpl
         N3GA==
X-Gm-Message-State: AOAM53284Cvkgx+ZSIVYLy9DUbYn9wR/gLeLRylKOYskcqs60Vf7Dqpq
        9APVz7D8cdetTqvbMXuRC9GvOmYGKcRltSPA+ws=
X-Google-Smtp-Source: ABdhPJxRYIeBq/WJWdkyTHNeYOmROne1kJMh68m/6ZEtenM0bNptSPQe7mFhYlFNJr8MYnmTs0yAjGxK89FgZcDL5Xo=
X-Received: by 2002:a92:6706:: with SMTP id b6mr1036839ilc.42.1605294373908;
 Fri, 13 Nov 2020 11:06:13 -0800 (PST)
MIME-Version: 1.0
References: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com> <5ce9986a-4c5c-9ffd-e83d-e6782ff370ba@solarflare.com>
In-Reply-To: <5ce9986a-4c5c-9ffd-e83d-e6782ff370ba@solarflare.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 13 Nov 2020 11:06:03 -0800
Message-ID: <CAKgT0UciV2rSiNBHQOhqHkrx=XBLzOTdHmKXZ6fTxdt1D3c0Gg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] sfc: extend bitfield macros to 19 fields
To:     Edward Cree <ecree@solarflare.com>
Cc:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 7:23 AM Edward Cree <ecree@solarflare.com> wrote:
>
> Our TSO descriptors got even more fussy.
>
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/bitfield.h | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/bitfield.h b/drivers/net/ethernet/sfc/bitfield.h
> index 64731eb5dd56..1f981dfe4bdc 100644
> --- a/drivers/net/ethernet/sfc/bitfield.h
> +++ b/drivers/net/ethernet/sfc/bitfield.h
> @@ -289,7 +289,9 @@ typedef union efx_oword {
>                                  field14, value14,                      \
>                                  field15, value15,                      \
>                                  field16, value16,                      \
> -                                field17, value17)                      \
> +                                field17, value17,                      \
> +                                field18, value18,                      \
> +                                field19, value19)                      \
>         (EFX_INSERT_FIELD_NATIVE((min), (max), field1, (value1)) |      \
>          EFX_INSERT_FIELD_NATIVE((min), (max), field2, (value2)) |      \
>          EFX_INSERT_FIELD_NATIVE((min), (max), field3, (value3)) |      \
> @@ -306,7 +308,9 @@ typedef union efx_oword {
>          EFX_INSERT_FIELD_NATIVE((min), (max), field14, (value14)) |    \
>          EFX_INSERT_FIELD_NATIVE((min), (max), field15, (value15)) |    \
>          EFX_INSERT_FIELD_NATIVE((min), (max), field16, (value16)) |    \
> -        EFX_INSERT_FIELD_NATIVE((min), (max), field17, (value17)))
> +        EFX_INSERT_FIELD_NATIVE((min), (max), field17, (value17)) |    \
> +        EFX_INSERT_FIELD_NATIVE((min), (max), field18, (value18)) |    \
> +        EFX_INSERT_FIELD_NATIVE((min), (max), field19, (value19)))
>
>  #define EFX_INSERT_FIELDS64(...)                               \
>         cpu_to_le64(EFX_INSERT_FIELDS_NATIVE(__VA_ARGS__))
> @@ -348,7 +352,11 @@ typedef union efx_oword {
>  #endif
>
>  /* Populate an octword field with various numbers of arguments */
> -#define EFX_POPULATE_OWORD_17 EFX_POPULATE_OWORD
> +#define EFX_POPULATE_OWORD_19 EFX_POPULATE_OWORD
> +#define EFX_POPULATE_OWORD_18(oword, ...) \
> +       EFX_POPULATE_OWORD_19(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFX_POPULATE_OWORD_17(oword, ...) \
> +       EFX_POPULATE_OWORD_18(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
>  #define EFX_POPULATE_OWORD_16(oword, ...) \
>         EFX_POPULATE_OWORD_17(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
>  #define EFX_POPULATE_OWORD_15(oword, ...) \
> @@ -391,7 +399,11 @@ typedef union efx_oword {
>                              EFX_DWORD_3, 0xffffffff)
>
>  /* Populate a quadword field with various numbers of arguments */
> -#define EFX_POPULATE_QWORD_17 EFX_POPULATE_QWORD
> +#define EFX_POPULATE_QWORD_19 EFX_POPULATE_QWORD
> +#define EFX_POPULATE_QWORD_18(qword, ...) \
> +       EFX_POPULATE_QWORD_19(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFX_POPULATE_QWORD_17(qword, ...) \
> +       EFX_POPULATE_QWORD_18(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
>  #define EFX_POPULATE_QWORD_16(qword, ...) \
>         EFX_POPULATE_QWORD_17(qword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
>  #define EFX_POPULATE_QWORD_15(qword, ...) \
> @@ -432,7 +444,11 @@ typedef union efx_oword {
>                              EFX_DWORD_1, 0xffffffff)
>
>  /* Populate a dword field with various numbers of arguments */
> -#define EFX_POPULATE_DWORD_17 EFX_POPULATE_DWORD
> +#define EFX_POPULATE_DWORD_19 EFX_POPULATE_DWORD
> +#define EFX_POPULATE_DWORD_18(dword, ...) \
> +       EFX_POPULATE_DWORD_19(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
> +#define EFX_POPULATE_DWORD_17(dword, ...) \
> +       EFX_POPULATE_DWORD_18(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
>  #define EFX_POPULATE_DWORD_16(dword, ...) \
>         EFX_POPULATE_DWORD_17(dword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
>  #define EFX_POPULATE_DWORD_15(dword, ...) \
>

Are all these macros really needed? It seems like this is adding a
bunch of noise in order to add support for a few additional fields.
Wouldn't it be possible to just define the ones that are actually
needed and add multiple dummy values to fill in the gaps instead of
defining every macro between zero and 19? For example this patch set
adds an option for setting 18 fields, but from what I can tell it is
never used.
