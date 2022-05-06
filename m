Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFA551CE00
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387945AbiEFBgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387939AbiEFBgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:36:03 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13E95D1A4
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:32:21 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-edf9ddb312so4976211fac.8
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 18:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mdaverde-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=068F+h8RQfUvOVO1t4k8OZXqnvKUCyKIVv9Y/xDcfUE=;
        b=X5LjzzrJPRILUj2wePdckLtkz/yTAOqqlWhNuos29HgZKVERn5uPygdpkEd7Or71yL
         elGUCzpyV/JjsRz0SAB2nmrME7scMN0yoWb0QEG26w+WM3A0fx5DwIKj7ZDatndOD/rU
         csRJ3qwoP/K+yJK1Abk6vIZCVNLHDfqqKe0sJlcZfpXpnHYo2uzpR9EHZRgL9q7Kmzwk
         sr/vSoRnWjKthofCIScEFvjnCb0C4h4xMDEj34gmd7bhr5dFigfK5nwGjqayrUogWgUy
         SZf8NU6wAlv9Sysds9a2iEZ+hUy6pcLCFgY7L0+WotCDwALnOEDjqLcaiAqPSuQI6j7K
         XYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=068F+h8RQfUvOVO1t4k8OZXqnvKUCyKIVv9Y/xDcfUE=;
        b=pZopirjeVDo8BLMctDIYHvTpgLTzyTfmgUmGF0T0cfAJMywqBBngOsGpWJ7Rab9jOP
         E/nOi5j4++Tn9g08AzatsjCS7G+Cl0/sGi03E6kfZaetD3f/EcQNx08PzC3BHRq8grKQ
         sgXBxOUkgvsy+AeBXQMGjDrElT85sCuDC1GmpvW2lN3j7cH2oA8t/SOK4J1M22QLw+ZJ
         NuAzMaxBAN0AOwsSab2IXHyJ5KGITWX09Klhj30brRQl66nefMeFlTbVmuJyZSHXscT8
         JRmqCUggw+ePaIyT9CPRP/D5k/EHfThoyycNk80jFNT7PVXHilq90QHzLsX7v52kHxHn
         g0Sg==
X-Gm-Message-State: AOAM533mPbxsUPSUEAlRofZ5xzLfujTovLZwWv3NvBkuF+o5RDVj7NT9
        rLpwojU68Oj7stH/DMOiQW6rKQ==
X-Google-Smtp-Source: ABdhPJw7EpOD9gz0ff27qFrh6p53w00QVueh6ajPyfZRMU6f46uyyPmO+pPTTLpC3Ni/FuWHCI8UPA==
X-Received: by 2002:a05:6870:d0cf:b0:ec:4559:86e1 with SMTP id k15-20020a056870d0cf00b000ec455986e1mr373763oaa.225.1651800740991;
        Thu, 05 May 2022 18:32:20 -0700 (PDT)
Received: from pop-os.localdomain ([2600:1700:1d10:5830:1761:845b:ca10:1b4d])
        by smtp.gmail.com with ESMTPSA id x4-20020a9d2084000000b006060322127csm1133944ota.76.2022.05.05.18.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 18:32:20 -0700 (PDT)
Date:   Thu, 5 May 2022 21:32:17 -0400
From:   Milan Landaverde <milan@mdaverde.com>
To:     Larysa Zaremba <larysa.zaremba@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH] bpftool: Use sysfs vmlinux when dumping BTF by ID
Message-ID: <YnR6oWaoUkEGW1iV@pop-os.localdomain>
References: <20220428110839.111042-1-larysa.zaremba@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428110839.111042-1-larysa.zaremba@intel.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello! Just ran into this. I think we also need to pass in errno
here to strerror instead of err:

On Thu, Apr 28, 2022 at 01:08:40PM +0200, Larysa Zaremba wrote:
>  		if (err) {
>  			p_err("get btf by id (%u): %s", btf_id, strerror(err));
>  			goto done;
>

Currently, the error output without a base btf reads:

$ bpftool btf dump id 816
Error: get btf by id (816): Unknown error -22

When it should (or at least intends to) read:

$ bpftool btf dump id 816
Error: get btf by id (816): Invalid argument

I was going to send this patch but if a v2 is going to be sent, figured
I mention it. Thanks!
