Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FAEEB68A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbfJaSAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:00:05 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35429 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbfJaSAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:00:04 -0400
Received: by mail-oi1-f194.google.com with SMTP id n16so5993449oig.2
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 11:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GtKYhEQC4Du9ORg0zqjtaU+h/BJ16IRRsZXZjPb+rYE=;
        b=BkZAy/ZBtOKgUyoV4BlnRwmrkFVUwptf0qjK350/iJWqZqY8rwPA3w9APbH0Ar7jJP
         Myq453PPrAQqlOPaOz7T8bCWYiZlcmfg6dLRDiCM4s2afyaBSa11EJIquwvpza1TmuJ5
         5lhUvJN5nSZlQ1u6yr/boyPir9JhKQ1XGJpIA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GtKYhEQC4Du9ORg0zqjtaU+h/BJ16IRRsZXZjPb+rYE=;
        b=aXTbe7BLTwoaeA8p1gEDq7BU24hMFpxyEPj7Y+bQ8TF4TjyhsQ2eKULHvmZhJChAYX
         lr6Hla5UO7jJV2P/8Y/bIGTSjIUY/bwKItNpBtIucFWDhK8JXlI4LyUg29O33twepgjS
         Lchy7ck4L+zTIYIo74y/KcAQJpC0zjKuZQ/AnCvpd25yMr4h2gjGjqXn2PbA4GY8LKKh
         dtvNUtw8DOLsE8FMxWBtNGabmXOBa7LtUYkL09c41VIge1rTogymHv6JeR4QRtlZ8olg
         kt4VmYEcdl3/idRzIaQgEedyOlHbQxfTaO4Vg3TyOOmjZbfeSo3Xxwuu6Bm4lU2XWYzb
         4T0g==
X-Gm-Message-State: APjAAAV/F4dMgjRP/4jKnhCK7iZCDViKYjmCAj0s8gsmIPpp494WDSl5
        SC783KwqjS07UtG8vr88rUO7KlC/YNoPU19pFU+d2g==
X-Google-Smtp-Source: APXvYqwkVSmyXA86l0dDbS+Yn1IaXlPi06qdXQQXqLiaYA2/7QVISqar9cF+ryYJSjy8tYfqBoljcnUAQ9CGHT3N97M=
X-Received: by 2002:aca:c6c6:: with SMTP id w189mr804269oif.124.1572544803762;
 Thu, 31 Oct 2019 11:00:03 -0700 (PDT)
MIME-Version: 1.0
References: <1572516532-5977-1-git-send-email-sheetal.tigadoli@broadcom.com> <1572516532-5977-3-git-send-email-sheetal.tigadoli@broadcom.com>
In-Reply-To: <1572516532-5977-3-git-send-email-sheetal.tigadoli@broadcom.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 31 Oct 2019 10:59:52 -0700
Message-ID: <CACKFLink_aKX6WreKRT4eotN8Rq3UObJzew8xM_b=e+VZJGR3A@mail.gmail.com>
Subject: Re: [PATCH net-next V5 2/3] bnxt_en: Add support to invoke OP-TEE API
 to reset firmware
To:     Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 3:08 AM Sheetal Tigadoli
<sheetal.tigadoli@broadcom.com> wrote:
>
> From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>
> In error recovery process when firmware indicates that it is
> completely down, initiate a firmware reset by calling OP-TEE API.
>
> Cc: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
