Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1FB102671
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 15:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfKSOSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 09:18:37 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37899 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbfKSOSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 09:18:37 -0500
Received: by mail-oi1-f193.google.com with SMTP id a14so19033365oid.5
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 06:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P2626os02OFwDmxJnp/pJO/gCGVJgfdyCkL3h6Y9T4o=;
        b=A4a59vyurntffnVVtEkHk2XQ2L/yh5u9ewwM5Ao5hIYvvY68KsqhFjqvyR55bHUlwv
         J0supu2hhf/g3SXVdukxmLBfGrc/pLdtwP5wBN15eBq7gE2kTEl5p7X/+0ntwg7eX73F
         lZNgW1JJW6Vg9OuqoR22o+YBtTmzS1WmWVV0XbIX5Sxs54Nw7rozeN3U3OBqLBrZy3wW
         1rKbKyEpY5QFIsQ006Y/D3b9DIt2h9UixLEUFec7T3K3CXK3IpMt+31YDlM278DXYEsJ
         QwXwCZCHu37S3PQSGTG723oDtAHN288vFlRAe4aJD/1/11XUD7hcLR8c6S50qqXnoS8T
         gPVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P2626os02OFwDmxJnp/pJO/gCGVJgfdyCkL3h6Y9T4o=;
        b=goqCrWapS7M0VoeyOGvNCYHMfE4IbdZFqxiDbNiXBVr+R00HNdJKrqsIBFQkvitwmg
         vQRo16UEnWQclwG7w7S07dZk7/8jJmRV3OZQDQ0T9aFhYjYCTTP0OyVWhC/hqetBbyVD
         t99JKA7HJFXQv8b03JgfYRFC8+A3iJukBBFZIZrJtE5LfLNqB7WlAGz8Rt+mhxc6RBsG
         ktLalmc0M4VlIfaTLAT71kcC4i3AERX81nDFdMCs4hhRgVnqY0U2Dsx1lhMoMaAlpYjF
         9//xVy2IeXSt1/qJEpWgQNX9RqImP6mDxPfgi4WrBciao+gpYEe8e5duLqiEx5y16DL+
         e22Q==
X-Gm-Message-State: APjAAAVtzKu6tD8CqGIFh5C6RFYpBjuICw9NLBw2oTzAxUiR2eUyFdBb
        qTnxvpgPVtoSVc3YqVYrWsQCnjpOPbtuN/369ICkwA==
X-Google-Smtp-Source: APXvYqyhKOic94N6WrmYNEi0VgoGvOmXlw2gXMofETqQid3W5b9e6A3mY/iLcY5FSTRW63KVRFb+uHzZna8rwsVXEV8=
X-Received: by 2002:aca:c396:: with SMTP id t144mr4122228oif.171.1574173115987;
 Tue, 19 Nov 2019 06:18:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574155869.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1574155869.git.lucien.xin@gmail.com>
From:   Roman Mashak <mrv@mojatatu.com>
Date:   Tue, 19 Nov 2019 09:18:24 -0500
Message-ID: <CAHvchGmygFXEiw6k7FTzN16YBJu6WtCm_tE7zQAbUaHE5N+KQw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: sched: support vxlan and erspan options
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 4:32 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> This patchset is to add vxlan and erspan options support in
> cls_flower and act_tunnel_key. The form is pretty much like
> geneve_opts in:
>
>   https://patchwork.ozlabs.org/patch/935272/
>   https://patchwork.ozlabs.org/patch/954564/
>
> but only one option is allowed for vxlan and erspan.

[...]

Are you considering to add tdc tests for the new features in separate patch?
