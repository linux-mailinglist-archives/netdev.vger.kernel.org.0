Return-Path: <netdev+bounces-4587-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 417A970D4DF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9325C1C20C69
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940D11D2D1;
	Tue, 23 May 2023 07:24:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891B11B8F2
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:24:31 +0000 (UTC)
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895E511A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 00:24:04 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-62387baa403so20599586d6.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 00:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ipng.nl; s=google; t=1684826643; x=1687418643;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BQYrNouzFNu6KqiawdxoaH9GsQNTlNIV0Lh///oQLE0=;
        b=Ux5PmxA5f7+L2byh3CB82c12Nqz6qOUuyB3bVbRO9eE6lyNum5bljqp1Amn17kSGsK
         HWPH3PDbilnG5RVc/hGNQlESz1i7VREsjLcM7R02VxDYFTXhjqrL9YQoPjUrZDj32UQL
         jyStfqSnWcGago4ySVxsX/9coEDFQ+aQc/C2o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684826643; x=1687418643;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BQYrNouzFNu6KqiawdxoaH9GsQNTlNIV0Lh///oQLE0=;
        b=PnIykUwGvcQtpXSNX5LpQMSaHvL3SfLBtTxlYEKoq6PrsYUCW9DMny/4sxX+U/dF2U
         C85Dy6dDaR6yv5Q0HhwSOHXygqRG2QBZhQHRM6W6+ZsjI2q3WutqrQhElIROhdzMtcM5
         tIXmEsHZ+2ygDfJgHYRtMObVfyuzVIPBB+7jccR34psNM+0bp3EYZw+UY3l371DbaXSE
         dpqaesM2daurIcKmsuQonjTnAuM22Qm5mQqsB33sADDdi30GMEOUFhYfkj0MSdpq5Mqg
         vOYjKrB9Uk7vlx25OPoj9OKeptt5DMK+/0S+E6gL16NPMe5dqan7ZhRdYRQlrFWpzmJw
         fDEQ==
X-Gm-Message-State: AC+VfDxULhH6417324U3meBR0ZU/m+EIxsf1Npvu8o0hJQCOvuV6P5PD
	Ehd5D74IhLvqibUfEDVdHVtW8Vy+abAfydWQ/OBLO8gtyUdpSbwkDE4=
X-Google-Smtp-Source: ACHHUZ6g86B1M8Pp3MkHsP3Asu3tPfN9mVpja9TfOMBLcC2LvPGN7LyB7FyvCOrtg6bGjNaoRjnlWd9vXsTOgZnft0k=
X-Received: by 2002:a05:6214:401d:b0:616:859a:471a with SMTP id
 kd29-20020a056214401d00b00616859a471amr22581666qvb.17.1684826643502; Tue, 23
 May 2023 00:24:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Pim van Pelt <pim@ipng.nl>
Date: Tue, 23 May 2023 09:23:52 +0200
Message-ID: <CAEnbrFkS+Ruo9HoXBOtqdZDSYzBYOLOKz+BPnwQYN+dGKb_aTA@mail.gmail.com>
Subject: Showing NLM_F_REPLACE in ipmonitor.c
To: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hoi folks,

I'm a developer over at fd.io's vector packet processer, and
contributed a netlink controlplane listener there back in 2021. I was
debugging an issue between Bird2 and VPP with respect to netlink
messages that sometimes are create and sometimes are replace
(NLM_F_REPLACE), and noticed that ipmonitor.c does not make the
distinction between the two. Context in [1].

I thought it would be useful to signal replace in the following diff
[2], possibly for route, neighbor and nexthop messages, as they
commonly mix NLM_F_CREATE with NLM_F_REPLACE. Would adding (something
like) this be possible, so observers can tell the difference between
the two ?

groet,
Pim

[1] https://lists.fd.io/g/vpp-dev/message/23054 and
http://trubka.network.cz/pipermail/bird-users/2023-May/016946.html
[2] https://github.com/shemminger/iproute2/pull/68/commits/47c8a034bebbc553045273da857a68256635e9ff
-- 
Pim van Pelt <pim@ipng.nl>
PBVP1-RIPE - http://www.ipng.nl/

