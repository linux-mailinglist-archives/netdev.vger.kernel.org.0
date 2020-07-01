Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A79021102D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732296AbgGAQF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGAQF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:05:56 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEF6C08C5C1;
        Wed,  1 Jul 2020 09:05:55 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id q3so10797905ilt.8;
        Wed, 01 Jul 2020 09:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P6Jzhi8PQ7Yh19edg9xNloDUsoGpRoDY3eC/QwCEbjk=;
        b=UTv+1FlJUGGQF132XOivjrqZzc3NGyMyUIi6+hTuX6aT3f4NgIYkioz+N+w4AbdoDk
         v29aKjisYx17Z05IiybXRhXX8DUHiOq10D/3xEXnm4YJ9pf00+LAF1/fqUm5007cDAKr
         nBp3/BUXl7vC8gXVvjqbDaSb3dXYfO1j6b0/k6w/TcOeWQM3Iq6YnFKD3KTioLblIVIg
         gCAmv9BikJ86B5gHXtu+AdiBnbTiMizUoF9nmkWB4lIJYV02K+1LNtsXrABf/CVfh0r6
         LI5w2xLbR9OZP99vTQFZAn6+aNqlNGrzAWOOVYBwzeFbsmZzPirKApxKPYGlLA4uI/qv
         UJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P6Jzhi8PQ7Yh19edg9xNloDUsoGpRoDY3eC/QwCEbjk=;
        b=LU4IVEDyivWh8r1Cd+igQPgL1ill4g7WzY9hSvcUBkkh+//pFBCLbhPZt/1klGzf9X
         HDT69IkDDm2hjGLfpcqZlZnGnqDPhvkcMXV3cR5uwSMVMuU2BjD8BafbaJwoToZRXQV0
         IzIMwZVn2zk24WCKIbwhGd6cVW694VZlhpzMmuu9D9kJwtXamA/e79c4WhAOjF5hhdHy
         TPqmWnpHEQIhJ2ZpOvekalcTbMypThRm0iRHilrLW16gSmTcoN3peA4Z6BJiMcZOg+AA
         y/ZkHwmUJaB0rW8f5fBgZiM311dHRbHLX2AWQg2WPPyuC35PeVyKk/jOu3L9KReB8R4j
         3Lhw==
X-Gm-Message-State: AOAM530lcoE/S5OYdg15Mmdt+VxYZYa+y7xi3mpI7rvLD3LxcEaQZmV8
        9FC+lbNHd7vzQ4tsalpw7SDk0wxFtP402NWzV6E=
X-Google-Smtp-Source: ABdhPJwBHxtkEsS3T6qBCnTiacFDtYyWIObQUKy5IgofmsXn63hMieFrwhqwuKRnLbN2EJ8ytzScyIBe9dCLrPBmcn8=
X-Received: by 2002:a92:5857:: with SMTP id m84mr8477108ilb.144.1593619555213;
 Wed, 01 Jul 2020 09:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
In-Reply-To: <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 1 Jul 2020 09:05:43 -0700
Message-ID: <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Josh Hunt <johunt@akamai.com>
Cc:     jonas.bonn@netrounds.com, Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 2:08 PM Josh Hunt <johunt@akamai.com> wrote:
> Do either of you know if there's been any development on a fix for this
> issue? If not we can propose something.

If you have a reproducer, I can look into this.

Thanks.
