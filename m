Return-Path: <netdev+bounces-1499-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 855166FE05C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A966B1C20DB0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB58312B95;
	Wed, 10 May 2023 14:33:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5FF20B34
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:33:30 +0000 (UTC)
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC3C5FC9;
	Wed, 10 May 2023 07:33:26 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-61a80fcc4c9so33648776d6.2;
        Wed, 10 May 2023 07:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683729205; x=1686321205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0hfysyDoLvfSjn9Gbra/pgFrunFJIjWSldqphEXu3M=;
        b=A98X2+vOlDRUmkVdkHCs/Abj0vBCqdKvG9jwP14IOjRKX7G6vSNz5a3n2ApqOH5Jdx
         b5iLqbf7uMXR/ecTLhuy0GfAC/CFTb5J+zOrf8Qt6/OpI8n9oqrFm0NMsZz2sr5+qmU2
         mmUb9NqThK2eGhofH0wqdMLqnTnkX9WkxgG8HQHLCNhx4h99iUl3hgy8oMRngZ6xCPlU
         6ctHf321OwOUtxpxnYBUHWhktarotZiBVcZQFex6W1QD0S+QwMCAffXA/F1wEQjmo6J6
         XSGVMMQSo1cApQhd+ISbWJOZsm5L82qwi4Q61ipQ2ZbaarGaXJT7ZYhbiLl2UPOF/7VV
         MQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683729205; x=1686321205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0hfysyDoLvfSjn9Gbra/pgFrunFJIjWSldqphEXu3M=;
        b=DokrpW/TZioAFKswRg1/UUszYx/JNyPTi2g89Zn7UztHGTV+a+NvA2p8nrzrlWHXJH
         J+u4n1E06IlCRWyhACpPCgQNgaQ+xAD3k9eXR67jCEb6GC2y3D+Nwaq9ozaniwMZU+aG
         XpLQymvpuN1wxs4mABtHU5mAkkuPqm6tuOV19OT0ggKhQq78phkw1FM+VdPT051h2Ycv
         rwEbSP523kzxh+KxQf28dyKjjJBcfQlK+S3wSqbdDDEzMHJZgGAPMfRDRQfWNriXOn5P
         eTykv4P9d7Yb/+FP3CF64VtHKTYvLIow3mLhSNYNqxwJpcK5bKMVvBWiYP2R+33YGXFF
         tlcA==
X-Gm-Message-State: AC+VfDywbxrYR2QmfE95+e2REyYbbC07H3Pmn+oBWGXeXc1zuTuOe+0p
	OTQ2AZxxz8nULyoXCbqpY025FCPP/w1U8HD7g2k=
X-Google-Smtp-Source: ACHHUZ78XZoOaM4Rp8Q2G5bpRTJygEU4p3T3rDEn8TaTH/r/devHjRVlY4shTDOc/4ZkGjfB/OqAHOa8fCq/ncKjO+o=
X-Received: by 2002:a05:6214:ca1:b0:5c5:6e60:eacd with SMTP id
 s1-20020a0562140ca100b005c56e60eacdmr26700910qvs.28.1683729205293; Wed, 10
 May 2023 07:33:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1683718725-14869-1-git-send-email-quic_rohiagar@quicinc.com>
 <c0c3db1d-e83c-3610-ed61-db84cd88b569@quicinc.com> <CAHp75Ved53idRgpCDb2c=Bq9HXaE+sOWpY256rSRz-6bfRYnqA@mail.gmail.com>
 <9ed645c0-bae0-eb73-ab96-72fd69f9b463@linaro.org>
In-Reply-To: <9ed645c0-bae0-eb73-ab96-72fd69f9b463@linaro.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 10 May 2023 17:32:49 +0300
Message-ID: <CAHp75VdNvLpe2dw-FDr1=GH6+Gdt+-L04TgPS8-cQgVVZSk8xw@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] Add pinctrl support for SDX75
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Rohit Agarwal <quic_rohiagar@quicinc.com>, agross@kernel.org, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linus.walleij@linaro.org, robh+dt@kernel.org, 
	krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com, 
	manivannan.sadhasivam@linaro.org, Mukesh Ojha <quic_mojha@quicinc.com>, 
	linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 5:06=E2=80=AFPM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
> On 10/05/2023 16:02, Andy Shevchenko wrote:
> > On Wed, May 10, 2023 at 3:16=E2=80=AFPM Rohit Agarwal <quic_rohiagar@qu=
icinc.com> wrote:
> >> On 5/10/2023 5:08 PM, Rohit Agarwal wrote:
> >
> >> Patch 2/4 didnt go through in the mailing list linux-arm-msm because o=
f
> >> char length.
> >> BOUNCE linux-arm-msm@vger.kernel.org: Message too long (>100000 chars)
> >>
> >> Here is the link for it.
> >> https://lore.kernel.org/all/1683718725-14869-3-git-send-email-quic_roh=
iagar@quicinc.com/
> >> Please suggest if this patch needs to be broken down.
> >
> > Since lore.kernel.org has it, I think nothing additional needs to be do=
ne.
> > `b4` tool will take it from the archive.
>
> Patchwork does not take from b4, but msm list, so this won't be applied
> by Bjorn. I would suggest either pinging him to notice it or splitting
> the patch a bit.

Oh, this is unfortunate.
Thank you for the information.

--=20
With Best Regards,
Andy Shevchenko

