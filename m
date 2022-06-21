Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44FD553E87
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 00:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354164AbiFUWbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 18:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiFUWbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 18:31:40 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B92B481;
        Tue, 21 Jun 2022 15:31:40 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id k127so9162524pfd.10;
        Tue, 21 Jun 2022 15:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SZdE7QPkm1R89AKJqDyqxi4uethQzAG0zu7JrCCmLrs=;
        b=o8ldGyuiz/On72dreNwnBsp7iSyBGM/I7ed6LpTCpfJ1o9ZoG2W5U0roLtkPoyeIjY
         z7SkF0OCpEUo+YkmM+vxnvsD4byoiu/MYUK171zCvr3x5M8mLxT+HePei6Wm0fayyH/k
         bk0/vARyaJzMnCqYSMBjKwYnrYL9iHxeCN5ULvZJgbf5vDpLIL7hfAGjegKs7CM/jdAL
         /vaPsd1gxk6DniB26exqYZYjWvmUMhX9CHrx6jGSErF9tfrcOHxRdv8HBb8tG6h5ICjI
         zP+nrYCRNPpPqJuE48lxwMxrUlEMBHk8KTg8iNkpQE/pv1TDixl3N9lzj8T8pAC5Mkh9
         w0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SZdE7QPkm1R89AKJqDyqxi4uethQzAG0zu7JrCCmLrs=;
        b=O5zmTDHUJherhqiaGCmnP9UE4muiCGBM6qHo78VcNbDCfPzW/q74ZTsrha1zRGc/AY
         yTtnhsXLu0OiznAZ8bcJvCtjoeKuuvVXd0pbIYPRKxBtKiq5u0ukRMQh+cL/MreMnqUV
         F8i8+iEn8UfeyVJosrVm/uZ7dhzk8evvT3DspMiRPiPiIdrJN/iPajZeOkpuiJKf8vQs
         CdbKXeKFkfMxwqHjoDg2CkIBErD/z8mP5G7fxmkY+zswUNHkzBb3lLts/yoo58NO1U9Q
         zyboAAAPE98dLvh699jcY5XgZCn7pbTdqGWAjXH/KgKZmZMI4IoxaCRWaJ/MQXQdBZFA
         dB8Q==
X-Gm-Message-State: AJIora8B0Ctu2/+dA7AFvwjcfcAvnjpyll1JsmBADNlgpbocmpRLpTCz
        kwtCWIWOdHi/CLZIp2+rz0g=
X-Google-Smtp-Source: AGRyM1u2oBLCQ55uzgZc2QZ4kMby3VwDKlsClbSYcfE5CIM8e26J7xgEw4mcK7ONWCD+oH8bhCiR+w==
X-Received: by 2002:a63:cd51:0:b0:408:415a:3a18 with SMTP id a17-20020a63cd51000000b00408415a3a18mr192295pgj.524.1655850699528;
        Tue, 21 Jun 2022 15:31:39 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::5:29cb])
        by smtp.gmail.com with ESMTPSA id k16-20020aa78210000000b0051bb79437f7sm11797719pfi.37.2022.06.21.15.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:31:38 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:31:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kpsingh@kernel.org, john.fastabend@gmail.com,
        songliubraving@fb.com, kafai@fb.com, yhs@fb.com,
        dhowells@redhat.com, keyrings@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/5] selftests/bpf: Add test for
 bpf_verify_pkcs7_signature() helper
Message-ID: <20220621223135.puwe3m55yznaevm5@macbook-pro-3.dhcp.thefacebook.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-6-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621163757.760304-6-roberto.sassu@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 06:37:57PM +0200, Roberto Sassu wrote:
> +	if (child_pid == 0) {
> +		snprintf(path, sizeof(path), "%s/signing_key.pem", tmp_dir);
> +
> +		return execlp("./sign-file", "./sign-file", "-d", "sha256",
> +			      path, path, data_template, NULL);

Did you miss my earlier reply requesting not to do this module_signature append
and use signature directly?
