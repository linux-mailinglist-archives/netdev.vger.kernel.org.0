Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD18A57442
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 00:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfFZWZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 18:25:01 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37843 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfFZWZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 18:25:01 -0400
Received: by mail-pf1-f194.google.com with SMTP id 19so158877pfa.4;
        Wed, 26 Jun 2019 15:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5oPhE3qEEt+RsciwWt3P6Fjbl5mc7GWFjnz4iQlRxp4=;
        b=H4+gaLabIccSX6EPGUvDOCU/qUWZUMhDbwijJ4DRhclRYA8njNCIhVON5hmDAmRjyP
         us29dx6wXrDFhkSBYtZP+QnMwkUxbt/b/NT9soEdmAxHwSGDaPDlwMwZgzNqXvOH3aso
         2f9q6yIIHe7gJ8HNtc/aWgiuXhoX0rzuU/K2diGjE5ZK7pdDMd0B1uW+/Dqe1477OhVx
         IrxhZdW9rbOcpZWyMwh65fNWDmD1Ll6t3XZRsVs/yuRwUQPPont7siNBs5QFWibv8n+w
         EzcCqvqSOhG2s0daMmj+Bt+KKOTRXLXfDo7Yn5/MIDQw8qOb7G3VrVDpkXXeUeybpeyV
         P4mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5oPhE3qEEt+RsciwWt3P6Fjbl5mc7GWFjnz4iQlRxp4=;
        b=AQFuIdwD/VB9c0fhOZI4oHs8xSR5A4FvAkOygd5wihGNyPTU5urT8X5jIeCxVHwqeg
         5oarCHHeDfU7fVvhpRfKU+G4OVEDx/nghtIbXnchRlpQAWKZJdIwEDIPhHmOYxh7k1uQ
         UjdMBUfwc3OqEppaOa8AAm/Z1fWQQGFb1lji/CziRcdSmVfiFM3GRAiwzN/mqd7IbYWz
         LBcvvGPVsLXKFPrCZo8cdBzOcCRvlMF5Nf6XOhMqx+/cZ6Z2HYR1dHm5WbLguExoDisD
         NuF5B6G1kw3FatSyTwlOngxsWbAXYZjbAF5T8uks46H5HRxVCJhEEOfeUSRgmKwMcSZX
         jJPw==
X-Gm-Message-State: APjAAAWO2CeTGw8C4BSlRzVjT3DJQtNwExpx0M5Uq1WpOsvCUVTQORv5
        FOq4QgSe1yVc6t4q8HPfsic=
X-Google-Smtp-Source: APXvYqxmpsROUGAEqYL8EDVOV7OByHymtS0Mqk4ScvgHjMvlv0A3sn919heSyv/nLXtsc2sr0jMmeg==
X-Received: by 2002:a63:e40a:: with SMTP id a10mr260601pgi.277.1561587899713;
        Wed, 26 Jun 2019 15:24:59 -0700 (PDT)
Received: from localhost ([67.136.128.119])
        by smtp.gmail.com with ESMTPSA id u128sm297015pfu.26.2019.06.26.15.24.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 15:24:59 -0700 (PDT)
Date:   Wed, 26 Jun 2019 15:24:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     syzbot <syzbot+8893700724999566d6a9@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, ast@kernel.org, cai@lca.pw,
        crecklin@redhat.com, daniel@iogearbox.net, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Message-ID: <5d13f0ba3d1aa_25912acd0de805bcce@john-XPS-13-9370.notmuch>
In-Reply-To: <20190625234808.GB116876@gmail.com>
References: <000000000000e672c6058bd7ee45@google.com>
 <0000000000007724d6058c2dfc24@google.com>
 <20190625234808.GB116876@gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Write in validate_chain
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Biggers wrote:
> Hi John,
> 
> On Tue, Jun 25, 2019 at 04:07:00PM -0700, syzbot wrote:
> > syzbot has bisected this bug to:
> > 
> > commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
> > Author: John Fastabend <john.fastabend@gmail.com>
> > Date:   Sat Jun 30 13:17:47 2018 +0000
> > 
> >     bpf: sockhash fix omitted bucket lock in sock_close
> > 
> 
> Are you working on this?  This is the 6th open syzbot report that has been
> bisected to this commit, and I suspect it's the cause of many of the other
> 30 open syzbot reports I assigned to the bpf subsystem too
> (https://lore.kernel.org/bpf/20190624050114.GA30702@sol.localdomain/).
> 
> Also, this is happening in mainline (v5.2-rc6).
> 
> - Eric

Should have a fix today. It seems syzbot has found this bug repeatedly.

.John
