Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1EA20F355
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 13:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732825AbgF3LEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 07:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729924AbgF3LEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 07:04:04 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51776C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 04:04:04 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f8so9670644ljc.2
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 04:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:to:cc:subject:from:date:message-id
         :in-reply-to;
        bh=4dJaKUDqdDWKdmokAg7F0B7ARIJTMxuq+5UR6gzHE3k=;
        b=dh+3OmKU9ngFdFbqnCSn3klewYl/HsHAHByudyzxriSzUrzHtgdfqTvt4roFZmYvUG
         BXSJEarzn8XLTGiiN7li8MlVhjtWN+NEWki9o4iYC7a4t4xRSJG6X+pdpvk+q+SrxlPG
         l4+h9+5xVwpoDhFfv8/j35Rbe5n34F3nYoQTmugYUpSMefYOo/8EsQVZ6bScNYKvXKCh
         7uAiLTQysVD6k3UzXUxZRJ7DL1y8JA0akgfLIUT8MvD2ArEOkKDm+uGoM6WsXqciybAw
         0WRZxi1WSncLuA6R/EEMaOtKW7hfU3sRKjNOVZ0RaDLjeT60cikiBr6wqUlc1AgObw14
         dD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:to:cc:subject:from
         :date:message-id:in-reply-to;
        bh=4dJaKUDqdDWKdmokAg7F0B7ARIJTMxuq+5UR6gzHE3k=;
        b=pYEGuB3WJsfjyK8OzuJ5VCyrEB+FfWY2Tb/JU0bt2fcjiuflYjsqgE87Qca/NHN62M
         TkrAn+0qrx8i87Y3tKptbRrB/L2WidCNdgxzoSoVzb1bVJ5D2PCkWKRt3uBSHxHj6+8s
         RSVt0AlUFeKh6xY/x60NKKxVO1ekNZnFh1QTpSA22JcIZIGCZ+db5fjC0LJz+heOPrmv
         qj4FeGvvjKxMcBoV7gcjLdDNNmqx5hmr3DT0FLOaw7F9kF34BEvXSqDvNTnl4FIkGhVl
         EQOMV+8byc+SxtZrobUmJPnIcWeY72SdCf1Y+pRDeYzY3OW5p5EQ0sXKko1nwlyS3SH5
         8CiQ==
X-Gm-Message-State: AOAM530oOwBS7CuRI0Fc7bCoKV2/vOUBsnkck0hcl5+o8nBkWVCv9rX/
        TVGn+BUGaxzi6Jy+AVXEKI6YMxbDnjc=
X-Google-Smtp-Source: ABdhPJw8urKwxq87ytyJjRnrEBdBJMneyBzmvKxkgoKwSZxiY2JiUjDu9Y4fHjMcM6xQNuaBWKqo7w==
X-Received: by 2002:a2e:808d:: with SMTP id i13mr7033265ljg.452.1593515041794;
        Tue, 30 Jun 2020 04:04:01 -0700 (PDT)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y3sm619613ljk.39.2020.06.30.04.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 04:04:00 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To:     "Andy Duan" <fugang.duan@nxp.com>,
        "David Miller" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
Date:   Tue, 30 Jun 2020 13:01:54 +0200
Message-Id: <C3UDW5NW0479.2LD6LMUDKPVGN@wkz-x280>
In-Reply-To: <AM6PR0402MB36074675DB9DBCD9788DCE9BFF6F0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Jun 30, 2020 at 11:47 AM CEST, Andy Duan wrote:
> Tobias, sorry, I am not running the net tree, I run the linux-imx tree:
> https://source.codeaurora.org/external/imx/linux-imx/refs/heads
> branch=EF=BC=9Aimx_5.4.24_2.1.0
> But the data follow is the same as net tree.

Ok, I'll build that kernel and see if I get different results. Would
you mind sharing your kernel config?
