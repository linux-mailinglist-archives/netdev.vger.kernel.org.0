Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD36C51F302
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 05:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiEIDhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 23:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbiEID16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 23:27:58 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0F486E2E;
        Sun,  8 May 2022 20:24:06 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h11so8476593ila.5;
        Sun, 08 May 2022 20:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=DeR7qCFLTfzasDfIzwzIFCxgYRIudbUbg6goLscSctY=;
        b=BeVapuF80B9KC6hy/PY0RpUKz6EEqDK30Sv7f2RqcEUJnF+j63FEcX5OymQURTFh8l
         X5t0m3EHNW0O5t3QxTC3a0dwVFdBNBCJ7GY0MyVqCIKOgXKgKB//dY5G7gtDdeGt6m0M
         bqcG3AOAaT7SdCeqHP7h0LAyurDCJ997koNvsOgQ1lkFKuOzhxKV6S8R2UW07RfAcrUd
         I/dBJf9eBpf99nJHccaGTIwcw4EQIEh8AiiudUaLf6HGzv4VXjlibKVK7dkSSkVuZQC8
         ZgTlrElUt7u4Zm9yCl34pnlzOhU2hQoTPE2JpUQGnVJd5EhIXK6kCvIv9O5wz+RDaMuW
         jpQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=DeR7qCFLTfzasDfIzwzIFCxgYRIudbUbg6goLscSctY=;
        b=Dz9OiH2X5FVoeHIKtsKo/peXXLXR4sRlGNOw3jQuntZbMCRIfssJifLCrWpOnI90M2
         UTTSJLZZm/s5op/c6NgfzJaAVfIMgh6gjscizlc9F+TkzSnemZNr1mqBsdjTeYrk3ax0
         cKAnA52oOmBRoxTlKfKgUhNjK8QkoU5V7++JhOHpOvu3IGcOaUuzzSJeB22l/10hyYG0
         sS+fRX9wK+zwxC/ZYBXNxljK5APwWgmh13Uwfd6ITIdVMB7YwWAbv81tBF5Q05SRPqPY
         Y5J8kwNzIels9S0LWhD+kqFKdhfEc25MKIM3UTr7+2uiUHYHMqRDcIijw71VpnMuY0/a
         zmQQ==
X-Gm-Message-State: AOAM532V1tqmtKtKpesLQLnE27XQGhGUBWEn6u50Uzrji7N7wDZm07AD
        x0dxPKulEp2lIaoHBRYybgw=
X-Google-Smtp-Source: ABdhPJyVZIDB9f6naESORU90YAVw6Vu3lsvfgtKJPVa7hkxl8a3RQnUWmKqL8qokiEkKRWXDoa3k2A==
X-Received: by 2002:a05:6e02:1c4a:b0:2cd:feea:d696 with SMTP id d10-20020a056e021c4a00b002cdfeead696mr5551380ilg.277.1652066645520;
        Sun, 08 May 2022 20:24:05 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id o23-20020a6bcf17000000b0065a47e16f47sm3161534ioa.25.2022.05.08.20.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 20:24:05 -0700 (PDT)
Date:   Sun, 08 May 2022 20:23:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Takshak Chahande <ctakshak@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     andrii@kernel.org, ast@kernel.org, ctakshak@fb.com, ndixit@fb.com,
        kafai@fb.com, andriin@fb.com, daniel@iogearbox.net, yhs@fb.com,
        ctakshak@gmail.com
Message-ID: <6278894cd9ef6_6265d20832@john.notmuch>
In-Reply-To: <20220506010049.1980482-1-ctakshak@fb.com>
References: <20220506010049.1980482-1-ctakshak@fb.com>
Subject: RE: [PATCH bpf-next v5 1/2] bpf: Extend batch operations for
 map-in-map bpf-maps
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Takshak Chahande wrote:
> This patch extends batch operations support for map-in-map map-types:
> BPF_MAP_TYPE_HASH_OF_MAPS and BPF_MAP_TYPE_ARRAY_OF_MAPS
> 
> A usecase where outer HASH map holds hundred of VIP entries and its
> associated reuse-ports per VIP stored in REUSEPORT_SOCKARRAY type
> inner map, needs to do batch operation for performance gain.
> 
> This patch leverages the exiting generic functions for most of the batch
> operations. As map-in-map's value contains the actual reference of the inner map,
> for BPF_MAP_TYPE_HASH_OF_MAPS type, it needed an extra step to fetch the
> map_id from the reference value.
> 
> selftests are added in next patch 2/2.
> 
> Signed-off-by: Takshak Chahande <ctakshak@fb.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
