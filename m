Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFC24ED6C3
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiCaJ21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiCaJ20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:28:26 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4E71FDFE7;
        Thu, 31 Mar 2022 02:26:39 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id p15so46767194ejc.7;
        Thu, 31 Mar 2022 02:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=BQzqug6TtJon58Y75oLbeWdZudSqnMYJcFPXb4iBlFM=;
        b=RlKkxDZ70JBAkNTyPnOmO2IvQitrUXmpPnHUjAl1X+RgZ2E0E5pAlt37R+CO+yVU6h
         YuPM/Thd5c9b8PPpMXlIkT4L1vyo2u5dWryt14VnD0U+OpabTSX26POTY5nM0i5iC07t
         F/dLI6CVKSPNHYQUm8MhnUbeucrduAE2MEp0RYa+UxA5VdPmhbUBrHSc9GowDatGv9na
         0OIa8gYw6iAvacFzrGFuygF9+R3oVaACUExHX1pdTZQmYYiV9Ii9H+dQHVDDVmySH5P8
         SAvjinnyqlmdwl9Xt90plyNjgKo3tfFDFdXSJyJuQLPinVVBi+31/X1BIhaMLNFj/UUn
         0wJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=BQzqug6TtJon58Y75oLbeWdZudSqnMYJcFPXb4iBlFM=;
        b=Dy8LUGyOF2Z0adRqBcVT4HK5FCAhjw9ZCY5orFtSHrS2SguZdXVpNyCO0CMn1YX9bb
         cS4DYmFoDVA0C9/xRths9bp7/pOUkeV5zaEerSViMPnIj7oWrMj4MRTjsFmOMRJDMt0R
         P1BTnntneJlDKxzuMcJcRHHpqIfru3iwn/SiNm6GsRfXkdbnl+J8it6qtkbUpmPy4LmL
         vgyP4Y84Cp2JMShTiTK8ZwEfN8P/MSkz/ob1TS4kDDH0kRQZqHWs4MYxSwgg0LYxsUcU
         lOZpLN8ByhCVuT+ry00NwWpGVvp7/152MlK81GE+P8lSC9dM5BJzj6UW2Ie6D+yYjXde
         57wQ==
X-Gm-Message-State: AOAM531NUmDJi7sYqgpoLMuKy5zldV6Xy0Qm8vqFA8aeEQJJsjWgqpK2
        u625G0oAJzKc2cXw779ymL7/zxO3gyU+3g==
X-Google-Smtp-Source: ABdhPJwnRuwMDTXeNBMaZuBHYcEVJ1bB/yBLYHXEvwulY4XOI28kspERTlLsQ8Sfr7h8qT1wkVOxSw==
X-Received: by 2002:a17:906:144e:b0:6ce:6126:6a6d with SMTP id q14-20020a170906144e00b006ce61266a6dmr4070102ejc.662.1648718797808;
        Thu, 31 Mar 2022 02:26:37 -0700 (PDT)
Received: from smtpclient.apple (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.gmail.com with ESMTPSA id y26-20020a1709063a9a00b006e0c272e263sm6764346ejd.71.2022.03.31.02.26.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2022 02:26:37 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH] taprio: replace usage of found with dedicated list
 iterator variable
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <87fsmz3uc6.fsf@intel.com>
Date:   Thu, 31 Mar 2022 11:26:36 +0200
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A19238DC-24F8-4BD9-A6FA-C8019596F4A6@gmail.com>
References: <20220324072607.63594-1-jakobkoschel@gmail.com>
 <87fsmz3uc6.fsf@intel.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 31. Mar 2022, at 01:15, Vinicius Costa Gomes =
<vinicius.gomes@intel.com> wrote:
>=20
> Hi,
>=20
> Jakob Koschel <jakobkoschel@gmail.com> writes:
>=20
>> To move the list iterator variable into the list_for_each_entry_*()
>> macro in the future it should be avoided to use the list iterator
>> variable after the loop body.
>>=20
>> To *never* use the list iterator variable after the loop it was
>> concluded to use a separate iterator variable instead of a
>> found boolean [1].
>>=20
>> This removes the need to use a found variable and simply checking if
>> the variable was set, can determine if the break/goto was hit.
>>=20
>> Link: =
https://lore.kernel.org/all/CAHk-=3DwgRr_D8CB-D9Kg-c=3DEHreAsk5SqXPwr9Y7k9=
sA6cWXJ6w@mail.gmail.com/
>> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>> ---
>=20
> Code wise, patch look good.
>=20
> Just some commit style/meta comments:
> - I think that it would make more sense that these were two separate
> patches, but I haven't been following the fallout of the discussion
> above to know what other folks are doing;

Thanks for the input, I'll split them up.

> - Please use '[PATCH net-next]' in the subject prefix of your =
patch(es)
> when you next propose this (net-next is closed for new submissions for
> now, it should open again in a few days);

I'll include that prefix, thanks.

Paolo Abeni [CC'd] suggested to bundle all net-next patches in one =
series [1].
If that's the general desire I'm happy to do that.


[1] =
https://lore.kernel.org/linux-kernel/7393b673c626fd75f2b4f8509faa5459254fb=
87c.camel@redhat.com/

>=20
>=20
> Cheers,
> --=20
> Vinicius

