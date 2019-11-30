Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70CE410DCC2
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 07:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbfK3GIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 01:08:07 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34878 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfK3GIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 01:08:07 -0500
Received: by mail-pf1-f196.google.com with SMTP id q13so15690393pff.2
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 22:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pu7mgGugDk77kg65Gvrgjv44Cixq42LYmr59MdubKI4=;
        b=sU+Mf/kIhSeoRLmPQMAkmsuqTlc2oR9TsBGS3anOVRZxSbJ0z+Hk17l0noldXOT3B9
         HktbvLVL3iAkZIG4N6QfZ8QmrOIXRVBnyL9Y6SEv5ybKmbTgVJCk8UQDn2MWfGZZNzXd
         sWyPxssbvSxQhVOi1KzMIlnjMEUehdH/kyFMUMs9thKMqRYjjBGMEM4pfXrK8/S8DUEV
         s2kWHvKoWGanFiIgl9S6AQr9GiBR/i+NSl360Ht8chaxMl+S+7rDHzSJhHx0Z3q5vKUP
         IHWtdAcve1qZl7CaGgegvAyYxdSUvSvPCmfXQjTv6U7UegBAL44GbtkM/WXipA7iDgP4
         dSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pu7mgGugDk77kg65Gvrgjv44Cixq42LYmr59MdubKI4=;
        b=pAt7YZDlYlXSi/dQzRo0yYvy//5q+g1vxiP3GUPdQhJnddfmVfoQN2opJ6Vi0SIWdn
         b5m51T9WgrqUEwH02LySLBUflJK4HWLaLcYmrGTjufNk3mUy7ogI9gC6R8/CBLpJuS/y
         qyFJvrNVWytGh9pPXBwCrxAEGbRA3Juo7nTNgrkeua9xpXDcKNOPnx5r5TQFwy196RAK
         JHFx3aVbU4fHNEbYBD0ccfgmqpvSEKWjP9DRzYy9JL7nZiF93NsFgNEChdnr/sEuWXXb
         asdb9oMgAubFhn0Bo9ek1dAvVzxo/uuUr5bsIrxGu5MGShF3ULGgKbtO17tApI3iXLJ5
         yLrA==
X-Gm-Message-State: APjAAAXiXNEkGRIexmi0BZYwDrPgl8878+HRV/LLdx7tbZ0MvOs9Q4qV
        yxDzD6zcUgARMYsCTNGc+YRgEfWsC4SDCmDtcg2jOsfBIp8=
X-Google-Smtp-Source: APXvYqyWs6Md31ROUqiXfOWjb7MY2RDGNuoAkWgqYpYAVzFRxVpTpIgZZ4MV3OvwZfWuMNe1XbWSn1qN99UqfGosvs4=
X-Received: by 2002:aa7:96ef:: with SMTP id i15mr59429567pfq.242.1575094085469;
 Fri, 29 Nov 2019 22:08:05 -0800 (PST)
MIME-Version: 1.0
References: <1574848877-7531-1-git-send-email-martinvarghesenokia@gmail.com> <20191127.112401.1924842050321978996.davem@davemloft.net>
In-Reply-To: <20191127.112401.1924842050321978996.davem@davemloft.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 Nov 2019 22:07:53 -0800
Message-ID: <CAM_iQpWu9DQ06FYo7xtuLFnHP-wx35Uva_0-im7XwemKtLno0A@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] Enhanced skb_mpls_pop to update ethertype of
 the packet in all the cases when an ethernet header is present is the packet.
To:     David Miller <davem@davemloft.net>
Cc:     martinvarghesenokia@gmail.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        pravin shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 11:24 AM David Miller <davem@davemloft.net> wrote:
>
>
> net-next is closed, please resubmit this when net-next opens back up.
>

I think this patch is intended for -net as it fixes a bug in OVS?

Martin, if it is the case, please resend with targeting to -net instead.
Also, please make the $subject shorter.

Thanks.
