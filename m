Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212444B8843
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 13:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiBPMz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 07:55:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbiBPMz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 07:55:28 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666B02A7947
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 04:55:16 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id j4so1926843plj.8
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 04:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:cc;
        bh=7f0Bjb4CTA9sDf/RhNU0ViDB8ImucRrQA+jdH+nCegM=;
        b=Lfp+QXhFPhXhoUqpvw5lgLjvu1Jv6NJVpBFah8+qrb+fAdgmXsQ/NIaIOKMBuD1Q86
         7YJd69xRxq0gGtHAxAtHaYfWE+LSbYhccu2C9gWc/c0JgjRAByfO7ys0iS5mBVCFet91
         GgYgrtb80XQ0j2FDKr4N17vG0ja9l8cke1CHG4/4wmj6Ar2EraJ5bet7iAD4tVHWexNL
         jG17OLzG8UE8tlxC3UAfB3ND4CDxDEb4BpWxgiL2Rw9CO5zR6wW7zTOi8RaYxpqXvE15
         Edp+5uOfqCRB2yyIdn85LjwkpBu5ETojB/qzRQdQl5R463T4LPcSQZo9TX2jTZi3QUqr
         riWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:cc;
        bh=7f0Bjb4CTA9sDf/RhNU0ViDB8ImucRrQA+jdH+nCegM=;
        b=dTaSEtg3Wy+zhHqzURO7tAmOMXCiQKBAhg1Yin1awWXLVj8UmcJy4fpTLoFk9sudZR
         If3837ZCY9tbNjnkFveVout13hh929xn5NMNxAoPi0LSFHLj5j36JI8fui9j3Z3JE7Vg
         CAgbUKJS7IvtVbwLGNbKgeIzgYIzfOrrK/Jf3bNp6Wti/9GZ1QRE8N6MH82wl3MG7ssX
         56U22Fh2ctW6KJGNUFflexLFR4GwLj6T9t4Efff2cFxUKvA6fgvE9bb8iV/BGBNTe23w
         SgdDzOvfA8WddeK24kmeW93KJjVUFPKjwBLYN6lwUZVorX53Zcxjkpem9NXC1fvNat/s
         VrZw==
X-Gm-Message-State: AOAM5338BQmrebk6i+KrAz8kfPSL5MYVrzLPf9LQvXql5hfrJr5NVZv7
        FuOLDR20rTknivbGILUsoWLhvLw9ZYbKT3A91GYv+yR5w0E=
X-Received: by 2002:a17:90b:f88:b0:1b8:ad41:e200 with SMTP id
 ft8-20020a17090b0f8800b001b8ad41e200mt1280259pjb.1.1645016115995; Wed, 16 Feb
 2022 04:55:15 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:1252:0:0:0:0 with HTTP; Wed, 16 Feb 2022 04:55:15
 -0800 (PST)
