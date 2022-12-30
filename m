Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1496C6593F2
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 02:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiL3BCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 20:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiL3BCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 20:02:34 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAAA6316
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 17:02:32 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id vm8so41544956ejc.2
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 17:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=skymem-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tycLNGe2zV3GnXgelO8GUNgiAF+Co3Lc7eFI7APeWH8=;
        b=KWqt4BUKA/3p/uKzZw4e1Eh/x2eemw9jbrY7G8vBhIr3h16MMCHpqh29vJQ0dv3WKG
         /jisC1SJ6Ozh5eiZklfwAZZ+EXU6rQ/mFphZMgwQ0gHUap7mi1Pl3+O1XGL8D1XemzVw
         gA/sVAggf1GEzgB8VxGGT7NSTuN/ccQ/JXnsTFjWjdJNn7TBp/nChrhHJW3U38CeQaHG
         qE/idylrjO2Ja9k/DVrhwL+X/c6n1ShqjEh4R4SAedqeoWp9WgEJJDwpgv4FTq36pM0i
         22LOtZTeNG1uiRNsMeKKK+In/jLY2RjGHfIbed9P9G8IQIOaZMUIpg4AfvEec4YU44IS
         iu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tycLNGe2zV3GnXgelO8GUNgiAF+Co3Lc7eFI7APeWH8=;
        b=gvJke1HrkuCSHRixHhxsCfJHm0Uxl7XtEDzjLLSQC7qQ1A8gWJRXQ/AeWS/ygoJqdW
         TzFfCs1tiJTm9QRhzqFpXclN5ojEtoqyC0Mg4guVL/DoIvL26ZUoVzF4qN97aaBPAQgJ
         m1Ra62sdXuRFinU/DThM7pslW5RgtGPoOB8mrvDHPm75Vus7AdYLN+0k9utQO3emCF6t
         T8VX2AIPNEhKiMuDWRcTZnIA3EDkvAN+wnUvxv7ZaHbHl1wHdsJA7sqKdmdnW6HUlO85
         i+VoX/pwTUcVSOYGXGoG8fNxb3OsKChoP/1OT2awm5r02wXVvul98oJZqcdym9ziGTb8
         Vwqw==
X-Gm-Message-State: AFqh2krqxRudyI3u91jU3r/7msfOLpqClKfaBz9jovROGmfXK9PETyfm
        Hsc6LVpttqedi7ItULpOP2u9NVaGOZKrjn2fo4dP2A==
X-Google-Smtp-Source: AMrXdXsxbFfy6emzOy4rCk6sMZPvjUzJF5QKzuwD7rQ/YSoPshmepyvuTDh9wMDtTu6OUcTZH4pGGJc1rii5yqt4dPw=
X-Received: by 2002:a17:906:2c45:b0:741:5c0e:1058 with SMTP id
 f5-20020a1709062c4500b007415c0e1058mr1744939ejh.472.1672362151160; Thu, 29
 Dec 2022 17:02:31 -0800 (PST)
MIME-Version: 1.0
References: <20221208121448.2845986-1-shaozhengchao@huawei.com> <167102054878.7997.15438501425115316737.kvalo@kernel.org>
In-Reply-To: <167102054878.7997.15438501425115316737.kvalo@kernel.org>
From:   Info Skymem <info@skymem.com>
Date:   Fri, 30 Dec 2022 02:02:20 +0100
Message-ID: <CAKvd=_gj0H0TQTmshenaebufeCTJfBmA9h75OoPKkJ1wXC5=KA@mail.gmail.com>
Subject: Re: wifi: libertas: fix memory leak in lbs_init_adapter()
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, johannes.berg@intel.com,
        dcbw@redhat.com, linville@tuxdriver.com,
        hs4233@mail.mn-solutions.de, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
thank you for your information.

On our website you can find email addresses of companies and people.
https://www.skymem.info

In short, it=E2=80=99s like Google for emails.

Best regards,
Robert,
Skymem team

On Wed, Dec 14, 2022 at 1:23 PM Kalle Valo <kvalo@kernel.org> wrote:
>
> Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> > When kfifo_alloc() failed in lbs_init_adapter(), cmd buffer is not
> > released. Add free memory to processing error path.
> >
> > Fixes: 7919b89c8276 ("libertas: convert libertas driver to use an event=
/cmdresp queue")
> > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>
> Patch applied to wireless-next.git, thanks.
>
> 16a03958618f wifi: libertas: fix memory leak in lbs_init_adapter()
>
> --
> https://patchwork.kernel.org/project/linux-wireless/patch/20221208121448.=
2845986-1-shaozhengchao@huawei.com/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches
>
>
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
