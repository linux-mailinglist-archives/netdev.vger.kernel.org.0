Return-Path: <netdev+bounces-7523-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D157208BE
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADAA2281A48
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F023B19BAE;
	Fri,  2 Jun 2023 18:03:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21AC332F8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:03:01 +0000 (UTC)
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE43B3;
	Fri,  2 Jun 2023 11:03:00 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-256c8bed212so1120337a91.3;
        Fri, 02 Jun 2023 11:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685728980; x=1688320980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MaBnduWEIwZFnpCcbiASKw0hIUXbEMHiR0zcXJmhHuI=;
        b=NPZeifEavHndt91cofi2/cZORqy0k7+MlO1oOlRpVMi9G7s8AqtphFgvVqlEvupPxf
         85NvJnfJUo3lyZw7a0nz0XM2eCvlmDuCXAtKNn4Yla+R7mKZbZSeM7L5LZKA6wcTuWWF
         sWzEYQ1mQ1661YwEgZgzpF7+HCuaBo+8vQdlO2PglNQKCGEOHasHltMC48TNqkqZApfs
         m7tqxu+bso9Z6u10KOQn2DWbRyaIf7yVFNpbsP9YTp/ps8UKgxcc3t1W8Zol3iZNwfY+
         nbAp1oJ+8vZcVPTcaB6lKLVJA5dd0uqwLXPDWZAIblDKqp/ME401t/8PmJL4/xRfduq5
         uc8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685728980; x=1688320980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MaBnduWEIwZFnpCcbiASKw0hIUXbEMHiR0zcXJmhHuI=;
        b=ELgLpSzpx4H/WFzLppNQF9UEUbYgW2iuJ/DACb3MBbEDN8cGGbvTkX+fjHaO7Kjp/r
         NM6evNyoEMLAZ6C29yNjl/a3H/V9GjPQajyguvBPwm6Ovfznst4IOCTVDe3fB2wmIpxP
         XGl//HwRRWglq+AYyjrkvtzcxL6/IMzb1hl6aURB6+6FTEZTqu8PngZxA/LamU5lRD2x
         /mL3ar4lNQN+QHy0O2OkkOX2kNaF64DhD3TW7I2QEYj0JwK+fr8DAgfyoPUAX1xR7MmC
         bnpSgjovj4SLlE5szsoHIYIpcMGBBhgycWfqI6123f/TFu//4iBkPBKE5gtPTSQTxXR2
         G/4w==
X-Gm-Message-State: AC+VfDxB1612FYDIBZAYU4tkIAIlf65GZBlqDa/IHvXcgqv1B4EixpEC
	sROn9fGSgyNjbx7iXm2PnZKjs6QdvRoKCbDRiTk=
X-Google-Smtp-Source: ACHHUZ5oU8J70MhGTcCdyz4P+fiuZgw6JSjLwg+elJAQjVH8zwzI5HyAKev8rzIMT8hrKFGaYhela0Mk/re+O+LMixs=
X-Received: by 2002:a17:90a:1b05:b0:24b:c580:1ab8 with SMTP id
 q5-20020a17090a1b0500b0024bc5801ab8mr532609pjq.40.1685728979752; Fri, 02 Jun
 2023 11:02:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
 <135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
 <eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn> <6110cf9f-c10e-4b9b-934d-8d202b7f5794@lunn.ch>
 <f7e23fe6-4d30-ef1b-a431-3ef6ec6f77ba@sangfor.com.cn> <6e28cea9-d615-449d-9c68-aa155efc8444@lunn.ch>
 <CAKgT0UdyykQL-BidjaNpjX99FwJTxET51U29q4_CDqmABUuVbw@mail.gmail.com> <ece228a3-5c31-4390-b6ba-ec3f2b6c5dcb@lunn.ch>
In-Reply-To: <ece228a3-5c31-4390-b6ba-ec3f2b6c5dcb@lunn.ch>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Jun 2023 11:02:23 -0700
Message-ID: <CAKgT0Uf+XaKCFgBRTn-viVsKkNE7piAuDpht=efixsAV=3JdFQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
To: Andrew Lunn <andrew@lunn.ch>
Cc: Ding Hui <dinghui@sangfor.com.cn>, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn, 
	huangcun@sangfor.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 9:37=E2=80=AFAM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > What this change is essentially doing is clamping the copied data to
> > the lesser of the current value versus the value when the userspace
> > was allocated. However I am wondering now if we shouldn't just update
> > the size value and return that as some sort of error for the userspace
> > to potentially reallocate and repeat until it has the right size.
>
> I'm not sure we should be putting any effort into the IOCTL
> interface. It is deprecated. We should fix overrun problems, but i
> would not change the API. Netlink handles this atomically, and that is
> the interface tools should be using, not this IOCTL.

If that is the case maybe it would just make more sense to just return
an error if we are at risk of overrunning the userspace allocated
buffer.

