Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC17132D1A
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgAGRdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:33:43 -0500
Received: from mail-il1-f178.google.com ([209.85.166.178]:44736 "EHLO
        mail-il1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbgAGRdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:33:41 -0500
Received: by mail-il1-f178.google.com with SMTP id z12so239628iln.11;
        Tue, 07 Jan 2020 09:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=p0QP3Y2t/mcLYot7olsyGCxLNRAkxQvzwJoQhN15wqY=;
        b=K3kTS2Ble/HlLhcisyOS++vPmIzkZ2V2IvfCttoA6o9uF8EEmSjDzaXVvWOx4unR/f
         14E6rcQkL/C+lhavpY3MY8T9PtnIr4fEyuU09w/+rtPFlIzDF+VCmqqUtjl7lCdzXIG/
         UkMi3ZZhPHQ2xCtBSTNwy+0J6FGqxBwHitGQ17b5c9nGyrEmnMbGorBcwg+F7VDUa0cG
         xcZivvPaD+DnBrbHDdPrG8rjEXvUNPW4H7YsyvqpaUKdD/oI4c69XlqO/6ObD6AxlBsR
         h4mdf5Ls/KAiMIhSOga/4fWP8gk3nBph4YcOsdjmv9ZgH1WKz1gfoR/U5O/ArT6lSyff
         KobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=p0QP3Y2t/mcLYot7olsyGCxLNRAkxQvzwJoQhN15wqY=;
        b=ptPre8sWqrBzLA1AlneONYOJQBvmmiHOSs0V4gkIYJCoj9j4X9TquLZVdhY9BfcWEL
         z+dLSUBqPKhp7RXVlFRFb9ZtSAllLbDRS0b0cH+YKXRPPaSMWuIdzTU8E035Tl306pa1
         YeNNy8JRsZcXPK3X6CrWqaPSZyiApRzpEO1iuNbQaoQCvHx0D8BDgo5qJbpnfR7P/AXb
         Mu5kxX/5aAWUTclRzf2l511cb/KICnu/WUeGqTNhgGy0jyUFNNsSRgrmpzU/nvqIU+p7
         uRDYCIAZAy/vRtzRA7dgLJROdp4GwUMSdFGQvisNu5WKKuI55iebmPttvqvNBf0BjHan
         KAsw==
X-Gm-Message-State: APjAAAUASVVuO0NntJYEpqznfOxNbM1NoC/inAyb0vcGQN6KwzAzgXp4
        RCADzhgnQ823vQ/BTngw3bg=
X-Google-Smtp-Source: APXvYqzoCn/IQT1wBZMyI10bqClR9l3pRwUAD1045Ht42p48GVdy9vcVO9CdZxGB2oHiy+KdI/WRwQ==
X-Received: by 2002:a92:8458:: with SMTP id l85mr193602ild.296.1578418420915;
        Tue, 07 Jan 2020 09:33:40 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s8sm31588iom.46.2020.01.07.09.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:33:40 -0800 (PST)
Date:   Tue, 07 Jan 2020 09:33:32 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Message-ID: <5e14c0ecc158_67962afd051fc5c04b@john-XPS-13-9370.notmuch>
In-Reply-To: <20191219061006.21980-4-bjorn.topel@gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
 <20191219061006.21980-4-bjorn.topel@gmail.com>
Subject: RE: [PATCH bpf-next v2 3/8] xdp: fix graze->grace type-o in cpumap
 comments
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> =

> Simple spelling fix.
> =

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
