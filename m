Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A4C11D9A3
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 23:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731042AbfLLWnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 17:43:00 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42455 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730707AbfLLWnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 17:43:00 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so165504pfz.9
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 14:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ZIupz8CJ03WX8+ruPv9sIkgT1VrG+6iS2XYJnRcfuyg=;
        b=iIFhu4qkunC0Lwn7JHdKOhG3f6CXgmE5mHRRS7IJBTKg8ESQl4RW/xkmwOb+CNDkgl
         9NpsbREeTXasi6Zsh+xi3H/xWtQY0KD9WesZbsBI5H8ob25aqW+LiQj7AozlyvYuHRRq
         BkBEWPmJe2qfx+E1DlwW8A/vmU6KqvnuAHbOWtggw6Ysna1iJlH9PhDSjkpZJQOoA60+
         EhNCIChrH7nZNT39RNzbd6djvved/fv7JkTeUQvvEaFKJ4d/IAyxd3j3YWTGJQnPZJIW
         XmCvbmx9EziwWh9JzmQ+nIyX1n7xDR+/YIAXDC7pj3cess8QoRezyZxNEXiu3RPIaxiS
         3jEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZIupz8CJ03WX8+ruPv9sIkgT1VrG+6iS2XYJnRcfuyg=;
        b=GnYZYOuilH230T7WHVK72WKdFUrw2xPlYfwRu1nBpnm1a/hQf7PKI7X1+XyoGojHA3
         7Auxro/i+Y0veapS/CM0DP1wdn4hPa7OJHHB5pPsr68GjnTV/dWw1YuiBTA4B+WWxx/w
         kfaacDLWbhO+vFAY+4xti4tLUivcaLNq9JiGvZW1XcNWDKPIbcVpvQS/iR0UyhXSiuyt
         YnKzSxFXTAvfUuCGBJrqNEjOD4Ur4Uih7YOhRG3IZEAe+TWhvdniuO1H9ze/Yzv6ZHHw
         H+UQffzTzjf5TXXoZnhoP84sV0DEr62NCgTMjRQZFWOsFUaTKVoBdJnTWeTHOx+zzMxB
         cGDg==
X-Gm-Message-State: APjAAAVZ3SbRx424+KdMJ0OeBu3JCf/w2mjR4EDPUr1wVydbtqt5bIET
        li6RIsT1wtE5BtNC3H1qytKEwmFO5rA=
X-Google-Smtp-Source: APXvYqzRfJjmA76Wv/hLM+MKgEErf/dZaIdkUrCrza1gqmRM3R9b09AG5SF66YCqmAcy2hKCsJxSHA==
X-Received: by 2002:a62:d415:: with SMTP id a21mr12256279pfh.242.1576190579672;
        Thu, 12 Dec 2019 14:42:59 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l66sm7917736pga.30.2019.12.12.14.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 14:42:59 -0800 (PST)
Date:   Thu, 12 Dec 2019 14:42:56 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
Message-ID: <20191212144256.1f6912fa@cakuba.netronome.com>
In-Reply-To: <e4f01388-8cc4-1ac5-8f8e-ef24cc1b45ad@pensando.io>
References: <20191212003344.5571-1-snelson@pensando.io>
        <20191212003344.5571-3-snelson@pensando.io>
        <acfcf58b-93ff-fba5-5769-6bc29ed0d375@mellanox.com>
        <20191212115228.2caf0c63@cakuba.netronome.com>
        <bd7553cd-8784-6dfd-0b51-552b49ca8eaa@pensando.io>
        <20191212133540.3992ac0c@cakuba.netronome.com>
        <a135f5fa-3745-69f6-4787-1695f47f1df8@mellanox.com>
        <e4f01388-8cc4-1ac5-8f8e-ef24cc1b45ad@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 14:40:01 -0800, Shannon Nelson wrote:
> I suppose the argument could be made that PF's probe should if the VF 
> config fails, but it might be nice to have the PF driver running to help 
> fix up whatever when sideways in the VF configuration.

If probe fails driver should probe in a degraded mode, where only
subset of devlink functionality needed for debug is available.
