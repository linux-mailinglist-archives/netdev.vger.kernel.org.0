Return-Path: <netdev+bounces-8317-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A89E723905
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:30:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BE4A2814F1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46CEB8F61;
	Tue,  6 Jun 2023 07:30:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394EF5697
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:30:27 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1814EC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:30:25 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f7024e66adso29145e9.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 00:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686036624; x=1688628624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9e0R8kvpkcQGZ1suFVheePpTIa++meveoUY483U0zAQ=;
        b=ggbaLeEVE8s7htt9DEhQe+51sdK6NvRHRKXRhL4sjalvOBQX5QC0izUn7FUCYkyS4T
         laECJs+e09P8ks8Pt4ZZBgJgUbLew++QD1t/LHX+mz5TbXS8/KlH5Coa+06BSopniEgk
         VZd5pgi8AMcO63X7XrjQlRLOz0+krCr/Q5gC+7DOfKAh/RuWoVGe4ES6/ekBEgJW4Woa
         j76DzE7XA1fhihDrZmzmvDI81KZBBHI3oxGYWSJp2Z2CBjchYN8LUAtanRuo338heTgY
         Tkabi0tAb4GT16woiBX1mm0uBCus3CQf08TmaX1iaSjJF+XAvbzPS/+A8UMSrcMjz3k/
         CDbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686036624; x=1688628624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9e0R8kvpkcQGZ1suFVheePpTIa++meveoUY483U0zAQ=;
        b=dq/GAqN/CGiU0kJBOEiUSnFqtpjKzfH6SdnLeU25Fkqo059PykX05cNPsxyw0iSe0j
         Exgd+JMMNXincDWfiYvHXXXjOkHdPlFbwC/sC0Tc29RsApC4ct5Yp8GBMVSFWK/dve7d
         dDQ/kYTiLIbBz85L8v7GyBSlaEG9YgeEkCve1V2/lYU0YvUHJzmwgtOGRgjQqLX/2fEh
         3hCLQL5vG2TGi/SVekfoGQA8u1LD5gljbwy9ACpXePJSuHK13R3RXhXSJHZB84r+cUHN
         5ffcicCVzmpkIojfbwFVJxMsvOHMp8IYU13ZprlfX/213Yh3M1ugZxaSPgqOC4biPDs+
         4eZA==
X-Gm-Message-State: AC+VfDwWt74dsdEbZ3P2+ruzMx9qIhWlX5uH1X0r7MBOHAxJEXfgLinz
	NEHsytsmdWJ5Eyg4wL0jMnE46YkW9SGDTWlmMKagsA==
X-Google-Smtp-Source: ACHHUZ49BOyqxu+7+96YfaGxxXYlB1Y4UDJQZ1jydiy0tTnzMK/k6B5GEQyPTCdMlklXUCscdyQz0K44VsGmrLZ6kKc=
X-Received: by 2002:a05:600c:3b19:b0:3f7:3654:8d3 with SMTP id
 m25-20020a05600c3b1900b003f7365408d3mr146991wms.2.1686036624008; Tue, 06 Jun
 2023 00:30:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602163141.2115187-1-edumazet@google.com> <20230602163141.2115187-2-edumazet@google.com>
 <20230605155253.1cedfdb0@kernel.org>
In-Reply-To: <20230605155253.1cedfdb0@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 6 Jun 2023 09:30:12 +0200
Message-ID: <CANn89iKhSv981L-WHn=479U2XniQXU0qNX=yoAaWBA1LdY4B4g@mail.gmail.com>
Subject: Re: [PATCH net 1/2] rfs: annotate lockless accesses to sk->sk_rxhash
To: Jakub Kicinski <kuba@kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 12:52=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri,  2 Jun 2023 16:31:40 +0000 Eric Dumazet wrote:
> > +             if (sk->sk_state =3D=3D TCP_ESTABLISHED) {
> > +                     /* This READ_ONCE() is paired with the WRITE_ONCE=
()
> > +                      * from sock_rps_save_rxhash() and sock_rps_reset=
_rxhash().
> > +                      */
> > +                     sock_rps_record_flow_hash(READ_ONCE(sk->sk_rxhash=
));
> > +                     }
>
> Hi Eric, the series got "changes requested", a bit unclear why,
> I'm guessing it's because it lacks Fixes tags.
>
> I also noticed that the closing bracket above looks misaligned.

Right I think Simon gave this feedback.

>
> Would you mind reposting? If you prefer not to add Fixes tag
> a mention that it's intentional in the cover letter is enough.

Yes, I do not think a Fixes: tag is necessary.

I will post a v2 with an aligned closing bracket.

Thanks.

