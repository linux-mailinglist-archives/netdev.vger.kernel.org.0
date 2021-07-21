Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9700E3D18D8
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhGUUgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 16:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhGUUgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 16:36:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E9DC061575;
        Wed, 21 Jul 2021 14:16:43 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626902202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SRiajcVUG8kkXW77JkyefMeF62lPa2D1xRVh/uS1Pcc=;
        b=JsZSNBDhAtOGRXnmlDHSZO1xrzcJu8SnKp57KmfS1fAG6nAgrBz6aq/lo8/RGXsKA/m0a9
        551fDtEVCTSy0XDd6EWOVhDe+WpVP2K5VgOm/rj9V5cFGgkn4uhHcARGIQgmRLEXkPg1Yq
        DgSkcBx249z+Xhyw3PzUZFfKRJaN0eUK7ipxyN3SeHFkG/7RJRVBzr66gH3hPItV1JUelD
        TvtWEgaSAH+niFBMNgODD9Zj1/yP44HNH8YiKMBPcMFa5EXxolPQMp8X5Oymhg8SNSgMKU
        oPBHxWNS5uKBjXoiEFXKmoDH1OfE76cj2dSEM8Crmgk/1zD31lGpT7SnyNQbIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626902202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SRiajcVUG8kkXW77JkyefMeF62lPa2D1xRVh/uS1Pcc=;
        b=UsiW6dIfwJVshmwQ9U09Xm7AkT9BJE+2U91TClDH7AZTjO8PGGwkd2ONGYbjcYkvVOSBrV
        96W3g5agpmUFMoAA==
To:     Dexuan Cui <decui@microsoft.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Cc:     "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "'netdev\@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'x86\@kernel.org'" <x86@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel\@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
In-Reply-To: <BYAPR21MB127077DE03164CA31AE0B33DBFE19@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <BYAPR21MB12703228F3E7A8B8158EB054BF129@BYAPR21MB1270.namprd21.prod.outlook.com> <BYAPR21MB127099BADA8490B48910D3F1BF129@BYAPR21MB1270.namprd21.prod.outlook.com> <YPPwel8mhaIdHP1y@unreal> <c61af64fd275b3a329bbad699de9db661e3cf082.camel@kernel.org> <BYAPR21MB127077DE03164CA31AE0B33DBFE19@BYAPR21MB1270.namprd21.prod.outlook.com>
Date:   Wed, 21 Jul 2021 23:16:41 +0200
Message-ID: <87czrbpdty.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dexuan,

On Mon, Jul 19 2021 at 20:33, Dexuan Cui wrote:
> This is a bare metal x86-64 host with Intel CPUs. Yes, I believe the
> issue is in the IOMMU Interrupt Remapping mechanism rather in the
> NIC driver. I just don't understand why bringing the CPUs online and
> offline can work around the issue. I'm trying to dump the IOMMU IR
> table entries to look for any error. 

can you please enable GENERIC_IRQ_DEBUGFS and provide the output of

cat /sys/kernel/debug/irq/irqs/$THENICIRQS

Thanks,

        tglx
