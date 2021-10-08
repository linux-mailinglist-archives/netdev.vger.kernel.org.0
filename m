Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BB342658D
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 10:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhJHIFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 04:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbhJHIE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 04:04:26 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF98BC061570
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 01:02:31 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id k19so192093qvm.13
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 01:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EC09Hkxbi4TOnTSsjfnoq1JOzm235aUyNqPxEbQfZDU=;
        b=GRXj4gk313VyB4ODN/GH3dZmd53vkgjkeroLzBH0u3UYjUocTYOGC6H724AHXvXClb
         VEeo5TxJDOxtUKpkiD+RZBp15I1JBhJ+bn9tN01Kr1SSbwzT6ydr4ON3HirMUpst/AYl
         jj7OhrWEjCNkAGyTKBZoqkXfJp79kEqZBGZnk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EC09Hkxbi4TOnTSsjfnoq1JOzm235aUyNqPxEbQfZDU=;
        b=e/Dun+SA2s+QsKs60Fti0MoRUbhOXgJHjCPzyuLrenXB3j7hW6F0p7ucGHtK7MEF4y
         IeE17fM2B8b9KQ8eUr4DhfiNzFOtrTOk7htM0i/R5C6iH7nZXNJGAqvLO8Hp1Qyk79Y4
         hSOG08LXS0+6zdgZxwNrhGmWRkyNyV/9PVpQbODV8d4Yz5FRglDLtgIb5fDxXFX+6EMa
         8fdyYDWC3kV++ivY5NufJHdYswrrF1UL1VFobhIBbudm9EEUhMGPD4upY/iRwulkXFTp
         2nclH2+LBGk6+/qGtb9AsmB9ouFJHSlKTRbQDvFAQd+Kq10oSvbxPNT7utI245D5YwEO
         VKjQ==
X-Gm-Message-State: AOAM533jhlTYukeQj13y8ThJexk/904YDlr6ZaRDS1KNe2tHw3C0ZSc0
        WjSwj+iFIHspYeO/UMWQrzGrcgP5bi8l2n7l9l7KSQ==
X-Google-Smtp-Source: ABdhPJwRIB1TajKPdOJp4wrBTlJGZqZr1Wibcj53fZ7AUixln3nbqRqTDDReD7fVs6U4hJzzQFuH/NQbYGjoOTBxOL8=
X-Received: by 2002:a05:6214:1269:: with SMTP id r9mr8437410qvv.23.1633680150896;
 Fri, 08 Oct 2021 01:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211008063147.1421-1-sakiwit@gmail.com>
In-Reply-To: <20211008063147.1421-1-sakiwit@gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 8 Oct 2021 01:02:19 -0700
Message-ID: <CACKFLinAdmeBrhEv-Kbb8vtKcLwm74vL4=b3X6i39jXP3pJwDQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: tg3: fix redundant check of true expression
To:     =?UTF-8?B?Ss61YW4gU2FjcmVu?= <sakiwit@gmail.com>
Cc:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 11:32 PM J=CE=B5an Sacren <sakiwit@gmail.com> wrote:
>
> From: Jean Sacren <sakiwit@gmail.com>
>
> Remove the redundant check of (tg3_asic_rev(tp) =3D=3D ASIC_REV_5705) aft=
er
> it is checked to be true.
>
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>

Thanks.
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
