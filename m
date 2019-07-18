Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DFC6D6DC
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 00:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403766AbfGRWm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 18:42:26 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33953 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbfGRWm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 18:42:26 -0400
Received: by mail-io1-f66.google.com with SMTP id k8so54490040iot.1
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 15:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RswXAC63q+ewd4F9GDtuysFlEipVwpGF+ql04sn/eqg=;
        b=kWiy22zroxmjMjHExY0b9Jz0C1a95GyF/nrqNpv1F6rKrTXnx6oRenN+yWHQ3gVUni
         G2EBwB1oB3B6DfnUYuLbsQpzcw2+TSDlNh96vFX4VNK8u/EwJfVenXGv7BeaZE5qircq
         hRWvEMsc/0RGv2AC6gcJfEjmoJ27G3aEv+XS9i04zhICrb/SaXa92givvn3Du9AWjErK
         BLk/5fOn5vupOvQ+/J3RHqMmX1UoMZeXJeTHFBbbL3cMfZiogA2G3gu57r56dHerK9qx
         gDvLN3xPGnkFS9yZqVjg2c6r8yqX6Fo4s/i5wvAmxbIEJrR4dpe7Lp9ruedYHaB/Fx6h
         2fYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RswXAC63q+ewd4F9GDtuysFlEipVwpGF+ql04sn/eqg=;
        b=EbihWwbYgmh5vbhUBDrF3dnV8a/gX/wjzasc8yxKQv4UQT4j5zg8fjQgJUfrGrviUn
         wRCJGu2zO/uNVjEY6EZUSmy52eJ6J7UMRg/4+XX5Ejj3ULI4b9ayV1ccT3VSJRojoAJs
         lXlRue9Rqgr61E5bCpoSNfHPpCwvcXpK1MzhYvgwVBNLCHnLv1cS80oMiQyYWmxd5wrB
         GxoTkuHTA2urC9zLecZ+mspSTspYLJ9Ys4kJ9Jqk+MW70+IdzBtrkuawlVOVQivukNIr
         tnSIlavfc8hMmqKNRJ/DMlJcbSRSwHnLl94G1y+0uuHnT0/DdYmd6IO4K+DlJa4ojPKP
         AnwA==
X-Gm-Message-State: APjAAAUJknZgFGB22PvOEv5Lj97T/Wrkk/rALJsUgdOYzTb03Mt2jh2A
        tezsUlnQ58UxYjicOHqHvoU=
X-Google-Smtp-Source: APXvYqwaFzCRGgMBw/8ROkqD/na0Vz9EXJJcDqYRhXLA69w2c1zL0giMMiPAOV1DN/fwKsM/L/8bag==
X-Received: by 2002:a5e:d611:: with SMTP id w17mr36187619iom.63.1563489745472;
        Thu, 18 Jul 2019 15:42:25 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:d57e:4df9:f3b0:1b7c? ([2601:282:800:fd80:d57e:4df9:f3b0:1b7c])
        by smtp.googlemail.com with ESMTPSA id y20sm22761346ion.77.2019.07.18.15.42.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 15:42:24 -0700 (PDT)
Subject: Re: [PATCH net-next iproute2 v2 0/3] net/sched: Introduce tc
 connection tracking
To:     Paul Blakey <paulb@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
References: <1562832867-32347-1-git-send-email-paulb@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4823f7c0-c6cb-6bcf-6ff5-9b57e1b744f6@gmail.com>
Date:   Thu, 18 Jul 2019 16:42:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1562832867-32347-1-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/11/19 2:14 AM, Paul Blakey wrote:
> Hi,
> 
> This patch series add connection tracking capabilities in tc.
> It does so via a new tc action, called act_ct, and new tc flower classifier matching.
> Act ct and relevant flower matches, are still under review in net-next mailing list.
> 

...

> 
> Paul Blakey (3):
>   tc: add NLA_F_NESTED flag to all actions options nested block
>   tc: Introduce tc ct action
>   tc: flower: Add matching on conntrack info
> 

applied to iproute2-next. Thanks



