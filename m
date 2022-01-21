Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFF24967A8
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 22:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbiAUV5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 16:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbiAUV5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 16:57:50 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A39FC06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 13:57:50 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id i2so2055676wrb.12
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 13:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=l1xtrViE5M+7PE1Oz5jUW3CFgiEMYAd/0eH2rFcoAZ4=;
        b=OZxX8xpJ4w1tqDvu/zmSUgXv23lk7RbYppQ2wfQRZQx7TPuM50dDt+q/nbe/KRmdUH
         KllldeeGfZCk+Xx5EHr2idM+X6Vr5z0YlRD/wiDXiN5bSO8Zmky4Gk3ektqMokZvKUUu
         xJbkGDOJpnWuSvVCGMm3D4v1WBzy+pt7HckcCUi+TbkR3TzI86hX81jNYR2X4Rft3v6g
         2qlECXjKmFk3bpFn3VTIGpHUGXPEH7VHDvKcw29MCRCGoKavD/HExXYeVIkEz5x/S3ug
         1FpxiplQr5Ii2LPeRtnj6xK2FaJj7g5V3i8KDKK/zwj1x1ToiFiFXbfDH7ib/G5nU4TP
         +WTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=l1xtrViE5M+7PE1Oz5jUW3CFgiEMYAd/0eH2rFcoAZ4=;
        b=mvba8/B6pt47vv/51FXEVhYrFRYAu0uKtU7uC+IU44ri7uVCsI2l6s+jCxBxz5s+c6
         ZIs3Q7jyQ46JtZZu4rK87KqqvRT6zZBw2noHUZNERPL3sXEnX14vmAf+JYV2F1D5TAPK
         0++yZ7/nb+EYpKG/kGH1rlekrgfs5h/UKEYwKMVB8fRt4kB+X/5UXORvgcI7rpSb4EM9
         SUW0UU8PM0dmqxkuuxYXFJGZwBDSbsIWs1rfeIbfZkZX2WQKwY8sX8yZlm58RWVSTh8+
         6YY8z6ZqzWLgVVUJEQ7uka1rkap7RiqR2n+klVGx7B951HFh+y/BXE16dWGwAyE3xVAY
         1gow==
X-Gm-Message-State: AOAM530s5n896mtHzB10QfVO4zRHN9YQbOlNZcSrpBGPLGyJpTaXeTia
        djPhkeE/MxhNWhEZMR4RBFQBEmOKd5s=
X-Google-Smtp-Source: ABdhPJxATkvOwiSbauO0E3+taVJInrDR9uv0a0hv6c/6Ox5GeH/L7s/GnOngPo3SEyNXODEQ/jXCjg==
X-Received: by 2002:adf:ef4f:: with SMTP id c15mr562599wrp.63.1642802268700;
        Fri, 21 Jan 2022 13:57:48 -0800 (PST)
Received: from nz.home (host81-129-87-131.range81-129.btcentralplus.com. [81.129.87.131])
        by smtp.gmail.com with ESMTPSA id y6sm5740140wma.48.2022.01.21.13.57.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 13:57:48 -0800 (PST)
Received: by nz.home (Postfix, from userid 1000)
        id 7A8F11B436783; Fri, 21 Jan 2022 21:57:47 +0000 (GMT)
Date:   Fri, 21 Jan 2022 21:57:47 +0000
From:   Sergei Trofimovich <slyich@gmail.com>
To:     netdev@vger.kernel.org
Subject: atl1c drivers run 'napi/eth%d-385' named threads with unsubstituted
 %d
Message-ID: <YessW5YR285JeLf5@nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hia atl1c maintainers!

This cosmetics bothered me for some time: atl1c driver
shows unexpanded % in kernel thread names. Looks like a
minor bug:

    $ ping -f 172.16.0.1  # host1
    $ top  # host2
    ...
    621 root 20 0 0 0 0 S 11.0 0.0 0:05.01 napi/eth%d-385
    622 root 20 0 0 0 0 S  5.6 0.0 0:02.64 napi/eth%d-386
    ...

Was happening for a few years. Likely not a recent regression.

System:
- linux-5.16.1
- x86_64
- 02:00.0 Ethernet controller: Qualcomm Atheros AR8151 v2.0 Gigabit Ethernet (rev c0)

From what I understand thread name comes from somewhere around:

  net/core/dev.c:
    int dev_set_threaded(struct net_device *dev, bool threaded)
    ...
        err = napi_kthread_create(napi);
    ...
    static int napi_kthread_create(struct napi_struct *n)
    ...
        n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",

  drivers/net/ethernet/atheros/atl1c/atl1c_main.c:
    static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
    ...
        dev_set_threaded(netdev, true);

  ${somewhere} (not sure where):
    ...
      strcpy(netdev->name, "eth%d");

I was not able to pinpoint where expansion should ideally happen.
Looks like many driver do `strcpy(netdev->name, "eth%d");` style
initialization and almost none call `dev_set_threaded(netdev, true);`.

Can you help me find it out how it should be fixed?

Thank you!

-- 

  Sergei
