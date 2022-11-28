Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E3163A742
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiK1Lft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiK1Lfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:35:47 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5C912774
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 03:35:47 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id d128so12884985ybf.10
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 03:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMiFcCRzgQ1Lx1T2iWyB8q4b0VW6bVDTTTY1sWj2uJg=;
        b=RoM9jvyUrXr6jehF181Xr64Ljtctckxvz2cDyDAUv4/ufceaI2Yseeexg1dc2+H372
         4qufAJIbu0+7ubkdOT8BahDScj88E+42zY/IsTPeR146EPTAgZWSX/NvJAfpybzOJKS7
         O0XRKT5ApKlYRBU8/2/qEk0ujDlCuzj6iwfFt1mFJc9x46KB1lFLUnZCQvvw0UfllPJL
         es+UJP+hVeO4tBSapQwoGMIn8u7mJmVIkGJxiFJTDgiCP7W34IcVSlRxmfdjiVpHl7s9
         BGGK9FMeqbqPQbaBT1v6vtYPJLru+247RALfQaHus7ZsWKpqwNG5yqiyPSnrGjYtIJxH
         TF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JMiFcCRzgQ1Lx1T2iWyB8q4b0VW6bVDTTTY1sWj2uJg=;
        b=zmOPkAlKCM5S+//3O+K6Xyq9rbRwcYeFCgnlQx6rMyd9brjBwawVgQA3JI2uHNMbRh
         CEwMC0x4lIqBPFZAJ4y7ymLk8vr88hZTGTWUlz9X/6uunGciarfv5duUHrPh3cC68WfT
         oiErCViDvGA3LEr4O7crdLHlloDqZnbqFzSsxw2kE4BXx/JkyuVNzXf99X5DAF+duc/g
         9ZQ4V4BForbL5B0uNFujxQmboQDCWyVqB/Z1z6I8SEalMKHLHqkI4f9ZHbXtA73XXLkr
         Sj/xVuimoypcmf7X1vQprTSpLTskJds3AhuP2w7whbNprRE4gqpaIyrTksS+z9lPyS1H
         mPCA==
X-Gm-Message-State: ANoB5pnOsK3oJq8eZpZPa8WLh9meMbWCQKmBhD5LwzEh8HI2cqTKtfJj
        llP1qFqfDif+jf4q3B6CD9x8X5xAPu2IOpVlg+pDIw==
X-Google-Smtp-Source: AA0mqf41kgnKvInoyBS5vu6QjZ1R1Il8TXVYuPHMKUkw+jmRBvME7aS0GGcwt5kdjaNlrGaSplfpKS1gsY129KcutJA=
X-Received: by 2002:a25:97c4:0:b0:6f0:7d2e:1a73 with SMTP id
 j4-20020a2597c4000000b006f07d2e1a73mr23493546ybo.397.1669635346355; Mon, 28
 Nov 2022 03:35:46 -0800 (PST)
MIME-Version: 1.0
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CAM0EoMnw57gVb+niRzZ-QYefey4TuhFZwnVs3P53_jo60d8Efg@mail.gmail.com> <PH0PR13MB47931C1CBABDD4113275A2A994139@PH0PR13MB4793.namprd13.prod.outlook.com>
In-Reply-To: <PH0PR13MB47931C1CBABDD4113275A2A994139@PH0PR13MB4793.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 28 Nov 2022 06:35:35 -0500
Message-ID: <CAM0EoMmPjXvfeGo47KN_rAg-HsFMqK2yku4_BHu0M6G1VH48Pw@mail.gmail.com>
Subject: Re: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
To:     Tianyu Yuan <tianyu.yuan@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Marcelo Leitner <mleitner@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
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

On Mon, Nov 28, 2022 at 3:56 AM Tianyu Yuan <tianyu.yuan@corigine.com> wrot=
e:
>
> Hi Jamal,
>
>
> When no action is specified, there should not be gact with PIPE, rather t=
han a gact with drop, like:
>

Thanks for the example dumps. I think you should put them in your commit lo=
gs.

[..]

>
> About the second scenario of PIPE alone, I don=E2=80=99t think it should =
exist.
> Besides this adding a PIPE at the first place of a tc filter to update th=
e flow stats, another
> attempt that directly store the flower stats, which is got from driver, i=
n socket transacted
> with userspace (e.g. OVS). In this approach, we don=E2=80=99t have to mak=
e changes in driver. Which
> could be a better solution you think for this propose

I was thinking about a case of a filter with no actions but with
interest in a counter for that match.

i.e pseudo-tc-dsl as:
tc filter add ... flower blah action count

which translated is:
tc filter add ... flower blah action pipe

cheers,
jamal
