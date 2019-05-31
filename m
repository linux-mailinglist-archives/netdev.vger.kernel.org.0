Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C22831370
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfEaRHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:07:08 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52287 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaRHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:07:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id y3so6478726wmm.2
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GfXn8X8Ct8unv5GGp5SMGW0fg12aNA3dWh90BHSPlq8=;
        b=R7UsqMlfeH7yjPbe9P6ulligXL4fZZXxTbDWpj3C+34YKCbRJ0x7q+NCCys2wlDqFe
         5ZN5PyLjVglYkIGzv2VGS5J4++MicnsRRioYo9fCQoHQpz3bmA7qzPn4gJm887L9MP1i
         xaoUOafj39qWAjcXZXbdPgKTFngO4l24ulxdigsoJ5xcFU5N7hpxIiNuLoq/3FjhHmiY
         9AN42dL0vrrMkl5mQywFdKH0rU7mjSpm3lFgjHi19B52C8ksWxI4W9K0chKdtAnrlVlC
         ZK/uO/ouFYKg8YjfxorB/cOoj+soThuej9whTTtr91xMNsAEleoMihqw6pGage845hll
         pssA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GfXn8X8Ct8unv5GGp5SMGW0fg12aNA3dWh90BHSPlq8=;
        b=JyPMAa2Wuzfh5O3sC8Z81IQ4RrPsjVkdnF8Ex55EP3/uh2moky3n+5+FIPBoSabP3G
         QRWsCpRJ24HBe/yKzbGn/Pz62w4T4UQM9mHvIDZ+t990d0lHT0Vh0LbVZsFp06VvXu+w
         lnJ//TuJcmFo9qHfZLdggPrjQ/MVL++DGbsl3SCEcb07H6HYI6yvkhhqqAEHtJOUml5X
         kLVA2vX8fEGS+M+3Th8u2Ql3tKq1ISs6KgVEgmnjBvYhZzl5HGo8jDEAVnbiE7qg6HpI
         tcReBkCJr0pWNruZIU1c5/U+Od5YluxARYVLiiZsHsEt8TrUQi9wmOjKAXxXu5SaBJyc
         R7gA==
X-Gm-Message-State: APjAAAU7H6LEqlHM1w51MYY+1nordhd2KjxGFl7Vnx79RuZQxhZEF03Z
        3Y+7mw7N9HDTxEHpKIeytVbmef61
X-Google-Smtp-Source: APXvYqx/1hnIP8f+eJAIz1dCo7WQJVNpbX6QYRNwcDc4uStHQ9+PkrH7Su1ok1bnAcbFJqKkweJ5xw==
X-Received: by 2002:a1c:f61a:: with SMTP id w26mr6394216wmc.47.1559322425664;
        Fri, 31 May 2019 10:07:05 -0700 (PDT)
Received: from AHABDELS-M-J3JG ([192.135.27.139])
        by smtp.gmail.com with ESMTPSA id x187sm6565032wmg.11.2019.05.31.10.07.04
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 31 May 2019 10:07:05 -0700 (PDT)
Date:   Fri, 31 May 2019 19:07:04 +0200
From:   Ahmed Abdelsalam <ahabdels.dev@gmail.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com,
        Tom Herbert <tom@quantonium.net>
Subject: Re: [RFC PATCH 6/6] seg6: Add support to rearrange SRH for AH ICV
 calculation
Message-Id: <20190531190704.07285053cb9a1d193f7b061d@gmail.com>
In-Reply-To: <1559321320-9444-7-git-send-email-tom@quantonium.net>
References: <1559321320-9444-1-git-send-email-tom@quantonium.net>
        <1559321320-9444-7-git-send-email-tom@quantonium.net>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 09:48:40 -0700
Tom Herbert <tom@herbertland.com> wrote:

> Mutable fields related to segment routing are: destination address,
> segments left, and modifiable TLVs (those whose high order bit is set).
> 
> Add support to rearrange a segment routing (type 4) routing header to
> handle these mutability requirements. This is described in
> draft-herbert-ipv6-srh-ah-00.

Hi Tom, 
Assuming that IETF process needs to be fixed, then, IMO, should not be on the cost of breaking the kernel process here. 
Let us add to the kernel things that have been reviewed and reached some consensus.
For new features that still need to be reviewed we can have them outside the kernel tree for community to use. 
This way the community does not get blocked by IETF process but also keep the kernel tree stable.
Thanks,
Ahmed

-- 
Ahmed Abdelsalam <ahabdels.dev@gmail.com>
