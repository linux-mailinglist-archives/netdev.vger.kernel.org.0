Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D951FFC15
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbgFRT4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728753AbgFRT4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 15:56:23 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646CEC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 12:56:23 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id z2so7112863ilq.0
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 12:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PK+9ji006IwQlovmrVA4KlmDzFpOMHVtC8vUT3rw05s=;
        b=X383FqfwcbW+BE93TjK5D7bNxJzHRSgbhaFWXtljNu+5cNBuqNCVFCZAfm8ujoT4bZ
         LioFysJkBr/15HRZ+cpc4iOBsID1Cdmj3RMxuVoPlVlHE4/5Ju7Hb8/iJ0W79EH863id
         an1v1zmmu9Ny34qezZqQ2KHBN6IxxdX/EZDx4jOq9iIA4eEXJ8HtGoJXSgyWQD7/AhmS
         imWEeu/WvmLph935693CsDx9nrwuXKyYA9f0tJDpd2PaFSN6bAxNUwg66ux5VBv0mJAy
         GiVSsJCZa4BBUBNdtwA6iwX/yhBeztKCZMv+3YyV/EFrTmithmWCa0kdFUYFbxtu3WmD
         u15Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PK+9ji006IwQlovmrVA4KlmDzFpOMHVtC8vUT3rw05s=;
        b=S9NwlOuYOJadKREhO2gMUTNo7kR1YA1B28SZ4gxzg1v2DlHf08oR3gxyDWCXVROalA
         a+ek8DBNnUw7AdAgUt5xlcGoVk+LJsMt/fOt/0c0FuTGPJTEddtIUD2bPzBiNnbUOdoL
         bCRG2ODxvopweXpDwGZ0SiXxYQH/aE9Bl+rS4KlyF9AVUis8SkIo5CAhF2M3SdyHVQs7
         aMKkJOGAq/RQaCllDEIGBBOvECcQWDIKojSN0Wq8dKaqGueShoS+1EmzrIFDOGa7Bjqg
         gYlXhhOx8Xg3YJxw9K0GqmBKV8aN8f+UlsVPmSKGPWwNgf7ClBL5cUan9v/mrLrkcXe7
         xwHQ==
X-Gm-Message-State: AOAM533XHiF2UgEUNNTDglPcFZ04BTGcefzmSOKytZMB4hfxaHlU3Pyg
        yj5rtPrAcvrHKwdqgslumVMUXtsbbPmYPhq6oZs=
X-Google-Smtp-Source: ABdhPJw3yRTNXScc/Tro38XazOCCYZA0ZM0MtoQGJ7d56yLpGg12WMiDVh3bXt6cnHrWiNPVuHFe2bC795WXWgYusdo=
X-Received: by 2002:a92:5b15:: with SMTP id p21mr180278ilb.22.1592510182819;
 Thu, 18 Jun 2020 12:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com> <CA+h21hr_epEqWukZMQmZ2ecS9Y0yvX9mzR3g3OA39rg_96FfnQ@mail.gmail.com>
In-Reply-To: <CA+h21hr_epEqWukZMQmZ2ecS9Y0yvX9mzR3g3OA39rg_96FfnQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 18 Jun 2020 12:56:11 -0700
Message-ID: <CAM_iQpW-5WpaSvSmJgoqEbcjtrjvaZY3ngKzVy2S-v81MdK4iQ@mail.gmail.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:40 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> It's me with the stacked DSA devices again:

It looks like DSA never uses netdev API to link master
device with slave devices? If so, their dev->lower_level
are always 1, therefore triggers this warning.

I think it should call one of these netdev_upper_dev_link()
API's when creating a slave device.

Thanks.
