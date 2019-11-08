Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 226D6F5B90
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKHXCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:02:38 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38318 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKHXCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:02:37 -0500
Received: by mail-pf1-f193.google.com with SMTP id c13so5810652pfp.5;
        Fri, 08 Nov 2019 15:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=LXjK0596Y0Ovre0/EOPzNHI04qmg1FdAVW0yeaZID+g=;
        b=HdZ45FPKlGf7BQnaGGbeijuqwVSYgAYGYgky1iuSB+Jz86ZM4Vs2u730YO5/xJS/xe
         YZ2TUOekDNM1bia37wOmNS84lWSQQzAysPge/FI33w78DhIMjIAWGerSnRTorHS32D6O
         juRSvCoZay0omIWFRDKSkK1u6HDbUnj0zmuFLomAtNpcMKU74mp3/DMNH/JdQ08uvNEC
         lorv+AhxZEd9vtinikp2Anjj9yQ87whXdmaW3WXraoCZ215MX4a0EfRIioL1+ShQ5uxv
         v6x9uQgC/znraOjhX8gfRJL6KU+HN5WL9wXYM9FxppsvcbWbv4XhUPIY3bGIEGLCmnHc
         FdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=LXjK0596Y0Ovre0/EOPzNHI04qmg1FdAVW0yeaZID+g=;
        b=hlLzMmq5jXt/phXeaZ4HIv48TFYQCOd6LAnuK2kAUDSJUMg8+JY7FDrzgVlbHjC7cn
         IHw3oIL7Jmxop+TjSAewm7lTE59Lxfrh/A1YFQKtfm89lKiZJct6RzKBB4IvLzDNaDxE
         3YZ60eAc9sZGm4k30/1a0msKEh2mbDF28XSM5ZkkJMPjCuxb3TjuzIZvIrML7tEzUSet
         y/dDYcZZOiTQyZvEVvhcgnMzogjc/vEIkXlY+FCTdfthjrzY0TWWy0ntj5CC4ijdHjqD
         +tIEG9wSGGaKioOt+eeu6HE4kjn+Suv2hgOMJ7oZw/yp0CleybNwQqC4BiUXcIPqhqkJ
         h/Fw==
X-Gm-Message-State: APjAAAV33USUbgjmdG9ZqoTZUptku8vp3a+eUgChkJcu+L/8OblfoIvW
        t+1jCkwY9cmKo48R1C73ams=
X-Google-Smtp-Source: APXvYqwPwrLgKCwEK5j0FdLLwvDp/XOfoJjqYA937Lpy1ucksSHoh/fYusALUJ/aYkGs7La+jvhjjA==
X-Received: by 2002:a62:4ec4:: with SMTP id c187mr15243659pfb.113.1573254157283;
        Fri, 08 Nov 2019 15:02:37 -0800 (PST)
Received: from [172.20.40.253] ([2620:10d:c090:200::3:c214])
        by smtp.gmail.com with ESMTPSA id x192sm7155598pfc.109.2019.11.08.15.02.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 15:02:36 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, u9012063@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 4/5] samples/bpf: use Rx-only and Tx-only sockets
 in xdpsock
Date:   Fri, 08 Nov 2019 15:02:36 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <FC0465CF-6F62-4FEF-88CF-B5496E9E4881@gmail.com>
In-Reply-To: <1573148860-30254-5-git-send-email-magnus.karlsson@intel.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-5-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7 Nov 2019, at 9:47, Magnus Karlsson wrote:

> Use Rx-only sockets for the rxdrop sample and Tx-only sockets for the
> txpush sample in the xdpsock application. This so that we exercise and
> show case these socket types too.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
