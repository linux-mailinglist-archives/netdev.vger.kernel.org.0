Return-Path: <netdev+bounces-9142-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91031727758
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 08:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC1A41C20FD4
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 06:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8E346BD;
	Thu,  8 Jun 2023 06:37:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5A4EA3
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:37:05 +0000 (UTC)
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3B72717;
	Wed,  7 Jun 2023 23:36:58 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
	(authenticated bits=0)
	by dilbert.mork.no (8.17.1.9/8.17.1.9) with ESMTPSA id 3586aLIb1511367
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Thu, 8 Jun 2023 07:36:22 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:964:4b0a:9af7:269:d286:bcf0])
	(authenticated bits=0)
	by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 3586aFRb1374861
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Thu, 8 Jun 2023 08:36:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
	t=1686206176; bh=o4taXXBgL3fitDlVeOrhKNo+T/8XA6xGhb9a2DaU7/8=;
	h=From:To:Cc:Subject:References:Date:Message-ID:From;
	b=K2m/7ZGh4kwqBALF0znIdFmzTbV76KVH0Vwha4mUjXdxtvFQMQwwOZEmRVrSboxu+
	 tjdrzPLHpnBxMGxQriDwg84jO2Kads2Oqgh5TBjPlMY05jdYJNU0BWnlcaaKMFUv6t
	 wR8kNYMjM8+YdmKZqSZEEAqnsOPQrQiKObilTuGc=
Received: (nullmailer pid 1642711 invoked by uid 1000);
	Thu, 08 Jun 2023 06:36:10 -0000
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Wes Huang <wes155076@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wes Huang <wes.huang@moxa.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH V2 1/1] net: usb: qmi_wwan: add support for Compal RXM-G1
Organization: m
References: <20230608030141.3546-1-wes.huang@moxa.com>
Date: Thu, 08 Jun 2023 08:36:10 +0200
In-Reply-To: <20230608030141.3546-1-wes.huang@moxa.com> (Wes Huang's message
	of "Thu, 8 Jun 2023 11:01:42 +0800")
Message-ID: <87jzweihph.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.8 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wes Huang <wes155076@gmail.com> writes:

> From: Wes Huang <wes.huang@moxa.com>
>
> Add support for Compal RXM-G1 which is based on Qualcomm SDX55 chip.
> This patch adds support for two compositions:
>
> 0x9091: DIAG + MODEM + QMI_RMNET + ADB
> 0x90db: DIAG + DUN + RMNET + DPL + QDSS(Trace) + ADB

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

