Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5D111BAD7
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbfLKR6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:58:34 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40542 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731077AbfLKR6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:58:33 -0500
Received: by mail-qt1-f193.google.com with SMTP id t17so7040931qtr.7
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kSgsBNcHLvWJ5Aptf1RcQ8u2LPLH61DVfePEcCW2rEs=;
        b=Ih7eK0YLN/M5rPvW/0j8yVb4nomi1edtbuGNCn1j5S4ua3k66fyM1rkqK6UhOQiSRw
         p7Axwolb0MtIIunU3/dxtBz+zNT1UtN4PhocOsFj/G68KLNxG9iTbuox3OU2DsZJFBEh
         Hk/LxOsTxBTBKjTIE26HG2AJRHlmByZ0UPJ2BSHCb17rLy8FxTGjCDdy+SOsOZlMcG+m
         y+gbVAsPlRmKNJpMlFIrzofXI01atILEtV+t+n6JMPx65Z3ZdvYoID6vTRo9kk9YiqXK
         rwrPP8KytWUlzkOncpKj3D+OP64L381rSt86JQhyZaFcUUW9I6LHTthjYxCQD6Ku1ru2
         TEdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kSgsBNcHLvWJ5Aptf1RcQ8u2LPLH61DVfePEcCW2rEs=;
        b=dQDIQWCwVC5c/hR+s2gChgQFPT3xwv+NVCz/5ThCeurx2x5mtj5CzTWpx4/RFRzfug
         nC3qFnRx5NCMBGQruyocZ1Q7x5RaXaOG1OOt3K/ct8OLrjY6SURIfNpuz067dYO+Y3Pb
         YouMu2Kvb0gmQHZzDYNlm0nRRZcb1QeVxtEFnpA/NXZOTYCL614rP82zxpDaLMl3IEHL
         oxZupxN8LmXThmSMh0xw/ZiyuwcRGxX9egeMUBO7M84lobg2m86VBnKIAqf2mTwu4hH0
         vz0LHIcvnvlpyGU0mJA0zZVW+XY7Ldg2wSz4WCmuYYGmHH6AkOFAT/P0KWa/mkQ75snR
         4AsA==
X-Gm-Message-State: APjAAAUiVgwStf/EJrPo1wMx/a3wBA6nKSFfLkiDuGwHsglz7sI02jF1
        Ev4xd+GP3Nk/cY3xrWgQfs1CoB1Skb4=
X-Google-Smtp-Source: APXvYqwOmw1ZPr/mayseofB3rFRiuNQRj6LFUO++3NbxB8D9Z2v2DDjkC5vjnNK4ghUvET1xdmi/kA==
X-Received: by 2002:aed:23a2:: with SMTP id j31mr3960803qtc.6.1576087112506;
        Wed, 11 Dec 2019 09:58:32 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id 40sm1088866qtc.95.2019.12.11.09.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 09:58:31 -0800 (PST)
Subject: Re: [PATCH net-next 8/9] mlxsw: spectrum_router: Start using new IPv4
 route notifications
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20191210172402.463397-1-idosch@idosch.org>
 <20191210172402.463397-9-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2e97aa7e-e982-a8cb-92f2-77639fc17035@gmail.com>
Date:   Wed, 11 Dec 2019 10:58:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210172402.463397-9-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 10:24 AM, Ido Schimmel wrote:
>  .../ethernet/mellanox/mlxsw/spectrum_router.c | 141 +++---------------
>  1 file changed, 20 insertions(+), 121 deletions(-)
> 
>

that's a good stat line.

