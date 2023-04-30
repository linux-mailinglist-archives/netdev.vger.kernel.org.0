Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2B86F2BC3
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 01:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjD3X7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 19:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbjD3X5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 19:57:55 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23478E66;
        Sun, 30 Apr 2023 16:57:53 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id ada2fe7eead31-42dfffbbf32so566803137.1;
        Sun, 30 Apr 2023 16:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682899073; x=1685491073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y5yOMPitISYAlbpaB11MkGcUAwlL+JYlE7n3Iz8ufFk=;
        b=f1AaNZHBnAEJzKBd0h6IkFWqk9amZi25t38VA17+VcbfH0J97hr4b1RVLBZGgGlPjq
         0Y1/N3juwlzIclF748EhRHOG1BhWVwgxNm8OMGAj2FzxdKwfbLf2qCUkb33XWDBnq70l
         Mn1lPoULdMUDgQUAxHlpKUnHwWMxkTaS/AHL/Mp34FQaEmCUEzSeYL6FGUH8ZUBGybvm
         SwtHBelp1iO3TCETcTDwLCm7tnBV1gmKudx3b7Ycel2XXSbx2sI5H+T3rc7npn0lvREq
         rAwNuHrYLGr21AHWTirKstqsn/j6mdxdW+/3n7FQy/nnbhejIRRWw1mmgjI11UUfkuqN
         d1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682899073; x=1685491073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y5yOMPitISYAlbpaB11MkGcUAwlL+JYlE7n3Iz8ufFk=;
        b=WapTdWpS6U8KgIKCe19YO/VH2uyKxLAs2qVUsJxOuOvI5vPh3gxZ82NWkGrIOb40s6
         LtiRgwnrlC046PP8kl6EK8t4b1GKO/bAmv6C2jjBsvJfyRzVgA5VBPxqaoUJkJiJBDlg
         S36x0UYY6WERxrHL/lycCISlV5dCcXUvU7dQ3hwKIvwhuoe7ef/BludMwxSvVsBSDZWd
         JIH+RcZiP3wnQde6LmOXMdTa7zGjqburO+yxeuk1fV6R+yDS8NlprxVwKjMXOmqJN5OX
         Eih10O3KiqYAkN662WmSjrUMfE0XsE4ryb+2oke4CNVTMUPtD7tFLH2M14JxrZYNOCyF
         +wtw==
X-Gm-Message-State: AC+VfDwDieS5WCPrJAnaRg9/LVM94DCRPIL0+Gk6K6TOrR9PNR/Qm+WH
        Vv29QXUrdUikEbg9anZ1Jz0wBVzR+oIaMuN2nws=
X-Google-Smtp-Source: ACHHUZ5CsWQV7H563NgOgOzxqRbohUZKUSDeVX7Jo4SjdJwXY1g6eQIHAUoxDtw7DESK/5724qipuhp9akOGPe6jhMs=
X-Received: by 2002:a67:edd1:0:b0:42e:6298:801d with SMTP id
 e17-20020a67edd1000000b0042e6298801dmr4655196vsp.20.1682899072981; Sun, 30
 Apr 2023 16:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230429020951.082353595@lindbergh.monkeyblade.net>
 <CAAJw_ZueYAHQtM++4259TXcxQ_btcRQKiX93u85WEs2b2p19wA@mail.gmail.com>
 <ZE0kndhsXNBIb1g7@debian.me> <CAAJw_Zvxtf-Ny2iymoZdBGF577aeNomWP7u7-5rWyn6A7rzKRg@mail.gmail.com>
 <CAAJw_ZvZdFpw9W2Hisc9c2BAFbYAnQuaFFaFG6N7qPUP2fOL_w@mail.gmail.com>
 <e9c289bea2c36c496c3425b7dc42c6324d2a43e3.camel@intel.com> <0785e432f1776b3531e8e033cb5b48eeb58b12b6.camel@intel.com>
In-Reply-To: <0785e432f1776b3531e8e033cb5b48eeb58b12b6.camel@intel.com>
From:   Jeff Chua <jeff.chua.linux@gmail.com>
Date:   Mon, 1 May 2023 07:57:42 +0800
Message-ID: <CAAJw_Zvafhng8oP8E6HyhB5DK-WSQm2_yNbbHhgbTQb74pM-fA@mail.gmail.com>
Subject: Re: iwlwifi broken in post-linux-6.3.0 after April 26
To:     "Greenman, Gregory" <gregory.greenman@intel.com>
Cc:     "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 1, 2023 at 2:00=E2=80=AFAM Greenman, Gregory
<gregory.greenman@intel.com> wrote:

> > Strangely, I couldn't reproduce it on my system. But, anyway this featu=
re
> > better be disabled for a while. I'll send a patch with a fix shortly.
> May I ask you to try this fix in [1] (also cc-ed you on the patch itself)=
?
>
> [1] https://lore.kernel.org/linux-wireless/20230430201830.2f8f88fe49f6.I2=
f0076ef1d1cbe5d10010549c875b7038ec4c365@changeid/

Hi Greg,

Applied the patch. It worked! Thank you!

Jeff
