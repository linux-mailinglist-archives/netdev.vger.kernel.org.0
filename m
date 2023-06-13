Return-Path: <netdev+bounces-10428-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0E972E6B5
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6F2A1C20CB6
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297233B8B8;
	Tue, 13 Jun 2023 15:08:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E41C3B8B7
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 15:08:22 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9820173C;
	Tue, 13 Jun 2023 08:08:20 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-977d7bdde43so1150717766b.0;
        Tue, 13 Jun 2023 08:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686668899; x=1689260899;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E4q8adGwxP9RYL6Vu3j2Y5B/9TiS66xoysba9qM6aQE=;
        b=hcSwsE9PzOYN9O5abXdqmabZ58t+8RxBrj8ppWrnu8gAZAYHkwSe408mCYnJg+vkZC
         xdwGLzzyHRtT5OdYDGLGHQWWMP7AmhHd1lhhwK/wqklZbYGtf6MREWj1bnVzRP/CoVai
         ZOF17lGRw7baUP0UpNFK7ym2XGGQwVcqRhuZlYCi3xUSNNyuV9FWvbMEzRgYam8wpKOs
         K/Xr4YwUb3FCv5WQvjdheckRnIpQYb1hfJA3naknTArhzNmhu1Vd7UqCtGFwxq1M6HSR
         yv0scS1291VRLS8sQWHq+88sx1XO5/9UV2bx747a98ErN2A76J+VgHYsOmzqkAB3AaK9
         u4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686668899; x=1689260899;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E4q8adGwxP9RYL6Vu3j2Y5B/9TiS66xoysba9qM6aQE=;
        b=Cu6tPX4oQjDh+8u9NXu7o72ioR5SgKrjXGUiD+6jJiGzf/kFwwwPZpY5QdgqjmDYBv
         GDEtn30qFV58laKjfUD3QXH6GViSULwfO56YZiQ4jIKTrOFi7RmjFI6Od8U/0UDtW97/
         RBjVMwImNwtx6/0P8AXa2k9H+g+tKaxukS7GrDp6jyUz+NNcbI2K7QRksdiVZs5mca3X
         pDwvU7hMFZRFotygWGai9Q3bIaM7jUVl7wiSWsN/M6xJoTuK5Re3og8fVyqwOxsvb+/R
         xDpA4mitjKAYJM1sTOU0pXXczMzFasnJXGV/rVrzcR/7X332gKMKsldLIdl63UOWC90G
         9tbw==
X-Gm-Message-State: AC+VfDx+7ErQiqVCFLeHx4EuCDKhD1IHvMIJI/wKZCuPzeUHLtQb0kMG
	70cChMvYodCXU1Pb4t75FNXHaKdOCcyVYA==
X-Google-Smtp-Source: ACHHUZ7BRSngSE3pUQl7PfAVn9vk1KT0aL5TEihMP8aZralFWsbXNqoJNu+UOZk1g1MQH+CqxCy1xw==
X-Received: by 2002:a17:907:7d92:b0:969:9c0c:4c97 with SMTP id oz18-20020a1709077d9200b009699c0c4c97mr13123946ejc.1.1686668899039;
        Tue, 13 Jun 2023 08:08:19 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z10-20020aa7c64a000000b00514bcbfd9e0sm6585832edr.46.2023.06.13.08.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 08:08:18 -0700 (PDT)
Date: Tue, 13 Jun 2023 18:08:15 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc9.unal@gmail.com>
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
Message-ID: <20230613150815.67uoz3cvvwgmhdp2@skbuf>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <20230611081547.26747-2-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230611081547.26747-2-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 11:15:42AM +0300, Arınç ÜNAL wrote:
> The CPU_PORT bits represent the CPU port to trap frames to for the MT7530
> switch. This switch traps frames to the CPU port set on the CPU_PORT bits,
> regardless of the affinity of the user port which the frames are received
> from.
> 
> When multiple CPU ports are being used, the trapped frames won't be
> received when the DSA conduit interface, which the frames are supposed to
> be trapped to, is down because it's not affine to any user port. This
> requires the DSA conduit interface to be manually set up for the trapped
> frames to be received.
> 
> To fix this, implement ds->ops->master_state_change() on this subdriver and
> set the CPU_PORT bits to the CPU port which the DSA conduit interface its
> affine to is up. Introduce the active_cpu_ports field to store the
> information of the active CPU ports. Correct the macros, CPU_PORT is bits 4
> through 6 of the register.
> 
> Add comments to explain frame trapping for this switch.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

My only concern with this patch is that it depends upon functionality
that was introduced in kernel v5.18 - commit 295ab96f478d ("net: dsa:
provide switch operations for tracking the master state"). But otherwise
it is correct, does not require subsequent net-next rework, and
relatively clean, at least I think it's cleaner than checking which of
the multiple CPU ports is the active CPU port - the other will have no
user port dp->cpu_dp pointing to it. But strictly, the master_state_change()
logic is not needed when you can't change the CPU port assignment.

It might also be that your patch "net: dsa: introduce
preferred_default_local_cpu_port and use on MT7530" gets backported
to stable kernels that this patch doesn't get backported to, and then,
we have a problem, because that will cause even more breakage.

I wonder if there's a way to specify a dependency from this to that
other patch, to ensure that at least that does not happen?

