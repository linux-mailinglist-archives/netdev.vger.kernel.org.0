Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1031FD9F7
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 01:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgFQXy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 19:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgFQXy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 19:54:27 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFC1C06174E;
        Wed, 17 Jun 2020 16:54:26 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id z2so4105663ilq.0;
        Wed, 17 Jun 2020 16:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=EYfYK1a47R4Pt+a65ABQenYJCxUYs6FFYcHNkdZ4LHk=;
        b=gtE9RcFo2unpWpPsCO3aczMJTEQd0xC3bVuptc6CLU5YYe1rvLoGIOOpeG4ykZ/zFW
         zVE43GLeHTy1ic4Jrgykv8qwT8MxF6ivHI6y5+x2R3RU5bYn82F1r/uYFlRMX1DPxxO6
         uRJoEGAGBmOSS0o6Fo9DaV4oWBMjn+NTLYzRbcQP2folXHVE0b+seSeNlrkN+ZAzmOAV
         eDC936D/ceh8EOVMMjhzRSynO6b+oC79WgvfMry3F1ZU3MPkhqi0h3zguxqxKMnjMxnL
         jbFtcu32Laz9RLdD7UC9JgDdQX1r71EwcsJzCsvhEjhoSKKMM2SdqGO6b5ZphDPuITbg
         Tizg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=EYfYK1a47R4Pt+a65ABQenYJCxUYs6FFYcHNkdZ4LHk=;
        b=k1xnCV+1LeTRdBcdjyAfzzWWe4XatqiizSkWyXomJGipvXRtoEr0OuspUXGgDiTMzu
         s1j5FkgZVIYTeLDnCpzr3jgBDI+CLCWwFPsRLL0BK8u2HENwFvK7cXPCj4IfdtWt6hBy
         LOR5nU297rF4IbGZwu7zu1IgO1G4idCwfSlJM2fqQG0oMOT80TdP/e5VHLMMaRN1aAMI
         8essjwOJJiVjMkYgE6hYEjyzvo2TzNpH+dL4nc6suvlOmKi5Gy9PhH9t8C4jOQYlscKJ
         Mk+tz3/i4yktCal4oShKYzREpnDgz0eMvPyH1+lQNw5uUUvO5v1MFwgAlm7Ikq+RHV9r
         FzjA==
X-Gm-Message-State: AOAM533oxZH7IgAkdChM0vRX7Qwg5/VfcU74NGT1DDaDp0qt4dN2MFXw
        U2KYPWmw+rSWstiyae6/tPI=
X-Google-Smtp-Source: ABdhPJweetuxXvdTBIUKjtolvrsQzW5ANhWb3D0DeTCw+aWMNUInbDduwI0Nq8dEqfGuiDr3JSV4Xg==
X-Received: by 2002:a05:6e02:f44:: with SMTP id y4mr1506634ilj.237.1592438065965;
        Wed, 17 Jun 2020 16:54:25 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e25sm749723ios.0.2020.06.17.16.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 16:54:25 -0700 (PDT)
Date:   Wed, 17 Jun 2020 16:54:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Dmitry Yakunin <zeil@yandex-team.ru>, daniel@iogearbox.net,
        alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <5eeaad298137_38b82b28075185c423@john-XPS-13-9370.notmuch>
In-Reply-To: <20200617110217.35669-1-zeil@yandex-team.ru>
References: <20200617110217.35669-1-zeil@yandex-team.ru>
Subject: RE: [PATCH bpf-next v4 1/3] sock: move sock_valbool_flag to header
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Yakunin wrote:
> This is preparation for usage in bpf_setsockopt.
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