Reply-To: israelbarney287@gmail.com
In-Reply-To: <CAGMjROcUriFjEkictTQgia7rDb47=55s_A41acHyAxvdGmWubA@mail.gmail.com>
References: <CAGMjROcfEYkqT5CXLTKMD4pMGsR3v6EQi8W8if6+8fWmu2jxsA@mail.gmail.com>
 <CAGMjROfMvKas4=qZnZC-8s73m=HVTNG5RwvKzanBixyXtaJnNg@mail.gmail.com>
 <CAGMjROcoSqeLX7CcyHXje0WOT7D6vf-ZA2yGRku0z9eCUpyhiQ@mail.gmail.com>
 <CAGMjROeP4FN0RW4d__NzD0zNr8KQQTaVt3JtEgaTZExQD0AGJA@mail.gmail.com>
 <CAGMjROdHZ9cSG3S0++OQJKVaHwuUk6=3N-DZe6_re-d+za0dqQ@mail.gmail.com>
 <CAGMjROcgX9Bb+Qw9Ui-Co0RtrbQPfC+oRmrKVVyRNWo+9RRtVA@mail.gmail.com>
 <CAGMjROcMHuTCaUYYFuXWRW7_joDoVuCyeSA9wK8Emi4zPBB-pw@mail.gmail.com>
 <CAGMjROdKsc8gB=AKOZ4TR81Pr8KzLGCJC1VeUpH1x-VgA5qVuA@mail.gmail.com>
 <CAGMjROdqTNOM-2HHs-RnhiuVCbO9cZ32p+DAS8b0mHuHmoVuqA@mail.gmail.com>
 <CAGMjROdXpTtGc7aaZSwhMrC6EnWqF9dO_tc9MhmEBjUuJJ9bdA@mail.gmail.com>
 <CAGMjROd58LU=CCcAj0+fP=Ghq5cnfxXW20wjRR6cmQ2=zh_UJQ@mail.gmail.com>
 <CAGMjROcOxpNx1CJodGO5i8OSTwt8fshpWVNG8ZaVOyUNmq5GVA@mail.gmail.com>
 <CAGMjROc_8TZqf1kfF_iVJ63zEy_JbaMdi4X2FTKCny+H3cPz0A@mail.gmail.com>
 <CAGMjROcpFVrCk2g3B9DZeRRTRm7UMs1pN1sYa+aNc_x3Lztb0A@mail.gmail.com>
 <CAGMjROdLPFY0z+F+Yk=9kaCTUrkve8oHQvArZhCH+oWJDR1kcg@mail.gmail.com>
 <CAGMjROc7YvkQQ=EWBFmQqMSnTf6vk__xpJyKqGdbCQJVBh5oTQ@mail.gmail.com>
 <CAGMjROd9xHdwDHTVsU6iHWUN53empP_0w0CH2DRDX4q+z5WShA@mail.gmail.com>
 <CAGMjROcf8OqU2JjMJJZPD2ntrgxLP6-b_vnTjM0z7WpCo+dnKg@mail.gmail.com>
 <CAGMjROdiOUrBJEr00zXD4+L02HfSRs02BRNydytZaM29_QwJ1A@mail.gmail.com>
 <CAGMjROerQpG+o0XL16eDM0af=0kqp40KdC3Aev9wDCyXmJ1kWA@mail.gmail.com>
 <CAGMjROdR9JF4VVDxA-vpHPYjVKZ-TnFfs78RjXnx+V_7=e6a+A@mail.gmail.com>
 <CAGMjROcbJSpYpH=fzguXQ_LxhObXkMCCyXPuk-qPAJh4CLOncQ@mail.gmail.com>
 <CAGMjROdnmJdUxVdwRp8cynr-G2=Z84-cyvbY-L3E4JAO2aX1YQ@mail.gmail.com>
 <CAGMjROc8s4duGvWdVQwq772PmuLagvzF4=ogo84wtG2a10r2Yg@mail.gmail.com>
 <CAGMjROdX5-GUrQ+OL_+-KmKfcyr21uzYw-+xKXB7LFPgnafjew@mail.gmail.com>
 <CAGMjROf=Hr2y0XANsnA0Gs5g7S_=c+ud=Edm-56qJcO494ZndA@mail.gmail.com>
 <CAGMjROdc30cg+7Cn4Rc-Cx7Xvf-CVsVO_v1i5Y5-R5CMNsuGJQ@mail.gmail.com>
 <CAGMjROfkms2kQRMqd0qdmLuYMHf9UDpMMXgv+ZACnNgDNMygkA@mail.gmail.com>
 <CAGMjROc=UMQ7yGJuOGBkXeh-zAS-6nyAde9-5XOoEouooMkFYQ@mail.gmail.com>
 <CAGMjROcUj3Pfp7hZnT_bXWpadq8qsKr6Xa3UHLuHqaK_x5VX_A@mail.gmail.com>
 <CAGMjROceRA=UHPhRgH6sSxcrfpQ2Sw3RWchX3iQAG2xTGQiqXw@mail.gmail.com>
 <CAGMjROd1m9M+TTp0Z4jgof8NDOjp222VOLbMmGFAASR9fyFGpg@mail.gmail.com>
 <CAGMjROfdxY8oXP_+rXhjx-VLmzB7t4A3w2hOdPOKFneWc9YvNA@mail.gmail.com>
 <CAGMjROdGBPRtvMhpRQTabAUkijiZM3NUsBqN0-FpRf4bvkmVbQ@mail.gmail.com>
 <CAGMjROeUQn+hhz_+0opQ_uKU3Ph0SBhKZjiRcEcMNgp2aiVvsg@mail.gmail.com>
 <CAGMjROckb8rF246+nTo6UkLLaf+mC6KzbM2WRE6UOzMaFuBFRQ@mail.gmail.com> <CAGMjROcUriFjEkictTQgia7rDb47=55s_A41acHyAxvdGmWubA@mail.gmail.com>
From:   israel barney <sylvabou2018@gmail.com>
Date:   Wed, 16 Feb 2022 13:55:15 +0100
Message-ID: <CAGMjROcYipqRymU_LYG1APPQ3QYgRi2C1-bvW-f46R0J5We6yQ@mail.gmail.com>
Subject: hi
Cc:     israelbarney287@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        MISSING_HEADERS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Permit I talk with you please, is about Mrs. Anna.
