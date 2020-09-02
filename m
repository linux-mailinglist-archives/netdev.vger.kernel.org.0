Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D529F25A55E
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 08:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgIBGIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 02:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBGIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 02:08:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00A4C061244;
        Tue,  1 Sep 2020 23:08:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c15so1792690plq.4;
        Tue, 01 Sep 2020 23:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ZMb0ASEzb/3ynYKyIXLW7eTGvZCyyhDBWoynwxmg0Fw=;
        b=sO2pxPz7OOoSOuqbxP7hJ0HD5PWTjkscbcyYagBEG1e/eESBWjBIEnJZbj4DICWDDN
         NET6EjT1Ww9kYOndk3XllDCIdGSNBIBgG0iuy40tWbV0eIfO1En/Gu5OTQj2R3DZOv0U
         YopiLPQdEVdM/7526NuSboAw77CptJEWlKEqD9Cr0vBnCvA1wGfXUzepxwALwNR7Xx/9
         3kHci5HA+bBSN2AAIBJJIsX+2zJGczThSDxPQYK9a7W7QLT665klMmNlFinafyzrEEsx
         mbAwaTyse+xbB+epTyZkZkGdyqU/ZFDRDsbsOqOoSssoKYZ2M89Z4wdYTncQWFyONQsg
         XyIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ZMb0ASEzb/3ynYKyIXLW7eTGvZCyyhDBWoynwxmg0Fw=;
        b=qcn7MjyRQzbUcI5cwhDUcxnuCbJ9uos5MQTBLJQZWkeltgHpf6CDVC6sHG+U/708OY
         pmwisVju42jRjMtnV6WcVWfSipWZYgjfMvn/Iwet6VV0S5xHna+berk/n2nUAkV7BkfG
         Gw852INB2hEfzGFWxwR24flGE8+RlBUFxthGNq0umiqfkVX5sB1aNPubMqkXVpEEhlHT
         cK6h1MeARUKFtw5chOJ/TII3ZjRm0z0kx3WxxF7gzPeJAM8yERcQtBl8HqYhtRMajH7r
         OxSZX1FohKgxN3+D9d8rSOKlPu+TKyca4sHMWUfAbNtA9AE4aiWdmcDEIJwfNu8AekRs
         rRCg==
X-Gm-Message-State: AOAM530BftYCgbr4XtIRcJRRDwFjSftJlQxsKGwWDFRjRkJj+d2nfD/H
        VoxAsqFQ8NjV0GqI1DV7i6xNWU72pui/tA==
X-Google-Smtp-Source: ABdhPJx4hGmCN8R7DsOhBZRwvZeupayZTCzbIokai+AeMIa6h/T166l0aTPZVHC8tkLhgJ+bBnGbPA==
X-Received: by 2002:a17:902:c086:: with SMTP id j6mr817790pld.230.1599026915152;
        Tue, 01 Sep 2020 23:08:35 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q3sm4270855pfb.201.2020.09.01.23.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 23:08:34 -0700 (PDT)
Date:   Tue, 01 Sep 2020 23:08:28 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5f4f36dc134c5_5f39820836@john-XPS-13-9370.notmuch>
In-Reply-To: <20200901015003.2871861-3-andriin@fb.com>
References: <20200901015003.2871861-1-andriin@fb.com>
 <20200901015003.2871861-3-andriin@fb.com>
Subject: RE: [PATCH v2 bpf-next 02/14] libbpf: parse multi-function sections
 into multiple BPF programs
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Teach libbpf how to parse code sections into potentially multiple bpf_program
> instances, based on ELF FUNC symbols. Each BPF program will keep track of its
> position within containing ELF section for translating section instruction
> offsets into program instruction offsets: regardless of BPF program's location
> in ELF section, it's first instruction is always at local instruction offset
> 0, so when libbpf is working with relocations (which use section-based
> instruction offsets) this is critical to make proper translations.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
