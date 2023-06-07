Return-Path: <netdev+bounces-9011-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BCE472688F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:24:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27A302814DE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F41739234;
	Wed,  7 Jun 2023 18:22:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A4839226
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 18:22:04 +0000 (UTC)
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA00273F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:21:39 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1a3136fd194so2546401fac.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 11:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686162095; x=1688754095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2QBJwnvgby8wO2gP26SNNLUvVxEfkb0WLd9Kh+mDTQ=;
        b=LXEUp2oBK8r7+vHVBcQYFcgeAGHeqSO1dsY9MEqM9E7IZUuozlEVYUAdUWa58WMc65
         W8M7cUt9ERBeScXRsBCchj4s0mzNAc6pKt6SaDkYQIaz/JzAQwtN0U8IVN1/EaOl4eB4
         aXo+/Bn//19kNM2WdG1l7hvSoDf5VIgBV1RgGlYUfbhBIg1J5z9rsQA9i0303mJ6zDk+
         UvYPvLQhniReoR3NPYlyryF3wAiFyr+UA87Wx+YjoXVRSg8UTIOa0I2WQC3XNxu2aKci
         7NgZ75oGEdRn669p2HavZGM/8meLv2nvVTF5Bi7GLL3oAIlo86m9X4e4EG5EFk9YmGQM
         pn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686162095; x=1688754095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R2QBJwnvgby8wO2gP26SNNLUvVxEfkb0WLd9Kh+mDTQ=;
        b=LeHwITBRJqQ7+q5cDAcaexW2pWPrv0BsJ7iJX5jPczz/NSRBnwdp5gccNj27N+5mU/
         S8BTFcxJPqfu7lyQKC+7fLWx8GiNSfokE+bJ9nw4Dn8K43kG1IYxAc7/eWFG20xl0x0r
         efq92sUqba6apD7bGf4du9C2SDw1nM1ZYMu2LIaqetWm58MWVRLA+diYxe3a7yY+jUn+
         gc81xWeZTbA/5f/bmCTLURnHt+HM2lvTemB7qqJR2sHJSVKVMrZ9rOOQwsxanRZ30q/0
         pzzhQgMt32MZMvhmFUOgO/HsRSDlfWr+ZY7WWkZ3nEBI1w4b68oORJdHR3GCXPjZ9Ix+
         Io4A==
X-Gm-Message-State: AC+VfDz85nvvYiH53JzxvTY6pw+DOWOzKNPgdnmrjnUJRG5PstJB1+oZ
	WFk4S8SaDqxZzFumcmHnZ3Uqymn0vo3/iBt427o=
X-Google-Smtp-Source: ACHHUZ4Dd6HkqgKf7RCNMXUxJRvfkA/mvbcmEaZrK/tI2N7U2oSRqNLrapC3zb7lwMVO0Akyv3GgRK6MyniZJDqpZxM=
X-Received: by 2002:a05:6358:be87:b0:129:c3fc:ff5c with SMTP id
 di7-20020a056358be8700b00129c3fcff5cmr1208715rwb.24.1686162094962; Wed, 07
 Jun 2023 11:21:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
 <20230530234501.2680230-6-anthony.l.nguyen@intel.com> <20230531232239.5db93c09@kernel.org>
 <3fe3bf2a-6cb2-c3a1-3fa3-ed9a5425e603@intel.com>
In-Reply-To: <3fe3bf2a-6cb2-c3a1-3fa3-ed9a5425e603@intel.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 7 Jun 2023 20:20:57 +0200
Message-ID: <CAF=yD-KAQceDE9UmJAvepz8tWGgqyr+drv_WYp-q=7vEEUTfiA@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] idpf: add create vport and netdev configuration
To: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net, pabeni@redhat.com, 
	edumazet@google.com, netdev@vger.kernel.org, emil.s.tantilov@intel.com, 
	jesse.brandeburg@intel.com, sridhar.samudrala@intel.com, 
	shiraz.saleem@intel.com, sindhu.devale@intel.com, willemb@google.com, 
	decot@google.com, andrew@lunn.ch, leon@kernel.org, mst@redhat.com, 
	simon.horman@corigine.com, shannon.nelson@amd.com, stephen@networkplumber.org, 
	Alan Brady <alan.brady@intel.com>, Joshua Hay <joshua.a.hay@intel.com>, 
	Madhu Chittim <madhu.chittim@intel.com>, Phani Burra <phani.r.burra@intel.com>, 
	Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>, 
	Krishneil Singh <krishneil.k.singh@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 1:48=E2=80=AFAM Linga, Pavan Kumar
<pavan.kumar.linga@intel.com> wrote:
>
>
>
> On 5/31/2023 11:22 PM, Jakub Kicinski wrote:
> > On Tue, 30 May 2023 16:44:51 -0700 Tony Nguyen wrote:
> >> @@ -137,8 +210,12 @@ static int idpf_set_msg_pending_bit(struct idpf_a=
dapter *adapter,
> >>       * previous message.
> >>       */
> >>      while (retries) {
> >> -            if (!test_and_set_bit(IDPF_VC_MSG_PENDING, adapter->flags=
))
> >> +            if ((vport && !test_and_set_bit(IDPF_VPORT_VC_MSG_PENDING=
,
> >> +                                            vport->flags)) ||
> >> +                (!vport && !test_and_set_bit(IDPF_VC_MSG_PENDING,
> >> +                                             adapter->flags)))
> >>                      break;
> >> +
> >>              msleep(20);
> >>              retries--;
> >>      }
> >
> > Please use locks. Every single Intel driver comes with gazillion flags
> > and endless bugs when the flags go out of sync.
>
> Thanks for the feedback. Will use mutex lock instead of 'VC_MSG_PENDING'
> flag.

Was that the intent of the comment?

Or is it to replace these individual atomic test_and_set bit
operations with a single spinlock-protected critical section around
all the flag operations?

That's how I read the suggestion.

