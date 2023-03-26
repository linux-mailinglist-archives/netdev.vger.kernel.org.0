Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C584B6C92AE
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 07:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjCZFsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 01:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjCZFs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 01:48:29 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7C75FD2;
        Sat, 25 Mar 2023 22:48:27 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id d2so4832718vso.9;
        Sat, 25 Mar 2023 22:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679809707;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zc8mjbAuYE0z1ltMPEd4RTUXwSwNvXX5rOmOekUZdqE=;
        b=GnLiGyUR6Rvay2/a/1SUmgvNdgnBKLKauRB5Zj5QuFtvFN2rwLL2HR1hU9AaSDK82S
         mbhZFe+jD1jAes5V9VRJ66m2b6y2sdbRatL5N+4QfVhfQ+/rguMfJq4GzfQ7wJtM26UB
         y3kwsW7s6hXlHf1VKdGJOXzhmnZpF35ih/yW0WbBJy0lWaEf/FBCRs9dxsEIy4O/Yjxo
         ZYu0/X0PDyXyNA7ftm0SC9zCDpRqlsaOaRbIGhEt9CHFLjazghLx+k4OUsQGeFrSn5vA
         cRJEl1dn26bUBQkwAOKZ2qBD/5ET+MBhuOsbZY2/Nkd/0qaFr8E41QopekT0Oa5+o3eV
         +Efw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679809707;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zc8mjbAuYE0z1ltMPEd4RTUXwSwNvXX5rOmOekUZdqE=;
        b=Q89oR6m+M+oH7o00ovWixLOUEqOB9YikHyQcai0DsDQ/nV66P1U9N+gvK0I4Cg3Pro
         /ECFgwMKtWHW0NHy+TtorWcrT7Le8NVS8Ie2bsP1E+v35PN8PykJRy2BL6rFl0q7aGOe
         Hg9qk7RHFrAi93B97u7lOOTh8DI+6GSud4DWQQPz0uJgE/Kt/DydEtCQwXBbDSlVtdpe
         QoiW2vRbz2QCJmbiwE2gQZ+vAJlLfwHxDQZdlmvsigwYwptlWDz9ZiAusLuPvzyirhJU
         O43KbL9cb7lEy9yg1OiRpXJ3Ewmo7PtpZKyJdHjrWUdhzTW/CHrfMPu/P2ywYy1PKwGF
         O4yQ==
X-Gm-Message-State: AAQBX9cA1plz4jrQUHszL7XaOilTVDck4Lje+Tw6i73CVaO/iykYugqj
        S0m1gPUGzktDzRTceZc3llYGXeEFbtjfYtdN4f8=
X-Google-Smtp-Source: AKy350ZTWb+yA0Pk18IiwfASQF2bHwbj1wQaJBnzEmcrUoLrosk1ZIFVjWLd3KkeW+dTI5pSiAcTlVPT2i0WKdnGm/o=
X-Received: by 2002:a67:ca16:0:b0:421:eabb:cd6a with SMTP id
 z22-20020a67ca16000000b00421eabbcd6amr4074364vsk.7.1679809707027; Sat, 25 Mar
 2023 22:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230325083429.3571917-1-harperchen1110@gmail.com> <ZB7DSn3wfjU9OVgJ@corigine.com>
In-Reply-To: <ZB7DSn3wfjU9OVgJ@corigine.com>
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Sun, 26 Mar 2023 13:47:51 +0800
Message-ID: <CAO4mrfduRPKLruShN76VDOMAeZF=A7f84=vcamnHPCtMLGuRvA@mail.gmail.com>
Subject: Re: [PATCH] wireless: rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_rfreg()
To:     Simon Horman <simon.horman@corigine.com>
Cc:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Simon,

Thanks for the advice and review. I have sent the second version of the patch.

Besides, rtl_debugfs_set_write_reg also suffers from the incorrect
error code problem. I also sent v2 of the corresponding patch. Hope
there is no confusion between these two patches.

Best,
Wei

On Sat, 25 Mar 2023 at 17:48, Simon Horman <simon.horman@corigine.com> wrote:
>
> On Sat, Mar 25, 2023 at 08:34:29AM +0000, Wei Chen wrote:
> > If there is a failure during copy_from_user or user-provided data buffer
> > is invalid, rtl_debugfs_set_write_rfreg should return negative error code
> > instead of a positive value count.
> >
> > Fix this bug by returning correct error code. Moreover, the check of buffer
> > against null is removed since it will be handled by copy_from_user.
> >
> > Signed-off-by: Wei Chen <harperchen1110@gmail.com>
>
> Hi Wei Chen,
>
> * I'm not sure if a fixes tag is appropriate for this.
>   But if so, perhaps it should be:
>
>   Fixes: 610247f46feb ("rtlwifi: Improve debugging by using debugfs")
>
> * I think the preferred subject prefix may be                                     'rtlwifi: ' (without the leading 'wireless: ').
>
> * This seems to be v2 of this patch, which would be best noted in
>   the subject '[PATCH v2]'.
>
> The above notwithstanding, the code changes look correct to me.
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> > ---
> >  drivers/net/wireless/realtek/rtlwifi/debug.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
> > index 3e7f9b4f1f19..9eb26dfe4ca9 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/debug.c
> > +++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
> > @@ -375,8 +375,8 @@ static ssize_t rtl_debugfs_set_write_rfreg(struct file *filp,
> >
> >       tmp_len = (count > sizeof(tmp) - 1 ? sizeof(tmp) - 1 : count);
> >
> > -     if (!buffer || copy_from_user(tmp, buffer, tmp_len))
> > -             return count;
> > +     if (copy_from_user(tmp, buffer, tmp_len))
> > +             return -EFAULT;
> >
> >       tmp[tmp_len] = '\0';
> >
> > @@ -386,7 +386,7 @@ static ssize_t rtl_debugfs_set_write_rfreg(struct file *filp,
> >       if (num != 4) {
> >               rtl_dbg(rtlpriv, COMP_ERR, DBG_DMESG,
> >                       "Format is <path> <addr> <mask> <data>\n");
> > -             return count;
> > +             return -EINVAL;
> >       }
> >
> >       rtl_set_rfreg(hw, path, addr, bitmask, data);
> > --
> > 2.25.1
> >
