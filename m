Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E8D318D2A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 15:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhBKOSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 09:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhBKOPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 09:15:46 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030E2C061574;
        Thu, 11 Feb 2021 06:15:05 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id u14so5897532wmq.4;
        Thu, 11 Feb 2021 06:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=NqJl+7VgG2HfaF9Ked4qUIjOghassFCSe0BNnEt7qj8=;
        b=mPb+s7DITo6YbAtQjaqPCEBNGHpfyHFE4s9EjjWPnx5M8SIZYlPQ9vx4O6elsYgKPY
         +Ej7zP1LSif9NfKboWhGb5BXjisNCMPjXtL6b6THXoqm+F/neJTqbQzUUtQollpmiZdt
         IUpDSRHAT0zzr2yZuzdKroI87pI9a3TqJ1V/ihNLDVMzh1o79Q3Yfok7RhPlJwGA0Vak
         jyLyfyiNscakfPrS2GE8hoP64a9C1ODvEonaJRDa/Qqf7MTD3wXuZiVFOvjueTst8tll
         dZ4VqQdHT0ZLYLZTiuJ0Vy8rhIKV3NfpDzpEK2NmonwJVvCyCILbpuBN7xyALDZbqf9v
         ZBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :content-language:thread-index;
        bh=NqJl+7VgG2HfaF9Ked4qUIjOghassFCSe0BNnEt7qj8=;
        b=FBHGT0f/H8D3Y4OzzM3y8nTEcxahvd1X80nsX2YaGapOb94SLW2NHYQaVPUVlzAWHO
         sYsAIFir/kEijn37a9SIR0EkRMNnnMaqBOv+Q2o0zWV76NxKlUQ4z2Sp55iEKlus914x
         +QpYWggmMs+1AopI/g8xWvos6BDxcDot+HXgel4eqC9ZPIaKMv4R2u40TvJgVz1TnGz3
         7hXQwPqoMjSbi1mcz0IVd4OP6VeLBWIbd2aZ5NOG2c/GOnsYd3X7ONB5+ddfQB9mYCcX
         60rMmWLNZx226TBhJgYT8Cm8pmlJAM2ajvW/CnIXTpCtAqhPDBHGrbgo1T5ND/dOrXMm
         WACg==
X-Gm-Message-State: AOAM533pL0966mFhTerYWTyBw1m88QXORJ/fVYKM0JjU33Fs5u/M+4/2
        Z//lzePGvYQTvsKzK+TR2QLs6CR96aukMw==
X-Google-Smtp-Source: ABdhPJzMRxugvXnzrQVDPQcGqkvzFNvBaMKVtpKaUKUX/H65FT6SVTHvQwoSqVx3xmLWZ2SNHe4UNQ==
X-Received: by 2002:a1c:6a09:: with SMTP id f9mr5485740wmc.104.1613052903733;
        Thu, 11 Feb 2021 06:15:03 -0800 (PST)
Received: from CBGR90WXYV0 ([2a00:23c5:5785:9a01:f088:412:4748:4eb1])
        by smtp.gmail.com with ESMTPSA id f2sm5093215wrt.7.2021.02.11.06.15.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Feb 2021 06:15:03 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Juergen Gross'" <jgross@suse.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc:     "'Wei Liu'" <wei.liu@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>
References: <20210211101616.13788-1-jgross@suse.com> <20210211101616.13788-5-jgross@suse.com>
In-Reply-To: <20210211101616.13788-5-jgross@suse.com>
Subject: RE: [PATCH v2 4/8] xen/netback: fix spurious event detection for common event case
Date:   Thu, 11 Feb 2021 14:15:02 -0000
Message-ID: <001d01d70080$4a5446d0$defcd470$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQJuRSjpYwlLGVvLkRJGigHTv/cnpwJEXRo/qRJS+MA=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Juergen Gross <jgross@suse.com>
> Sent: 11 February 2021 10:16
> To: xen-devel@lists.xenproject.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Juergen Gross <jgross@suse.com>; Wei Liu <wei.liu@kernel.org>; Paul Durrant <paul@xen.org>; David
> S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>
> Subject: [PATCH v2 4/8] xen/netback: fix spurious event detection for common event case
> 
> In case of a common event for rx and tx queue the event should be
> regarded to be spurious if no rx and no tx requests are pending.
> 
> Unfortunately the condition for testing that is wrong causing to
> decide a event being spurious if no rx OR no tx requests are
> pending.
> 
> Fix that plus using local variables for rx/tx pending indicators in
> order to split function calls and if condition.
> 

Definitely neater.

> Fixes: 23025393dbeb3b ("xen/netback: use lateeoi irq binding")
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Paul Durrant <paul@xen.org>

