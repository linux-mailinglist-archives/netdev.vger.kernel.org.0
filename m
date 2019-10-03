Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155A0CB0D2
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbfJCVIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:08:45 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40978 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfJCVIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:08:45 -0400
Received: by mail-io1-f68.google.com with SMTP id n26so8827323ioj.8;
        Thu, 03 Oct 2019 14:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=hBpK7xDzlnL8ljzox/cnUXn1+XMnoCD9cuKEJvoy/bQ=;
        b=abQckxYajH8Ep6BsTg5flUXpmTGWgQpUt1mvGnnXhvciAyQDlGUSyq6VFHTpJrdB/b
         twWMgl7gPsL28dz/gvl8rE7DVmNVR2uqqGzizy6NLccjgc11J3Q73WjudbfMVgjBzhlR
         9ZKsdOFoXdXUpjwn1+NNhiwi4rcFZZAJ+ru6IkecY3hQ4SmoxRo/WBCfN5hS6nN8VWF1
         hTgbOMswYrEiAuYX/TYPLwbCYGhAKgHGtBXK2fh3c1v4JfW5Ord6bPdnJ3R2FUDeRKv+
         81xME6wP7sqh9dBweh0IlsnIQ07qFR+x8ZfAqJyfSkCh/pwbacaLq9LMaOFCfdXZL529
         xVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=hBpK7xDzlnL8ljzox/cnUXn1+XMnoCD9cuKEJvoy/bQ=;
        b=ownq6ZS178wFmBbVuvQYHt+3lM4k8QMfaByKnIvy/3tvm6+DHkdoqIibxD1GgDa6uh
         FTzjTNBYEhf7D4S/MVmRiZELPexnPrcHAyvgi+wvXysXKuedjbbT8XoBkXpPRgBaCDj9
         yXpJ7AvVH8+9j+EP0JKmzZw/Np1iBjS8HNC1hiloolNQczalSJOLAWdsBG1zb5knaLwO
         7ujUVJEKGM0qbkdLQ2G/Ypk1QFrYd1Pdy5MIf5j9RvC0IRNBjQRQ2OglcXFoeQ1WPa13
         yzLgVs7rX64b+One0ssLqxEkbR0w7IXGzjo9B/thFZcyzD6isoaqOkxQg4Ija4qiCgD2
         KzdQ==
X-Gm-Message-State: APjAAAWR3y9iWw4N/kKKnltbX0Ou5/89w5C8LaqENJkc0GJx5bBen2Yv
        dSZFT75vgjbu/Q1olyj/Mew=
X-Google-Smtp-Source: APXvYqyeLamt4Vrvvg3V9M8HIDonzdOp9yzO11yxhdfUc4UIUBYQHme8WoxyNruVBN/2w6nPY5vgCA==
X-Received: by 2002:a92:d806:: with SMTP id y6mr974169ilm.22.1570136923989;
        Thu, 03 Oct 2019 14:08:43 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d197sm1389346iog.15.2019.10.03.14.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 14:08:43 -0700 (PDT)
Date:   Thu, 03 Oct 2019 14:08:36 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Song Liu <liu.song.a23@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Message-ID: <5d9663547acce_59e82ace6a9345b4a3@john-XPS-13-9370.notmuch>
In-Reply-To: <CAPhsuW6==Ukxjh69SVLusC=GMf=65Y2T0gLNig55obwbS-7VqQ@mail.gmail.com>
References: <20191002234512.25902-1-daniel@iogearbox.net>
 <CAPhsuW6==Ukxjh69SVLusC=GMf=65Y2T0gLNig55obwbS-7VqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, x86: Small optimization in comparing
 against imm0
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Liu wrote:
> On Wed, Oct 2, 2019 at 5:30 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > Replace 'cmp reg, 0' with 'test reg, reg' for comparisons against
> > zero. Saves 1 byte of instruction encoding per occurrence. The flag
> > results of test 'reg, reg' are identical to 'cmp reg, 0' in all
> > cases except for AF which we don't use/care about. In terms of
> > macro-fusibility in combination with a subsequent conditional jump
> > instruction, both have the same properties for the jumps used in
> > the JIT translation. For example, same JITed Cilium program can
> > shrink a bit from e.g. 12,455 to 12,317 bytes as tests with 0 are
> > used quite frequently.
> >
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> 
> Acked-by: Song Liu <songliubraving@fb.com>

Bonus points for causing me to spend the morning remembering the
differences between cmd, and, or, and test.

Also wonder if at some point we should clean up the jit a bit and
add some defines/helpers for all the open coded opcodes and such.

Acked-by: John Fastabend <john.fastabend@gmail.com>
