Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B12D065C
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 06:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfJIEMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 00:12:05 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:44112 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfJIEMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 00:12:05 -0400
Received: by mail-io1-f52.google.com with SMTP id w12so1872685iol.11;
        Tue, 08 Oct 2019 21:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=QImVarFmxCaA6l0M9QUupZLpUc9Wi7+xOD3W95H8pNk=;
        b=kXtyMLm0Prki5mVMXQ9aTYh83F8txfUEVggtgcx28XaWAWXXgDbssx2VomDSRJOF7Q
         DhHEhWYwdQDTYNLzvGSqdf2R0nh6pBd08rxNJqUpJJbP3LDzRn8qxi2ztwC35ohG7rDl
         mxdNrokmXRYvoWlFnG1a1X1IMgnsS/nYndI2+NjfimN/z47WRRJJ9LSKYBXIrHNZqNUZ
         G7Ea7UpHa50wtMBBQEDZt752a4NT9hby1v3mME+QndUsWl0vl848haBKDjUt3oDB9gIy
         oBJhrs8wTkHo149Us1YF6ngn/ZIN+VzYCGROsZZshQPmaFOltypPGz8Hs2CLdg8Z+WO7
         su6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=QImVarFmxCaA6l0M9QUupZLpUc9Wi7+xOD3W95H8pNk=;
        b=G3Rcxq9+XqEu2FN9Qv2zQbUXYpuOv3gPOajXsvQAbl+Ipf2iE1w+BIBtldl8VjcoUv
         Df+3MWFbTgrlxolo/7qve9IBvTeR59t3rw6RXaxU0jbRYjNnrXHEEYuerULgb4qA7Pkf
         ZjoeIhKPK2z7p8suPZCC7ibBK5vAcWIVvLyBN7Qm4NfQBGCHpxL84V1TD5PGacDT6uic
         RP9O9Vl+wXqk3jI6FpM0dO50a0e4nMaBzVzADp715BgPypFRCrhC8DPe+5bj4PgnnpdU
         fAj4BYzhSo1hr8KCEyEls0yGySO030COkGflGPnxOHv4oD87nrDWhTE9ucZdf85o/ERk
         nHEQ==
X-Gm-Message-State: APjAAAViJQWsNC/kDf4RQDG9Edjk8B0AHEPcQvHvKj8MC0rQMi0Jeizw
        PdPPX8sGblFONEHFmO7zsiE=
X-Google-Smtp-Source: APXvYqxRnkzOYzi/YQKqRVMMTCQxh5PJarPuuiOzHQ2qEDhdGqjpexYX5uX0kipt4L+tGkV/J6gmXg==
X-Received: by 2002:a92:60e:: with SMTP id x14mr1314892ilg.301.1570594324467;
        Tue, 08 Oct 2019 21:12:04 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f12sm451507iob.58.2019.10.08.21.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 21:12:03 -0700 (PDT)
Date:   Tue, 08 Oct 2019 21:11:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        john.fastabend@gmail.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5d9d5e0c16c62_5b122afbd8ad85b4f8@john-XPS-13-9370.notmuch>
In-Reply-To: <20191008231009.2991130-2-andriin@fb.com>
References: <20191008231009.2991130-1-andriin@fb.com>
 <20191008231009.2991130-2-andriin@fb.com>
Subject: RE: [PATCH bpf-next 1/3] libbpf: fix struct end padding in btf_dump
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Fix a case where explicit padding at the end of a struct is necessary
> due to non-standart alignment requirements of fields (which BTF doesn't
> capture explicitly).
> 
> Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
> Reported-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Tested a few different kernels and seems to have resolved the issue
I was seeing.

Tested-by: John Fastabend <john.fastabend@gmail.com>
