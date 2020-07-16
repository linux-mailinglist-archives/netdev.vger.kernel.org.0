Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB81221E16
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgGPIUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 04:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPIUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 04:20:05 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408B6C061755;
        Thu, 16 Jul 2020 01:20:05 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id k15so2829983lfc.4;
        Thu, 16 Jul 2020 01:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mz30pS9nuWD5vYzRoE6sn37W/RWl4qEdurv/5wWXpsA=;
        b=tWXeV08xIDH5mo3BHwWVQQPgIPC8FLW3QYQqYh3Z1s9vxZB22Rv/By4ahoAVgUImwI
         WNtv1xht/klcqHZt958pemGcTDDIZhQtrZ290hDYIEbgykwrrkcWoTkffRzR8wIVH1bt
         i9RaK+DyNUxBVc3xQNV8QweyNWFNo2DMT4XvzFp22dyVuSGASMFutNWkGZGF2gO2jpZw
         KgASta8rv3o4qVuYqL6PwfxRGjQaQn8Si3iwG0Kr1ONB766pcizeTA7XOS1ROnTEyb8s
         xyKEl9ysTMAUGzX7GlLj86m6LL7VlNo3bRXztRaxcuG8IFC7cVrOMxX/hIE4WzFcJEad
         TFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mz30pS9nuWD5vYzRoE6sn37W/RWl4qEdurv/5wWXpsA=;
        b=B61nsE7mzlr04Ymt1Ta4i55+rT48+C7o+RHc2WsGE0tgRSMmWgE5SO+JXWJJEEos9V
         4ywYCu46iLahHiXxr2pOZm4/y6aLz+I5BCRk1K9PciB1WquklfsEKLGztr0SxaRIRI3Y
         6Y+JmKXZ/eq8e0dw5bXo6Z+yZFnOAMUk53UL0n2CD2rFdW6Obu8K1AkSsImFY3AHxUY5
         SQZUq2+Y/9emJK2/yMKEGIteex0Qt3cjVn49oBPKNxc1GOm6bAhydFSYWfL4EWU+Ga+7
         F59AutfwO4VzAIcJTYzYTH4LZ49/I7OnykCj16mFpAl+kUToOhesacygzLW81gmIEe6P
         XXoQ==
X-Gm-Message-State: AOAM531ezLkWO/bdcJiBLHwWR5+ZaD/8o1r3/f+ALq74se8hV198D7Xq
        HilR9okN/kamudDzdEEy45nzrQjC9uU=
X-Google-Smtp-Source: ABdhPJxoShNW+1nwmDHdli9/hEpTeonEHue/Vq5kDk20T5a5m/nKCansNBawju9h60BKAwWgU+aH6A==
X-Received: by 2002:a19:c886:: with SMTP id y128mr1520323lff.98.1594887603491;
        Thu, 16 Jul 2020 01:20:03 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:23b:3385:c538:1113:7a4f:71ec? ([2a00:1fa0:23b:3385:c538:1113:7a4f:71ec])
        by smtp.gmail.com with ESMTPSA id b11sm1023669lfa.50.2020.07.16.01.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 01:20:03 -0700 (PDT)
Subject: Re: [PATCH 3/4] cdc_ncm: replace the way cdc_ncm hooks into
To:     =?UTF-8?Q?Wxcaf=c3=a9?= <wxcafe@wxcafe.net>,
        linux-usb@vger.kernel.org
Cc:     =?UTF-8?Q?Miguel_Rodr=c3=adguez_P=c3=a9rez?= <miguel@det.uvigo.gal>,
        oliver@neukum.org, netdev@vger.kernel.org
References: <ba544d6d55f72040b70f041911199e693f7855f7.camel@wxcafe.net>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <b9219015-6157-495f-0cbc-08cb078aab78@gmail.com>
Date:   Thu, 16 Jul 2020 11:19:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ba544d6d55f72040b70f041911199e693f7855f7.camel@wxcafe.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 15.07.2020 18:56, Wxcafé wrote:

>  From 352445fcbac243b8f10e1840726d67b41a45853d Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Miguel Rodr=C3=ADguez P=C3=A9rez? <miguel@det.uvigo.gal>

   Something went wrong

> Date: Tue, 14 Jul 2020 18:10:34 -0400
> Subject: [PATCH 3/4] cdc_ncm: replace the way cdc_ncm hooks into
>   usbnet_change_mtu

    You don't need the above, except for From:...

> Previously cdc_ncm overwrited netdev_ops used by usbnet

    Overwrote.

> thus preventing hooking into set_rx_mode. This patch
> preserves usbnet hooks into netdev_ops, and add an
> additional one for change_mtu needed by cdc_ncm.
> 
> Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>
> Signed-off-by: Wxcafé <wxcafe@wxcafe.net>
[...]

MBR, Sergei
