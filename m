Return-Path: <netdev+bounces-9745-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF47972A62F
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 00:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 272751C20A7A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B285124124;
	Fri,  9 Jun 2023 22:13:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E86823403
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 22:13:05 +0000 (UTC)
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78F93588
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:13:03 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-25691a1b2b8so826145a91.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 15:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686348783; x=1688940783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aj3qxlePjXwuS4HBA07UIRS79a1AWg76ztzUwiI0tlA=;
        b=Ih+NyZL3T6Zg0oXbu0VfFj9qxnVcz08v8Ny2LnZ9uWx2hkmYk2UNB/YufdVR6g/kn+
         Ifu0M4zxQd0iHF9YgzlKzE7msMe/nmL9/aKq2Bbt0EBvkoy4AJDdVbRnvnlTihuve9JA
         SBpuMz2N/M3hxmt9jK99Y4THxnpqfqIdsr3of4uAcH67ZdeRITt0T75nHpNikne93Gwq
         F4QjFt5vKYawtdVAyoc5TU0g8QvVnTX44dJMBJClto2XcSt/yeQ0Qzz+dEMJ3ypAMr7T
         oNFMk6IIBjHm/qLjwmGfdqgDzFA/IXr0XLCfnJ7n7CiMXnBg+YMtN6vbdShV+4VbBIaG
         sYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686348783; x=1688940783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aj3qxlePjXwuS4HBA07UIRS79a1AWg76ztzUwiI0tlA=;
        b=dpVPyUNOMcL2Qan5a3QlVDd0ijtFtndaoeDR3nViIUw0nJwE/SCAZnyvgeuPS3tWIM
         DnU26YH0XLE3eGN5SziHfcvmUuu/tkQN9mSM0ds0jqSQ05WfI1NOV2fYaZ/wKao771tg
         j0OIQT92KWLJix8sIZPk1k9ntXcmw0DSEK+ZrrlyLfk4HYZfYll4MkvWNEhVbUhX3fVp
         c9tBf+KJ29dBBTRJHPw/yAsczekfwBC6zgaxRFfHClQkeeAqGGUt0adLwMGUIcfsM8UC
         xbqANAVNpmxfeH4Z8Mjgaotqe2TlRVFDWlSwMRZzAotgCkSKtlmJbyid18KcKcoZHCrJ
         cH2w==
X-Gm-Message-State: AC+VfDxggVdBeWW5fBC1aNUos8QR7Mzhwe3OLqVWoXHNNbTSC4V2/ja4
	d7XZyqBupyNF1TXyobKG9Pu3gX6aAuXR7TerRfK2lD2kZjMB4c40WQQZBw==
X-Google-Smtp-Source: ACHHUZ6LsBWiXQ0Z+6Ulbgfdva0mwFulBYWPBQXp5K7erJYSBEvn2f93U/dmyHYcxGPDK+L+oIZNvi9uogfPi6DkixQ=
X-Received: by 2002:a17:90a:13:b0:259:a879:cb8f with SMTP id
 19-20020a17090a001300b00259a879cb8fmr2006895pja.7.1686348783120; Fri, 09 Jun
 2023 15:13:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609214346.1605106-1-kuba@kernel.org>
In-Reply-To: <20230609214346.1605106-1-kuba@kernel.org>
From: Stanislav Fomichev <sdf@google.com>
Date: Fri, 9 Jun 2023 15:12:51 -0700
Message-ID: <CAKH8qBtDgxEdvPX_jZW431x4jB7dksA4fRS+cqGHVL+Favampw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/12] tools: ynl: generate code for the ethtool family
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com, 
	pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 2:43=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> And finally ethtool support. Thanks to Stan's work the ethtool family
> spec is quite complete, so there is a lot of operations to support.
>
> I chickened out of stats-get support, they require at the very least
> type-value support on a u64 scalar. Type-value is an arrangement where
> a u16 attribute is encoded directly in attribute type. Code gen can
> support this if the inside is a nest, we just throw in an extra
> field into that nest to carry the attr type. But a little more coding
> is needed to for a scalar, because first we need to turn the scalar
> into a struct with one member, then we can add the attr type.
>
> Other than that ethtool required event support (notification which
> does not share contents with any GET), but the previous series
> already added that to the codegen.
>
> I haven't tested all the ops here, and a few I tried seem to work.
>
> Jakub Kicinski (12):
>   tools: ynl-gen: support excluding tricky ops
>   tools: ynl-gen: record extra args for regen
>   netlink: specs: support setting prefix-name per attribute
>   netlink: specs: ethtool: add C render hints
>   tools: ynl-gen: don't generate enum types if unnamed
>   tools: ynl-gen: resolve enum vs struct name conflicts
>   netlink: specs: ethtool: add empty enum stringset
>   netlink: specs: ethtool: untangle UDP tunnels and cable test a bit
>   netlink: specs: ethtool: untangle stats-get
>   netlink: specs: ethtool: mark pads as pads
>   tools: ynl: generate code for the ethtool family
>   tools: ynl: add sample for ethtool
>
>  Documentation/netlink/genetlink-c.yaml      |    4 +
>  Documentation/netlink/genetlink-legacy.yaml |    4 +
>  Documentation/netlink/specs/ethtool.yaml    |  120 +-
>  tools/net/ynl/generated/Makefile            |    9 +-
>  tools/net/ynl/generated/ethtool-user.c      | 6353 +++++++++++++++++++
>  tools/net/ynl/generated/ethtool-user.h      | 5531 ++++++++++++++++
>  tools/net/ynl/lib/nlspec.py                 |   12 +-
>  tools/net/ynl/samples/.gitignore            |    1 +
>  tools/net/ynl/samples/ethtool.c             |   65 +
>  tools/net/ynl/ynl-gen-c.py                  |   59 +-
>  tools/net/ynl/ynl-regen.sh                  |    4 +-
>  11 files changed, 12116 insertions(+), 46 deletions(-)
>  create mode 100644 tools/net/ynl/generated/ethtool-user.c
>  create mode 100644 tools/net/ynl/generated/ethtool-user.h
>  create mode 100644 tools/net/ynl/samples/ethtool.c

Exciting! Clicked through the series, everything makes sense:
Acked-by: Stanislav Fomichev <sdf@google.com>

Cable tests are yucky.

