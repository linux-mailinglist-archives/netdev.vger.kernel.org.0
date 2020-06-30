Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548B720EC4E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgF3EBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgF3EBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:01:35 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A45C061755;
        Mon, 29 Jun 2020 21:01:34 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id o5so19480182iow.8;
        Mon, 29 Jun 2020 21:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=aCfk5zNmIYsbAQNjjrWxmMxKJt+hXWizEFm7EszgON72WH/ZKTdBzP0JFSeLNFAjpK
         OLKdq7clw6z/gHezE5Tu2/52P1L8ZNeGHfosoBTCrrn97OvIcljesv26kvI1mK3zuYrP
         +h9Y7vIRTdj8sKb7A1nPkQAcrG6RIKxugItyClsPSDq4MsVzItIDRUG7YdGObdhgx89M
         n/ylPhgHGV+uUXXzzRghdl51+ntw7UP6yCHFPqFdZ3OvAPiGkHOZKwThJ+ymBlS3Wqvf
         ZJ4KGwnFYCgJm8F7naGipX/DNvaxIm9kCN35hiZ+F0fPqpbE9TpUYY/2DPIhpl0lCj93
         ITmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yAZduYcEKm4wiOoLB6wnk1hlMRtoPsLgtKlyIvlMUUk=;
        b=CV3oXOMEQUSlIQgqKRRQSrhG+mV1PM2FD+uh8O3/Z15kSNdz+01g8uuk2CS6593gVs
         cf4lV+ViE8+tvm9dqbFf2k97Jy6TlFCdAXPf5sg1dtrtNoRguBGtBesY5crHafqOAIm7
         vTeTABDyctcpORekcAqzmH9JAFpWqal6ydsGSHauknqaY4ISXKq7eIDEJk8xNdZxB98y
         G5r+qgyJsVcIPvZgsq8AYhPCZEQ4K2KlRo3SaIUoeV1R4UNRi/NbHEMJ+GXlMnkB6Bts
         z98aWkYMaadJpNSI5Xf9umkhVT3oXtRbpc5ji9pslOGnm2FrZS0PT0E3b3dworTOnzom
         7UsQ==
X-Gm-Message-State: AOAM5309G3qN9rITkpt8b0lUpp10o4c7gDy8OEk3eviklbF5XZgQb6Qv
        +J2yvX2cZRnBUBSByikjWxSnbAuVrcoIz82oBs0=
X-Google-Smtp-Source: ABdhPJy8WlxLuKeyK0h/suhKmQWjI43bIW8LWGDkSQyiBzmJNOiT09bCu9kNk9Cw3WH2C+SpAQF1KNbYZF2dUIqKNE4=
X-Received: by 2002:a02:1a08:: with SMTP id 8mr20492522jai.124.1593489694333;
 Mon, 29 Jun 2020 21:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c760af05a8ffc49a@google.com>
In-Reply-To: <000000000000c760af05a8ffc49a@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Jun 2020 21:01:23 -0700
Message-ID: <CAM_iQpVzsDTnShVP7AyfE7jmzJUB7-C+3Bj2b8+9zBHBrifcoA@mail.gmail.com>
Subject: Re: KASAN: vmalloc-out-of-bounds Read in tipc_nl_publ_dump
To:     syzbot <syzbot+24902249a963936dfe80@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>, jmaloy@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net,
        Ying Xue <ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: genetlink: get rid of family->attrbuf
