Return-Path: <netdev+bounces-7205-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6826071F0E4
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDBA61C210C1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC4947016;
	Thu,  1 Jun 2023 17:37:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF1647014
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:37:46 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6022C189
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:37:45 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d57cd373fso1864051b3a.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 10:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685641065; x=1688233065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3VaooKom1fpr+/gFLUK2ePWF2zVhCHZPLzAcFMttDEM=;
        b=MHSqsckRCpeDoAGkYMTNaUf8HXTi7i1vORvFkCxMTEUbOwF3hDPYiDc7fFQMPlAq2F
         cXQdYOZneqJDanRwrJGT5TiAw3lSbDh/dzwSjw6g4CmcRcd2jULq+fPI64PC3km0AJ8o
         2PjBMI8jyygfqWvpj/9HPpCKdpPk7v0MskmbjN6d7QCnag4DGEbtq3amlJSeDTwYc3zT
         c0cV9wX4QJgURi4YJnSboQbChb1aZWzL1hvpMQc5EufEqPm6+DIaJwCYZOZ6FWPWEgmi
         1vId6smHDNqp1/Et5J7vtutwuBFt7gM/c2cO7oARrjPxprOFoTUBsByAcCb0gBVMlPmH
         8rkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685641065; x=1688233065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3VaooKom1fpr+/gFLUK2ePWF2zVhCHZPLzAcFMttDEM=;
        b=AR/LG4il++i4oJb4zjN5XsGqRo+HZEIUkIUkOup3qIF7HCHalRFUhc9zq0GtAJUTje
         UTGz1J2qL++uf66zduems9YM3uzvHC4g8peLCjxJtD897acVDtimY8PTZ7D+sku3vHmp
         BW4DxUys3ArAYRd5dyOyGD26mv5TgECWPPCOzbv5C7n/NoGI1ZDqTjS77mp60ZqHplm0
         L0z1zytZHFqC+S+AX/Yc+Xs8gHKxDnBLvuoPvUyZkCfgPFBfL7VqvoWTkR0gVZTBQwj0
         5BefT50N3WQaRzwzJ5hTZ4oyASpgvIMVLGEPkSZJKG4x8rHRQffX2yLw/paYkd8GYOdJ
         GM5Q==
X-Gm-Message-State: AC+VfDyFIfA3SwS0UWLKHfED4q7cFYvf9TFhRfjRsPR2NqgvBweK+mQA
	hYStftdFmqRUuvek9eU23ruRwQ==
X-Google-Smtp-Source: ACHHUZ7z6hqFz0/ybL9ukj5Ma2ElT9E2J0J2UDKTdWLYHsIJgV2YGGUXYubX2wob3APlALw7YS3Uvg==
X-Received: by 2002:a05:6a20:3d87:b0:104:1016:dd0e with SMTP id s7-20020a056a203d8700b001041016dd0emr3075210pzi.3.1685641064841;
        Thu, 01 Jun 2023 10:37:44 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id s13-20020a65644d000000b0053fbacdaf59sm3139207pgv.69.2023.06.01.10.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 10:37:44 -0700 (PDT)
Date: Thu, 1 Jun 2023 10:37:42 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Mat Martineau
 <martineau@kernel.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC] net: skip printing "link become ready" v6
 msg
Message-ID: <20230601103742.71285cf1@hermes.local>
In-Reply-To: <20230601-net-next-skip_print_link_becomes_ready-v1-1-c13e64c14095@tessares.net>
References: <20230601-net-next-skip_print_link_becomes_ready-v1-1-c13e64c14095@tessares.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 01 Jun 2023 16:34:36 +0200
Matthieu Baerts <matthieu.baerts@tessares.net> wrote:

> This following message is printed in the console each time a network
> device configured with an IPv6 addresses is ready to be used:
> 
>   ADDRCONF(NETDEV_CHANGE): <iface>: link becomes ready
> 
> When netns are being extensively used -- e.g. by re-creating netns with
> veth to discuss with each other for testing purposes like mptcp_join.sh
> selftest does -- it generates a lot of messages: more than 700 when
> executing mptcp_join.sh with the latest version.

Don't add yet another network nerd knob.
Just change message from pr_info to pr_debug.

