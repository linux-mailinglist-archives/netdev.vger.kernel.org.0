Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0879E487E6D
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 22:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiAGVo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 16:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiAGVo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 16:44:26 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D33BC061574;
        Fri,  7 Jan 2022 13:44:25 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b13so26983580edd.8;
        Fri, 07 Jan 2022 13:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zXtdlL7gt6DxK0b+DlUcls5cPx4gO0iu5itPDk8XQcQ=;
        b=Hi4VtCwsWIj23EKOp/A6OS4R5FtBNKeI8CL0vWZxvdWb1gb6kQ/h/XUVeg9hJ3J7oX
         /F1S89XHIym6LwpmFOfswFIi0Jh77zWQhwHNyrfip0NwmmNZ7Y3ZZAn1evG+G8UbrKOJ
         O8y1WcDwarI1fNIXVU3B+MZfAW9wyFG5w/5mapVnUhrwuyqNcL8v80vjxLlDXDoFrP61
         FRE9tCErIJjQECRPCIGfoDxqKo1DB7P189pj7YOwiVSDY0AjrHqBdDpCcAdMbz9FNOma
         74ZQhpx9jL4N1zMNyyMXKmCMWaRnCRmtZJnH7ynxtogSSFqi+DdbAWo4RedWggI1bck2
         O6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zXtdlL7gt6DxK0b+DlUcls5cPx4gO0iu5itPDk8XQcQ=;
        b=OFjul4SQnLnXvpbFk3YfuTItxX53aG6WAE9HkFHwmAxiEXIusNr5SfGpI/pfguvgEn
         zDh7pT5PIIBIrI/F84ehhfjaMW4Gy4OnY/SjhOWItDHAXoOm2Ffvfz2I5f5f7JGJqL8R
         vWYPJOonLKvk0HxiK5AmS7FK8jnMK3szfGRvUTnLkewMYBRwxjHk74T9bOkWJZDUr5H5
         c13IiNKv9i6/KndQqms5qL4dktQ/0Ouw06asaJ/xO5k9OPy9uBqoa7Q9bViJ6zNhq35Y
         WqeKj09rD0gsKV6lwQaWpV77NtWXHVy2SYSktE88yhAr9kK+6+l7Tp/BCPr9qY0XgK/o
         A+Wg==
X-Gm-Message-State: AOAM530FbD1Funs5PoW4WEGIMMO2IKpnd4KbEyB3Kn97q9BZUOlISZvN
        rWSMIjZx1VyhqfSRO0AECrjMkeDjUZi+kz1dQMxzm2ByEcQ=
X-Google-Smtp-Source: ABdhPJyGa1XDoDP+0UdWLvgJj03UHE2OeJYIuZujmLHlyW3eTuHIJrCF8DVyiHmRb75V3oYfSBp4Zp6lBnOJMjycXZQ=
X-Received: by 2002:a05:6402:518a:: with SMTP id q10mr61045735edd.29.1641591863806;
 Fri, 07 Jan 2022 13:44:23 -0800 (PST)
MIME-Version: 1.0
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
 <20211228211501.468981-4-martin.blumenstingl@googlemail.com> <1e9ed12ac55e42beb2197524c524e69f@realtek.com>
In-Reply-To: <1e9ed12ac55e42beb2197524c524e69f@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 7 Jan 2022 22:44:13 +0100
Message-ID: <CAFBinCBUJHWb+VpLdqDh49RSX9oMPjCxU1hzzqsCL31ouG=zmw@mail.gmail.com>
Subject: Re: [PATCH 3/9] rtw88: Move rtw_update_sta_info() out of rtw_ra_mask_info_update_iter()
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ping-Ke,

On Fri, Jan 7, 2022 at 9:42 AM Pkshih <pkshih@realtek.com> wrote:
[...]
>
> > @@ -699,11 +702,20 @@ static void rtw_ra_mask_info_update(struct rtw_dev *rtwdev,
> >                                   const struct cfg80211_bitrate_mask *mask)
> >  {
> >       struct rtw_iter_bitrate_mask_data br_data;
> > +     unsigned int i;
> > +
> > +     mutex_lock(&rtwdev->mutex);
>
> I think this lock is used to protect br_data.si[i], right?
Correct, I chose this lock because it's also used in
rtw_ops_sta_remove() and rtw_ops_sta_add() (which could modify the
data in br_data.si[i]).

> And, I prefer to move mutex lock to caller, like:
>
> @@ -734,7 +734,9 @@ static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
>  {
>         struct rtw_dev *rtwdev = hw->priv;
>
> +       mutex_lock(&rtwdev->mutex);
>         rtw_ra_mask_info_update(rtwdev, vif, mask);
> +       mutex_unlock(&rtwdev->mutex);
>
>         return 0;
>  }
Thank you for this hint - if I do it like you suggest then the locking
will be consistent with other functions.
I'll send a v3 with this fixed.


Best regards,
Martin
