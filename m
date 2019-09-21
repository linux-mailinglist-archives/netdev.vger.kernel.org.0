Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0D6B9BF3
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 04:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437553AbfIUCDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 22:03:09 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40314 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437471AbfIUCDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 22:03:09 -0400
Received: by mail-qk1-f194.google.com with SMTP id y144so9252766qkb.7
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 19:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=TKQNktweFiniNKPZ1K4hQ+hmbYW6Qjq/UnNJEIp/c0E=;
        b=dhJ4ltjboaskS3BNZfUNp9te0pSoKYgpwSXOIMM3W4rDycbfQKBzm8pzlNgZlBvehX
         lni1mXwspTYH795xgmQ5HvKr9lhLyN9oS49AEObVifxTZ587UKCjhWWG47q+uH6SEEYS
         b5tCCntQv8CY1A0jL0QrOZcySTBKsT00TXvzStvL+flGRePQt7Ti7MXCR93bubBPGMiv
         OzKh6Efg4lEdzWwVwpSMLg4CBII4vW1l7u7DQE8tVjf2EfNF003NJac1Eo8a+uJ8NZEb
         r96AVRfWZW3l8SRLj0XnxYHv7gtHaoicMNNeWgE+XTw0DLutvpYDGaAw+Foy4Deu4e54
         GFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=TKQNktweFiniNKPZ1K4hQ+hmbYW6Qjq/UnNJEIp/c0E=;
        b=lHCGXhZhdOPKhBZH7qfR8lfFJ0HFi8OyePQahNTswwniZM5I0D0+ZmGn55W+m6aVz3
         K3U6nJ35zbTsFSPrGphgib/U4qlo/xesWnjqSoF8K60ifHqXIZGOH/yOwr4mYIBrriNp
         qatzM+SdnYzHKObGMeDmVjFueZgtsg2u57G3aIxGHkDffCUht+aAV1U1UrTxZj0dj+bK
         /SA6NBewCim75A2bJeA1KgnVsTVfXyxw2El3/ddcvmnkPRxuO3PQd0VOsMCsoHoyobc7
         n59JzU3XPocDXgoTwcaoMz5MfCkdGgE+9043no+N/YwNE/bGqVrya+dOxrKxRyOJ9HYn
         mAjw==
X-Gm-Message-State: APjAAAWGagkSmJYrwg4h71NzV3Ap9SD02/MzpfV7EvpMRyI6H4kPzmX6
        QPcz+wQodTMlgAkNOnm7ZsOfUw==
X-Google-Smtp-Source: APXvYqz/BxYdzZQVqL23CXs4R732G54NUtBs6GuwsHdbUcFT2KQ9DxUNZvh9MhT7Ju64TbdteyAULg==
X-Received: by 2002:a05:620a:7ca:: with SMTP id 10mr6945646qkb.410.1569031388353;
        Fri, 20 Sep 2019 19:03:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g8sm1896906qta.67.2019.09.20.19.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 19:03:08 -0700 (PDT)
Date:   Fri, 20 Sep 2019 19:03:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH net,stable] usbnet: ignore endpoints with invalid
 wMaxPacketSize
Message-ID: <20190920190303.149da58a@cakuba.netronome.com>
In-Reply-To: <20190918121738.6343-1-bjorn@mork.no>
References: <20190918121738.6343-1-bjorn@mork.no>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Sep 2019 14:17:38 +0200, Bj=C3=B8rn Mork wrote:
> Endpoints with zero wMaxPacketSize are not usable for transferring
> data. Ignore such endpoints when looking for valid in, out and
> status pipes, to make the drivers more robust against invalid and
> meaningless descriptors.
>=20
> The wMaxPacketSize of these endpoints are used for memory allocations
> and as divisors in many usbnet minidrivers. Avoiding zero is therefore
> critical.
>=20
> Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>

Fixes tag would be useful. I'm not sure how far into stable we should
backport this.

Is this something that occurs on real devices or protection from
malicious ones?
