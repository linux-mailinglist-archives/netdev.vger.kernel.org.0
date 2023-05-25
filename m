Return-Path: <netdev+bounces-5382-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC64710FBF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13E6B1C20ECA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5692419BAF;
	Thu, 25 May 2023 15:38:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471301952A
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:38:08 +0000 (UTC)
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7FC99;
	Thu, 25 May 2023 08:38:07 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id 71dfb90a1353d-456f7ea8694so237357e0c.0;
        Thu, 25 May 2023 08:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685029086; x=1687621086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9d5HraNv7RlWulERyCsylj00zboFv7KU4ycsvo9n/0=;
        b=TZzb5+2/XZxAz9DJKwqmMw7eEONON3ZLhRN2IzIcwwV8U/9lRUVWaoqY3P9GL/EGbk
         lHycfck0D0xnwuf9zv3933Jz3UjhS9mM0YLFQOqWRHju0zNrBLfCT4agxSQk/Af755vY
         hfruqStbC4UQDilS0swaaLIKFT+dIt5lICIDi0E1Oxglx0UBDioJ2XjBvSmhE+C0UA5H
         j9RebkYy8DQqCRnuTv7IOx8l/jXGxTmc5vUtqhwsYttr1xrCSQ9LpUN2fLTOzXDUC6sQ
         bYIIeVqT7AggfNtyCtK7cJ6vTFtlpTN3e2efPD/vZWZAJ4ad4DWxCNbuzCHyw06eGw6P
         f/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685029086; x=1687621086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9d5HraNv7RlWulERyCsylj00zboFv7KU4ycsvo9n/0=;
        b=COyK/rgmq0air5TrClTvsbA/PczhWJaoJ8bhb+l1eoiqGegpVUCn73uHvgnDnI+req
         WO6o3ceLWyPSvsAfijoYmIiEvh48Afba1fdUPAajiSNKxhej078VEfM9bMPjzJi+XOwF
         J+qJqw9fh/2AiPHEWtyiaGcnGc1rIAcrURz6hatT6wrek3Trog5Fn2nSWHGaj7SyFJ94
         Hvi8qlA8wj1SVjXM3KZkHjma2fSoELqHuVdyjE/KqRHVGmGMAb4dDC6PI0FtrfHMASyA
         R0y81aPty+GIi96R25nrtqHemiNlOAUfxnDibLLeq9oskMshzFXMcdx11Ivh5JfiLVD8
         +MaA==
X-Gm-Message-State: AC+VfDzKTYAgn2VSc9MTKCXmB+bNsbl1qsm5B4i8RAvJaMe1BqtzcmQS
	Sd97SCQ4ehk3oQB9kHHPBvqK3vM06cNYAPqqh3s=
X-Google-Smtp-Source: ACHHUZ7GgANnM2SaBGxcq1S0uMC0DIpsfaSw0ggHBRlPsSoDmq9Ip+hZNqc6c3RHcrhX/tGb2TnYqeP+dE8yzmGi2A8=
X-Received: by 2002:a1f:5584:0:b0:450:a3:7c2e with SMTP id j126-20020a1f5584000000b0045000a37c2emr5960444vkb.7.1685029086050;
 Thu, 25 May 2023 08:38:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230523223944.691076-1-Kenny.Ho@amd.com> <01936d68-85d3-4d20-9beb-27ff9f62d826@lunn.ch>
 <CAB9dFdt4-cBFhEqsTXk9suE+Bw-xcpM0n3Q6rFmBaa+8A5uMWQ@mail.gmail.com>
 <c0fda91b-1e98-420f-a18a-16bbed25e98d@lunn.ch> <CAOWid-erNGD24Ouf4fAJJBqm69QVoHOpNt0E-G+Wt=nq1W4oBQ@mail.gmail.com>
 <5b1355b8-17f7-49c8-b7b5-3d9ecdb146ce@lunn.ch> <CAOWid-dYtkcKuNxoOyf3yqSJ7OtcNjaqJLVX1QhRUhYSOO6vHA@mail.gmail.com>
 <30d65ea9170d4f60bd76ed516541cb46@AcuMS.aculab.com> <CAOWid-eEbeeU9mOpwgOatt5rHQhRt+xPrsQ1fsMemVZDdeN=MQ@mail.gmail.com>
 <81d01562a59a4fb49cd4681ebcf2e74a@AcuMS.aculab.com>
In-Reply-To: <81d01562a59a4fb49cd4681ebcf2e74a@AcuMS.aculab.com>
From: Kenny Ho <y2kenny@gmail.com>
Date: Thu, 25 May 2023 11:37:54 -0400
Message-ID: <CAOWid-d=OFn7JS5JvsK9qc7X6HeZgOm5OAd1_g2=_GZgpKRZnA@mail.gmail.com>
Subject: Re: [PATCH] Remove hardcoded static string length
To: David Laight <David.Laight@aculab.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Marc Dionne <marc.dionne@auristor.com>, 
	Kenny Ho <Kenny.Ho@amd.com>, David Howells <dhowells@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:04=E2=80=AFAM David Laight <David.Laight@aculab.=
com> wrote:
> But isn't UTS_RELEASE usually much shorter?
> I think it is what 'uname -r' prints, the longest I've seen recently
> is "3.10.0-1127.19.1.el7.x86_64" - well under the limit.

Usually yes, but I believe LOCALVERSION can be appended to
KERNELRELEASE / UTS_RELEASE which can makes it much longer.

> > "The standard formulation seems to be: <project> <version> built
> > <yyyy>-<mm>-<dd>"
>
> Which I don't recall the string actually matching?
> Also the people who like reproducible builds don't like __DATE__.

That's correct, it was not matching even when it was introduced.  I am
simply taking that as people caring about the content and not simply
making rxrpc_version_string =3D=3D UTS_RELEASE.  The current format is:

"linux-" UTS_RELEASE " AF_RXRPC"

Kenny

