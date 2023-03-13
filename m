Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4D16B72BC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCMJhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjCMJgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:36:49 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD4D56524;
        Mon, 13 Mar 2023 02:34:55 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so946244pjt.2;
        Mon, 13 Mar 2023 02:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678700089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXdchWGvpYYUnRnDN5ksYkh2pmYAg17MIrwTAg/AU7w=;
        b=D+kS+Em66tsW1DnCr1bjb3GHPLYA9muY+RQn7gWEjW7Wcrdhk0A0/jTF80jfUdBxW4
         bwlobc/p3gpheh1Gn6MJuuG++V47qlCbxDbmb3CYrs+fQ0CoWUjf/6JDHx1qm/FTaKDU
         AZv2cyxCCJVaOoLzcpQLcZ/e6RSvnPxq6fCz6zRm2tO6TL1DOZG+7KT51C8n1GN3S2kl
         abvWrv2N+CrFhWxcbekq6cAjSKR8vXX6T/5Z7DVdsziEDmUjBbPxSl0Y4hGQyB+ZI7bU
         Ij8Z9gQe0z5tL0ElFZTc7smxQXAMA09uEp4oVgStYnWinlc0LE0f0mkADohXsglMl6tw
         IPiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678700089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZXdchWGvpYYUnRnDN5ksYkh2pmYAg17MIrwTAg/AU7w=;
        b=Fjrhz28XNq9s5r9e0zi6N0B8newwSwu8qE1BvuIVhRL1qia5n0cbsowx3Hgo8VIy2T
         AA2oB0AZxeJJmltYIBiCdT03G0BEhMz2nxCm3wlbC2Z3ZMVNgPww+tnhAMoh8pB/ADzZ
         KWSfxj8O+0bZzR2xU3wNMjcZymFt1Dte1t55ndH8JsPxlGQaRVViERudmeK9z2vkEdDU
         99wTOLqlqkex/ni21GHImYX35f+T7VXUmU5AxVIYGb7dvGmmqih3rcYScaK+cCN7T9M9
         5Bf2lotiKnE0CIWkIr34EeHDAOEEa49hTc4hIVVJf74d10kv8YD+/Pxyg84WnD1nQfkB
         sMNw==
X-Gm-Message-State: AO0yUKWK0cw8QC999p+K6PQw/dL/aWMmwWxrSQqMpTfx6XIzgsZwXVuI
        tZoF3xGT/1C3cbUe3SFWuJ+8Bszne60E78THl5k=
X-Google-Smtp-Source: AK7set/gfywg6ehGXdfiz6oa3IZ3JzD0sx/FyV+qZYGZy3UjOHsFfYQAeqyulBFbvq/EvkE/ZxK0u8hC+qORX2ZBCRk=
X-Received: by 2002:a17:903:2890:b0:19f:2554:2886 with SMTP id
 ku16-20020a170903289000b0019f25542886mr2432770plb.0.1678700089583; Mon, 13
 Mar 2023 02:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230311180630.4011201-1-zyytlz.wz@163.com> <57f6d87e-8bfb-40fc-7724-89676c2e75ef@huawei.com>
 <CAJedcCy8QOCv3SC-Li2JkaFEQydTDd1aiY77BHn7ht0Y8r1nUA@mail.gmail.com> <43a4a617-2633-a501-6fd1-b2495aed90f7@huawei.com>
In-Reply-To: <43a4a617-2633-a501-6fd1-b2495aed90f7@huawei.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Mon, 13 Mar 2023 17:34:36 +0800
Message-ID: <CAJedcCwK_WtyDTTpLV0Cp0KLRSaVjCw_LUS6LKUbyYpia96wWw@mail.gmail.com>
Subject: Re: [PATCH net v3] net: ravb: Fix possible UAF bug in ravb_remove
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, s.shtylyov@omp.ru,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 1395428693sheep@gmail.com,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yunsheng Lin <linyunsheng@huawei.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=B8=80 11:32=E5=86=99=E9=81=93=EF=BC=9A
>
> On 2023/3/13 11:02, Zheng Hacker wrote:
> > Yunsheng Lin <linyunsheng@huawei.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=881=
3=E6=97=A5=E5=91=A8=E4=B8=80 09:15=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> On 2023/3/12 2:06, Zheng Wang wrote:
> >>> In ravb_probe, priv->work was bound with ravb_tx_timeout_work.
> >>> If timeout occurs, it will start the work. And if we call
> >>> ravb_remove without finishing the work, there may be a
> >>> use-after-free bug on ndev.
> >>>
> >>> Fix it by finishing the job before cleanup in ravb_remove.
> >>>
> >>> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> >>> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> >>> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> >>> ---
> >>> v3:
> >>> - fix typo in commit message
> >>> v2:
> >>> - stop dev_watchdog so that handle no more timeout work suggested by =
Yunsheng Lin,
> >>> add an empty line to make code clear suggested by Sergey Shtylyov
> >>> ---
> >>>  drivers/net/ethernet/renesas/ravb_main.c | 4 ++++
> >>>  1 file changed, 4 insertions(+)
> >>>
> >>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/e=
thernet/renesas/ravb_main.c
> >>> index 0f54849a3823..eb63ea788e19 100644
> >>> --- a/drivers/net/ethernet/renesas/ravb_main.c
> >>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> >>> @@ -2892,6 +2892,10 @@ static int ravb_remove(struct platform_device =
*pdev)
> >>>       struct ravb_private *priv =3D netdev_priv(ndev);
> >>>       const struct ravb_hw_info *info =3D priv->info;
> >>>
> >>> +     netif_carrier_off(ndev);
> >>> +     netif_tx_disable(ndev);
> >>> +     cancel_work_sync(&priv->work);
> >>
> >> LGTM.
> >> Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
> >>
> >> As noted by Sergey, ravb_remove() and ravb_close() may
> >> share the same handling, but may require some refactoring
> >> in order to do that. So for a fix, it seems the easiest
> >> way to just add the handling here.
> >
> > Dear Yunsheng,
> >
> > I think Sergey is right for I've seen other drivers' same handling
> > logic. Do you think we should try to move the cancel-work-related code
> > from ravb_remove to ravb_close funtion?
> > Appreciate for your precise advice.
>
> As Sergey question "can ravb_remove() be called without ravb_close()
> having been called on the bound devices?"
> If I understand it correctly, I think ravb_remove() can be called
> without ravb_close() having been called on the bound devices. I am
> happy to be corrected if I am wrong.
>

Hi Yunsheng,

I'm still not sure. I'll look at code more carefully and see if there
is more proof about it.
And as I'm not familiar with the related code, let's see how Sergey thnks.

> Yes, you can call *_close() directly in *_remove(), but that may
> require some refactoring and a lot of testing.

>
> Also, if you found the bug through some static analysis, it may
> be better to make it clear in the commit log and share some info
> about the static analysis, which I suppose it is a tool?

Yes, I'll append this msg to commit msg later.

> >
> >>
> >>> +
> >>>       /* Stop PTP Clock driver */
> >>>       if (info->ccc_gac)
> >>>               ravb_ptp_stop(ndev);
> >>>
> > .
> >

Best regards,
Zheng
