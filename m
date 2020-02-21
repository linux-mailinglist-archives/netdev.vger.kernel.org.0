Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6821166E1E
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 04:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgBUDwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 22:52:42 -0500
Received: from mail-pg1-f179.google.com ([209.85.215.179]:38876 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729546AbgBUDwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 22:52:42 -0500
Received: by mail-pg1-f179.google.com with SMTP id d6so304828pgn.5;
        Thu, 20 Feb 2020 19:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=GX1wC2g1eEjx7PtRucEigGTf3nADVZwrjz6hwbK+jJ4=;
        b=gz6PVvQymfL3eDAIC6krLpmpKX5w92h1T0MDEDTpRN3bzCDE9UOYYwo7UgR9DNnVnn
         P5pIGDO0Q/2/8uI0UmAL2JV9K1K+L0plDUYx4WhZPnzvOs2dhvOP+hMt9PTm1WfYW5yo
         lbGmKe+tn286CNBz22clBdNu1E0nukdjHvr3qXpNf7Wv8lqAFbYHajknRixAzXxYApdP
         3Mr+5YPJsxKQ4mas8L/TkD+chatOny6EidTSChyFfB8E+t6gYRAHgx5+tMbrBmYzJ3JM
         V9yxSomkVSQ5fZpCGt2wBx0MB8S3AmrgqBtomjs6OzNHxlyUJq1lmTgmHOCSGkqECcnN
         fJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=GX1wC2g1eEjx7PtRucEigGTf3nADVZwrjz6hwbK+jJ4=;
        b=PeD2ZgurhL09s2UeXJlY6jPkWvI778uuXTTZC2YK8jOubOU8yxX+shoMaTwBdZD82i
         320lPCRuLFwlrBT8Tk3klgwSJQOQ6sEUGE3e92RYp34p8hrzLYT6vxwmLSo/CTmOxoUQ
         Mc5drrGzCUX/E/aTE3YO9MOn3tM+th3+lPKWb6LK06QxQWsAZWNy9/DqSxreCY7YM/UJ
         OC/Xlz+ROTjjCAdXYx8m+2ZdL4PZzwAfDKhCC+ybBP1f9LkOVRTmraN96QynvP+o/dbI
         PM3e7X86WA7g7OmAzBlbBo+3A2ETdjC12mSBLRB7ZKiI0Cp5J+GFChSWcjSgqTKMH9TS
         u/lw==
X-Gm-Message-State: APjAAAUNbI/R1SzskJhimLU8V5adAV9xKGDrpwnuY+Bj3EuD5FSsIxzd
        ziZtMpMSs7L8TsX6PENesrfqLq4H
X-Google-Smtp-Source: APXvYqyvp+OF5zp3OWDdtP0ZenRonKfc+klUzcmFB2eoigplhW1S4bjZkju8wTBBdRNTvIKIIk7Bxg==
X-Received: by 2002:a63:1510:: with SMTP id v16mr34911012pgl.155.1582257161730;
        Thu, 20 Feb 2020 19:52:41 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f8sm810110pjg.28.2020.02.20.19.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 19:52:41 -0800 (PST)
Date:   Thu, 20 Feb 2020 19:52:33 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Message-ID: <5e4f5401360ab_18d22b0a1febc5b824@john-XPS-13-9370.notmuch>
In-Reply-To: <20200218171023.844439-11-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
 <20200218171023.844439-11-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v7 10/11] selftests/bpf: Extend SK_REUSEPORT
 tests to cover SOCKMAP/SOCKHASH
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Parametrize the SK_REUSEPORT tests so that the map type for storing sockets
> is not hard-coded in the test setup routine.
> 
> This, together with careful state cleaning after the tests, lets us run the
> test cases for REUSEPORT_ARRAY, SOCKMAP, and SOCKHASH to have test coverage
> for all supported map types. The last two support only TCP sockets at the
> moment.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
